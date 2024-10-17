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

if length(surfaceData.time) == 3308
    surfaceData = surfaceData(1:2078,:);
    snapRateHourly = snapRateHourly(1:2078,:);
end

times = surfaceData.time;

%%
% Filter Creation
% Frequency cutoff for filter.
cutoffHrs = 24;
%Create the cutoff
% cutoff = 1/(cutoffHrs);
% Bandpass filtering between 40 hours and 10 days; I want to focus on the
% effect of synoptic winds and the Spring/Neap tidal cycle on snaps, and
% use those snaps as a proxy for noise creation.
cutoff = [1/240 1/24]
filterType = 'bandpass';
bins = 4;
filterOrder = 5;

[filteredData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP...
    powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)

%%
%Frank needs to "Show it in the data"
figure()
yyaxis left
plot(times,filteredData.Winds,'b')
ylabel('WSPD (m/s)')
yyaxis right
plot(times,filteredData.Noise,'r')
ylabel('HF Noise (mV)')
title(sprintf('%s Filter (1-10day) Results',filterType),'HF Noise and Windspeed')
legend('Windspeed','HF Noise')



figure()
yyaxis left
plot(times,filteredData.Winds,'b')
ylabel('WSPD (m/s)')
yyaxis right
plot(times,filteredData.Snaps,'r')
ylabel('Snaprate')
title('','Windspeeds and Snaprates')
legend('Windspeed','Hourly Snaprate')


figure()
yyaxis left
plot(times,filteredData.Waves,'b')
ylabel('Waveheight (m)')
yyaxis right
plot(times,filteredData.Snaps,'r')
ylabel('Snaprate')
title('','Waves n''snaps')
legend('Waveheight','Snaps')


figure()
semilogx(powerSnapWaveLP.f*86400,powerSnapWaveLP.phase)













