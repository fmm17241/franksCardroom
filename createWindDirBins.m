

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        windDirBins{COUNT}{season}(1,:) = fullData{COUNT}.windDir < 20 & fullData{COUNT}.season == season;
        windDirBins{COUNT}{season}(2,:) = fullData{COUNT}.windDir > 20 & fullData{COUNT}.windDir < 40 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(3,:) = fullData{COUNT}.windDir > 40 & fullData{COUNT}.windDir < 60 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(4,:) = fullData{COUNT}.windDir > 60 & fullData{COUNT}.windDir < 80 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(5,:) = fullData{COUNT}.windDir > 80 & fullData{COUNT}.windDir < 100 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(6,:) = fullData{COUNT}.windDir > 100 & fullData{COUNT}.windDir < 120 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(7,:) = fullData{COUNT}.windDir > 120 & fullData{COUNT}.windDir < 140 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(8,:) = fullData{COUNT}.windDir > 140 & fullData{COUNT}.windDir < 160 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(9,:) = fullData{COUNT}.windDir > 160 & fullData{COUNT}.windDir < 180 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(10,:) = fullData{COUNT}.windDir > 180 & fullData{COUNT}.windDir < 200 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(11,:) = fullData{COUNT}.windDir > 200 & fullData{COUNT}.windDir < 220 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(12,:) = fullData{COUNT}.windDir > 220 & fullData{COUNT}.windDir < 240 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(13,:) = fullData{COUNT}.windDir > 240 & fullData{COUNT}.windDir < 260 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(14,:) = fullData{COUNT}.windDir > 260 & fullData{COUNT}.windDir < 280 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(15,:) = fullData{COUNT}.windDir > 280 & fullData{COUNT}.windDir < 300 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(16,:) = fullData{COUNT}.windDir > 300 & fullData{COUNT}.windDir < 320 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(17,:) = fullData{COUNT}.windDir > 320 & fullData{COUNT}.windDir < 340 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(18,:) = fullData{COUNT}.windDir > 340 & fullData{COUNT}.season ==season;
    end
end


%%

% average = zeros(1,height(windBins))
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(windDirBins{COUNT}{season})
            windDirScenario{COUNT}{season}{k}= fullData{COUNT}(windDirBins{COUNT}{season}(k,:),:);
            averagewindDir{COUNT}{season}(1,k) = mean(windDirScenario{COUNT}{season}{1,k}.detections);
            tiltCompareWindDir{COUNT}{season}(k) = mean(windDirScenario{COUNT}{season}{1,k}.tilt);
        end
    end
end

for COUNT = 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter = [averagewindDir{COUNT}{season},averagewindDir{COUNT+1}{season}];
        normalizedwindDir{COUNT}{season}  = averagewindDir{COUNT}{season}/(max(comboPlatter));
        normalizedwindDir{COUNT+1}{season}  = averagewindDir{COUNT+1}{season}/(max(comboPlatter));
    end
end




for COUNT = 1:length(normalizedwindDir)
    for season = 1:length(seasons)
        completeWindDir{COUNT}(season,:) = normalizedwindDir{COUNT}{season};
        completeTiltVswindDir{COUNT}(season,:)   = tiltCompareWindDir{COUNT}{season};
    end
end


for COUNT = 1:length(completeWindDir)
    completeWindsDirAvg(COUNT,:) = nanmean(completeWindDir{COUNT});
    completeTiltVsWindDirAvg(COUNT,:) = nanmean(completeTiltVswindDir{COUNT})
end

for COUNT = 1:length(completeWindsDirAvg)
    yearlywindDir(1,COUNT) = mean(completeWindsDirAvg(:,COUNT));
    yearlyTiltVswindDir(1,COUNT) = mean(completeTiltVsWindDirAvg(:,COUNT));
end
