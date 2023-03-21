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
matchAnglesFlipped
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

seasons = unique(fullData{1}.season)

% clearvars -except fullData detections time bottom* receiverData fullTide*

%%
%Okay. now I have to convert all to go through all the transceiver pairs,
%not just the cross and along. Aight, got this, bodybag

% clearvars -except fullData fullTide*

%Changing this from just seasons to different transceiver pairings +
%seasons


for COUNT= 1:length(fullData)
    for k = 1:length(seasons)
        %Parallel: X-axis of our tides, aligned with transmissions
        tideBinsPara{COUNT}{k}(1,:) = fullData{COUNT}.paraTide < -.4 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(2,:) =  fullData{COUNT}.paraTide > -.4 &  fullData{COUNT}.paraTide < -.35 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(3,:) =  fullData{COUNT}.paraTide > -.35 &  fullData{COUNT}.paraTide < -.30 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(4,:) =  fullData{COUNT}.paraTide > -.30 & fullData{COUNT}.paraTide <-.25 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(5,:) =  fullData{COUNT}.paraTide > -.25 &  fullData{COUNT}.paraTide < -.20 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(6,:) =  fullData{COUNT}.paraTide > -.20 &  fullData{COUNT}.paraTide < -.15 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(7,:) =  fullData{COUNT}.paraTide > -.15 &  fullData{COUNT}.paraTide < -.10 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(8,:) =  fullData{COUNT}.paraTide > -.1 &  fullData{COUNT}.paraTide < -.05 & fullData{COUNT}.season ==k;

        tideBinsPara{COUNT}{k}(9,:) =  fullData{COUNT}.paraTide > -.05 &  fullData{COUNT}.paraTide < 0.05 & fullData{COUNT}.season ==k;

        tideBinsPara{COUNT}{k}(10,:) =  fullData{COUNT}.paraTide > .05 &  fullData{COUNT}.paraTide < .1 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(11,:) =  fullData{COUNT}.paraTide > .10 &  fullData{COUNT}.paraTide < .15 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(12,:) =  fullData{COUNT}.paraTide > .15 & fullData{COUNT}.paraTide < .2 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(13,:) =  fullData{COUNT}.paraTide > .20 &  fullData{COUNT}.paraTide < .25 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(14,:) =  fullData{COUNT}.paraTide > .25 &  fullData{COUNT}.paraTide < .3 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(15,:) =  fullData{COUNT}.paraTide > .30 &  fullData{COUNT}.paraTide < .35 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(16,:) =  fullData{COUNT}.paraTide > .35 &  fullData{COUNT}.paraTide < .4 & fullData{COUNT}.season ==k;
        tideBinsPara{COUNT}{k}(17,:) =  fullData{COUNT}.paraTide > .40 & fullData{COUNT}.season ==k;
    
    %Perpendicular: Y-axis of our tides, perpendicular to transmissions
        tideBinsPerp{COUNT}{k}(1,:) = fullData{COUNT}.perpTide < -.40  & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(2,:) = fullData{COUNT}.perpTide > -.40 & fullData{COUNT}.perpTide < -.35 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(3,:) = fullData{COUNT}.perpTide > -.35 & fullData{COUNT}.perpTide < -.30 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(4,:) = fullData{COUNT}.perpTide > -.30 & fullData{COUNT}.perpTide < -.25 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(5,:) = fullData{COUNT}.perpTide > -.25 & fullData{COUNT}.perpTide < -.20 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(6,:) = fullData{COUNT}.perpTide > -.20 & fullData{COUNT}.perpTide < -.15 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(7,:) = fullData{COUNT}.perpTide > -.15 & fullData{COUNT}.perpTide < -.10 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(8,:) = fullData{COUNT}.perpTide > -.10 & fullData{COUNT}.perpTide < -.05 & fullData{COUNT}.season ==k;

        tideBinsPerp{COUNT}{k}(9,:) = fullData{COUNT}.perpTide > -.05 & fullData{COUNT}.perpTide < 0.05 & fullData{COUNT}.season ==k;

        tideBinsPerp{COUNT}{k}(10,:) = fullData{COUNT}.perpTide > .05 & fullData{COUNT}.perpTide < .10 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(11,:) = fullData{COUNT}.perpTide > .10 & fullData{COUNT}.perpTide < 0.15 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(12,:) = fullData{COUNT}.perpTide > .15 & fullData{COUNT}.perpTide < .20 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(13,:) = fullData{COUNT}.perpTide > .20 & fullData{COUNT}.perpTide < .25 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(14,:) = fullData{COUNT}.perpTide > .25 & fullData{COUNT}.perpTide < .30 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(15,:) = fullData{COUNT}.perpTide > .30 & fullData{COUNT}.perpTide < .35 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(16,:) = fullData{COUNT}.perpTide > .35 & fullData{COUNT}.perpTide < .40 & fullData{COUNT}.season ==k;
        tideBinsPerp{COUNT}{k}(17,:) = fullData{COUNT}.perpTide > .40 & fullData{COUNT}.season ==k;
    end
