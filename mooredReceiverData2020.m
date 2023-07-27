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
                    'VR2Tx-483081';}] % 'VR2Tx-483081' 39IN

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
