%%FM Stratificatiom

%Making bins from stratification levels. Want to figure out how
%winds/currents affect it more or less when stratified/mixed.

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\exportedFigures'

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        stratBins{COUNT}{season}(1,:) = fullData{COUNT}.stratification < 0.2 & fullData{COUNT}.season == season;
        stratBins{COUNT}{season}(2,:) = fullData{COUNT}.stratification > 0.2 & fullData{COUNT}.stratification < 0.4 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(3,:) = fullData{COUNT}.stratification > 0.4 & fullData{COUNT}.stratification < 0.6 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(4,:) = fullData{COUNT}.stratification > 0.6 & fullData{COUNT}.stratification < 0.8 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(5,:) = fullData{COUNT}.stratification > 0.8 & fullData{COUNT}.stratification < 1.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(6,:) = fullData{COUNT}.stratification > 1.0 & fullData{COUNT}.stratification < 1.2 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(7,:) = fullData{COUNT}.stratification > 1.2 & fullData{COUNT}.stratification < 1.4 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(8,:) = fullData{COUNT}.stratification > 1.4 & fullData{COUNT}.stratification < 1.6 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(9,:) = fullData{COUNT}.stratification > 1.6 & fullData{COUNT}.stratification < 1.8 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(10,:) = fullData{COUNT}.stratification > 1.8 & fullData{COUNT}.stratification < 2.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(11,:) = fullData{COUNT}.stratification > 2.0 & fullData{COUNT}.stratification < 2.2 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(12,:) = fullData{COUNT}.stratification > 2.2 & fullData{COUNT}.stratification < 2.4 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(13,:) = fullData{COUNT}.stratification > 2.4 & fullData{COUNT}.stratification < 2.6 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(14,:) = fullData{COUNT}.stratification > 2.6 & fullData{COUNT}.stratification < 2.8 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(15,:) = fullData{COUNT}.stratification > 2.8 & fullData{COUNT}.stratification < 3.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(16,:) = fullData{COUNT}.stratification > 3.0 & fullData{COUNT}.stratification < 3.2 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(17,:) = fullData{COUNT}.stratification > 3.2 & fullData{COUNT}.stratification < 3.4 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(18,:) = fullData{COUNT}.stratification > 3.4 & fullData{COUNT}.stratification < 3.6 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(19,:) = fullData{COUNT}.stratification > 3.6 & fullData{COUNT}.stratification < 3.8 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(20,:) = fullData{COUNT}.stratification > 3.8 & fullData{COUNT}.stratification < 4.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(21,:) = fullData{COUNT}.stratification > 4.0 & fullData{COUNT}.stratification < 4.2 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(22,:) = fullData{COUNT}.stratification > 4.2 & fullData{COUNT}.stratification < 4.4 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(23,:) = fullData{COUNT}.stratification > 4.4 & fullData{COUNT}.season ==season;
    end
end

%%

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(stratBins{COUNT}{season})
            stratScenario{COUNT}{season}{k}= fullData{COUNT}(stratBins{COUNT}{season}(k,:),:);
            averageStrat{COUNT}{season}(1,k) = mean(stratScenario{COUNT}{season}{1,k}.detections);
            tiltCompareStrat{COUNT}{season}(k) = mean(stratScenario{COUNT}{season}{1,k}.tilt);
        end
    end
end

for COUNT = 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter = [averageStrat{COUNT}{season},averageStrat{COUNT+1}{season}];
        normalizedStrat{COUNT}{season}  = averageStrat{COUNT}{season}/(max(comboPlatter));
        normalizedStrat{COUNT+1}{season}  = averageStrat{COUNT+1}{season}/(max(comboPlatter));
    end
end




for COUNT = 1:length(normalizedStrat)
    for season = 1:length(seasons)
        completeStratNormalCell{COUNT}(season,:) = normalizedStrat{COUNT}{season};
        completeStratCell{COUNT}(season,:) = averageStrat{COUNT}{season};
        completeTiltVsStrat{COUNT}(season,:)   = tiltCompareStrat{COUNT}{season};
    end
end


for COUNT = 1:length(completeStratNormalCell)
    completeStratNormal(COUNT,:) = nanmean(completeStratNormalCell{COUNT});
    completeStrat(COUNT,:) = nanmean(completeStratCell{COUNT});
    completeTiltVsStratAVG(COUNT,:) = nanmean(completeTiltVsStrat{COUNT})
end

for COUNT = 1:length(completeStratNormal)
    yearlyStrat(1,COUNT) = mean(completeStratNormal(:,COUNT));
    yearlyStratAVG(1,COUNT) = mean(completeStrat(:,COUNT));
    yearlyTiltVsStrat(1,COUNT) = mean(completeTiltVsStratAVG(:,COUNT));
end

%%
%Plot findings
x = 0:0.2:4.4;
seasonNames = {'Winter','Spring','Summer','Fall','Mariner''s Fall'}


for COUNT = 1:length(normalizedStrat)
    figure()
    hold on
    for season = 1:length(normalizedStrat{1})
        plot(x,completeStratCell{COUNT}(season,:))
    end
    hold off
    xlabel('Bulk Stratification')
    ylabel('Det Efficiency')
    title(sprintf('All Seasons, %d',COUNT))
    legend(seasonNames)
end



for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(completeStratCell)
        plot(x,completeStratCell{COUNT}(season,:))
    end
    hold off
    xlabel('Bulk Stratification')
    ylabel('Det Efficiency')
    title(sprintf('10 Transmissions, %s',COUNT{season}))
end



