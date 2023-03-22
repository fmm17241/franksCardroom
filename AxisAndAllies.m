%%
%Frank McQuarrie 3/22/23
%Creating a script to bin the dataset by winds AND tides; when they're
%parallel/perpendicular? To shore/to eachother? Gosh, it's gonna get
%confusing but may ellucidate why strong winds are seemingly so important
%to detection efficiency.

weakWindBin = cell(1,length(fullData));
for COUNT= 1:length(fullData)
    %Tides cross-shore and weak winds
    weakWindBin{COUNT}(1,:) =  fullData{COUNT}.uShore < -.4  & fullData{COUNT}.windSpeed     < 5;
    weakWindBin{COUNT}(2,:) =  fullData{COUNT}.uShore > -.4  & fullData{COUNT}.uShore < -.30 & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(3,:) =  fullData{COUNT}.uShore > -.30 & fullData{COUNT}.uShore < -.20 & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(4,:) =  fullData{COUNT}.uShore > -.20 & fullData{COUNT}.uShore < -.10 & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(5,:) =  fullData{COUNT}.uShore > -.10 & fullData{COUNT}.uShore < .10  & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(6,:) =  fullData{COUNT}.uShore > .10  & fullData{COUNT}.uShore < .20  & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(7,:) =  fullData{COUNT}.uShore > .20  & fullData{COUNT}.uShore < .30  & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(8,:) =  fullData{COUNT}.uShore > .30  & fullData{COUNT}.uShore < .40  & fullData{COUNT}.windSpeed  < 5;
    weakWindBin{COUNT}(9,:) =  fullData{COUNT}.uShore > .40  & fullData{COUNT}.windSpeed     < 5;
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


%Use the indices above and average
weakWindScenario= cell(1,length(fullData));
strongWindScenario= cell(1,length(fullData));
averagedWeak   = zeros(length(fullData),length(weakWindBin));
averagedStrong =zeros(length(fullData),length(strongWindBin));
for COUNT = 1:length(fullData)
    for k = 1:height(strongWindBin{COUNT})
        weakWindScenario{COUNT}{k}   = fullData{COUNT}(weakWindBin{COUNT}(k,:),:);
        strongWindScenario{COUNT}{k} = fullData{COUNT}(strongWindBin{COUNT}(k,:),:);
        %Average of values from those bins
        averagedWeak(COUNT,k) = mean(weakWindScenario{COUNT}{k}.detections);
        averagedStrong(COUNT,k) = mean(strongWindScenario{COUNT}{k}.detections);
        if isnan(averagedWeak(COUNT,k))
            averagedWeak(COUNT,k) = 0;
        end
        if isnan(averagedStrong(COUNT,k))
            averagedStrong(COUNT,k) = 0;
        end
    end   
end





 