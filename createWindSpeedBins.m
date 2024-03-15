%Doing the same for my wind data
seasons = [1:5];

for COUNT = 1:length(receiverData)
    for season = 1:length(seasons)
        windSpeedBins{COUNT}{season}(1,:) = receiverData{COUNT}.windSpd < 2 & receiverData{COUNT}.Season ==season;
        windSpeedBins{COUNT}{season}(2,:) = receiverData{COUNT}.windSpd > 2 & receiverData{COUNT}.windSpd < 4 & receiverData{COUNT}.Season ==season;
        windSpeedBins{COUNT}{season}(3,:) = receiverData{COUNT}.windSpd > 4 & receiverData{COUNT}.windSpd < 6 & receiverData{COUNT}.Season ==season;
        windSpeedBins{COUNT}{season}(4,:) = receiverData{COUNT}.windSpd > 6 & receiverData{COUNT}.windSpd < 8 & receiverData{COUNT}.Season ==season;
        windSpeedBins{COUNT}{season}(5,:) = receiverData{COUNT}.windSpd > 8 & receiverData{COUNT}.windSpd < 10 & receiverData{COUNT}.Season ==season;
        windSpeedBins{COUNT}{season}(6,:) = receiverData{COUNT}.windSpd > 10 & receiverData{COUNT}.windSpd < 12 & receiverData{COUNT}.Season ==season;
        windSpeedBins{COUNT}{season}(7,:) = receiverData{COUNT}.windSpd > 12  & receiverData{COUNT}.Season ==season;
%         windSpeedBins{COUNT}{season}(7,:) = receiverData{COUNT}.windSpd > 6 & receiverData{COUNT}.windSpd < 7 & receiverData{COUNT}.season ==season;
%         windSpeedBins{COUNT}{season}(8,:) = receiverData{COUNT}.windSpd > 7 & receiverData{COUNT}.windSpd < 8 & receiverData{COUNT}.season ==season;
%         windSpeedBins{COUNT}{season}(9,:) = receiverData{COUNT}.windSpd > 8 & receiverData{COUNT}.windSpd < 9 & receiverData{COUNT}.season ==season;
%         windSpeedBins{COUNT}{season}(10,:) = receiverData{COUNT}.windSpd > 9 & receiverData{COUNT}.windSpd < 10 & receiverData{COUNT}.season ==season;
%         windSpeedBins{COUNT}{season}(11,:) = receiverData{COUNT}.windSpd > 10 & receiverData{COUNT}.windSpd < 11 & receiverData{COUNT}.season ==season;
%         windSpeedBins{COUNT}{season}(12,:) = receiverData{COUNT}.windSpd > 11 & receiverData{COUNT}.windSpd < 12 & receiverData{COUNT}.season ==season;
%         windSpeedBins{COUNT}{season}(13,:) = receiverData{COUNT}.windSpd > 12 & receiverData{COUNT}.season ==season;
    end
end

%%
for COUNT = 1:length(receiverData)
    windSpeedBinsAnnual{COUNT}(1,:) = receiverData{COUNT}.windSpd < 1 ;
    windSpeedBinsAnnual{COUNT}(2,:) = receiverData{COUNT}.windSpd > 1 & receiverData{COUNT}.windSpd < 2 ;
    windSpeedBinsAnnual{COUNT}(3,:) = receiverData{COUNT}.windSpd > 2 & receiverData{COUNT}.windSpd < 3 ;
    windSpeedBinsAnnual{COUNT}(4,:) = receiverData{COUNT}.windSpd > 3 & receiverData{COUNT}.windSpd < 4 ;
    windSpeedBinsAnnual{COUNT}(5,:) = receiverData{COUNT}.windSpd > 4 & receiverData{COUNT}.windSpd < 5 ;
    windSpeedBinsAnnual{COUNT}(6,:) = receiverData{COUNT}.windSpd > 5 & receiverData{COUNT}.windSpd < 6 ;
    windSpeedBinsAnnual{COUNT}(7,:) = receiverData{COUNT}.windSpd > 6 & receiverData{COUNT}.windSpd < 7 ;
    windSpeedBinsAnnual{COUNT}(8,:) = receiverData{COUNT}.windSpd > 7 & receiverData{COUNT}.windSpd < 8 ;
    windSpeedBinsAnnual{COUNT}(9,:) = receiverData{COUNT}.windSpd > 8 & receiverData{COUNT}.windSpd < 9 ;
    windSpeedBinsAnnual{COUNT}(10,:) = receiverData{COUNT}.windSpd > 9 & receiverData{COUNT}.windSpd < 10 ;
    windSpeedBinsAnnual{COUNT}(11,:) = receiverData{COUNT}.windSpd > 10 & receiverData{COUNT}.windSpd < 11 ;
    windSpeedBinsAnnual{COUNT}(12,:) = receiverData{COUNT}.windSpd > 11 & receiverData{COUNT}.windSpd < 12 ;
    windSpeedBinsAnnual{COUNT}(13,:) = receiverData{COUNT}.windSpd > 12 ;
end



