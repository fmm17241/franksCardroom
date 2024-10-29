%%
% Okay, I calculated and capped the attenuation at the surface, now I have to
%   figure out what percentage of the difference is from this bubble layer,
%   and whether the snaprate changes.


fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

%%
% % Load in saved data
% % Environmental data matched to the hourly snaps.
% load envDataSpring
% % % Full snaprate dataset
% load snapRateDataSpring
% % % Snaprate binned hourly
% load snapRateHourlySpring
% % % Snaprate binned per minute
% load snapRateMinuteSpring
% load surfaceDataSpring
% load filteredData4Bin40HrLowSPRING
% 
% times = surfaceData.time;
%%
load envDataFall
% Full snaprate dataset
load snapRateDataFall
% Snaprate binned hourly
load snapRateHourlyFall
% Snaprate binned per minute
load snapRateMinuteFall
load surfaceDataFall
load filteredData4Bin40HrLowFALLpruned.mat
times = surfaceData.time;

envData = envData(30:2078,:);
surfaceData = surfaceData(30:2078,:);
snapRateHourly = snapRateHourly(30:2078,:);
times = times(30:2078);
FMFMFMFM Frank prune data

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
RSQ = R(1,2)*R(1,2)

[R,P,RL,RU] =corrcoef(decimatedData.SBLcapped,decimatedData.Noise)
RSQ = R(1,2)*R(1,2)


[R,P,RL,RU]= corrcoef(envData.Noise,surfaceData.SBLcapped)


[R,P,RL,RU] =corrcoef(envData.Noise,snapRateHourly.SnapCount)
RSQ = R(1,2)*R(1,2)


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
% 
% FRANKFRANKFEFFSERFGF
% Loops in Noise and SBL: 2268, 2191, 2098, 2060, 2140'
% 876, 803, 687, 610, 955, 1037
% 387, 457, 301

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
scatter(times,filteredData.Noise,[],X,'filled');
legend('Raw','Filtered')
title('Noise')

ax2 = nexttile()
scatter(times,surfaceData.WSPD);
hold on
scatter(times,filteredData.Winds,[],X,'filled');
legend('Raw','Filtered')
title('Winds')

linkaxes([ax1 ax2],'x')

%%
% Frank learning to decimate()

decimatedData.Snaps = decimate(filteredData.Snaps,4);
decimatedData.Noise = decimate(filteredData.Noise,4);
decimatedData.Winds = decimate(filteredData.Winds,4);
decimatedData.Waves = decimate(filteredData.Waves,4);
decimatedData.Tides = decimate(filteredData.Tides,4);
decimatedData.TidesAbsolute = decimate(filteredData.TidesAbsolute,4);
decimatedData.WindDir = decimate(filteredData.WindDir,4);
decimatedData.SBL = decimate(filteredData.SBL,4);
decimatedData.SBLcapped = decimate(filteredData.SBLcapped,4);
decimatedData.Detections = decimate(filteredData.Detections,4);
decimatedData.SST = decimate(filteredData.SST,4);


figure()
scatter(times,filteredData.Snaps)
figure()
plot(decimatedData.Snaps)


X1 = 1:length(times);
X2 = 1:length(decimatedData.Snaps);

figure()
Tiled = tiledlayout(2,3)
ax1 = nexttile([2,1])
% scatter(snapRateHourly.SnapCount,envData.Noise,[],X1)
% hold on
scatter(decimatedData.Snaps,decimatedData.Noise,[],X2,'filled')
xlabel('Hourly Snaprate')
ylabel('HF Noise (mV)')
title('','High-Frequency Noise Being Created')
% legend('Raw','40Hr Lowpass')


ax2 = nexttile([2,1])
% scatter(surfaceData.WSPD,envData.Noise)
% scatter(surfaceData.SBLcapped,envData.Noise,[],X1)
% hold on
% scatter(filteredData.Winds,filteredData.Noise)
scatter(decimatedData.SBLcapped,decimatedData.Noise,[],X2,'filled')
ylabel('HF Noise (mV)')
xlabel('Surface Bubble Loss (dBs)')
title('Gray''s Reef Soundscape, Spring 2020','Noise Being Attenuated at the Surface')


ax3 = nexttile([2,1])
% scatter(surfaceData.WSPD,snapRateHourly.SnapCount,[],X1)
% hold on
scatter(decimatedData.Winds,decimatedData.Snaps,[],X2,'filled')
ylabel('Hourly Snaps')
xlabel('Windspeed (m/s)')
title('','Little Change in Snaprate')


% cd ('C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis\plots')
% exportgraphics(Tiled,'decimatedTiles.png')



%%
%just making presentation plots

figure()
yyaxis left
% plot(times,snapRateHourly.SnapCount)
plot(times,filteredData.Snaps,'LineWidth',4)
ylabel('Hourly Snaps')

yyaxis right
plot(times,filteredData.BottomTemp,'LineWidth',4)
ylabel('Bottom Temperature (C)')

title('Increase in Benthic Activity as Gray''s Reef Warms','40Hr Lowpass')

cd ('C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis\plots')
exportgraphics(gca,'snapTemps.png')

%
figure()
scatter(decimatedData.Snaps,decimatedData.Noise,[],X2,'filled')
ylabel('HF Noise (mV)')
xlabel('Hourly Snaprate')
title('Snapping Shrimp Noise Creation','40Hr Lowpass')

figure()
plot(times,snapRateHourly.SnapCount,'LineWidth',4)

cd ('C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis\plots')
exportgraphics(gca,'snapNoise.png')

[R,P,RL,RU] =corrcoef(filteredData.Snaps,filteredData.BottomTemp)
RSQ = R(1,2)*R(1,2)


[R,P,RL,RU] =corrcoef(filteredData.Snaps(29:end),filteredData.BottomTemp(29:end))
RSQ = R(1,2)*R(1,2)

[R,P,RL,RU] =corrcoef(filteredData.Snaps,filteredData.Noise)
RSQ = R(1,2)*R(1,2)

figure()
yyaxis left
plot(times,filteredData.Winds,'LineWidth',3)
yyaxis right
plot(times,filteredData.Noise)



ax1.YAxis(1).Color = 'k';
ax1.YAxis(2).Color = 'k';
ax2.YAxis(1).Color = 'k';
ax2.YAxis(2).Color = 'k';


%%
figure()
yyaxis left 
plot(times,surfaceData.SBLcapped)
yyaxis right
plot(times,envData.Noise)

