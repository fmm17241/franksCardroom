
function [receiverData,envData, windSpeedBins, windSpeedScenario, avgSnaps, averageDets] = snapRatePlotter(oneDrive, SnapCountTable, snapRateTables, hourSnaps, hourEnergy, hourAmp, minuteSnaps, minuteAmp, minuteEnergy)

buildReceiverData
close all
clearvars index

% 
%  %Run "snapRateAnalyzer" first
% fileLocation = ([oneDrive,'\acousticAnalysis']);
% % fileLocation = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis';
% [SnapCountTable, snapRateTables, PeakAmpTable, EnergyTable, hourSnaps, hourAmp, hourEnergy, minuteSnaps, minuteAmp, minuteEnergy] = snapRateAnalyzer(fileLocation)

%FM This is just for the March 2020 dataset, two small times had bad data and so I'm removing those hours.
% badTimes = [351;547];
% if hourSnaps{1}.Time(1,1) == '02-Mar-2020 23:00:00.000';
%     % hourSnaps{1}.SnapCount(351,:) = NaN;
%     hourSnaps{1}.SnapCount(badTimes,:) = NaN;
% end


figure()
tiledlayout(4,1,'tileSpacing','compact')

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
% legend({'Mid','High','Low'})
title('SnapRate')

ax4 = nexttile()
hold on
for i = 1:length(hourAmp)
    plot(minuteAmp{i}.Time,minuteAmp{i}.PeakAmp)
end
% legend({'Mid','High','Low'})
title('Peak Amplitude')



linkaxes([ax1,ax2,ax3,ax4],'x')

%%

for K = 1:length(hourSnaps)
    clear snapTimeRange envFit
    snapTimeRange = [hourSnaps{K}.Time(1); hourSnaps{K}.Time(end)];
    
    envFit = isbetween(receiverData{4}.DT, snapTimeRange(1),snapTimeRange(2));

    envData{K} = receiverData{4}(envFit,:);
    snaps{K} = hourSnaps{K}.SnapCount;
end

%
for month = 1:length(envData)
    for k = 1:2
        windSpeedBins{k,month}(1,:) = envData{month}.windSpd < 2 & envData{month}.daytime == (k-1) ;
        windSpeedBins{k,month}(2,:) = envData{month}.windSpd > 2 & envData{month}.windSpd < 4 & envData{month}.daytime == (k-1) ;
        windSpeedBins{k,month}(3,:) = envData{month}.windSpd > 4 & envData{month}.windSpd < 6 & envData{month}.daytime == (k-1) ;
        windSpeedBins{k,month}(4,:) = envData{month}.windSpd > 6 & envData{month}.windSpd < 8 & envData{month}.daytime == (k-1) ;
        windSpeedBins{k,month}(5,:) = envData{month}.windSpd > 8 & envData{month}.windSpd < 10 & envData{month}.daytime == (k-1) ;
        windSpeedBins{k,month}(6,:) = envData{month}.windSpd > 10 & envData{month}.windSpd < 12 & envData{month}.daytime == (k-1) ;
        windSpeedBins{k,month}(7,:) = envData{month}.windSpd > 12 & envData{month}.windSpd < 14 & envData{month}.daytime == (k-1) ;
        windSpeedBins{k,month}(8,:) = envData{month}.windSpd > 14 & envData{month}.daytime == (k-1) ;
    end
end

%%
for month = 1:length(envData)
    for k = 1:2
        for ii = 1:height(windSpeedBins{k,month})
            % windSpeedScenario{k,month}= envData(windSpeedBins{k,month}(ii,:),:);
            windSpeedScenario{k,month}= envData{1,month}(windSpeedBins{k,month}(ii,:),:);        

            averageDets{month}(k,ii) = mean(windSpeedScenario{k,month}.HourlyDets,'omitnan');
            noiseCompare{month}(k,ii) = mean(windSpeedScenario{k,month}.Noise,'omitnan');
            wavesCompare{month}(k,ii) = mean(windSpeedScenario{k,month}.waveHeight,'omitnan');
            tiltCompareWind{month}(k,ii) = mean(windSpeedScenario{k,month}.Tilt,'omitnan');
            stratCompareWind{month}(k,ii) = mean(windSpeedScenario{k,month}.bulkThermalStrat,'omitnan')        
        end
    end
end
%%
for month = 1:length(envData)
    for k = 1:height(windSpeedBins)
        for ii = 1:height(windSpeedBins{k,month})
            binnedSnaps{k,month}{ii}   =  snaps{month}(windSpeedBins{k,month}(ii,:));
        %
            avgSnaps{k,month}(ii)  = mean(binnedSnaps{k,month}{ii},'omitNan')
        end
    end
end


% 
% %Day Confidence Intervals
% for k = 1:length(binnedSnaps)
%     %Finding standard deviations/CIs of values
%     SEM = std(binnedSnaps{1,k}(:),'omitnan')/sqrt(length(binnedSnaps{1,k}));  
%     ts = tinv([0.025  0.975],length(binnedSnaps{1,k})-1);  
%     CIdayNoise(k,:) = mean(binnedSnaps{1,k},'all','omitnan') + ts*SEM; 
% 
% end
% 
% 
% 
% %Day Confidence Intervals
% for ii = 1:height(binnedSnaps)
%     for k = 1:length(binnedSnaps)
%     %Finding standard deviations/CIs of values
%     SEM = std(binnedSnaps{ii,k}(:),'omitnan')/sqrt(length(binnedSnaps{ii,k}));  
%     ts = tinv([0.025  0.975],length(binnedSnaps{ii,k})-1);  
%     CIsnaps{ii}(k,:) = mean(binnedSnaps{i,k},'all','omitnan') + ts*SEM; 
%     end
% end



X = 0:2:14

for K = 1:length(avgSnaps)
    figure()
    tiledlayout(2,1)
    ax1 = nexttile()
    scatter(X,avgSnaps{2,K},'filled','r')
    ylabel('Hourly Snaps')
    title('Shrimp Activity vs Wind','Day')
    ax2 = nexttile()
    scatter(X,avgSnaps{1,K},'filled','b')
    ylabel('Hourly Snaps')
    xlabel('Windspeed (m/s)')
    title('','Night')
end

%%

figure()
scatter(X,avgSnaps{2,1},'filled','r')
ylabel('Hourly Snaps')
title('Shrimp Activity vs Wind, March','Day')
hold on
scatter(X,avgSnaps{1,1},'filled','b')
ylabel('Hourly Snaps')
xlabel('Windspeed (m/s)')


% 
% figure()
% hold on
% % ciplot(CIsunsetNoise(:,1),CIsunsetNoise(:,2),1:5,'k')
% ciplot(CIsnaps{1}(:,1),CIsnaps{1}(:,2),1:7,'b')
% ciplot(CIsnaps{2}(:,1),CIsnaps{2}(:,2),1:7,'r')
% xlabel('Seasons, 2020')
% ylabel('Average Noise (mV)')
% title('Average Noise By Time of Day and Season','95% Conf. Interval, 69 kHz')
% legend('Night','Day')






%mscohere()



