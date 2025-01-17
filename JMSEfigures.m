
% Load in data. Consolidating my figures so I don't lose them.

% Much simpler than what I was trying to do. Let me try below.
% Load in data.
% franksTalkingPoints
% addressingAutoCorrelation
% % Environmental data matched to the hourly snaps.
load envDataSpring
% % Full snaprate dataset
load snapRateDataSpring
% % Snaprate binned hourly
load snapRateHourlySpring
% % Snaprate binned per minute
load snapRateMinuteSpring
load surfaceDataSpring
load filteredData4Bin40HrLowSPRING.mat
load decimatedDataSpring
times = surfaceData.time;
disp(filteredData)

%%%
% RawVsFilteredComparisonFigure, 6 tiles, colored and trended



%Column 1 stats
[R, P] = corr(envData.Noise,snapRateHourly.SnapCount, 'Type', 'Spearman')
R*R
[R, P] = corr(decimatedData.Noise,decimatedData.Snaps, 'Type', 'Spearman')
R*R
%Column 2 stats
[R, P] = corr(surfaceData.SBLcapped,envData.Noise, 'Type', 'Spearman')
R*R
[R, P] = corr(decimatedData.SBLcapped,decimatedData.Noise, 'Type', 'Spearman')
R*R
%Column 3 stats
[R, P] = corr(surfaceData.WSPD,snapRateHourly.SnapCount, 'Type', 'Spearman')
R*R
[R, P] = corr(decimatedData.Winds,decimatedData.Snaps, 'Type', 'Spearman')
R*R


% Binning, hmgsvfbmgbf
binningSnaps
snapBinX = 750:750:6750;
%
binningSBL
SBLbinX  = 2:2:14;
%
binningWSPD
windBinX = 2:2:14;
%
% Values for color-changing, Raw and Snaps
X1 = 1:length(times);
X2 = 1:length(decimatedData.Snaps);


%Creates indexes for lines to show wind events. Gotta get creative.
index{1} = [75;116];
index{2} = [116;150]; 
index{3} = [150;189];
index{4} = [189;240];
index{5} = [360;384];
index{6} = [430;452];
index{7} = [513;535];
index{8} = [535;567];

midIndex=[97;132;170;219;371;441;525;548]

for K = 1:length(index)
    startSBLcapped(K) = mean(decimatedData.SBLcapped(index{K}));
    startNoise(K)     = mean(decimatedData.Noise(index{K}));
    startWinds(K)     = mean(decimatedData.Winds(index{K}));
    startSnaps(K)     = mean(decimatedData.Snaps(index{K}));

    endSBL(K)    = decimatedData.SBLcapped(midIndex(K));
    endNoise(K)  = decimatedData.Noise(midIndex(K));
    endWinds(K)  = decimatedData.Winds(midIndex(K));
    endSnaps(K)  = decimatedData.Snaps(midIndex(K));

end
for K = 1:length(index)
    %Piece it together
    %Snaps and Noise
    plot4Lines{K} = [startSnaps(K),startNoise(K); endSnaps(K),endNoise(K)]
    plot4Slopes{K} = (plot4Lines{K}(2,2)-plot4Lines{K}(1,2))/(plot4Lines{K}(2,1)-plot4Lines{K}(1,1));
    %SBL and Noise
    plot5Lines{K} = [startSBLcapped(K),startNoise(K); endSBL(K),endNoise(K)]
    plot5Slopes{K} = (plot5Lines{K}(2,2)-plot5Lines{K}(1,2))/(plot5Lines{K}(2,1)-plot5Lines{K}(1,1));
    %Winds and Snaps
    plot6Lines{K} = [startWinds(K),startSnaps(K); endWinds(K),endSnaps(K)]
    plot6Slopes{K} = (plot6Lines{K}(2,2)-plot6Lines{K}(1,2))/(plot6Lines{K}(2,1)-plot6Lines{K}(1,1));
end

