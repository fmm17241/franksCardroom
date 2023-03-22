% FM 3/22/23 Bins fullData by amount of tilt felt by the instruments.
% 
% First use binnedAVG



for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        tiltBins{COUNT}{season}(1,:) = fullData{COUNT}.tilt < 2 & fullData{COUNT}.season == season;
        tiltBins{COUNT}{season}(2,:) = fullData{COUNT}.tilt > 2 & fullData{COUNT}.tilt < 4 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(3,:) = fullData{COUNT}.tilt > 4 & fullData{COUNT}.tilt < 6 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(4,:) = fullData{COUNT}.tilt > 6 & fullData{COUNT}.tilt < 8 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(5,:) = fullData{COUNT}.tilt > 8 & fullData{COUNT}.tilt < 10 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(6,:) = fullData{COUNT}.tilt > 10 & fullData{COUNT}.tilt < 12 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(7,:) = fullData{COUNT}.tilt > 12 & fullData{COUNT}.tilt < 14 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(8,:) = fullData{COUNT}.tilt > 14 & fullData{COUNT}.tilt < 16 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(9,:) = fullData{COUNT}.tilt > 16 & fullData{COUNT}.tilt < 18 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(10,:) = fullData{COUNT}.tilt > 18 & fullData{COUNT}.tilt < 20 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(11,:) = fullData{COUNT}.tilt > 20 & fullData{COUNT}.tilt < 22 & fullData{COUNT}.season ==season;
        tiltBins{COUNT}{season}(12,:) = fullData{COUNT}.tilt > 22 & fullData{COUNT}.season ==season;
    end
end


%%

% average = zeros(1,height(tiltBins))
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(tiltBins{COUNT}{season})
            tiltScenario{COUNT}{season}{k}= fullData{COUNT}(tiltBins{COUNT}{season}(k,:),:);
            averageTilt{COUNT}{season}(1,k) = mean(tiltScenario{COUNT}{season}{1,k}.detections);
            if isnan(averageTilt{COUNT}{season}(1,k))
                averageTilt{COUNT}{season}(1,k) = 0;
            end
        end

    end
end

for COUNT = 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter = [averageTilt{COUNT}{season},averageTilt{COUNT+1}{season}];
        normalizedTilt{COUNT}{season}  = averageTilt{COUNT}{season}/(max(comboPlatter));
        normalizedTilt{COUNT+1}{season}  = averageTilt{COUNT+1}{season}/(max(comboPlatter));
    end
end


for COUNT = 1:length(normalizedTilt)
    for season = 1:length(seasons)
        completeTilt{COUNT}(season,:) = normalizedTilt{COUNT}{season};
    end
end


for COUNT = 1:length(completeTilt)
    completeTiltAvg(COUNT,:) = nanmean(completeTilt{COUNT});
end

for COUNT = 1:length(completeTiltAvg)
    yearlyTilt(1,COUNT) = mean(completeTiltAvg(:,COUNT))
end
