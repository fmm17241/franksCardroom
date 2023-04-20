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
        weakWindBin{COUNT}{season}(1,:) =  fullData{COUNT}.uShore < -.4  & fullData{COUNT}.windSpeed     < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(2,:) =  fullData{COUNT}.uShore > -.4  & fullData{COUNT}.uShore < -.35 & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(3,:) =  fullData{COUNT}.uShore > -.35 & fullData{COUNT}.uShore < -.30 & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(4,:) =  fullData{COUNT}.uShore > -.30 & fullData{COUNT}.uShore < -.25 & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(5,:) =  fullData{COUNT}.uShore > -.25 & fullData{COUNT}.uShore < -.20  & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(6,:) =  fullData{COUNT}.uShore > -.20  & fullData{COUNT}.uShore < -.15  & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(7,:) =  fullData{COUNT}.uShore > -.15  & fullData{COUNT}.uShore < -.10  & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(8,:) =  fullData{COUNT}.uShore > -.10  & fullData{COUNT}.uShore < -.05  & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(9,:) =  fullData{COUNT}.uShore > -.05 & fullData{COUNT}.uShore < .05 & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(10,:) =  fullData{COUNT}.uShore > .05 & fullData{COUNT}.uShore < .10 & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(11,:) =  fullData{COUNT}.uShore > .10 & fullData{COUNT}.uShore < .15  & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(12,:) =  fullData{COUNT}.uShore > .15  & fullData{COUNT}.uShore < .20  & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(13,:) =  fullData{COUNT}.uShore > .20  & fullData{COUNT}.uShore < .25  & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(14,:) =  fullData{COUNT}.uShore > .25  & fullData{COUNT}.uShore < .30  & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(15,:) =  fullData{COUNT}.uShore > .30  & fullData{COUNT}.uShore < .35  & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(16,:) =  fullData{COUNT}.uShore > .35  & fullData{COUNT}.uShore < .40  & fullData{COUNT}.windSpeed  < 5 & fullData{COUNT}.season ==season;
        weakWindBin{COUNT}{season}(17,:) =  fullData{COUNT}.uShore > .40  & fullData{COUNT}.windSpeed     < 5 & fullData{COUNT}.season ==season;
    end
end


strongWindBin = cell(1,length(fullData));
for COUNT= 1:length(fullData)
    for season = 1:length(seasons)
        %Tides cross-shore and strong winds
        strongWindBin{COUNT}{season}(1,:) =  fullData{COUNT}.uShore < -.4  & fullData{COUNT}.windSpeed > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(2,:) =  fullData{COUNT}.uShore > -.4  & fullData{COUNT}.uShore < -.35 & fullData{COUNT}.windSpeed > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(3,:) =  fullData{COUNT}.uShore > -.35 & fullData{COUNT}.uShore < -.30 & fullData{COUNT}.windSpeed  > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(4,:) =  fullData{COUNT}.uShore > -.30 & fullData{COUNT}.uShore < -.25 & fullData{COUNT}.windSpeed > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(5,:) =  fullData{COUNT}.uShore > -.25 & fullData{COUNT}.uShore < -.20  & fullData{COUNT}.windSpeed > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(6,:) =  fullData{COUNT}.uShore > -.20  & fullData{COUNT}.uShore < -.15  & fullData{COUNT}.windSpeed > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(7,:) =  fullData{COUNT}.uShore > -.15  & fullData{COUNT}.uShore < -.10  & fullData{COUNT}.windSpeed > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(8,:) =  fullData{COUNT}.uShore > -.10  & fullData{COUNT}.uShore < -.05  & fullData{COUNT}.windSpeed  > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(9,:) =  fullData{COUNT}.uShore > -.05 & fullData{COUNT}.uShore < .05 & fullData{COUNT}.windSpeed  > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(10,:) =  fullData{COUNT}.uShore > .05 & fullData{COUNT}.uShore < .10 & fullData{COUNT}.windSpeed  > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(11,:) =  fullData{COUNT}.uShore > .10 & fullData{COUNT}.uShore < .15  & fullData{COUNT}.windSpeed  > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(12,:) =  fullData{COUNT}.uShore > .15  & fullData{COUNT}.uShore < .20  & fullData{COUNT}.windSpeed  > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(13,:) =  fullData{COUNT}.uShore > .20  & fullData{COUNT}.uShore < .25  & fullData{COUNT}.windSpeed  > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(14,:) =  fullData{COUNT}.uShore > .25  & fullData{COUNT}.uShore < .30  & fullData{COUNT}.windSpeed  > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(15,:) =  fullData{COUNT}.uShore > .30  & fullData{COUNT}.uShore < .35  & fullData{COUNT}.windSpeed  > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(16,:) =  fullData{COUNT}.uShore > .35  & fullData{COUNT}.uShore < .40  & fullData{COUNT}.windSpeed  > 10  & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}{season}(17,:) =  fullData{COUNT}.uShore > .40  & fullData{COUNT}.windSpeed     > 10  & fullData{COUNT}.season ==season;
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
            weakWindScenario{COUNT}{season,k}    = fullData{1,COUNT}(weakWindBin{1,COUNT}{season}(k,:),:);
            strongWindScenario{COUNT}{season,k}  = fullData{1,COUNT}(strongWindBin{1,COUNT}{season}(k,:),:);
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
scatter(X,)


