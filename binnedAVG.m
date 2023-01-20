%Instead of slicing the data into chunks, this instead moves a window and
%gives us glimpses at chunks of the larger set.

figure()
SunriseSunsetUTC
%Day timing
sunRun = [sunrise; sunset];

%Tidal predictions, rotated to be along vs cross-shore. Uses tideDT,
%rotUtide
tidalAnalysis2020

%Detections with one transceiver pair, ~0.53 km. Uses
%hourlyDetections{X}.time/detections
mooredEfficiency
% experiment1
reefAverage

%Thermal stratification between transceiver temperature measurements and
%NOAA buoy SST measurements. Uses bottom.bottomTime, buoyStratification,
%bottom.tilt, and leftovers (disconnected pings, measure of transmission
%failure)
sstAnalysis2020

%Winds magnitude and direction from the buoy. Uses windsDN/U/V.
windsAnalysis2020
%12/22 added "waveHeight" for waveheight.


close all

%Okay, Frank. Instead of plotting every hour for 2 weeks/months/whatever,
%we've got to average it out. Example: all the times when the wind is
%between 0-1, what's avg dets?
% our Variables:
% Tidal Currents: tideDT, rotUtide, rotVtide
% Detections:  hourlyDetections{2}.time,  hourlyDetections{2}.detections
% Stratification: bottom.bottomTime, buoyStratification
% Winds: windsDT, windsU, windsV, rotUwinds, rotVwinds, WSPD, WDIR

%Lets start at 2020-01-29 16:30, ending on 2020-12-17 22:30
fullTime = [datetime(2020,01,29,17,00,00),datetime(2020,12,17,22,00,00)];
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

clearvars detections
for COUNT = 1:length(fullDetsIndex)
    detTimes{COUNT}   = [hourlyDetections{COUNT}.time(fullDetsIndex{COUNT})]
    detections{COUNT} = [hourlyDetections{COUNT}.detections(fullDetsIndex{COUNT})];
end

%W2E is missing the very bottom hours, adding these as placeholders:
detections{1}(7756:7758) = 0;

stratIndex = isbetween(bottom.bottomTime,fullTime(1,1),fullTime(1,2),'closed');
time = bottom.bottomTime(stratIndex);
fixInd = isnan(buoyStratification)
buoyStratification(fixInd) = 0;
fullStratData = buoyStratification(stratIndex);

noiseIndex = isbetween(datetime(receiverData{1,1}.avgNoise(:,1),'ConvertFrom','datenum','TimeZone','UTC'),fullTime(1,1),fullTime(1,2),'closed')
noise = receiverData{1,1}.avgNoise(noiseIndex,2)


%creating daylight variable
xx = length(sunRun);
sunlight = zeros(1,height(time));
for k = 1:xx
    currentSun = sunRun(:,k);
    currentHours = isbetween(time,currentSun(1,1),currentSun(2,1))
    currentDays = find(currentHours);
    sunlight(currentDays) = 1;
end

%creating season variable
%%Five seasonal wind regimes from Blanton's wind, 1980
% Winter:           Nov-Feb
winter  = [1:751,6632:7758];
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

