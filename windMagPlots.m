%%
%Related to paraPerpPlots, run binnedAVG then use this script to bin and
%visualize how detection efficiency changes with increases/decreases in
%wind power.

%binnedAVG


cd (localPlots)

%Creating an X-axis to emulate the bins of Wind data, 0-14 m/s
X = 0:12;

seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];



figure()
scatter(X,yearlyWindSpeed,'filled')
ylabel('Normalized Det. Efficiency')
xlabel('Wind Magnitude (m/s)')
title('Wind Magnitude''s Enabling of Detection Success')


figure()
yyaxis left
scatter(X,yearlyTiltVsWindSpeed,'b','filled')
ylabel('Avg Instrument Tilt')
xlabel('Wind Magnitude (m/s)')

yyaxis right
scatter(X,yearlyWindSpeed,'r','filled')
ylabel('Normalized Det. Efficiency')

title('Wind''s Effect on Moored Transceivers')



for COUNT = 1:length(normalizedWSpeed)
    figure()
    hold on
    for season = 1:length(seasons)
        scatter(X,normalizedWSpeed{COUNT}{season},'filled')
%         plot(X,normalizedWindSpeed{COUNT}{season})
    end
    nameit = sprintf('Wind Magnitude on Transceiver: %d',COUNT);
    title(nameit)
    ylabel('Normalized Det. Efficiency')
    xlabel('Wind Magnitude (m/s)')
   lgd =  legend('Winter','Spring','Summer','Fall','Mariners Fall',loc='upper left')
   lgd.Location = 'northwest';
%     exportgraphics(gcf,sprintf('Transceiver%dWinds.png',COUNT),'Resolution',300)
end



%All seasons together
for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(normalizedWSpeed)
        scatter(X,normalizedWSpeed{COUNT}{season},'filled')
    end
    nameit = sprintf('Winds During %s',seasonName{season});
    title(nameit)
    ylabel('Normalized Det. Efficiency')
    xlabel('Wind Magnitude (m/s)')
%     legend('Winter','Spring','Summer','Fall','Mariners Fall')
%     exportgraphics(gcf,sprintf('WindsDuring %s .png',seasonName{season}),'Resolution',300)
end



%
 
X = 0:2:22;


cd (localPlots)

seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];

figure()
scatter(X,yearlyTiltVsWindSpeed,'filled')
xlabel('Instrument Tilt')
ylabel('Normalized Det. Efficiency')
title('Yearly Avg Det Efficiency w/ different tilts')

for COUNT = 1:length(normalizedTilt)
    figure()
    hold on
    for season = 1:length(seasons)
        scatter(X,normalizedTilt{COUNT}{season},'filled')
    end
    nameit = sprintf('Tilt on Transceiver: %d',COUNT);
    title(nameit)
    ylabel('Normalized Det. Efficiency')
    xlabel('Instrument Tilt')
   lgd =  legend('Winter','Spring','Summer','Fall','Mariners Fall',loc='upper left')
%    lgd.Location = 'northwest';
%     exportgraphics(gcf,sprintf('Transceiver%dTilt.png',COUNT),'Resolution',300)
end


figure()
hold on
for COUNT = 1:length(normalizedTilt)
    for season = 1:length(seasons)
        scatter(X,normalizedTilt{COUNT}{season},color(COUNT),'filled')
%         plot(X,normalizedTilt{COUNT}{season})
    end
%     nameit = sprintf('Tilt on Transceiver: %d',COUNT);
%     title(nameit)
    ylabel('Normalized Det. Efficiency')
    xlabel('Instrument Tilt')
%    lgd =  legend('Winter','Spring','Summer','Fall','Mariners Fall',loc='upper left')
%    lgd.Location = 'northwest';
%     exportgraphics(gcf,sprintf('Transceiver%dTilt.png',COUNT),'Resolution',300)
    title('12 gauge shotgun blast of tilt vs efficiency')
end

