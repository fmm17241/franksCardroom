%FM 3/12/23 Gotta run "binnedAVG" before this, this now becomes the script
%to plot everything on. binnedAVG has become too crowded, that will now be
%the data load/processing script.

%yearlyPara/PerpAVG: One yearly average for each transceiver in tide bins
%completePara/Perp: Binned averages for each transceiver in each season

%Now to plot visualization

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\exportedFigures'
x = -0.4:0.05:.4;
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]

%%

%Yearly plots
figure()
hold on
for COUNT = 1:length(yearlyParaAVG)
    scatter(x,yearlyParaAVG{COUNT},'filled')
end
ylabel('Normalized Det. Efficiency')
xlabel('Parallel Current Velocity (m/s)')
title('Parallel Currents vs 10 Transmission Directions')
% exportgraphics(gcf,'yearlyPara.png','Resolution',300)

figure()
hold on
for COUNT = 1:length(yearlyPerpAVG)
    scatter(x,yearlyPerpAVG{COUNT},'filled')
end
ylabel('Normalized Det. Efficiency')
xlabel('Perpendicular Current Velocity (m/s)')
title('Perpendicular Currents vs 10 Transmission Directions')
% exportgraphics(gcf,'yearlyPerp.png','Resolution',300)
  
%All on one graph
figure()
set(gcf, 'Position', get(0, 'Screensize'));
tiledlayout(10,5,'TileSpacing','Compact','Padding','Compact')
for COUNT = 1:length(yearlyPerpAVG)

    for season = 1:length(seasons)
        nexttile()
        scatter(x,moddedAveragePara{COUNT}{season},'filled')
        nameit = sprintf('Parallel %d, %d',COUNT,season);
        title(nameit)
    end
    exportgraphics(gcf,sprintf('Transceiver%dParaSeasonal2.png',COUNT),'Resolution',300)
end

figure()
set(gcf, 'Position', get(0, 'Screensize'));
tiledlayout(10,5,'TileSpacing','Compact','Padding','Compact')
for COUNT = 1:length(yearlyPerpAVG)

    for season = 1:length(seasons)
        nexttile()
        scatter(x,moddedAveragePerp{COUNT}{season},'filled')
        nameit = sprintf('Perpendicular %d, %d',COUNT,season);
        title(nameit)
    end
    exportgraphics(gcf,sprintf('Transceiver%dPerpSeasonal2.png',COUNT),'Resolution',300)
end


% All seasons for each pairing
figure()
set(gcf, 'Position', get(0, 'Screensize'));
tiledlayout(5,2,'TileSpacing','Compact','Padding','Compact')
for COUNT = 1:length(yearlyPerpAVG)
    nexttile()
    hold on

    for season = 1:length(seasons)
        scatter(x,moddedAveragePara{COUNT}{season},'filled')
    end
    nameit = sprintf('Parallel %d',COUNT);
    title(nameit)
    hold off
%     exportgraphics(gcf,sprintf('Transceiver%dParaSeasonal2.png',COUNT),'Resolution',300)
end

figure()
set(gcf, 'Position', get(0, 'Screensize'));
tiledlayout(5,2,'TileSpacing','Compact','Padding','Compact')
for COUNT = 1:length(yearlyPerpAVG)
    nexttile()
    hold on

    for season = 1:length(seasons)
        scatter(x,moddedAveragePerp{COUNT}{season},'filled')
    end
    nameit = sprintf('Perpendicular %d',COUNT);
    title(nameit)
    hold off
%     exportgraphics(gcf,sprintf('Transceiver%dPerpSeasonal2.png',COUNT),'Resolution',300)
end




%Seasonal Plots
for COUNT = 1:length(moddedAveragePara)
    figure()
    hold on
    for season = 1:length(seasons)
        scatter(x,moddedAveragePara{COUNT}{season},'filled')
    end
    nameit = sprintf('Parallel %d',COUNT);
    title(nameit)
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
    legend('Winter','Spring','Summer','Fall','Mariners Fall')
    exportgraphics(gcf,sprintf('Transceiver%dParaSeasonal.png',COUNT),'Resolution',300)
