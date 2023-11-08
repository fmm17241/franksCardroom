%FM
%What's going on, vegv,pbmkfgbmklfb m sbklgmvkb kgmbkmgf

stationTidalAnalysis
%tideDN, tideDT: tide timing
%rotUtideShore, rotVtideShore: tidal velocities with perspective rotated so
%that the X axis is cross-shore, and the Y axis is alongshore.
%ut, vt: Same tidal velocities but in lat/lon directional perspective.


%Loads in and analyzes the windspeeds and directions
stationWindsAnalysis
%WSPD: Magnitude of winds
% WDIR: Direction of winds, GOING TOWARDS, not meteorological
% windsDT, windsDN: Timing of the winds

% fullTime = [datetime(2020,01,29,17,00,00),datetime(2020,12,10,13,00,00)];
% fullTime.TimeZone = 'UTC';
%Creates diurnal data
figure()
SunriseSunsetUTC


%Day timing
sunRun = [sunrise; sunset];

%Binary data: night or day
xx = length(sunRun);
sunlight = zeros(1,height(time));
for k = 1:xx
    currentSun = sunRun(:,k);
    currentHours = isbetween(time,currentSun(1,1),currentSun(2,1)); %FM 7/1
    currentDays = find(currentHours);
    sunlight(currentDays) = 1;
end

%Bringing in NDBC buoy data on the sea surface
cd([oneDrive,'WeatherData'])
seas2019 = readtable('temp2019.csv'); %IN UTC!!!!!
seas2020 = readtable('temp2020.csv'); %IN UTC!!!!!
seas = [seas2019;seas2020]
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
% clear detectionIndex  PT noiseIndex pingIndex detectionIndex tempIndex tiltIndex WonderfulReceivers data dataDN 

%Removing single datapoints from testing
receiverTimes{1} = receiverTimes{1}(3:end);
receiverData{1}.bottomTemp = receiverData{1}.bottomTemp(3:end,:);
receiverData{1}.hourlyDets = receiverData{1}.hourlyDets(3:end,:);
receiverData{1}.avgNoise   = receiverData{1}.avgNoise(3:end,:);
receiverData{1}.pings      = receiverData{1}.pings(3:end,:); 
receiverData{1}.tilt       = receiverData{1}.tilt(3:end,:);   

receiverTimes{4} = receiverTimes{4}(1:end-4);
receiverData{4}.bottomTemp = receiverData{4}.bottomTemp(1:end-4,:);
receiverData{4}.hourlyDets = receiverData{4}.hourlyDets(1:end-4,:);
receiverData{4}.avgNoise   = receiverData{4}.avgNoise(1:end-4,:);
receiverData{4}.pings      = receiverData{4}.pings(1:end-4,:);
receiverData{4}.tilt       = receiverData{4}.tilt(1:end-4,:); 


for COUNT = 1:4
    fullWindIndex{COUNT} = isbetween(windsDT,receiverTimes{COUNT}(1,1),receiverTimes{COUNT}(end,1),'closed');
    receiverData{COUNT}.windSpd(:,1) = windsDN(fullWindIndex{COUNT});      receiverData{COUNT}.windSpd(:,2) = WSPD(fullWindIndex{COUNT});
    receiverData{COUNT}.windDir(:,1) = windsDN(fullWindIndex{COUNT});        receiverData{COUNT}.windDir(:,2) = WDIR(fullWindIndex{COUNT});
end

% seas = seas(8050:end,:);


%%
for COUNT = 1:4
    fullSeasIndex{COUNT} = isbetween(seas.time,receiverTimes{COUNT}(1,1),receiverTimes{COUNT}(end,1),'closed');
    % useSST = seas.SST(fullWindIndex{COUNT});
    receiverData{COUNT}.bulkStrat = seas.SST(fullSeasIndex{COUNT})-receiverData{COUNT}.bottomTemp(:,2);
end



%%





