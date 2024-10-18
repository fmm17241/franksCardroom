%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FM 9/24/24
% Frank is analyzing the activity of snapping shrimp.
%Step 1: Raven Pro amplitude threshold detector gives snaps, I bin them hourly
%Step 2: load in that snapdata and relevant environmental data.
%Step 3: Convert the data from time domain to power domain, frequency spectrum
%Step 4: Compare the different signals using coherence
%%
%Run snapRateAnalyzer and Plotter.


% fileLocation = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis\SpringSnapStudy';
% [snapRateData, snapRateHourly, snapRateMinute] = snapRateAnalyzer(fileLocation);
% % % Second step: this bins, averages, and plots some of their
% [receiverData, tides, snapRateHourly, snapRateMinute, envData, windSpeedBins, windSpeedScenario, avgSnaps, averageDets, surfaceData] = snapRatePlotter(oneDrive, snapRateHourly, snapRateMinute);
% % %%
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

[filteredData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP,...
    powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
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


[filteredData, powerSnapWindLP, powerSnapWaveLP, powerWindWaveLP,...
    powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapDataSimple(snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)


figure()
scatter(filteredData.Winds,filteredData.Snaps);

[R,P,RL,RU] =corrcoef(filteredData.Winds,filteredData.Waves)

[R,P,RL,RU]= corrcoef(surfaceData.WSPD,snapRateHourly.SnapCount)
[R,P,RL,RU] = corrcoef(filteredData.Winds,filteredData.Snaps)




