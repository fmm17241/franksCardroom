%Frank's current work: trying to have one code that runs through and grabs
%hourly data for all my transceiver pairings. This way I can recreate
%Catherine's 2016 graphs.

%Creates diurnal data
figure()
SunriseSunsetUTC
%Day timing
sunRun = [sunrise; sunset];


%Tidal predictions, rotated to be parallel and perpendicular. Uses tideDT,
%rotUtide{} is parallel to transmissions and rotVtide{} is perpendicular.

%FRANK THIS IS ALREADY FLIPPED, YOOOO
tidalAnalysis2020
close all

%Detections between specific transceiver pairs. Uses
%hourlyDetections{X}.time/detections
mooredEfficiency

%Thermal stratification between transceiver temperature measurements and
%NOAA buoy SST measurements. Uses bottom{}....bottomTime, buoyStratification,
%tilt, and leftovers (disconnected pings, measure of transmission
%failure)
%bottom{}
mooredReceiverData2020


%Winds magnitude and direction from the buoy. Uses windsDN/U/V.
windsAnalysis2020
%12/22 added "waveHeight" for waveheight.


% close all

%Okay, Frank. Instead of plotting every hour for 2 weeks/months/whatever,
%we've got to average it out. Example: all the times when the wind is
%between 0-1, what's avg dets?
% our Variables:
% Tidal Currents: tideDT, rotUtide, rotVtide
% Detections:  hourlyDetections{}.time,  hourlyDetections{}.detections
% Stratification: bottom.bottomTime, buoyStratification
% Winds: windsDT, windsU, windsV, rotUwinds, rotVwinds, WSPD, WDIR
% Waveheight: seas.waveHeight
% Tilt: bottom.tilt


%Lets start at 2020-01-29 17:00, ending on 2020-12-10 13:00:00
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

for COUNT = 1:length(hourlyDetections)
    fullDetsIndex{COUNT} = isbetween(hourlyDetections{COUNT}.time,fullTime(1,1),fullTime(1,2),'closed');
end

clearvars detections time

for COUNT = 1:length(fullDetsIndex)
    detTimes{COUNT}   = [hourlyDetections{COUNT}.time(fullDetsIndex{COUNT})];
    detections{COUNT} = [hourlyDetections{COUNT}.detections(fullDetsIndex{COUNT})];
end

%For FM purposes, this is now useless; I've rotated all tides to account
%for transceiver orientation.
% detsAlong1 = [detections{1:2}]; detsAlong = mean(detsAlong1,2);
% detsAlong1 = [detections{3:4}]; detsAlong = mean(detsAlong1,2);
% detsCross1 = [detections{7:10}]; detsCross = mean(detsCross1,2);
% dets451     = [detections{1:2},detections{5:6}]; dets45 = mean(dets451,2);

time = waveHt.time;


%FRANKFRANKFRANK Fix Buoy Stratification, any NaNs?

for COUNT = 1:length(bottom)
    stratIndex = isbetween(bottom{COUNT}.Time,fullTime(1,1),fullTime(1,2),'closed');
    bottomStats{COUNT} = bottom{COUNT}(stratIndex,:);
%     fixInd = isnan(buoyStats{COUNT}.botTemp)
%     buoyStratification{COUNT}(fixInd) = 0;
%     fullStratData{COUNT} = buoyStats{COUNT}(stratIndex);
end

% for COUNT = 1:length()



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
    currentHours = isbetween(time,currentSun(1,1),currentSun(2,1)-hours(1));
    currentDays = find(currentHours);
    sunsetting = isbetween(time,currentSun(2,1)-hours(1),currentSun(2,1));
    sunrising = isbetween(time,currentSun(1,1)-hours(1),currentSun(1,1));
    crepuscular = find(sunsetting);
    sunrise     = find(sunrising);
    sunlight(currentDays) = 1;
    sunlight(crepuscular) = 2;
    sunlight(sunrising)   = 2;
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

%Set length to 10; last 2 were far less detections and time deployed.
%Not helpful.
for COUNT = 1:10
    fullData{COUNT} = table2timetable(table(time, seasonCounter', detections{COUNT},  sunlight', rotUwinds, rotVwinds, WSPD, WDIR, stratification{COUNT}, ut', vt', rotUtide(COUNT,:)',...
        rotVtide(COUNT,:)',rotUtideShore',rotVtideShore', bottomStats{COUNT}.Noise,bottomStats{COUNT}.Tilt,waveHt.waveHeight));
    fullData{COUNT}.Properties.VariableNames = {'season', 'detections','sunlight', 'windsCross','windsAlong','windSpeed','windDir','stratification','uTide','vTide','paraTide','perpTide','uShore','vShore','noise','tilt','waveHeight'};
end

seasons = unique(fullData{1}.season)


% clearvars -except fullData detections time bottom* receiverData fullTide*
for COUNT = 1:length(fullData)
    index{1,COUNT} = sunlight ==1;
    index{2,COUNT} = sunlight ==2;
    index{3,COUNT} = sunlight ==0;
    day{COUNT}    = fullData{COUNT}(index{1,COUNT},:)
    night{COUNT}  = fullData{COUNT}(index{3,COUNT},:)
    crepuscular{COUNT} = fullData{COUNT}(index{2,COUNT},:)
    dayDets(COUNT,:)    = day{COUNT}.detections;
    nightDets(COUNT,:)  = night{COUNT}.detections;
    sunsetDets(COUNT,:) = crepuscular{COUNT}.detections;
    daySounds(COUNT,:)     =day{COUNT}.noise;
    nightSounds(COUNT,:)   = night{COUNT}.noise;
    sunsetSounds(COUNT,:)  =crepuscular{COUNT}.noise;
end

noiseDay1    = mean(daySounds,1);
noiseNight1  = mean(nightSounds,1);
noiseSunset1 = mean(sunsetSounds,1);
noiseDay    = mean(noiseDay1,'all')
noiseNight  = mean(noiseNight1,'all')
noiseSunset = mean(noiseSunset1,'all')
avgDay1    = mean(dayDets,1)
avgNight1  = mean(nightDets,1)
avgSunset1 = mean(sunsetDets,1)
avgDay    = mean(avgDay1,'all')
avgNight  = mean(avgNight1,'all')
avgSunset = mean(avgSunset1,'all')

errDay    = std(avgDay1);

errNight  = std(avgNight1);
errSunset = std(avgSunset1);


x = 1:length(dayDets(1,:));
x1 = 1:length(nightDets(1,:));
x2 = 1:length(sunsetDets(1,:));

figure()
hold on
scatter(day{1}.time,avgDay1,'r','filled')
scatter(night{1}.time,avgNight1,'b','filled')
scatter(crepuscular{1}.time,avgSunset1,'k','filled')


figure()
scatter(1,avgDay,'r','filled')
hold on
scatter(2,avgSunset,'b','filled')
scatter(3,avgNight,'k','filled')
errorbar(1,avgDay,errDay,'LineStyle','none')
errorbar(2,avgSunset,errSunset,'LineStyle','none')
errorbar(3,avgNight,errNight,'LineStyle','none')
ylim([0 4])
xlim([0.9 3.1])



%%
%Frank separated all the bin creation to not clutter one massive script
%with so many different goals.

% createTideBins
% createTideBinsABS
% createTiltBins
% createWindSpeedBins
% createWindDirBins
% 
% % The big'un. Looking to bin by both tide and wind directions.
% AxisAndAllies   


for COUNT=1:length(fullData)
    sumD(COUNT) = sum(fullData{COUNT}.detections);
end


