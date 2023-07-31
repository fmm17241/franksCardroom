%FM 3/12/23 Gotta run "binnedAVG" before this, this now becomes the script
%to plot everything on. binnedAVG has become too crowded, that will now be
%the data load/processing script.

%yearlyPara/PerpAVG: One yearly average for each transceiver in tide bins
%completePara/Perp: Binned averages for each transceiver in each season

%Now to plot visualization

cd (localPlots)

% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\exportedFigures'
x = -0.4:0.05:.4;
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];

%%
for COUNT = 1:length(yearlyParaAVG)
    [index1(COUNT,:) position(COUNT,:)] = max(yearlyParaAVG{COUNT})
    maxYearly(COUNT) = x(position(COUNT))
    maxDets(COUNT)   = index1(COUNT);
end

%Yearly plots
figure()
hold on
for COUNT = 1:length(yearlyParaAVG)
    scatter(x,yearlyParaAVG{COUNT},color(COUNT),'filled')
    scatter(maxYearly(COUNT),maxDets(COUNT),500,'sq',color(COUNT),'filled')
end
ylabel('Normalized Det. Efficiency')
xlabel('Parallel Current Velocity (m/s)')
title('Parallel Currents vs 10 Transmission Directions')
% exportgraphics(gcf,'yearlyPara.png','Resolution',300)

% figure()
% hold on
% for COUNT = 1:length(yearlyPerpAVG)
%     scatter(x,yearlyPerpAVG{COUNT},'filled')
% end
% ylabel('Normalized Det. Efficiency')
% xlabel('Perpendicular Current Velocity (m/s)')
% title('Perpendicular Currents vs 10 Transmission Directions')
% exportgraphics(gcf,'yearlyPerp.png','Resolution',300)
  
%All on one graph
% figure()
% set(gcf, 'Position', get(0, 'Screensize'));
% tiledlayout(10,5,'TileSpacing','Compact','Padding','Compact')
% for COUNT = 1:length(yearlyPerpAVG)
%     for season = 1:length(seasons)
%         nexttile()
%         scatter(x,normalizedPara{COUNT}{season},'filled')
%         nameit = sprintf('Parallel %d, %d',COUNT,season);
%         title(nameit)
%     end
% end
%     exportgraphics(gcf,sprintf('Transceiver%dParaSeasonal2.png',COUNT),'Resolution',300)


%Seasonal Plots
for COUNT = 1:length(normalizedPara)
    figure()
    hold on
    for season = 1:length(seasons)
        scatter(x,normalizedPara{COUNT}{season},'filled')
    end
    nameit = sprintf('Parallel %d',COUNT);
    title(nameit)
    ylim([0 1])
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
    legend('Winter','Spring','Summer','Fall','Mariners Fall')
%     exportgraphics(gcf,sprintf('Transceiver%dParaSeasonal.png',COUNT),'Resolution',300)
end

%Seasonal Plots, average
for COUNT = 1:length(averageParaTide)
    figure()
    hold on
    for season = 1:length(seasons)
        scatter(x,averageParaTide{COUNT}{season},'filled')
    end
    nameit = sprintf('Parallel %d',COUNT);
    title(nameit)
    ylim([0 4])
    yline(3,'label','50% Efficiency')
    ylabel('Det. Efficiency')
    xlabel('Current Velocity (m/s)')
    legend('Winter','Spring','Summer','Fall','Mariners Fall')
%     exportgraphics(gcf,sprintf('Transceiver%dParaSeasonal.png',COUNT),'Resolution',300)
end




NamesDude = [{'1','2','3','4','5','6','Pairing 1.1','Pairing 1.2','Pairing 2.1','Pairing 2.2'}]
labe = [{'1','2','3','4','5','6','A','B','C','D'}];