%%
% Wind direction instead of wind speed, here
% cd (localPlots)
% 
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];
% 
% 
% X = 20:20:360;
% 
% figure()
% scatter(X,yearlywindDir,'filled')
% ylabel('Normalized Det. Efficiency')
% xlabel('Wind Direction')
% title('Wind Direction''s Enabling of Detection Success')
% 
% 
% figure()
% scatter(X,yearlyTiltVswindDir,'filled')
% xlabel('Wind Direction')
% ylabel('Instrument Tilt')
% title('Phys Processes Tilting Instruments')
% 
% 
% 
% 
% 
% for COUNT = 1:length(normalizedwindDir)
%     figure()
%     hold on
%     for season = 1:length(seasons)
%         scatter(X,normalizedwindDir{COUNT}{season},color(COUNT),'filled')
% %         plot(X,normalizedTilt{COUNT}{season})
%     end
% %     nameit = sprintf('Tilt on Transceiver: %d',COUNT);
% %     title(nameit)
%     ylabel('Normalized Det. Efficiency')
%     xlabel('Wind Dir.')
% %    lgd =  legend('Winter','Spring','Summer','Fall','Mariners Fall',loc='upper left')
% %    lgd.Location = 'northwest';
% %     exportgraphics(gcf,sprintf('Transceiver%dTilt.png',COUNT),'Resolution',300)
%     title('WindDir vs efficiency')
% end
% 
% 
% pairingNumb = [1;1;2;2;3;3;4;4;5;5]
% for COUNT = 1:2:length(normalizedwindDir)
%     f = figure;
%     f.Position = [100 100 450 800];
%     tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
%     for season = 1:length(seasons)
%         nexttile()
%         scatter(X,normalizedwindDir{COUNT}{season},'r','filled')
%         hold on
%         scatter(X,normalizedwindDir{COUNT+1}{season},'k','filled')
%         nameit = sprintf('Wind, Transceivers %d, %s',pairingNumb(COUNT),seasonName{season});
%         title(nameit)
%         hold off
%     end
%     ylabel('Normalized Det. Efficiency')
%     xlabel('Wind Direction')
%     exportgraphics(gcf,sprintf('WindTrans%dBOTHdirections.png',pairingNumb(COUNT)),'Resolution',300)
% end
% 
% 
% for COUNT = 1:length(normalizedwindDir)
%     figure()
%     hold on
%     for season = 1:length(seasons)
%         scatter(X,normalizedwindDir{COUNT}{season},color(COUNT),'filled')
% %         plot(X,normalizedTilt{COUNT}{season})
%     end
% %     nameit = sprintf('Tilt on Transceiver: %d',COUNT);
% %     title(nameit)
%     ylabel('Normalized Det. Efficiency')
%     xlabel('Wind Dir.')
% %    lgd =  legend('Winter','Spring','Summer','Fall','Mariners Fall',loc='upper left')
% %    lgd.Location = 'northwest';
% %     exportgraphics(gcf,sprintf('Transceiver%dTilt.png',COUNT),'Resolution',300)
%     title('WindDir vs efficiency')
% end

%%

% Annuals

x = 1:length(averageWindSpeedAnnual(1,:))
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];

figure()
hold on
for COUNT = 1:height(averageWindSpeedAnnual)
    plot(x,averageWindSpeedAnnual(COUNT,:),color(COUNT))
%     errorbar(x,averageWindSpeedAnnual(COUNT,:),errorWindAnnual(COUNT,:),color(COUNT),"LineStyle","none")
end
xlabel('Wind Magnitude')
ylabel('Det Efficiency')
ylim([0 6])
% 
% 
% 
% 
% 
% %Same graph, normalized
% figure()
% hold on
% for COUNT = 1:height(averageWindSpeedAnnual)
%     plot(x,normalizedWSpeedAnnual(COUNT,:),color(COUNT))
% %     errorbar(x,normalizedWSpeedAnnual(COUNT,:),errorWindAnnual(COUNT,:),color(COUNT))
% end
% 
% xlabel('Wind Magnitude (m/s)')
% ylabel('Normalized Det Efficiency')
% xlim([0 13])
% xline(3.60,'label','Light Breeze')
% xline(5.65,'label','Moderate Breeze')
% x1 = xline(10.8,'label','Strong Breeze')
% x1.LabelVerticalAlignment = 'bottom'
% title('Transmission Success','Increasing Wind Magnitude')
% 
% 
% figure()
% hold on
% for COUNT = 1:length(noiseCompareAnnual)
%     plot(x,noiseCompareAnnual{COUNT},color(COUNT))
% end
% xlabel('Wind Magnitude')
% ylabel('Ambient Noise (69 kHz, mV)')
% x1 = xline(3.60,'label','Light Breeze')
% x2 = xline(5.65,'label','Moderate Breeze')
% x3 = xline(10.8,'label','Strong Breeze')
% x1.LabelVerticalAlignment = 'bottom'
% x2.LabelVerticalAlignment = 'bottom'
% x3.LabelVerticalAlignment = 'bottom'
% title('Ambient Noise','Increasing Wind Magnitude')
% 
% figure()
% hold on
% for COUNT = 1:length(tiltCompareWindAnnual)
%     plot(x,tiltCompareWindAnnual{COUNT},color(COUNT))
% end
% xlabel('Wind Magnitude')
% ylabel('Instrument Tilt °')
% title('Instrument Orientation','Increasing Wind Magnitude')
% 
% 
% figure()
% hold on
% for COUNT = 1:height(averageWindSpeedAnnual)
%     plot(x,wavesCompareAnnual{COUNT},color(COUNT))
% end
% xline(3.60,'label','Light Breeze')
% xline(5.65,'label','Moderate Breeze')
% x1 = xline(10.8,'label','Strong Breeze')
% xlabel('Wind Magnitude')
% ylabel('WaveHeight')
% title('WaveHeight','Increasing Wind Magnitude')
% 
% %
% x = 0:12;
% 
% figure()
% scatter(x,yearlyWindSpeed,200,yearlyStratVsWindSpeed,'filled')
% xlim([-0.5 12.3])
% h = colorbar
% colormap jet
% ylabel(h,'Bulk Thermal Strat (°C)')
% xlabel('Wind Magnitude (m/s)')
% ylabel('Normalized Detection Efficiency')
% title('Increasing Wind Magnitude','Change in Bulk Thermal Stratification')


