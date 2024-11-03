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
[wt, f] = cwt(filteredData.SBLcapped, 1/3600);  % `Fs` should match the sampling rate of your recording
% Plot the wavelet coefficients
figure;
pcolor(times, f, abs(wt));  % `t` is time, `f` is frequency vector from `cwt`
shading interp;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Wavelet Transform');
colorbar;

% Assume `signal` is your time series data, and `Fs` is the sampling frequency
[wt, f] = cwt(filteredData.Snaps, 1/3600);  % `Fs` should match the sampling rate of your recording
% Plot the wavelet coefficients
figure;
pcolor(times, f, abs(wt));  % `t` is time, `f` is frequency vector from `cwt`
shading interp;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Wavelet Transform');
colorbar;



%%
signals = [snapRateHourly.SnapCount surfaceData.SBLcapped];

numSignals = size(signals, 2);
Fs = 1/3600; % Hourly sampling rate

waveletCoefficients = cell(1, numSignals); % To store results
frequencies = cell(1, numSignals);         % To store frequency scales

for i = 1:numSignals
    [wt, f] = cwt(signals(:, i), Fs);
    % [wt, f] = cwt(signals(:, i), Fs, 'FrequencyLimits', [1e3, 20e3]);
    waveletCoefficients{i} = wt;
    frequencies{i} = f;
end

figure;
for i = 1:numSignals
    subplot(numSignals, 1, i);
    pcolor(times, frequencies{i}, abs(waveletCoefficients{i}));  % Use pcolor to plot magnitude
    shading interp;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title(['Signal ' num2str(i) ' Wavelet Transform']);
    colorbar;
end
