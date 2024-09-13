


buildReceiverData
close all
clearvars index



fileLocation = ([oneDrive,'\acousticAnalysis']);
% fileLocation = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis';
[SnapCountTable, snapRateTables, PeakAmpTable, EnergyTable, hourSnaps, hourAmp, hourEnergy, minuteSnaps, minuteAmp, minuteEnergy] = snapRateAnalyzer(fileLocation)

%FM This is just for the March 2020 dataset, two small times had bad data and so I'm removing those hours.

badTimes = [351;547];

if hourSnaps{1}.Time(1,1) == '02-Mar-2020 23:00:00.000';
    hourSnaps{1}.SnapCount(351,:) = NaN;
    hourSnaps{1}.SnapCount(547,:) = NaN;
end

%FM I'm removing approximate sunset from our dataset. It is a very strong
%biological cue so there will always be significant increases in shrimp
%activity, we want to focus on wind's effect not the sun and moon's.
hours = hour(hourSnaps{1}.Time);

%index
rowsToReplace = (hours ==23 | hours == 0 | hours == 11);
hourSnaps{1}.SnapCount(rowsToReplace) = NaN;



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


for k = 1:length(windSpeedBins)
    for ii = 1:height(windSpeedBins{1})
    snapCompare{k,ii}   =  snaps(windSpeedBins{k}(ii,:));
    %
    avgSnaps{k}(ii)  = mean(snapCompare{k,ii},'omitNan')
    end
end



%Day Confidence Intervals
for ii = 1:height(snapCompare)
    for k = 1:length(snapCompare)
    %Finding standard deviations/CIs of values
    SEM = std(snapCompare{ii,k}(:),'omitnan')/sqrt(length(snapCompare{ii,k}));  
    ts = tinv([0.025  0.975],length(snapCompare{ii,k})-1);  
    CIsnaps{ii}(k,:) = mean(snapCompare{i,k},'all','omitnan') + ts*SEM; 
    end
end



X = 0:2:12


figure()
tiledlayout(2,1)
ax1 = nexttile()
scatter(X,avgSnaps{2},'filled','r')
ylabel('Hourly Snaps')
title('Shrimp Activity vs Wind, March','Day')
ax2 = nexttile()
scatter(X,avgSnaps{1},'filled','b')
ylabel('Hourly Snaps')
xlabel('Windspeed (m/s)')
title('','Night')


%%

figure()
scatter(X,avgSnaps{2},'filled','r')
ylabel('Hourly Snaps')
title('Shrimp Activity vs Wind, March','Day')
hold on
scatter(X,avgSnaps{1},'filled','b')
ylabel('Hourly Snaps')
xlabel('Windspeed (m/s)')



figure()
hold on
% ciplot(CIsunsetNoise(:,1),CIsunsetNoise(:,2),1:5,'k')
ciplot(CIsnaps{1}(:,1),CIsnaps{1}(:,2),1:7,'b')
ciplot(CIsnaps{2}(:,1),CIsnaps{2}(:,2),1:7,'r')
xlabel('Seasons, 2020')
ylabel('Average Noise (mV)')
title('Average Noise By Time of Day and Season','95% Conf. Interval, 69 kHz')
legend('Night','Day')






%mscohere()











