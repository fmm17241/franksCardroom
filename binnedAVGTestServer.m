%TESTING EDIT FMFMFMF


figure()
SunriseSunsetUTC
%Day timing
sunRun = [sunrise; sunset];

%Tidal predictions, rotated to be along vs cross-shore. Uses tideDT,
%rotUtide
tidalAnalysis2020

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

fullTideData = [rotUtide(fullTideIndex);rotVtide(fullTideIndex)]
fullTideData = fullTideData(:,1:2:end);

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
fullData = table2timetable(table(time, seasonCounter', detsAlong,detsCross,dets45, sunlight', rotUwinds(windsIndex), rotVwinds(windsIndex), WSPD(windsIndex), WDIR(windsIndex), fullTideData',noise,waveHt.waveHeight));
fullData.Properties.VariableNames = {'season', 'detsAlong','detsCross','dets45','sunlight', 'windsCross','windsAlong','windSpeed','windDir','tidalData','noise','waveHeight'};
%ALSO HAVE: 
% detections{}
% bottomStats: have tilt and bottom temp, can be stratification.



clearvars -except fullData detections time bottom* receiverData

%%
%Okay. Doable. Leggo.


seasons = unique(fullData.season)

for season = 1:length(seasons)
    windBins{season}(1,:) = fullData.windSpeed < 1 & fullData.season == season;
    windBins{season}(2,:) = fullData.windSpeed > 1 & fullData.windSpeed < 2 & fullData.season ==season;
    windBins{season}(3,:) = fullData.windSpeed > 2 & fullData.windSpeed < 3 & fullData.season ==season;
    windBins{season}(4,:) = fullData.windSpeed > 3 & fullData.windSpeed < 4 & fullData.season ==season;
    windBins{season}(5,:) = fullData.windSpeed > 4 & fullData.windSpeed < 5 & fullData.season ==season;
    windBins{season}(6,:) = fullData.windSpeed > 5 & fullData.windSpeed < 6 & fullData.season ==season;
    windBins{season}(7,:) = fullData.windSpeed > 6 & fullData.windSpeed < 7 & fullData.season ==season;
    windBins{season}(8,:) = fullData.windSpeed > 7 & fullData.windSpeed < 8 & fullData.season ==season;
    windBins{season}(9,:) = fullData.windSpeed > 8 & fullData.windSpeed < 9 & fullData.season ==season;
    windBins{season}(10,:) = fullData.windSpeed > 9 & fullData.windSpeed < 10 & fullData.season ==season;
    windBins{season}(11,:) = fullData.windSpeed > 10 & fullData.windSpeed < 11 & fullData.season ==season;
    windBins{season}(12,:) = fullData.windSpeed > 11 & fullData.windSpeed < 12 & fullData.season ==season;
    windBins{season}(13,:) = fullData.windSpeed > 12 & fullData.windSpeed < 13 & fullData.season ==season;
    windBins{season}(14,:) = fullData.windSpeed > 13 & fullData.windSpeed < 14 & fullData.season ==season;
    windBins{season}(15,:) = fullData.windSpeed > 14 & fullData.season ==season;
end

%%

% average = zeros(1,height(windBins))
for seasonBin = 1:length(seasons)
    for k = 1:height(windBins{1})
        windScenario{seasonBin}{k}= fullData(windBins{seasonBin}(k,:),:);
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

figure()
scatter(x,wavesCompareX)



%%
clearvars -except fullData

seasons = unique(fullData.season)
for k = 1:length(seasons)
    tideBinsX{k}(1,:) = fullData.tidalData(:,1) < -.4 & fullData.season ==k;
    tideBinsX{k}(2,:) =  fullData.tidalData(:,1) > -.4 &  fullData.tidalData(:,1) < -.35 & fullData.season ==k;
    tideBinsX{k}(3,:) =  fullData.tidalData(:,1) > -.35 &  fullData.tidalData(:,1) < -.30 & fullData.season ==k;
    tideBinsX{k}(4,:) =  fullData.tidalData(:,1) > -.30 & fullData.tidalData(:,1) <-.25 & fullData.season ==k;
    tideBinsX{k}(5,:) =  fullData.tidalData(:,1) > -.25 &  fullData.tidalData(:,1) < -.20 & fullData.season ==k;
    tideBinsX{k}(6,:) =  fullData.tidalData(:,1) > -.20 &  fullData.tidalData(:,1) < -.15 & fullData.season ==k;
    tideBinsX{k}(7,:) =  fullData.tidalData(:,1) > -.15 &  fullData.tidalData(:,1) < -.10 & fullData.season ==k;
    tideBinsX{k}(8,:) =  fullData.tidalData(:,1) > -.1 &  fullData.tidalData(:,1) < -.05 & fullData.season ==k;
    tideBinsX{k}(9,:) =  fullData.tidalData(:,1) > -.05 &  fullData.tidalData(:,1) < 0.05 & fullData.season ==k;
%     tideBinsX{k}(10,:) = fullData.tidalData(:,1) < .05 &  fullData.tidalData(:,1) > 0 & fullData.season ==k;
    tideBinsX{k}(10,:) =  fullData.tidalData(:,1) > .05 &  fullData.tidalData(:,1) < .1 & fullData.season ==k;
    tideBinsX{k}(11,:) =  fullData.tidalData(:,1) > .1 &  fullData.tidalData(:,1) < .15 & fullData.season ==k;
    tideBinsX{k}(12,:) =  fullData.tidalData(:,1) > .15 & fullData.tidalData(:,1) < .2 & fullData.season ==k;
    tideBinsX{k}(13,:) =  fullData.tidalData(:,1) > .2 &  fullData.tidalData(:,1) < .25 & fullData.season ==k;
    tideBinsX{k}(14,:) =  fullData.tidalData(:,1) > .25&  fullData.tidalData(:,1) < .3 & fullData.season ==k;
    tideBinsX{k}(15,:) =  fullData.tidalData(:,1) > .3 &  fullData.tidalData(:,1) < .35 & fullData.season ==k;
    tideBinsX{k}(16,:) =  fullData.tidalData(:,1) > .35 &  fullData.tidalData(:,1) < .4 & fullData.season ==k;
    tideBinsX{k}(17,:) =  fullData.tidalData(:,1) > .4 & fullData.season ==k;

%Alongshore
    tideBinsAlong{k}(1,:) = fullData.tidalData(:,2) < -.1& fullData.season ==k;
    tideBinsAlong{k}(2,:) = fullData.tidalData(:,2) > -.1 & fullData.tidalData(:,2) < -.09 & fullData.season ==k;
    tideBinsAlong{k}(3,:) = fullData.tidalData(:,2) > -.09 & fullData.tidalData(:,2) < -.08 & fullData.season ==k;
    tideBinsAlong{k}(4,:) = fullData.tidalData(:,2) > -.08 & fullData.tidalData(:,2) < -.07 & fullData.season ==k;
    tideBinsAlong{k}(5,:) = fullData.tidalData(:,2) > -.07 & fullData.tidalData(:,2) < -.06 & fullData.season ==k;
    tideBinsAlong{k}(6,:) = fullData.tidalData(:,2) > -.06 & fullData.tidalData(:,2) < -.05 & fullData.season ==k;
    tideBinsAlong{k}(7,:) = fullData.tidalData(:,2) > -.05 & fullData.tidalData(:,2) < -.04 & fullData.season ==k;
    tideBinsAlong{k}(8,:) = fullData.tidalData(:,2) > -.04 & fullData.tidalData(:,2) < -.03 & fullData.season ==k;
    tideBinsAlong{k}(9,:) = fullData.tidalData(:,2) > -.03 & fullData.tidalData(:,2) < -.02 & fullData.season ==k;
    tideBinsAlong{k}(9,:) = fullData.tidalData(:,2) > -.02 & fullData.tidalData(:,2) < -.01 & fullData.season ==k;

    tideBinsAlong{k}(10,:) = fullData.tidalData(:,2) > -.01 & fullData.tidalData(:,2) < .01 & fullData.season ==k;
    
    tideBinsAlong{k}(11,:) = fullData.tidalData(:,2) > .01 & fullData.tidalData(:,2) < .02 & fullData.season ==k;
    tideBinsAlong{k}(12,:) = fullData.tidalData(:,2) > .02 & fullData.tidalData(:,2) < .03 & fullData.season ==k;
    tideBinsAlong{k}(13,:) = fullData.tidalData(:,2) > .03 & fullData.tidalData(:,2) < .04 & fullData.season ==k;
    tideBinsAlong{k}(14,:) = fullData.tidalData(:,2) > .04 & fullData.tidalData(:,2) < .05 & fullData.season ==k;
    tideBinsAlong{k}(15,:) = fullData.tidalData(:,2) > .05 & fullData.tidalData(:,2) < .06 & fullData.season ==k;
    tideBinsAlong{k}(16,:) = fullData.tidalData(:,2) > .06 & fullData.tidalData(:,2) < .07 & fullData.season ==k;
    tideBinsAlong{k}(17,:) = fullData.tidalData(:,2) > .07 & fullData.tidalData(:,2) < .08 & fullData.season ==k;
    tideBinsAlong{k}(18,:) = fullData.tidalData(:,2) > .08 & fullData.tidalData(:,2) < .09 & fullData.season ==k;
    tideBinsAlong{k}(19,:) = fullData.tidalData(:,2) > .09 & fullData.tidalData(:,2) < .1 & fullData.season ==k;
    tideBinsAlong{k}(20,:) = fullData.tidalData(:,2) > .1 & fullData.season ==k;
end


%I can edit this to choose which seasons. 4 & 5 to compare to 2014
for season = 1:length(seasons)
% for season = 4:5
    for k = 1:height(tideBinsX{season})
        tideScenarioX{season}{k}= fullData(tideBinsX{season}(k,:),:);
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
        tideScenarioA{season}{k}= fullData(tideBinsAlong{season}(k,:),:);
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


%%
% seasons = unique(fullData.season)
% 
% for season = 1:length(seasons)
%     waveBins{season}(1,:) = fullData.waveHeight < .02 & fullData.season == season;
%     waveBins{season}(2,:) = fullData.waveHeight > .02 & fullData.waveHeight < .04 & fullData.season ==season;
%     waveBins{season}(3,:) = fullData.waveHeight > .04 & fullData.waveHeight < .06 & fullData.season ==season;
%     waveBins{season}(4,:) = fullData.waveHeight > .06 & fullData.waveHeight < .08 & fullData.season ==season;
%     waveBins{season}(5,:) = fullData.waveHeight > .08 & fullData.waveHeight < 1 & fullData.season ==season;
%     waveBins{season}(6,:) = fullData.waveHeight > 1.0 & fullData.waveHeight < 1.2 & fullData.season ==season;
%     waveBins{season}(7,:) = fullData.waveHeight > 1.2 & fullData.waveHeight < 1.4 & fullData.season ==season;
%     waveBins{season}(8,:) = fullData.waveHeight > 1.4 & fullData.waveHeight < 1.6 & fullData.season ==season;
%     waveBins{season}(9,:) = fullData.waveHeight > 1.6 & fullData.waveHeight < 1.8 & fullData.season ==season;
%     waveBins{season}(10,:) = fullData.waveHeight > 1.8 & fullData.waveHeight < 2.0 & fullData.season ==season;
%     waveBins{season}(11,:) = fullData.waveHeight > 2.0 & fullData.waveHeight < 2.2 & fullData.season ==season;
%     waveBins{season}(12,:) = fullData.waveHeight > 2.2 & fullData.waveHeight < 2.4 & fullData.season ==season;
%     waveBins{season}(13,:) = fullData.waveHeight > 2.4 & fullData.season ==season;
% end
% 
% for season = 1:length(seasons)
%     for k = 1:height(waveBins{season})
%         waveScenario{season}{k}= fullData(waveBins{season}(k,:),:);
%         averageX{season}(1,k) = mean(waveScenario{season}{1,k}.allDets);
%         averagePercentW{season}(1,k) = (averageWave{season}(1,k)/6)*100;
%         if isnan(averagePercentW{season}(1,k))
%             averagePercentW{season}(1,k) = 0;
%             continue
%         end
%     end
%     moddedPercentW{season}  = averagePercentW{season}/(max(averagePercentW{season}));
% end
% 
% 
% 
% 
% 
% 
% 

