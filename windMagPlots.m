%%
%Related to paraPerpPlots, run binnedAVG then use this script to bin and
%visualize how detection efficiency changes with increases/decreases in
%wind power.

%binnedAVG
%createWindSpeedBins

% cd (localPlots)

%Creating an X-axis to emulate the bins of Wind data, 0-14 m/s
X = 0:6;

seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];


% 
% figure()
% scatter(X,yearlyWindSpeed,'filled')
% ylabel('Normalized Det. Efficiency')
% xlabel('Wind Magnitude (m/s)')
% title('Wind Magnitude''s Enabling of Detection Success')
% 
% 
% figure()
% yyaxis left
% scatter(X,yearlyTiltVsWindSpeed,'b','filled')
% ylabel('Avg Instrument Tilt')
% xlabel('Wind Magnitude (m/s)')
% 
% yyaxis right
% scatter(X,yearlyWindSpeed,'r','filled')
% ylabel('Normalized Det. Efficiency')
% legend('Tilt','Efficiency')
% title('Wind''s Effect on Moored Transceivers')

% 
% 
% for COUNT = 1:length(normalizedWSpeed)
%     figure()
%     hold on
%     for season = 1:length(seasons)
%         scatter(X,normalizedWSpeed{COUNT}{season},'filled')
% %         plot(X,normalizedWindSpeed{COUNT}{season})
%     end
%     nameit = sprintf('Wind Magnitude on Transceiver: %d',COUNT);
%     title(nameit)
%     ylabel('Normalized Det. Efficiency')
%     xlabel('Wind Magnitude (m/s)')
%    lgd =  legend('Winter','Spring','Summer','Fall','Mariners Fall',loc='upper left')
%    lgd.Location = 'northwest';
% %     exportgraphics(gcf,sprintf('Transceiver%dWinds.png',COUNT),'Resolution',300)
% end

% 

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
 
% X = 0:2:22;
% 
% 
% cd (localPlots)
% 
% seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
% color = ['r','r','g','g','k','k','b','b','m','m'];
% 
% figure()
% scatter(X,yearlyTiltVsWindSpeed,'filled')
% xlabel('Instrument Tilt')
% ylabel('Normalized Det. Efficiency')
% title('Yearly Avg Det Efficiency w/ different tilts')
% 
% for COUNT = 1:length(normalizedTilt)
%     figure()
%     hold on
%     for season = 1:length(seasons)
%         scatter(X,normalizedTilt{COUNT}{season},'filled')
%     end
%     nameit = sprintf('Tilt on Transceiver: %d',COUNT);
%     title(nameit)
%     ylabel('Normalized Det. Efficiency')
%     xlabel('Instrument Tilt')
%    lgd =  legend('Winter','Spring','Summer','Fall','Mariners Fall',loc='upper left')
% %    lgd.Location = 'northwest';
% %     exportgraphics(gcf,sprintf('Transceiver%dTilt.png',COUNT),'Resolution',300)
% end




for COUNT = 1:length(normalizedwindDir)
    figure()
    hold on
    for season = 1:length(seasons)
        scatter(X,normalizedwindDir{COUNT}{season},color(COUNT),'filled')
%         plot(X,normalizedTilt{COUNT}{season})
    end
%     nameit = sprintf('Tilt on Transceiver: %d',COUNT);
%     title(nameit)
    ylabel('Normalized Det. Efficiency')
    xlabel('Wind Dir.')
%    lgd =  legend('Winter','Spring','Summer','Fall','Mariners Fall',loc='upper left')
%    lgd.Location = 'northwest';
%     exportgraphics(gcf,sprintf('Transceiver%dTilt.png',COUNT),'Resolution',300)
    title('WindDir vs efficiency')
end


% Annuals

x = 1:length(averageWindSpeedAnnual(1,:))
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];