figure()
hold on
for COUNT = 7:10
    nexttile()
    hold on
    for season = 1:length(seasons)
        scatter(x,averageParaTide{COUNT}{season},'filled')
    end
    yline(3,'label','50%')
    nameit = sprintf('Transceiver %s',NamesDude{COUNT});
    title(nameit)
    ylim([0 6])
    str = sprintf('%s',labe{COUNT})
    text(0.4,5.5,str,'HorizontalAlignment','right','VerticalAlignment','top')
    ylabel('Det. Efficiency')
    xlabel('Parallel Current Velocity (m/s)')
    legend('Winter','Spring','Summer','Fall','Mariners Fall')
end

 exportgraphics(gcf,'save4Square.png','Resolution',300)

% for COUNT = 1:length(normalizedPerp)
%     figure()
%     hold on
%     for season = 1:length(seasons)
%         scatter(x,normalizedPerp{COUNT}{season},'filled')
%     end
%     nameit = sprintf('Perpendicular %d',COUNT);
%     title(nameit)
%     ylabel('Normalized Det. Efficiency')
%     xlabel('Current Velocity (m/s)')
%     legend('Winter','Spring','Summer','Fall','Mariners Fall')
%     exportgraphics(gcf,sprintf('Transceiver%dPerpSeasonal.png',COUNT),'Resolution',300)
% end


%%

%All seasons together
for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(normalizedPara)
        labelz = num2str(sprintf('%d',COUNT))
%         scatter(x,normalizedPara{COUNT}{season},'filled')
        h= plot(x,normalizedPara{COUNT}{season})
        label(h,sprintf('%s',labelz),'location','North')
    end
    nameit = sprintf('Parallel %s',seasonName{season});
    title(nameit)
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
%     legend('Winter','Spring','Summer','Fall','Mariners Fall')
%     exportgraphics(gcf,sprintf('Transceiver%dParaSeasonal.png',COUNT),'Resolution',300)
end
% for season = 1:length(seasons)
%     figure()
%     hold on
%     for COUNT = 1:length(normalizedPerp)
%         scatter(x,normalizedPerp{COUNT}{season},'filled')
%     end
%     nameit = sprintf('Perpendicular %s',seasonName{season});
%     title(nameit)
%     ylabel('Normalized Det. Efficiency')
%     xlabel('Current Velocity (m/s)')
% %     exportgraphics(gcf,sprintf('Transceiver%dPerpSeasonal.png',COUNT),'Resolution',300)
% end
        labelz = num2str(sprintf('%d',COUNT))
        h = plot(x,allStrat{COUNT}(season,:))
        label(h,sprintf('%s',labelz))

%%
%One plot = all seasons for 1 transceiver, parallel + perp
% for COUNT = 1:length(normalizedPara)
%     f = figure;
%     f.Position = [100 100 450 800];
%     tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
%     for season = 1:length(seasons)
%         nexttile()
%         scatter(x,normalizedPara{COUNT}{season},'r','filled')
%         nameit = sprintf('Parallel %d, %s',COUNT,seasonName{season});
%         title(nameit)
%     end
%     ylabel('Normalized Det. Efficiency')
%     xlabel('Current Velocity (m/s)')
%     exportgraphics(gcf,sprintf('Trans%dParallel.png',COUNT),'Resolution',300)
% end

% for COUNT = 1:length(normalizedPerp)
%     f = figure;
%     f.Position = [100 100 450 800];
%     tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
%     for season = 1:length(seasons)
%         nexttile()
%         scatter(x,normalizedPerp{COUNT}{season},'b','filled')
%         nameit = sprintf('Perpendicular %d, %s',COUNT,seasonName{season});
%         title(nameit)
%     end
%     ylabel('Normalized Det. Efficiency')
%     xlabel('Current Velocity (m/s)')
%     exportgraphics(gcf,sprintf('Trans%dPerpendicular.png',COUNT),'Resolution',300)
% end
%%

%Transceiver pair, both directions? Workshopping this viz.

