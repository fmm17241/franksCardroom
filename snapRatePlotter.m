


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
snaps = hourSnaps{1}.SnapCount;


%
for k = 1:2
    windSpeedBins{k}(1,:) = subset.windSpd < 2 & subset.daytime == (k-1) ;
    windSpeedBins{k}(2,:) = subset.windSpd > 2 & subset.windSpd < 4 & subset.daytime == (k-1) ;
    windSpeedBins{k}(3,:) = subset.windSpd > 4 & subset.windSpd < 6 & subset.daytime == (k-1) ;
    windSpeedBins{k}(4,:) = subset.windSpd > 6 & subset.windSpd < 8 & subset.daytime == (k-1) ;
    windSpeedBins{k}(5,:) = subset.windSpd > 8 & subset.windSpd < 10 & subset.daytime == (k-1) ;
    windSpeedBins{k}(6,:) = subset.windSpd > 10 & subset.windSpd < 12 & subset.daytime == (k-1) ;
    windSpeedBins{k}(7,:) = subset.windSpd > 12 & subset.daytime == (k-1) ;
end

%

%%

for k = 1:height(windSpeedBins)
    for ii = 1:height(windSpeedBins{1})
        windSpeedScenario{k}= subset(windSpeedBins{k}(ii,:),:);
    
        averageDets(k,ii) = mean(windSpeedScenario{1,k}.HourlyDets);
        noiseCompareAnnual(k) = mean(windSpeedScenario{1,k}.Noise);
        wavesCompareAnnual(k) = mean(windSpeedScenario{1,k}.waveHeight,'omitnan');
        tiltCompareWindAnnual(k) = mean(windSpeedScenario{1,k}.Tilt);
        stratCompareWindAnnual(k) = mean(windSpeedScenario{1,k}.bulkThermalStrat)

        
    end
end


for k = 1:height(windSpeedBins)
    for ii = 1:height(windSpeedBins{1})
    snapCompare{k,ii}   =  snaps(windSpeedBins{k}(ii,:));
    %
    avgSnaps{k}(ii)  = mean(snapCompare{k,ii})
    end
end



%Day Confidence Intervals
for k = 1:length(snapCompare)
    %Finding standard deviations/CIs of values
    SEM = std(snapCompare{k,1}(:),'omitnan')/sqrt(length(snapCompare{k,1}));  
    ts = tinv([0.025  0.975],length(snapCompare{k,1})-1);  
    CIdayNoise(k,:) = mean(snapCompare{k,1},'all','omitnan') + ts*SEM; 

end






X = 1:length(avgSnaps{1});

figure()
scatter(X,avgSnaps{1},'filled','r')
hold on
scatter(X,avgSnaps{2},'filled','b')
legend('Day','Night')