for PT = 1:length(receiverData)
    usedPings = receiverData{PT}.hourlyDets(:,2)*8;
    ratio     = usedPings./receiverData{PT}.pings(:,2);
    receiverData{PT}.ratio(:,1) = receiverData{PT}.hourlyDets(:,1); 
    receiverData{PT}.ratio(:,2) = ratio;
end



%Timetable of transceiver data
for PT = 1:length(receiverData)
    startTime = [datetime(receiverData{1,PT}.bottomTemp(1,1),'ConvertFrom','datenum','TimeZone','UTC'); datetime(receiverData{1,PT}.bottomTemp(end,1),'ConvertFrom','datenum','TimeZone','UTC')];
    bottomTime{PT} = datetime(receiverData{PT}.bottomTemp(:,1),'ConvertFrom','datenum','TimeZone','UTC');
    botIndex       = isbetween(bottomTime{PT},startTime(1,1),startTime(2,1));
    bottom{PT} = timetable(bottomTime{PT}(botIndex),receiverData{PT}.bottomTemp(botIndex,2),receiverData{PT}.hourlyDets(botIndex,2),receiverData{PT}.tilt(botIndex,2),receiverData{PT}.avgNoise(botIndex,2),receiverData{PT}.pings(botIndex,2),receiverData{PT}.hourlyDets(botIndex,2));
    bottom{PT}.Properties.VariableNames = {'botTemp','Detections','Tilt','Noise','Pings','TotalDets'};
    bottom{PT}.Tilt(bottom{PT}.Tilt>70) = 0;
end
% 
% for PT = 1:length(bottom)
%     startTime = [datetime(2020,01,29,17,00,00,'TimeZone','UTC'); datetime(2020,12,10,13,00,00,'TimeZone','UTC')];
%     stratIndex1 = isbetween(seas.time,startTime(1,1),startTime(2,1));
%     stratIndex2 = isbetween(bottomTime{1,PT},startTime(1,1),startTime(2,1));
% %     if PT == 9 | 10
% %         continue
% %     end
%     stratification{PT} = seas.SST(stratIndex1)-bottom{1,PT}.botTemp(stratIndex2);
%     nullindex = stratification{1,PT} < .000001;
%     stratification{PT}(nullindex) = 0;
% end 
% 
% 
% 
% for COUNT = 1:length(bottom)
%     stratIndex = isbetween(bottom{COUNT}.Time,startTime(1,1),startTime(2,1),'closed');
%     bottomStats{COUNT} = bottom{COUNT}(stratIndex,:);
% %     fixInd = isnan(buoyStats{COUNT}.botTemp)
% %     buoyStratification{COUNT}(fixInd) = 0;
% %     fullStratData{COUNT} = buoyStats{COUNT}(stratIndex);
% end


%Binary data: night or day
xx = length(sunRun);
for COUNT = 1:length(receiverData)
    receiverData{COUNT}.daytime = zeros(height(receiverTimes{COUNT}),1);
    for k = 1:xx
        currentSun = sunRun(:,k);
        currentHours = isbetween(receiverTimes{COUNT},currentSun(1,1),currentSun(2,1)); %FM 7/1
        currentDays = find(currentHours);
        receiverData{COUNT}.daytime(currentDays) = 1;
    end
end




%%








% FM gotta edit this so it works for transceiver baed meaures
% 
% seasons = length(unique(receiverData{1}.season))
% 
% for COUNT = 1:length(receiverData)
%     for season = 1:length(seasons)
%         seasonBin{COUNT}{season} = fullData{COUNT}.season ==season;
%         seasonScenario{COUNT}{season}= fullData{COUNT}(seasonBin{COUNT}{season},:);
%         averageDets{COUNT}(season) = mean(seasonScenario{COUNT}{season}.detections);
%         noiseCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.noise);
%         wavesCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.waveHeight);
%         tiltCompareWind{COUNT}(season) = mean(seasonScenario{COUNT}{season}.tilt);
%         stratCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.stratification);
%         pingCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.pings);
%         totalDets{COUNT}(season)   = mean(seasonScenario{COUNT}{season}.TotalDets);
%     end
% end



















