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
%    lgd =  legend('Winter','Spring','Summer','Fall','Mariners Fall',loc='upper left')
%    lgd.Location = 'northwest';
    exportgraphics(gcf,sprintf('Transceiver%dWinds.png',COUNT),'Resolution',300)
end

for COUNT = 1:2
    figure()
    hold on
    for season = 1:length(seasons)
        scatter(X,normalizedWSpeedAnnual{COUNT}{season},'filled')
%         plot(X,normalizedWindSpeed{COUNT}{season})
    end
    nameit = sprintf('Wind Magnitude on Transceiver: %d',COUNT);
    title(nameit)
    ylabel('Normalized Det. Efficiency')
    xlabel('Wind Magnitude (m/s)')
%    lgd =  legend('Winter','Spring','Summer','Fall','Mariners Fall',loc='upper left')
%    lgd.Location = 'northwest';
    exportgraphics(gcf,sprintf('Transceiver%dWinds.png',COUNT),'Resolution',300)
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
    exportgraphics(gcf,sprintf('WindsDuring %s .png',seasonName{season}),'Resolution',300)
end



%%
 
X = 0:2:22;

cd (localPlots)

seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];

figure()
scatter(x,yearlyTiltVsWindSpeed,'filled')
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
cd (localPlots)

seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];


X = 20:20:360;

figure()
scatter(X,yearlywindDir,'filled')
ylabel('Normalized Det. Efficiency')
xlabel('Wind Direction')
title('Wind Direction''s Enabling of Detection Success')


figure()
scatter(X,yearlyTiltVswindDir,'filled')
xlabel('Wind Direction')
ylabel('Instrument Tilt')
title('Phys Processes Tilting Instruments')





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


pairingNumb = [1;1;2;2;3;3;4;4;5;5]
for COUNT = 1:2:length(normalizedwindDir)
    f = figure;
    f.Position = [100 100 450 800];
    tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact')
    for season = 1:length(seasons)
        nexttile()
        scatter(X,normalizedwindDir{COUNT}{season},'r','filled')
        hold on
        scatter(X,normalizedwindDir{COUNT+1}{season},'k','filled')
        nameit = sprintf('Wind, Transceivers %d, %s',pairingNumb(COUNT),seasonName{season});
        title(nameit)
        hold off
    end
    ylabel('Normalized Det. Efficiency')
    xlabel('Wind Direction')
    exportgraphics(gcf,sprintf('WindTrans%dBOTHdirections.png',pairingNumb(COUNT)),'Resolution',300)
end


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

%%

% Annuals

x = 1:length(averageWindSpeedAnnual{1})


figure()
hold on
for COUNT = 1:length(averageWindSpeedAnnual)
    plot(x,averageWindSpeedAnnual{COUNT},color(COUNT))
    errorbar(x,averageWindSpeedAnnual{COUNT},errorWindAnnual(COUNT,:),color(COUNT),"LineStyle","none")
end
xlabel('Wind Magnitude')
ylabel('Det Efficiency')





%Same graph, normalized
figure()
hold on
for COUNT = 1:length(averageWindSpeedAnnual)
    plot(x,normalizedWSpeedAnnual{COUNT},color(COUNT))
end
xlabel('Wind Magnitude')
ylabel('Normalized Det Efficiency')
title('Transmission Success','Increasing Wind Magnitude')


figure()
hold on
for COUNT = 1:length(averageWindSpeedAnnual)
    plot(x,noiseCompareAnnual{COUNT},color(COUNT))
end
xlabel('Wind Magnitude')
ylabel('Ambient Noise (69 kHz, mV)')
title('Ambient Noise','Increasing Wind Magnitude')

figure()
hold on
for COUNT = 1:length(averageWindSpeedAnnual)
    plot(x,tiltCompareWindAnnual{COUNT},color(COUNT))
end
xlabel('Wind Magnitude')
ylabel('Instrument Tilt °')
title('Instrument Orientation','Increasing Wind Magnitude')


figure()
hold on
for COUNT = 1:length(averageWindSpeedAnnual)
    plot(x,wavesCompareAnnual{COUNT},color(COUNT))
end
xlabel('Wind Magnitude')
ylabel('WaveHeight')
title('WaveHeight','Increasing Wind Magnitude')


