
% Load in data. Consolidating my figures so I don't lose them.


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
title('40Hr Lowpass','Noise Being Attenuated at the Surface')


ax3 = nexttile([2,1])
% scatter(surfaceData.WSPD,snapRateHourly.SnapCount,[],X1)
% hold on
scatter(decimatedData.Winds,decimatedData.Snaps,[],X2,'filled')
ylabel('Hourly Snaps')
xlabel('Windspeed (m/s)')
title('','Wind''s Effect on Snap Rate')
