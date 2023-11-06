%Frank wants to show relationship in easy way


for COUNT = 1:length(fullData)
        noiseBinsAnnual{COUNT}(1,:) = fullData{COUNT}.noise < 450;
        noiseBinsAnnual{COUNT}(2,:) = fullData{COUNT}.noise > 450 & fullData{COUNT}.noise < 500;
        noiseBinsAnnual{COUNT}(3,:) = fullData{COUNT}.noise > 500 & fullData{COUNT}.noise < 550;
        noiseBinsAnnual{COUNT}(4,:) = fullData{COUNT}.noise > 550 & fullData{COUNT}.noise < 600;
        noiseBinsAnnual{COUNT}(5,:) = fullData{COUNT}.noise > 600 & fullData{COUNT}.noise < 650;
        noiseBinsAnnual{COUNT}(6,:) = fullData{COUNT}.noise > 650 & fullData{COUNT}.noise < 700;
        noiseBinsAnnual{COUNT}(7,:) = fullData{COUNT}.noise > 700 & fullData{COUNT}.noise < 750;
        noiseBinsAnnual{COUNT}(8,:) = fullData{COUNT}.noise > 750;
end

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        noiseBins{COUNT}{season}(1,:) = fullData{COUNT}.noise < 450 & fullData{COUNT}.season ==season;
        noiseBins{COUNT}{season}(2,:) = fullData{COUNT}.noise > 450 & fullData{COUNT}.noise < 500 & fullData{COUNT}.season ==season;
        noiseBins{COUNT}{season}(3,:) = fullData{COUNT}.noise > 500 & fullData{COUNT}.noise < 550 & fullData{COUNT}.season ==season;
        noiseBins{COUNT}{season}(4,:) = fullData{COUNT}.noise > 550 & fullData{COUNT}.noise < 600 & fullData{COUNT}.season ==season;
        noiseBins{COUNT}{season}(5,:) = fullData{COUNT}.noise > 600 & fullData{COUNT}.noise < 650 & fullData{COUNT}.season ==season;
        noiseBins{COUNT}{season}(6,:) = fullData{COUNT}.noise > 650 & fullData{COUNT}.noise < 700 & fullData{COUNT}.season ==season;
        noiseBins{COUNT}{season}(7,:) = fullData{COUNT}.noise > 700 & fullData{COUNT}.noise < 750 & fullData{COUNT}.season ==season;
        noiseBins{COUNT}{season}(8,:) = fullData{COUNT}.noise > 750 & fullData{COUNT}.season ==season;
    end
end


for COUNT = 1:length(fullData)
    for k = 1:height(noiseBinsAnnual{COUNT})
        noiseScenarioAnnual{COUNT}{k}= fullData{COUNT}(noiseBinsAnnual{COUNT}(k,:),:);
        averageNoiseAnnual(COUNT,k) = mean(noiseScenarioAnnual{COUNT}{1,k}.detections)/6*100;
        noiseCompareAnnual{COUNT}(k) = mean(noiseScenarioAnnual{COUNT}{1,k}.noise);
        wavesCompareAnnual{COUNT}(k) = mean(noiseScenarioAnnual{COUNT}{1,k}.waveHeight,'omitnan');
        tiltCompareWindAnnual{COUNT}(k) = mean(noiseScenarioAnnual{COUNT}{1,k}.tilt);
        stratCompareWindAnnual{COUNT}(k) = mean(noiseScenarioAnnual{COUNT}{1,k}.stratification)
        
        countAnnual(COUNT,k)             = length(noiseScenarioAnnual{COUNT}{k}.detections)
    end
    normalizedWSpeedAnnual(COUNT,:)  = averageNoiseAnnual(COUNT,:)/(max(averageNoiseAnnual(COUNT,:)));
end


X = 450:50:800;

figure()
hold on
for COUNT = 1:length(noiseBinsAnnual)
    scatter(X,averageNoiseAnnual(COUNT,:),'filled')
    xlabel('HF Noise (mV)')
    ylabel('Hourly Det. Efficiency (%)')
    title('Relating High-Frequency Noise and Detection Efficiency', '10 Different Efficiency Averages')

end
