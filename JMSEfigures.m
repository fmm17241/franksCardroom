
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

%