end


%I can edit this to choose which seasons. 4 & 5 to compare to 2014
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(tideBinsPara{COUNT}{season})
            tideScenarioPara{COUNT}{season}{k}= fullData{COUNT}(tideBinsPara{COUNT}{season}(k,:),:);
            tideScenarioPerp{COUNT}{season}{k}= fullData{COUNT}(tideBinsPerp{COUNT}{season}(k,:),:);
            averageParaTide{COUNT}{season}(1,k) = mean(tideScenarioPara{COUNT}{season}{1,k}.detections);
%             averageTilt{COUNT}{season}(1,k) = mean(tideScenarioPara{COUNT}{season}{1,k}.tilt);
%             averagePerpTide{COUNT}{season}(1,k) = mean(tideScenarioPerp{COUNT}{season}{1,k}.detections);
            if isnan(averageParaTide{COUNT}{season}(1,k))
                averageParaTide{COUNT}{season}(1,k) = 0;
            end
%             if isnan(averagePerpTide{COUNT}{season}(1,k))
%                 averagePerpTide{COUNT}{season}(1,k) = 0;
%             end
        end
        normalizedPara{COUNT}{season}  = averageParaTide{COUNT}{season}/(max(averageParaTide{COUNT}{season}));
%         normalizedPerp{COUNT}{season}  = averagePerpTide{COUNT}{season}/(max(averagePerpTide{COUNT}{season}));
    end
end

for COUNT = 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter = [averageParaTide{COUNT}{season},averageParaTide{COUNT+1}{season}]
        normalizedPara{COUNT}{season}  = averageParaTide{COUNT}{season}/(max(comboPlatter));
        normalizedPara{COUNT+1}{season}  = averageParaTide{COUNT+1}{season}/(max(comboPlatter));
    end
end



for COUNT = 1:length(normalizedPara)
    for season = 1:length(seasons)
        allPara{COUNT}(season,:) = normalizedPara{COUNT}{season};
%         completePerp{COUNT}(season,:) = normalizedPerp{COUNT}{season};
    end
end

%Whole year
for COUNT = 1:length(allPara)
    yearlyParaAVG{COUNT} = mean(allPara{COUNT},1)
%     yearlyPerpAVG(COUNT,:) = mean(completePerp{COUNT},1)
end

%%

%These find absolute value for the tidal directions; this is to compare the
% two different directions.