%%%%%%%%%%%%%%%%
%%
figure()
Tiled = tiledlayout(4,3)
ax1 = nexttile([2,1])
% semilogx(snapRateHourly.SnapCount,logNoise)
scatter(snapRateHourly.SnapCount,envData.Noise,[],X1)
set(gca, 'XScale', 'log');
% xlabel('Snap Rate')
ylabel('HF Noise (mV)')
% title('','High-Frequency Noise Being Created')
xlim([500 7000])
ylim([400 780])
hold on
x = 750:750:6750;

% Scatter plot with error bars
errorbar(snapBinX, noiseVsSnaps, noiseSEM, 'k.', 'MarkerSize', 10, 'LineWidth', 1.5);
scatter(snapBinX, noiseVsSnaps, 'k', 'filled'); % Overlay points for clarity
customTicks = [1000, 2000, 4000, 6000]; % Tick positions
xticks(customTicks);              % Apply custom ticks
xticklabels(string(customTicks)); % Use the same values as labels
% scatter(snapRateHourly.SnapCount(loopIndexFilt{3}),envData.Noise(loopIndexFilt{3}),[],'r','filled')
% legend('Raw','40Hr Lowpass')
% Log this?

ax2 = nexttile([2,1])
% scatter(surfaceData.WSPD,envData.Noise)
scatter(surfaceData.SBLcapped,envData.Noise,[],X1)
hold on
% plot(SBLbinX,noiseVsSBL,'k','LineWidth',1.75)
% Scatter plot with error bars
errorbar(SBLbinX, noiseVsSBL, noiseSBLSEM, 'k.', 'MarkerSize', 10, 'LineWidth', 1.5);
scatter(SBLbinX, noiseVsSBL, 'k', 'filled'); % Overlay points for clarity
% scatter(surfaceData.SBLcapped(loopIndexFilt{3}),envData.Noise(loopIndexFilt{3}),[],'r','filled')
xlim([0 15])
ylim([400 780])
ylabel('HF Noise (mV)')
% xlabel('Surface Bubble Loss (dBs)')
% title('Gray''s Reef Soundscape, Spring 2020','Noise Being Attenuated at the Surface')


ax3 = nexttile([2,1])
% scatter(surfaceData.WSPD,snapRateHourly.SnapCount,[],X1)
scatter(surfaceData.SBLcapped,snapRateHourly.SnapCount,[],X1)
xlim([0 15])
ylim([0 6000])
hold on
% plot(windBinX,snapsVsWind,'k','LineWidth',1.75)
% Scatter plot with error bars
errorbar(windBinX, snapsVsWind, windSnapSEM, 'k.', 'MarkerSize', 10, 'LineWidth', 1.5);
scatter(windBinX, snapsVsWind, 'k', 'filled'); % Overlay points for clarity
% scatter(surfaceData.WSPD(loopIndexFilt{3}),snapRateHourly.SnapCount(loopIndexFilt{3}),[],'r','filled')
ylabel('Snap Rate')
% xlabel('Windspeed (m/s)')
% title('','Wind''s Effect on Snap Rate')

ax4 = nexttile([2,1])
% scatter(snapRateHourly.SnapCount,envData.Noise,[],X1)
% hold on
scatter(decimatedData.Snaps,decimatedData.Noise,[],X2,'filled','MarkerFaceAlpha',0.45,'MarkerEdgeAlpha',0.45)
hold on
for K = 1:length(plot4Lines)
    plot(plot4Lines{K}(:,1),plot4Lines{K}(:,2),'k','LineWidth', 2)
end
set(gca, 'XScale', 'log');
xlim([500 7000])
ylim([400 780])
xlabel('Snap Rate')
ylabel('HF Noise (mV)')
customTicks = [1000, 2000, 4000, 6000]; % Tick positions
xticks(customTicks);              % Apply custom ticks
xticklabels(string(customTicks)); % Use the same values as labels


% title('','High-Frequency Noise Being Created')
% legend('Raw','40Hr Lowpass')


