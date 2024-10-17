%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FM 9/24/24
% Frank is analyzing the activity of snapping shrimp.
%Step 1: Raven Pro amplitude threshold detector gives snaps, I bin them hourly
%Step 2: load in that snapdata and relevant environmental data.
%Step 3: Convert the data from time domain to power domain, frequency spectrum
%Step 4: Compare the different signals using coherence
%%
%Run snapRateAnalyzer and Plotter.


% fileLocation = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis\FallSnapStudy';
% [snapRateData, snapRateHourly, snapRateMinute] = snapRateAnalyzer(fileLocation);
% % % Second step: this bins, averages, and plots some of their
% [receiverData, tides, snapRateHourly, snapRateMinute, envData, windSpeedBins, windSpeedScenario, avgSnaps, averageDets, surfaceData] = snapRatePlotter(oneDrive, snapRateHourly, snapRateMinute);
% % %%
fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

%%
% Load in saved data
% Environmental data matched to the hourly snaps.
load envDataSpring
% Full snaprate dataset
load snapRateDataSpring
% Snaprate binned hourly
load snapRateHourlySpring
% Snaprate binned per minute
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
%This is just raw frequency
bins = 4;

[powerSnapWind, powerSnapWave, powerSnapNoise, powerWindWave,...
    powerNoiseWave,powerSnapTides,powerSnapAbsTides] = filterSnapDataRaw(envData, snapRateHourly, surfaceData, bins)

%Bandpass Creation
% % Frequency cutoff for filter.
% cutoffHrs = 40;
% %Create the cutoff
% % cutoff = 1/(cutoffHrs);
% % Bandpass filtering between 40 hours and 10 days; I want to focus on the
% % effect of synoptic winds and the Spring/Neap tidal cycle on snaps, and
% % use those snaps as a proxy for noise creation.
% cutoff = [1/240; 1/40]
% filterType = 'bandpass';
% bins = 5;
% 
% [lowpassData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP...
%     powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
%     cutoff, cutoffHrs, filterType, bins, filterOrder)

%%
% Filter Creation
% Frequency cutoff for filter.
cutoffHrs = 40;
%Create the cutoff
% cutoff = 1/(cutoffHrs);
% Bandpass filtering between 40 hours and 10 days; I want to focus on the
% effect of synoptic winds and the Spring/Neap tidal cycle on snaps, and
% use those snaps as a proxy for noise creation.
cutoff = [1/40]
filterType = 'low';
bins = 4;
filterOrder = 4;

[filteredData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP...
    powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)


