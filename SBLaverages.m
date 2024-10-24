%%
%Frank's calculating averages so its less squiggly. 
%just load it
fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

%%
% % Load in saved data
% % Environmental data matched to the hourly snaps.
load envDataSpring
% % Full snaprate dataset
load snapRateDataSpring
% % Snaprate binned hourly
load snapRateHourlySpring
% % Snaprate binned per minute
load snapRateMinuteSpring
load surfaceDataSpring
load filteredData4Bin40HrLowSPRING

times = surfaceData.time;

%%

% 
% load envDataFall
% % Full snaprate dataset
% load snapRateDataFall
% % Snaprate binned hourly
% load snapRateHourlyFall
% % Snaprate binned per minute
% load snapRateMinuteFall
% load surfaceDataFall
% load filteredData4Bin40HrLowFALLpruned.mat
% 
% % %This is Frank pruning from Sept-Feb to Sept-Dec.
% if length(surfaceData.time) == 3308
%     surfaceData = surfaceData(1:2078,:);
%     snapRateHourly = snapRateHourly(1:2078,:);
% end
% times = surfaceData.time;

%%

windSpeedBins(1,:) = surfaceData.WSPD < 1;
windSpeedBins(2,:) = surfaceData.WSPD > 1 & surfaceData.WSPD < 2 ;
windSpeedBins(3,:) = surfaceData.WSPD > 2 & surfaceData.WSPD < 3 ;
windSpeedBins(4,:) = surfaceData.WSPD > 3 & surfaceData.WSPD < 4 ;
windSpeedBins(5,:) = surfaceData.WSPD > 4 & surfaceData.WSPD < 5 ;
windSpeedBins(6,:) = surfaceData.WSPD > 5 & surfaceData.WSPD < 6 ;
windSpeedBins(7,:) = surfaceData.WSPD > 6 & surfaceData.WSPD < 7 ;
windSpeedBins(8,:) = surfaceData.WSPD > 7 & surfaceData.WSPD < 8 ;
windSpeedBins(9,:) = surfaceData.WSPD > 8 & surfaceData.WSPD < 9 ;
windSpeedBins(10,:) = surfaceData.WSPD > 9 & surfaceData.WSPD < 10 ;
windSpeedBins(11,:) = surfaceData.WSPD > 10 & surfaceData.WSPD < 11 ;
windSpeedBins(12,:) = surfaceData.WSPD > 11 & surfaceData.WSPD < 12 ;
windSpeedBins(13,:) = surfaceData.WSPD > 12 & surfaceData.WSPD < 13 ;
windSpeedBins(14,:) = surfaceData.WSPD > 13 & surfaceData.WSPD < 14 ;
windSpeedBins(15,:) = surfaceData.WSPD > 14;


windSpeedFiltBins(1,:) = filteredData.Winds < 1;
windSpeedFiltBins(2,:) = filteredData.Winds > 1 & filteredData.Winds < 2 ;
windSpeedFiltBins(3,:) = filteredData.Winds > 2 & filteredData.Winds < 3 ;
windSpeedFiltBins(4,:) = filteredData.Winds > 3 & filteredData.Winds < 4 ;
windSpeedFiltBins(5,:) = filteredData.Winds > 4 & filteredData.Winds < 5 ;
windSpeedFiltBins(6,:) = filteredData.Winds > 5 & filteredData.Winds < 6 ;
windSpeedFiltBins(7,:) = filteredData.Winds > 6 & filteredData.Winds < 7 ;
windSpeedFiltBins(8,:) = filteredData.Winds > 7 & filteredData.Winds < 8 ;
windSpeedFiltBins(9,:) = filteredData.Winds > 8 & filteredData.Winds < 9 ;
windSpeedFiltBins(10,:) = filteredData.Winds > 9 & filteredData.Winds < 10 ;
windSpeedFiltBins(11,:) = filteredData.Winds > 10 & filteredData.Winds < 11 ;
windSpeedFiltBins(12,:) = filteredData.Winds > 11 & filteredData.Winds < 12 ;
windSpeedFiltBins(13,:) = filteredData.Winds > 12 & filteredData.Winds < 13 ;
windSpeedFiltBins(14,:) = filteredData.Winds > 13 & filteredData.Winds < 14 ;
windSpeedFiltBins(15,:) = filteredData.Winds > 14;
% windSpeedFiltBins(1,:) = filteredData.Winds < 2;
% windSpeedFiltBins(2,:) = filteredData.Winds > 2 & filteredData.Winds < 4 ;
% windSpeedFiltBins(3,:) = filteredData.Winds > 4 & filteredData.Winds < 6 ;
% windSpeedFiltBins(4,:) = filteredData.Winds > 6 & filteredData.Winds < 8 ;
% windSpeedFiltBins(5,:) = filteredData.Winds > 8 & filteredData.Winds < 10 ;
% windSpeedFiltBins(6,:) = filteredData.Winds > 10 & filteredData.Winds < 12 ;
% windSpeedFiltBins(7,:) = filteredData.Winds > 12 & filteredData.Winds < 14 ;
% windSpeedFiltBins(8,:) = filteredData.Winds > 14;


