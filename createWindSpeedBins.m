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




