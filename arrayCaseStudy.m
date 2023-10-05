
% 1 SURTASSTN20    63062
% 2 SURTASS_05IN   63064
% 3 Roldan         63066
% 4 33OUT          63067 * none heard
% 5 FS17           63068  *none heard
% 6 08C            63070
% 7 STSNew1        63073
% 8 STSNew2        63074
% 9 FS6            63075
% 10 08ALTIN       63076
% 11 34ALTOUT      63079
% 12 09T           63080
% 13 39IN          63081

%Experiment 1, compare two moored transceivers 0.53km away
%For our purposes, Mooring 1 will be SURTASSTN20, deeper transceiver central to an array, and Mooring 2 will be
%STSNew1, more shallow transceiver. Yes, numbers above may be confusing, good observation, but I
%gotta keep them straight. If I lose that numbering, all of this is for naught and I may join the circus.

cd ([oneDrive,'Moored\GRNMS\VRLs'])
% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Moored\GRNMS\VRLs'

% call = readtable('VR2Tx_483080_20211223_1.csv'); %SURTASSSTN20
rawDetFile{1,1} = readtable('VR2Tx_483062_20211112_1.csv'); %SURTASSSTN20
rawDetFile{2,1} = readtable('VR2Tx_483064_20211025_1.csv'); %SURTASS05IN
rawDetFile{3,1} = readtable('VR2Tx_483066_20211018_1.csv'); %Roldan
rawDetFile{4,1} = readtable('VR2Tx_483070_20211223_1.csv'); % 08C
rawDetFile{5,1} = readtable('VR2Tx_483073_20211112_4.csv'); %STSNew1
rawDetFile{6,1} = readtable('VR2Tx_483074_20211025_1.csv'); %STSNEW2
rawDetFile{7,1} = readtable('VR2Tx_483075_20211025_1.csv'); %FS6
rawDetFile{8,1} = readtable('VR2Tx_483076_20211018_1.csv'); %08ALTIN
rawDetFile{9,1} = readtable('VR2Tx_483080_20211223_1.csv'); %09T
rawDetFile{10,1} = readtable('VR2Tx_483081_20211005_1.csv'); %39IN

%First pairing: SURTASSSTN20 and STSNEW1
%Second pairing: SURTASS05IN and FS6
%Third pairing: Roldan and 08ALTIN
%Fourth pairing: SURTASS05IN and STSNew2
%Fifth pairing: 39IN and SURTASS05IN
%Sixth pairing: STSNEW2 and FS6
%Extra Receivers: 09T

%Recognize pattern in the CSV of unique identification 
pattern1 = digitsPattern(4)+ "-" + digitsPattern(3,5);
pattern2 = "-" + digitsPattern(3,5);

%Comb through raw files, give me datetimes in EST (local), and tell me
%which instrument transmitted.
for counter=1:length(rawDetFile)
    if isempty(rawDetFile{counter})
        continue
    else
    mooredReceivers{counter,1}.DT=table2array(rawDetFile{counter,1}(:,1));mooredReceivers{counter,1}.DT.TimeZone = 'UTC';
    mooredReceivers{counter,1}.DN= datenum(mooredReceivers{counter,1}.DT);
    converty=string(rawDetFile{counter,1}{:,3});
    first = extract(converty,pattern1);
    second = extract(first,pattern2); third = erase(second,"-");
    mooredReceivers{counter,1}.detections = str2double(third);
    [mooredReceivers{counter,1}.which,~,c]      = unique(mooredReceivers{counter,1}.detections);
    arr = accumarray(c,1);
    counters{counter}=[mooredReceivers{counter,1}.which,arr];
    end
end
%Cleanup a bit
clear first second third fourth counter pattern1 pattern2 test arr converty c

%%

%Index of my pair. I don't need all detections, especially not self
%detections, I want to know how many times these bad boys heard each other.

%First pairing
index{1} = mooredReceivers{1,1}.detections == 63073; %SURTASSSTN20 hearing STSNew1, transmits West to East
index{2} = mooredReceivers{5,1}.detections == 63062; %STSNew1 hearing SURTASSSTN20, transmits East to West

%Second pairing
index{3} = mooredReceivers{7,1}.detections == 63064; %FS6 hearing SURTASS05In, transmits ENE
index{4} = mooredReceivers{2,1}.detections == 63075; %SURTASS05In hearing FS6, transmits WSW

