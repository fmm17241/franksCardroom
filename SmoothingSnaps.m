%%
%Frank has some odd peaks when I bin the snaps then convert to the power spectrum.

%I'm going to try and use a very small filter to remove some of that noise
fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)
%Load data
% % Environmental data matched to the hourly snaps.
load envDataSpring
% Full snaprate dataset
load snapRateDataSpring
% Snaprate binned hourly
load snapRateHourlySpring
% Snaprate binned per minute
load snapRateMinuteSpring
% Separate wind and wave data
load surfaceDataSpring
% % Environmental data matched to the hourly snaps.
% load envDataFall
% % Full snaprate dataset
% load snapRateDataFall
% % Snaprate binned hourly
% load snapRateHourlyFall
% % Snaprate binned per minute
% load snapRateMinuteFall
% % Separate wind and wave data
% load surfaceDataFall

%%
% I want to smooth some of the snapt data. Technically snaps are events that are counted instantly
% but binned by minute or hour.
%Fall has 137 days, Spring has 94.5 days
% FALL
% 2 Bins: 68.5  days
% 3 Bins: 45.6  days
% 4 Bins: 34.3  days
% 5 Bins: 27.4  days
% 6 Bins: 22.8  days
% 8 Bins: 17.1  days
%10 Bins: 13.7  days

% SPRING
% 2 Bins: 47.3  days
% 3 Bins: 31.5  days
% 4 Bins: 23.6  days
% 5 Bins: 18.9  days
% 6 Bins: 15.8  days
% 8 Bins: 11.8  days


cutoffHrs = 12;
%Create the cutoff
% cutoff = 1/(cutoffHrs);
% Bandpass filtering between 40 hours and 10 days; I want to focus on the
% effect of synoptic winds and the Spring/Neap tidal cycle on snaps, and
% use those snaps as a proxy for noise creation.
cutoff = [1/12]
filterType = 'low';
bins = 5;
filterOrder = 4;

[filteredData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP...
    powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)


close all

