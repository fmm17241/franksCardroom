%FM creating paper figure, need to color code paths between tranceivers


%Transceiver pairings:
% 1.  SURTASSSTN20 hearing STSNew1
% 2.  STSNew1 hearing SURTASSSTN20
% 3.  SURTASS05In hearing FS6
% 4.  FS6 hearing SURTASS05In
% 5.  Roldan hearing 08ALTIN
% 6.  08ALTIN hearing Roldan
% 7.  SURTASS05In hearing STSNEW2
% 8.  STSNEW2 hearing SURTASS05In
% 9.  39IN hearing SURTASS05IN
% 10. SURTASS05IN hearing 39IN
% 11. STSNEW2 hearing FS6
% 12. FS6 hearing STSNew2

load mooredGPS 
transmitters = {'63068' '63073' '63067' '63079' '63080' '63066' '63076' '63078' '63063'...
        '63070' '63074' '63075' '63081' '63064' '63062' '63071'};

figure()
scatter(mooredGPS(:,2),mooredGPS(:,1),'filled')
axis equal

binnedAVG
createWindSpeedBins



x = 1:length(averageWindSpeedAnnual(1,:))
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];


f = figure;
f.Position = [100 -50 500 500];
% tiledlayout(1,3,'TileSpacing','Compact','Padding','Compact')
tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact')

% 
% nexttile()
% hold on
% for COUNT = 1:height(averageWindSpeedAnnual)
%     plot(x,wavesCompareAnnual{COUNT},'k','LineWidth',2)
% end
% xline(3.60,'--','LineWidth',1.5,'label','Light Breeze')
% xline(5.65,'--','LineWidth',1.5,'label','Moderate Breeze')
% x1 = xline(10.8,'--','LineWidth',1.5,'label','Strong Breeze')
% x1.LabelVerticalAlignment = 'bottom'; x1.LabelHorizontalAlignment = 'left';
% xlim([0 12])
% ylabel('WaveHeight')
% title('','WaveHeight')

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



