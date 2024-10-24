%%
% Okay, I calculated and capped the attenuation at the surface, now I have to
%   figure out what percentage of the difference is from this bubble layer,
%   and whether the snaprate changes.


fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

%%
% % Load in saved data
% Environmental data matched to the hourly snaps.
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
% load envDataFall
% % Full snaprate dataset
% load snapRateDataFall
% % Snaprate binned hourly
% load snapRateHourlyFall
% % Snaprate binned per minute
% load snapRateMinuteFall
% load surfaceDataFall
% times = surfaceData.time;
%%
bins = 4

powerDetsSBLcapped = Coherence_whelch_overlap(envData.HourlyDets,surfaceData.SBLcapped,3600,bins,1,1,1)

%Frank is trying to remove non-significant peaks; it gets furry at the bottom of the Y, let's clean up.
powerDetsSBLcapped.coh(powerDetsSBLcapped.coh < powerDetsSBLcapped.pr95bendat) = 0;

%Frank doing the same for phases
powerDetsSBLcapped.phase(powerDetsSBLcapped.coh < powerDetsSBLcapped.pr95bendat) = 0;


figure()
loglog(powerDetsSBLcapped.f*86400,powerDetsSBLcapped.psda,'k')
hold on
loglog(powerDetsSBLcapped.f*86400,powerDetsSBLcapped.psdb,'r')
legend('Snaprate','SBLoss')

figure()
semilogx(powerDetsSBLcapped.f*86400,powerDetsSBLcapped.coh)
yline(powerDetsSBLcapped.pr95bendat,'-','95%')
title('Coherence - Detections and SBL')



%%
snapRateHourly.SnapCount
surfaceData.

[R,P,RL,RU] =corrcoef(filteredData.SST,filteredData.Snaps)


[R,P,RL,RU] =corrcoef(surfaceData.SST,snapRateHourly.SnapCount)


[R,P,RL,RU]= corrcoef(surfaceData.WSPD,snapRateHourly.SnapCount)
[R,P,RL,RU] = corrcoef(filteredData.Winds,filteredData.Snaps)

% filtered.Data

figure()
scatter(surfaceData.WSPD,surfaceData.waveHeight)

figure()
yyaxis left
scatter(surfaceData.WSPD,envData.Noise)
yyaxis right
plot(filteredData.Winds,filteredData.Snaps)

figure()
scatter(surfaceData.SST,snapRateHourly.SnapCount)
hold on
scatter(filteredData.SST,filteredData.Snaps,'filled')
xlabel('Sea Surface Temp (C)')
ylabel('Hourly Snaps')
legend('Raw Data','40Hr Lowpass')
title('Benthic Activity with Warming Waters','Raw versus 40Hr Lowpass')
% exportgraphics(gca,'TempSnaprate.png')

X = 1:length(times);


figure()
Tiled = tiledlayout(2,3)
ax1 = nexttile([2,1])
scatter(snapRateHourly.SnapCount,envData.Noise,[],X)
hold on
scatter(filteredData.Snaps,filteredData.Noise,[],X,'filled')
xlabel('Hourly Snaprate')
ylabel('HF Noise (mV)')
title('','High-Frequency Noise Being Created')
legend('Raw','40Hr Lowpass')


ax2 = nexttile([2,1])
% scatter(surfaceData.WSPD,envData.Noise)
scatter(surfaceData.SBLcapped,envData.Noise,[],X)
ylabel('HF Noise (mV)')
xlabel('Surface Bubble Loss (dBs)')
hold on
% scatter(filteredData.Winds,filteredData.Noise)
scatter(filteredData.SBLcapped,filteredData.Noise,[],X,'filled')
title('Gray''s Reef Soundscape, Spring 2020','Noise Being Attenuated at the Surface')


ax3 = nexttile([2,1])
scatter(surfaceData.WSPD,snapRateHourly.SnapCount,[],X)
hold on
scatter(filteredData.Winds,filteredData.Snaps,[],X,'filled')
ylabel('Hourly Snaps')
xlabel('Windspeed (m/s)')
title('','Little Change in Snaprate')

% cd ('C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis\plots')
% exportgraphics(Tiled,'soundscapeTiles.png')

%%
%
figure()
tiledlayout(2,1)
ax1 = nexttile()
scatter(times,envData.Noise);
hold on
scatter(times,filteredData.Noise,[],X);
legend('Raw','Filtered')
title('Noise')

ax2 = nexttile()
scatter(times,surfaceData.WSPD);
hold on
scatter(times,filteredData.Winds,[],X);
legend('Raw','Filtered')
title('Winds')

linkaxes([ax1 ax2],'x')