ax5 = nexttile([2,1])
% scatter(surfaceData.WSPD,envData.Noise)
% scatter(surfaceData.SBLcapped,envData.Noise,[],X1)
% hold on
% scatter(filteredData.Winds,filteredData.Noise)
scatter(decimatedData.SBLcapped,decimatedData.Noise,[],X2,'filled','MarkerFaceAlpha',0.45,'MarkerEdgeAlpha',0.45)
xlim([0 15])
ylim([400 780])
hold on
hold on
for K = 1:length(plot5Lines)
    plot(plot5Lines{K}(:,1),plot5Lines{K}(:,2),'k','LineWidth', 2)
end
ylabel('HF Noise (mV)')
xlabel('Surface Bubble Loss (dBs)')
% title('40Hr Lowpass-Filtered','Noise Being Attenuated at the Surface')

% add lines to this plot showing some wind events

ax6 = nexttile([2,1])
% scatter(surfaceData.WSPD,snapRateHourly.SnapCount,[],X1)
% hold on
scatter(decimatedData.Winds,decimatedData.Snaps,[],X2,'filled','MarkerFaceAlpha',0.45,'MarkerEdgeAlpha',0.45)
hold on
for K = 1:length(plot6Lines)
    plot(plot6Lines{K}(:,1),plot6Lines{K}(:,2),'k','LineWidth', 2)
end
ylim([0 6000])
xlim([0 15])
ylabel('Snap Rate')
xlabel('Windspeed (m/s)')
% title('','Wind''s Effect on Snap Rate')



% Column 1
[R,P] = corrcoef(envData.Noise,snapRateHourly.SnapCount)
RSqrd = R(1,2)*R(1,2)
[R,P] = corrcoef(decimatedData.Noise,decimatedData.Snaps)
RSqrd = R(1,2)*R(1,2)
% Testing non-linear
[R, P] = corr(decimatedData.Noise,decimatedData.Snaps, 'Type', 'Spearman')
R*R


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
% Feb 03 11:00 to Mar 10 03:00
figIndex = 24:238;

figure()
TT = tiledlayout(3,4)
ax3 = nexttile([1,4])
yyaxis left
plot(decimatedData.Time(figIndex),decimatedData.SBLcapped(figIndex),'b--','LineWidth',3)
ylim([0 14])
ylabel('SBL (dB)')

yyaxis right
plot(decimatedData.Time(figIndex),decimatedData.Snaps(figIndex),'g','LineWidth',3)
ylim([800 2000])
ylabel('Snap Rate')
legend('SBL','Snaps')
title('Snapping Shrimp Activity During High Wind Periods','SURTASSTN20, lowpass filter')


ax2 = nexttile([1,4])
yyaxis left
plot(decimatedData.Time(figIndex),decimatedData.SBLcapped(figIndex),'b--','LineWidth',3)
ylim([0 14])
ylabel('SBL (dB)')

yyaxis right
plot(decimatedData.Time(figIndex),decimatedData.Noise(figIndex),'k','LineWidth',3)
ylim([525 675])
ylabel('HF Noise (mV)')
legend('SBL','Noise')
title('High-Frequency Noise During High Wind Periods','SURTASSTN20, 50-90 kHz, lowpass filter')



%FM Creating efficiency from Detection rates
efficiency = decimatedData.Detections(figIndex)/6;


ax1 = nexttile([1,4])
yyaxis left
% plot(times(92:948),filteredData.SBLcapped(92:948),'b--','LineWidth',2)
plot(decimatedData.Time(figIndex),decimatedData.SBLcapped(figIndex),'b--','LineWidth',3)
ylim([0 14])
ylabel('SBL (dB)')
title('Telemetry Success Rates During High Wind Periods','SURTASSTN20 to STSNEW1, 440 meters, lowpass filter')

yyaxis right
plot(decimatedData.Time(figIndex),efficiency,'r','LineWidth',3)
ylim([0 0.28])
ylabel('Det. Efficiency (%)')

legend('SBL','Det. Efficiency')

linkaxes([ax1,ax2,ax3],'x')
ax1.YAxis(2).Color = 'k';
ax2.YAxis(2).Color = 'k';
ax3.YAxis(2).Color = 'k';

%Tile 1 - FILT SBL vs FILT Snaps
[R,P] = corrcoef(decimatedData.SBLcapped(figIndex),decimatedData.Snaps(figIndex))
R(1,2)*R(1,2)