for COUNT= 1:length(fullData)
    for k = 1:length(seasons)
        %Parallel: X-axis of our tides, aligned with transmissions

        tideBinsParaABS{COUNT}{k}(1,:) =  abs(fullData{COUNT}.paraTide) < 0.05 & fullData{COUNT}.season ==k;

        tideBinsParaABS{COUNT}{k}(2,:) =  abs(fullData{COUNT}.paraTide) > .05 &  abs(fullData{COUNT}.paraTide) < .1 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(3,:) =  abs(fullData{COUNT}.paraTide) > .10 &  abs(fullData{COUNT}.paraTide)< .15 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(4,:) =  abs(fullData{COUNT}.paraTide)> .15 & abs(fullData{COUNT}.paraTide)< .2 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(5,:) =  abs(fullData{COUNT}.paraTide)> .20 &  abs(fullData{COUNT}.paraTide)< .25 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(6,:) =  abs(fullData{COUNT}.paraTide)> .25 &  abs(fullData{COUNT}.paraTide)< .3 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(7,:) =  abs(fullData{COUNT}.paraTide)> .30 &  abs(fullData{COUNT}.paraTide)< .35 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(8,:) =  abs(fullData{COUNT}.paraTide)> .35 &  abs(fullData{COUNT}.paraTide)< .4 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(9,:) =  abs(fullData{COUNT}.paraTide)> .40 & fullData{COUNT}.season ==k;
    
    %Perpendicular: Y-axis of our tides, perpendicular to transmissions
        tideBinsPerpABS{COUNT}{k}(1,:) = abs(fullData{COUNT}.perpTide) < 0.05 & fullData{COUNT}.season ==k;

        tideBinsPerpABS{COUNT}{k}(2,:) = abs(fullData{COUNT}.perpTide)> .05 & abs(fullData{COUNT}.perpTide)< .10 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(3,:) = abs(fullData{COUNT}.perpTide)> .10 & abs(fullData{COUNT}.perpTide)< 0.15 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(4,:) = abs(fullData{COUNT}.perpTide)> .15 & abs(fullData{COUNT}.perpTide)< .20 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(5,:) = abs(fullData{COUNT}.perpTide)> .20 & abs(fullData{COUNT}.perpTide)< .25 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(6,:) = abs(fullData{COUNT}.perpTide)> .25 & abs(fullData{COUNT}.perpTide)< .30 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(7,:) = abs(fullData{COUNT}.perpTide)> .30 & abs(fullData{COUNT}.perpTide)< .35 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(8,:) = abs(fullData{COUNT}.perpTide)> .35 & abs(fullData{COUNT}.perpTide)< .40 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(9,:) = abs(fullData{COUNT}.perpTide)> .40 & fullData{COUNT}.season ==k;
    end
end

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(tideBinsParaABS{COUNT}{season})
            tideScenarioParaABS{COUNT}{season}{k}= fullData{COUNT}(tideBinsParaABS{COUNT}{season}(k,:),:);
            tideScenarioPerpABS{COUNT}{season}{k}= fullData{COUNT}(tideBinsPerpABS{COUNT}{season}(k,:),:);
            averageParaTideABS{COUNT}{season}(1,k) = mean(tideScenarioParaABS{COUNT}{season}{1,k}.detections);
            averagePerpTideABS{COUNT}{season}(1,k) = mean(tideScenarioPerpABS{COUNT}{season}{1,k}.detections);
            if isnan(averageParaTideABS{COUNT}{season}(1,k))
                averageParaTideABS{COUNT}{season}(1,k) = 0;
            end
            if isnan(averagePerpTideABS{COUNT}{season}(1,k))
                averagePerpTideABS{COUNT}{season}(1,k) = 0;
            end
        end
%         if isempty(averageParaTide{COUNT}{season}) ==1
%             moddedAveragePara{COUNT}{season}  = 0;
%             moddedAveragePerp{COUNT}{season}  = 0;
%             continue
%         end

    end
end

for COUNT= 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter = [averageParaTideABS{COUNT}{season},averageParaTideABS{COUNT+1}{season}];
        normalizedParaABS{COUNT}{season}  = averageParaTideABS{COUNT}{season}/(max(comboPlatter));
        normalizedParaABS{COUNT+1}{season}  = averageParaTideABS{COUNT+1}{season}/(max(comboPlatter));
    end
