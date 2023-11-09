
%FM splitting up bins by tidal velocity

%Frank changes "singleData{X}" to pick different transceivers



for season = 1:length(seasonName)
    %Parallel: X-axis of our tides, aligned with transmissions
    crossTideBins{season, 1} = singleData{4}.CrossTide < -.4 & singleData{4}.Season ==season;
    crossTideBins{season, 2} =  singleData{4}.CrossTide > -.4 &  singleData{4}.CrossTide < -.35 & singleData{4}.Season ==season;
    crossTideBins{season, 3} =  singleData{4}.CrossTide > -.35 &  singleData{4}.CrossTide < -.30 & singleData{4}.Season ==season;
    crossTideBins{season, 4} =  singleData{4}.CrossTide > -.30 & singleData{4}.CrossTide <-.25 & singleData{4}.Season ==season;
    crossTideBins{season, 5} =  singleData{4}.CrossTide > -.25 &  singleData{4}.CrossTide < -.20 & singleData{4}.Season ==season;
    crossTideBins{season, 6} =  singleData{4}.CrossTide > -.20 &  singleData{4}.CrossTide < -.15 & singleData{4}.Season ==season;
    crossTideBins{season, 7} =  singleData{4}.CrossTide > -.15 &  singleData{4}.CrossTide < -.10 & singleData{4}.Season ==season;
    crossTideBins{season, 8} =  singleData{4}.CrossTide > -.1 &  singleData{4}.CrossTide < -.05 & singleData{4}.Season ==season;

    crossTideBins{season, 9} =  singleData{4}.CrossTide > -.05 &  singleData{4}.CrossTide < 0.05 & singleData{4}.Season ==season;

    crossTideBins{season, 10} =  singleData{4}.CrossTide > .05 &  singleData{4}.CrossTide < .1 & singleData{4}.Season ==season;
    crossTideBins{season, 11} =  singleData{4}.CrossTide > .10 &  singleData{4}.CrossTide < .15 & singleData{4}.Season ==season;
    crossTideBins{season, 12} =  singleData{4}.CrossTide > .15 & singleData{4}.CrossTide < .2 & singleData{4}.Season ==season;
    crossTideBins{season, 13} =  singleData{4}.CrossTide > .20 &  singleData{4}.CrossTide < .25 & singleData{4}.Season ==season;
    crossTideBins{season, 14} =  singleData{4}.CrossTide > .25 &  singleData{4}.CrossTide < .3 & singleData{4}.Season ==season;
    crossTideBins{season, 15} =  singleData{4}.CrossTide > .30 &  singleData{4}.CrossTide < .35 & singleData{4}.Season ==season;
    crossTideBins{season, 16} =  singleData{4}.CrossTide > .35 &  singleData{4}.CrossTide < .4 & singleData{4}.Season ==season;
    crossTideBins{season, 17} =  singleData{4}.CrossTide > .40 & singleData{4}.Season ==season;
end





%Trying to adjust
for season = 1:height(crossTideBins)
    for k = 1:length(crossTideBins)
        crossTideScenario{season,k}= singleData{4}(crossTideBins{season,k},:);
        averageTideDets(season,k) = mean(crossTideScenario{season,k}.HourlyDets);
        noiseCompare(season,k) = mean(crossTideScenario{season,k}.Noise);
        tiltCompareTide(season,k) = mean(crossTideScenario{season,k}.Tilt);
        stratCompare(season,k) = mean(crossTideScenario{season,k}.BulkStrat);
        ratioCompareTide(season,k) = mean(crossTideScenario{season,k}.Ratio);
        pingsCompareTide(season,k) = mean(crossTideScenario{season,k}.Pings);
    end
    normalizedTideDets(season,:)  = averageTideDets(season,:)/(max(averageTideDets(season,:)));
end


X = -.4:.05:.4;


figure()
plot(X,ratioCompareTide)
legend(seasonName)
title('Ping Ratio D')
xlabel('Cross-shore Tidal Magnitude (m/s)')
ylim([0.6 1])
ylabel('Ping Ratio')


clearvars crossTideBins crossTideScenario averageTideDets noiseCompare tiltCompareTide normalizedTideDets



figure()
plot(X,stratCompare)
legend(seasonName)
title('Bulk Stratification')
xlabel('Cross-shore Tidal Magnitude (m/s)')

figure()
plot(X,ratioCompareTide)
legend(seasonName)
title('Ping Ratio')
xlabel('Cross-shore Tidal Magnitude (m/s)')


%%