end
for COUNT = 1:length(moddedAveragePerp)
    figure()
    hold on
    for season = 1:length(seasons)
        scatter(x,moddedAveragePerp{COUNT}{season},'filled')
    end
    nameit = sprintf('Perpendicular %d',COUNT);
    title(nameit)
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
    legend('Winter','Spring','Summer','Fall','Mariners Fall')
    exportgraphics(gcf,sprintf('Transceiver%dPerpSeasonal.png',COUNT),'Resolution',300)
end


%%

%All seasons together
for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(moddedAveragePara)
        scatter(x,moddedAveragePara{COUNT}{season},'filled')
    end
    nameit = sprintf('Parallel %s',seasonName{season});
    title(nameit)
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
%     legend('Winter','Spring','Summer','Fall','Mariners Fall')
%     exportgraphics(gcf,sprintf('Transceiver%dParaSeasonal.png',COUNT),'Resolution',300)
end
for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(moddedAveragePerp)
        scatter(x,moddedAveragePerp{COUNT}{season},'filled')
    end
    nameit = sprintf('Perpendicular %s',seasonName{season});
    title(nameit)
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
%     exportgraphics(gcf,sprintf('Transceiver%dPerpSeasonal.png',COUNT),'Resolution',300)
end


%%
%One plot = all seasons for 1 transceiver, parallel + perp
for COUNT = 1:length(moddedAveragePara)
    f = figure;
    f.Position = [100 100 450 800];
    tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
    for season = 1:length(seasons)
        nexttile()
        scatter(x,moddedAveragePara{COUNT}{season},'r','filled')
        nameit = sprintf('Parallel %d, %s',COUNT,seasonName{season});
        title(nameit)
    end
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
    exportgraphics(gcf,sprintf('Trans%dParallel.png',COUNT),'Resolution',300)
end

for COUNT = 1:length(moddedAveragePerp)
    f = figure;
    f.Position = [100 100 450 800];
    tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
    for season = 1:length(seasons)
        nexttile()
        scatter(x,moddedAveragePerp{COUNT}{season},'b','filled')
        nameit = sprintf('Perpendicular %d, %s',COUNT,seasonName{season});
        title(nameit)
    end
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
    exportgraphics(gcf,sprintf('Trans%dPerpendicular.png',COUNT),'Resolution',300)
end
%%

%One plot = all seasons for 1 transceiver, BOTH perp and para
for COUNT = 1:length(moddedAveragePara)
    f = figure;
    f.Position = [100 100 450 800];
    tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
    for season = 1:length(seasons)
        nexttile()
        scatter(x,moddedAveragePara{COUNT}{season},'r','filled')
        hold on
        scatter(x,moddedAveragePerp{COUNT}{season},'k','filled')
        nameit = sprintf('Transceivers %d, %s',COUNT,seasonName{season});
        title(nameit)
        hold off
    end
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
    exportgraphics(gcf,sprintf('Trans%dBOTH.png',COUNT),'Resolution',300)
end

for COUNT = 1:length(moddedAveragePerp)
    f = figure;
    f.Position = [100 100 450 800];
    tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
    for season = 1:length(seasons)
        nexttile()
        scatter(x,moddedAveragePerp{COUNT}{season},'b','filled')
        nameit = sprintf('Perpendicular %d, %s',COUNT,seasonName{season});
        title(nameit)
    end
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
    exportgraphics(gcf,sprintf('Trans%dPerpendicular.png',COUNT),'Resolution',300)
end

%%
%Single Transceiver/season Plots
for COUNT = 1:length(moddedAveragePara)
    
    for season = 1:length(seasons)
        figure()
        hold on
        scatter(x,moddedAveragePara{COUNT}{season},'filled')
        nameit = sprintf('Parallel %d and %d',COUNT,season);
        title(nameit)
        ylabel('Normalized Det. Efficiency')
        xlabel('Current Velocity (m/s)')
        exportgraphics(gcf,sprintf('Transceiver %d Parallel Season %d.png',COUNT,season),'Resolution',300)


        figure()
        hold on
        scatter(x,moddedAveragePerp{COUNT}{season},'filled')
        nameit = sprintf('Perpendicular %d and %d',COUNT,season);
        title(nameit)
        ylabel('Normalized Det. Efficiency')
        xlabel('Current Velocity (m/s)')
        exportgraphics(gcf,sprintf('Transceiver %d Perpendicular Season %d.png',COUNT,season),'Resolution',300)
    end
end


%%