%%
for k = 1:height(windSpeedBins)
    windSpeedScenario{k}= surfaceData(windSpeedBins(k,:),:);
    averageSBL(1,k) = mean(windSpeedScenario{1,k}.SBLcapped);
    averageSST(1,k) = mean(windSpeedScenario{1,k}.SST);
    averageWaves(1,k) = mean(windSpeedScenario{1,k}.waveHeight);

    SnapWindScenario{k} = snapRateHourly(windSpeedBins(k,:),:);
    averageSnaps(1,k) = mean(SnapWindScenario{1,k}.SnapCount);

    windEnviroScenario{k}= envData(windSpeedBins(k,:),:);
    averageDets(1,k)  = mean(windEnviroScenario{1,k}.HourlyDets);
    averageNoise(1,k) = mean(windEnviroScenario{1,k}.Noise);

end
%%
%Filt averages.
for k = 1:height(windSpeedFiltBins)
    windSpeedFiltScenario{k}= surfaceData(windSpeedFiltBins(k,:),:);
    filtAverageSBL(1,k) = mean(windSpeedFiltScenario{1,k}.SBLcapped);
    filtAverageSST(1,k) = mean(windSpeedFiltScenario{1,k}.SST);
    filtAverageWaves(1,k) = mean(windSpeedFiltScenario{1,k}.waveHeight);

    SnapWindFiltScenario{k} = snapRateHourly(windSpeedFiltBins(k,:),:);
    filtAverageSnaps(1,k) = mean(SnapWindFiltScenario{1,k}.SnapCount);

    windEnviroFiltScenario{k}= envData(windSpeedFiltBins(k,:),:);
    averageDets(1,k)  = mean(windEnviroFiltScenario{1,k}.HourlyDets);
    averageNoise(1,k) = mean(windEnviroFiltScenario{1,k}.Noise);
end

%%

% Surface Bubble Loss ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(windSpeedScenario{1,k}.SBLcapped(:),'omitnan')/sqrt(length(windSpeedScenario{1,k}.SBLcapped));  
    ts = tinv([0.025  0.975],length(windSpeedScenario{1,k}.SBLcapped)-1);  
    ConfIntSBL(k,:) = mean(windSpeedScenario{1,k}.SBLcapped,'all','omitnan') + ts*SEM; 
end

% Seasurface Temperature ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(windSpeedScenario{1,k}.SST(:),'omitnan')/sqrt(length(windSpeedScenario{1,k}.SST));  
    ts = tinv([0.025  0.975],length(windSpeedScenario{1,k}.SST)-1);  
    ConfIntSST(k,:) = mean(windSpeedScenario{1,k}.SST,'all','omitnan') + ts*SEM; 
end

% Waveheight ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(windSpeedScenario{1,k}.waveHeight(:),'omitnan')/sqrt(length(windSpeedScenario{1,k}.waveHeight));  
    ts = tinv([0.025  0.975],length(windSpeedScenario{1,k}.waveHeight)-1);  
    ConfIntWaves(k,:) = mean(windSpeedScenario{1,k}.waveHeight,'all','omitnan') + ts*SEM; 