end



for COUNT = 1:length(normalizedParaABS)
    for season = 1:length(seasons)
        allParaABS{COUNT}(season,:) = normalizedParaABS{COUNT}{season};
    end
end

%Whole year
for COUNT = 1:length(allParaABS)
    yearlyParaABS{COUNT} = mean(allParaABS{COUNT},1)
end

%%

%Frank is finding standard deviation

%Normal
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(tideBinsPara{COUNT}{season})
            if isempty(tideScenarioPara{COUNT}{season}{1,k}) == 1
                errorData{COUNT}(season,k) = 0;
                continue
            end
            errorData{COUNT}(season,k) = std(tideScenarioPara{COUNT}{season}{1,k}.detections)
        end
    end
end
%Absolute values
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(tideBinsParaABS{COUNT}{season})
            if isempty(tideScenarioParaABS{COUNT}{season}{1,k}) == 1
                errorDataABS{COUNT}(season,k) = 0;
                continue
            end
            errorDataABS{COUNT}(season,k) = std(tideScenarioParaABS{COUNT}{season}{1,k}.detections)
        end
    end
end

%%
%Doing the same for my wind data
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        windSpeedBins{COUNT}{season}(1,:) = fullData{COUNT}.windSpeed < 1 & fullData{COUNT}.season == season;
        windSpeedBins{COUNT}{season}(2,:) = fullData{COUNT}.windSpeed > 1 & fullData{COUNT}.windSpeed < 2 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(3,:) = fullData{COUNT}.windSpeed > 2 & fullData{COUNT}.windSpeed < 3 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(4,:) = fullData{COUNT}.windSpeed > 3 & fullData{COUNT}.windSpeed < 4 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(5,:) = fullData{COUNT}.windSpeed > 4 & fullData{COUNT}.windSpeed < 5 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(6,:) = fullData{COUNT}.windSpeed > 5 & fullData{COUNT}.windSpeed < 6 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(7,:) = fullData{COUNT}.windSpeed > 6 & fullData{COUNT}.windSpeed < 7 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(8,:) = fullData{COUNT}.windSpeed > 7 & fullData{COUNT}.windSpeed < 8 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(9,:) = fullData{COUNT}.windSpeed > 8 & fullData{COUNT}.windSpeed < 9 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(10,:) = fullData{COUNT}.windSpeed > 9 & fullData{COUNT}.windSpeed < 10 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(11,:) = fullData{COUNT}.windSpeed > 10 & fullData{COUNT}.windSpeed < 11 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(12,:) = fullData{COUNT}.windSpeed > 11 & fullData{COUNT}.windSpeed < 12 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(13,:) = fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.windSpeed < 13 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(14,:) = fullData{COUNT}.windSpeed > 13 & fullData{COUNT}.windSpeed < 14 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(15,:) = fullData{COUNT}.windSpeed > 14 & fullData{COUNT}.season ==season;
    end
end


%%

% average = zeros(1,height(windBins))
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(windSpeedBins{COUNT}{season})
            windSpeedScenario{COUNT}{season}{k}= fullData{COUNT}(windSpeedBins{COUNT}{season}(k,:),:);
            averageWindSpeed{COUNT}{season}(1,k) = mean(windSpeedScenario{COUNT}{season}{1,k}.detections);
            noiseCompare{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.noise);
            wavesCompare{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.waveHeight);
            tiltCompareWind{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.tilt);
        end
        normalizedWindSpeed{COUNT}{season}  = averageWindSpeed{COUNT}{season}/(max(averageWindSpeed{COUNT}{season}));
    end
end


