%%FM Stratificatiom

%Making bins from stratification levels. Want to figure out how
%winds/currents affect it more or less when stratified/mixed.

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\exportedFigures'

for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        stratBins{COUNT}{season}(1,:) = fullData{COUNT}.stratification < 0.5 & fullData{COUNT}.season == season;
        stratBins{COUNT}{season}(2,:) = fullData{COUNT}.stratification > 0.5 & fullData{COUNT}.stratification < 1.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(3,:) = fullData{COUNT}.stratification > 1.0 & fullData{COUNT}.stratification < 1.5 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(4,:) = fullData{COUNT}.stratification > 1.5 & fullData{COUNT}.stratification < 2.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(5,:) = fullData{COUNT}.stratification > 2.0 & fullData{COUNT}.stratification < 2.5 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(6,:) = fullData{COUNT}.stratification > 2.5 & fullData{COUNT}.stratification < 3.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(7,:) = fullData{COUNT}.stratification > 3.0 & fullData{COUNT}.stratification < 3.5 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(8,:) = fullData{COUNT}.stratification > 3.5 & fullData{COUNT}.stratification < 4.0 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(9,:) = fullData{COUNT}.stratification > 4.0 & fullData{COUNT}.stratification < 4.5 & fullData{COUNT}.season ==season;
        stratBins{COUNT}{season}(10,:) = fullData{COUNT}.stratification > 4.5 & fullData{COUNT}.season ==season;
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
x = 0:0.5:4.5;
seasonNames = {'Winter','Spring','Summer','Fall','Mariner''s Fall'}


for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(completeStratCell)
        plot(x,completeStratCell{COUNT}(season,:))
    end
    hold off
    xlabel('Bulk Stratification')
    ylabel('Det Efficiency')
    title(sprintf('10 Transmissions, %s',seasonNames{season}))
end