figure()
hold on
for COUNT = 1:height(averageWindSpeedAnnual)
    plot(x,averageWindSpeedAnnual(COUNT,:),color(COUNT))
    errorbar(x,averageWindSpeedAnnual(COUNT,:),errorWindAnnual(COUNT,:),color(COUNT),"LineStyle","none")
end
xlabel('Wind Magnitude')
ylabel('Detections')
ylim([0 6])





%Same graph, normalized
figure()
hold on
for COUNT = 1:height(averageWindSpeedAnnual)
    plot(x,normalizedWSpeedAnnual(COUNT,:))
%     errorbar(x,normalizedWSpeedAnnual(COUNT,:),errorWindAnnual(COUNT,:),color(COUNT))
end

xlabel('Wind Magnitude (m/s)')
ylabel('Normalized Det Efficiency')
xlim([0 13])
xline(3.60,'label','Light Breeze')
xline(5.65,'label','Moderate Breeze')
x1 = xline(10.8,'label','Strong Breeze')
x1.LabelVerticalAlignment = 'bottom'
title('Transmission Success','Increasing Wind Magnitude')


figure()
hold on
for COUNT = 1:length(noiseCompareAnnual)
    plot(x,noiseCompareAnnual{COUNT})
end
xlabel('Wind Magnitude')
ylabel('Ambient Noise (69 kHz, mV)')
x1 = xline(3.60,'label','Light Breeze')
x2 = xline(5.65,'label','Moderate Breeze')
x3 = xline(10.8,'label','Strong Breeze')
x1.LabelVerticalAlignment = 'bottom'
x2.LabelVerticalAlignment = 'bottom'
x3.LabelVerticalAlignment = 'bottom'
title('Ambient Noise','Increasing Wind Magnitude')

figure()
hold on
for COUNT = 1:length(tiltCompareWindAnnual)
    plot(x,tiltCompareWindAnnual{COUNT},color(COUNT))
end
xlabel('Wind Magnitude')
ylabel('Instrument Tilt °')
title('Instrument Orientation','Increasing Wind Magnitude')


figure()
hold on
for COUNT = 1:height(averageWindSpeedAnnual)
    plot(x,wavesCompareAnnual{COUNT},color(COUNT))
end
xline(3.60,'label','Light Breeze')
xline(5.65,'label','Moderate Breeze')
x1 = xline(10.8,'label','Strong Breeze')
xlabel('Wind Magnitude')
ylabel('WaveHeight')
title('WaveHeight','Increasing Wind Magnitude')

%


x = 1:length(averageWindSpeedAnnual(1,:))
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];

% Frank adding colors so I can track who is who
myColors = ['b','r','y','k','m','g','b','r','y','k','m','g','b']
myLineStyles = ["-";"--";"-o"]


f = figure;
f.Position = [100 -50 500 500];
% tiledlayout(1,3,'TileSpacing','Compact','Padding','Compact')
tiledlayout(1,4,'TileSpacing','Compact','Padding','Compact')
% 
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
for COUNT = 1:height(averageWindSpeedAnnual)
    plot(x,stratCompareWindAnnual{COUNT},'LineWidth',2)
end
x1 = xline(3.60,'--','LineWidth',1.5,'label','Light Breeze')
x2 = xline(5.65,'--','LineWidth',1.5,'label','Moderate')
x3 = xline(10.8,'--','LineWidth',1.5,'label','Strong Breeze')
x1.LabelVerticalAlignment = 'bottom'; x1.LabelHorizontalAlignment = 'left';
x2.LabelVerticalAlignment = 'bottom'; x1.LabelHorizontalAlignment = 'left';
xlim([0 12])
ylabel('Stratification (Δ°C)')
title('','Bulk Thermal Strat.')
ax = gca;
ax.LineStyleOrder = myLineStyles

nexttile()
hold on
for COUNT = 1:length(noiseCompareAnnual)
    plot(x,noiseCompareAnnual{COUNT},'LineWidth',2)
