stationWindsAnalysis


%Load in the detection files
cd ([oneDrive,'Moored\GRNMS\VRLs'])
rawDetFile{1,1} = readtable('VR2Tx_483062_20211112_1.csv'); %SURTASSSTN20
rawDetFile{2,1} = readtable('VR2Tx_483064_20211025_1.csv'); %SURTASS05IN
rawDetFile{3,1} = readtable('VR2Tx_483066_20211018_1.csv'); %Roldan
rawDetFile{4,1} = readtable('VR2Tx_483067_20211112_3.csv'); %33OUT??
rawDetFile{5,1} = readtable('VR2Tx_483068_20211223_1.csv'); %FS17??
rawDetFile{6,1} = readtable('VR2Tx_483070_20211223_1.csv'); % 08C
rawDetFile{7,1} = readtable('VR2Tx_483073_20211112_4.csv'); %STSNew1
rawDetFile{8,1} = readtable('VR2Tx_483074_20211025_1.csv'); %STSNEW2
rawDetFile{9,1} = readtable('VR2Tx_483075_20211025_1.csv'); %FS6
rawDetFile{10,1} = readtable('VR2Tx_483076_20211018_1.csv'); %08ALTIN
rawDetFile{11,1} = readtable('VR2Tx_483079_20211130_1.csv'); %34ALTOUT
rawDetFile{12,1} = readtable('VR2Tx_483080_20211223_1.csv'); %09T
rawDetFile{13,1} = readtable('VR2Tx_483081_20211005_1.csv'); %39IN

%Frank's adding in measure of when they hear themselves
selfID = ['A69-1601-63062';'A69-1601-63064';'A69-1601-63066';'A69-1601-63067';...
    'A69-1601-63068';'A69-1601-63070';'A69-1601-63073';'A69-1601-63074';...
    'A69-1601-63075';'A69-1601-63076';'A69-1601-63079';'A69-1601-63080';...
    'A69-1601-63081'];

for transceiver = 1:length(rawDetFile)
    heardSelf{transceiver} = strcmp(rawDetFile{transceiver,1}.Var3,selfID(transceiver,:))
    countSelfDetects(transceiver,1) = sum(heardSelf{transceiver});
end

%4 and 5 never heard themselves

selfDetects{transceiver} = rawDetFile{transceiver,heardSelf{transceiver}};

%%FM 5/24: trying bulk strat using bottom receiver + buoy info
cd ([oneDrive,'Moored'])
% Separate dets, temps, and noise by which receiver is giving the data
data = readtable('VUE_Export.csv');


dataDN = datenum(data.DateAndTime_UTC_);
dataDT = datetime(dataDN,'convertFrom','datenum');

%FM 3/6/23 Ordered the transceivers and doubled some up; this is to match
%the transceiver order listed in "matchAngles"/"thetaFinder"
%FM 11/16/23 NEW Frank says that's dumb. We shall go in numerical order, so
%it is written so shall it be done.
uniqueReceivers =  [{'VR2Tx-483062';  % 'VR2Tx-483062' SURTASSSTN20, A
                     'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN, B
                     'VR2Tx-483066';   % 'VR2Tx-483066' Roldan, C
                     'VR2Tx-483067';    % 33OUT, D
                     'VR2Tx-483068';    %FS17, E
                     'VR2Tx-483070';    %08C, F
                     'VR2Tx-483073';  % 'VR2Tx-483073' STSNew1, G
                     'VR2Tx-483074';   % 'VR2Tx-483074' STSNew2, H
                     'VR2Tx-483075';   % 'VR2Tx-483075' FS6, I
                     'VR2Tx-483076';     % 'VR2Tx-483076' 08ALTIN, J
                     'VR2Tx-483079';   % 34ALTOUT, K
                     'VR2Tx-483080';     %09T, L
                     'VR2Tx-483081'}]   % 'VR2Tx-483081' 39IN, M


