%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FM 9/24/24
% Frank is analyzing the activity of snapping shrimp.
%Step 1: Raven Pro amplitude threshold detector gives snaps, I bin them hourly
%Step 2: load in that snapdata and relevant environmental data.
%Step 3: Convert the data from time domain to power domain, frequency spectrum
%Step 4: Compare the different signals using coherence
%%
%Run snapRateAnalyzer and Plotter.


fileLocation = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis\SpringSnapStudy';
[snapRateData, snapRateHourly, snapRateMinute] = snapRateAnalyzer(fileLocation);
% % Second step: this bins, averages, and plots some of their
[receiverData, tides, snapRateHourly, snapRateMinute, envData, windSpeedBins, windSpeedScenario, avgSnaps, averageDets, surfaceData] = snapRatePlotter(oneDrive, snapRateHourly, snapRateMinute);
% %%
% surfaceLossFM


fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

%%
% Load in saved data
% Environmental data matched to the hourly snaps.
load envDataSpring
% % Full snaprate dataset
load snapRateDataSpring
% % Snaprate binned hourly
load snapRateHourlySpring
% % Snaprate binned per minute
load snapRateMinuteSpring
load surfaceDataSpring
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

%This is just raw frequency, without filtering.
bins = 4;

[powerSnapWind, powerSnapWave, powerSnapNoise, powerWindWave,...
    powerNoiseWave,powerSnapTides,powerSnapAbsTides,powerSnapSBLcapped] = filterSnapDataRaw(envData, snapRateHourly, surfaceData, bins)

%%
% Filter Creation
%Fitlers can be 'low', 'high', or 'bandpass'
filterType = 'low';
% Frequency cutoff for filter. Just used for titles and things
cutoffHrs = 40;
%Create the cutoff, 1/hours. For bandpass, format is [1/X 1/Y].
cutoff = [1/40]
%Bins to separate the data into.
bins = 4;
%Filter order
filterOrder = 4;

[filteredData, powerSnapWindFilt, powerSnapWaveFilt, powerSnapNoiseFilt, powerWindWaveFilt,...
    powerNoiseWaveFilt,powerSnapTidesFilt,powerSnapAbsTidesFilt] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)

%%
% Just for fall, simple, no noise just processes
%Fitlers can be 'low', 'high', or 'bandpass'
filterType = 'low';
% Frequency cutoff for filter. Just used for titles and things
cutoffHrs = 40;
%Create the cutoff, 1/hours. For bandpass, format is [1/X 1/Y].
cutoff = [1/40]
%Bins to separate the data into.
bins = 4;
%Filter order
filterOrder = 4;


[filteredData, powerSnapWindFilt, powerSnapWaveFilt, powerWindWaveFilt,...
    powerSnapTidesFilt,powerSnapAbsTidesFilt] = filterSnapDataSimple(snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)


[R,P,RL,RU] =corrcoef(snapRateHourly.SnapCount,envData.Noise)

figure()
TT = tiledlayout('flow')
ax1 = nexttile([1,1])
yyaxis left
plot(times,filteredData.SBLcapped,'b--','LineWidth',2)
ylabel('SBL (dB)')
ylim([0 10])
yyaxis right
plot(times,filteredData.Detections,'r-','LineWidth',2)
ylim([0 4])
ylabel('Detections')
title('Surface Bubble Loss''s Effect on Detections','40 Hr. Lowpass')
ax2 = nexttile([1,1])
plot(times,filteredData.SBLcapped,'b--','LineWidth',2)
ylabel('SBL (dB)')
ylim([0 16])
yyaxis right
plot(times,filteredData.Snaps,'r-','LineWidth',2)
% ylim([400 800])
ylabel('Snaprates')
title('Surface Bubble Loss''s Effect on Snaprate','40 Hr. Lowpass')
linkaxes([ax1 ax2],'x')

ax1.YAxis(1).Color = 'k';
ax1.YAxis(2).Color = 'k';
ax2.YAxis(1).Color = 'k';
ax2.YAxis(2).Color = 'k';


