
% Load in data. Consolidating my figures so I don't lose them.

% franksTalkingPoints
% addressingAutoCorrelation

X1 = 1:length(times);
X2 = 1:length(decimatedData.Snaps);

figure()
Tiled = tiledlayout(4,3)
ax4 = nexttile([2,1])
scatter(snapRateHourly.SnapCount,envData.Noise,[],X1)
% hold on
% scatter(decimatedData.Snaps,decimatedData.Noise,[],X2,'filled')
xlabel('Hourly Snaprate')
ylabel('HF Noise (mV)')
title('','High-Frequency Noise Being Created')
% legend('Raw','40Hr Lowpass')


ax5 = nexttile([2,1])
% scatter(surfaceData.WSPD,envData.Noise)
scatter(surfaceData.SBLcapped,envData.Noise,[],X1)
hold on
% scatter(filteredData.Winds,filteredData.Noise)
% scatter(decimatedData.SBLcapped,decimatedData.Noise,[],X2,'filled')
ylabel('HF Noise (mV)')
xlabel('Surface Bubble Loss (dBs)')
title('Gray''s Reef Soundscape, Spring 2020','Noise Being Attenuated at the Surface')


ax6 = nexttile([2,1])
scatter(surfaceData.WSPD,snapRateHourly.SnapCount,[],X1)
% hold on
% scatter(decimatedData.Winds,decimatedData.Snaps,[],X2,'filled')
ylabel('Hourly Snaps')
xlabel('Windspeed (m/s)')
title('','Wind''s Effect on Snap Rate')

ax1 = nexttile([2,1])
% scatter(snapRateHourly.SnapCount,envData.Noise,[],X1)
% hold on
scatter(decimatedData.Snaps,decimatedData.Noise,[],X2,'filled')
xlabel('Hourly Snaprate')
ylabel('HF Noise (mV)')
title('','High-Frequency Noise Being Created')
% legend('Raw','40Hr Lowpass')


ax2 = nexttile([2,1])
% scatter(surfaceData.WSPD,envData.Noise)
% scatter(surfaceData.SBLcapped,envData.Noise,[],X1)
% hold on
% scatter(filteredData.Winds,filteredData.Noise)
scatter(decimatedData.SBLcapped,decimatedData.Noise,[],X2,'filled')
ylabel('HF Noise (mV)')
xlabel('Surface Bubble Loss (dBs)')
title('40Hr Lowpass-Filtered','Noise Being Attenuated at the Surface')


ax3 = nexttile([2,1])
% scatter(surfaceData.WSPD,snapRateHourly.SnapCount,[],X1)
% hold on
scatter(decimatedData.Winds,decimatedData.Snaps,[],X2,'filled')
ylabel('Hourly Snaps')
xlabel('Windspeed (m/s)')
title('','Wind''s Effect on Snap Rate')



% Column 1
[R,P] = corrcoef(envData.Noise,snapRateHourly.SnapCount)
RSqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.Noise,decimatedData.Snaps)
RSqrd = R(1,2)*R(1,2)
% Column 2
[R,P] = corrcoef(surfaceData.SBLcapped,envData.Noise)
Rsqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.SBLcapped,decimatedData.Noise)
Rsqrd = R(1,2)*R(1,2)
% Column 3
[R,P] = corrcoef(surfaceData.WSPD,snapRateHourly.SnapCount)
RSqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.Winds,decimatedData.Snaps)
RSqrd = R(1,2)*R(1,2)




[R,P] = corrcoef(decimatedData.Detections,decimatedData.Snaps)



[R,P] = corrcoef(decimatedData.SBLcapped,decimatedData.Snaps)

[R,P] = corrcoef(decimatedData.SBLcapped,decimatedData.Snaps)
[R,P] = corrcoef(surfaceData.SBLcapped,snapRateHourly.SnapCount)
[R,P] = corrcoef(decimatedData.Winds,decimatedData.Snaps)
[R,P] = corrcoef(surfaceData.WSPD,snapRateHourly.SnapCount)

[R,P] = corrcoef(decimatedData.Waves,decimatedData.Snaps)
[R,P] = corrcoef(surfaceData.waveHeight,snapRateHourly.SnapCount)

[R,P] = corrcoef(decimatedData.SBLcapped,decimatedData.Noise)
Rsqrd = R(1,2)*R(1,2)


[R,P] = corrcoef(surfaceData.SBLcapped,envData.Noise)
Rsqrd = R(1,2)*R(1,2)




