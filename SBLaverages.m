%%
%Frank's calculating averages so its less squiggly. 
%just load it
fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

%%
% % Load in saved data
% Environmental data matched to the hourly snaps.
load envDataSpring
% % Full snaprate dataset
load snapRateDataSpring
% % Snaprate binned hourly
load snapRateHourlySpring
% % Snaprate binned per minute
load snapRateMinuteSpring
load surfaceDataSpring
load filteredData4Bin40HrLowSPRING

times = surfaceData.time;
%%

windSpeedBins(1,:) = surfaceData.WSPD < 2;
windSpeedBins(2,:) = surfaceData.WSPD > 2 & surfaceData.WSPD < 4 ;
windSpeedBins(3,:) = surfaceData.WSPD > 4 & surfaceData.WSPD < 6 ;
windSpeedBins(4,:) = surfaceData.WSPD > 6 & surfaceData.WSPD < 8 ;
windSpeedBins(5,:) = surfaceData.WSPD > 8 & surfaceData.WSPD < 10 ;
windSpeedBins(6,:) = surfaceData.WSPD > 10 & surfaceData.WSPD < 12 ;
windSpeedBins(7,:) = surfaceData.WSPD > 12 & surfaceData.WSPD < 14 ;
windSpeedBins(8,:) = surfaceData.WSPD > 14;


windSpeedFiltBins(1,:) = filteredData.Winds < 2;
windSpeedFiltBins(2,:) = filteredData.Winds > 2 & filteredData.Winds < 4 ;
windSpeedFiltBins(3,:) = filteredData.Winds > 4 & filteredData.Winds < 6 ;
windSpeedFiltBins(4,:) = filteredData.Winds > 6 & filteredData.Winds < 8 ;
windSpeedFiltBins(5,:) = filteredData.Winds > 8 & filteredData.Winds < 10 ;
windSpeedFiltBins(6,:) = filteredData.Winds > 10 & filteredData.Winds < 12 ;
windSpeedFiltBins(7,:) = filteredData.Winds > 12 & filteredData.Winds < 14 ;
windSpeedFiltBins(8,:) = filteredData.Winds > 14;



for k = 1:height(windSpeedBins)
    windSpeedScenario{k}= surfaceData(windSpeedBins(k,:),:);
    % averageSBL(1,k) = mean(windSpeedScenario{1,k}.HourlyDets);
   
    % countAnnual(1,k)             = length(windSpeedScenario{k}.HourlyDets)
end
normalizedWSpeedAnnual(COUNT,:)  = averageWindSpeed(COUNT,:)/(max(averageWindSpeed(COUNT,:)));



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
        errorWindAnnual(COUNT,k) = std(windSpeedScenario{COUNT}{k}.HourlyDets,'omitnan')
    end
end


for COUNT = 1:length(windSpeedScenario)
    for k = 1:height(windSpeedBinsAnnual{COUNT})
        errorWSpeedAnnual(COUNT,k) = std(averageWindSpeed(COUNT,k),'omitnan')
    end
end


for COUNT = 1:2:length(receiverData)-1
    for season = 1:length(seasons)
        comboPlatter = [averageWindSpeed{COUNT}{season},averageWindSpeed{COUNT+1}{season}];
        normalizedWSpeed{COUNT}{season}  = averageWindSpeed{COUNT}{season}/(max(comboPlatter));
        normalizedWSpeed{COUNT+1}{season}  = averageWindSpeed{COUNT+1}{season}/(max(comboPlatter));
    end
end
