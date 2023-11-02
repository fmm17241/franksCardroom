%%
%FM just isolating stratification, gonna compare to winds and seasons

%FRANK using just the transceivers. Stations, not paths for this data
fullData = {fullData{1},fullData{2},fullData{3},fullData{6}}
%FS6, SURT05, STSNew2, 39IN


for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        stratBins{COUNT}{season}(1,:) = fullData{COUNT}.stratification ==0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(2,:) = fullData{COUNT}.stratification > 0 & fullData{COUNT}.stratification < 0.5 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(3,:) = fullData{COUNT}.stratification > 0.5 & fullData{COUNT}.stratification < 1.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(4,:) = fullData{COUNT}.stratification > 1.0 & fullData{COUNT}.stratification < 1.5 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(5,:) = fullData{COUNT}.stratification > 1.5 & fullData{COUNT}.stratification < 2.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(6,:) = fullData{COUNT}.stratification > 2.0 & fullData{COUNT}.stratification < 2.5 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(7,:) = fullData{COUNT}.stratification > 2.5 & fullData{COUNT}.stratification < 3.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(8,:) = fullData{COUNT}.stratification > 3.0 & fullData{COUNT}.stratification < 3.5 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(9,:) = fullData{COUNT}.stratification > 3.5 & fullData{COUNT}.stratification < 4.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(10,:) = fullData{COUNT}.stratification > 4.0 & fullData{COUNT}.stratification < 4.5 & fullData{COUNT}.season ==season;   
        stratBins{COUNT}{season}(11,:) = fullData{COUNT}.stratification > 4.5 & fullData{COUNT}.stratification < 5.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(12,:) = fullData{COUNT}.stratification > 5.0 & fullData{COUNT}.stratification < 5.5 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(13,:) = fullData{COUNT}.stratification > 5.5 & fullData{COUNT}.stratification < 6.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(14,:) = fullData{COUNT}.stratification > 6.0 & fullData{COUNT}.stratification < 6.5 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(15,:) = fullData{COUNT}.stratification > 6.5 & fullData{COUNT}.season ==season;
    end
end


% average = zeros(1,height(windBins))
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(stratBins{COUNT}{season})
            stratScenario{COUNT}{season}{k}= fullData{COUNT}(stratBins{COUNT}{season}(k,:),:);
            averageStratDets{COUNT}{season}(1,k) = mean(stratScenario{COUNT}{season}{1,k}.detections,'omitnan')/6*100;
            noiseCompare{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.noise, 'omitnan');
            wavesCompare{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.waveHeight, 'omitnan');
            tiltCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.tilt, 'omitnan');
            pingsCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.pings, 'omitnan');
            windSpeedCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.windSpeed, 'omitnan');
            windDirCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.windDir, 'omitnan');
            crossTideCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.uShore, 'omitnan');
            paraTideCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.paraTide, 'omitnan');
        end
    end
end

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(stratBins{COUNT}{season})
            if isnan(crossTideCompareStrat{COUNT}{season}(k))
                crossTideCompareStrat{COUNT}{season}(k) = 0;
            end
            if isnan(averageStratDets{COUNT}{season}(k))
                averageStratDets{COUNT}{season}(k) = 0;
            end
            if isnan(pingsCompareStrat{COUNT}{season}(k))
                pingsCompareStrat{COUNT}{season}(k) = 0;
            end
            if isnan(windSpeedCompareStrat{COUNT}{season}(k))
                windSpeedCompareStrat{COUNT}{season}(k) = 0;
            end
            if isnan(paraTideCompareStrat{COUNT}{season}(k)) 
                paraTideCompareStrat{COUNT}{season}(k) = 0;
            end
        end
    end
end

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:length(stratScenario{COUNT}{season})
            usedPings = (stratScenario{COUNT}{season}{k}.TotalDets)*8;
            removeFull{COUNT,season} = stratScenario{COUNT}{season}{k}.pings - usedPings;
            ratio{COUNT,season}{k}      = usedPings./stratScenario{COUNT}{season}{k}.pings;
            averageRatio{COUNT,season}(k) = mean(ratio{COUNT,season}{k})
        end
    end
end



X = 0:0.5:7
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}];
color = ['r','g','k','b','m'];


for k = 1:length(fullData)
    figure
    hold on
    for season = 1:length(seasons)
        plot(X,averageRatio{k,season},color(season),'lineWidth',3)
    end
    title(sprintf('Ratio of Ping Usage, %d',k))
    ylim([0.6 1])
    ylabel('Ping Ratio')
    xlabel('Stratification (C)')
    if k ==2
        legend('Winter','Spring','Summer','Fall','M.Fall')
    end
end


%%
% Detections vs Strat
for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(fullData)
        scatter(X,averageStratDets{COUNT}{season},color(COUNT),'filled')
    end
    xlabel('Bulk Strat. (C)')
    ylim([0 80])
    xlim ([0 7.4])
    ylabel('Detection Efficiency (%)')
    title(sprintf('Quantifying Effect of Strat., %s',seasonName{season}))
end

%%
% Strat vs 
for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(fullData)
        scatter(X, crossTideCompareStrat{COUNT}{season}, color(COUNT),'filled')
    end
    xlabel(' Bulk Stratification (C)')
%     ylim([0 80])
%     xlim ([0 7.4])
    ylabel('Parallel Tide Magntiude (m/s)')
    title(sprintf('Tides vs Stratification, %s',seasonName{season}))
end


for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(fullData)
        scatter(X, windDirCompareStrat{COUNT}{season}, color(COUNT),'filled')
    end
    xlabel(' Bulk Stratification (C)')
%     ylim([0 80])
%     xlim ([0 7.4])
    ylabel('Wind Direction (CW from N)')
    title(sprintf('Tides vs Stratification, %s',seasonName{season}))
end