[R,P] = corrcoef(decimatedData.BulkStrat,decimatedData.Noise)
Rsqrd = R(1,2)*R(1,2)


%%
%Table of Spring Stats
%
[R,P] = corrcoef(surfaceData.WSPD,snapRateHourly.SnapCount)
RSqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.Winds,decimatedData.Snaps)
RSqrd = R(1,2)*R(1,2)
%
[R,P] = corrcoef(surfaceData.WSPD,envData.Noise)
RSqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.Winds,decimatedData.Noise)
RSqrd = R(1,2)*R(1,2)
%
[R,P] = corrcoef(surfaceData.SBLcapped,envData.Noise)
Rsqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.SBLcapped,decimatedData.Noise)
Rsqrd = R(1,2)*R(1,2)
%
[R,P] = corrcoef(surfaceData.SBLcapped,envData.HourlyDets)
RSqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.SBLcapped,decimatedData.Detections)
RSqrd = R(1,2)*R(1,2)
%
[R,P] = corrcoef(envData.Noise,snapRateHourly.SnapCount)
RSqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.Noise,decimatedData.Snaps)
RSqrd = R(1,2)*R(1,2)
%
[R,P] = corrcoef(envData.Temp,snapRateHourly.SnapCount)
RSqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.BottomTemp,decimatedData.Snaps)
RSqrd = R(1,2)*R(1,2)
%
[R,P] = corrcoef(surfaceData.SBLcapped,snapRateHourly.SnapCount)
RSqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.SBLcapped,decimatedData.Snaps)
RSqrd = R(1,2)*R(1,2)
%
[R,P] = corrcoef(envData.bulkThermalStrat,surfaceData.WSPD)
RSqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.BulkStrat,decimatedData.Winds)
RSqrd = R(1,2)*R(1,2)
%

%%%
% LowpassTilesLabel

figure()
TT = tiledlayout(2,4)
ax1 = nexttile([1,4])
yyaxis left
plot(times(92:948),filteredData.SBLcapped(92:948),'b--','LineWidth',2)
ylim([0 16])
ylabel('SBL (dB)')
title('Surface Bubble Loss and Detections','SURTASSTN20, 40-hour lowpass filter')

yyaxis right
plot(times(92:948),filteredData.Detections(92:948),'r','LineWidth',2)
ylim([0 2.8])
ylabel('Detections')

legend('SBL','Detections')

ax2 = nexttile([1,4])
yyaxis left
plot(times(92:948),filteredData.SBLcapped(92:948),'b--','LineWidth',2)
ylim([0 16])
ylabel('SBL (dB)')


yyaxis right
plot(times(92:948),filteredData.Noise(92:948),'k','LineWidth',2)
ylim([525 700])
ylabel('HF Noise (mV)')
legend('SBL','Noise')

linkaxes([ax1,ax2],'x')
ax2.YAxis(2).Color = 'k';
title('Surface Bubble Loss and Noise (50-90 kHz)','SURTASSTN20, 40-hour lowpass filter')


%%
% "FullStoryTilesHorizontal"

%Feb 18 19:00 - Feb 24 15:00
loopIndexFilt{3} = 461:601;
loopIndexDS{3} = 116:151;

figure()
TTTT = tiledlayout(4,6)
ax1 = nexttile([2,2])
yyaxis left
scatter(decimatedData.Time(loopIndexDS{3}),decimatedData.SBLcapped(loopIndexDS{3}),70,'filled')
ylim([0 15])
ylabel('SBL (dB)')
yyaxis right
scatter(decimatedData.Time(loopIndexDS{3}),decimatedData.Noise(loopIndexDS{3}),70,'k','filled','^')
ylabel('Noise (mV)')
% title('Noise Attenuation due to SBL','40Hr Lowpass')
title('Noise Attenuation due to Surface Bubble Loss')
% legend('SBL','Noise')
hleg = legend('SBL','Noise');
htitle = get(hleg,'Title');
set(htitle,'String','Lowpass-Filtered')


ax2 = nexttile([2,2])
yyaxis left
scatter(decimatedData.Time(loopIndexDS{3}),decimatedData.SBLcapped(loopIndexDS{3}),70,'filled')
ylim([0 15])
% ylabel('SBL (dB)')
yyaxis right
scatter(decimatedData.Time(loopIndexDS{3}),decimatedData.Detections(loopIndexDS{3}),70,'r','filled','hexagram')
ylabel('Detections')
% title('Surface Attenuation Enabling Acoustic Telemetry','40Hr Lowpass')
title('Telemetry Efficiency Versus Background Noise')
% legend('SBL','Detections')
hleg = legend('SBL','Detections');
htitle = get(hleg,'Title');
set(htitle,'String','Lowpass-Filtered')