%FM 7/19 tiled layout for figure

x = 1:length(averageWindSpeedAnnual(1,:))
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];


f = figure;
f.Position = [100 -50 500 500];
tiledlayout(1,3,'TileSpacing','Compact','Padding','Compact')

nexttile()
hold on
for COUNT = 1:height(averageWindSpeedAnnual)
    plot(x,wavesCompareAnnual{COUNT},'k','LineWidth',2)
end
xline(3.60,'--','LineWidth',1.5,'label','Light Breeze')
xline(5.65,'--','LineWidth',1.5,'label','Moderate Breeze')
x1 = xline(10.8,'--','LineWidth',1.5,'label','Strong Breeze')
x1.LabelVerticalAlignment = 'bottom'; x1.LabelHorizontalAlignment = 'left';
xlim([0 12])
ylabel('WaveHeight')
title('','WaveHeight')

nexttile()
hold on
for COUNT = 1:length(noiseCompareAnnual)
    plot(x,noiseCompareAnnual{COUNT},color(COUNT),'LineWidth',2)
end
xlabel('Wind Magnitude (m/s)')
ylabel('Ambient Sound (69 kHz, mV)')
xlim([0 12])
x1 = xline(3.60,'--','LineWidth',1.5)
x2 = xline(5.65,'--','LineWidth',1.5)
x3 = xline(10.8,'--','LineWidth',1.5)
title('High Wind Magnitudes Enabling Acoustic Detections','Ambient Sound')

nexttile()
hold on
for COUNT = 1:height(averageWindSpeedAnnual)
    plot(x,normalizedWSpeedAnnual(COUNT,:),color(COUNT),'LineWidth',2)
%     errorbar(x,normalizedWSpeedAnnual(COUNT,:),errorWindAnnual(COUNT,:),color(COUNT))
end
xlim([0 12])


ylabel('Normalized Det Efficiency')
xline(3.60,'--','LineWidth',1.5)
xline(5.65,'--','LineWidth',1.5)
x1 = xline(10.8,'--','LineWidth',1.5)
title('','Transmission Success')


%%
%FM 7/23/23 - have to look at single plots of noise vs detection efficiency
%pairings. 

figure()
nexttile()
hold on
for COUNT = 1:length(noiseCompareAnnual)
    plot(x,noiseCompareAnnual{COUNT},color(COUNT),'LineWidth',2)
end
xlabel('Wind Magnitude (m/s)')
ylabel('Ambient Sound (69 kHz, mV)')
xlim([0 12])
x1 = xline(3.60,'--','LineWidth',1.5)
x2 = xline(5.65,'--','LineWidth',1.5)
x3 = xline(10.8,'--','LineWidth',1.5)
title('High Wind Magnitudes Enabling Acoustic Detections','Ambient Sound')

for COUNT = 1:2:length(noiseCompareAnnual)-1
    figure()
    hold on
    yyaxis left
    plot(x,noiseCompareAnnual{COUNT},color(COUNT),'LineStyle','-','LineWidth',2);
    plot(x,noiseCompareAnnual{COUNT+1},color(COUNT+1),'LineStyle','-','LineWidth',2);
    ylim([400 800])
    yyaxis right
    plot(x,normalizedWSpeedAnnual(COUNT,:),color(COUNT),'LineStyle','--','LineWidth',2)
    plot(x,normalizedWSpeedAnnual(COUNT+1,:),color(COUNT+1),'LineStyle','--','LineWidth',2)
    ylim([0 1])
end

%Tiling transceiver pairings

figure()
tiledlayout(4,4,'TileSpacing','Compact','Padding','Compact')
hold on
for COUNT = 1:2:length(noiseCompareAnnual)-1
    nexttile
    yyaxis left
    plot(x,noiseCompareAnnual{COUNT},color(COUNT),'LineStyle','-','LineWidth',2);
    plot(x,noiseCompareAnnual{COUNT+1},color(COUNT+1),'LineStyle','-','LineWidth',2);
    ylim([400 800])
    yyaxis right
    plot(x,normalizedWSpeedAnnual(COUNT,:),color(COUNT),'LineStyle','--','LineWidth',2)
    plot(x,normalizedWSpeedAnnual(COUNT+1,:),color(COUNT+1),'LineStyle','--','LineWidth',2)
    ylim([0 1])
end
