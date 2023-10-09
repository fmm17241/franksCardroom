%Workspace
%Creates diurnal data
figure()
SunriseSunsetUTC
%Day timing
sunRun = [sunrise; sunset];



load mooredGPS 
% transmitters = {'63068' '63073' '63067' '63079' '63080' '63066' '63076' '63078' '63063'...
%         '63070' '63074' '63075' '63081' '63064' '63062' '63071'};
%     
% moored = {'FS17','STSNew1','33OUT','34ALTOUT','09T','Roldan',...
%           '08ALTIN','14IN','West15','08C','STSNew2','FS6','39IN','SURTASS_05IN',...
%           'SURTASS_STN20','SURTASS_FS15'}.';
%       
%       
figure()
scatter(mooredGPS(:,2),mooredGPS(:,1),'k');      
xlabel('Longitude');
ylabel('Latitude');
axis equal
hold on
scatter(mooredGPS(11:14,2),mooredGPS(11:14,1),'k','filled');  
% legend('Moored Acoustic Transmitters');


%diskm
test = lldistkm(mooredGPS(13,:),mooredGPS(12,:))




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

ArrayTidalAnalysis
ArrayWindsAnalysis
fullTime = [datetime(2020,01,29,17,00,00),datetime(2020,12,10,13,00,00)];
fullTime.TimeZone = 'UTC';

fullTideIndex = isbetween(tideDT,fullTime(1,1),fullTime(1,2),'closed');

tideDT = tideDT(fullTideIndex);
tideDT = tideDT(1:2:end);
ut       = ut(:,fullTideIndex);
ut       = ut(:,1:2:end);
vt       = vt(:,fullTideIndex);
vt       = vt(:,1:2:end);
rotUtide = rotUtide(:,fullTideIndex);
rotUtide = rotUtide(:,1:2:end);
rotVtide = rotVtide(:,fullTideIndex);
rotVtide = rotVtide(:,1:2:end);

rotUtideShore = rotUtideShore(:,fullTideIndex);
rotUtideShore = rotUtideShore(:,1:2:end);
rotVtideShore = rotVtideShore(:,fullTideIndex);
rotVtideShore = rotVtideShore(:,1:2:end);


% % fullTideData = [rotUtide(fullTideIndex);rotVtide(fullTideIndex)];
% % fullTideData = fullTideData(:,1:2:end);

windsIndex = isbetween(windsAverage.time,fullTime(1,1),fullTime(1,2),'closed');
rotUwinds = rotUwinds(windsIndex); rotVwinds= rotVwinds(windsIndex); WSPD = WSPD(windsIndex); WDIR = WDIR(windsIndex);
waveIndex = isbetween(waveHeight.time,fullTime(1,1),fullTime(1,2),'closed');
waveHt = waveHeight(waveIndex,"waveHeight")
%%


time = waveHt.time;
test = zeros(length(time),1);



%Experiment 1, compare two moored transceivers 0.53km away
%For our purposes, Mooring 1 will be SURTASSTN20, deeper transceiver central to an array, and Mooring 2 will be
%STSNew1, more shallow transceiver. Yes, numbers above may be confusing, good observation, but I
%gotta keep them straight. If I lose that numbering, all of this is for naught and I may join the circus.

cd ([oneDrive,'Moored\GRNMS\VRLs'])
% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Moored\GRNMS\VRLs'

% call = readtable('VR2Tx_483080_20211223_1.csv'); %SURTASSSTN20
rawDetFile{1,1} = readtable('VR2Tx_483064_20211025_1.csv'); %SURTASS05IN
rawDetFile{2,1} = readtable('VR2Tx_483074_20211025_1.csv'); %STSNEW2
rawDetFile{3,1} = readtable('VR2Tx_483075_20211025_1.csv'); %FS6
rawDetFile{4,1} = readtable('VR2Tx_483081_20211005_1.csv'); %39IN

%First pairing: SURTASS05IN and FS6
%Second pairing: SURTASS05IN and STSNew2
%Third pairing: 39IN and SURTASS05IN
%Fourth pairing: 39IN and FS6
%Fifth pairing: STSNEW2 and FS6

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
index{1} = mooredReceivers{3,1}.detections == 63064; %FS6 hearing SURTASS05In, transmits ENE
index{2} = mooredReceivers{1,1}.detections == 63075; %SURTASS05In hearing FS6, transmits WSW

%Second pairing
index{3} = mooredReceivers{2,1}.detections == 63064; % STSNEW2 hearing SURTASS05IN, transmits NW to SE
index{4} = mooredReceivers{1,1}.detections == 63074; % SURTASS05IN hearing STSNEW2, transmits SE to NW