pairingNumb = [1;1;2;2;3;3;4;4;5;5]
for COUNT = 1:2:length(normalizedPara)
    f = figure;
    f.Position = [100 100 450 800];
    tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
    for season = 1:length(seasons)
        nexttile()
        scatter(x,normalizedPara{COUNT}{season},'r','filled')
        hold on
        scatter(x,normalizedPara{COUNT+1}{season},'k','filled')
        nameit = sprintf('Para., Transceivers %d, %s',pairingNumb(COUNT),seasonName{season});
        title(nameit)
        hold off
    end
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
%     exportgraphics(gcf,sprintf('ParaTrans%dBOTHdirections.png',pairingNumb(COUNT)),'Resolution',300)
end

%%
%Frank has deemed it necessary to add absolute values SO IT IS WRITTEN
%SO SHALL IT BE DONE. IN HIS NAME.
x = 0:0.05:.4;
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]

pairingNumb = [1;1;2;2;3;3;4;4;5;5]


% Both parallel directions
for COUNT = 1:2:length(normalizedParaABS)
f = figure;
f.Position = [100 100 450 800];
tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
for season = 1:length(seasons)
    nexttile()
    scatter(x,normalizedParaABS{COUNT}{season},'r','filled')
    hold on
    scatter(x,normalizedParaABS{COUNT+1}{season},'k','filled')
    nameit = sprintf('Both Directions, Absolute. Pairing %d, %s',pairingNumb(COUNT),seasonName{season});
    title(nameit)
    if season == 1
        legend('Sq to X','X to Sq')
    end

end
ylabel('Normalized Det. Efficiency')
xlabel('Current Magnitude (m/s)')
%     exportgraphics(gcf,sprintf('Trans%dABS.png',pairingNumb(COUNT)),'Resolution',300)
end

for COUNT = 1:2:length(normalizedParaABS)
    for season = 1:length(seasons)
        f = figure;
        f.Position = [100 100 450 800];
        scatter(x,normalizedParaABS{COUNT}{season},'r','filled')
        hold on
        scatter(x,normalizedParaABS{COUNT+1}{season},'k','filled')
        nameit = sprintf('Both Directions, Absolute. Pairing %d, %s',pairingNumb(COUNT),seasonName{season});
        title(nameit)
        ylabel('Normalized Det. Efficiency')
        xlabel('Current Magnitude (m/s)')
        if season == 1
            legend('Sq to X','X to Sq')
        end
    end
end



x = -0.4:0.05:.4;
for COUNT = 1:2:length(normalizedPara)
    f = figure;
    f.Position = [100 100 450 800];
    tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
    for season = 1:length(seasons)
        nexttile()
        scatter(x,normalizedPara{COUNT}{season},'r','filled')
        hold on
        scatter(x,normalizedPara{COUNT+1}{season},'k','filled')
        nameit = sprintf('Para., Transceivers %d, %s',pairingNumb(COUNT),seasonName{season});
        title(nameit)
        hold off
    end
    ylabel('Normalized Det. Efficiency')
    xlabel('Current Velocity (m/s)')
    exportgraphics(gcf,sprintf('ParaTrans%dBOTHdirections.png',pairingNumb(COUNT)),'Resolution',300)
end

%%
%Above is normalized, below is Average!! Less procssed
cd (localPlots)
x = 0:0.05:.4;
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
pairingNumb = [1;1;2;2;3;3;4;4;5;5];
changeYlol = [4;4;1;1;3;3;3.5;3.5;3.5;3.5];


