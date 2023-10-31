%%
%FM just isolating stratification, gonna compare to winds and seasons

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        stratBins{COUNT}{season}(1,:) = fullData{COUNT}.stratification ==0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(2,:) = fullData{COUNT}.stratification > 0 & fullData{COUNT}.stratification < 0.2 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(3,:) = fullData{COUNT}.stratification > 0.2 & fullData{COUNT}.stratification < 0.4 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(4,:) = fullData{COUNT}.stratification > 0.4 & fullData{COUNT}.stratification < 0.6 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(5,:) = fullData{COUNT}.stratification > 0.6 & fullData{COUNT}.stratification < 0.8 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(6,:) = fullData{COUNT}.stratification > 0.8 & fullData{COUNT}.stratification < 1.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(7,:) = fullData{COUNT}.stratification > 1 & fullData{COUNT}.stratification < 1.2 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(8,:) = fullData{COUNT}.stratification > 1.2 & fullData{COUNT}.stratification < 1,4 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(9,:) = fullData{COUNT}.stratification > 1.4 & fullData{COUNT}.stratification < 1.6 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(10,:) = fullData{COUNT}.stratification > 1.6 & fullData{COUNT}.stratification < 1.8 & fullData{COUNT}.season ==season;   
        stratBins{COUNT}{season}(11,:) = fullData{COUNT}.stratification > 1.8 & fullData{COUNT}.stratification < 2.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(12,:) = fullData{COUNT}.stratification > 2.0 & fullData{COUNT}.season ==season;
    end
end


% average = zeros(1,height(windBins))
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(stratBins{COUNT}{season})
            stratScenario{COUNT}{season}{k}= fullData{COUNT}(stratBins{COUNT}{season}(k,:),:);
            averagestratDets{COUNT}{season}(1,k) = mean(stratScenario{COUNT}{season}{1,k}.detections);
            noiseCompare{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.noise);
            wavesCompare{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.waveHeight);
            tiltCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.tilt);
            pingsCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.pings);
            windSpeedCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.windSpeed);
            windDirCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.windDir);
            crossTideCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.uShore);
            paraTideCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.paraTide);
        end
    end
end