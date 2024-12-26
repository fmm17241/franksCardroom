stationWindsAnalysis
stationTidalAnalysis


%Load in the detection files
cd ([oneDrive,'Moored\GRNMS\VRLs'])
rawDetFile{1,1} = readtable('VR2Tx_483062_20211112_1.csv'); %SURTASSSTN20
rawDetFile{2,1} = readtable('VR2Tx_483064_20211025_1.csv'); %SURTASS05IN
rawDetFile{3,1} = readtable('VR2Tx_483066_20211018_1.csv'); %Roldan
rawDetFile{4,1} = readtable('VR2Tx_483067_20211112_3.csv'); %33OUT
rawDetFile{5,1} = readtable('VR2Tx_483068_20211223_1.csv'); %FS17
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

%

%
for k = 1:length(rawDetFile)
    % Extract the data from Var3
    data{k} = rawDetFile{k,1}.Var3;

    % Ensure it's a string array for easier processing
    data{k} = string(data{k});

    % Get unique strings and their counts
    [occurrences{k}(1,:), TEST{k}] = groupcounts(data{k});
end

% TEST{13} = TEST{13}';
% 
% all = height(rawDetFile{1})+height(rawDetFile{2})+height(rawDetFile{3})+height(rawDetFile{4})+height(rawDetFile{5})+height(rawDetFile{6})+height(rawDetFile{7})+height(rawDetFile{8})+height(rawDetFile{9})+height(rawDetFile{10})+height(rawDetFile{11})+height(rawDetFile{12})+height(rawDetFile{13})
% 
% for k = 1:length(rawDetFile)
%     data{k} = string(rawDetFile{k,1}.Var3); % Convert to string array
%     filteredData{k} = data{k}(startsWith(data{k}, 'A69-1602-')); % Filter by prefix
% end



% THIS removes self detections, and adds a line of "1s" in a columnn so I
% can do an hourly sum of detections.
for transceiver = 1:length(rawDetFile)
    heardSelf{transceiver}    = strcmp(rawDetFile{transceiver,1}.Var3,selfID(transceiver,:))
    % heardMooring{transceiver} = strfind(rawDetFile{transceiver,1}.Var3,'A69-1601') 
    % heardMooring{transceiver} = contains(rawDetFile{transceiver,1}.Var3,'A69-1601')
    % FM targetting a single mooring.
    heardMooring{transceiver} = contains(rawDetFile{transceiver,1}.Var3,'A69-1601-63073')

    selfDets{transceiver} = rawDetFile{transceiver,1}(heardSelf{transceiver},:)

    % countMooring{transceiver} = sum(heardMooring{transceiver})
    countSelfDetects(transceiver,1) = sum(heardSelf{transceiver});
    rawDetFile{transceiver}(strcmp(rawDetFile{transceiver,1}.Var3,selfID(transceiver,:)),:) = [];
    %
    howMany{transceiver} = height(rawDetFile{transceiver});
    addIt = ones(howMany{transceiver},1);
    rawDetFile{transceiver}.Var4 = addIt;
    howManySelf{transceiver} = height(selfDets{transceiver});
    addIt2 = zeros(howManySelf{transceiver},1);
    selfDets{transceiver}.Var4 = addIt2;

end

%This turns my raw detection files into a timetable, then bins it hourly
%and defines the timezone to UTC.
for transceiver = 1:length(rawDetFile)
    rawDetFile{transceiver} = table2timetable(rawDetFile{transceiver}(:,{'Var1','Var4'}));
    rawDetFile{transceiver} = retime(rawDetFile{transceiver},'hourly','sum')
    rawDetFile{transceiver}.Properties.VariableNames = {'HourlyDets'};
    rawDetFile{transceiver}
    % receiverData{PT}.Properties.VariableNames = {'DN','HourlyDets','Noise','Pings','Tilt','Temp'};
    rawDetFile{transceiver}.Properties.DimensionNames{1} = 'DT'; 
    rawDetFile{transceiver}.DT.TimeZone = "UTC";
    %
    selfArray{transceiver} = table2timetable(selfDets{transceiver}(:,{'Var1','Var4'}));
    selfArray{transceiver} = retime(selfArray{transceiver},'hourly','sum');
    selfArray{transceiver}.Properties.DimensionNames{1} = 'DT'; 
    selfArray{transceiver}.Properties.DimensionNames{2} = 'SelfDets';
    selfArray{transceiver}.DT.TimeZone = "UTC";
    selfArray{transceiver}.ExpectedSelfPings = selfArray{transceiver}.SelfDets*8;
