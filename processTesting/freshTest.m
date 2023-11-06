%FM
%What's going on, vegv,pbmkfgbmklfb m sbklgmvkb kgmbkmgf

stationTidalAnalysis

%Loads in and analyzes the windspeeds and directions
stationWindsAnalysis


% fullTime = [datetime(2020,01,29,17,00,00),datetime(2020,12,10,13,00,00)];
% fullTime.TimeZone = 'UTC';
%Creates diurnal data
figure()
SunriseSunsetUTC

%Day timing
sunRun = [sunrise; sunset];



%Load in the detection files
cd ([oneDrive,'Moored\GRNMS\VRLs'])
rawDetFile{1,1} = readtable('VR2Tx_483064_20211025_1.csv'); %SURTASS05IN, A
rawDetFile{2,1} = readtable('VR2Tx_483074_20211025_1.csv'); %STSNEW2, B
rawDetFile{3,1} = readtable('VR2Tx_483075_20211025_1.csv'); %FS6, C
rawDetFile{4,1} = readtable('VR2Tx_483081_20211005_1.csv'); %39IN, D


%%FM 5/24: trying bulk strat using bottom receiver + buoy info
cd ([oneDrive,'Moored'])
% Separate dets, temps, and noise by which receiver is giving the data
data = readtable('VUE_Export.csv');

%These transceivers are used for this research
WonderfulReceivers = ['VR2Tx-483064';'VR2Tx-483074';'VR2Tx-483075';'VR2Tx-483081'];
data(~ismember(data.Receiver,WonderfulReceivers),:)=[];

%%
% Bringing in receiver data

dataDN = datenum(data.DateAndTime_UTC_);
dataDT = datetime(dataDN,'convertFrom','datenum');

%FM 3/6/23 Ordered the transceivers and doubled some up; this is to match
%the transceiver order listed in "matchAngles"/"thetaFinder"
uniqueReceivers = [{'VR2Tx-483064';     % 'VR2Tx-483064' SURTASS_05IN
                    'VR2Tx-483074';     % 'VR2Tx-483074' STSNew2
                    'VR2Tx-483075';     % 'VR2Tx-483075' FS6
                    'VR2Tx-483081'}]    % 'VR2Tx-483081' 39IN

%%
% uniqueReceivers = unique(data.Receiver);
for PT = 1:length(uniqueReceivers)
%     clearvars tempIndex detectionIndex noiseIndex pingIndex tiltIndex
    tempIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Temperature');
    detectionIndex{PT,1} = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Detections on 69 kHz');
    noiseIndex{PT,1}     = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Average noise');
    pingIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Pings on 69 kHz');
    tiltIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Tilt angle');
    
    receiverData{PT}.identity        = uniqueReceivers{PT}
    receiverData{PT}.bottomTemp(:,1) = dataDN(tempIndex{PT}); receiverData{PT}.bottomTemp(:,2) = data.Data(tempIndex{PT});
    receiverData{PT}.hourlyDets(:,1) = dataDN(detectionIndex{PT}); receiverData{PT}.hourlyDets(:,2) = data.Data(detectionIndex{PT});
    receiverData{PT}.avgNoise(:,1)   = dataDN(noiseIndex{PT}); receiverData{PT}.avgNoise(:,2) = data.Data(noiseIndex{PT});
    receiverData{PT}.pings(:,1)      = dataDN(pingIndex{PT});  receiverData{PT}.pings(:,2)    = data.Data(pingIndex{PT});
    receiverData{PT}.tilt(:,1)       = dataDN(tiltIndex{PT}); receiverData{PT}.tilt(:,2)          = data.Data(tiltIndex{PT});
    receiverTimes{PT}                = datetime(receiverData{PT}.hourlyDets(:,1),'ConvertFrom','datenum','TimeZone','UTC');
end
clear detectionIndex  PT noiseIndex pingIndex detectionIndex tempIndex tiltIndex WonderfulReceivers data dataDN 

for PT = 1:length(uniqueReceivers)
    usedPings = receiverData{PT}.hourlyDets(:,2)*8;
    ratio     = usedPings./receiverData{PT}.pings(:,2);
    receiverData{PT}.ratio(:,1) = receiverData{PT}.hourlyDets(:,1); 
    receiverData{PT}.ratio(:,2) = ratio;
end




