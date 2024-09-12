


buildReceiverData
close all
clearvars index



fileLocation = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis';
[SnapCountTable, PeakAmpTable, EnergyTable, hourSnaps, hourAmp, hourEnergy, minuteSnaps, minuteAmp, minuteEnergy] = snapRateAnalyzer(fileLocation)


figure()
tiledlayout(3,1,'tileSpacing','compact')

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

% 
ax3 = nexttile()
hold on
for i = 1:length(hourSnaps)
plot(minuteSnaps{i}.Time,minuteSnaps{i}.SnapCount)
end
legend({'Mid','High','Low'})
title('SnapRate')

% ax4 = nexttile()
% hold on
% for i = 1:length(hourAmp)
%     plot(minuteAmp{i}.Time,minuteAmp{i}.PeakAmp)
% end
% legend({'Mid','High','Low'})
% title('Peak Amplitude')


% ax3 = nexttile()
% for k = 1:length(receiverData)
% plot(receiverData{k}.DT,receiverData{k}.HourlyDets,'r')
% end
% title('Detections')


linkaxes([ax1,ax2,ax3],'x')




%Okay focus on one month 9/12/24 work
subset = receiverData{4}(2480:3152,:);
timeTest = receiverData{4}.DT(2480:3152);
noise = receiverData{4}.Noise(2480:3152);
tideVelocity = receiverData{4}.crossShore(2480:3152);




windSpeedDay(1,:) = subset.windSpd < 1 & subset.daytime == 1 ;
windSpeedDay(2,:) = subset.windSpd > 1 & subset.windSpd < 2 & subset.daytime == 1 ;
windSpeedDay(3,:) = subset.windSpd > 2 & subset.windSpd < 3 & subset.daytime == 1 ;
windSpeedDay(4,:) = subset.windSpd > 3 & subset.windSpd < 4 & subset.daytime == 1 ;
windSpeedDay(5,:) = subset.windSpd > 4 & subset.windSpd < 5 & subset.daytime == 1 ;
windSpeedDay(6,:) = subset.windSpd > 5 & subset.windSpd < 6 & subset.daytime == 1 ;
windSpeedDay(7,:) = subset.windSpd > 6 & subset.windSpd < 7 & subset.daytime == 1 ;
windSpeedDay(8,:) = subset.windSpd > 7 & subset.windSpd < 8 & subset.daytime == 1 ;
windSpeedDay(9,:) = subset.windSpd > 8 & subset.windSpd < 9 & subset.daytime == 1 ;
windSpeedDay(10,:) = subset.windSpd > 9 & subset.windSpd < 10 & subset.daytime == 1 ;
windSpeedDay(11,:) = subset.windSpd > 10 & subset.windSpd < 11 & subset.daytime == 1 ;
windSpeedDay(12,:) = subset.windSpd > 11 & subset.windSpd < 12 & subset.daytime == 1 ;
windSpeedDay(13,:) = subset.windSpd > 12 & subset.daytime == 1 ;



windSpeedNight(1,:) = subset.windSpd < 1 & subset.daytime == 0 ;
windSpeedNight(2,:) = subset.windSpd > 1 & subset.windSpd < 2 & subset.daytime == 0 ;
windSpeedNight(3,:) = subset.windSpd > 2 & subset.windSpd < 3 & subset.daytime == 0 ;
windSpeedNight(4,:) = subset.windSpd > 3 & subset.windSpd < 4 & subset.daytime == 0 ;
windSpeedNight(5,:) = subset.windSpd > 4 & subset.windSpd < 5 & subset.daytime == 0 ;
windSpeedNight(6,:) = subset.windSpd > 5 & subset.windSpd < 6 & subset.daytime == 0 ;
windSpeedNight(7,:) = subset.windSpd > 6 & subset.windSpd < 7 & subset.daytime == 0 ;
windSpeedNight(8,:) = subset.windSpd > 7 & subset.windSpd < 8 & subset.daytime == 0 ;
windSpeedNight(9,:) = subset.windSpd > 8 & subset.windSpd < 9 & subset.daytime == 0 ;
windSpeedNight(10,:) = subset.windSpd > 9 & subset.windSpd < 10 & subset.daytime == 0 ;
windSpeedNight(11,:) = subset.windSpd > 10 & subset.windSpd < 11 & subset.daytime == 0 ;
windSpeedNight(12,:) = subset.windSpd > 11 & subset.windSpd < 12 & subset.daytime == 0 ;
windSpeedNight(13,:) = subset.windSpd > 12 & subset.daytime == 0 ;



%%

for k = 1:height(windSpeedDay)
    windSpeedScenarioAnnual{k}= receiverData(windSpeedBinsAnnual(k,:),:);
    averageWindSpeedAnnual(COUNT,k) = mean(windSpeedScenarioAnnual{1,k}.HourlyDets);
    noiseCompareAnnual(k) = mean(windSpeedScenarioAnnual{1,k}.Noise);
    wavesCompareAnnual(k) = mean(windSpeedScenarioAnnual{1,k}.waveHeight,'omitnan');
    tiltCompareWindAnnual(k) = mean(windSpeedScenarioAnnual{1,k}.Tilt);
    stratCompareWindAnnual(k) = mean(windSpeedScenarioAnnual{1,k}.bulkThermalStrat)
end
normalizedWSpeedAnnual(COUNT,:)  = averageWindSpeedAnnual(COUNT,:)/(max(averageWindSpeedAnnual(COUNT,:)));