end


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

%Frank testing
for PT = 1:length(uniqueReceivers)
%     clearvars tempIndex detectionIndex noiseIndex pingIndex tiltIndex
    tempIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Temperature');
    detectionIndex{PT,1} = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Detections on 69 kHz');
    noiseIndex{PT,1}     = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Average noise');
    pingIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Pings on 69 kHz');
    tiltIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Tilt angle');
    
    % 
    % receiverData{PT}     = table2timetable(table(datetime(dataDN(detectionIndex{PT}),'ConvertFrom','datenum','TimeZone','UTC'), ...
    %                                 dataDN(detectionIndex{PT}), ...
    %                                 data.Data(detectionIndex{PT}), ...
    %                                 data.Data(noiseIndex{PT}), ...
    %                                 data.Data(pingIndex{PT}), ...
    %                                 data.Data(tiltIndex{PT}), ...
    %                                 data.Data(tempIndex{PT})))
    % receiverData{PT}.Properties.VariableNames = {'DN','HourlyDets','Noise','Pings','Tilt','Temp'};
    % receiverData{PT}.Properties.DimensionNames{1} = 'DT'; 

    receiverData{PT}     = table2timetable(table(datetime(dataDN(noiseIndex{PT}),'ConvertFrom','datenum','TimeZone','UTC'), ...
                                    data.Data(noiseIndex{PT}), ...
                                    data.Data(pingIndex{PT}), ...
                                    data.Data(tiltIndex{PT}), ...
                                    data.Data(tempIndex{PT})))
    receiverData{PT}.Properties.VariableNames = {'Noise','Pings','Tilt','Temp'};
    % receiverData{PT}.Properties.VariableNames = {'DN','HourlyDets','Noise','Pings','Tilt','Temp'};
    receiverData{PT}.Properties.DimensionNames{1} = 'DT'; 


    receiverIdentity{PT}        = {uniqueReceivers{PT},transceiverNames{PT}, letters(PT)};

end
receiverData{2} = receiverData{2}(3:end,:)
receiverData{3} = receiverData{3}(1:10154,:)
receiverData{11} = receiverData{11}(1:7685,:)
receiverData{13} = receiverData{13}(1:9373,:)

% Removes NaNs formed when Daylight savings time occurred
% receiverData{1}(1473,:) = [];
% receiverData{2}(1952,:) = [];


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

sunRun = [sunrise2019, sunrise2020; sunset2019, sunset2020];
close all
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



%Frank wind
for COUNT = 1:length(receiverData)
    fullWindIndex{COUNT} = isbetween(windsDT,receiverData{COUNT}.DT(1,1),receiverData{COUNT}.DT(end,1),'closed');
    receiverData{COUNT}.windSpd(:,1) = WSPD(fullWindIndex{COUNT});
    receiverData{COUNT}.windDir(:,1) = WDIR(fullWindIndex{COUNT});
    receiverData{COUNT}.surfaceTemp  = seas.SST(fullWindIndex{COUNT});
    receiverData{COUNT}.bulkThermalStrat = receiverData{COUNT}.surfaceTemp-receiverData{COUNT}.Temp;
    receiverData{COUNT}.waveHeight       = seas.waveHeight(fullWindIndex{COUNT});

end


% %Frank creating Ping Ratio, very rough measure of efficiency
% for COUNT = 1:length(receiverData)
%     detPings = receiverData{COUNT}.HourlyDets.*8;
%     receiverData{COUNT}.PingRatio = detPings./receiverData{COUNT}.Pings;
%     receiverData{COUNT}.PingRatio(isnan(receiverData{COUNT}.PingRatio))=0;
% end