end
xlabel('Wind Magnitude (m/s)')
ylabel('High-Freq. Sound (mV)')
xlim([0 12])
x1 = xline(3.60,'--','LineWidth',1.5)
x2 = xline(5.65,'--','LineWidth',1.5)
x3 = xline(10.8,'--','LineWidth',1.5)
title('Coastal Wind''s Effect on Shallow Reef Telemetry','50-100 kHz Noise')



nexttile()
hold on
for COUNT = 1:height(averageWindSpeedAnnual)
    plot(x,normalizedWSpeedAnnual(COUNT,:),'LineWidth',2)
%     errorbar(x,normalizedWSpeedAnnual(COUNT,:),errorWindAnnual(COUNT,:),color(COUNT))
end
xlim([0 12])


ylabel('Normalized Det Efficiency')
xline(3.60,'--','LineWidth',1.5)
xline(5.65,'--','LineWidth',1.5)
x1 = xline(10.8,'--','LineWidth',1.5)
title('','Transmission Success')


%% Okay Frank, make separate figs. Ugh.
for COUNT = 1:height(averageWindSpeedAnnual)
f = figure;
f.Position = [100 -50 500 500];
% tiledlayout(1,3,'TileSpacing','Compact','Padding','Compact')
tiledlayout(1,4,'TileSpacing','Compact','Padding','Compact')
% 
nexttile()
hold on
    plot(x,wavesCompareAnnual{COUNT},'k','LineWidth',2)
xline(3.60,'--','LineWidth',1.5,'label','Light Breeze')
xline(5.65,'--','LineWidth',1.5,'label','Moderate Breeze')
x1 = xline(10.8,'--','LineWidth',1.5,'label','Strong Breeze')
x1.LabelVerticalAlignment = 'bottom'; x1.LabelHorizontalAlignment = 'left';
xlim([0 12])
ylabel('WaveHeight')
title('','WaveHeight')



nexttile()
hold on
    plot(x,stratCompareWindAnnual{COUNT},'LineWidth',2)
x1 = xline(3.60,'--','LineWidth',1.5,'label','Light Breeze')
x2 = xline(5.65,'--','LineWidth',1.5,'label','Moderate')
x3 = xline(10.8,'--','LineWidth',1.5,'label','Strong Breeze')
x1.LabelVerticalAlignment = 'bottom'; x1.LabelHorizontalAlignment = 'left';
x2.LabelVerticalAlignment = 'bottom'; x1.LabelHorizontalAlignment = 'left';
xlim([0 12])
ylabel('Stratification (Δ°C)')
title('','Bulk Thermal Strat.')
ax = gca;
ax.LineStyleOrder = myLineStyles

nexttile()
hold on
    plot(x,noiseCompareAnnual{COUNT},'LineWidth',2)
xlabel('Wind Magnitude (m/s)')
ylabel('High-Freq. Sound (mV)')
xlim([0 12])
x1 = xline(3.60,'--','LineWidth',1.5)
x2 = xline(5.65,'--','LineWidth',1.5)
x3 = xline(10.8,'--','LineWidth',1.5)
title('Coastal Wind''s Effect on Shallow Reef Telemetry','50-100 kHz Noise')



nexttile()
hold on
    plot(x,normalizedWSpeedAnnual(COUNT,:),'LineWidth',2)
xlim([0 12])


ylabel('Normalized Det Efficiency')
xline(3.60,'--','LineWidth',1.5)
xline(5.65,'--','LineWidth',1.5)
x1 = xline(10.8,'--','LineWidth',1.5)
title('','Transmission Success')

end


%%

%
% FM 7/23/23 - have to look at single plots of noise vs detection efficiency
% pairings. 

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
    plot(x,noiseCompareAnnual{COUNT+1},'k','LineStyle','-','LineWidth',2);
    ylim([400 800])
    yyaxis right
    plot(x,normalizedWSpeedAnnual(COUNT,:),color(COUNT),'LineStyle','--','LineWidth',2)
    plot(x,normalizedWSpeedAnnual(COUNT+1,:),color(COUNT+1),'LineStyle','--','LineWidth',2)
    ylim([0 1])