% Normalizing the data for each transceiver pairing. Instead of each set of
% detections having its own maximum, this uses the relationship between the
% two together. Two transmissions traveling the same distance in the same
% water column, opposite directions. This isolates that direction/transceiver.
for COUNT = 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter1 = [averagedStrong{COUNT}(season,:),averagedStrong{COUNT+1}(season,:)]
        comboPlatter2 = [averagedWeak{COUNT}(season,:),averagedWeak{COUNT+1}(season,:)]
        normalizedStrong{COUNT}(season,:)       = averagedStrong{COUNT}(season,:)/(max(comboPlatter1));
        normalizedStrong{COUNT+1}(season,:)     = averagedStrong{COUNT+1}(season,:)/(max(comboPlatter1));
        normalizedWeak{COUNT}(season,:)         = averagedWeak{COUNT}(season,:)/(max(comboPlatter2));
        normalizedWeak{COUNT+1}(season,:)       = averagedWeak{COUNT+1}(season,:)/(max(comboPlatter2));
    end
end

for COUNT = 1:length(normalizedStrong)
    completeNormalStrong(COUNT,:) = nanmean(normalizedStrong{COUNT},1);
    completeNormalWeak(COUNT,:)   = nanmean(normalizedWeak{COUNT},1);
    completeAVGstrong(COUNT, :) =   nanmean(averagedStrong{COUNT},1);
    completeAVGweak(COUNT, :)   =   nanmean(averagedWeak{COUNT},1);
end

%Whole year
yearlyNormalStrong = mean(completeNormalStrong,1);
yearlyNormalWeak = mean(completeNormalWeak,1);

yearlyAVGstrong = mean(completeAVGstrong,1);
yearlyAVGweak = mean(completeAVGweak,1);



x = -.4:.05:.4;


figure()
scatter(x,yearlyNormalStrong,'r','filled')
hold on
scatter(x,yearlyNormalWeak,'b','filled')
legend('Strong Winds(>12 m/s)','Weak Winds(<3 m/s)')
title('Yearly Normalized Detections w/ Strong/Weak Tides & Winds')
xlabel('Tidal Magnitude')
ylabel('Normalized Detection Efficiency')


figure()
scatter(x,yearlyAVGstrong,'r','filled')
hold on
scatter(x,yearlyAVGweak,'b','filled')
legend('Strong Winds(>12 m/s)','Weak Winds(<3 m/s)')
title('Yearly AVG Detections w/ Strong/Weak Tides & Winds')
xlabel('Tidal Magnitude')
ylabel('Detection Efficiency')


for COUNT = 1:height(completeAVGstrong)
    figure()
    hold on
    scatter(x,completeAVGstrong(COUNT,:),'r','filled')
    scatter(x,completeAVGweak(COUNT,:),'b','filled')
    ylabel('Avg Det Efficiency')
    xlabel('Tidal Velocity (m/s)')
    ylim([0 6])
    title(sprintf('Transceiver Pairing %d, Winds & Tides',COUNT))
    legend('Strong Winds','Weak Winds')
end


%%

%Frank: Wind's effect on noise, night vs day

