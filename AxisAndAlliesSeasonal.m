%%
%Frank McQuarrie 3/22/23
%Creating a script to bin the dataset by winds AND tides; when they're
%parallel/perpendicular? To shore/to eachother? Gosh, it's gonna get
%confusing but may ellucidate why strong winds are seemingly so important
%to detection efficiency.

weakWindBin = cell(1,length(fullData));
for COUNT= 1:length(fullData)
    for season = 1:length(seasons)
        %Tides cross-shore and weak winds
        weakWindBin{COUNT}{season}(1,:) =  fullData{COUNT}.uShore < -.4  & fullData{COUNT}.windSpeed     < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(2,:) =  fullData{COUNT}.uShore > -.4  & fullData{COUNT}.uShore < -.35 & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(3,:) =  fullData{COUNT}.uShore > -.35 & fullData{COUNT}.uShore < -.30 & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(4,:) =  fullData{COUNT}.uShore > -.30 & fullData{COUNT}.uShore < -.25 & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(5,:) =  fullData{COUNT}.uShore > -.25 & fullData{COUNT}.uShore < -.20  & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(6,:) =  fullData{COUNT}.uShore > -.20  & fullData{COUNT}.uShore < -.15  & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(7,:) =  fullData{COUNT}.uShore > -.15  & fullData{COUNT}.uShore < -.10  & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(8,:) =  fullData{COUNT}.uShore > -.10  & fullData{COUNT}.uShore < -.05  & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(9,:) =  fullData{COUNT}.uShore > -.05 & fullData{COUNT}.uShore < .05 & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(10,:) =  fullData{COUNT}.uShore > .05 & fullData{COUNT}.uShore < .10 & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(11,:) =  fullData{COUNT}.uShore > .10 & fullData{COUNT}.uShore < .15  & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(12,:) =  fullData{COUNT}.uShore > .15  & fullData{COUNT}.uShore < .20  & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(13,:) =  fullData{COUNT}.uShore > .20  & fullData{COUNT}.uShore < .25  & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(14,:) =  fullData{COUNT}.uShore > .25  & fullData{COUNT}.uShore < .30  & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(15,:) =  fullData{COUNT}.uShore > .30  & fullData{COUNT}.uShore < .35  & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(16,:) =  fullData{COUNT}.uShore > .35  & fullData{COUNT}.uShore < .40  & fullData{COUNT}.windSpeed  < 3 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(17,:) =  fullData{COUNT}.uShore > .40  & fullData{COUNT}.windSpeed     < 3 & fullData{COUNT}.season ==season;
    end

end


strongWindBin = cell(1,length(fullData));
for COUNT= 1:length(fullData)
    for season = 1:length(seasons)
    %Tides cross-shore and strong winds
    strongWindBin{COUNT}{season}(1,:) =  fullData{COUNT}.uShore < -.4  & fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(2,:) =  fullData{COUNT}.uShore > -.4  & fullData{COUNT}.uShore < -.35 & fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(3,:) =  fullData{COUNT}.uShore > -.35 & fullData{COUNT}.uShore < -.30 & fullData{COUNT}.windSpeed  > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(4,:) =  fullData{COUNT}.uShore > -.30 & fullData{COUNT}.uShore < -.25 & fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(5,:) =  fullData{COUNT}.uShore > -.25 & fullData{COUNT}.uShore < -.20  & fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(6,:) =  fullData{COUNT}.uShore > -.20  & fullData{COUNT}.uShore < -.15  & fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(7,:) =  fullData{COUNT}.uShore > -.15  & fullData{COUNT}.uShore < -.10  & fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(8,:) =  fullData{COUNT}.uShore > -.10  & fullData{COUNT}.uShore < -.05  & fullData{COUNT}.windSpeed  > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(9,:) =  fullData{COUNT}.uShore > -.05 & fullData{COUNT}.uShore < .05 & fullData{COUNT}.windSpeed  > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(10,:) =  fullData{COUNT}.uShore > .05 & fullData{COUNT}.uShore < .10 & fullData{COUNT}.windSpeed  > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(11,:) =  fullData{COUNT}.uShore > .10 & fullData{COUNT}.uShore < .15  & fullData{COUNT}.windSpeed  > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(12,:) =  fullData{COUNT}.uShore > .15  & fullData{COUNT}.uShore < .20  & fullData{COUNT}.windSpeed  > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(13,:) =  fullData{COUNT}.uShore > .20  & fullData{COUNT}.uShore < .25  & fullData{COUNT}.windSpeed  > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(14,:) =  fullData{COUNT}.uShore > .25  & fullData{COUNT}.uShore < .30  & fullData{COUNT}.windSpeed  > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(15,:) =  fullData{COUNT}.uShore > .30  & fullData{COUNT}.uShore < .35  & fullData{COUNT}.windSpeed  > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(16,:) =  fullData{COUNT}.uShore > .35  & fullData{COUNT}.uShore < .40  & fullData{COUNT}.windSpeed  > 12 & fullData{COUNT}.season ==season;
    strongWindBin{COUNT}{season}(17,:) =  fullData{COUNT}.uShore > .40  & fullData{COUNT}.windSpeed     > 12 & fullData{COUNT}.season ==season;
    end