end

% Tiling transceiver pairings
%
orderNumbers = [1 1 2 2 3 3 4 4 5 5];
figure()
tiledlayout(4,4,'TileSpacing','Compact','Padding','Compact')
hold on
for COUNT = 1:2:5
    nexttile
    yyaxis left
    plot(x,noiseCompareAnnual{COUNT},color(COUNT),'LineStyle','-','LineWidth',2);
    hold on
    plot(x,noiseCompareAnnual{COUNT+1},color(COUNT+1),'LineStyle','-','LineWidth',2);
    ylim([380 820])
    yyaxis right
    plot(x,normalizedWSpeedAnnual(COUNT,:),color(COUNT),'LineStyle','--','LineWidth',2)
    hold on
    plot(x,normalizedWSpeedAnnual(COUNT+1,:),color(COUNT+1),'LineStyle','--','LineWidth',2)
    ylim([0 1])
    xlim([0 12])
    if COUNT == 7
        legend('Noise Levels','','Detections','')
    end
    nameit = sprintf('Transceiver Pair %d',orderNumbers(COUNT));
    title(nameit)
end
%

% just picking certain pairings now
% Pairing one: SURTASSTN20 to STSNew1, denser part of reef
% Pairing two: Roldan to 08ALTIN, more sparse


figure()
tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact')
nexttile
yyaxis left
plot(x,noiseCompareAnnual{1},'b','LineStyle','--','LineWidth',2);
hold on
plot(x,noiseCompareAnnual{2},'b','LineStyle','--','LineWidth',2);
ylim([380 820])
ylabel('High Freq. Noise (mV)')
ax = gca;
ax.YAxis(1).Color = 'k'

yyaxis right
plot(x,normalizedWSpeedAnnual(1,:),'r','LineStyle','-','LineWidth',2)
hold on
plot(x,normalizedWSpeedAnnual(2,:),'r','LineStyle','-','LineWidth',2)
ylim([0 1])
xlim([0 12])
set(gca,'YTick', [])
ax = gca;
ax.YAxis(2).Color = 'k'
title('Transceiver Pairing A','Denser, Shallower Reef')
xlabel('Wind speed (m/s)');



nexttile
yyaxis left
plot(x,noiseCompareAnnual{5},'b','LineStyle','--','LineWidth',2);
hold on
plot(x,noiseCompareAnnual{6},'b','LineStyle','--','LineWidth',2);
ylim([380 820])
set(gca,'YTick', [])
ax = gca;
ax.YAxis(1).Color = 'k';

yyaxis right
plot(x,normalizedWSpeedAnnual(5,:),'r','LineStyle','-','LineWidth',2)
hold on
plot(x,normalizedWSpeedAnnual(6,:),'r','LineStyle','-','LineWidth',2)
ylim([0 1])
xlim([0 12])
ax = gca;
ax.YAxis(2).Color = 'k'
ylabel('Normalized Detection Efficiency')
xlabel('Wind speed (m/s)');
legend('Average Noise','','Det. Efficiency','')
title('Transceiver Pairing B','Sparser, Deeper Reef')

export_fig pairingComparison.jpeg -r600 -transparent




%
FM testing season winds

X = 1:length(averageWindSpeed{1}{1});

seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];

figure()
hold on
for COUNT = 1:length(X)
    for seaason = 1:length(seasons)
        plot(X,averageWindSpeed{COUNT}{season},color(COUNT))
    errorbar(x,averageWindSpeedAnnual(COUNT,:),errorWindAnnual(COUNT,:),color(COUNT),"LineStyle","none")
    end
end
xlabel('Wind Magnitude')
ylabel('Detections')
ylim([0 6])


figure()
plot()





