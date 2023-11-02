%FM

arrayCaseStudy

%Frank, using bioIndex? or just difference in pings/acoustic environment
%Frank needs to cut down the fullData to just stations

fullData = {fullData{1},fullData{2},fullData{3},fullData{6}}

%FS6, SURT05, STSNew2, 39IN



for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        seasonBin{COUNT}{season} = fullData{COUNT}.season ==season;
        seasonScenario{COUNT}{season}= fullData{COUNT}(seasonBin{COUNT}{season},:);
        averageDets{COUNT}(season) = mean(seasonScenario{COUNT}{season}.detections);
        noiseCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.noise);
        wavesCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.waveHeight);
        tiltCompareWind{COUNT}(season) = mean(seasonScenario{COUNT}{season}.tilt);
        stratCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.stratification);
        pingCompare{COUNT}(season) = mean(seasonScenario{COUNT}{season}.pings);
        totalDets{COUNT}(season)   = mean(seasonScenario{COUNT}{season}.TotalDets);
    end
end
% end
% % 

X = 1:5
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','g','k','b','m'];

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        usedPings = (seasonScenario{COUNT}{season}.TotalDets)*8;
        removeFull{COUNT,season} = seasonScenario{COUNT}{season}.pings - usedPings;
        ratio{COUNT,season}      = usedPings./seasonScenario{COUNT}{season}.pings;
        averageRatio(COUNT,season) = mean(ratio{COUNT,season})
    end
end


figure()
hold on
yyaxis left
plot(X,pingCompare{1},color(1))
yyaxis right
plot(X,totalDets{1},color(1))




for COUNT = 1:length(fullData)
    figure()
    hold on
    yyaxis left
    plot(X,averageRatio(COUNT,:),'b',lineWidth = 5)
    ylabel('Ratio (usedPings/TotalPings)')
    ylim([0.65 1])
    yyaxis right
    plot(X,stratCompare{1,COUNT},'r',lineWidth = 5)
    ylabel('Bulk Thermal Strat (deg)')
    ylim([0 2])
    title(sprintf('Ratio of heard to detected, %d', COUNT))
end