% Both parallel directions
for COUNT = 1:2:length(averageParaTideABS)
    f = figure;
    f.Position = [50 0 450 800];
    tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
    for season = 1:length(seasons)
        nexttile()
        scatter(x,averageParaTideABS{COUNT}{season},'r','filled')
        hold on
        scatter(x,averageParaTideABS{COUNT+1}{season},'k','filled')
        errorbar(x,averageParaTideABS{COUNT}{season},errorDataABS{COUNT}(season,:),"LineStyle","none")
        errorbar(x,averageParaTideABS{COUNT+1}{season},errorDataABS{COUNT+1}(season,:),"LineStyle","none")
        ylim([0 changeYlol(COUNT)])
        nameit = sprintf('Both Directions, Absolute. Pairing %d, %s',pairingNumb(COUNT),seasonName{season});
        title(nameit)
        if season == 1
            legend('Sq to X','X to Sq')
        end
    end
    ylabel('Det. Efficiency')
    xlabel('Current Magnitude (m/s)')
%     exportgraphics(gcf,sprintf('Trans%dABS.png',pairingNumb(COUNT)),'Resolution',300)
end

setYlim = [0 0 0 0 0 0 0 0 0 0;
           4.5 4.5 1.5 1.5 4 4 4 4 4 4];


x = -0.4:0.05:.4;
for COUNT = 1:2:length(averageParaTide)
    f = figure;
    f.Position = [50 0 450 800];
    tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
    for season = 1:length(seasons)
        nexttile()
        scatter(x,averageParaTide{COUNT}{season},'r','filled')
        hold on
%         errorbar(x,averageParaTide{COUNT}{season},errorData{COUNT}(season,:),"LineStyle","none")
        scatter(x,averageParaTide{COUNT+1}{season},'k','filled')
%         errorbar(x,averageParaTide{COUNT+1}{season},errorData{COUNT+1}(season,:),"LineStyle","none")
        ylim(setYlim(:,COUNT))
        nameit = sprintf('Para., Transceivers %d, %s',pairingNumb(COUNT),seasonName{season});
        title(nameit)
        hold off
    end
    ylabel('Det. Efficiency')
    xlabel('Current Velocity (m/s)')
%     exportgraphics(gcf,sprintf('ParaTrans%dBOTHdirections.png',pairingNumb(COUNT)),'Resolution',300)
end



%%
x = -0.4:0.05:.4;

figure()
hold on
for COUNT = 1:length(averageAnnual)
    scatter(x,averageAnnual{COUNT},'filled')
%     errorbar(x,averageAnnual{COUNT},errorDataAnnual{COUNT},"LineStyle","none")
end
xline(0);

for COUNT = 1:length(averageAnnual)
    [maxDets(COUNT,1),findMax(COUNT)] = max(averageAnnual{COUNT});
    xEquivalent(COUNT,1) = x(findMax(COUNT))

end

    maxDetsPercentage = maxDets/6;


figure()
hold on
for COUNT = 1:length(normalizedAnnual)
    scatter(x,normalizedAnnual{COUNT},'filled')
end
xline(0);
xlabel('Parallel Current Velocity')
ylabel('Normalized Det Efficiency')
title('10 Transmission Directions','Pairings Normalized')

figure()
hold on
for COUNT = 1:length(normalizedAnnual)
    scatter(x,normalizedSingle{COUNT},color(COUNT),'filled')
end
plot(x,normalizedSingle{8},'b')
xline(0);
xlabel('Parallel Current Velocity (m/s)')
ylabel('Normalized Det Efficiency')
title('Effect of Parallel Currents' ,'10 Transmitters, Normalized')


figure()
hold on
for COUNT = 1:length(normalizedAnnual)
    plot(x,tiltCompareTideAnnual{COUNT},color(COUNT))
end
xline(0);
xlabel('Parallel Current Velocity')
ylabel('Instrument Tilt °')
title('Instrument Orientation')

figure()
hold on
for COUNT = 1:length(normalizedAnnual)
    plot(x,noiseCompareTideAnnual{COUNT},color(COUNT))
end
xline(0);
xlabel('Parallel Current Velocity')
ylabel('Ambient Noise (69 kHz, mV)')
title('Tides Effect on Noise')


% 