%Third pairing
index{5} = mooredReceivers{1,1}.detections == 63081; % SURTASS05IN hearing 39IN, transmits NW to SE
index{6} = mooredReceivers{4,1}.detections == 63064; % 39IN hearing SURTASS05IN, transmits SE to NW

%Fourth Pairing
index{7} = mooredReceivers{4,1}.detections == 63075; %39IN hearing FS6
index{8} = mooredReceivers{3,1}.detections == 63081; %FS6 hearing 39IN

%Fifth pairing
index{9} = mooredReceivers{2,1}.detections == 63075; %STSNew2 hearing FS6
index{10} = mooredReceivers{3,1}.detections == 63074; %FS6 hearing STSNew2



%FM this is my "key" for the index. I didn't want to load data twice so
%this key tells the loop which order to use
receiverOrder = [3;1;2;1;1;4;4;3;2;3];
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
    useTime{k} = mooredReceivers{recNumber,1}.DT(index{k});
    detections{k} = ones(length(mooredReceivers{recNumber,1}.detections(index{k})),1);
    detectionTable{k} = table(useTime{1,k},detections{1,k}); 
    detectionTable{k}.Properties.VariableNames = {'time','detections'};
    detectionTable{k} = table2timetable(detectionTable{k});

    hourlyDetections{k} = retime(detectionTable{k},'hourly','sum');
    if length(hourlyDetections{k}.time) < 7581
        useIt = timetable(time,zeros(length(time),1))
        middleGround = synchronize(useIt,hourlyDetections{k})
        test1 = isnan(middleGround.Var1);
        test2 = isnan(middleGround.detections);
        middleGround.Var1(test1) = 0;
        middleGround.detections(test2) = 0;
        clear hourlyDetections{k}
        hourlyDetections{k} = timetable(middleGround.time,middleGround.Var1+middleGround.detections);
        hourlyDetections{k}.Properties.DimensionNames{1} = 'time'
%         hourlyDetections{k}.Properties.VariableNames = 'detections'
        hourlyDetections{k} = renamevars(hourlyDetections{k},"Var1","detections")
    end
    
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