for COUNT = 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter = [averageWindSpeed{COUNT}{season},averageWindSpeed{COUNT+1}{season}];
        normalizedWindSpeed{COUNT}{season}  = averageWindSpeed{COUNT}{season}/(max(comboPlatter));
        normalizedWindSpeed{COUNT+1}{season}  = averageWindSpeed{COUNT+1}{season}/(max(comboPlatter));
    end
end


for COUNT = 1:length(normalizedWindSpeed)
    for season = 1:length(seasons)
        completeWinds{COUNT}(season,:) = normalizedWindSpeed{COUNT}{season};
        completeWHeight{COUNT}(season,:) = wavesCompare{COUNT}{season};
        completeNoise{COUNT}(season,:)   = noiseCompare{COUNT}{season};
        completeTiltVsWindSpeed{COUNT}(season,:)   = tiltCompareWind{COUNT}{season};
    end
end


for COUNT = 1:length(completeWinds)
    completeWindsAvg(COUNT,:) = nanmean(completeWinds{COUNT});
    completeTiltVsWindAvg(COUNT,:) = nanmean(completeTiltVsWindSpeed{COUNT})
end

for COUNT = 1:length(completeWindsAvg)
    yearlyWindSpeed(1,COUNT) = mean(completeWindsAvg(:,COUNT));
    yearlyTiltVsWindSpeed(1,COUNT) = mean(completeTiltVsWindAvg(:,COUNT));
end







%%
%TILTED TOWERS LET'S GOOOOO

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        tiltBins{COUNT}{season}(1,:) = fullData{COUNT}.tilt < 2 & fullData{COUNT}.season == season;
        tiltBins{COUNT}{season}(2,:) = fullData{COUNT}.tilt > 2 & fullData{COUNT}.tilt < 4 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(3,:) = fullData{COUNT}.tilt > 4 & fullData{COUNT}.tilt < 6 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(4,:) = fullData{COUNT}.tilt > 6 & fullData{COUNT}.tilt < 8 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(5,:) = fullData{COUNT}.tilt > 8 & fullData{COUNT}.tilt < 10 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(6,:) = fullData{COUNT}.tilt > 10 & fullData{COUNT}.tilt < 12 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(7,:) = fullData{COUNT}.tilt > 12 & fullData{COUNT}.tilt < 14 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(8,:) = fullData{COUNT}.tilt > 14 & fullData{COUNT}.tilt < 16 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(9,:) = fullData{COUNT}.tilt > 16 & fullData{COUNT}.tilt < 18 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(10,:) = fullData{COUNT}.tilt > 18 & fullData{COUNT}.tilt < 20 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(11,:) = fullData{COUNT}.tilt > 20 & fullData{COUNT}.tilt < 22 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(12,:) = fullData{COUNT}.tilt > 22 & fullData{COUNT}.season ==season;
    end
end


%%

% average = zeros(1,height(tiltBins))
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(tiltBins{COUNT}{season})
            tiltScenario{COUNT}{season}{k}= fullData{COUNT}(tiltBins{COUNT}{season}(k,:),:);
            averageTilt{COUNT}{season}(1,k) = mean(tiltScenario{COUNT}{season}{1,k}.detections);
            if isnan(averageTilt{COUNT}{season}(1,k))
                averageTilt{COUNT}{season}(1,k) = 0;
            end
        end

    end
end

for COUNT = 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter = [averageTilt{COUNT}{season},averageTilt{COUNT+1}{season}];
        normalizedTilt{COUNT}{season}  = averageTilt{COUNT}{season}/(max(comboPlatter));
        normalizedTilt{COUNT+1}{season}  = averageTilt{COUNT+1}{season}/(max(comboPlatter));
    end
end


for COUNT = 1:length(normalizedTilt)
    for season = 1:length(seasons)
        completeTilt{COUNT}(season,:) = normalizedTilt{COUNT}{season};
    end
end


for COUNT = 1:length(completeTilt)
    completeTiltAvg(COUNT,:) = nanmean(completeTilt{COUNT});
end

