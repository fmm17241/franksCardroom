%%
%Frank needs to cut fall at some point. I have lots of snap, wind, and wave data but less noise data from the transceiver.
% Maybe include detections too?

% Load in data.
fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

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


surfaceData = surfaceData(1:2078,:);
snapRateHourly = snapRateHourly(1:2078,:);

%%
% Highpass Creation
% Frequency cutoff for filter.
cutoffHrs = 40;
%Create the cutoff
% cutoff = 1/(cutoffHrs);
% Bandpass filtering between 40 hours and 10 days; I want to focus on the
% effect of synoptic winds and the Spring/Neap tidal cycle on snaps, and
% use those snaps as a proxy for noise creation.
cutoff = [1/40]
filterType = 'low';
bins = 6;
filterOrder = 4;

[filteredData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP...
    powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)

%%