for COUNT = 1:length(fullData)
    wSpeedNight{COUNT}(1,:) = fullData{COUNT}.windSpeed < 1 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(2,:) = fullData{COUNT}.windSpeed > 1 & fullData{COUNT}.windSpeed < 2 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(3,:) = fullData{COUNT}.windSpeed > 2 & fullData{COUNT}.windSpeed < 3 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(4,:) = fullData{COUNT}.windSpeed > 3 & fullData{COUNT}.windSpeed < 4 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(5,:) = fullData{COUNT}.windSpeed > 4 & fullData{COUNT}.windSpeed < 5 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(6,:) = fullData{COUNT}.windSpeed > 5 & fullData{COUNT}.windSpeed < 6 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(7,:) = fullData{COUNT}.windSpeed > 6 & fullData{COUNT}.windSpeed < 7 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(8,:) = fullData{COUNT}.windSpeed > 7 & fullData{COUNT}.windSpeed < 8 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(9,:) = fullData{COUNT}.windSpeed > 8 & fullData{COUNT}.windSpeed < 9 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(10,:) = fullData{COUNT}.windSpeed > 9 & fullData{COUNT}.windSpeed < 10 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(11,:) = fullData{COUNT}.windSpeed > 10 & fullData{COUNT}.windSpeed < 11 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(12,:) = fullData{COUNT}.windSpeed > 11 & fullData{COUNT}.windSpeed < 12 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(13,:) = fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.windSpeed < 13 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(14,:) = fullData{COUNT}.windSpeed > 13 & fullData{COUNT}.windSpeed < 14 & fullData{COUNT}.sunlight ==0;
    wSpeedNight{COUNT}(15,:) = fullData{COUNT}.windSpeed > 14 & fullData{COUNT}.sunlight ==0;
end

for COUNT = 1:length(fullData)
    wSpeedDay{COUNT}(1,:) = fullData{COUNT}.windSpeed < 1 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(2,:) = fullData{COUNT}.windSpeed > 1 & fullData{COUNT}.windSpeed < 2 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(3,:) = fullData{COUNT}.windSpeed > 2 & fullData{COUNT}.windSpeed < 3 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(4,:) = fullData{COUNT}.windSpeed > 3 & fullData{COUNT}.windSpeed < 4 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(5,:) = fullData{COUNT}.windSpeed > 4 & fullData{COUNT}.windSpeed < 5 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(6,:) = fullData{COUNT}.windSpeed > 5 & fullData{COUNT}.windSpeed < 6 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(7,:) = fullData{COUNT}.windSpeed > 6 & fullData{COUNT}.windSpeed < 7 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(8,:) = fullData{COUNT}.windSpeed > 7 & fullData{COUNT}.windSpeed < 8 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(9,:) = fullData{COUNT}.windSpeed > 8 & fullData{COUNT}.windSpeed < 9 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(10,:) = fullData{COUNT}.windSpeed > 9 & fullData{COUNT}.windSpeed < 10 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(11,:) = fullData{COUNT}.windSpeed > 10 & fullData{COUNT}.windSpeed < 11 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(12,:) = fullData{COUNT}.windSpeed > 11 & fullData{COUNT}.windSpeed < 12 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(13,:) = fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.windSpeed < 13 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(14,:) = fullData{COUNT}.windSpeed > 13 & fullData{COUNT}.windSpeed < 14 & fullData{COUNT}.sunlight ==1;
    wSpeedDay{COUNT}(15,:) = fullData{COUNT}.windSpeed > 14 & fullData{COUNT}.sunlight ==1;
end

%%

for COUNT = 1:length(fullData)
    for k = 1:height(wSpeedNight{COUNT})
        wSpeedScenNight{COUNT}{k}= fullData{COUNT}(wSpeedNight{COUNT}(k,:),:);
        avgWindSpeedNight{COUNT}(1,k) = mean(wSpeedScenNight{COUNT}{1,k}.detections);
        noiseNight{COUNT}(k) = mean(wSpeedScenNight{COUNT}{1,k}.noise);
        wavesNight{COUNT}(k) = mean(wSpeedScenNight{COUNT}{1,k}.waveHeight);
        tiltNight{COUNT}(k) = mean(wSpeedScenNight{COUNT}{1,k}.tilt);
    end
    normalizedWSpeedNight{COUNT}  = avgWindSpeedNight{COUNT}/(max(avgWindSpeedNight{COUNT}));
end

%%
for COUNT = 1:length(fullData)
    for k = 1:height(wSpeedDay{COUNT})
        wSpeedScenDay{COUNT}{k}= fullData{COUNT}(wSpeedDay{COUNT}(k,:),:);
        avgWindSpeedDay{COUNT}(1,k) = mean(wSpeedScenDay{COUNT}{1,k}.detections);
        noiseDay{COUNT}(k) = mean(wSpeedScenDay{COUNT}{1,k}.noise);
        wavesDay{COUNT}(k) = mean(wSpeedScenDay{COUNT}{1,k}.waveHeight);
        tiltDay{COUNT}(k) = mean(wSpeedScenDay{COUNT}{1,k}.tilt);
    end
    normalizedWSpeedDay{COUNT}  = avgWindSpeedDay{COUNT}/(max(avgWindSpeedDay{COUNT}));