end

% Snaprate ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(SnapWindScenario{1,k}.SnapCount(:),'omitnan')/sqrt(length(SnapWindScenario{1,k}.SnapCount));  
    ts = tinv([0.025  0.975],length(SnapWindScenario{1,k}.SnapCount)-1);  
    ConfIntSnaps(k,:) = mean(SnapWindScenario{1,k}.SnapCount,'all','omitnan') + ts*SEM; 
end

% Noise ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(windEnviroScenario{1,k}.Noise(:),'omitnan')/sqrt(length(windEnviroScenario{1,k}.Noise));  
    ts = tinv([0.025  0.975],length(windEnviroScenario{1,k}.Noise)-1);  
    ConfIntNoise(k,:) = mean(windEnviroScenario{1,k}.Noise,'all','omitnan') + ts*SEM; 
end


%%
% Confidence intervals for the filtered data
% Surface Bubble Loss ConfInt
for k = 1:length(filtAverageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(windSpeedFiltScenario{1,k}.SBLcapped(:),'omitnan')/sqrt(length(windSpeedFiltScenario{1,k}.SBLcapped));  
    ts = tinv([0.025  0.975],length(windSpeedFiltScenario{1,k}.SBLcapped)-1);  
    ConfIntSBLfiltered(k,:) = mean(windSpeedFiltScenario{1,k}.SBLcapped,'all','omitnan') + ts*SEM; 
end

% Seasurface Temperature ConfInt
for k = 1:length(filtAverageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(windSpeedFiltScenario{1,k}.SST(:),'omitnan')/sqrt(length(windSpeedFiltScenario{1,k}.SST));  
    ts = tinv([0.025  0.975],length(windSpeedFiltScenario{1,k}.SST)-1);  
    ConfIntSSTfiltered(k,:) = mean(windSpeedFiltScenario{1,k}.SST,'all','omitnan') + ts*SEM; 
end

% Waveheight ConfInt
for k = 1:length(filtAverageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(windSpeedFiltScenario{1,k}.waveHeight(:),'omitnan')/sqrt(length(windSpeedFiltScenario{1,k}.waveHeight));  
    ts = tinv([0.025  0.975],length(windSpeedFiltScenario{1,k}.waveHeight)-1);  
    ConfIntWavesfiltered(k,:) = mean(windSpeedFiltScenario{1,k}.waveHeight,'all','omitnan') + ts*SEM; 
end

% Snaprate ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(SnapWindFiltScenario{1,k}.SnapCount(:),'omitnan')/sqrt(length(SnapWindFiltScenario{1,k}.SnapCount));  
    ts = tinv([0.025  0.975],length(SnapWindFiltScenario{1,k}.SnapCount)-1);  
    ConfIntSnapsfiltered(k,:) = mean(SnapWindFiltScenario{1,k}.SnapCount,'all','omitnan') + ts*SEM; 
end

% Noise ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(windEnviroFiltScenario{1,k}.Noise(:),'omitnan')/sqrt(length(windEnviroFiltScenario{1,k}.Noise));  
    ts = tinv([0.025  0.975],length(windEnviroFiltScenario{1,k}.Noise)-1);  
    ConfIntNoisefiltered(k,:) = mean(windEnviroFiltScenario{1,k}.Noise,'all','omitnan') + ts*SEM; 
end

%%


% normalizedWSpeedAnnual(COUNT,:)  = averageWindSpeed(COUNT,:)/(max(averageWindSpeed(COUNT,:)));

% % Previous example, Frank gotta use
% ciplot(CInightNoise(:,1),CInightNoise(:,2),1:5,'b')
% ciplot(CIdayNoise(:,1),CIdayNoise(:,2),1:5,'r')

% CONFINT Plots

X = 0:14;
figure()
Test = tiledlayout(1,4)
ax1 = nexttile()
ciplot(ConfIntSBL(:,1),ConfIntSBL(:,2),1:15,'b')
xlabel('Windspeed (m/s)')
ylabel('SBL (dB)')
title('Surface Bubble Loss')

ax2 = nexttile()
% plot(X,averageWaves,'LineWidth',2);
ciplot(ConfIntNoise(:,1),ConfIntNoise(:,2),1:15,'b')
xlabel('Windspeed (m/s)')
ylabel('Noise (mV)')
title('High-Frequency (50-90 kHz) Noise')

ax3 = nexttile()
% plot(X,averageSnaps,'LineWidth',2);
ciplot(ConfIntSnaps(:,1),ConfIntSnaps(:,2),1:15,'b')
xlabel('Windspeed (m/s)')
ylabel('Snaprate')
title('Hourly Snaprate')


ax4 = nexttile()
% plot(X,averageSST,'LineWidth',2)
ciplot(ConfIntSST(:,1),ConfIntSST(:,2),1:15,'b')
xlabel('Windspeed (m/s)')
ylabel('SST (C)')
title('Sea-surface Temperature')

%%
% Same, but using the 40hr lowpass filt.
X = 0:14;
figure()
Test = tiledlayout(1,4)
ax1 = nexttile()
ciplot(ConfIntSBLfiltered(:,1),ConfIntSBLfiltered(:,2),1:15,'b')
xlabel('Windspeed (m/s)')
ylabel('SBL (dB)')
title('Surface Bubble Loss')

ax2 = nexttile()
plot(X,averageWaves,'LineWidth',2);
ciplot(ConfIntNoisefiltered(:,1),ConfIntNoisefiltered(:,2),1:15,'b')
xlabel('Windspeed (m/s)')
ylabel('Noise (mV)')
title('High-Frequency (50-90 kHz) Noise')

ax3 = nexttile()
plot(X,averageSnaps,'LineWidth',2);
ciplot(ConfIntSnapsfiltered(:,1),ConfIntSnapsfiltered(:,2),1:15,'b')
xlabel('Windspeed (m/s)')
ylabel('Snaprate')
title('Hourly Snaprate')


ax4 = nexttile()
plot(X,averageSST,'LineWidth',2)
ciplot(ConfIntSSTfiltered(:,1),ConfIntSSTfiltered(:,2),1:15,'b')
xlabel('Windspeed (m/s)')
ylabel('SST (C)')
title('Sea-surface Temperature')


%%
% Regular Averages

figure()
Test = tiledlayout(1,4)
ax1 = nexttile()
plot(X,averageSBL,'LineWidth',2);
xlabel('Windspeed (m/s)')
ylabel('SBL (dB)')
title('Surface Bubble Loss')

ax2 = nexttile()
plot(X,averageWaves,'LineWidth',2);
xlabel('Windspeed (m/s)')
ylabel('Waveheight (m)')
title('Waveheight')

ax3 = nexttile()
plot(X,averageSnaps,'LineWidth',2);
xlabel('Windspeed (m/s)')
ylabel('Snaprate')
title('Hourly Snaprate')


ax4 = nexttile()
plot(X,averageSST,'LineWidth',2)
xlabel('Windspeed (m/s)')
ylabel('SST (C)')
title('Sea-surface Temperature')

%%

for COUNT = 1:length(windSpeedScenario)
    for season = 1:length(seasons)
        errorWind(COUNT,season) = std(averageWindSpeed{COUNT}{season},'omitnan');
        errorNoise(COUNT,season) = std(noiseCompare{COUNT}{season},'omitnan');
        errorStrat(COUNT,season) = std(stratCompareWind{COUNT}{season},'omitnan');
    end
end


for COUNT = 1:2:length(receiverData)-1
    for season = 1:length(seasons)
        comboPlatter = [averageWindSpeed{COUNT}{season},averageWindSpeed{COUNT+1}{season}];
        normalizedWSpeed{COUNT}{season}  = averageWindSpeed{COUNT}{season}/(max(comboPlatter));
        normalizedWSpeed{COUNT+1}{season}  = averageWindSpeed{COUNT+1}{season}/(max(comboPlatter));
    end
end

%%
% Binned by snaprate


snapRateBins(1,:) = snapRateHourly.SnapCount < 750;
snapRateBins(2,:) = snapRateHourly.SnapCount > 750 & snapRateHourly.SnapCount < 1125 ;
snapRateBins(3,:) = snapRateHourly.SnapCount > 1125 & snapRateHourly.SnapCount < 1500 ;
snapRateBins(4,:) = snapRateHourly.SnapCount > 1500 & snapRateHourly.SnapCount < 1875 ;
snapRateBins(5,:) = snapRateHourly.SnapCount > 1875 & snapRateHourly.SnapCount < 2250 ;
snapRateBins(6,:) = snapRateHourly.SnapCount > 2250 & snapRateHourly.SnapCount < 2625 ;
snapRateBins(7,:) = snapRateHourly.SnapCount > 2625 & snapRateHourly.SnapCount < 3000 ;
snapRateBins(8,:) = snapRateHourly.SnapCount > 3000 & snapRateHourly.SnapCount < 3375 ;
snapRateBins(9,:) = snapRateHourly.SnapCount > 3375 & snapRateHourly.SnapCount < 3750 ;
snapRateBins(10,:) = snapRateHourly.SnapCount > 3750 & snapRateHourly.SnapCount < 4125 ;
snapRateBins(11,:) = snapRateHourly.SnapCount > 4125 & snapRateHourly.SnapCount < 4500 ;
snapRateBins(12,:) = snapRateHourly.SnapCount > 4500 & snapRateHourly.SnapCount < 4875 ;
snapRateBins(13,:) = snapRateHourly.SnapCount > 4875;

%
snapRateFiltBins(1,:) = filteredData.Snaps < 750;
snapRateFiltBins(2,:) = filteredData.Snaps > 750 & filteredData.Snaps < 1125 ;
snapRateFiltBins(3,:) = filteredData.Snaps > 1125 & filteredData.Snaps < 1500 ;
snapRateFiltBins(4,:) = filteredData.Snaps > 1500 & filteredData.Snaps < 1875 ;
snapRateFiltBins(5,:) = filteredData.Snaps > 1875 & filteredData.Snaps < 2250 ;
snapRateFiltBins(6,:) = filteredData.Snaps > 2250 & filteredData.Snaps < 2625 ;
snapRateFiltBins(7,:) = filteredData.Snaps > 2625 & filteredData.Snaps < 3000 ;
snapRateFiltBins(8,:) = filteredData.Snaps > 3000 & filteredData.Snaps < 3375 ;
snapRateFiltBins(9,:) = filteredData.Snaps > 3375 & filteredData.Snaps < 3750 ;
snapRateFiltBins(10,:) = filteredData.Snaps > 3750 & filteredData.Snaps < 4125 ;
snapRateFiltBins(11,:) = filteredData.Snaps > 4125 & filteredData.Snaps < 4500 ;
snapRateFiltBins(12,:) = filteredData.Snaps > 4500 & filteredData.Snaps < 4875 ;
snapRateFiltBins(13,:) = filteredData.Snaps > 4875;


%%

for k = 1:height(snapRateBins)
    snapScenario{k}= surfaceData(snapRateBins(k,:),:);
    averageSBL(1,k) = mean(snapScenario{1,k}.SBLcapped);
    averageSST(1,k) = mean(snapScenario{1,k}.SST);
    averageWaves(1,k) = mean(snapScenario{1,k}.waveHeight);
    averageWinds(1,k) = mean(snapScenario{1,k}.WSPD);
    
    
    snapEnviroScenario{k}= envData(snapRateBins(k,:),:);
    averageDets(1,k)  = mean(snapEnviroScenario{1,k}.HourlyDets);
    averageNoise(1,k) = mean(snapEnviroScenario{1,k}.Noise);
end
%%
%Filt averages.
for k = 1:height(snapRateFiltBins)
    snapFiltScenario{k}= surfaceData(snapRateFiltBins(k,:),:);
    filtAverageSBL(1,k) = mean(snapFiltScenario{1,k}.SBLcapped);
    filtAaverageSST(1,k) = mean(snapFiltScenario{1,k}.SST);
    filtAverageWaves(1,k) = mean(snapFiltScenario{1,k}.waveHeight);
    filtAverageWinds(1,k) = mean(snapFiltScenario{1,k}.WSPD);
    
    
    snapEnviroFiltScenario{k}= envData(snapRateFiltBins(k,:),:);
    averageFiltNoise(1,k) = mean(snapEnviroFiltScenario{1,k}.Noise);
    filtAverageDets(1,k)  = mean(snapEnviroFiltScenario{1,k}.HourlyDets);
end


%%


% Surface Bubble Loss ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(snapScenario{1,k}.SBLcapped(:),'omitnan')/sqrt(length(snapScenario{1,k}.SBLcapped));  
    ts = tinv([0.025  0.975],length(snapScenario{1,k}.SBLcapped)-1);  
    ConfIntSBL(k,:) = mean(snapScenario{1,k}.SBLcapped,'all','omitnan') + ts*SEM; 
end

% Seasurface Temperature ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(snapScenario{1,k}.SST(:),'omitnan')/sqrt(length(snapScenario{1,k}.SST));  
    ts = tinv([0.025  0.975],length(snapScenario{1,k}.SST)-1);  
    ConfIntSST(k,:) = mean(snapScenario{1,k}.SST,'all','omitnan') + ts*SEM; 
end

% Waveheight ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(snapScenario{1,k}.waveHeight(:),'omitnan')/sqrt(length(snapScenario{1,k}.waveHeight));  
    ts = tinv([0.025  0.975],length(snapScenario{1,k}.waveHeight)-1);  
    ConfIntWaves(k,:) = mean(snapScenario{1,k}.waveHeight,'all','omitnan') + ts*SEM; 
end

% Noise ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(snapEnviroScenario{1,k}.Noise(:),'omitnan')/sqrt(length(snapEnviroScenario{1,k}.Noise));  
    ts = tinv([0.025  0.975],length(snapEnviroScenario{1,k}.Noise)-1);  
    ConfIntNoise(k,:) = mean(snapEnviroScenario{1,k}.Noise,'all','omitnan') + ts*SEM; 
end

% Dets ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(snapEnviroScenario{1,k}.HourlyDets(:),'omitnan')/sqrt(length(snapEnviroScenario{1,k}.HourlyDets));  
    ts = tinv([0.025  0.975],length(snapEnviroScenario{1,k}.HourlyDets)-1);  
    ConfIntHourlyDets(k,:) = mean(snapEnviroScenario{1,k}.HourlyDets,'all','omitnan') + ts*SEM; 
end


%%
% Confidence intervals for the filtered data
% Surface Bubble Loss ConfInt
for k = 1:length(filtAverageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(snapFiltScenario{1,k}.SBLcapped(:),'omitnan')/sqrt(length(snapFiltScenario{1,k}.SBLcapped));  
    ts = tinv([0.025  0.975],length(snapFiltScenario{1,k}.SBLcapped)-1);  
    ConfIntSBLfiltered(k,:) = mean(snapFiltScenario{1,k}.SBLcapped,'all','omitnan') + ts*SEM; 
end

% Seasurface Temperature ConfInt
for k = 1:length(filtAverageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(snapFiltScenario{1,k}.SST(:),'omitnan')/sqrt(length(snapFiltScenario{1,k}.SST));  
    ts = tinv([0.025  0.975],length(snapFiltScenario{1,k}.SST)-1);  
    ConfIntSSTfiltered(k,:) = mean(snapFiltScenario{1,k}.SST,'all','omitnan') + ts*SEM; 
end

% Waveheight ConfInt
for k = 1:length(filtAverageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(snapFiltScenario{1,k}.waveHeight(:),'omitnan')/sqrt(length(snapFiltScenario{1,k}.waveHeight));  
    ts = tinv([0.025  0.975],length(snapFiltScenario{1,k}.waveHeight)-1);  
    ConfIntWavesfiltered(k,:) = mean(snapFiltScenario{1,k}.waveHeight,'all','omitnan') + ts*SEM; 
end


% Noise ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(snapEnviroFiltScenario{1,k}.Noise(:),'omitnan')/sqrt(length(snapEnviroFiltScenario{1,k}.Noise));  
    ts = tinv([0.025  0.975],length(snapEnviroFiltScenario{1,k}.Noise)-1);  
    ConfIntNoisefiltered(k,:) = mean(snapEnviroFiltScenario{1,k}.Noise,'all','omitnan') + ts*SEM; 
end

% Dets ConfInt
for k = 1:length(averageSBL)
    %Finding standard deviations/CIs of values
    SEM = std(snapEnviroFiltScenario{1,k}.HourlyDets(:),'omitnan')/sqrt(length(snapEnviroFiltScenario{1,k}.HourlyDets));  
    ts = tinv([0.025  0.975],length(snapEnviroFiltScenario{1,k}.HourlyDets)-1);  
    ConfIntHourlyDetsfiltered(k,:) = mean(snapEnviroFiltScenario{1,k}.HourlyDets,'all','omitnan') + ts*SEM; 
end

%%

% Range of snaprates
X = 750:375:5250;

figure()
Test = tiledlayout(1,5)
ax1 = nexttile()
ciplot(ConfIntSBL(:,1),ConfIntSBL(:,2),X,'b')
xlabel('Snaprate')
ylabel('SBL (dB)')
title('Surface Bubble Loss')

ax2 = nexttile()
% plot(X,averageWaves,'LineWidth',2);
ciplot(ConfIntWaves(:,1),ConfIntWaves(:,2),X,'b')
xlabel('Snaprate')
ylabel('Waveheight (m)')
title('Waveheight')

ax3 = nexttile()
% plot(X,averageSnaps,'LineWidth',2);
ciplot(ConfIntHourlyDets(:,1),ConfIntHourlyDets(:,2),X,'b')
xlabel('Snaprate')
ylabel('Detections')
title('Hourly Detections')


ax4 = nexttile()
% plot(X,averageSST,'LineWidth',2)
ciplot(ConfIntSST(:,1),ConfIntSST(:,2),X,'b')
xlabel('Snaprate')
ylabel('SST (C)')
title('Sea-surface Temperature')


ax5 = nexttile()
% plot(X,averageSST,'LineWidth',2)
ciplot(ConfIntNoise(:,1),ConfIntNoise(:,2),X,'b')
xlabel('Snaprate')
ylabel('Noise (mV)')
title('High-Frequency Noise')


%%
% Same, but using the 40hr lowpass filt.
% Range of snaprates
X = 750:375:5250;


figure()
Test = tiledlayout(1,5)
ax1 = nexttile()
ciplot(ConfIntSBLfiltered(:,1),ConfIntSBLfiltered(:,2),X,'b')
xlabel('Snaprate')
ylabel('SBL (dB)')
title('Surface Bubble Loss')

ax2 = nexttile()
% plot(X,averageWaves,'LineWidth',2);
ciplot(ConfIntWavesfiltered(:,1),ConfIntWavesfiltered(:,2),X,'b')
xlabel('Snaprate')
ylabel('Waveheight (m)')
title('Waveheight')

ax3 = nexttile()
% plot(X,averageSnaps,'LineWidth',2);
ciplot(ConfIntHourlyDetsfiltered(:,1),ConfIntHourlyDetsfiltered(:,2),X,'b')
xlabel('Snaprate')
ylabel('Detections')
title('Hourly Detections')


ax4 = nexttile()
% plot(X,averageSST,'LineWidth',2)
ciplot(ConfIntSSTfiltered(:,1),ConfIntSSTfiltered(:,2),X,'b')
xlabel('Snaprate')
ylabel('SST (C)')
title('Sea-surface Temperature')

ax5 = nexttile()
% plot(X,averageSST,'LineWidth',2)
ciplot(ConfIntNoisefiltered(:,1),ConfIntNoisefiltered(:,2),X,'b')
xlabel('Snaprate')
ylabel('Noise (mV)')
title('High-Frequency Noise')



