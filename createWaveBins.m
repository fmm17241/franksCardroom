%FM 4/24/23

% Create bins for waveheight, gotta compare to wind effects

for COUNT = 1:length(fullData)
    waveBinsAnnual{COUNT}(1,:)  = fullData{COUNT}.waveHeight < 0.4 ;
    waveBinsAnnual{COUNT}(2,:)  = fullData{COUNT}.waveHeight > 0.4 & fullData{COUNT}.waveHeight < 0.6 ;
    waveBinsAnnual{COUNT}(3,:)  = fullData{COUNT}.waveHeight > 0.6 & fullData{COUNT}.waveHeight < 0.8 ;
    waveBinsAnnual{COUNT}(4,:)  = fullData{COUNT}.waveHeight > 0.8 & fullData{COUNT}.waveHeight < 1.0 ;
    waveBinsAnnual{COUNT}(5,:)  = fullData{COUNT}.waveHeight > 1.0 & fullData{COUNT}.waveHeight < 1.2 ;
    waveBinsAnnual{COUNT}(6,:)  = fullData{COUNT}.waveHeight > 1.2 & fullData{COUNT}.waveHeight < 1.4 ;
    waveBinsAnnual{COUNT}(7,:)  = fullData{COUNT}.waveHeight > 1.4 & fullData{COUNT}.waveHeight < 1.6 ;
    waveBinsAnnual{COUNT}(8,:)  = fullData{COUNT}.waveHeight > 1.6 & fullData{COUNT}.waveHeight < 1.8 ;
    waveBinsAnnual{COUNT}(9,:)  = fullData{COUNT}.waveHeight > 1.8 & fullData{COUNT}.waveHeight < 2.0 ;
    waveBinsAnnual{COUNT}(10,:) = fullData{COUNT}.waveHeight > 2.0 & fullData{COUNT}.waveHeight < 2.2 ;
    waveBinsAnnual{COUNT}(11,:)  = fullData{COUNT}.waveHeight > 2.2 & fullData{COUNT}.waveHeight < 2.4 ;
    waveBinsAnnual{COUNT}(12,:)  = fullData{COUNT}.waveHeight > 2.4 & fullData{COUNT}.waveHeight < 2.6 ;
    waveBinsAnnual{COUNT}(13,:)  = fullData{COUNT}.waveHeight > 2.6;
end



for COUNT = 1:length(fullData)
    for k = 1:height(waveBinsAnnual{COUNT})
        waveScenarioAnnual{COUNT}{k}= fullData{COUNT}(waveBinsAnnual{COUNT}(k,:),:);
        averageWaveAnnual(COUNT,k) = mean(waveScenarioAnnual{COUNT}{1,k}.detections);
        noiseCompareAnnual{COUNT}(k) = mean(waveScenarioAnnual{COUNT}{1,k}.noise);
        wavesCompareAnnual{COUNT}(k) = mean(waveScenarioAnnual{COUNT}{1,k}.waveHeight,'omitnan');
        tiltCompareWaveAnnual{COUNT}(k) = mean(waveScenarioAnnual{COUNT}{1,k}.tilt);
        stratCompareWaveAnnual{COUNT}(k) = mean(waveScenarioAnnual{COUNT}{1,k}.stratification)
        countAnnual(COUNT,k)             = length(waveScenarioAnnual{COUNT}{k}.detections)
    end
    normalizedWaveAnnual(COUNT)  = averageWaveAnnual(COUNT,k)/(max(averageWaveAnnual(COUNT)));
end


x = 0.2:0.2:2.6;
color = ['r','r','g','g','k','k','b','b','m','m'];

figure()
hold on
for COUNT = 1:length(waveBinsAnnual)
    plot(x,averageWaveAnnual(COUNT,:),color(COUNT))

end
    