%Third pairing
index{5} = mooredReceivers{3,1}.detections == 63076; %Roldan hearing 08ALTIN, transmits South to North
index{6} = mooredReceivers{8,1}.detections == 63066; %08ALTIN hearing Roldan, transmits North to South

%Fourth pairing
index{7} = mooredReceivers{6,1}.detections == 63064; % STSNEW2 hearing SURTASS05IN, transmits NW to SE
index{8} = mooredReceivers{2,1}.detections == 63074; % SURTASS05IN hearing STSNEW2, transmits SE to NW

%Fifth pairing
index{9} = mooredReceivers{2,1}.detections == 63081; % SURTASS05IN hearing 39IN, transmits NW to SE
index{10} = mooredReceivers{10,1}.detections == 63064; % 39IN hearing SURTASS05IN, transmits SE to NW

% %Sixth Pairing
index{11} = mooredReceivers{10,1}.detections == 63075; %39IN hearing FS6
index{12} = mooredReceivers{7,1}.detections == 63081; %FS6 hearing 39IN

% Seventh pairing
index{13} = mooredReceivers{6,1}.detections == 63075; %STSNew2 hearing FS6
index{14} = mooredReceivers{7,1}.detections == 63074; %FS6 hearing STSNew2



%FM this is my "key" for the index. I didn't want to load data twice so
%this key tells the loop which order to use
receiverOrder = [1;5;7;2;3;8;6;2;2;10;10;7;6;7];
% receiverOrder = [1;5;7;2;3;8;6;2;2;10];


% %Making the visualizations more correct: instead of 06:00 representing
% %06:00 to 06:59:59, it will now show as 06:30, the middle of the binned
% %data
% offset = duration(minutes(30));

%Below is a loop to create the timetables for all the different pairings.
%This bins the time by hour, then adds the :30 to make the visualization
%clearer.
%%
for k = 1:length(index)
    recNumber = receiverOrder(k,1);
    time{k} = mooredReceivers{recNumber,1}.DT(index{k});
    detections{k} = ones(length(mooredReceivers{recNumber,1}.detections(index{k})),1);
    detectionTable{k} = table(time{1,k},detections{1,k}); 
    detectionTable{k}.Properties.VariableNames = {'time','detections'};
    detectionTable{k} = table2timetable(detectionTable{k});
    hourlyDetections{k} = retime(detectionTable{k},'hourly','sum');
    %Put this step into chunkPlotter instead; to correctly visualize the
    %bin, we put the hours in :30 but otherwise we keep hours.
%     hourlyDetections{k}.time = hourlyDetections{k}.time + offset;
end








%%

% 
% %39IN
% %SURTASS05IN
% %FS6
% %STSNew2
% 
% 3, FS6 hearing SURTASS05IN
% 4, SURTASS05IN hearing FS6
% 7, STSNew2 hearing SURTASS05IN
% 8, SURTASS05IN hearing STSNew2
% 9, SURTASS05IN hearing 39IN
% 10, 39IN hearing SURTASS05IN


%%
%

% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\WeatherData'

cd([oneDrive,'WeatherData'])


% fullsst2019 = readtable ('temp2019.csv'); %IN UTC!!!!!
fullsst2020 = readtable('temp2020.csv'); %IN UTC!!!!!
% fullsst2021 = readtable ('temp2021.csv'); %IN UTC!!!!!

seas  = fullsst2020;

timeVectorsst = table2array(seas(:,1:5)); timeVectorsst(:,6) = zeros(1,length(timeVectorsst));

time = datetime(timeVectorsst,'TimeZone','UTC'); time = time + min(1/144);




seas    = table2timetable(table(time,seas.WTMP, seas.WVHT));
% seas = seas(8675:17343,:); %This is for full 2020
% seas = seas(9340:17003,:);
seas = retime(seas,'hourly','previous');

seas.Properties.VariableNames = {'SST','waveHeight'};
index99 = seas.waveHeight >50;
seas.waveHeight(index99) = 0;


clear fullsst* time timeVectorsst


%%FM 5/24: trying bulk strat using bottom receiver + buoy info
cd ([oneDrive,'Moored'])

% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Moored'
%%
% Separate dets, temps, and noise by which receiver is giving the data
data = readtable('VUE_Export.csv');
%SWITCHED: BELOW LINES TAKES OUT TWO TRANSCEIVERS WHICH WERE NOT HEARD AT
%ALL, NOT EVEN BY THEMSELVES, HURTING AVERAGE FM 4/7/22
forbiddenReceivers = ['VR2Tx-483067';'VR2Tx-483068';'VR2Tx-483080'];
data(ismember(data.Receiver,forbiddenReceivers),:)=[];

