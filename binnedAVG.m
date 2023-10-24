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


time = waveHt.time;
test = zeros(length(time),1);

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

%%
%FM 10/14
%Adding a distance column. Just going to try it, so that when I add them
%all to the stats table, I can include the distance between transceivers
%SURTASSSTN20 and STSNew1
load mooredGPS 

pairingAngle(1,:) = repelem(atan2d((mooredGPS(2,2)-mooredGPS(15,2)),(mooredGPS(2,1)-mooredGPS(15,1))),length(detections{1}));
pairingAngle(2,:) = repelem(atan2d((mooredGPS(15,2)-mooredGPS(2,2)),(mooredGPS(15,1)-mooredGPS(2,1))),length(detections{1}));
%SURTASS05IN and FS6
pairingAngle(3,:) = repelem(atan2d((mooredGPS(14,2)-mooredGPS(12,2)),(mooredGPS(14,1)-mooredGPS(12,1))),length(detections{2}));
pairingAngle(4,:) = repelem(atan2d((mooredGPS(12,2)-mooredGPS(14,2)),(mooredGPS(12,1)-mooredGPS(14,1))),length(detections{2}));
%Roldan and 08ALTIN
pairingAngle(5,:) = repelem(atan2d((mooredGPS(7,2)-mooredGPS(6,2)),(mooredGPS(7,1)-mooredGPS(6,1))),length(detections{3}));
pairingAngle(6,:) = repelem(atan2d((mooredGPS(6,2)-mooredGPS(7,2)),(mooredGPS(6,1)-mooredGPS(7,1))),length(detections{3}));
%SURTASS05IN and STSNew2
pairingAngle(7,:) = repelem(atan2d((mooredGPS(14,2)-mooredGPS(11,2)),(mooredGPS(14,1)-mooredGPS(11,1))),length(detections{4}));
pairingAngle(8,:) = repelem(atan2d((mooredGPS(11,2)-mooredGPS(14,2)),(mooredGPS(11,1)-mooredGPS(14,1))),length(detections{4}));
%39IN and SURTASS05IN
pairingAngle(9,:) = repelem(atan2d((mooredGPS(14,2)-mooredGPS(13,2)),(mooredGPS(14,1)-mooredGPS(13,1))),length(detections{5}));
pairingAngle(10,:) = repelem(atan2d((mooredGPS(13,2)-mooredGPS(14,2)),(mooredGPS(13,1)-mooredGPS(14,1))),length(detections{5}));


distances(1,:) = repelem(lldistkm(mooredGPS(2,:),mooredGPS(15,:)),length(detections{1}));
distances(2,:) = repelem(lldistkm(mooredGPS(15,:),mooredGPS(2,:)),length(detections{1}));
distances(3,:) = repelem(lldistkm(mooredGPS(14,:),mooredGPS(12,:)),length(detections{2}));
distances(4,:) = repelem(lldistkm(mooredGPS(14,:),mooredGPS(12,:)),length(detections{2}));
distances(5,:) = repelem(lldistkm(mooredGPS(7,:),mooredGPS(6,:)),length(detections{3}));
distances(6,:) = repelem(lldistkm(mooredGPS(7,:),mooredGPS(6,:)),length(detections{3}));
distances(7,:) = repelem(lldistkm(mooredGPS(14,:),mooredGPS(11,:)),length(detections{4}));
distances(8,:) = repelem(lldistkm(mooredGPS(14,:),mooredGPS(11,:)),length(detections{4}));
distances(9,:) = repelem(lldistkm(mooredGPS(13,:),mooredGPS(14,:)),length(detections{5}));
distances(10,:) = repelem(lldistkm(mooredGPS(13,:),mooredGPS(14,:)),length(detections{5}));


%%



%Okay, basics are set.
close all

%Set length to 10; last 2 were far less detections and time deployed.
%Not helpful.
% for COUNT = 1:10
%     fullData{COUNT} = table2timetable(table(time, seasonCounter', detections{COUNT},  sunlight', rotUwinds, rotVwinds, WSPD, WDIR, stratification{COUNT}, ut', vt', rotUtide(COUNT,:)',...
%         rotVtide(COUNT,:)',rotUtideShore',rotVtideShore', bottomStats{COUNT}.Noise,bottomStats{COUNT}.Tilt,waveHt.waveHeight,distances(COUNT,:),pairingAngle(COUNT,:)));
%     fullData{COUNT}.Properties.VariableNames = {'season', 'detections','sunlight', 'windsCross','windsAlong','windSpeed','windDir','stratification','uTide','vTide','paraTide','perpTide','uShore','vShore','noise','tilt','waveHeight','distance','angle'};
% end
FRANK FIX THE TWO VARIABLES, TRANSPOSE

for COUNT = 1:10
    fullData{COUNT} = table2timetable(table(time, seasonCounter', detections{COUNT},  sunlight', rotUwinds, rotVwinds, WSPD, WDIR, stratification{COUNT}, ut', vt', rotUtide(COUNT,:)',...
        rotVtide(COUNT,:)',rotUtideShore',rotVtideShore', bottomStats{COUNT}.Noise,bottomStats{COUNT}.Tilt,waveHt.waveHeight));
    fullData{COUNT}.Properties.VariableNames = {'season', 'detections','sunlight', 'windsCross','windsAlong','windSpeed','windDir','stratification','uTide','vTide','paraTide','perpTide','uShore','vShore','noise','tilt','waveHeight'};
end


seasons = unique(fullData{1}.season)


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


