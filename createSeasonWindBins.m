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

for 
tryThis{1} = zeros(1,1);

for COUNT = 1:length(fullData)
    w