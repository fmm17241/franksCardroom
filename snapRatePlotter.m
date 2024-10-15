
function [receiverData, tides, snapRateHourly, snapRateMinute, envData, windSpeedBins, windSpeedScenario, avgSnaps, averageDets, surfaceData] = snapRatePlotter(oneDrive, snapRateHourly, snapRateMinute)

buildReceiverData
close all
clearvars index

tides = [crossShore; alongShore];

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
% for i = 1:length(hourSnaps)
plot(snapRateMinute.Time,snapRateMinute.SnapCount)
% end
% legend({'Mid','High','Low'})
title('SnapRate')

ax4 = nexttile()
hold on
% for i = 1:length(hourAmp)
plot(snapRateMinute.Time,snapRateMinute.PeakAmp)
% end
% legend({'Mid','High','Low'})
title('Peak Amplitude')



linkaxes([ax1,ax2,ax3,ax4],'x')

%%

% for K = 1:length(hourSnaps)
clear snapTimeRange envFit
snapTimeRange = [snapRateHourly.Time(1); snapRateHourly.Time(end)];


envFit = isbetween(receiverData{4}.DT, snapTimeRange(1),snapTimeRange(2));

envData = receiverData{4}(envFit,:);
snaps = snapRateHourly.SnapCount;

windFit = isbetween(windsAverage.time, snapTimeRange(1),snapTimeRange(2));
windData = windsAverage(windFit,:);

waveFit = isbetween(seas.time, snapTimeRange(1),snapTimeRange(2));
waveData = seas(waveFit,:);



surfaceData = synchronize(windData,waveData);



%This removes a few NaNs by interpolating from the hours next to it
snapRateHourly.SnapCount(isnan(snapRateHourly.SnapCount)) = interp1(snapRateHourly.Time(~isnan(snapRateHourly.SnapCount)),...
    snapRateHourly.SnapCount(~isnan(snapRateHourly.SnapCount)),snapRateHourly.Time(isnan(snapRateHourly.SnapCount))) ;

snapRateMinute.SnapCount(isnan(snapRateMinute.SnapCount)) = interp1(snapRateMinute.Time(~isnan(snapRateMinute.SnapCount)),...
    snapRateMinute.SnapCount(~isnan(snapRateMinute.SnapCount)),snapRateMinute.Time(isnan(snapRateMinute.SnapCount))) ;

envData.windSpd(isnan(envData.windSpd)) = interp1(envData.DT(~isnan(envData.windSpd)),...
    envData.windSpd(~isnan(envData.windSpd)),envData.DT(isnan(envData.windSpd))) ;

surfaceData.WSPD(isnan(surfaceData.WSPD))  = interp1(surfaceData.time(~isnan(surfaceData.WSPD)),...
    surfaceData.WSPD(~isnan(surfaceData.WSPD)),surfaceData.time(isnan(surfaceData.WSPD))) ;

surfaceData.waveHeight(isnan(surfaceData.waveHeight))  = interp1(surfaceData.time(~isnan(surfaceData.waveHeight)),...
    surfaceData.waveHeight(~isnan(surfaceData.waveHeight)),surfaceData.time(isnan(surfaceData.waveHeight))) ;

%%

% end

%
% for month = 1:length(envData)
for k = 1:2
    windSpeedBins{k}(1,:) = envData.windSpd < 2 & envData.daytime == (k-1) ;
    windSpeedBins{k}(2,:) = envData.windSpd > 2 & envData.windSpd < 4 & envData.daytime == (k-1) ;
    windSpeedBins{k}(3,:) = envData.windSpd > 4 & envData.windSpd < 6 & envData.daytime == (k-1) ;
    windSpeedBins{k}(4,:) = envData.windSpd > 6 & envData.windSpd < 8 & envData.daytime == (k-1) ;
    windSpeedBins{k}(5,:) = envData.windSpd > 8 & envData.windSpd < 10 & envData.daytime == (k-1) ;
    windSpeedBins{k}(6,:) = envData.windSpd > 10 & envData.windSpd < 12 & envData.daytime == (k-1) ;
    windSpeedBins{k}(7,:) = envData.windSpd > 12 & envData.windSpd < 14 & envData.daytime == (k-1) ;
    windSpeedBins{k}(8,:) = envData.windSpd > 14 & envData.daytime == (k-1) ;
end
% end

%%
% for month = 1:length(envData)
for k = 1:2
    for ii = 1:height(windSpeedBins{k})
        % windSpeedScenario{k}= envData(windSpeedBins{k}(ii,:),:);
        windSpeedScenario{k}= envData(windSpeedBins{k}(ii,:),:);        

        averageDets(k,ii) = mean(windSpeedScenario{k}.HourlyDets,'omitnan');
        noiseCompare(k,ii) = mean(windSpeedScenario{k}.Noise,'omitnan');
        wavesCompare(k,ii) = mean(windSpeedScenario{k}.waveHeight,'omitnan');
        tiltCompareWind(k,ii) = mean(windSpeedScenario{k}.Tilt,'omitnan');
        stratCompareWind(k,ii) = mean(windSpeedScenario{k}.bulkThermalStrat,'omitnan')        
    end
end
% end
%%
% for month = 1:length(envData)
for k = 1:length(windSpeedBins)
    for ii = 1:height(windSpeedBins{k})
        binnedSnaps{k}{ii}   =  snaps(windSpeedBins{k}(ii,:));
    %
        avgSnaps{k}(ii)  = mean(binnedSnaps{k}{ii},'omitNan')
    end
end
% end





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



% X = 0:2:14

% for K = 1:length(avgSnaps)
    % figure()
    % % tiledlayout(2,1)
    % ax1 = nexttile()
    % scatter(X,avgSnaps,'filled','r')
    % ylabel('Hourly Snaps')
    % title('Shrimp Activity vs Wind','Day')
    % % ax2 = nexttile()
    % % scatter(X,avgSnaps,'filled','b')
    % ylabel('Hourly Snaps')
    % xlabel('Windspeed (m/s)')
    % title('','Night')
% end

%%
% 
% figure()
% scatter(X,avgSnaps{2,1},'filled','r')
% ylabel('Hourly Snaps')
% title('Shrimp Activity vs Wind, March','Day')
% hold on
% scatter(X,avgSnaps{1,1},'filled','b')
% ylabel('Hourly Snaps')
% xlabel('Windspeed (m/s)')


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



