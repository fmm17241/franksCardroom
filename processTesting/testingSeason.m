%%
%FM isolating seasonal effects, maybe?


for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        seasonBin{COUNT}{season} = fullData{COUNT}.season ==season;
    end
end


for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        seasonScenario{COUNT}{season}= fullData{COUNT}(seasonBin{COUNT}{season},:);
        averageWindSpeed{COUNT}{season} = mean(seasonScenario{COUNT}{season}.detections);
        noiseCompare{COUNT}{season} = mean(seasonScenario{COUNT}{season}.noise);
        wavesCompare{COUNT}{season} = mean(seasonScenario{COUNT}{season}.waveHeight);
        tiltCompareWind{COUNT}{season} = mean(seasonScenario{COUNT}{season}.tilt);
        stratCompare{COUNT}{season} = mean(seasonScenario{COUNT}{season}.stratification)
    end
end
% end
% % 

for season = 1:length(seasons)
    windIndex{season,1} = seasonScenario{1}{season}.windSpeed < 2;
    windIndex{season,2} = seasonScenario{1}{season}.windSpeed < 6 & seasonScenario{1}{season}.windSpeed > 2;
    windIndex{season,3} = seasonScenario{1}{season}.windSpeed < 10 & seasonScenario{1}{season}.windSpeed > 6;
    windIndex{season,4} = seasonScenario{1}{season}.windSpeed > 10;
    compareCounts(1,season) = height(seasonScenario{1}{season}(windIndex{season,1},:))/height(seasonScenario{1}{season});
    compareCounts(2,season) = height(seasonScenario{1}{season}(windIndex{season,2},:))/height(seasonScenario{1}{season});
    compareCounts(3,season) = height(seasonScenario{1}{season}(windIndex{season,3},:))/height(seasonScenario{1}{season});
    compareCounts(4,season) = height(seasonScenario{1}{season}(windIndex{season,4},:))/height(seasonScenario{1}{season});
end

