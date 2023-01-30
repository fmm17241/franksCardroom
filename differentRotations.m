%TESTING EDIT FMFMFMF


figure()
SunriseSunsetUTC
%Day timing
sunRun = [sunrise; sunset];

%Tidal predictions, rotated to be along vs cross-shore. Uses tideDT,
%rotUtide
% tidalAnalysis2020
%OKAY: Now looking to test the new rotations. Rather than using
%tidalAnalysis2020, we have:
matchAngles

%....which gives us 12 different X and Y arrays for the currents. Just need
%to adjust how we move forward, we dont just have U and V, we have
%U(1:12,10k+) and V(1:12,10k+).



mooredReceiverData2020
%Detections with one transceiver pair, ~0.53 km. Uses
%hourlyDetections{X}.time/detections
mooredEfficiency
% experiment1
% reefAverage

%Thermal stratification between transceiver temperature measurements and
%NOAA buoy SST measurements. Uses bottom.bottomTime, buoyStratification,
%bottom.tilt, and leftovers (disconnected pings, measure of transmission
%failure)


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

% fullTideData = [paraTide(:,fullTideIndex);perpTide(:,fullTideIndex)]
% fullTideData = fullTideData(:,1:2:end);
for COUNT = 1:length(fullTideData)
    fullTideData{COUNT} = fullTideData{COUNT}(:,fullTideIndex)
    fullTideData{COUNT} = fullTideData{COUNT}(:,1:2:end);

end



windsIndex = isbetween(windsAverage.time,fullTime(1,1),fullTime(1,2),'closed');
fullWindsData = [windsU(windsIndex) windsV(windsIndex) rotUwinds(windsIndex) rotVwinds(windsIndex) WSPD(windsIndex) WDIR(windsIndex)];
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

% detsAlong1 = [detections{1:2}]; detsAlong = mean(detsAlong1,2);
detsAlong1 = [detections{3:4}]; detsAlong = mean(detsAlong1,2);
detsCross1 = [detections{7:10}]; detsCross = mean(detsCross1,2);
dets451     = [detections{1:2},detections{5:6}]; dets45 = mean(dets451,2);

time = waveHt.time;


%FRANKFRANKFRANK Fix Buoy Stratification, any NaNs?

for COUNT = 1:length(bottom)
    stratIndex = isbetween(bottom{COUNT}.Time,fullTime(1,1),fullTime(1,2),'closed');
    bottomStats{COUNT} = bottom{COUNT}(stratIndex,:);
%     fixInd = isnan(buoyStats{COUNT}.botTemp)
%     buoyStratification{COUNT}(fixInd) = 0;
%     fullStratData{COUNT} = buoyStats{COUNT}(stratIndex);
end


