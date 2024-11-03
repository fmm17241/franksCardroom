%Frank experiments with wavelets

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
load filteredData4Bin40HrLowSPRING.mat

times = surfaceData.time;


%Create monthly variables

surface = retime(surfaceData,'monthly','mean')
enviro = retime(envData,'monthly','mean')

snhaps = retime(snapRateHourly,'monthly','mean')



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





% Assume `signal` is your time series data, and `Fs` is the sampling frequency
[wt, f] = cwt(envData.crossShore, 3600);  % `Fs` should match the sampling rate of your recording
% Plot the wavelet coefficients
figure;
pcolor(times, f, abs(wt));  % `t` is time, `f` is frequency vector from `cwt`
shading interp;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Wavelet Transform');
colorbar;