for COUNT = 1:length(completeTiltAvg)
    yearlyTilt(1,COUNT) = mean(completeTiltAvg(:,COUNT))
end


%%
%Wind direction bins!


for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        windDirBins{COUNT}{season}(1,:) = fullData{COUNT}.windDir < 20 & fullData{COUNT}.season == season;
        windDirBins{COUNT}{season}(2,:) = fullData{COUNT}.windDir > 20 & fullData{COUNT}.windDir < 40 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(3,:) = fullData{COUNT}.windDir > 40 & fullData{COUNT}.windDir < 60 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(4,:) = fullData{COUNT}.windDir > 60 & fullData{COUNT}.windDir < 80 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(5,:) = fullData{COUNT}.windDir > 80 & fullData{COUNT}.windDir < 100 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(6,:) = fullData{COUNT}.windDir > 100 & fullData{COUNT}.windDir < 120 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(7,:) = fullData{COUNT}.windDir > 120 & fullData{COUNT}.windDir < 140 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(8,:) = fullData{COUNT}.windDir > 140 & fullData{COUNT}.windDir < 160 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(9,:) = fullData{COUNT}.windDir > 160 & fullData{COUNT}.windDir < 180 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(10,:) = fullData{COUNT}.windDir > 180 & fullData{COUNT}.windDir < 200 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(11,:) = fullData{COUNT}.windDir > 200 & fullData{COUNT}.windDir < 220 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(12,:) = fullData{COUNT}.windDir > 220 & fullData{COUNT}.windDir < 240 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(13,:) = fullData{COUNT}.windDir > 240 & fullData{COUNT}.windDir < 260 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(14,:) = fullData{COUNT}.windDir > 260 & fullData{COUNT}.windDir < 280 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(15,:) = fullData{COUNT}.windDir > 280 & fullData{COUNT}.windDir < 300 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(16,:) = fullData{COUNT}.windDir > 300 & fullData{COUNT}.windDir < 320 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(17,:) = fullData{COUNT}.windDir > 320 & fullData{COUNT}.windDir < 340 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(18,:) = fullData{COUNT}.windDir > 340 & fullData{COUNT}.season ==season;
    end
end


%%

% average = zeros(1,height(windBins))
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(windDirBins{COUNT}{season})
            windDirScenario{COUNT}{season}{k}= fullData{COUNT}(windDirBins{COUNT}{season}(k,:),:);
            averagewindDir{COUNT}{season}(1,k) = mean(windDirScenario{COUNT}{season}{1,k}.detections);
            tiltCompareWindDir{COUNT}{season}(k) = mean(windDirScenario{COUNT}{season}{1,k}.tilt);
        end
    end
end

for COUNT = 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter = [averagewindDir{COUNT}{season},averagewindDir{COUNT+1}{season}];
        normalizedwindDir{COUNT}{season}  = averagewindDir{COUNT}{season}/(max(comboPlatter));
        normalizedwindDir{COUNT+1}{season}  = averagewindDir{COUNT+1}{season}/(max(comboPlatter));
    end
end




for COUNT = 1:length(normalizedwindDir)
    for season = 1:length(seasons)
        completeWindDir{COUNT}(season,:) = normalizedwindDir{COUNT}{season};
        completeTiltVswindDir{COUNT}(season,:)   = tiltCompareWindDir{COUNT}{season};
    end
end


for COUNT = 1:length(completeWindDir)
    completeWindsDirAvg(COUNT,:) = nanmean(completeWindDir{COUNT});
    completeTiltVsWindDirAvg(COUNT,:) = nanmean(completeTiltVswindDir{COUNT})
end

for COUNT = 1:length(completeWindsDirAvg)
    yearlywindDir(1,COUNT) = mean(completeWindsDirAvg(:,COUNT));
    yearlyTiltVswindDir(1,COUNT) = mean(completeTiltVsWindDirAvg(:,COUNT));
end