fullData = table2timetable(table(time, seasonCounter', sunlight', detections{1}, detections{2}, rotUwinds(windsIndex), rotVwinds(windsIndex), WSPD(windsIndex), WDIR(windsIndex), fullTideData', buoyStratification(stratIndex),noise,waveHt.waveHeight));
fullData.Properties.VariableNames = {'season','sunlight','detections1','detections2', 'windsCross','windsAlong','windSpeed','windDir','tidalData','thermalStrat','noise','WaveHeight'};

% clearvars -except fullData

%%
%using this to compare 2014 time periods
% oldTime = [datetime(2020,08,20,16,00,00),datetime(2020,10,12,19,00,00)];
% oldTime.TimeZone = 'UTC';
% 
% oldTest = isbetween(fullData.time,oldTime(1,1),oldTime(1,2))
% oldData = fullData(oldTest,:)
% 
% windBins(1,:) = oldData.windSpeed < 1;
% windBins(2,:) = oldData.windSpeed > 1 & oldData.windSpeed < 2 ;
% windBins(3,:) = oldData.windSpeed > 2 & oldData.windSpeed < 3 ;
% windBins(4,:) = oldData.windSpeed > 3 & oldData.windSpeed < 4 ;
% windBins(5,:) = oldData.windSpeed > 4 & oldData.windSpeed < 5 ;
% windBins(6,:) = oldData.windSpeed > 5 & oldData.windSpeed < 6 ;
% windBins(7,:) = oldData.windSpeed > 6 & oldData.windSpeed < 7 ;
% windBins(8,:) = oldData.windSpeed > 7 & oldData.windSpeed < 8 ;
% windBins(9,:) = oldData.windSpeed > 8 & oldData.windSpeed < 9 ;
% windBins(10,:) = oldData.windSpeed > 9 & oldData.windSpeed < 10 ;
% windBins(11,:) = oldData.windSpeed > 10 & oldData.windSpeed < 11 ;
% windBins(12,:) = oldData.windSpeed > 11 & oldData.windSpeed < 12 ;
% windBins(13,:) = oldData.windSpeed > 12 & oldData.windSpeed < 13 ;
% windBins(14,:) = oldData.windSpeed > 13 & oldData.windSpeed < 14 ;
% windBins(15,:) = oldData.windSpeed > 14 ;
% 
% for k = 1:height(windBins)
%     windScenario{k}= oldData(windBins(k,:),:);
% 
%     average(1,k) = nanmean(windScenario{k}.detectionsE2W);
%     averagePercent(k) = (average(1,k)/6)*100;
% 
%     noiseCompare(k) = nanmean(windScenario{k}.noise);
%     wavesCompare(k) = nanmean(windScenario{k}.WaveHeight)
%     averageTest(k) = averagePercent(k)^2
% end
% 
% for k = 1:length(average)
%     moddedAVG = average/(max(average))
% end
% 
% 
% x = 0.5:14.5;
% figure()
% scatter(x, noiseCompare, averageTest, 'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
% legend('Winter','Spring','Summer','Fall','Mariners Fall')
% xlabel('Windspeed, m/s')
% ylabel('Average Noise (Db)')
% title('Increasing Winds: Less Noise, More Detections')
% 
% 
% figure()
% yyaxis left
% scatter(x,averagePercent,'filled','b','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
% xlabel('Windspeed, m/s')
% ylabel('2020 Detection Efficiency (%)')
% title('2020')

%Verified these numbers are correct for the entire dataset, lined up with
%times. Now we can do some conditional averaging.

%% WINDY DUDES
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

        average{seasonBin}(1,k) = mean(windScenario{seasonBin}{1,k}.detections2);
        averagePercent{seasonBin}(k) = (average{seasonBin}(1,k)/6)*100;

        noiseCompare{seasonBin}(k) = mean(windScenario{seasonBin}{1,k}.noise);
        wavesCompare{seasonBin}(k) = mean(windScenario{seasonBin}{1,k}.WaveHeight)
        averageTest{seasonBin}(k) = averagePercent{seasonBin}(k)^2
    end
end
%%
% 
% for seasonBin = 1:length(seasons)
%     for k =1:length(windScenario{1})
%         howMany(seasonBin,k) = height(windScenario{seasonBin}{1,k});
%     end
% end


% x = 0.5:14.5;
% figure()
% plot(x,howMany{1},'LineWidth',2)
% hold on
% % scatter(x,howMany{1},'filled','k')
% for seasonBin = 2:length(seasons)
%     plot(x,howMany{seasonBin},'LineWidth',2)
% %     scatter(x,howMany{seasonBin},'filled','k')
% end
% legend('Winter','Spring','Summer','Fall','Mariners Fall')
% ylabel('Hours')
% xlabel('Wind Magnitude (1 m/s bins)')
% title('Wind bins: How many hours in each?')


x = 0.5:14.5;
figure()
scatter(x, noiseCompare{1}, averagePercent{1}, 'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
hold on
for count = 2:length(seasons)
    scatter(x, noiseCompare{count}, averagePercent{count}, 'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')
xlabel('Windspeed, m/s')
ylabel('Average Noise (Db)')
title('Increasing Winds: Less Noise, More Detections')


%%
figure()
scatter(noiseCompare{1},averagePercent{1},'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
hold on
for count = 2:length(seasons)
    scatter(noiseCompare{count},averagePercent{count},'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')

%%
x = 0.5:14.5;
figure()
scatter(x, noiseCompare{1}, averageTest{1}, 'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
hold on
for count = 2:length(seasons)
    scatter(x, noiseCompare{count}, averageTest{count}, 'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
end
legend('Winter','Spring','Summer','Fall','Mariners Fall')
xlabel('Windspeed, m/s')
ylabel('Average Noise (Db)')
title('Increasing Winds: Less Noise, More Detections')




%% Tidal Currents
% clearvars average averagePercent
% %Averaging from absolute value of tidal magnitude, Cross-Shore
% tideBinsX(1,:) = fullData.tidalData(:,1) < .05;
% tideBinsX(2,:) = fullData.tidalData(:,1) > .05 & fullData.tidalData(:,1) < .1;
% tideBinsX(3,:) = fullData.tidalData(:,1) > .1 & fullData.tidalData(:,1) < .15;
% tideBinsX(4,:) = fullData.tidalData(:,1) > .15 & fullData.tidalData(:,1) < .2;
% tideBinsX(5,:) = fullData.tidalData(:,1) > .2 & fullData.tidalData(:,1) < .25;
% tideBinsX(6,:) = fullData.tidalData(:,1) > .25 & fullData.tidalData(:,1) < .3;
% tideBinsX(7,:) = fullData.tidalData(:,1) > .3 & fullData.tidalData(:,1) < .35;
% tideBinsX(8,:) = fullData.tidalData(:,1) > .35 & fullData.tidalData(:,1) < .4;
% tideBinsX(9,:) = fullData.tidalData(:,1) > .4
% 
% average = zeros(1,height(tideBinsX));
% for k = 1:height(tideBinsX)
%     tideScenario{k}= fullData(tideBinsX(k,:),:);
%     average(1,k) = mean(tideScenario{1,k}.detectionsE2W);
%     averagePercent(1,k) = (average(1,k)/6)*100;
% end
% 
% x = 0.025:0.05:.425
% figure()
% scatter(x,averagePercent,'filled')
% hold on 
% errorbar(x,averagePercent,std(averagePercent,[],2))
% xlim([0 .45])
% ylim([0 60])
% xlabel('Crossshore Current (m/s)')
% ylabel('Detection Efficiency (%)')
% title('Yearlong Averages, Binned')
% 
% 
% %Averaging from absolute value of tidal magnitude, Along-Shore
% clearvars average averagePercent
% tideBinsAlong(1,:) = fullData.tidalData(:,2) < .01;
% tideBinsAlong(2,:) = fullData.tidalData(:,2) > .01 & fullData.tidalData(:,2) < .02;
% tideBinsAlong(3,:) = fullData.tidalData(:,2) > .02 & fullData.tidalData(:,2) < .03;
% tideBinsAlong(4,:) = fullData.tidalData(:,2) > .03 & fullData.tidalData(:,2) < .04;
% tideBinsAlong(5,:) = fullData.tidalData(:,2) > .04 & fullData.tidalData(:,2) < .05;
% tideBinsAlong(6,:) = fullData.tidalData(:,2) > .05 & fullData.tidalData(:,2) < .06;
% tideBinsAlong(7,:) = fullData.tidalData(:,2) > .06 & fullData.tidalData(:,2) < .07;
% tideBinsAlong(8,:) = fullData.tidalData(:,2) > .07 & fullData.tidalData(:,2) < .08;
% tideBinsAlong(9,:) = fullData.tidalData(:,2) > .08 & fullData.tidalData(:,2) < .09;
% tideBinsAlong(10,:) = fullData.tidalData(:,2) > .09 & fullData.tidalData(:,2) < .1;
% tideBinsAlong(11,:) = fullData.tidalData(:,2) > .1;
% 
% 
% average = zeros(1,height(tideBinsAlong));
% for k = 1:height(tideBinsAlong)
%     tideScenario2{k}= fullData(tideBinsAlong(k,:),:);
%     average(1,k) = mean(tideScenario2{1,k}.detectionsE2W);
%     averagePercent(1,k) = (average(1,k)/6)*100;
% end
% 
% x = .005:.01:.105
% figure()
% scatter(x,averagePercent,'filled')
% hold on 
% errorbar(x,averagePercent,std(averagePercent,[],2))
% xlim([0 .11])
% ylim([10 60])
% xlabel('Alongshore Current (m/s)')
% ylabel('Detection Efficiency (%)')
% title('Yearlong Averages, Binned')

%% ABSOLUTE VALUES
%% Tidal Currents
clearvars average averagePercent
%Averaging from absolute value of tidal magnitude, Cross-Shore
tideBinsX(1,:) = abs(fullData.tidalData(:,1)) < .05 ;
tideBinsX(2,:) =  abs(fullData.tidalData(:,1)) > .05 &  abs(fullData.tidalData(:,1)) < .1;
tideBinsX(3,:) =  abs(fullData.tidalData(:,1)) > .1 &  abs(fullData.tidalData(:,1)) < .15;
tideBinsX(4,:) =  abs(fullData.tidalData(:,1)) > .15 & abs(fullData.tidalData(:,1)) < .2;
tideBinsX(5,:) =  abs(fullData.tidalData(:,1)) > .2 &  abs(fullData.tidalData(:,1)) < .25;
tideBinsX(6,:) =  abs(fullData.tidalData(:,1)) > .25& abs( fullData.tidalData(:,1)) < .3;
tideBinsX(7,:) =  abs(fullData.tidalData(:,1)) > .3 &  abs(fullData.tidalData(:,1)) < .35;
tideBinsX(8,:) =  abs(fullData.tidalData(:,1)) > .35 &  abs(fullData.tidalData(:,1)) < .4;
tideBinsX(9,:) =  abs(fullData.tidalData(:,1)) > .4;

average = zeros(1,height(tideBinsX));
for k = 1:height(tideBinsX)
    tideScenario{k}= fullData(tideBinsX(k,:),:);
    average(1,k) = mean(tideScenario{1,k}.detections2);
    averagePercent1(1,k) = (average(1,k)/6)*100;
end

x1 = 0.025:0.05:.425
figure()
scatter(x1,averagePercent1,'filled')
hold on 
errorbar(x1,averagePercent1,std(averagePercent1,[],2))
xlim([0 .45])
ylim([0 60])
xlabel('Crossshore Current (m/s,absValue)')
ylabel('Detection Efficiency (%)')
title('Yearlong Averages, Binned')


%Averaging from absolute value of tidal magnitude, Along-Shore
clearvars average averagePercent tideBinsAlong averagePercent2 tideBins*
tideBinsAlong(1,:) = abs(fullData.tidalData(:,2)) < .02;
tideBinsAlong(2,:) = abs(fullData.tidalData(:,2)) > .02 & abs(fullData.tidalData(:,2)) < .04;
tideBinsAlong(3,:) = abs(fullData.tidalData(:,2)) > .04 & abs(fullData.tidalData(:,2)) < .06;
tideBinsAlong(4,:) = abs(fullData.tidalData(:,2)) > .06 & abs(fullData.tidalData(:,2)) < .08;
tideBinsAlong(5,:) = abs(fullData.tidalData(:,2)) > .08 & abs(fullData.tidalData(:,2)) < .1;
tideBinsAlong(6,:) = abs(fullData.tidalData(:,2)) > .1;

average = zeros(1,height(tideBinsAlong));
for k = 1:height(tideBinsAlong)
    tideScenario2{k}= fullData(tideBinsAlong(k,:),:);
    average(1,k) = mean(tideScenario2{1,k}.detections2);
    averagePercent2(1,k) = (average(1,k)/6)*100;
end

x2 = .005:.02:.105
figure()
scatter(x2,averagePercent2,'filled')
hold on 
errorbar(x2,averagePercent2,std(averagePercent2,[],2))
xlim([0 .11])
ylim([5 50])
xlabel('Alongshore Current (m/s, Abs)')
ylabel('Detection Efficiency (%)')
title('Yearlong Averages, Binned')

figure()
scatter(x1,averagePercent1,'b','filled')
hold on 
scatter(x2,averagePercent2,'r','filled')
xlabel('Current Velocity (m/s, Abs)')
ylabel('Detection Efficiency (%)')
title('Cross-shore (B) and Along-Shore (R) Efficiency')

%%
%Diurnal differences by season
% clearvars -except fullData

for k = 1:length(unique(fullData.season))
    dayLong(k,:) = fullData.sunlight == 1 & fullData.season ==k;
    nightLong(k,:) = fullData.sunlight == 0 & fullData.season ==k;
end

averageDay = zeros(1,height(dayLong));
for k = 1:height(dayLong)
    dayScenario{k}= fullData(dayLong(k,:),:);
    averageDay(1,k) = mean(dayScenario{1,k}.detections2);
    averageDayPercent(1,k) = (averageDay(1,k)/6)*100;
end

averageNight = zeros(1,height(nightLong));
for k = 1:height(nightLong)
    nightScenario{k}= fullData(nightLong(k,:),:);
    averageNight(1,k) = mean(nightScenario{1,k}.detections2);
    averageNightPercent(1,k) = (averageNight(1,k)/6)*100;
end

x = 1:5

figure()
scatter(x,averageDayPercent,'r','filled')
hold on
scatter(x,averageNightPercent,'b','filled')
xlim([0 6])
ylim([15 35])
xlabel('Season')
ylabel('Detection Efficiency (%)')
title('Seasonal Diurnal (Night Blue, Day Red)')

averagePercents = [averageDayPercent;averageNightPercent];
figure()
hb = bar(averagePercents')
legend('Day','Night')
hb(1).FaceColor = 'y'
hb(2).FaceColor = 'b' 
ylim([15 35])
xlabel('Season')
ylabel('Detection Efficiency (%)')
title('Seasonal Diurnal Differences')

%%



clearvars -except fullData

%Did some math cause I'm awesome:
% 0-2 m/s, 577 hours, 7.6%
% > 10 m/s, 616, 8.2%
% 0-3 m/s, 1268, 16%
% > 9 m/s, 1012, 13.4%
% 0-4 m/s, 2216, 29.4%
% > 7 m/s, 2239, 29.7%

%%
for k = 1:length(unique(fullData.season))
    lowWind(k,:) = fullData.windSpeed < 4 & fullData.season ==k;
    lowerWind(k,:) = fullData.windSpeed < 3 & fullData.season ==k;
    lowestWind(k,:) = fullData.windSpeed < 2 & fullData.season ==k;
    highWind(k,:) = fullData.windSpeed > 7 & fullData.season ==k;
    higherWind(k,:) = fullData.windSpeed > 9 & fullData.season ==k;
    highestWind(k,:) = fullData.windSpeed > 10 & fullData.season ==k;
end

for k = 1:height(lowWind)
% for k = 1
    lowScenario{k}= fullData(lowWind(k,:),:);
    averageLow(:,k) = mean(lowScenario{1,k}.detections2);
    averageLowPercent(:,k) = (averageLow(1,k)/6)*100;

    lowerScenario{k}= fullData(lowerWind(k,:),:);
    averageLower(:,k) = mean(lowerScenario{1,k}.detections2);
    averageLowerPercent(:,k) = (averageLower(1,k)/6)*100;

    lowestScenario{k}= fullData(lowestWind(k,:),:);
    averageLowest(:,k) = mean(lowestScenario{1,k}.detections2);
    averageLowestPercent(:,k) = (averageLowest(1,k)/6)*100;

    %
    highScenario{k}= fullData(highWind(k,:),:);
    averageHigh(:,k) = mean(highScenario{1,k}.detections2);
    averageHighPercent(:,k) = (averageHigh(1,k)/6)*100;

    higherScenario{k}= fullData(higherWind(k,:),:);
    averageHigher(:,k) = mean(higherScenario{1,k}.detections2);
    averageHigherPercent(:,k) = (averageHigher(1,k)/6)*100;

    highestScenario{k}= fullData(highestWind(k,:),:);
    averageHighest(:,k) = mean(highestScenario{1,k}.detections2);
    averageHighestPercent(:,k) = (averageHighest(1,k)/6)*100;
end

%%


x = 1:length(highScenario)

figure()
scatter(x,averageLowPercent,'filled','b')
hold on
scatter(x,averageLowestPercent,'filled','g')
scatter(x,averageHighPercent,'filled','r')
scatter(x,averageHighestPercent,'filled','k')
legend('Low Winds  (< 4 m/s, 29.4%)','Lowest Winds  (<2 m/s, 7.6%)','High Winds (> 7 m/s, 29.7%)','Highest Winds (> 10 m/s, 8.2%)')
xlabel('Season')
ylabel('Detection Efficiency (%)')
title('Wind Effects on Efficiency')


%%
%Now I want both in one, negative and positive
%Same tidal breakdown but now also by season
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

%Considering fixing the "7"s that show up. 6 is supposed to be 100%
%efficiency. 
%%
%FMFMFMF EDITED EXPERIMENT1 TO REMOVE 7s

% average = zeros(1,height(tideBinsX{1}));
for season = 1:length(seasons)
    for k = 1:height(tideBinsX{season})
        tideScenarioX{season}{k}= fullData(tideBinsX{season}(k,:),:);
        averageX{season}(1,k) = mean(tideScenarioX{season}{1,k}.detections2);
        averagePercentX{season}(1,k) = (averageX{season}(1,k)/6)*100;
        if isnan(averagePercentX{season}(1,k))
            averagePercentX{season}(1,k) = 0;
            continue
        end
    end
    moddedPercentX{season}  = averagePercentX{season}/(max(averagePercentX{season}));
end
%%

for season = 1:length(seasons)
    for k = 1:height(tideBinsAlong{season})
        tideScenarioAlong{season}{k}= fullData(tideBinsAlong{season}(k,:),:);
        averageAlong{season}(1,k) = mean(tideScenarioAlong{season}{1,k}.detections2);
        averagePercentAlong{season}(1,k) = (averageAlong{season}(1,k)/6)*100;
        if isnan(averagePercentAlong{season}(1,k))
            averagePercentAlong{season}(1,k) = 0;
            continue
        end
    end
    moddedPercentAlong{season}  = averagePercentAlong{season}/(max(averagePercentAlong{season}));
end

%%

seasonName = {'Winter','Spring','Summer','Fall','Mariner''s Fall'}
x = -0.4:0.05:.4;
for k = 1:length(averagePercentX)
    figure()
    scatter(x,averagePercentX{k},'filled')
    xlim([-.5 .5])
    ylim([0 60])
    xline(0)
%     hold on 
%     errorbar(x,averagePercent{k}(1:9),std(averagePercent{k}(1:9),[],2))
%     scatter(x,averagePercent{k}(10:18),'filled')
%     errorbar(x,averagePercent{k}(10:18),std(averagePercent{k}(10:18),[],2))
%     legend('Onshore (-)', 'Offshore (+)')
    xlabel('Current Magnitude')
    ylabel('Normalized Detection Efficiency')
    title('Tidal Magnitude''s Effect on Detections')
    title (sprintf('Tidal Magnitude''s Effect on Detections, %s',seasonName{k}))
end

%%
x = -0.4:0.05:.4;
 figure()
scatter(x,averagePercentX{1},'filled')
xlim([-.5 .5])
ylim([0 60])
hold on 
scatter(x,averagePercentX{2},'filled')
scatter(x,averagePercentX{3},'filled')
scatter(x,averagePercentX{4},'filled')
scatter(x,averagePercentX{5},'filled')
xline(0)
legend('Winter','Spring','Summer','Fall','Mariners Fall')

xlabel('Current Magnitude (m/s)')
ylabel('Detection Efficiency (%)')
title('Crossshore Tidal Magnitude''s Effect on Detections')
%%
x = -0.4:0.05:.4;
 figure()
scatter(x,moddedPercentX{1},'filled')
xlim([-.5 .5])
ylim([0 1.2])
hold on 
scatter(x,moddedPercentX{2},'filled')
scatter(x,moddedPercentX{3},'filled')
scatter(x,moddedPercentX{4},'filled')
scatter(x,moddedPercentX{5},'filled')
xline(0)
legend('Winter','Spring','Summer','Fall','Mariners Fall')

xlabel('Current Magnitude (m/s)')
ylabel('Normalized Detection Efficiency')
title('Normalized Xshore Tide''s Effect on Detections')
%%

%%
x = -0.1:0.01:.09;
 figure()
scatter(x,moddedPercentAlong{1},'filled')
xlim([-.15 .15])
ylim([0 1.2])
hold on 
scatter(x,moddedPercentAlong{2},'filled')
scatter(x,moddedPercentAlong{3},'filled')
scatter(x,moddedPercentAlong{4},'filled')
scatter(x,moddedPercentAlong{5},'filled')
xline(0)
legend('Winter','Spring','Summer','Fall','Mariners Fall')

xlabel('Current Magnitude (m/s)')
ylabel('Normalized Detection Efficiency')
title('Normalized Alongshore Tide''s Effect on Detections')
%%
% 
% x = -0.4:0.05:.4;
% figure()
% scatter(x,moddedPercentX{1},'filled')
% xlim([-.5 .5])
% ylim([0 1])
% hold on 
% scatter(x,moddedAverageX{2},'filled')
% scatter(x,moddedAverageX{3},'filled')
% scatter(x,moddedAverageX{4},'filled')
% scatter(x,moddedAverageX{5},'filled')
% xline(0)
% legend('Winter','Spring','Summer','Fall','Mariners Fall')
% 
% xlabel('Current Magnitude (m/s)')
% ylabel('Detection Efficiency (%)')
% title('Tidal Magnitude''s Effect on Detections')
% 
% %
%  figure()
% scatter(x,moddedPercentX{1},'filled')
% xlim([-.5 .5])
% ylim([0 60])
% hold on 
% scatter(x,moddedPercentX{2},'filled')
% scatter(x,moddedPercentX{3},'filled')
% scatter(x,moddedPercentX{4},'filled')
% scatter(x,moddedPercentX{5},'filled')
% xline(0)
% legend('Winter','Spring','Summer','Fall','Mariners Fall')
% 
% xlabel('Current Magnitude (m/s)')
% ylabel('Detection Efficiency (%)')
% title('Tidal Magnitude''s Effect on Detections')
%     %Okay. Need to add some type of tidal range. right now we just see
%     %tides as a seasonal variable, need to break down the differences
%     %within that time frame.
% 
% %findebbflood gives us tidalrange, an array of the difference between max
% %and min tides, and floodDT/ebbDT or high tide/low tide
% 
% 
% for kk = 1:length(ebbDT)
%     test = isbetween(fullData.time,floodDT(kk,1),ebbDT(kk+1,1))
%     playgroundMean(kk) = mean(fullData.detections2(test))
% end
% 
% 
% 
% 
% 
% x = 1:707;
% 
% figure()
% scatter(tidalrange,playgroundMean,'filled');















    