noiseIndex = isbetween(datetime(receiverData{1,1}.avgNoise(:,1),'ConvertFrom','datenum','TimeZone','UTC'),fullTime(1,1),fullTime(1,2),'closed');
noise = receiverData{1,1}.avgNoise(noiseIndex,2);


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
%1/30/23, Need to change this to all of the different transceiver pairings;
%shouldn't be too crazy of a change but many chances for FM to messup.
for COUNT = 1:length(Angles)
    fullData{COUNT} = table2timetable(table(time, seasonCounter', detsAlong,detsCross,dets45, sunlight', rotUwinds(windsIndex), rotVwinds(windsIndex), WSPD(windsIndex), WDIR(windsIndex), fullTideData{COUNT}',noise,waveHt.waveHeight));
    fullData{COUNT}.Properties.VariableNames = {'season', 'detsAlong','detsCross','dets45','sunlight', 'windsCross','windsAlong','windSpeed','windDir','tidalData','noise','waveHeight'};
end


%ALSO HAVE: 
% detections{}
% bottomStats: have tilt and bottom temp, can be stratification.



clearvars -except fullData detections time bottom* receiverData

%%
%Okay. Doable. Leggo.


seasons = unique(fullData{COUNT}.season)

for season = 1:length(seasons)
    windBins{season}(1,:) = fullData{COUNT}.windSpeed < 1 & fullData{COUNT}.season == season;
    windBins{season}(2,:) = fullData{COUNT}.windSpeed > 1 & fullData{COUNT}.windSpeed < 2 & fullData{COUNT}.season ==season;
    windBins{season}(3,:) = fullData{COUNT}.windSpeed > 2 & fullData{COUNT}.windSpeed < 3 & fullData{COUNT}.season ==season;
    windBins{season}(4,:) = fullData{COUNT}.windSpeed > 3 & fullData{COUNT}.windSpeed < 4 & fullData{COUNT}.season ==season;
    windBins{season}(5,:) = fullData{COUNT}.windSpeed > 4 & fullData{COUNT}.windSpeed < 5 & fullData{COUNT}.season ==season;
    windBins{season}(6,:) = fullData{COUNT}.windSpeed > 5 & fullData{COUNT}.windSpeed < 6 & fullData{COUNT}.season ==season;
    windBins{season}(7,:) = fullData{COUNT}.windSpeed > 6 & fullData{COUNT}.windSpeed < 7 & fullData{COUNT}.season ==season;
    windBins{season}(8,:) = fullData{COUNT}.windSpeed > 7 & fullData{COUNT}.windSpeed < 8 & fullData{COUNT}.season ==season;
    windBins{season}(9,:) = fullData{COUNT}.windSpeed > 8 & fullData{COUNT}.windSpeed < 9 & fullData{COUNT}.season ==season;
    windBins{season}(10,:) = fullData{COUNT}.windSpeed > 9 & fullData{COUNT}.windSpeed < 10 & fullData{COUNT}.season ==season;
    windBins{season}(11,:) = fullData{COUNT}.windSpeed > 10 & fullData{COUNT}.windSpeed < 11 & fullData{COUNT}.season ==season;
    windBins{season}(12,:) = fullData{COUNT}.windSpeed > 11 & fullData{COUNT}.windSpeed < 12 & fullData{COUNT}.season ==season;
    windBins{season}(13,:) = fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.windSpeed < 13 & fullData{COUNT}.season ==season;
    windBins{season}(14,:) = fullData{COUNT}.windSpeed > 13 & fullData{COUNT}.windSpeed < 14 & fullData{COUNT}.season ==season;
    windBins{season}(15,:) = fullData{COUNT}.windSpeed > 14 & fullData{COUNT}.season ==season;
end

%%

% average = zeros(1,height(windBins))
for seasonBin = 1:length(seasons)
    for k = 1:height(windBins{1})
        windScenario{seasonBin}{k}= fullData{COUNT}(windBins{seasonBin}(k,:),:);
        averageWindX{seasonBin}(1,k) = mean(windScenario{seasonBin}{1,k}.detsCross);
        noiseCompareWX{seasonBin}(k) = mean(windScenario{seasonBin}{1,k}.noise);
        wavesCompareWX{seasonBin}(k) = mean(windScenario{seasonBin}{1,k}.waveHeight)
%         averageCrossTest{seasonBin}(k) = averagePercentCross{seasonBin}(k)^2
    end
    normalizedWindX{seasonBin}  = averageWindX{seasonBin}/(max(averageWindX{seasonBin}));
end


for seasonBin = 1:length(seasons)
    for k = 1:height(windBins{1})
        averageWindA{seasonBin}(1,k) = mean(windScenario{seasonBin}{1,k}.detsAlong);
        noiseCompareWA{seasonBin}(k) = mean(windScenario{seasonBin}{1,k}.noise);
        wavesCompareWA{seasonBin}(k) = mean(windScenario{seasonBin}{1,k}.waveHeight)
%         averageAlongTest{seasonBin}(k) = averagePercentAlong{seasonBin}(k)^2
    end
    normalizedWindA{seasonBin}  = averageWindA{seasonBin}/(max(averageWindA{seasonBin}));
end

for COUNT = 1:length(normalizedWindA)
% for COUNT = 4:5
    completeAlong(COUNT,:) = normalizedWindA{COUNT};
    completeCross(COUNT,:) = normalizedWindX{COUNT};
    completeWHeightX(COUNT,:) = wavesCompareWX{COUNT};
    completeWHeightA(COUNT,:) = wavesCompareWA{COUNT};
end
for COUNT = 1:length(completeAlong)
    completeAlongAvg = nanmean(completeAlong,1)
    completeCrossAvg = nanmean(completeCross,1)
    completeWHeightAvgX = nanmean(completeWHeightX,1)
    completeWHeightAvgA = nanmean(completeWHeightA,1)
end


%Count up hours spent in bins
startCount = zeros(5,15);
for season = 1:length(seasons)
    for COUNT = 1:height(windBins{1})
        startCount(season,COUNT) = height(windScenario{season}{COUNT})
    end
end

countEm = sum(startCount,1);



x = 0.5:14.5;
figure()

scatter(x,completeAlongAvg,'r','filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
hold on
scatter(x,completeCrossAvg,'b','filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
xlabel('Windspeed (m/s)');
ylabel('Normalized Detections');
legend({'Along-Pairs','Cross-Pairs'});
title('2020 Cross and Alongshore Pairs');



x = 0.5:14.5;
figure()
scatter(x,normalizedWindX{1},'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
hold on
for COUNT = 2:length(seasons)
    scatter(x,normalizedWindX{COUNT},'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')
title('Normalized Detections, 2020 Cross-shore Transceiver Pairings')
ylabel('Normalized Detections')
xlabel('Windspeed, m/s')

x = 0.5:14.5;
figure()
scatter(x,normalizedWindA{1},'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
hold on
for COUNT = 2:length(seasons)
    scatter(x,normalizedWindA{COUNT},'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')
title('Normalized Detections, 2020 Along-shore Transceiver Pairings')
ylabel('Normalized Detections')
xlabel('Windspeed, m/s')

x = 0.5:14.5;
figure()
scatter(x,completeAlongAvg,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
hold on
scatter(x,completeCrossAvg,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
legend('Along-Shore Pairs','Cross-Shore Pairs')
title('Normalized Detections, 2020 Transceiver Pairings')
ylabel('Normalized Detections')
xlabel('Windspeed, m/s')

% figure()
% scatter(x,wavesCompareX)



%%
clearvars -except fullData

seasons = 5;
for COUNT = 1:length(fullData)
    for k = 1:length(seasons)
        tideBinsX{COUNT}{k}(1,:) = fullData{COUNT}.tidalData(:,1) < -.4 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(2,:) =  fullData{COUNT}.tidalData(:,1) > -.4 &  fullData{COUNT}.tidalData(:,1) < -.35 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(3,:) =  fullData{COUNT}.tidalData(:,1) > -.35 &  fullData{COUNT}.tidalData(:,1) < -.30 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(4,:) =  fullData{COUNT}.tidalData(:,1) > -.30 & fullData{COUNT}.tidalData(:,1) <-.25 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(5,:) =  fullData{COUNT}.tidalData(:,1) > -.25 &  fullData{COUNT}.tidalData(:,1) < -.20 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(6,:) =  fullData{COUNT}.tidalData(:,1) > -.20 &  fullData{COUNT}.tidalData(:,1) < -.15 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(7,:) =  fullData{COUNT}.tidalData(:,1) > -.15 &  fullData{COUNT}.tidalData(:,1) < -.10 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(8,:) =  fullData{COUNT}.tidalData(:,1) > -.1 &  fullData{COUNT}.tidalData(:,1) < -.05 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(9,:) =  fullData{COUNT}.tidalData(:,1) > -.05 &  fullData{COUNT}.tidalData(:,1) < 0.05 & fullData{COUNT}.season ==k;
    %     tideBinsX{COUNT}{k}(10,:) = fullData{COUNT}.tidalData(:,1) < .05 &  fullData{COUNT}.tidalData(:,1) > 0 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(10,:) =  fullData{COUNT}.tidalData(:,1) > .05 &  fullData{COUNT}.tidalData(:,1) < .1 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(11,:) =  fullData{COUNT}.tidalData(:,1) > .1 &  fullData{COUNT}.tidalData(:,1) < .15 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(12,:) =  fullData{COUNT}.tidalData(:,1) > .15 & fullData{COUNT}.tidalData(:,1) < .2 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(13,:) =  fullData{COUNT}.tidalData(:,1) > .2 &  fullData{COUNT}.tidalData(:,1) < .25 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(14,:) =  fullData{COUNT}.tidalData(:,1) > .25&  fullData{COUNT}.tidalData(:,1) < .3 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(15,:) =  fullData{COUNT}.tidalData(:,1) > .3 &  fullData{COUNT}.tidalData(:,1) < .35 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(16,:) =  fullData{COUNT}.tidalData(:,1) > .35 &  fullData{COUNT}.tidalData(:,1) < .4 & fullData{COUNT}.season ==k;
        tideBinsX{COUNT}{k}(17,:) =  fullData{COUNT}.tidalData(:,1) > .4 & fullData{COUNT}.season ==k;
    
    %Alongshore
        tideBinsAlong{COUNT}{k}(1,:) = fullData{COUNT}.tidalData(:,2) < -.1& fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(2,:) = fullData{COUNT}.tidalData(:,2) > -.1 & fullData{COUNT}.tidalData(:,2) < -.09 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(3,:) = fullData{COUNT}.tidalData(:,2) > -.09 & fullData{COUNT}.tidalData(:,2) < -.08 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(4,:) = fullData{COUNT}.tidalData(:,2) > -.08 & fullData{COUNT}.tidalData(:,2) < -.07 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(5,:) = fullData{COUNT}.tidalData(:,2) > -.07 & fullData{COUNT}.tidalData(:,2) < -.06 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(6,:) = fullData{COUNT}.tidalData(:,2) > -.06 & fullData{COUNT}.tidalData(:,2) < -.05 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(7,:) = fullData{COUNT}.tidalData(:,2) > -.05 & fullData{COUNT}.tidalData(:,2) < -.04 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(8,:) = fullData{COUNT}.tidalData(:,2) > -.04 & fullData{COUNT}.tidalData(:,2) < -.03 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(9,:) = fullData{COUNT}.tidalData(:,2) > -.03 & fullData{COUNT}.tidalData(:,2) < -.02 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(9,:) = fullData{COUNT}.tidalData(:,2) > -.02 & fullData{COUNT}.tidalData(:,2) < -.01 & fullData{COUNT}.season ==k;
    
        tideBinsAlong{COUNT}{k}(10,:) = fullData{COUNT}.tidalData(:,2) > -.01 & fullData{COUNT}.tidalData(:,2) < .01 & fullData{COUNT}.season ==k;
        
        tideBinsAlong{COUNT}{k}(11,:) = fullData{COUNT}.tidalData(:,2) > .01 & fullData{COUNT}.tidalData(:,2) < .02 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(12,:) = fullData{COUNT}.tidalData(:,2) > .02 & fullData{COUNT}.tidalData(:,2) < .03 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(13,:) = fullData{COUNT}.tidalData(:,2) > .03 & fullData{COUNT}.tidalData(:,2) < .04 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(14,:) = fullData{COUNT}.tidalData(:,2) > .04 & fullData{COUNT}.tidalData(:,2) < .05 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(15,:) = fullData{COUNT}.tidalData(:,2) > .05 & fullData{COUNT}.tidalData(:,2) < .06 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(16,:) = fullData{COUNT}.tidalData(:,2) > .06 & fullData{COUNT}.tidalData(:,2) < .07 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(17,:) = fullData{COUNT}.tidalData(:,2) > .07 & fullData{COUNT}.tidalData(:,2) < .08 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(18,:) = fullData{COUNT}.tidalData(:,2) > .08 & fullData{COUNT}.tidalData(:,2) < .09 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(19,:) = fullData{COUNT}.tidalData(:,2) > .09 & fullData{COUNT}.tidalData(:,2) < .1 & fullData{COUNT}.season ==k;
        tideBinsAlong{COUNT}{k}(20,:) = fullData{COUNT}.tidalData(:,2) > .1 & fullData{COUNT}.season ==k;
    end
end


%I can edit this to choose which seasons. 4 & 5 to compare to 2014
for season = 1:length(seasons)
% for season = 4:5
    for k = 1:height(tideBinsX{season})
        tideScenarioX{season}{k}= fullData{COUNT}(tideBinsX{season}(k,:),:);
        averageXX{season}(1,k) = mean(tideScenarioX{season}{1,k}.detsCross);
        averageXA{season}(1,k) = mean(tideScenarioX{season}{1,k}.detsAlong);
        averageX45{season}(1,k) = mean(tideScenarioX{season}{1,k}.dets45);
    end
    moddedAverageXX{season}  = averageXX{season}/(max(averageXX{season}));
    moddedAverageXA{season}  = averageXA{season}/(max(averageXA{season}));
    moddedAverageX45{season}  = averageX45{season}/(max(averageX45{season}));
end

for season = 1:length(seasons)
% for season = 4:5
    for k = 1:height(tideBinsAlong{season})
        tideScenarioA{season}{k}= fullData{COUNT}(tideBinsAlong{season}(k,:),:);
        averageAA{season}(1,k) = mean(tideScenarioA{season}{1,k}.detsAlong);
        averageAX{season}(1,k) = mean(tideScenarioA{season}{1,k}.detsCross);
        averageA45{season}(1,k) = mean(tideScenarioA{season}{1,k}.dets45);
    end
    moddedAverageAA{season}  = averageAA{season}/(max(averageAA{season}));
    moddedAverageAX{season}  = averageAX{season}/(max(averageAX{season}));
    moddedAverageA45{season}  = averageA45{season}/(max(averageA45{season}));
end

for COUNT = 1:length(moddedAverageXX)
% for COUNT = 4:5
    completeAA(COUNT,:) = moddedAverageAA{COUNT};
    completeAX(COUNT,:) = moddedAverageAX{COUNT};
    completeA45(COUNT,:) = moddedAverageA45{COUNT};
    completeXA(COUNT,:) = moddedAverageXA{COUNT};
    completeXX(COUNT,:) = moddedAverageXX{COUNT};
    completeX45(COUNT,:) = moddedAverageX45{COUNT};
end

%Whole year
completeAAavg = nanmean(completeAA,1)
completeAXavg = nanmean(completeAX,1)
completeA45avg = nanmean(completeA45,1)
completeXAavg = nanmean(completeXA,1)
completeXXavg = nanmean(completeXX,1)
completeX45avg = nanmean(completeX45,1)
%Below is for only fall:
% completeAAavg = nanmean(completeAA(4:5,:),1)
% completeAXavg = nanmean(completeAX(4:5,:),1)
% completeXAavg = nanmean(completeXA(4:5,:),1)
% completeXXavg = nanmean(completeXX(4:5,:),1)



seasonName = {'Winter','Spring','Summer','Fall','Mariner''s Fall'}
x = -0.4:0.05:.4;
figure()
scatter(x,moddedAverageXX{1},'filled')
hold on
for k = 2:length(moddedAverageXX)
    scatter(x,moddedAverageXX{k},'filled')
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')
xlim([-.5 .5])
ylim([0 1.1])
% xline(0)
%     legend('Onshore (-)', 'Offshore (+)')
xlabel('Current Magnitude')
ylabel('Normalized Detection Efficiency')
title('2020 XShore current, Xshore Oriented Pairs')


figure()
scatter(x,averageXA{1},'filled')
hold on
for k = 2:length(averageXA)
    scatter(x,averageXA{k},'filled')
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')
xlim([-.5 .5])
ylim([0 1.1])
%     xline(0)
%     legend('Onshore (-)', 'Offshore (+)')
xlabel('Current Magnitude')
ylabel('Normalized Detection Efficiency')
title('2020 XShore current, Ashore Oriented Pairs')


figure()
scatter(x,moddedAverageXA{1},'filled')
hold on
for k = 2:length(moddedAverageXA)
    scatter(x,moddedAverageXA{k},'filled')
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')
xlim([-.5 .5])
ylim([0 1.1])
%     xline(0)
%     legend('Onshore (-)', 'Offshore (+)')
xlabel('Current Magnitude')
ylabel('Normalized Detection Efficiency')
title('2020 XShore current, Ashore Oriented Pairs')


%% 
%Just fall
figure()
scatter(x,moddedAverageXA{4},'filled')
hold on
for k = 5
    scatter(x,moddedAverageXA{k},'filled')
end
legend('Fall','Mariners Fall')
xlim([-.5 .5])
ylim([0 1.1])
%     xline(0)
%     legend('Onshore (-)', 'Offshore (+)')
xlabel('Current Magnitude')
ylabel('Normalized Detection Efficiency')
title('2020 XShore current, Ashore Oriented Pairs')
%%


%
figure()
scatter(x,moddedAverageX45{1},'filled')
hold on
for k = 2:length(moddedAverageX45)
    scatter(x,moddedAverageX45{k},'filled')
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')
xlim([-.5 .5])
ylim([0 1.1])
%     xline(0)
%     legend('Onshore (-)', 'Offshore (+)')
xlabel('Current Magnitude')
ylabel('Normalized Detection Efficiency')
title('2020 XShore current, 45deg Oriented Pairs')

x = -.09:.01:.1;
figure()
scatter(x,moddedAverageAX{1},'filled')
hold on
for k = 2:length(moddedAverageAX)
    scatter(x,moddedAverageAX{k},'filled')
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')
xlim([-.1 .11])
ylim([0 1])
%     xline(0)
%     legend('Onshore (-)', 'Offshore (+)')
    xlabel('Current Magnitude')
    ylabel('Normalized Detection Efficiency')
    title('2020 AShore current, Xshore Oriented Pairs')


figure()
scatter(x,moddedAverageAA{1},'filled')
hold on
for k = 2:length(moddedAverageAA)
    scatter(x,moddedAverageAA{k},'filled')
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')
xlim([-.1 .11])
ylim([0 1.1])
%     xline(0)
%     legend('Onshore (-)', 'Offshore (+)')
xlabel('Current Magnitude')
ylabel('Normalized Detection Efficiency')
title('2020 AShore current, Ashore Oriented Pairs')

figure()
scatter(x,moddedAverageA45{1},'filled')
hold on
for k = 2:length(moddedAverageA45)
    scatter(x,moddedAverageA45{k},'filled')
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')
xlim([-.1 .11])
ylim([0 1.1])
%     xline(0)
%     legend('Onshore (-)', 'Offshore (+)')
xlabel('Current Magnitude')
ylabel('Normalized Detection Efficiency')
title('2020 AShore current, 45deg Oriented Pairs')



x = -.09:.01:.1;
figure()
scatter(x,completeAAavg,'k','filled');
hold on
scatter(x,completeAXavg,'m','filled');
scatter(x,completeA45avg,'o','filled');
legend('Along-Shore','Cross-shore','45');
xlabel('Current Magnitude')
ylabel('Normalized Detection Efficiency')
title('2020year AShore current vs Transceiver Pairs')



x = -0.4:0.05:.4;
figure()
scatter(x,completeXAavg,'r','filled');
hold on
scatter(x,completeXXavg,'b','filled');
scatter(x,completeX45avg,'k','filled');
legend('Along-Shore','Cross-shore','45');
xlabel('Current Magnitude')
ylabel('Normalized Detection Efficiency')
title('2020year XShore current vs Transceiver Pairs')
