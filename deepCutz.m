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
receiverData{5}= receiverData{5}(555:end,:);
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
%Frank's conditional averaging.
% I want to isolate wind's effect, so lets compare low wind day/night and
% high wind day/night.

for COUNT = 1:length(receiverData)
    for szn = 1:5
        dayLowIndex{COUNT,szn} = receiverData{1,COUNT}.daytime == 1 & receiverData{1,COUNT}.Season == szn & receiverData{1,COUNT}.windSpd < 2;
        dayHighIndex{COUNT,szn} = receiverData{1,COUNT}.daytime == 1 & receiverData{1,COUNT}.Season == szn & receiverData{1,COUNT}.windSpd > 8;
        nightLowIndex{COUNT,szn} = receiverData{1,COUNT}.daytime == 0 & receiverData{1,COUNT}.Season == szn & receiverData{1,COUNT}.windSpd > 2;
        nightHighIndex{COUNT,szn} = receiverData{1,COUNT}.daytime == 0 & receiverData{1,COUNT}.Season == szn & receiverData{1,COUNT}.windSpd > 8;
        dayLowScenario{COUNT,szn}      = receiverData{COUNT}(dayLowIndex{COUNT,szn},:)
        nightLowScenario{COUNT,szn}    = receiverData{COUNT}(nightLowIndex{COUNT,szn},:)
        dayHighScenario{COUNT,szn}      = receiverData{COUNT}(dayHighIndex{COUNT,szn},:)
        nightHighScenario{COUNT,szn}    = receiverData{COUNT}(nightHighIndex{COUNT,szn},:)

    end
end



for k = 1:length(receiverData)
    for season = 1:5
        nightLowPings(k,season) = mean(nightLowScenario{k,season}.Pings);
        nightLowNoise(k,season) = mean(nightLowScenario{k,season}.Noise);
        nightLowDets(k,season)  = mean(nightLowScenario{k,season}.HourlyDets);

        dayLowPings(k,season) = mean(dayLowScenario{k,season}.Pings);
        dayLowNoise(k,season) = mean(dayLowScenario{k,season}.Noise);
        dayLowDets(k,season)  = mean(dayLowScenario{k,season}.HourlyDets);

        %
        nightHighPings(k,season) = mean(nightHighScenario{k,season}.Pings);
        nightHighNoise(k,season) = mean(nightHighScenario{k,season}.Noise);
        nightHighDets(k,season)  = mean(nightHighScenario{k,season}.HourlyDets);

        dayHighPings(k,season) = mean(dayHighScenario{k,season}.Pings);
        dayHighNoise(k,season) = mean(dayHighScenario{k,season}.Noise);
        dayHighDets(k,season)  = mean(dayHighScenario{k,season}.HourlyDets);

    end
end

%%
%Frank needs to create another metric. % difference between day and night?
%yes yesysysysygjsdsfjkgjsgfgnjsnjssklm;s
for k = 1:length(receiverData)
    for season = 1:5
        diffNoiseDay(k,season) =      dayHighNoise(k,season)-dayLowNoise(k,season)
        diffNoiseNight(k,season) =    nightHighNoise(k,season)-nightLowNoise(k,season)
        diffPingsDay(k,season) =      dayHighPings(k,season)-dayLowPings(k,season)
        diffPingsNight(k,season) =    nightHighPings(k,season)-nightLowPings(k,season)

        percentNoiseDay(k,season) =     (diffNoiseDay(k,season)/dayLowNoise(k,season))*100
        percentNoiseNight(k,season) =   (diffNoiseNight(k,season)/nightLowNoise(k,season))*100
        percentPingsDay(k,season) =      (diffPingsDay(k,season)/dayLowPings(k,season))*100
        percentPingsNight(k,season) =    (diffPingsNight(k,season)/nightLowPings(k,season))*100
    end
end

