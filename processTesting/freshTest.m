%FM
%What's going on, vegv,pbmkfgbmklfb m sbklgmvkb kgmbkmgf

stationTidalAnalysis
%tideDN, tideDT: tide timing
%crossShore, alongShore: tidal velocities with perspective rotated so
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

for COUNT = 1:4
    fullTideIndex{COUNT} = isbetween(tideDT,receiverTimes{COUNT}(1,1),receiverTimes{COUNT}(end,1),'closed');
    receiverData{COUNT}.crossShore(:,1) = tideDN(fullWindIndex{COUNT});      receiverData{COUNT}.crossShore(:,2) = crossShore(fullWindIndex{COUNT});
    receiverData{COUNT}.alongShore(:,1) = tideDN(fullWindIndex{COUNT});        receiverData{COUNT}.alongShore(:,2) = alongShore(fullWindIndex{COUNT});
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

%Frank manually making season bins for the 4 transceivers
%SURT05
winter{1}     = [16:2063, 7944:9188]';
spring{1}     = [ 2064:4271]';
summer{1}  = [4272:5735]';
fall{1}          = [5736:6479]';
mFall{1}      = [6480:7943]';

%STSnew2
winter{2}     = [24:2405, 8286:9253]';
spring{2}     = [2406:4613]';
summer{2}  = [4614:6077]';
fall{2}          = [6078:6821]';
mFall{2}      = [6822:8285]';

%FS6
winter{3}    = [17:2061, 7942:9208]';
spring{3}    = [2062:4269]';
summer{3} = [4270:5733]';
fall{3}         = [5734:6477]';
mFall{3}     = [6478:7941]';

%39IN
winter{4}    = [14:2397, 8278:9373]';
spring{4}    = [2398:4605]';
summer{4} = [4606:6069]';
fall{4}         = [6070:6813]';
mFall{4}     = [6814:8277]';

% 
for COUNT = 1:4
    seasonCounter{COUNT} = zeros(1,length(receiverTimes{COUNT}));
    seasonCounter{COUNT}(winter{COUNT}) = 1; seasonCounter{COUNT}(spring{COUNT}) = 2; seasonCounter{COUNT}(summer{COUNT}) = 3; seasonCounter{COUNT}(fall{COUNT}) = 4; seasonCounter{COUNT}(mFall{COUNT}) = 5;
    receiverData{COUNT}.season = seasonCounter{COUNT}';
end


%%
for COUNT = 1:4
    singleData{COUNT,1} =table(receiverTimes{COUNT},receiverData{COUNT}.season, receiverData{COUNT}.hourlyDets(:,2), receiverData{COUNT}.crossShore(:,2), receiverData{COUNT}.alongShore(:,2),  receiverData{COUNT}.avgNoise(:,2), receiverData{COUNT}.pings(:,2),receiverData{COUNT}.tilt(:,2),receiverData{COUNT}.bottomTemp(:,2),receiverData{COUNT}.windSpd(:,2),receiverData{COUNT}.windDir(:,2),receiverData{COUNT}.bulkStrat,receiverData{COUNT}.daytime,receiverData{COUNT}.ratio(:,2));         
    singleData{COUNT,1}.Properties.VariableNames = {'Time','Season','HourlyDets','CrossTide','AlongTide','Noise','Pings','Tilt','Temp','WindSpd','WindDir','BulkStrat','Daytime','Ratio'};
end

%Removing timing of testing: first bits are clearly in air.
singleData{1} = singleData{1}(16:end,:)
singleData{2} = singleData{2}(24:end,:)
singleData{3} = singleData{3}(17:end,:)
singleData{4} = singleData{4}(14:end,:)


seasonName = [{'Winter'},{'Spring'},{'Summer'},{'Fall'},{'M. Fall'}];


%%
%Very late but Frank has to compare these


for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        nightBin{COUNT,season} = singleData{COUNT}.Daytime == 0 & singleData{COUNT}.Season ==season;
        dayBin{COUNT,season} = singleData{COUNT}.Daytime == 1 & singleData{COUNT}.Season ==season;
        nightDets(COUNT,season)  = mean(singleData{COUNT}.HourlyDets(nightBin{COUNT,season}));
        dayDets(COUNT,season)  = mean(singleData{COUNT}.HourlyDets(dayBin{COUNT,season}));

        nightRatio(COUNT,season)  = mean(singleData{COUNT}.Ratio(nightBin{COUNT,season}));
        dayRatio(COUNT,season)  = mean(singleData{COUNT}.Ratio(dayBin{COUNT,season}));

        nightStrat(COUNT,season)  = mean(singleData{COUNT}.BulkStrat(nightBin{COUNT,season}));
        dayStrat(COUNT,season)  = mean(singleData{COUNT}.BulkStrat(dayBin{COUNT,season}));

        nightNoise(COUNT,season)  = mean(singleData{COUNT}.Noise(nightBin{COUNT,season}));
        dayNoise(COUNT,season)  = mean(singleData{COUNT}.Noise(dayBin{COUNT,season}));

        nightPings(COUNT,season)  = mean(singleData{COUNT}.Pings(nightBin{COUNT,season}));
        dayPings(COUNT,season)  = mean(singleData{COUNT}.Pings(dayBin{COUNT,season}));
    end