clear fullsst* timeVectorsst


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
uniqueReceivers =  [{'VR2Tx-483075';   % 'VR2Tx-483075' FS6
                    'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN
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
%%

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

for COUNT = 1:length(hourlyDetections)
    fullDetsIndex{COUNT} = isbetween(hourlyDetections{COUNT}.time,fullTime(1,1),fullTime(1,2),'closed');
end

clearvars detections

for COUNT = 1:length(fullDetsIndex)
    detTimes{COUNT}   = [hourlyDetections{COUNT}.time(fullDetsIndex{COUNT})];
    detections{COUNT} = [hourlyDetections{COUNT}.detections(fullDetsIndex{COUNT})];
end

close all
% RANKFRANK Fix Buoy Stratification, any NaNs?

for COUNT = 1:length(bottom)
    stratIndex = isbetween(bottom{COUNT}.Time,fullTime(1,1),fullTime(1,2),'closed');
    bottomStats{COUNT} = bottom{COUNT}(stratIndex,:);
%     fixInd = isnan(buoyStats{COUNT}.botTemp)
%     buoyStratification{COUNT}(fixInd) = 0;
%     fullStratData{COUNT} = buoyStats{COUNT}(stratIndex);
end

% for COUNT = 1:length()
time = waveHt.time;


%creating daylight variable
% xx = length(sunRun);
% sunlight = zeros(1,height(time));
% for k = 1:xx
%     currentSun = sunRun(:,k);
%     currentHours = isbetween(time,currentSun(1,1),currentSun(2,1));
%     currentDays = find(currentHours);
%     sunlight(currentDays) = 1;
% end

%Testing additional light variable

xx = length(sunRun);
sunlight = zeros(1,height(time));
for k = 1:xx
    currentSun = sunRun(:,k);
    currentHours = isbetween(time,currentSun(1,1),currentSun(2,1)-hours(1)); %FM 7/1
    currentDays = find(currentHours);
    sunlight(currentDays) = 1;
    sunsetHourIndex = isbetween(time,currentSun(2,1)-hours(1),currentSun(2,1));
    sunlight(sunsetHourIndex) = 2;
end



%creating season variable
%%Five seasonal wind regimes from Blanton's wind, 1980
% Winter:           Nov-Feb
winter  = [1:751,6632:7581];
% Spring:           Mar-May
spring   = 752:2959;
% Summer:           June, July
summer   = 2960:4423;
% Fall:             August
fall     = 4424:5167;
% Mariner's Fall:   Sep-Oct
Mfall    =5168:6631;

seasonCounter = zeros(1,length(time));
seasonCounter(winter) = 1; seasonCounter(spring) = 2; seasonCounter(summer) = 3; seasonCounter(fall) = 4; seasonCounter(Mfall) = 5;

%Okay, basics are set.
close all

%Set length to 14

for COUNT = 1:10
    fullData{COUNT} = table2timetable(table(time, seasonCounter', detections{COUNT},  sunlight', rotUwinds, rotVwinds, WSPD, WDIR, stratification{COUNT}, ut', vt', rotUtide(COUNT,:)',...
        rotVtide(COUNT,:)',rotUtideShore',rotVtideShore', bottomStats{COUNT}.Noise,bottomStats{COUNT}.Tilt,waveHt.waveHeight));
    fullData{COUNT}.Properties.VariableNames = {'season', 'detections','sunlight', 'windsCross','windsAlong','windSpeed','windDir','stratification','uTide','vTide','paraTide','perpTide','uShore','vShore','noise','tilt','waveHeight'};
end

seasons = unique(fullData{1}.season)

%%
%Leaving This Here, Frank's Okay, He'll do it
% uniqueReceivers =  [{
%                     'VR2Tx-483075';   % 'VR2Tx-483075' FS6
%                     'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN
%                     'VR2Tx-483074';   % 'VR2Tx-483074' STSNew2
%                     'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN
%                     'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN
%                     'VR2Tx-483081';   % 'VR2Tx-483081' 39IN
%                     'VR2Tx-483081';   % 'VR2Tx-483081' 39IN
%                     'VR2Tx-483075';   % 'VR2Tx-483075' FS6
%                     'VR2Tx-483074';   % 'VR2Tx-483074' STSNew2
%                     'VR2Tx-483075';}] % 'VR2Tx-483075' FS6

% uniqueReceivers =  [{'VR2Tx-483075';   % 'VR2Tx-483075' FS6
%                     'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN
%                     'VR2Tx-483074';   % 'VR2Tx-483074' STSNew2
%                     'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN
%                     'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN
%                     'VR2Tx-483081';   % 'VR2Tx-483081' 39IN
%                     'VR2Tx-483081';   % 'VR2Tx-483081' 39IN
%                     'VR2Tx-483075';   % 'VR2Tx-483075' FS6
%                     'VR2Tx-483074';   % 'VR2Tx-483074' STSNew2
%                     'VR2Tx-483075';}] % 'VR2Tx-483075' FS6


%DEPTHS
receiverDepths(1,:)   = [17.68, 16.76, 16.46, 16.76, 16.76, 15.85, 15.85, 17.68, 16.46, 17.68]; %Instrument depth
receiverDepths(2,:)   = [19.81, 18.29, 18.59, 18.29, 18.29, 17.68, 17.68, 19.81, 18.59, 19.81]; %Bottom Depth
receiverDepths(3,:)   = receiverDepths(2,:)-receiverDepths(1,:)  %Meters off the bottom



for K = 1:length(fullData)
    figure()
    hist(fullData{1,K}.tilt)
    title(sprintf('TILT,%d,ReceiverDepth: %.2f; BottomDepth: %.2f',K,receiverDepths(1,K),receiverDepths(2,K)))
    xlim([0 40])

    tiltAverage(1,K) = mean(fullData{1,K}.tilt)
    detsAverage(1,K) = (mean(fullData{1,K}.detections))
    detsPercent(1,K) = detsAverage(1,K)/6*100
end
% 
% figure()
% scatter(receiverDepths(3,:),tiltAverage,'filled')
% xlabel('Difference b/w Bottom and Receiver (m)')
% ylabel('Average Tilt of Instrument (deg)')
% title('Bottom Gap vs Tilt')
% 
% 
% figure()
% scatter(receiverDepths(2,:),tiltAverage,'filled')
% title('Bottom Depth')
% xlabel('Bottom Depth(m)')
% ylabel('Average Tilt of Instrument (deg)')
% 
% figure()
% scatter(receiverDepths(1,:),tiltAverage,'filled')
% title('Instrument Depth')
% xlabel('Receiver Depth (m)')
% ylabel('Average Tilt of Instrument (deg)')
% 
% 
% 
% figure()
% scatter(receiverDepths(3,:),detsAverage,'filled')
% xlabel('Difference b/w Bottom and Receiver (m)')
% ylabel('Average Detections')
% title('Bottom Gap vs Dets')
% hold on
% scatter(receiverDepths(3,4),detsAverage(4),'filled','r')
%%

createWindSpeedBins
windMagPlots    
%
createTideBins