end

%%
cd (localPlots)

X = 0:14;

seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];


figure()
hold on
for COUNT = 1:length(normalizedWSpeedNight)
    plot(X,normalizedWSpeedNight{COUNT},'r')
end
title('Night Winds')
xlabel('Wind Magnitude m/s')
ylabel('Normalized Det. Efficiency')


figure()
hold on
for COUNT = 1:length(normalizedWSpeedDay)
    plot(X,normalizedWSpeedDay{COUNT},'b')
end
title('Day Winds')
xlabel('Wind Magnitude m/s')
ylabel('Normalized Det. Efficiency')

%

figure()
hold on
for COUNT = 1:length(avgWindSpeedDay)
    plot(X,avgWindSpeedDay{COUNT},'b')
end
title('Day Winds')
xlabel('Wind Magnitude m/s')
ylabel('Det. Efficiency')

figure()
hold on
for COUNT = 1:length(avgWindSpeedNight)
    plot(X,avgWindSpeedNight{COUNT},'r')
end
title('Night Winds')
xlabel('Wind Magnitude m/s')
ylabel('Det. Efficiency')
 

%%
figure()
hold on
for COUNT = 1:length(avgWindSpeedDay)
    plot(X,noiseDay{COUNT},'b')
end
title('Day Winds')
xlabel('Wind Magnitude m/s')
ylabel('Noise')

figure()
hold on
for COUNT = 1:length(avgWindSpeedNight)
    plot(X,noiseNight{COUNT},'r')
end
title('Night Winds')
xlabel('Wind Magnitude m/s')
ylabel('Noise')

%%
%Adding season
for COUNT = 1:length(fullData)
    for k = 1:length(seasons)
        wSpeedNightSsn{COUNT}{k}(1,:) = fullData{COUNT}.windSpeed < 1 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(2,:) = fullData{COUNT}.windSpeed > 1 & fullData{COUNT}.windSpeed < 2 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(3,:) = fullData{COUNT}.windSpeed > 2 & fullData{COUNT}.windSpeed < 3 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(4,:) = fullData{COUNT}.windSpeed > 3 & fullData{COUNT}.windSpeed < 4 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(5,:) = fullData{COUNT}.windSpeed > 4 & fullData{COUNT}.windSpeed < 5 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(6,:) = fullData{COUNT}.windSpeed > 5 & fullData{COUNT}.windSpeed < 6 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(7,:) = fullData{COUNT}.windSpeed > 6 & fullData{COUNT}.windSpeed < 7 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(8,:) = fullData{COUNT}.windSpeed > 7 & fullData{COUNT}.windSpeed < 8 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(9,:) = fullData{COUNT}.windSpeed > 8 & fullData{COUNT}.windSpeed < 9 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(10,:) = fullData{COUNT}.windSpeed > 9 & fullData{COUNT}.windSpeed < 10 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(11,:) = fullData{COUNT}.windSpeed > 10 & fullData{COUNT}.windSpeed < 11 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(12,:) = fullData{COUNT}.windSpeed > 11 & fullData{COUNT}.windSpeed < 12 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(13,:) = fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.windSpeed < 13 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(14,:) = fullData{COUNT}.windSpeed > 13 & fullData{COUNT}.windSpeed < 14 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
        wSpeedNightSsn{COUNT}{k}(15,:) = fullData{COUNT}.windSpeed > 14 & fullData{COUNT}.sunlight ==0 & fullData{COUNT}.season == k;
    end

end