end





%%
%Night Detection Confidence Intervals
%night
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.HourlyDets(nightBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.HourlyDets(nightBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CInightDets{COUNT}(season,:) = (mean(singleData{COUNT}.HourlyDets(nightBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%Day
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.HourlyDets(dayBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.HourlyDets(dayBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CIdayDets{COUNT}(season,:) = (mean(singleData{COUNT}.HourlyDets(dayBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%

%Night Ratio Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Ratio(nightBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Ratio(nightBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CInightRatio{COUNT}(season,:) = (mean(singleData{COUNT}.Ratio(nightBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%Day Ratio Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Ratio(dayBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Ratio(dayBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CIdayRatio{COUNT}(season,:) = (mean(singleData{COUNT}.Ratio(dayBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%
%Day Noise Confidence Interval
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Noise(nightBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Noise(nightBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CInightNoise{COUNT}(season,:) = (mean(singleData{COUNT}.Noise(nightBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%Day Noise Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Noise(dayBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Noise(dayBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CIdayNoise{COUNT}(season,:) = (mean(singleData{COUNT}.Noise(dayBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%
%Night Ping Confidence Interval
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Pings(nightBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Pings(nightBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CInightPings{COUNT}(season,:) = (mean(singleData{COUNT}.Pings(nightBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%Day Ping Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Pings(dayBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Pings(dayBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CIdayPings{COUNT}(season,:) = (mean(singleData{COUNT}.Pings(dayBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%
%Bulk Strat
%Night Ping Confidence Interval
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.BulkStrat(nightBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.BulkStrat(nightBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CInightStrat{COUNT}(season,:) = (mean(singleData{COUNT}.BulkStrat(nightBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%Day Ping Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.BulkStrat(dayBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.BulkStrat(dayBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CIdayStrat{COUNT}(season,:) = (mean(singleData{COUNT}.BulkStrat(dayBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%


X = 1:5;

figure()
nexttile([2 1])
plot(X,dayDets(1,:),'r','LineWidth',2)
hold on
scatter(X,dayDets(1,:),150,'r','filled')
ciplot(CIdayDets{1}(:,1),CIdayDets{1}(:,2),X,'r')
plot(X,nightDets(1,:),'b','LineWidth',2)
scatter(X,nightDets(1,:),150,'b','filled')
ciplot(CInightDets{1}(:,1),CInightDets{1}(:,2),X,'b')
legend('','','Day','','','Night')
xlabel('Season')
ylabel('Hourly Detections')
title('','Hourly Detections')

nexttile([2 1])
plot(X,dayPings(1,:),'r','LineWidth',2)
hold on
scatter(X,dayPings(1,:),150,'r','filled')
ciplot(CIdayPings{1}(:,1),CIdayPings{1}(:,2),X,'r')
plot(X,nightPings(1,:),'b','LineWidth',2)
scatter(X,nightPings(1,:),150,'b','filled')
ciplot(CInightPings{1}(:,1),CInightPings{1}(:,2),X,'b')
legend('','','Day','','','Night')
xlabel('Season')
ylabel('Hourly Pings')
title('','Hourly Pings')


nexttile([2 1])
plot(X,dayNoise(1,:),'r','LineWidth',2)
hold on
scatter(X,dayNoise(1,:),150,'r','filled')
ciplot(CIdayNoise{1}(:,1),CIdayNoise{1}(:,2),X,'r')
plot(X,nightNoise(1,:),'b','LineWidth',2)
scatter(X,nightNoise(1,:),150,'b','filled')
ciplot(CInightNoise{1}(:,1),CInightNoise{1}(:,2),X,'b')
yline(650,'--')
legend('','','Day','','','Night','')
xlabel('Season')
ylabel('HF Noise (mV)')
title('Diurnal Differences in the Acoustic Environment','High-Frequency Noise')

nexttile([2 1])
plot(X,dayRatio(1,:),'r','LineWidth',2)
hold on
scatter(X,dayRatio(1,:),150,'r','filled')
ciplot(CIdayRatio{1}(:,1),CIdayRatio{1}(:,2),X,'r')
plot(X,nightRatio(1,:),'b','LineWidth',2)
scatter(X,nightRatio(1,:),150,'b','filled')
ciplot(CInightRatio{1}(:,1),CInightRatio{1}(:,2),X,'b')
legend('','','Day','','','Night')
xlabel('Season')
ylabel('Ping Ratio')
title('','Ping Ratio')

nexttile([2 1])
plot(X,dayStrat(1,:),'r','LineWidth',2)
hold on
scatter(X,dayStrat(1,:),150,'r','filled')
ciplot(CIdayStrat{1}(:,1),CIdayStrat{1}(:,2),X,'r')
plot(X,nightStrat(1,:),'b','LineWidth',2)
scatter(X,nightStrat(1,:),150,'b','filled')
ciplot(CInightStrat{1}(:,1),CInightStrat{1}(:,2),X,'b')
legend('','','Day','','','Night')
xlabel('Season')
ylabel('Bulk Strat (C)')
title('','Thermal Stratification')

ax = gcf;
exportgraphics(ax,sprintf('test4Day%d.png',COUNT))