%%
% uniqueReceivers = unique(data.Receiver);
letters = 'A':'M';
transceiverNames = {'SURTASSSTN20','SURTASS_05IN','Roldan','33OUT','FS17','08C','STSNew1','STSNew2',...
    'FS6','08ALTIN','34ALTOUT','09T','39IN'};


%% 

%%
%Frank testing
for PT = 1:length(uniqueReceivers)
%     clearvars tempIndex detectionIndex noiseIndex pingIndex tiltIndex
    tempIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Temperature');
    detectionIndex{PT,1} = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Detections on 69 kHz');
    noiseIndex{PT,1}     = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Average noise');
    pingIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Pings on 69 kHz');
    tiltIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Tilt angle');
    

    receiverData{PT}     = table2timetable(table(datetime(dataDN(detectionIndex{PT}),'ConvertFrom','datenum','TimeZone','UTC'), ...
                                    dataDN(detectionIndex{PT}), ...
                                    data.Data(detectionIndex{PT}), ...
                                    data.Data(noiseIndex{PT}), ...
                                    data.Data(pingIndex{PT}), ...
                                    data.Data(tiltIndex{PT}), ...
                                    data.Data(tempIndex{PT})))
    receiverData{PT}.Properties.VariableNames = {'DN','HourlyDets','Noise','Pings','Tilt','Temp'};
    receiverData{PT}.Properties.DimensionNames{1} = 'DT'; 



    receiverIdentity{PT}        = {uniqueReceivers{PT},transceiverNames{PT}, letters(PT)};
    % receiverData{PT}.name            = transceiverNames{PT};
    % receiverData{PT}.letter          = letters(PT);
    % receiverData{PT}.bottomTemp(:,1) = dataDN(tempIndex{PT}); receiverData{PT}.bottomTemp(:,2) = data.Data(tempIndex{PT});
    % receiverData{PT}.hourlyDets(:,1) = dataDN(detectionIndex{PT}); receiverData{PT}.hourlyDets(:,2) = data.Data(detectionIndex{PT});
    % receiverData{PT}.avgNoise(:,1)   = dataDN(noiseIndex{PT}); receiverData{PT}.avgNoise(:,2) = data.Data(noiseIndex{PT});
    % receiverData{PT}.pings(:,1)      = dataDN(pingIndex{PT});  receiverData{PT}.pings(:,2)    = data.Data(pingIndex{PT});
    % receiverData{PT}.tilt(:,1)       = dataDN(tiltIndex{PT}); receiverData{PT}.tilt(:,2)          = data.Data(tiltIndex{PT});
    % receiverData{PT}.DT               = datetime(receiverData{PT}.hourlyDets(:,1),'ConvertFrom','datenum','TimeZone','UTC');

end


