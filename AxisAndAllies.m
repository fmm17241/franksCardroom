%%
%Frank McQuarrie 3/22/23
%Creating a script to bin the dataset by winds AND tides; when they're
%parallel/perpendicular? To shore/to eachother? Gosh, it's gonna get
%confusing but may ellucidate why strong winds are seemingly so important
%to detection efficiency.

weakWindBin = cell(1,length(fullData));
for COUNT= 1:length(fullData)
    %Tides cross-shore and weak winds
    weakWindBin{COUNT}(1,:) =  fullData{COUNT}.uShore < -.4  & fullData{COUNT}.windSpeed < 5;
    weakWindBin{COUNT}(2,:) =  fullData{COUNT}.uShore > -.4  & fullData{COUNT}.uShore < -.30 & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(3,:) =  fullData{COUNT}.uShore > -.30 & fullData{COUNT}.uShore < -.20 & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(4,:) =  fullData{COUNT}.uShore > -.20 & fullData{COUNT}.uShore < -.10 & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(5,:) =  fullData{COUNT}.uShore > -.10 & fullData{COUNT}.uShore < .10  & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(6,:) =  fullData{COUNT}.uShore > .10  & fullData{COUNT}.uShore < .20  & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(7,:) =  fullData{COUNT}.uShore > .20  & fullData{COUNT}.uShore < .30  & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(8,:) =  fullData{COUNT}.uShore > .30  & fullData{COUNT}.uShore < .40  & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(9,:) =  fullData{COUNT}.uShore > .40  & fullData{COUNT}.windSpeed  < 5;
end

strongWindBin = cell(1,length(fullData));
for COUNT= 1:length(fullData)
    %Tides cross-shore and strong winds
    strongWindBin{COUNT}(1,:) =  fullData{COUNT}.uShore < -.4  &  fullData{COUNT}.windSpeed > 12;
    strongWindBin{COUNT}(2,:) =  fullData{COUNT}.uShore > -.4  &  fullData{COUNT}.uShore < -.30 & fullData{COUNT}.windSpeed  > 12;
    strongWindBin{COUNT}(3,:) =  fullData{COUNT}.uShore > -.30 &  fullData{COUNT}.uShore < -.20 & fullData{COUNT}.windSpeed  > 12;
    strongWindBin{COUNT}(4,:) =  fullData{COUNT}.uShore > -.20 &  fullData{COUNT}.uShore < -.10 & fullData{COUNT}.windSpeed  > 12;
    strongWindBin{COUNT}(5,:) =  fullData{COUNT}.uShore > -.10 &  fullData{COUNT}.uShore < .10  & fullData{COUNT}.windSpeed  > 12;
    strongWindBin{COUNT}(6,:) =  fullData{COUNT}.uShore > .10  &  fullData{COUNT}.uShore < .20  & fullData{COUNT}.windSpeed  > 12;
    strongWindBin{COUNT}(7,:) =  fullData{COUNT}.uShore > .20  &  fullData{COUNT}.uShore < .30  & fullData{COUNT}.windSpeed  > 12;
    strongWindBin{COUNT}(8,:) =  fullData{COUNT}.uShore > .30  &  fullData{COUNT}.uShore < .40  & fullData{COUNT}.windSpeed  > 12;
    strongWindBin{COUNT}(9,:) =  fullData{COUNT}.uShore > .40  &  fullData{COUNT}.windSpeed  > 12;
end

weakWindScenario= cell(1,length(fullData));
strongWindScenario= cell(1,length(fullData));
averagedWeak= cell(1,length(fullData));
averagedStrong = cell(1,length(fullData));
for COUNT = 1:length(fullData)
    for k = 1:height(strongWindBin{COUNT})
        weakWindScenario{COUNT}{k}   = fullData{COUNT}(weakWindBin{COUNT}(k,:),:);
        strongWindScenario{COUNT}{k} = fullData{COUNT}(strongWindBin{COUNT}(k,:),:);
        %Average of values from those bins
        averagedWeak{COUNT}(1,k) = mean(weakWindScenario{COUNT}{k}.detections);
        averagedStrong{COUNT}(1,k) = mean(strongWindScenario{COUNT}{k}.detections);
    end   
end


for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(tideBinsParaABS{COUNT}{season})
            tideScenarioParaABS{COUNT}{season}{k}= fullData{COUNT}(tideBinsParaABS{COUNT}{season}(k,:),:);
            averageParaTideABS{COUNT}{season}(1,k) = mean(tideScenarioParaABS{COUNT}{season}{1,k}.detections);
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



castle = 