end


%Use the indices above and average
% weakWindScenario= cell(1,length(fullData));
% strongWindScenario= cell(1,length(fullData));
% averagedWeak   = zeros(length(fullData),:);
% averagedStrong =zeros(length(fullData,:));
for COUNT = 1:length(fullData)
    for k = 1:height(strongWindBin{COUNT})
        weakWindScenario{COUNT}{k}    = fullData{1,COUNT}(weakWindBin{1,COUNT}(k,:),:);
        strongWindScenario{COUNT}{k}  = fullData{1,COUNT}(strongWindBin{1,COUNT}(k,:),:);
        %Average of values from those bins
        averagedWeak(COUNT,k) = nanmean(weakWindScenario{COUNT}{k}.detections);
        averagedStrong(COUNT,k) = nanmean(strongWindScenario{COUNT}{k}.detections);
        if isnan(averagedWeak(COUNT,k))
            averagedWeak(COUNT,k) = 0;
        end
        if isnan(averagedStrong(COUNT,k))
            averagedStrong(COUNT,k) = 0;
        end
    end

end


% Normalizing the data for each transceiver pairing. Instead of each set of
% detections having its own maximum, this uses the relationship between the
% two together. Two transmissions traveling the same distance in the same
% water column, opposite directions. This isolates that direction/transceiver.
for COUNT = 1:2:length(fullData)
    comboPlatter1 = [averagedStrong(COUNT,:),averagedStrong(COUNT+1,:)]
    comboPlatter2 = [averagedWeak(COUNT,:),averagedWeak(COUNT+1,:)]
    normalizedStrong(COUNT,:)  = averagedStrong(COUNT,:)/(max(comboPlatter1));
    normalizedStrong(COUNT+1,:)  = averagedStrong(COUNT+1,:)/(max(comboPlatter1));
    normalizedWeak(COUNT,:)  = averagedWeak(COUNT,:)/(max(comboPlatter2));
    normalizedWeak(COUNT+1,:)  = averagedWeak(COUNT+1,:)/(max(comboPlatter2));
end


%Whole year

yearlyStrong = mean(normalizedStrong,1)
yearlyWeak = mean(normalizedWeak,1)

x = -.4:.05:.4;


figure()
scatter(x,yearlyStrong,'r','filled')
hold on
scatter(x,yearlyWeak,'b','filled')
legend('Strong Winds(>12 m/s)','Weak Winds(<3 m/s)')
title('Yearly AVG Detections w/ Strong/Weak Tides & Winds')
xlabel('Tidal Magnitude')
ylabel('Normalized Detection Efficiency')

figure()
hold on
for COUNT = 1:length(fullData)
    figure()
    hold on
    scatter(x,averagedStrong(COUNT,:),'r','filled')
    scatter(x,averagedWeak(COUNT,:),'b','filled')
    ylabel('Avg Det Efficiency')
    xlabel('Tidal Velocity (m/s)')
    ylim([0 6])
    title(sprintf('Transceiver Pairing %d, Winds & Tides',COUNT))
    legend('Strong Winds','Weak Winds')
end




 