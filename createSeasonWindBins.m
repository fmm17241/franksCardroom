for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        windSpeedBins{COUNT}{season}(1,:) = fullData{COUNT}.windSpeed < 1 & fullData{COUNT}.season ==season;
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
        windSpeedBins{COUNT}{season}(13,:) = fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.season ==season;
    end
end

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(windSpeedBins{COUNT}{season})
            windSpeedScenario{COUNT}{season}{k}= fullData{COUNT}(windSpeedBins{COUNT}{season}(k,:),:);
            averageWindSpeed{COUNT}{season}(1,k) = mean(windSpeedScenario{COUNT}{season}{1,k}.detections);
            noiseCompare{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.noise);
            wavesCompare{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.waveHeight);
            tiltCompareWind{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.tilt);
            stratCompareWind{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.stratification)
        end
        normalizedWSpeed{COUNT}{season}  = averageWindSpeed{COUNT}{season}/(max(averageWindSpeed{COUNT}{season}));
    end
end



for season = 1:length(seasons) 
    for k = 1:height(windSpeedBins{COUNT}{season})
        seasonAllDets{season,k} = zeros(1,1);
        seasonAllNoise{season,k} = zeros(1,1);
    end
end


for season = 1:length(seasons)
    for k = 1:height(windSpeedBins{COUNT}{season})
        for COUNT = 1:length(fullData)
            seasonAllDets{season,k} = [seasonAllDets{season,k}; windSpeedScenario{COUNT}{season}{k}.detections]
            seasonAllNoise{season,k} = [seasonAllNoise{season,k}; windSpeedScenario{COUNT}{season}{k}.noise]
        end
        seasonAllDets{season,k}     = seasonAllDets{season,k}(2:end);
        seasonAllNoise{season,k}     = seasonAllNoise{season,k}(2:end);
        seasonAverageDets(season,k) = mean(seasonAllDets{season,k});
        seasonAverageNoise(season,k) = mean(seasonAllNoise{season,k});
    end
end

testEfficiency = ((seasonAverageDets./6).*100).^2;



x = 0:12;

figure()
hold on
for COUNT = 1:height(seasonAverageDets)
    plot(x,seasonAverageDets(COUNT,:))
end

figure()
hold on
for COUNT = 1:height(seasonAverageNoise)
    plot(x,seasonAverageNoise(COUNT,:))
end

figure()
hold on
for COUNT = 1:height(seasonAverageNoise)
    scatter(x,seasonAverageNoise(COUNT,:),testEfficiency(COUNT,:),'filled','MarkerFaceAlpha',.7)
end
xlabel('Wind Magnitude (m/s)')
ylabel('Measured Noise (mV)')
title('Windspeed''s Effect:','High Frequency Noise (Y) & Detection Efficiency (Size)')
x2 = xline(6.03,'label','Moderate Breeze')
x3 = xline(10.09,'label','Strong Breeze')
legend('Winter','Spring','Summer','Fall','Mariner''s Fall')
