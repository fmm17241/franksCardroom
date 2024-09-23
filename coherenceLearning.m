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
