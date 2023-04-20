
%FM 4/20


%
weakWindBin = cell(1,length(fullData));
strongWindBin = cell(1,length(fullData));
for COUNT= 1:length(fullData)
    for season = 1:length(seasons)
        %Tides cross-shore and weak winds
        weakWindBin{COUNT}{season,:} = fullData{COUNT}.windSpeed   < 5 & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season,:} = fullData{COUNT}.windSpeed > 10 & fullData{COUNT}.season ==season;
    end
end


%Use the indices above and average
% weakWindScenario= cell(1,length(fullData));
% strongWindScenario= cell(1,length(fullData));
% averagedWeak   = zeros(length(fullData),:);
% averagedStrong =zeros(length(fullData,:));
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(strongWindBin{COUNT}{season})
            weakWindScenario{COUNT}{season,k}    = fullData{1,COUNT}(weakWindBin{1,COUNT}{season,:},:);
            strongWindScenario{COUNT}{season,k}  = fullData{1,COUNT}(strongWindBin{1,COUNT}{season,:},:);
            %Average of values from those bins
            averagedWeak{COUNT}(season,k) = nanmean(weakWindScenario{COUNT}{season,k}.detections);
            averagedStrong{COUNT}(season,k) = nanmean(strongWindScenario{COUNT}{season,k}.detections);
            if isnan(averagedWeak{COUNT}(season,k))
                averagedWeak{COUNT}(season,k) = 0;
            end
            if isnan(averagedStrong{COUNT}(season,k))
                averagedStrong{COUNT}(season,k) = 0;
            end
        end
    end
end


% Finding errorbars for weak wind scenarios
for COUNT = 1:length(weakWindScenario)
    for season = 1:height(weakWindScenario{COUNT})
        for k = 1:length(weakWindScenario{COUNT})
            if isempty(weakWindScenario{COUNT}{season,k}) == 1
                errorWeakWind{COUNT}(season,k) = 0;
                continue
            end
            errorWeakWind{COUNT}(season,k) = std(weakWindScenario{COUNT}{season,k}.detections)
        end
    end
end

% Finding errorbars for strong wind scenarios
for COUNT = 1:length(strongWindScenario)
    for season = 1:height(strongWindScenario{COUNT})
        for k = 1:length(strongWindScenario{COUNT})
            if isempty(strongWindScenario{COUNT}{season,k}) == 1
                errorstrongWind{COUNT}(season,k) = 0;
                continue
            end
            errorstrongWind{COUNT}(season,k) = std(strongWindScenario{COUNT}{season,k}.detections)
        end
    end
end


X = 0:14;

figure()