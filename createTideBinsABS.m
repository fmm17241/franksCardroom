%These find absolute value for the tidal directions; this is to compare the
% two different directions.

for COUNT= 1:length(fullData)
    for k = 1:length(seasons)
        %Parallel: X-axis of our tides, aligned with transmissions

        tideBinsParaABS{COUNT}{k}(1,:) =  abs(fullData{COUNT}.paraTide) < 0.05 & fullData{COUNT}.season ==k;

        tideBinsParaABS{COUNT}{k}(2,:) =  abs(fullData{COUNT}.paraTide) > .05 &  abs(fullData{COUNT}.paraTide) < .1 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(3,:) =  abs(fullData{COUNT}.paraTide) > .10 &  abs(fullData{COUNT}.paraTide)< .15 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(4,:) =  abs(fullData{COUNT}.paraTide)> .15 & abs(fullData{COUNT}.paraTide)< .2 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(5,:) =  abs(fullData{COUNT}.paraTide)> .20 &  abs(fullData{COUNT}.paraTide)< .25 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(6,:) =  abs(fullData{COUNT}.paraTide)> .25 &  abs(fullData{COUNT}.paraTide)< .3 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(7,:) =  abs(fullData{COUNT}.paraTide)> .30 &  abs(fullData{COUNT}.paraTide)< .35 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(8,:) =  abs(fullData{COUNT}.paraTide)> .35 &  abs(fullData{COUNT}.paraTide)< .4 & fullData{COUNT}.season ==k;
        tideBinsParaABS{COUNT}{k}(9,:) =  abs(fullData{COUNT}.paraTide)> .40 & fullData{COUNT}.season ==k;
    
    %Perpendicular: Y-axis of our tides, perpendicular to transmissions
        tideBinsPerpABS{COUNT}{k}(1,:) = abs(fullData{COUNT}.perpTide) < 0.05 & fullData{COUNT}.season ==k;

        tideBinsPerpABS{COUNT}{k}(2,:) = abs(fullData{COUNT}.perpTide)> .05 & abs(fullData{COUNT}.perpTide)< .10 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(3,:) = abs(fullData{COUNT}.perpTide)> .10 & abs(fullData{COUNT}.perpTide)< 0.15 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(4,:) = abs(fullData{COUNT}.perpTide)> .15 & abs(fullData{COUNT}.perpTide)< .20 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(5,:) = abs(fullData{COUNT}.perpTide)> .20 & abs(fullData{COUNT}.perpTide)< .25 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(6,:) = abs(fullData{COUNT}.perpTide)> .25 & abs(fullData{COUNT}.perpTide)< .30 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(7,:) = abs(fullData{COUNT}.perpTide)> .30 & abs(fullData{COUNT}.perpTide)< .35 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(8,:) = abs(fullData{COUNT}.perpTide)> .35 & abs(fullData{COUNT}.perpTide)< .40 & fullData{COUNT}.season ==k;
        tideBinsPerpABS{COUNT}{k}(9,:) = abs(fullData{COUNT}.perpTide)> .40 & fullData{COUNT}.season ==k;
    end
end

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(tideBinsParaABS{COUNT}{season})
            tideScenarioParaABS{COUNT}{season}{k}= fullData{COUNT}(tideBinsParaABS{COUNT}{season}(k,:),:);
            tideScenarioPerpABS{COUNT}{season}{k}= fullData{COUNT}(tideBinsPerpABS{COUNT}{season}(k,:),:);
            averageParaTideABS{COUNT}{season}(1,k) = mean(tideScenarioParaABS{COUNT}{season}{1,k}.detections);
            averagePerpTideABS{COUNT}{season}(1,k) = mean(tideScenarioPerpABS{COUNT}{season}{1,k}.detections);
            if isnan(averageParaTideABS{COUNT}{season}(1,k))
                averageParaTideABS{COUNT}{season}(1,k) = 0;
            end
            if isnan(averagePerpTideABS{COUNT}{season}(1,k))
                averagePerpTideABS{COUNT}{season}(1,k) = 0;
            end
        end
%         if isempty(averageParaTide{COUNT}{season}) ==1
%             moddedAveragePara{COUNT}{season}  = 0;
%             moddedAveragePerp{COUNT}{season}  = 0;
%             continue
%         end

    end
end

for COUNT= 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter = [averageParaTideABS{COUNT}{season},averageParaTideABS{COUNT+1}{season}];
        normalizedParaABS{COUNT}{season}  = averageParaTideABS{COUNT}{season}/(max(comboPlatter));
        normalizedParaABS{COUNT+1}{season}  = averageParaTideABS{COUNT+1}{season}/(max(comboPlatter));
    end
end



for COUNT = 1:length(normalizedParaABS)
    for season = 1:length(seasons)
        allParaABS{COUNT}(season,:) = normalizedParaABS{COUNT}{season};
    end
end

%Whole year
for COUNT = 1:length(allParaABS)
    yearlyParaABS{COUNT} = mean(allParaABS{COUNT},1)
end