%Tile 2 - FILT SBL vs FILT Noise
[R,P] = corrcoef(decimatedData.SBLcapped(figIndex),decimatedData.Noise(figIndex))
R(1,2)*R(1,2)

%Tile 1 - FILT SBL vs FILT Detections
[R, P] = corr(decimatedData.SBLcapped(figIndex),decimatedData.Detections(figIndex), 'Type', 'Spearman')
R*R

testf = decimatedData.Time(loopIndexDS{3})

%%
% "FullStoryTilesHorizontal"

%Feb 18 19:00 - Feb 24 15:00
loopIndexFilt{3} = 461:601;
loopIndexDS{3} = 116:151;

figure()
TTTT = tiledlayout(4,6)
ax1 = nexttile([2,2])
yyaxis left
scatter(times(loopIndexFilt{3}),surfaceData.SBLcapped(loopIndexFilt{3}),70,'filled')
ylim([0 15])
ylabel('SBL (dB)')
yyaxis right
scatter(times(loopIndexFilt{3}),envData.Noise(loopIndexFilt{3}),70,'k','filled','^')
ylabel('Noise (mV)')
ylim([500 725])
% title('','Raw Data')
% title('Raw Data','Noise Attenuation due to SBL')
% legend('SBL','Noise')
% hleg = legend('SBL','Noise');
% htitle = get(hleg,'Title');
% set(htitle,'String','Raw Data')

ax2 = nexttile([2,2])
yyaxis left
scatter(times(loopIndexFilt{3}),surfaceData.SBLcapped(loopIndexFilt{3}),70,'filled')
ylim([0 15])
% ylabel('SBL (dB)')
yyaxis right
scatter(times(loopIndexFilt{3}),envData.HourlyDets(loopIndexFilt{3}),70,[0.7,0,0],'filled','hexagram')
ylabel('Detections')
ylim([0 4])
% title('','Raw Data')
% title('','Surface Attenuation Enabling Acoustic Telemetry')
% legend('SBL','Detections')
% hleg = legend('SBL','Detections');
% htitle = get(hleg,'Title');
% set(htitle,'String','Raw Data')
timeNaN = times(loopIndexFilt{3}(1:3))
fillNaN = [NaN;NaN;NaN]

ax3 = nexttile([2,2])
yyaxis left
hold on
scatter(times(loopIndexFilt{3}),surfaceData.SBLcapped(loopIndexFilt{3}),70,'filled')
scatter(timeNaN,fillNaN,130,'k','filled','^')
scatter(timeNaN,fillNaN,130,[0.7,0,0],'filled','hexagram')
ylim([0 15])
% ylabel('SBL (dB)')
yyaxis right
scatter(times(loopIndexFilt{3}),snapRateHourly.SnapCount(loopIndexFilt{3}),130,[0,0.4,0],'filled','diamond')
ylabel('Snaps')
ylim([200 3500])
% title('','Raw Data')
% title('','Snaprate Unnaffected by Winds')
% legend('SBL','Snaps')
hleg = legend('SBL','Noise','Detections','Snaps');
htitle = get(hleg,'Title');
set(htitle,'String','Raw Data')

ax4 = nexttile([2,2])
yyaxis left
% scatter(decimatedData.Time(loopIndexDS{3}),decimatedData.SBLcapped(loopIndexDS{3}),70,'filled')
plot(decimatedData.Time(loopIndexDS{3}),decimatedData.SBLcapped(loopIndexDS{3}),'b','LineWidth',3)
ylim([0 15])
ylabel('SBL (dB)')
yyaxis right
% scatter(decimatedData.Time(loopIndexDS{3}),decimatedData.Noise(loopIndexDS{3}),70,'k','filled','^')
plot(decimatedData.Time(loopIndexDS{3}),decimatedData.Noise(loopIndexDS{3}),'k','LineWidth',3)
ylabel('Noise (mV)')
ylim([500 725])
% legend('SBL','Noise')
% hleg = legend('SBL','Noise');
% htitle = get(hleg,'Title');
% set(htitle,'String','Lowpass-Filtered')