ax3 = nexttile([2,2])
yyaxis left
scatter(decimatedData.Time(loopIndexDS{3}),decimatedData.SBLcapped(loopIndexDS{3}),70,'filled')
ylim([0 15])
% ylabel('SBL (dB)')
yyaxis right
scatter(decimatedData.Time(loopIndexDS{3}),decimatedData.Snaps(loopIndexDS{3}),70,'g','filled','diamond')
ylabel('Snaps')
% title('Snaprate Unnaffected by Winds','40Hr Lowpass')
title('Snapping Shrimp Behavior')
% legend('SBL','Snaps')
hleg = legend('SBL','Snaps');
htitle = get(hleg,'Title');
set(htitle,'String','Lowpass-Filtered')


ax4 = nexttile([2,2])
yyaxis left
scatter(times(loopIndexFilt{3}),surfaceData.SBLcapped(loopIndexFilt{3}),70,'filled')
ylim([0 15])
ylabel('SBL (dB)')
yyaxis right
scatter(times(loopIndexFilt{3}),envData.Noise(loopIndexFilt{3}),70,'k','filled','^')
ylabel('Noise (mV)')
% title('','Raw Data')
% title('Raw Data','Noise Attenuation due to SBL')
% legend('SBL','Noise')
hleg = legend('SBL','Noise');
htitle = get(hleg,'Title');
set(htitle,'String','Raw Data')


ax5 = nexttile([2,2])
yyaxis left
scatter(times(loopIndexFilt{3}),surfaceData.SBLcapped(loopIndexFilt{3}),70,'filled')
ylim([0 15])
% ylabel('SBL (dB)')
yyaxis right
scatter(times(loopIndexFilt{3}),envData.HourlyDets(loopIndexFilt{3}),70,'r','filled','hexagram')
ylabel('Detections')
% title('','Raw Data')
% title('','Surface Attenuation Enabling Acoustic Telemetry')
% legend('SBL','Detections')
hleg = legend('SBL','Detections');
htitle = get(hleg,'Title');
set(htitle,'String','Raw Data')



ax6 = nexttile([2,2])
yyaxis left
scatter(times(loopIndexFilt{3}),surfaceData.SBLcapped(loopIndexFilt{3}),70,'filled')
ylim([0 15])
% ylabel('SBL (dB)')
yyaxis right
scatter(times(loopIndexFilt{3}),snapRateHourly.SnapCount(loopIndexFilt{3}),70,'g','filled','diamond')
ylabel('Snaps')
% title('','Raw Data')
% title('','Snaprate Unnaffected by Winds')
% legend('SBL','Snaps')
hleg = legend('SBL','Snaps');
htitle = get(hleg,'Title');
set(htitle,'String','Raw Data')

% Setting up stats for the 6-tile wind event plot.
%Tile 1 - Filtered/Decimated SBL vs Noise
[R,P] = corrcoef(decimatedData.SBLcapped(loopIndexDS{3}),decimatedData.Noise(loopIndexDS{3}))
Rsqrd = R(1,2)*R(1,2)

%Tile 2 - Filtered/Decimated SBL vs Detections
[R, P] = corr(decimatedData.Detections(loopIndexDS{3}),decimatedData.Winds(loopIndexDS{3}), 'Type', 'Spearman')
R*R
P

%Tile 3 - Filtered/Decimated SBL vs Snaps
[R,P] = corrcoef(decimatedData.SBLcapped(loopIndexDS{3}),decimatedData.Snaps(loopIndexDS{3}))
R(1,2)*R(1,2)

%Tile 4 - Raw SBL vs Noise
[R,P] = corrcoef(surfaceData.SBLcapped(loopIndexFilt{3}),envData.Noise(loopIndexFilt{3}))
R(1,2)*R(1,2)

%Tile 5 - Raw SBL vs Detections
[R, P] = corr(surfaceData.SBLcapped(loopIndexFilt{3}),envData.HourlyDets(loopIndexFilt{3}), 'Type', 'Spearman')
R*R
%Tile 6 - Raw SBL vs Snaps
[R,P] = corrcoef(surfaceData.SBLcapped(loopIndexFilt{3}),snapRateHourly.SnapCount(loopIndexFilt{3}))
R(1,2)*R(1,2)








