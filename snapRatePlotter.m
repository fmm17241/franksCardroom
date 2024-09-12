


buildReceiverData
close all
clearvars index



fileLocation = pwd;
[SnapCountTable, PeakAmpTable, EnergyTable, hourSnaps, minuteSnaps, minuteAmp, minuteEnergy] = snapRateAnalyzer(fileLocation)


figure()
tiledlayout(5,1,'tileSpacing','compact')

% ax1 = nexttile()
% hold on
% for k = 1:length(receiverData)
% plot(receiverData{k}.DT,receiverData{k}.Noise)

ax1 = nexttile()
hold on
plot(receiverData{4}.DT,receiverData{4}.Noise,'k')
title('Noise')

ax2 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd)
hold on
title('Windspeed')

ax3 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.crossShore)
hold on
yline(0)
title('CrossShore Tide')

% 
ax4 = nexttile()
hold on
for i = 1:length(hourSnaps)
plot(minuteSnaps{i}.Time,minuteSnaps{i}.SnapCount)
end
legend({'Mid','High','Low'})
title('SnapRate')

ax5 = nexttile()
hold on
for i = 1:length(hourAmp)
    plot(minuteAmp{i}.Time,minuteAmp{i}.PeakAmp)
end
legend({'Mid','High','Low'})
title('Peak Amplitude')


% ax3 = nexttile()
% for k = 1:length(receiverData)
% plot(receiverData{k}.DT,receiverData{k}.HourlyDets,'r')
% end
% title('Detections')


linkaxes([ax1,ax2,ax3,ax4, ax5],'x')