%%
%Franks trying new approach, isolating winds
for k = 1:length(receiverData)
    for season = 1:5
        diffNoiseHigh(k,season) =      nightHighNoise(k,season)-dayHighNoise(k,season)
        diffNoiseLow(k,season) =    nightLowNoise(k,season)-dayLowNoise(k,season)
        diffPingsHigh(k,season) =      nightHighPings(k,season)-dayHighPings(k,season)
        diffPingsLow(k,season) =    nightLowPings(k,season)-dayLowPings(k,season)

        percentNoiseHigh(k,season) =     (diffNoiseHigh(k,season)/dayHighNoise(k,season))*100
        percentNoiseLow(k,season) =   (diffNoiseLow(k,season)/dayLowNoise(k,season))*100
        percentPingsHigh(k,season) =      (diffPingsHigh(k,season)/dayHighPings(k,season))*100
        percentPingsLow(k,season) =    (diffPingsLow(k,season)/dayLowPings(k,season))*100
    end
end





%%

X = 1:5;

figure()
scatter(X,percentNoiseDay(4:5,:),'filled')
legend('On Reef','Off Reef')
xlabel('Season')
ylabel('Difference in Noise (%)')
title('% Difference in HF Noise, Daytime, HighWinds-LowWinds')

figure()
scatter(X,percentNoiseNight(4:5,:),'filled')
legend('On Reef','Off Reef')
xlabel('Season')
ylabel('Difference in Noise (%)')
title('% Difference in HF Noise, Nighttime, HighWinds-LowWinds')

figure()
scatter(X,percentPingsDay(4:5,:),'filled')
legend('On Reef','Off Reef')
xlabel('Season')
ylabel('Difference in Pings (%)')
title('% Difference in Pings, Daytime, HighWinds-LowWinds')

figure()
scatter(X,percentPingsNight(4:5,:),'filled')
legend('On Reef','Off Reef')
xlabel('Season')
ylabel('Difference in Pings (%)')
title('% Difference in Pings, Nighttime, HighWinds-LowWinds')

%%

seasonColors = ['r','g','b','k','m']

figure
tiledlayout(2,2)
nexttile()
hold on
for season = 1:5
    scatter(receiverData{4}.Noise(dayLowIndex{4,season}),receiverData{4}.HourlyDets(dayLowIndex{4,season}),seasonColors(season))
end
title('On Reef, Low Winds (<2 m/s)')


nexttile()
hold on
for season = 1:5
    scatter(receiverData{5}.Noise(dayLowIndex{5,season}),receiverData{5}.HourlyDets(dayLowIndex{5,season}),seasonColors(season))
end
title('Off Reef, Low Winds (<2 m/s)')


nexttile()
hold on
for season = 1:5
    scatter(receiverData{4}.Noise(dayHighIndex{4,season}),receiverData{4}.HourlyDets(dayHighIndex{4,season}),seasonColors(season))
end
title('On Reef, High Winds (>8 m/s)')

nexttile()
hold on
for season = 1:5
    scatter(receiverData{5}.Noise(dayHighIndex{5,season}),receiverData{5}.HourlyDets(dayHighIndex{5,season}),seasonColors(season))
end
title('Off Reef, High Winds (>8 m/s)')

%%




figure()
scatter(receiverData{4}.Noise(receiverData{4}.Season ==1),receiverData{4}.windSpd(receiverData{4}.Season ==1),'r')
hold on
scatter(receiverData{4}.Noise(receiverData{4}.Season ==2),receiverData{4}.windSpd(receiverData{4}.Season ==2),'g')
scatter(receiverData{4}.Noise(receiverData{4}.Season ==3),receiverData{4}.windSpd(receiverData{4}.Season ==3),'b')
scatter(receiverData{4}.Noise(receiverData{4}.Season ==4),receiverData{4}.windSpd(receiverData{4}.Season ==4),'k')
scatter(receiverData{4}.Noise(receiverData{4}.Season ==5),receiverData{4}.windSpd(receiverData{4}.Season ==5),'m')
ylabel('Avg Windspeed (m/s)')
xlabel('HF Noise (mV)')
legend('Winter','Spring','Summer','Fall','M.Fall')
title('On Reef')
xlim([250 850])
ylim([0 18])




