%%
dataDN = datenum(data.DateAndTime_UTC_);
dataDT = datetime(dataDN,'convertFrom','datenum');

%FM 3/6/23 Ordered the transceivers and doubled some up; this is to match
%the transceiver order listed in "matchAngles"/"thetaFinder"
uniqueReceivers =  [{'VR2Tx-483062';  % 'VR2Tx-483062' SURTASSSTN20
                     'VR2Tx-483073';  % 'VR2Tx-483073' STSNew1
                    'VR2Tx-483075';   % 'VR2Tx-483075' FS6
                    'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN
                    'VR2Tx-483066';   % 'VR2Tx-483066' Roldan
                    'VR2Tx-483076';   % 'VR2Tx-483076' 08ALTIN
                    'VR2Tx-483074';   % 'VR2Tx-483074' STSNew2
                    'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN
                    'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN
                    'VR2Tx-483081';   % 'VR2Tx-483081' 39IN
                    'VR2Tx-483081';   % 'VR2Tx-483081' 39IN
                    'VR2Tx-483075';   % 'VR2Tx-483075' FS6
                    'VR2Tx-483074';   % 'VR2Tx-483074' STSNew2
                    'VR2Tx-483075';}] % 'VR2Tx-483075' FS6

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

% Unique Receivers order: Have to be careful, its not the same as the
% detection information. 
%ReceiverData:
%1. 'VR2Tx-483062' SURTASSSTN20
%2. 'VR2Tx-483064' SURTASS_05IN
%3. 'VR2Tx-483066' Roldan
%4. 'VR2Tx-483070' 08C
%5. 'VR2Tx-483073' STSNew1
%6. 'VR2Tx-483074' STSNew2
%7. 'VR2Tx-483075' FS6
%8. 'VR2Tx-483076' 08ALTIN
%9. 'VR2Tx-483081' 39IN
%10. 
%11.
%12.
%13.
%14.

%Cleared offset for data purposes, can add for visualization
% offset = duration(minutes(30));
% bottomTime = datetime(receiverData{1}.bottomTemp(:,1),'ConvertFrom','datenum','TimeZone','UTC')+offset;

for PT = 1:length(uniqueReceivers)
    startTime = [datetime(receiverData{1,PT}.bottomTemp(1,1),'ConvertFrom','datenum','TimeZone','UTC'); datetime(receiverData{1,PT}.bottomTemp(end,1),'ConvertFrom','datenum','TimeZone','UTC')];
    bottomTime{PT} = datetime(receiverData{PT}.bottomTemp(:,1),'ConvertFrom','datenum','TimeZone','UTC');
    botIndex       = isbetween(bottomTime{PT},startTime(1,1),startTime(2,1));
    bottom{PT} = timetable(bottomTime{PT}(botIndex),receiverData{PT}.bottomTemp(botIndex,2),receiverData{PT}.hourlyDets(botIndex,2),receiverData{PT}.tilt(botIndex,2),receiverData{PT}.avgNoise(botIndex,2),receiverData{PT}.pings(botIndex,2));
    bottom{PT}.Properties.VariableNames = {'botTemp','Detections','Tilt','Noise','Pings'};
    bottom{PT}.Tilt(bottom{PT}.Tilt>70) = 0;
end





% clear detectionIndex PT noiseIndex pingIndex detectionIndex tempIndex forbiddenReceivers data dataDN bottomTime startTime

%cutting seas down 
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
% figure()
% plot(bottom.bottomTime,buoyStratification);
%% 
%This section gives us "leftovers", a measure of how many disconnected
%pings we have as a measure for failed transmissions
useDets = receiverData{1,1}.hourlyDets;
usePings = receiverData{1,1}.pings;

%Step by step
%Turns my disjointed pings into "detections"
pingsGrouped = usePings(:,2)./8;

%Calculates how many of the detections are false: Although 64pings/8dets =
%8, if we only had recorded 7 detections, those 8 extra pings must be
%recorded differently. This step should do that.
falseDets = pingsGrouped-useDets(:,2);

%turns the leftover detections back into single pings by multiplying by 8,
%the conversion factor.
leftoversDT = datetime(usePings(:,1),'ConvertFrom','datenum','TimeZone','UTC');

leftovers = falseDets.*8;



