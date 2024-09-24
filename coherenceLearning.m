%Frank teaching himself cohere. This is from ChatGPT, NOT for use, just for following the technique.

fs = 1000;            % Sampling frequency (Hz)
t = 0:1/fs:1-1/fs;    % Time vector (1 second of data)

% Generate two signals with shared and independent components
x = cos(2*pi*50*t) + randn(size(t));  % Signal 1: 50 Hz tone with noise
y = cos(2*pi*50*t) + randn(size(t));  % Signal 2: Same 50 Hz tone but different noise

% Calculate coherence between x and y
window = hamming(256);   % Define a window function (Hamming window)
noverlap = 128;          % Number of overlapping samples
nfft = 512;              % Number of FFT points

[Cxy, f] = mscohere(x, y, window, noverlap, nfft, fs);


% Plot coherence
figure;
plot(f, Cxy);
xlabel('Frequency (Hz)');
ylabel('Coherence');
title('Magnitude-Squared Coherence between x and y');
grid on;

window = hann(256);

figure()
semilogx(f, Cxy);
xlabel('Frequency (Hz)');
ylabel('Coherence');
grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Frank tries his own data now
%Run snapRateAnalyzer and Plotter.

%This processes our snap counts, removing the trend and mean from the data.
for K = 1:length(envData)
    % Detrending the signal
    detrendedSnapSignal{K} = detrend(hourSnaps{K}.SnapCount,'constant');
    %Removing the mean from the signal:
    snapSignal{K} = detrendedSnapSignal{K} - mean(detrendedSnapSignal{K});
end

%This processes our noise data, removing the trend and mean from the data.
for K = 1:length(envData)
    % Detrending the signal
    detrendedNoiseSignal{K} = detrend(envData{K}.Noise,'constant');
    %Removing the mean from the signal:
    noiseSignal{K} = detrendedNoiseSignal{K} - mean(detrendedNoiseSignal{K});
end

%This processes our wind data, removing the trend and mean from the data.
for K = 1:length(envData)
    % Detrending the signal
    detrendedWindSignal{K} = detrend(envData{K}.windSpd,'constant');
    %Removing the mean from the signal:
    windSignal{K} = detrendedWindSignal{K} - mean(detrendedWindSignal{K});
end

%Sampling frequency: Hourly (Hz) 1 Hz = second, so 1/
fs = 1/3600;

% Set window to cover the whole signal, no overlap, FFT length = length of signal
window = rectwin(length(x));  % Rectangular window with no tapering (i.e., no windowing)
noverlap = 330;          % Number of overlapping samples
nfft = 330;              % Number of FFT points

[Cxy, f] = mscohere(windSignal{1}, noiseSignal{1}, window, noverlap, nfft, fs);

when 1000 data:
window = hamming(256);   % Define a window function (Hamming window)
noverlap = 0;          % Number of overlapping samples
nfft = length(windSignal{1});              % Number of FFT points


clearvars detrended* minute*