for COUNT = 1:length(receiverData)
    for k = 1:height(windSpeedBinsAnnual{COUNT})
        windSpeedScenarioAnnual{COUNT}{k}= receiverData{COUNT}(windSpeedBinsAnnual{COUNT}(k,:),:);
        averageWindSpeedAnnual(COUNT,k) = mean(windSpeedScenarioAnnual{COUNT}{1,k}.HourlyDets);
        noiseCompareAnnual{COUNT}(k) = mean(windSpeedScenarioAnnual{COUNT}{1,k}.Noise);
        wavesCompareAnnual{COUNT}(k) = mean(windSpeedScenarioAnnual{COUNT}{1,k}.waveHeight,'omitnan');
        tiltCompareWindAnnual{COUNT}(k) = mean(windSpeedScenarioAnnual{COUNT}{1,k}.Tilt);
        stratCompareWindAnnual{COUNT}(k) = mean(windSpeedScenarioAnnual{COUNT}{1,k}.bulkThermalStrat)
        
        countAnnual(COUNT,k)             = length(windSpeedScenarioAnnual{COUNT}{k}.HourlyDets)
    end
    normalizedWSpeedAnnual(COUNT,:)  = averageWindSpeedAnnual(COUNT,:)/(max(averageWindSpeedAnnual(COUNT,:)));
end


%%

% average = zeros(1,height(windBins))
for COUNT = 1:length(receiverData)
    for season = 1:length(seasons)
        for k = 1:height(windSpeedBins{COUNT}{season})
            windSpeedScenario{COUNT}{season}{k}= receiverData{COUNT}(windSpeedBins{COUNT}{season}(k,:),:);
            averageWindSpeed{COUNT}{season}(1,k) = mean(windSpeedScenario{COUNT}{season}{1,k}.HourlyDets);
            noiseCompare{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.Noise);
            wavesCompare{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.waveHeight);
            tiltCompareWind{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.Tilt);
            stratCompareWind{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.bulkThermalStrat)
        end
        normalizedWSpeed{COUNT}{season}  = averageWindSpeed{COUNT}{season}/(max(averageWindSpeed{COUNT}{season}));
    end
end


for COUNT = 1:length(windSpeedScenario)
    for season = 1:length(seasons)
        errorWind(COUNT,season) = std(averageWindSpeed{COUNT}{season},'omitnan');
        errorNoise(COUNT,season) = std(noiseCompare{COUNT}{season},'omitnan');
        errorStrat(COUNT,season) = std(stratCompareWind{COUNT}{season},'omitnan');
    end
end





for COUNT = 1:length(windSpeedScenario)
    for k = 1:height(windSpeedBinsAnnual{COUNT})
        errorWindAnnual(COUNT,k) = std(windSpeedScenarioAnnual{COUNT}{k}.HourlyDets,'omitnan')
    end
end


for COUNT = 1:length(windSpeedScenario)
    for k = 1:height(windSpeedBinsAnnual{COUNT})
        errorWSpeedAnnual(COUNT,k) = std(averageWindSpeedAnnual(COUNT,k),'omitnan')
    end
end


for COUNT = 1:2:length(receiverData)-1
    for season = 1:length(seasons)
        comboPlatter = [averageWindSpeed{COUNT}{season},averageWindSpeed{COUNT+1}{season}];
        normalizedWSpeed{COUNT}{season}  = averageWindSpeed{COUNT}{season}/(max(comboPlatter));
        normalizedWSpeed{COUNT+1}{season}  = averageWindSpeed{COUNT+1}{season}/(max(comboPlatter));
    end
end

% 
% for COUNT = 1:length(normalizedWSpeed)
%     for season = 1:length(seasons)
%         completeWinds{COUNT}(season,:) = normalizedWSpeed{COUNT}{season};
%         completeWHeight{COUNT}(season,:) = wavesCompare{COUNT}{season};
%         completeNoise{COUNT}(season,:)   = noiseCompare{COUNT}{season};
%         completeTiltVsWindSpeed{COUNT}(season,:)   = tiltCompareWind{COUNT}{season};
%         completeStratVsWindSpeed{COUNT}(season,:)  = stratCompareWind{COUNT}{season};
%     end
% end
% 
% 
% for COUNT = 1:length(completeWinds)
%     completeWindsAvg(COUNT,:) = nanmean(completeWinds{COUNT});
%     completeNoiseAvg(COUNT,:) = nanmean(completeNoise{COUNT});
%     completeTiltVsWindAvg(COUNT,:) = nanmean(completeTiltVsWindSpeed{COUNT});
%     completeStratVsWindAvg(COUNT,:) = nanmean(completeStratVsWindSpeed{COUNT})
% end
% 
% for COUNT = 1:length(completeWindsAvg)
%     yearlyWindSpeed(1,COUNT)       = mean(completeWindsAvg(:,COUNT));
%     yearlyNoise(1,COUNT)           = mean(completeNoiseAvg(:,COUNT));  
%     yearlyTiltVsWindSpeed(1,COUNT) = mean(completeTiltVsWindAvg(:,COUNT));
%     yearlyStratVsWindSpeed(1,COUNT) = mean(completeStratVsWindAvg(:,COUNT));
% end

% normalizedYearlyWind = yearlyWindSpeed/(max(yearlyWindSpeed));