% for season = 1:length(seasons)
%     windBins{season}(1,:) = fullData.windSpeed < 1 & fullData.season == season;
%     windBins{season}(2,:) = fullData.windSpeed > 1 & fullData.windSpeed < 2 & fullData.season ==season;
%     windBins{season}(3,:) = fullData.windSpeed > 2 & fullData.windSpeed < 3 & fullData.season ==season;
%     windBins{season}(4,:) = fullData.windSpeed > 3 & fullData.windSpeed < 4 & fullData.season ==season;
%     windBins{season}(5,:) = fullData.windSpeed > 4 & fullData.windSpeed < 5 & fullData.season ==season;
%     windBins{season}(6,:) = fullData.windSpeed > 5 & fullData.windSpeed < 6 & fullData.season ==season;
%     windBins{season}(7,:) = fullData.windSpeed > 6 & fullData.windSpeed < 7 & fullData.season ==season;
%     windBins{season}(8,:) = fullData.windSpeed > 7 & fullData.windSpeed < 8 & fullData.season ==season;
%     windBins{season}(9,:) = fullData.windSpeed > 8 & fullData.windSpeed < 9 & fullData.season ==season;
%     windBins{season}(10,:) = fullData.windSpeed > 9 & fullData.windSpeed < 10 & fullData.season ==season;
%     windBins{season}(11,:) = fullData.windSpeed > 10 & fullData.windSpeed < 11 & fullData.season ==season;
%     windBins{season}(12,:) = fullData.windSpeed > 11 & fullData.windSpeed < 12 & fullData.season ==season;
%     windBins{season}(13,:) = fullData.windSpeed > 12 & fullData.windSpeed < 13 & fullData.season ==season;
%     windBins{season}(14,:) = fullData.windSpeed > 13 & fullData.windSpeed < 14 & fullData.season ==season;
%     windBins{season}(15,:) = fullData.windSpeed > 14 & fullData.season ==season;
% end
% 
% %%
% 
% % average = zeros(1,height(windBins))
% for seasonBin = 1:length(seasons)
%     for k = 1:height(windBins{1})
%         windScenario{seasonBin}{k}= fullData(windBins{seasonBin}(k,:),:);
%         averageWindX{seasonBin}(1,k) = mean(windScenario{seasonBin}{1,k}.detsCross);
%         noiseCompareWX{seasonBin}(k) = mean(windScenario{seasonBin}{1,k}.noise);
%         wavesCompareWX{seasonBin}(k) = mean(windScenario{seasonBin}{1,k}.waveHeight)
% %         averageCrossTest{seasonBin}(k) = averagePercentCross{seasonBin}(k)^2
%     end
%     normalizedWindX{seasonBin}  = averageWindX{seasonBin}/(max(averageWindX{seasonBin}));
% end
% 
% 
% for seasonBin = 1:length(seasons)
%     for k = 1:height(windBins{1})
%         averageWindA{seasonBin}(1,k) = mean(windScenario{seasonBin}{1,k}.detsAlong);
%         noiseCompareWA{seasonBin}(k) = mean(windScenario{seasonBin}{1,k}.noise);
%         wavesCompareWA{seasonBin}(k) = mean(windScenario{seasonBin}{1,k}.waveHeight)
% %         averageAlongTest{seasonBin}(k) = averagePercentAlong{seasonBin}(k)^2
%     end
%     normalizedWindA{seasonBin}  = averageWindA{seasonBin}/(max(averageWindA{seasonBin}));
% end
% 
% for COUNT = 1:length(normalizedWindA)
% % for COUNT = 4:5
%     completeAlong(COUNT,:) = normalizedWindA{COUNT};
%     completeCross(COUNT,:) = normalizedWindX{COUNT};
%     completeWHeightX(COUNT,:) = wavesCompareWX{COUNT};
%     completeWHeightA(COUNT,:) = wavesCompareWA{COUNT};
% end
% for COUNT = 1:length(completeAlong)
%     completeAlongAvg = nanmean(completeAlong,1)
%     completeCrossAvg = nanmean(completeCross,1)
%     completeWHeightAvgX = nanmean(completeWHeightX,1)
%     completeWHeightAvgA = nanmean(completeWHeightA,1)
% end
% 
% 
% %Count up hours spent in bins
% startCount = zeros(5,15);
% for season = 1:length(seasons)
%     for COUNT = 1:height(windBins{1})
%         startCount(season,COUNT) = height(windScenario{season}{COUNT})
%     end
% end
% 
% countEm = sum(startCount,1);
% 
% 
% 
% x = 0.5:14.5;
% figure()
% 
% scatter(x,completeAlongAvg,'r','filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
% hold on
% scatter(x,completeCrossAvg,'b','filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
% xlabel('Windspeed (m/s)');
% ylabel('Normalized Detections');
% legend({'Along-Pairs','Cross-Pairs'});
% title('2020 Cross and Alongshore Pairs');
% 
% 
% 
% x = 0.5:14.5;
% figure()
% scatter(x,normalizedWindX{1},'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
% hold on
% for COUNT = 2:length(seasons)
%     scatter(x,normalizedWindX{COUNT},'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
% end
% legend('Winter','Spring','Summer','Fall','Mariners Fall')
% title('Normalized Detections, 2020 Cross-shore Transceiver Pairings')
% ylabel('Normalized Detections')
% xlabel('Windspeed, m/s')
% 
% x = 0.5:14.5;
% figure()
% scatter(x,normalizedWindA{1},'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
% hold on
% for COUNT = 2:length(seasons)
%     scatter(x,normalizedWindA{COUNT},'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
% end
% legend('Winter','Spring','Summer','Fall','Mariners Fall')
% title('Normalized Detections, 2020 Along-shore Transceiver Pairings')
% ylabel('Normalized Detections')
% xlabel('Windspeed, m/s')
% 
% x = 0.5:14.5;
% figure()
% scatter(x,completeAlongAvg,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
% hold on
% scatter(x,completeCrossAvg,'filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
% legend('Along-Shore Pairs','Cross-Shore Pairs')
% title('Normalized Detections, 2020 Transceiver Pairings')
% ylabel('Normalized Detections')
% xlabel('Windspeed, m/s')
% 
% %%
% % seasons = unique(fullData.season)
% % 
% % for season = 1:length(seasons)
% %     waveBins{season}(1,:) = fullData.waveHeight < .02 & fullData.season == season;
% %     waveBins{season}(2,:) = fullData.waveHeight > .02 & fullData.waveHeight < .04 & fullData.season ==season;
% %     waveBins{season}(3,:) = fullData.waveHeight > .04 & fullData.waveHeight < .06 & fullData.season ==season;
% %     waveBins{season}(4,:) = fullData.waveHeight > .06 & fullData.waveHeight < .08 & fullData.season ==season;
% %     waveBins{season}(5,:) = fullData.waveHeight > .08 & fullData.waveHeight < 1 & fullData.season ==season;
% %     waveBins{season}(6,:) = fullData.waveHeight > 1.0 & fullData.waveHeight < 1.2 & fullData.season ==season;
% %     waveBins{season}(7,:) = fullData.waveHeight > 1.2 & fullData.waveHeight < 1.4 & fullData.season ==season;
% %     waveBins{season}(8,:) = fullData.waveHeight > 1.4 & fullData.waveHeight < 1.6 & fullData.season ==season;
% %     waveBins{season}(9,:) = fullData.waveHeight > 1.6 & fullData.waveHeight < 1.8 & fullData.season ==season;
% %     waveBins{season}(10,:) = fullData.waveHeight > 1.8 & fullData.waveHeight < 2.0 & fullData.season ==season;
% %     waveBins{season}(11,:) = fullData.waveHeight > 2.0 & fullData.waveHeight < 2.2 & fullData.season ==season;
% %     waveBins{season}(12,:) = fullData.waveHeight > 2.2 & fullData.waveHeight < 2.4 & fullData.season ==season;
% %     waveBins{season}(13,:) = fullData.waveHeight > 2.4 & fullData.season ==season;
% % end
% % 
% % for season = 1:length(seasons)
% %     for k = 1:height(waveBins{season})
% %         waveScenario{season}{k}= fullData(waveBins{season}(k,:),:);
% %         averageX{season}(1,k) = mean(waveScenario{season}{1,k}.allDets);
% %         averagePercentW{season}(1,k) = (averageWave{season}(1,k)/6)*100;
% %         if isnan(averagePercentW{season}(1,k))
% %             averagePercentW{season}(1,k) = 0;
% %             continue
% %         end
% %     end
% %     moddedPercentW{season}  = averagePercentW{season}/(max(averagePercentW{season}));
% % end
% % 
% % 
% % 
% % 
% % 
% % 
% % 
% 