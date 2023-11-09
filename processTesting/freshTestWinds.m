
%%

%Full season windbreakdown
for season = 1:length(seasonName)
    windSpeedBins{season,1} = singleData{1}.WindSpd < 2 & singleData{1}.Season ==season;
    windSpeedBins{season,2} = singleData{1}.WindSpd > 2 & singleData{1}.WindSpd < 4 & singleData{1}.Season ==season;
    windSpeedBins{season,3} = singleData{1}.WindSpd > 4 & singleData{1}.WindSpd < 6 & singleData{1}.Season ==season;
    windSpeedBins{season,4} = singleData{1}.WindSpd > 6 & singleData{1}.WindSpd < 8 & singleData{1}.Season ==season;
    windSpeedBins{season,5} = singleData{1}.WindSpd > 8 & singleData{1}.WindSpd < 10 & singleData{1}.Season ==season;
    windSpeedBins{season,6} = singleData{1}.WindSpd > 10 & singleData{1}.Season ==season;
end


%Trying to adjust
for season = 1:height(windSpeedBins)
    for k = 1:length(windSpeedBins)
        windSpeedScenario{season,k}= singleData{1}(windSpeedBins{season,k},:);
        averageWspDets(season,k) = mean(windSpeedScenario{season,k}.HourlyDets);
        noiseCompare(season,k) = mean(windSpeedScenario{season,k}.Noise);
        tiltCompareWind(season,k) = mean(windSpeedScenario{season,k}.Tilt);
        stratCompare(season,k) = mean(windSpeedScenario{season,k}.BulkStrat);
        ratioCompareWind(season,k) = mean(windSpeedScenario{season,k}.Ratio);
        pingsCompareWind(season,k) = mean(windSpeedScenario{season,k}.Pings);
        % stratCompareWind{COUNT}{season}(k) = mean(windSpeedScenario{season,k}.stratification)
    end
    % normalizedWSpeed{season,k}  = averageWindSpeed{COUNT}{season}/(max(averageWindSpeed{COUNT}{season}));
end


X = 2:2:12;
xSize = ones(6,1)



figure()
plot(X,averageWspDets,'LineWidth',2.5)
legend(seasonName)
xlabel('Windspeed (m/s)')
ylabel('Hourly Detections')
title('Increasing Windspeeds versus Total Detections','Hours averaged. each season')

figure()
plot(X,ratioCompareWind,'LineWidth',2.5)

xlabel('Windspeed (m/s)')
ylabel('Ping Ratio')
yyaxis right
scatter(X,stratCompare,'filled','k')
legend(seasonName)
title('Increasing Windspeeds versus Ping Efficiency','Hours averaged. each season')


figure()
scatter3(X,stratCompare,xSize,averageWspDets,'LineWidth',2.5)
legend(seasonName)
xlabel('Windspeed (m/s)')
ylabel('Bulk Stratification (C)')
title('Increasing Windspeeds versus Bulk Stratification','Hours averaged. each season')


figure()
scatter(noiseCompare,averageWspDets,'filled')
legend(seasonName)

%Winds for the first transceiver

%Plots relationship between noise and dets for every season + transceiver
for COUNT = 1
    for season = 1:length(seasonName)
        figure()
        hold on
        scatter(seasonScenario{COUNT,season}.Noise,seasonScenario{COUNT,season}.HourlyDets);
        title(sprintf('Noise vs Dets, %s',seasonName{season}),sprintf('Transceiver %d', COUNT))
        xlabel('Noise (mV)')
        ylabel('Hourly Dets')
        xlim([200 800])
        ylim([5 90])
    end
end

for COUNT = 2:length(winter)
    for season = 1:length(seasonName)
        figure()
        hold on
        scatter(seasonScenario{COUNT,season}.Noise,seasonScenario{COUNT,season}.HourlyDets);
        title(sprintf('Noise vs Dets, %s',seasonName{season}),sprintf('Transceiver %d', COUNT))
        xlabel('Noise (mV)')
        ylabel('Hourly Dets')
        xlim([200 800])
        ylim([5 25])
    end
end

%%
% WIND VS DETS
for COUNT = 1
    for season = 1:length(seasonName)
        figure()
        hold on
        yyaxis left
        scatter(seasonScenario{COUNT,season}.WindSpd,seasonScenario{COUNT,season}.HourlyDets);
        title(sprintf('Windspeed vs Dets, %s',seasonName{season}),sprintf('Transceiver %d', COUNT))
        xlabel('Windspeed (m/s)')
        ylabel('Hourly Dets')
        xlim([2 14])
        ylim([5 90])
        yyaxis right
        scatter(seasonScenario{COUNT,season}.WindSpd,seasonScenario{COUNT,season}.Tilt)
        ylim([2 30])
    end
end

for COUNT = 2:length(winter)
    for season = 1:length(seasonName)
        figure()
        hold on
        scatter(seasonScenario{COUNT,season}.WindSpd,seasonScenario{COUNT,season}.HourlyDets);
        title(sprintf('Windspeed vs Dets, %s',seasonName{season}),sprintf('Transceiver %d', COUNT))
        xlabel('Noise (mV)')
        ylabel('Hourly Dets')
        xlim([2 14])
        ylim([5 25])
        yyaxis right
        scatter(seasonScenario{COUNT,season}.WindSpd,seasonScenario{COUNT,season}.Tilt)
        ylim([2 30])
    end
end
%%






figure()
hold on
scatter(seasonScenario{1,5}.WindSpd, seasonScenario{1,5}.Pings);
title('fall')
xlabel('WindSpd (m/s)')
ylabel('Hourly PINGS')



figure()
hold on
scatter(seasonScenario{1,1}.tilt, seasonScenario{1,1}.pings);
title('Winter')
xlabel('Tilt (deg)')
ylabel('Hourly Dets')

figure()
hold on
scatter(seasonScenario{1,1}.noise, seasonScenario{1,1}.pings);
title('Winter')
xlabel('Noise (mV)')
ylabel('Hourly PINGS')








%     detectionTable{k} = table(useTime{1,k},detections{1,k}); 
%     detectionTable{k}.Properties.VariableNames = {'time','detections'};
%     detectionTable{k} = table2timetable(detectionTable{k});


load mooredGPS


%%
%Frank created receiverData{X}.ratio, now how can I show committee what I'm
%talking about?

figure()
hold on
% yyaxis left
plot(receiverTimes{1},receiverData{1}.ratio(:,2),'LineWidth',2);
ylabel('Ratio')
ylim([0.5 1])
yyaxis right
plot(receiverTimes{1},receiverData{1}.avgNoise(:,2),'LineWidth',2);
ylabel('Noise (mV)')
ylim([400 800])
title('Comparing Efficiency to Noise','Ratio = Used pings (dets*8)/Total Collected Pings')


figure()
hold on
yyaxis left
plot(receiverTimes{2},receiverData{2}.hourlyDets(:,2),'LineWidth',2);
ylabel('Hourly Dets')
ylim([6 15])
yyaxis right
plot(receiverTimes{2},receiverData{2}.avgNoise(:,2),'LineWidth',2);
ylabel('Noise (mV)')
ylim([400 800])
title('Comparing Efficiency to Noise','')

figure()
hold on
yyaxis left
plot(receiverTimes{2},receiverData{2}.pings(:,2),'LineWidth',2);
ylabel('Total Pings')
% ylim([6 15])
yyaxis right
plot(receiverTimes{2},receiverData{2}.avgNoise(:,2),'LineWidth',2);
ylabel('Noise (mV)')
ylim([400 800])
title('Comparing Abiotic Noise to Total Noise','')