%Adds predicted tidal currents to data
for COUNT = 1:length(receiverData)
    fullTideIndex{COUNT} = isbetween(tideDT,receiverData{COUNT}.DT(1,1),receiverData{COUNT}.DT(end,1),'closed');
    receiverData{COUNT}.crossShore(:,1) = crossShore(fullTideIndex{COUNT})';
    receiverData{COUNT}.alongShore(:,1) = alongShore(fullTideIndex{COUNT})';
end


% %Creates binary "did we hear something" variable and a noise threshold
% %variable
% for COUNT = 1:length(receiverData)
%     receiverData{COUNT}.HeardSomething = 1*(receiverData{COUNT}.HourlyDets > 0);
% 
%     %Anything with a 1 means the noise was below challenging
%     receiverData{COUNT}.NoiseThreshold = 1*(receiverData{COUNT}.Noise < 650);
% end




%Adds estimated bulk stratification, comparing the NOAA buoy to transceiver
%measurements.

% receiverData{}.bulkStrat = receiverData


%Frank testing
for PT = 1:length(uniqueReceivers)
    receiverData{PT}            = synchronize(receiverData{PT},rawDetFile{PT},'hourly')
end


%Frank cleaning up data from deploy/retrieve
%Not the prettiest, but this removes times where tilt and temperature are
%clearly showing its out of the water, or times out of our range, or NaN
%values from concatenating the two arrays.
receiverData{1}= receiverData{1}(21:end,:);
receiverData{2}= receiverData{2}(17:9188,:);
receiverData{3}= receiverData{3}(20:10155,:);
receiverData{4}= receiverData{4}(24:13937,:);
receiverData{5}= receiverData{5}(20:15017,:);
receiverData{6}= receiverData{6}(100:9893,:);
receiverData{7}= receiverData{7}(97:9962,:);
receiverData{8}= receiverData{8}(24:9253,:);
receiverData{9}= receiverData{9}(18:9209,:);
receiverData{10}= receiverData{10}(26:9367,:);
receiverData{11}= receiverData{11}(4:7685,:);
receiverData{12}= receiverData{12}(2:8832,:);
receiverData{13}= receiverData{13}(14:9373,:);

selfArray{1} = selfArray{1}(21:7780,:);
% rawDetFile{transceiver}.NonSelfPings = rawDetFile{transceiver}.Pings-selfArray{transceiver}.ExpectedSelfPings;
% 
% for k = 1:length(receiverData)
%     receiverData{k}.NonSelfPings = receiverData{k}.Pings-selfArray{k}.ExpectedSelfPings;
% end
%% 
%Further pruning.

figure()
tiledlayout(4,1,'tileSpacing','compact')

ax1 = nexttile()
hold on
for k = 1:length(receiverData)
plot(receiverData{k}.DT,receiverData{k}.Noise)
end
title('Noise')

ax2 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd)
title('Windspeed')

ax3 = nexttile()
hold on
for k = 1:length(receiverData)
plot(receiverData{k}.DT,receiverData{k}.Temp)
end
% plot(receiverData{4}.DT,receiverData{4}.surfaceTemp,'k','LineWidth',3)
title('Temperature')
% 
ax4 = nexttile()
for k = 1:length(receiverData)
plot(receiverData{k}.DT,receiverData{k}.HourlyDets)
end
title('Detections')


linkaxes([ax1,ax2,ax3,ax4],'x')

%%
%
for transceiver = 1:length(receiverData)
    receiverData{transceiver}.windSpd = fillmissing(receiverData{transceiver}.windSpd, 'linear');
    receiverData{transceiver}.Pings = fillmissing(receiverData{transceiver}.Pings, 'linear');
    receiverData{transceiver}.Noise = fillmissing(receiverData{transceiver}.Noise, 'linear');
     receiverData{transceiver}.HourlyDets = fillmissing(receiverData{transceiver}.HourlyDets, 'linear');
end
