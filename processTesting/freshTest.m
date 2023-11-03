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

cd([oneDrive,'WeatherData'])
seas = readtable('temp2020.csv'); %IN UTC!!!!!
timeVectorsst = table2array(seas(:,1:5)); timeVectorsst(:,6) = zeros(1,length(timeVectorsst));
time = datetime(timeVectorsst,'TimeZone','UTC'); time = time + min(1/144);

seas    = table2timetable(table(time,seas.WTMP, seas.WVHT));

%Retimes the data to be binned by the hour.
seas = retime(seas,'hourly','previous');
seas.Properties.VariableNames = {'SST','waveHeight'};
index99 = seas.waveHeight >50;
seas.waveHeight(index99) = 0;
clear fullsst* timeVectorsst


%Load in the detection files
cd ([oneDrive,'Moored\GRNMS\VRLs'])
rawDetFile{1,1} = readtable('VR2Tx_483064_20211025_1.csv'); %SURTASS05IN
rawDetFile{2,1} = readtable('VR2Tx_483074_20211025_1.csv'); %STSNEW2
rawDetFile{3,1} = readtable('VR2Tx_483075_20211025_1.csv'); %FS6
rawDetFile{4,1} = readtable('VR2Tx_483081_20211005_1.csv'); %39IN


%%FM 5/24: trying bulk strat using bottom receiver + buoy info
cd ([oneDrive,'Moored'])
% Separate dets, temps, and noise by which receiver is giving the data
data = readtable('VUE_Export.csv');

%These transceivers were never heard.
forbiddenReceivers = ['VR2Tx-483067';'VR2Tx-483068';'VR2Tx-483080'];
data(ismember(data.Receiver,forbiddenReceivers),:)=[];

%%
% Bringing in receiver data

dataDN = datenum(data.DateAndTime_UTC_);
dataDT = datetime(dataDN,'convertFrom','datenum');

%FM 3/6/23 Ordered the transceivers and doubled some up; this is to match
%the transceiver order listed in "matchAngles"/"thetaFinder"
uniqueReceivers = [{'VR2Tx-483064';     % 'VR2Tx-483064' SURTASS_05IN
                    'VR2Tx-483074';     % 'VR2Tx-483074' STSNew2
                    'VR2Tx-483081';     % 'VR2Tx-483081' 39IN
                    'VR2Tx-483075';}]   % 'VR2Tx-483075' FS6


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
end
clear detectionIndex  PT noiseIndex pingIndex detectionIndex tempIndex tiltIndex forbiddenReceivers data dataDN 

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

%
% for COUNT = 1:length(hourlyDetections)
%     fullDetsIndex{COUNT} = isbetween(hourlyDetections{COUNT}.time,fullTime(1,1),fullTime(1,2),'closed');
% end

%
% for COUNT = 1:length(fullDetsIndex)
%     detTimes{COUNT}   = [hourlyDetections{COUNT}.time(fullDetsIndex{COUNT})];
%     detections{COUNT} = [hourlyDetections{COUNT}.detections(fullDetsIndex{COUNT})];
%     luckySevens    = detections{COUNT} > 6;
%     detections{COUNT}(luckySevens) = 6;
% end

%
% for COUNT = 1:length(bottom)
%     stratIndex = isbetween(bottom{COUNT}.Time,fullTime(1,1),fullTime(1,2),'closed');
%     bottomStats{COUNT} = bottom{COUNT}(stratIndex,:);
% %     fixInd = isnan(buoyStats{COUNT}.botTemp)
% %     buoyStratification{COUNT}(fixInd) = 0;
% %     fullStratData{COUNT} = buoyStats{COUNT}(stratIndex);
% end


%Creates a value for thermal gradients between transceivers
% for COUNT = 1:2:length(bottomStats)
%     tempDifferences{COUNT} = abs(bottomStats{COUNT}.botTemp-bottomStats{COUNT+1}.botTemp)
%     tempDifferences{COUNT+1} = tempDifferences{COUNT};
% 
% end


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
% distances(:,2) = repelem(lldistkm(mooredGPS(12,:),mooredGPS(14,:)),length(uniqueReceivers));
% distances(:,3) = repelem(lldistkm(mooredGPS(14,:),mooredGPS(11,:)),length(uniqueReceivers));
% distances(:,4) = repelem(lldistkm(mooredGPS(11,:),mooredGPS(14,:)),length(uniqueReceivers));
% distances(:,5) = repelem(lldistkm(mooredGPS(13,:),mooredGPS(14,:)),length(uniqueReceivers));
% distances(:,6) = repelem(lldistkm(mooredGPS(14,:),mooredGPS(13,:)),length(uniqueReceivers));
% distances(:,7) = repelem(lldistkm(mooredGPS(12,:),mooredGPS(13,:)),length(uniqueReceivers));
% distances(:,8) = repelem(lldistkm(mooredGPS(13,:),mooredGPS(12,:)),length(uniqueReceivers));
% distances(:,9) = repelem(lldistkm(mooredGPS(12,:),mooredGPS(11,:)),length(uniqueReceivers));
% distances(:,10) = repelem(lldistkm(mooredGPS(11,:),mooredGPS(12,:)),length(uniqueReceivers));

%Angles between transceivers
% for K = 1:10
%     arrayPairing(:,K) = repelem(K,length(time))
%     transAngle(:,K)   = repelem(AnglesD(:,K),length(time))
% end

%Okay, basics are set.
close all