for COUNT = 1:length(fullData)
    for k =1:length(seasons)
        wSpeedDaySsn{COUNT}{k}(1,:) = fullData{COUNT}.windSpeed < 1 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(2,:) = fullData{COUNT}.windSpeed > 1 & fullData{COUNT}.windSpeed < 2 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(3,:) = fullData{COUNT}.windSpeed > 2 & fullData{COUNT}.windSpeed < 3 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(4,:) = fullData{COUNT}.windSpeed > 3 & fullData{COUNT}.windSpeed < 4 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(5,:) = fullData{COUNT}.windSpeed > 4 & fullData{COUNT}.windSpeed < 5 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(6,:) = fullData{COUNT}.windSpeed > 5 & fullData{COUNT}.windSpeed < 6 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(7,:) = fullData{COUNT}.windSpeed > 6 & fullData{COUNT}.windSpeed < 7 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(8,:) = fullData{COUNT}.windSpeed > 7 & fullData{COUNT}.windSpeed < 8 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(9,:) = fullData{COUNT}.windSpeed > 8 & fullData{COUNT}.windSpeed < 9 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(10,:) = fullData{COUNT}.windSpeed > 9 & fullData{COUNT}.windSpeed < 10 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(11,:) = fullData{COUNT}.windSpeed > 10 & fullData{COUNT}.windSpeed < 11 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(12,:) = fullData{COUNT}.windSpeed > 11 & fullData{COUNT}.windSpeed < 12 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(13,:) = fullData{COUNT}.windSpeed > 12 & fullData{COUNT}.windSpeed < 13 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(14,:) = fullData{COUNT}.windSpeed > 13 & fullData{COUNT}.windSpeed < 14 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
        wSpeedDaySsn{COUNT}{k}(15,:) = fullData{COUNT}.windSpeed > 14 & fullData{COUNT}.sunlight ==1 & fullData{COUNT}.season == k;
    end
end

%%
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(wSpeedDaySsn{COUNT}{season})
            wSpeedScenDay{COUNT}{season}{k}= fullData{COUNT}(wSpeedDaySsn{COUNT}{season}(k,:),:);
            avgWindSpeedDay{COUNT}{season}(:,k) = mean(wSpeedScenDay{COUNT}{season}{1,k}.detections);
            noiseDay{COUNT}{season}(k) = mean(wSpeedScenDay{COUNT}{season}{1,k}.noise);
            wavesDay{COUNT}{season}(k) = mean(wSpeedScenDay{COUNT}{season}{1,k}.waveHeight);
            tiltDay{COUNT}{season}(k) = mean(wSpeedScenDay{COUNT}{season}{1,k}.tilt);
            %Night
            wSpeedScenNight{COUNT}{season}{k}= fullData{COUNT}(wSpeedNightSsn{COUNT}{season}(k,:),:);
            avgWindSpeedNight{COUNT}{season}(1,k) = mean(wSpeedScenNight{COUNT}{season}{1,k}.detections);
            noiseNight{COUNT}{season}(k) = mean(wSpeedScenNight{COUNT}{season}{1,k}.noise);
            wavesNight{COUNT}{season}(k) = mean(wSpeedScenNight{COUNT}{season}{1,k}.waveHeight);
            tiltNight{COUNT}{season}(k) = mean(wSpeedScenNight{COUNT}{season}{1,k}.tilt);
        end
        normalizedwSpeedDaySsn{COUNT}{season}  = avgWindSpeedDay{COUNT}{season}/(max(avgWindSpeedDay{COUNT}{season}));
        normalizedwSpeedNightSsn{COUNT}{season}  = avgWindSpeedNight{COUNT}{season}/(max(avgWindSpeedNight{COUNT}{season}));
        allDay{COUNT}(season,:) = avgWindSpeedDay{COUNT}{season};
        allNight{COUNT}(season,:) = avgWindSpeedNight{COUNT}{season};
    end
    averageYearlyDay(COUNT,:) = mean(allDay{COUNT},'omitnan');
    averageYearlyNight(COUNT,:) = mean(allNight{COUNT},'omitnan');
end






figure()
plot(X,averageYearlyDay, 'b')
hold on
plot(X,averageYearlyNight,'r')
legend('Day','','','','','','','','','','','Night')
xlabel(['Wind Magnitude m/s'])
ylabel('Dets/hour')
title('Little Difference in Winds Effect','Day vs Night')


cd (localPlots)

X = 0:14;

seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];

%
for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(avgWindSpeedDay)
        plot(X,avgWindSpeedDay{COUNT}{season},'b')
    end
    title(sprintf('Day Winds, %s',seasonName{season}))
    xlabel('Wind Magnitude m/s')
    ylabel('Det. Efficiency')
    ylim([0 6])
end

for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(avgWindSpeedNight)
        plot(X,avgWindSpeedNight{COUNT}{season},'r')
    end
    title(sprintf('Night Winds, %s',seasonName{season}))
    xlabel('Wind Magnitude m/s')
    ylabel('Det. Efficiency')
    ylim([0 6])
end

