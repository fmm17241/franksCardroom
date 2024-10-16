%%
%Frank has some odd peaks when I bin the snaps then convert to the power spectrum.

%I'm going to try and use a very small filter to remove some of that noise
fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)
%Load data
% % Environmental data matched to the hourly snaps.
% load envDataSpring
% % Full snaprate dataset
% load snapRateDataSpring
% % Snaprate binned hourly
% load snapRateHourlySpring
% % Snaprate binned per minute
% load snapRateMinuteSpring
% % Separate wind and wave data
% load surfaceDataSpring
% Environmental data matched to the hourly snaps.
load envDataFall
% Full snaprate dataset
load snapRateDataFall
% Snaprate binned hourly
load snapRateHourlyFall
% Snaprate binned per minute
load snapRateMinuteFall
% Separate wind and wave data
load surfaceDataFall

%%
% I want to smooth some of the snapt data. Technically snaps are events that are counted instantly
% but binned by minute or hour.

cutoffHrs = 12;
%Create the cutoff
% cutoff = 1/(cutoffHrs);
% Bandpass filtering between 40 hours and 10 days; I want to focus on the
% effect of synoptic winds and the Spring/Neap tidal cycle on snaps, and
% use those snaps as a proxy for noise creation.
cutoff = [1/12]
filterType = 'low';
bins = 12;

[lowpassData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP...
    powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins)




