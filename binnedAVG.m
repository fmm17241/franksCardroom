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
matchAngles
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


%Lets start at 2020-01-29 16:30, ending on 2020-12-17 22:30
fullTime = [datetime(2020,01,29,17,00,00),datetime(2020,12,10,13,00,00)];
fullTime.TimeZone = 'UTC';

fullTideIndex = isbetween(tideDT,fullTime(1,1),fullTime(1,2),'closed');

tideDT = tideDT(fullTideIndex);
tideDT = tideDT(1:2:end);
rotUtide = rotUtide(:,fullTideIndex);
rotUtide = rotUtide(:,1:2:end);
rotVtide = rotVtide(:,fullTideIndex);
rotVtide = rotVtide(:,1:2:end);

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
xx = length(sunRun);
sunlight = zeros(1,height(time));
for k = 1:xx
    currentSun = sunRun(:,k);
    currentHours = isbetween(time,currentSun(1,1),currentSun(2,1));
    currentDays = find(currentHours);
    sunlight(currentDays) = 1;
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
    fullData{COUNT} = table2timetable(table(time, seasonCounter', detections{COUNT},  sunlight', rotUwinds, rotVwinds, WSPD, WDIR, rotUtide(COUNT,:)',...
        rotVtide(COUNT,:)', bottomStats{COUNT}.Noise,bottomStats{COUNT}.Tilt,waveHt.waveHeight));
    fullData{COUNT}.Properties.VariableNames = {'season', 'detections','sunlight', 'windsCross','windsAlong','windSpeed','windDir','paraTide','perpTide','noise','tilt','waveHeight'};
end

clearvars -except fullData detections time bottom* receiverData fullTide*

%%
%Okay. now I have to convert all to go through all the transceiver pairs,
%not just the cross and along. Aight, got this, bodybag

clearvars -except fullData fullTide*

%Changing this from just seasons to different transceiver pairings +
%seasons
seasons = unique(fullData{1}.season)

for COUNT= 1:length(fullData)
    for k = 1:length(seasons)
        %Parallel: X-axis of our tides, aligned with transmissions
        tideBinsParallel{COUNT}{k}(1,:) = fullData{COUNT}.paraTide < -.4 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(2,:) =  fullData{COUNT}.paraTide > -.4 &  fullData{COUNT}.paraTide < -.35 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(3,:) =  fullData{COUNT}.paraTide > -.35 &  fullData{COUNT}.paraTide < -.30 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(4,:) =  fullData{COUNT}.paraTide > -.30 & fullData{COUNT}.paraTide <-.25 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(5,:) =  fullData{COUNT}.paraTide > -.25 &  fullData{COUNT}.paraTide < -.20 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(6,:) =  fullData{COUNT}.paraTide > -.20 &  fullData{COUNT}.paraTide < -.15 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(7,:) =  fullData{COUNT}.paraTide > -.15 &  fullData{COUNT}.paraTide < -.10 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(8,:) =  fullData{COUNT}.paraTide > -.1 &  fullData{COUNT}.paraTide < -.05 & fullData{COUNT}.season ==k;

        tideBinsParallel{COUNT}{k}(9,:) =  fullData{COUNT}.paraTide > -.05 &  fullData{COUNT}.paraTide < 0.05 & fullData{COUNT}.season ==k;

        tideBinsParallel{COUNT}{k}(10,:) =  fullData{COUNT}.paraTide > .05 &  fullData{COUNT}.paraTide < .1 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(11,:) =  fullData{COUNT}.paraTide > .10 &  fullData{COUNT}.paraTide < .15 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(12,:) =  fullData{COUNT}.paraTide > .15 & fullData{COUNT}.paraTide < .2 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(13,:) =  fullData{COUNT}.paraTide > .20 &  fullData{COUNT}.paraTide < .25 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(14,:) =  fullData{COUNT}.paraTide > .25 &  fullData{COUNT}.paraTide < .3 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(15,:) =  fullData{COUNT}.paraTide > .30 &  fullData{COUNT}.paraTide < .35 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(16,:) =  fullData{COUNT}.paraTide > .35 &  fullData{COUNT}.paraTide < .4 & fullData{COUNT}.season ==k;
        tideBinsParallel{COUNT}{k}(17,:) =  fullData{COUNT}.paraTide > .40 & fullData{COUNT}.season ==k;
    
    %Perpendicular: Y-axis of our tides, perpendicular to transmissions
        tideBinsPerpendicular{COUNT}{k}(1,:) = fullData{COUNT}.perpTide < -.40  & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(2,:) = fullData{COUNT}.perpTide > -.40 & fullData{COUNT}.perpTide < -.35 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(3,:) = fullData{COUNT}.perpTide > -.35 & fullData{COUNT}.perpTide < -.30 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(4,:) = fullData{COUNT}.perpTide > -.30 & fullData{COUNT}.perpTide < -.25 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(5,:) = fullData{COUNT}.perpTide > -.25 & fullData{COUNT}.perpTide < -.20 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(6,:) = fullData{COUNT}.perpTide > -.20 & fullData{COUNT}.perpTide < -.15 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(7,:) = fullData{COUNT}.perpTide > -.15 & fullData{COUNT}.perpTide < -.10 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(8,:) = fullData{COUNT}.perpTide > -.10 & fullData{COUNT}.perpTide < -.05 & fullData{COUNT}.season ==k;

        tideBinsPerpendicular{COUNT}{k}(9,:) = fullData{COUNT}.perpTide > -.05 & fullData{COUNT}.perpTide < 0.05 & fullData{COUNT}.season ==k;

        tideBinsPerpendicular{COUNT}{k}(10,:) = fullData{COUNT}.perpTide > .05 & fullData{COUNT}.perpTide < .10 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(11,:) = fullData{COUNT}.perpTide > .10 & fullData{COUNT}.perpTide < 0.15 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(12,:) = fullData{COUNT}.perpTide > .15 & fullData{COUNT}.perpTide < .20 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(13,:) = fullData{COUNT}.perpTide > .20 & fullData{COUNT}.perpTide < .25 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(14,:) = fullData{COUNT}.perpTide > .25 & fullData{COUNT}.perpTide < .30 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(15,:) = fullData{COUNT}.perpTide > .30 & fullData{COUNT}.perpTide < .35 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(16,:) = fullData{COUNT}.perpTide > .35 & fullData{COUNT}.perpTide < .40 & fullData{COUNT}.season ==k;
        tideBinsPerpendicular{COUNT}{k}(17,:) = fullData{COUNT}.perpTide > .40 & fullData{COUNT}.season ==k;
    end
end


%I can edit this to choose which seasons. 4 & 5 to compare to 2014
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(tideBinsParallel{COUNT}{season})
            tideScenarioPara{COUNT}{season}{k}= fullData{COUNT}(tideBinsParallel{COUNT}{season}(k,:),:);
            tideScenarioPerp{COUNT}{season}{k}= fullData{COUNT}(tideBinsPerpendicular{COUNT}{season}(k,:),:);
            averageParaTide{COUNT}{season}(1,k) = mean(tideScenarioPara{COUNT}{season}{1,k}.detections);
            averagePerpTide{COUNT}{season}(1,k) = mean(tideScenarioPerp{COUNT}{season}{1,k}.detections);
            if isnan(averageParaTide{COUNT}{season}(1,k))
                averageParaTide{COUNT}{season}(1,k) = 0;
            end
            if isnan(averagePerpTide{COUNT}{season}(1,k))
                averagePerpTide{COUNT}{season}(1,k) = 0;
            end
        end
%         if isempty(averageParaTide{COUNT}{season}) ==1
%             moddedAveragePara{COUNT}{season}  = 0;
%             moddedAveragePerp{COUNT}{season}  = 0;
%             continue
%         end
        moddedAveragePara{COUNT}{season}  = averageParaTide{COUNT}{season}/(max(averageParaTide{COUNT}{season}));
        moddedAveragePerp{COUNT}{season}  = averagePerpTide{COUNT}{season}/(max(averagePerpTide{COUNT}{season}));
    end
end


for COUNT = 1:length(moddedAveragePara)
    for season = 1:length(seasons)
        completePara{COUNT}(season,:) = moddedAveragePara{COUNT}{season};
        completePerp{COUNT}(season,:) = moddedAveragePerp{COUNT}{season};
    end
end

%Whole year
for COUNT = 1:length(completePara)
    yearlyParaAVG{COUNT} = mean(completePara{COUNT},1)
    yearlyPerpAVG{COUNT} = mean(completePerp{COUNT},1)
end



%%
%Plotting efforts now belong in "paraPerpPlots"