%FM need to separate the seasons out for each transceiver :(

months = month(dataDT);

%Winter: Jan/Feb/Nov/Dec
seasonIndex{1} = [1:2,11:12];
%Spring: Mar/Apr/May
seasonIndex{2} = [3:5];
%Summer: Jun/Jul
seasonIndex{3} = [6:7];
%Fall: Aug
seasonIndex{4} = [8];
%Mariner's Fall: Sept/Oct
seasonIndex{5} = [9:10];

%Frank trying to automate separation of months/seasons
for k = 1:length(receiverData)
    originalSeason   = zeros(height(receiverData{k}),1);
    % receiverData{k}.Season = 
    whatMonth{k}     = month(receiverData{k}.DT);
    receiverData{k}.Season = originalSeason;
    winter{k} = ismember(whatMonth{k},seasonIndex{1});
    spring{k} = ismember(whatMonth{k},seasonIndex{2});
    summer{k} = ismember(whatMonth{k},seasonIndex{3});
    fall{k}   = ismember(whatMonth{k},seasonIndex{4});
    mFall{k}  = ismember(whatMonth{k},seasonIndex{5});

    receiverData{k}.Season(winter{k}) = 1;
    receiverData{k}.Season(spring{k}) = 2;
    receiverData{k}.Season(summer{k}) = 3;
    receiverData{k}.Season(fall{k}) = 4;
    receiverData{k}.Season(mFall{k}) = 5;
end

%Frank cleaning up data from deploy/retrieve
%Not the prettiest, but this removes times where tilt and temperature are
%clearly showing its out of the water, or datetimes years after the last
%reliable data.
receiverData{1}= receiverData{1}(20:end,:);
receiverData{2}= receiverData{2}(17:end,:);
receiverData{3}= receiverData{3}(15:10154,:);
receiverData{4}= receiverData{4}(24:end,:);
receiverData{5}= receiverData{5}(20:end,:);
receiverData{6}= receiverData{6}(96:end,:);
receiverData{7}= receiverData{7}(96:end,:);
receiverData{8}= receiverData{8}(23:end,:);
receiverData{9}= receiverData{9}(17:end,:);
receiverData{10}= receiverData{10}(25:end,:);
receiverData{11}= receiverData{11}(4:7685,:);

receiverData{12}= receiverData{12}(3:end,:);
receiverData{13}= receiverData{13}(17:9373,:);


%%
%Frank adding sunlight variable
%Creates diurnal data
figure()
SunriseSunsetUTC2019
figure()
SunriseSunsetUTC2020
figure()
SunriseSunsetUTC2021


date    = [date2019, date2020, date2021];
sunrise = [sunrise2019,sunrise2020, sunrise2021];
sunset  = [sunset2019, sunset2020, sunset2021];

sunRun = [sunrise;sunset]


%%
%Binary data: night or day
xx = length(sunRun);
sunlight = zeros(1,height(time));
for k = 1:xx
    currentSun = sunRun(:,k);
    currentHours = isbetween(time,currentSun(1,1),currentSun(2,1)); %FM 7/1
    currentDays = find(currentHours);
    sunlight(currentDays) = 1;
end

%Binary data: night or day
xx = length(sunRun);
for COUNT = 1:length(receiverData)
    receiverData{COUNT}.daytime = zeros(height(receiverData{COUNT}),1);
    for k = 1:xx
        currentSun = sunRun(:,k);
        currentHours = isbetween(receiverData{COUNT}.DT,currentSun(1,1),currentSun(2,1)); %FM 7/1
        currentDays = find(currentHours);
        receiverData{COUNT}.daytime(currentDays) = 1;
    end
end

%Frank needs to edit, add wind to data
for COUNT = 1:length(receiverData)
    fullWindIndex{COUNT} = isbetween(windsDT,receiverData{COUNT}.DT(1,1),receiverData{COUNT}.DT(end,1),'closed');
    receiverData{COUNT}.windSpd(:,1) = WSPD(fullWindIndex{COUNT});
    receiverData{COUNT}.windDir(:,1) = WDIR(fullWindIndex{COUNT});
end



%%
%Separating by day and night



for COUNT = 1:length(receiverData)
    for szn = 1:5
        dayIndex{COUNT,szn} = receiverData{1,COUNT}.daytime == 1 & receiverData{1,COUNT}.Season == szn;
        nightIndex{COUNT,szn} = receiverData{1,COUNT}.daytime == 0 & receiverData{1,COUNT}.Season == szn;

        dayScenario{COUNT,szn}      = receiverData{COUNT}(dayIndex{COUNT,szn},:)
        nightScenario{COUNT,szn}    = receiverData{COUNT}(nightIndex{COUNT,szn},:)

    end
end

%%

for k = 1:length(receiverData)
    for season = 1:5
        nightPings(k,season) = mean(nightScenario{k,season}.Pings);
        nightNoise(k,season) = mean(nightScenario{k,season}.Noise);
        nightDets(k,season)  = mean(nightScenario{k,season}.HourlyDets);

        dayPings(k,season) = mean(dayScenario{k,season}.Pings);
        dayNoise(k,season) = mean(dayScenario{k,season}.Noise);
        dayDets(k,season)  = mean(dayScenario{k,season}.HourlyDets);
    end
end
%%
%FOR DAYTIME

for k = 1:length(dayScenario)
    for season = 1:5
        %Creating Confidence Intervals
        %Noise
        clearvars ts
        SEMdaynoise{k}(season,:) = std(dayScenario{k,season}.Noise,'omitnan')/sqrt(length(dayScenario{k,season}.Noise));  
        ts = tinv([0.025  0.975],height(dayScenario{k,season})-1);  
        ciDayNoise{k}(season,:) = (mean(dayScenario{k,season}.Noise,'all','omitnan') + ts*SEMdaynoise{k}(season,:)); 


        %Dets
        clearvars ts
        SEMdaydets{k}(season,:) = std(dayScenario{k,season}.HourlyDets,'omitnan')/sqrt(length(dayScenario{k,season}.HourlyDets));  
        ts = tinv([0.025  0.975],height(dayScenario{k,season})-1);  
        ciDayHourlyDets{k}(season,:) = (mean(dayScenario{k,season}.HourlyDets,'all','omitnan') + ts*SEMdaydets{k}(season,:)); 



        %Pings
        clearvars ts
        SEMdaypings{k}(season,:) = std(dayScenario{k,season}.Pings,'omitnan')/sqrt(length(dayScenario{k,season}.Pings));  
        ts = tinv([0.025  0.975],height(dayScenario{k,season})-1);  
        ciDayPings{k}(season,:) = (mean(dayScenario{k,season}.Pings,'all','omitnan') + ts*SEMdaypings{k}(season,:)); 



        %Tilt
        clearvars ts
        SEMdaytilt{k}(season,:) = std(dayScenario{k,season}.Tilt,'omitnan')/sqrt(length(dayScenario{k,season}.Tilt));  
  
        ts = tinv([0.025  0.975],height(dayScenario{k,season})-1);  
        ciDayTilt{k}(season,:) = (mean(dayScenario{k,season}.Tilt,'all','omitnan') + ts*SEMdaytilt{k}(season,:)); 
        
    end
    SEMdaynoise{k}(:,2)     = -SEMdaynoise{k};
    SEMdaydets{k}(:,2)     = -SEMdaydets{k};
    SEMdaytilt{k}(:,2)     = -SEMdaytilt{k};
    SEMdaypings{k}(:,2)     = -SEMdaypings{k};
end


%%
%FOR NIGHTTIME
for k = 1:length(receiverData)
    for season = 1:5
        %Creating Confidence Intervals
        %Noise
        clearvars ts
        SEMNightnoise{k}(season,:) = std(nightScenario{k,season}.Noise,'omitnan')/sqrt(length(nightScenario{k,season}.Noise));  
        ts = tinv([0.025  0.975],height(nightScenario{k,season})-1);  
        ciNightNoise{k}(season,:) = (mean(nightScenario{k,season}.Noise,'all','omitnan') + ts*SEMNightnoise{k}(season,:)); 


        %Dets
        clearvars ts
        SEMNightdets{k}(season,:) = std(nightScenario{k,season}.HourlyDets,'omitnan')/sqrt(length(nightScenario{k,season}.HourlyDets));  
        ts = tinv([0.025  0.975],height(nightScenario{k,season})-1);  
        ciNightHourlyDets{k}(season,:) = (mean(nightScenario{k,season}.HourlyDets,'all','omitnan') + ts*SEMNightdets{k}(season,:)); 



        %Pings
        clearvars ts
        SEMNightpings{k}(season,:) = std(nightScenario{k,season}.Pings,'omitnan')/sqrt(length(nightScenario{k,season}.Pings));  
        ts = tinv([0.025  0.975],height(nightScenario{k,season})-1);  
        ciNightPings{k}(season,:) = (mean(nightScenario{k,season}.Pings,'all','omitnan') + ts*SEMNightpings{k}(season,:)); 



        %Tilt
        clearvars ts
        SEMNighttilt{k}(season,:) = std(nightScenario{k,season}.Tilt,'omitnan')/sqrt(length(nightScenario{k,season}.Tilt));  
  
        ts = tinv([0.025  0.975],height(nightScenario{k,season})-1);  
        ciNightTilt{k}(season,:) = (mean(nightScenario{k,season}.Tilt,'all','omitnan') + ts*SEMNighttilt{k}(season,:)); 
        
    end
    SEMNightnoise{k}(:,2)     = -SEMNightnoise{k};
    SEMNightdets{k}(:,2)     = -SEMNightdets{k};
    SEMNighttilt{k}(:,2)     = -SEMNighttilt{k};
    SEMNightpings{k}(:,2)     = -SEMNightpings{k};
end



figure()
scatter(nightNoise,nightPings,'r')
hold on
scatter(dayNoise,dayPings,'b')

X = 1:5;


ff = tiledlayout('horizontal')
nexttile([2 1])
hold on
scatter(dayNoise(4,:),dayPings(4,:),150,'r','>','filled')
scatter(dayNoise(5,:),dayPings(5,:),150,'b','*')
% scatter(testingNoise(loudNumbers,4),testingDets(loudNumbers,4),'r','>','filled')
% scatter(testingNoise(quietNumbers,4),testingDets(quietNumbers,4),'b','>','filled')
legend('On Reef','Off Reef')
title('On and Off the Reef','Daytime')
ylabel('Avg. Hourly Pings')
xlabel('HF Noise (mV)')
xlim([400 800])
ylim([0 35])

nexttile([2 1])
hold on
scatter(nightNoise(4,:),nightPings(4,:),150,'r','>','filled')
scatter(nightNoise(5,:),nightPings(5,:),150,'b','*')
% scatter(testingNoise(loudNumbers,4),testingDets(loudNumbers,4),'r','>','filled')
% scatter(testingNoise(quietNumbers,4),testingDets(quietNumbers,4),'b','>','filled')
legend('On Reef','Off Reef')
title('On and Off the Reef','Nighttime')
ylabel('Avg. Hourly Pings')
xlabel('HF Noise (mV)')
xlim([400 800])
ylim([0 35])


%%
LineSpecLoudPyramid = ['r','^']
LineSpecQuietPyramid = ['b','^']

LineSpecLoudSquare = ['r','pentagram']
LineSpecQuietSquare = ['b','pentagram']


ff = tiledlayout('horizontal')
nexttile([2 1])
hold on
errorbar(dayNoise(4,:),dayPings(4,:),SEMdaynoise{4}(:,2),SEMdaynoise{4}(:,1),SEMdaypings{4}(:,2),SEMdaypings{4}(:,1),LineSpecLoudPyramid)
errorbar(dayNoise(5,:),dayPings(5,:),SEMdaynoise{5}(:,2),SEMdaynoise{5}(:,1),SEMdaypings{5}(:,2),SEMdaypings{5}(:,1),LineSpecQuietPyramid)
xlim([400 800])
ylim([0 35])

title('Seasonal Averages','Daytime')
ylabel('Avg. Hourly Pings')
xlabel('HF Noise (mV)')
legend('Live Bottom','Flat Sand')

nexttile([2 1])
hold on
errorbar(nightNoise(4,:),nightPings(4,:),SEMNightnoise{4}(:,2),SEMNightnoise{4}(:,1),SEMNightpings{4}(:,2),SEMNightpings{4}(:,1),LineSpecLoudSquare)
errorbar(nightNoise(5,:),nightPings(5,:),SEMNightnoise{5}(:,2),SEMNightnoise{5}(:,1),SEMNightpings{5}(:,2),SEMNightpings{5}(:,1),LineSpecQuietSquare)
title('On and Off the Reef','Nighttime')
ylabel('Avg. Hourly Pings')
xlabel('HF Noise (mV)')
legend('Live Bottom','Flat Sand')
xlim([400 800])
ylim([0 35])


%%
% Now for all the transceivers, not just the 2 
loudNumbers  = [1,2,4,8,9,11,12];
quietNumbers = [3,5,6,7,10,13];
LineSpecLoud = ['r','^']
LineSpecQuiet = ['b','^']



ff = tiledlayout('horizontal')
nexttile([2 1])
hold on
for loudy = 1:length(loudNumbers)
    errorbar(dayNoise(loudNumbers(loudy),:),dayPings(loudNumbers(loudy),:),SEMdaynoise{loudNumbers(loudy)}(:,2),SEMdaynoise{loudNumbers(loudy)}(:,1),SEMdaypings{loudNumbers(loudy)}(:,2),SEMdaypings{loudNumbers(loudy)}(:,1),LineSpecLoud)
end
for quietish = 1:length(quietNumbers)
    errorbar(dayNoise(quietNumbers(quietish),:),dayPings(quietNumbers(quietish),:),SEMdaynoise{quietNumbers(quietish)}(:,2),SEMdaynoise{quietNumbers(quietish)}(:,1),SEMdaypings{quietNumbers(quietish)}(:,2),SEMdaypings{quietNumbers(quietish)}(:,1),LineSpecQuiet)
end

xlim([400 800])
ylim([0 600])

title('Seasonal Averages, All Transceivers','Daytime')
ylabel('Avg. Hourly Pings')
xlabel('HF Noise (mV)')
legend('Live Bottom','','','','','','','','','','','Flat Sand')


nexttile([2 1])
hold on
for loudy = 1:length(loudNumbers)
    errorbar(nightNoise(loudNumbers(loudy),:),nightPings(loudNumbers(loudy),:),SEMNightnoise{loudNumbers(loudy)}(:,2),SEMNightnoise{loudNumbers(loudy)}(:,1),SEMNightpings{loudNumbers(loudy)}(:,2),SEMNightpings{loudNumbers(loudy)}(:,1),LineSpecLoud)
end

for quietish = 1:length(quietNumbers)
    errorbar(nightNoise(quietNumbers(quietish),:),nightPings(quietNumbers(quietish),:),SEMNightnoise{quietNumbers(quietish)}(:,2),SEMNightnoise{quietNumbers(quietish)}(:,1),SEMNightpings{quietNumbers(quietish)}(:,2),SEMNightpings{quietNumbers(quietish)}(:,1),LineSpecQuiet)
end

title('Seasonal Averages, All Transceivers','Nighttime')
ylabel('Avg. Hourly Pings')
xlabel('HF Noise (mV)')
legend('Live Bottom','','','','','','','','','','','Flat Sand')
xlim([400 800])
ylim([0 600])

%%

ff = tiledlayout('horizontal')
nexttile([2 1])
scatter(receiverData{4}.Noise,receiverData{4}.windSpd,'r');
ylim([0 18])
xlim([200 850])
xlabel('HF Noise (mV)')
ylabel('Windspeed (m/s)')
title('On Reef, Live Bottom')



nexttile([2 1])
scatter(receiverData{5}.Noise,receiverData{5}.windSpd,'b');
ylim([0 18])
xlim([200 850])
xlabel('HF Noise (mV)')
ylabel('Windspeed (m/s)')
title('Off Reef, Flat Sand')

%%
ff = figure()
ff = tiledlayout('horizontal')
nexttile([2 1])
scatter(receiverData{4}.windSpd,receiverData{4}.Pings,'r');
% ylim([0 18])
% xlim([200 850])
xlabel('Windspeed (m/s)')
ylabel('Hourly Pings')
title('On Reef, Live Bottom')



nexttile([2 1])
scatter(receiverData{5}.windSpd,receiverData{5}.Pings,'b');
% ylim([0 18])
% xlim([200 850])
xlabel('Windspeed (m/s)')
ylabel('Hourly Pings')
title('Off Reef, Flat Sand')

%%
%Testing same visualization on different transceivers
ff = figure()
ff = tiledlayout('horizontal')
nexttile([2 1])
scatter(receiverData{3}.Noise,receiverData{3}.windSpd,'r');
ylim([0 18])
xlim([200 850])
xlabel('HF Noise (mV)')
ylabel('Windspeed (m/s)')
title('On Reef, Live Bottom')



nexttile([2 1])
scatter(receiverData{10}.Noise,receiverData{10}.windSpd,'b');
ylim([0 18])
xlim([200 850])
xlabel('HF Noise (mV)')
ylabel('Windspeed (m/s)')
title('Off Reef, Flat Sand')