ax5 = nexttile([2,2])
yyaxis left
plot(decimatedData.Time(loopIndexDS{3}),decimatedData.SBLcapped(loopIndexDS{3}),'b','LineWidth',3)
ylim([0 15])
% ylabel('SBL (dB)')
yyaxis right
plot(decimatedData.Time(loopIndexDS{3}),decimatedData.Detections(loopIndexDS{3}),'Color',[0.7,0,0],'LineWidth',3)
ylabel('Detections')
ylim([0 4])
% legend('SBL','Detections')
% hleg = legend('SBL','Detections');
% htitle = get(hleg,'Title');
% set(htitle,'String','Lowpass-Filtered')



ax6 = nexttile([2,2])
yyaxis left
plot(decimatedData.Time(loopIndexDS{3}),decimatedData.SBLcapped(loopIndexDS{3}),'b','LineWidth',3)
hold on
plot(timeNaN,fillNaN,'k-','LineWidth',3)
plot(timeNaN,fillNaN,'-','Color',[0.7,0,0],'LineWidth',3)
ylim([0 15])
% ylabel('SBL (dB)')
yyaxis right
plot(decimatedData.Time(loopIndexDS{3}),decimatedData.Snaps(loopIndexDS{3}),'Color',[0,0.4,0],'LineWidth',3)
ylabel('Snaps')
ylim([200 3500])
% legend('SBL','Snaps')
hleg = legend('SBL','Noise','Detections','Snaps');
htitle = get(hleg,'Title');
set(htitle,'String','Lowpass-Filtered')

ax1.YAxis(2).Color = 'k';
ax2.YAxis(2).Color = [0.7,0,0];
ax3.YAxis(2).Color = [0,0.4,0];
ax4.YAxis(2).Color = 'k';
ax5.YAxis(2).Color = [0.7,0,0];
ax6.YAxis(2).Color = [0,0.4,0];


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

%%
%%Stats Table
[R, P] = corr(decimatedData.SBLcapped,decimatedData.Detections, 'Type', 'Spearman')
R*R
[R, P] = corr(surfaceData.SBLcapped,envData.HourlyDets, 'Type', 'Spearman')
R*R

[R, P] = corr(decimatedData.Snaps,decimatedData.Detections, 'Type', 'Spearman')
R*R
[R, P] = corr(snapRateHourly.SnapCount,envData.HourlyDets, 'Type', 'Spearman')
R*R

[R, P] = corr(decimatedData.BulkStrat,decimatedData.Detections, 'Type', 'Spearman')
R*R
[R, P] = corr(envData.bulkThermalStrat,envData.HourlyDets, 'Type', 'Spearman')
R*R

%%
% April Case Study
% Find index
aprilIndex = 1985:2146;

[R, P] = corr(envData.Noise(aprilIndex),envData.HourlyDets(aprilIndex), 'Type', 'Spearman')
R*R

%
febIndex = 239:526;
[R, P] = corr(envData.Noise(febIndex),envData.HourlyDets(febIndex), 'Type', 'Spearman')
R*R
%
marIndex = 820:1120;
[R, P] = corr(envData.Noise(febIndex),envData.HourlyDets(febIndex), 'Type', 'Spearman')
R*R

%%
%DailySnapDetections
%Wind Event #1
ev1Index = 1139:1280;
[R, P] = corr(envData.Noise(ev1Index),envData.HourlyDets(ev1Index), 'Type', 'Spearman')
R*R

%Wind Event #2
ev2Index = 632:791;
[R, P] = corr(envData.Noise(ev2Index),envData.HourlyDets(ev2Index), 'Type', 'Spearman')
R*R
%Wind Event #3
ev3Index = 1402:1550;
[R, P] = corr(envData.Noise(ev3Index),envData.HourlyDets(ev3Index), 'Type', 'Spearman')
R*R

%%
%Shrimp Activity Shaded
%
[R,P] = corrcoef(decimatedData.BottomTemp,decimatedData.Snaps)
R(1,2)*R(1,2)

% Load Fall data
[R,P] = corrcoef(decimatedData.BottomTemp,decimatedData.Snaps)
R(1,2)*R(1,2)