%Timetable of transceiver data
for PT = 1:length(uniqueReceivers)
    startTime = [datetime(receiverData{1,PT}.bottomTemp(1,1),'ConvertFrom','datenum','TimeZone','UTC'); datetime(receiverData{1,PT}.bottomTemp(end,1),'ConvertFrom','datenum','TimeZone','UTC')];
    bottomTime{PT} = datetime(receiverData{PT}.bottomTemp(:,1),'ConvertFrom','datenum','TimeZone','UTC');
    botIndex       = isbetween(bottomTime{PT},startTime(1,1),startTime(2,1));
    bottom{PT} = timetable(bottomTime{PT}(botIndex),receiverData{PT}.bottomTemp(botIndex,2),receiverData{PT}.hourlyDets(botIndex,2),receiverData{PT}.tilt(botIndex,2),receiverData{PT}.avgNoise(botIndex,2),receiverData{PT}.pings(botIndex,2),receiverData{PT}.hourlyDets(botIndex,2));
    bottom{PT}.Properties.VariableNames = {'botTemp','Detections','Tilt','Noise','Pings','TotalDets'};
    bottom{PT}.Tilt(bottom{PT}.Tilt>70) = 0;
end

for PT = 1:length(bottom)
    startTime = [datetime(2020,01,29,17,00,00,'TimeZone','UTC'); datetime(2020,12,10,13,00,00,'TimeZone','UTC')];
    stratIndex1 = isbetween(seas.time,startTime(1,1),startTime(2,1));
    stratIndex2 = isbetween(bottomTime{1,PT},startTime(1,1),startTime(2,1));
%     if PT == 9 | 10
%         continue
%     end
    stratification{PT} = seas.SST(stratIndex1)-bottom{1,PT}.botTemp(stratIndex2);
    nullindex = stratification{1,PT} < .000001;
    stratification{PT}(nullindex) = 0;
end 



for COUNT = 1:length(bottom)
    stratIndex = isbetween(bottom{COUNT}.Time,startTime(1,1),startTime(2,1),'closed');
    bottomStats{COUNT} = bottom{COUNT}(stratIndex,:);
%     fixInd = isnan(buoyStats{COUNT}.botTemp)
%     buoyStratification{COUNT}(fixInd) = 0;
%     fullStratData{COUNT} = buoyStats{COUNT}(stratIndex);
end


%Binary data: night or day
xx = length(sunRun);
sunlight = zeros(1,height(time));
for k = 1:xx
    currentSun = sunRun(:,k);
    currentHours = isbetween(time,currentSun(1,1),currentSun(2,1)); %FM 7/1
    currentDays = find(currentHours);
    sunlight(currentDays) = 1;
end

% winter  = [1:751,6632:7581];
% % Spring:           Mar-May
% spring   = 752:2959;
% % Summer:           June, July
% summer   = 2960:4423;
% % Fall:             August
% fall     = 4424:5167;
% % Mariner's Fall:   Sep-Oct
% Mfall    =5168:6631;

% seasonCounter = zeros(1,length(time));
% seasonCounter(winter) = 1; seasonCounter(spring) = 2; seasonCounter(summer) = 3; seasonCounter(fall) = 4; seasonCounter(Mfall) = 5;



load mooredGPS

% %Creates distance variable between transceivers
% distances(:,1) = repelem(lldistkm(mooredGPS(14,:),mooredGPS(12,:)),length(uniqueReceivers));


%Angles between transceivers
% for K = 1:10
%     arrayPairing(:,K) = repelem(K,length(time))
%     transAngle(:,K)   = repelem(AnglesD(:,K),length(time))
% end

%Okay, basics are set.
close all


%%
%Frank created receiverData{X}.ratio, now how can I show committee what I'm
%talking about?

figure()
hold on
% yyaxis left
plot(receiverTimes{1},receiverData{1}.ratio(:,2),'LineWidth',2);
ylabel('Ratio')
ylim([0.5 1])
yyaxis right
plot(receiverTimes{1},receiverData{1}.avgNoise(:,2),'LineWidth',2);
ylabel('Noise (mV)')
ylim([400 800])
title('Comparing Efficiency to Noise','Ratio = Used pings (dets*8)/Total Collected Pings')


figure()
hold on
yyaxis left
plot(receiverTimes{2},receiverData{2}.hourlyDets(:,2),'LineWidth',2);
ylabel('Hourly Dets')
ylim([6 15])
yyaxis right
plot(receiverTimes{2},receiverData{2}.avgNoise(:,2),'LineWidth',2);
ylabel('Noise (mV)')
ylim([400 800])
title('Comparing Efficiency to Noise','')




for COUNT = 1:length(receiverData)
    for season = 1:length(seasons)
        seasonBin{COUNT}{season} = fullData{COUNT}.season ==season;
        seasonScenario{COUNT}{season}= fullData{COUNT}(seasonBin{COUNT}{season},:);
        averageDets{COUNT}(season) = mean(seasonScenario{COUNT}{season}.detections);
        noiseCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.noise);
        wavesCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.waveHeight);
        tiltCompareWind{COUNT}(season) = mean(seasonScenario{COUNT}{season}.tilt);
        stratCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.stratification);
        pingCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.pings);
        totalDets{COUNT}(season)   = mean(seasonScenario{COUNT}{season}.TotalDets);
    end
end
