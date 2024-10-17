
function [receiverData, tides, snapRateHourly, snapRateMinute, envData, windSpeedBins, windSpeedScenario, avgSnaps, averageDets, surfaceData] = snapRatePlotter(oneDrive, snapRateHourly, snapRateMinute)

buildReceiverData
close all
clearvars index

tides = [crossShore; alongShore]';

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

tideFit = isbetween(tideDT, snapTimeRange(1),snapTimeRange(2));
tideData = timetable(tideDT(tideFit,:),tides(tideFit,1),tides(tideFit,2));
tideData.Properties.VariableNames = [{'crossShore'},{'alongShore'}];

windFit = isbetween(windsAverage.time, snapTimeRange(1),snapTimeRange(2));
windData = windsAverage(windFit,:);

waveFit = isbetween(seas.time, snapTimeRange(1),snapTimeRange(2));
waveData = seas(waveFit,:);



surfaceData = synchronize(windData,waveData,tideData);



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

surfaceData.WDIR(isnan(surfaceData.WDIR))  = interp1(surfaceData.time(~isnan(surfaceData.WDIR)),...
    surfaceData.WDIR(~isnan(surfaceData.WDIR)),surfaceData.time(isnan(surfaceData.WDIR))) ;


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



