%Doing the same for my wind data
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
        windSpeedBins{COUNT}{season}(13,:) = fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.windSpeed < 13 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(14,:) = fullData{COUNT}.windSpeed > 13 & fullData{COUNT}.windSpeed < 14 & fullData{COUNT}.season ==season;
        windSpeedBins{COUNT}{season}(15,:) = fullData{COUNT}.windSpeed > 14 & fullData{COUNT}.season ==season;
    end
end

%%
for COUNT = 1:length(fullData)
    windSpeedBinsAnnual{COUNT}(1,:) = fullData{COUNT}.windSpeed < 1 ;
    windSpeedBinsAnnual{COUNT}(2,:) = fullData{COUNT}.windSpeed > 1 & fullData{COUNT}.windSpeed < 2 ;
    windSpeedBinsAnnual{COUNT}(3,:) = fullData{COUNT}.windSpeed > 2 & fullData{COUNT}.windSpeed < 3 ;
    windSpeedBinsAnnual{COUNT}(4,:) = fullData{COUNT}.windSpeed > 3 & fullData{COUNT}.windSpeed < 4 ;
    windSpeedBinsAnnual{COUNT}(5,:) = fullData{COUNT}.windSpeed > 4 & fullData{COUNT}.windSpeed < 5 ;
    windSpeedBinsAnnual{COUNT}(6,:) = fullData{COUNT}.windSpeed > 5 & fullData{COUNT}.windSpeed < 6 ;
    windSpeedBinsAnnual{COUNT}(7,:) = fullData{COUNT}.windSpeed > 6 & fullData{COUNT}.windSpeed < 7 ;
    windSpeedBinsAnnual{COUNT}(8,:) = fullData{COUNT}.windSpeed > 7 & fullData{COUNT}.windSpeed < 8 ;
    windSpeedBinsAnnual{COUNT}(9,:) = fullData{COUNT}.windSpeed > 8 & fullData{COUNT}.windSpeed < 9 ;
    windSpeedBinsAnnual{COUNT}(10,:) = fullData{COUNT}.windSpeed > 9 & fullData{COUNT}.windSpeed < 10 ;
    windSpeedBinsAnnual{COUNT}(11,:) = fullData{COUNT}.windSpeed > 10 & fullData{COUNT}.windSpeed < 11 ;
    windSpeedBinsAnnual{COUNT}(12,:) = fullData{COUNT}.windSpeed > 11 & fullData{COUNT}.windSpeed < 12 ;
    windSpeedBinsAnnual{COUNT}(13,:) = fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.windSpeed < 13 ;
    windSpeedBinsAnnual{COUNT}(14,:) = fullData{COUNT}.windSpeed > 13 & fullData{COUNT}.windSpeed < 14 ;
    windSpeedBinsAnnual{COUNT}(15,:) = fullData{COUNT}.windSpeed > 14 ;
end


for COUNT = 1:length(fullData)
    for k = 1:height(windSpeedBinsAnnual{COUNT})
        windSpeedScenarioAnnual{COUNT}{k}= fullData{COUNT}(windSpeedBinsAnnual{COUNT}(k,:),:);
        averageWindSpeedAnnual{COUNT}(1,k) = mean(windSpeedScenarioAnnual{COUNT}{1,k}.detections);
        noiseCompareAnnual{COUNT}(k) = mean(windSpeedScenarioAnnual{COUNT}{1,k}.noise);
        wavesCompareAnnual{COUNT}(k) = mean(windSpeedScenarioAnnual{COUNT}{1,k}.waveHeight,'omitnan');
        tiltCompareWindAnnual{COUNT}(k) = mean(windSpeedScenarioAnnual{COUNT}{1,k}.tilt);
        stratCompareWindAnnual{COUNT}(k) = mean(windSpeedScenarioAnnual{COUNT}{1,k}.stratification)
    end
    normalizedWSpeedAnnual{COUNT}  = averageWindSpeedAnnual{COUNT}/(max(averageWindSpeedAnnual{COUNT}));
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
            stratCompareWind{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.stratification)
        end
        normalizedWSpeed{COUNT}{season}  = averageWindSpeed{COUNT}{season}/(max(averageWindSpeed{COUNT}{season}));
    end
end


for COUNT = 1:length(weakWindScenario)
    for season = 1:length(seasons)
        errorWeakWind(COUNT,season) = std(weakWindScenario{COUNT}{season,1}.detections)  
        errorMediumWind(COUNT,season) = std(mediumWindScenario{COUNT}{season,1}.detections) 
        errorStrongWind(COUNT,season) = std(strongWindScenario{COUNT}{season,1}.detections)
    end
end


for COUNT = 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter = [averageWindSpeed{COUNT}{season},averageWindSpeed{COUNT+1}{season}];
        normalizedWSpeed{COUNT}{season}  = averageWindSpeed{COUNT}{season}/(max(comboPlatter));
        normalizedWSpeed{COUNT+1}{season}  = averageWindSpeed{COUNT+1}{season}/(max(comboPlatter));
    end
end


for COUNT = 1:length(normalizedWSpeed)
    for season = 1:length(seasons)
        completeWinds{COUNT}(season,:) = normalizedWSpeed{COUNT}{season};
        completeWHeight{COUNT}(season,:) = wavesCompare{COUNT}{season};
        completeNoise{COUNT}(season,:)   = noiseCompare{COUNT}{season};
        completeTiltVsWindSpeed{COUNT}(season,:)   = tiltCompareWind{COUNT}{season};
        completeStratVsWindSpeed{COUNT}(season,:)  = stratCompareWind{COUNT}{season};
    end
end


for COUNT = 1:length(completeWinds)
    completeWindsAvg(COUNT,:) = nanmean(completeWinds{COUNT});
    completeNoiseAvg(COUNT,:) = nanmean(completeNoise{COUNT});
    completeTiltVsWindAvg(COUNT,:) = nanmean(completeTiltVsWindSpeed{COUNT});
    completeStratVsWindAvg(COUNT,:) = nanmean(completeStratVsWindSpeed{COUNT})
end

for COUNT = 1:length(completeWindsAvg)
    yearlyWindSpeed(1,COUNT)       = mean(completeWindsAvg(:,COUNT));
    yearlyNoise(1,COUNT)           = mean(completeNoiseAvg(:,COUNT));  
    yearlyTiltVsWindSpeed(1,COUNT) = mean(completeTiltVsWindAvg(:,COUNT));
    yearlyStratVsWindSpeed(1,COUNT) = mean(completeStratVsWindAvg(:,COUNT));
end

normalizedYearlyWind = yearlyWindSpeed/(max(yearlyWindSpeed));





