


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
windSpeeds = receiverData{4}.windSpd(2480:3152);
timeTest = receiverData{4}.DT(2480:3152);
noise = receiverData{4}.Noise(2480:3152);
tideVelocity = receiverData{4}.crossShore(2480:3152);

figure()
scatter(windSpeeds,hourSnaps{1}.SnapCount)



for COUNT = 1:length(receiverData)
    windSpeedBins{COUNT}(1,:) = receiverData{COUNT}.windSpd < 1 ;
    windSpeedBins{COUNT}(2,:) = receiverData{COUNT}.windSpd > 1 & receiverData{COUNT}.windSpd < 2 ;
    windSpeedBins{COUNT}(3,:) = receiverData{COUNT}.windSpd > 2 & receiverData{COUNT}.windSpd < 3 ;
    windSpeedBins{COUNT}(4,:) = receiverData{COUNT}.windSpd > 3 & receiverData{COUNT}.windSpd < 4 ;
    windSpeedBins{COUNT}(5,:) = receiverData{COUNT}.windSpd > 4 & receiverData{COUNT}.windSpd < 5 ;
    windSpeedBins{COUNT}(6,:) = receiverData{COUNT}.windSpd > 5 & receiverData{COUNT}.windSpd < 6 ;
    windSpeedBins{COUNT}(7,:) = receiverData{COUNT}.windSpd > 6 & receiverData{COUNT}.windSpd < 7 ;
    windSpeedBins{COUNT}(8,:) = receiverData{COUNT}.windSpd > 7 & receiverData{COUNT}.windSpd < 8 ;
    windSpeedBins{COUNT}(9,:) = receiverData{COUNT}.windSpd > 8 & receiverData{COUNT}.windSpd < 9 ;
    windSpeedBins{COUNT}(10,:) = receiverData{COUNT}.windSpd > 9 & receiverData{COUNT}.windSpd < 10 ;
    windSpeedBins{COUNT}(11,:) = receiverData{COUNT}.windSpd > 10 & receiverData{COUNT}.windSpd < 11 ;
    windSpeedBins{COUNT}(12,:) = receiverData{COUNT}.windSpd > 11 & receiverData{COUNT}.windSpd < 12 ;
    windSpeedBins{COUNT}(13,:) = receiverData{COUNT}.windSpd > 12 ;
end








