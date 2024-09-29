%Frank teaching himself cohere. This is from ChatGPT, NOT for use, just for following the technique.
% 
% fs = 1000;            % Sampling frequency (Hz)
% t = 0:1/fs:1-1/fs;    % Time vector (1 second of data)
% 
% % Generate two signals with shared and independent components
% x = cos(2*pi*50*t) + randn(size(t));  % Signal 1: 50 Hz tone with noise
% y = cos(2*pi*50*t) + randn(size(t));  % Signal 2: Same 50 Hz tone but different noise
% 
% % Calculate coherence between x and y
% window = hamming(256);   % Define a window function (Hamming window)
% noverlap = 128;          % Number of overlapping samples
% nfft = 512;              % Number of FFT points
% 
% [Cxy, f] = mscohere(x, y, window, noverlap, nfft, fs);
% 
% 
% % Plot coherence
% figure;
% plot(f, Cxy);
% xlabel('Frequency (Hz)');
% ylabel('Coherence');
% title('Magnitude-Squared Coherence between x and y');
% grid on;
% 
% window = hann(256);
% 
% 
% figure()
% semilogx(f, Cxy);
% xlabel('Frequency (Hz)');
% ylabel('Coherence');
% grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Frank tries his own data now
%Run snapRateAnalyzer and Plotter.

fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
% fileLocation = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis';
% [snapRateData, snapRateHourly, snapRateMinute] = snapRateAnalyzer(fileLocation);

% Second step: this bins, averages, and plots some of their
% [receiverData, envData, windSpeedBins, windSpeedScenario, avgSnaps, averageDets] = snapRatePlotter(oneDrive, snapRateHourly, snapRateMinute);

cd (fileLocation)
load envDataSpring
load receiverData
load snapRateDataSpring
load snapRateHourlySpring
load snapRateMinuteSpring

figure()
tiledlayout(2,1)
ax1 = nexttile()
yyaxis left
plot(envData.DT,envData.Noise,'k');
ylabel('HF Noise')
yyaxis right
plot(envData.DT,envData.windSpd,'b')
ylabel('Winds')
ax2 = nexttile()
plot(snapRateHourly.Time,snapRateHourly.SnapCount,'r');
ylabel('SnapCount')

linkaxes([ax1, ax2],'x')

%Brock's breakdown into the power spectra
% dataout=Power_spectra(datainA,bins,DT,windoww,samplinginterval,cutoff)
snapSignal = Power_spectra(snapRateHourly.SnapCount,1,1,0,3600,0);
windSignal = Power_spectra(envData.windSpd,1,1,0,3600,0);
noiseSignal = Power_spectra(envData.Noise,1,1,0,3600,0);
tempSignal  = Power_spectra(envData.Temp,1,1,0,3600,0);
waveSignal  = Power_spectra(envData.waveHeight,1,1,0,3600,0);

%Coherence: comparing the signals created by Power_spectra
% Coherence_whelch_overlap(datainA, datainB, samplinginterval, bins, windoww, DT, cutoff)
coherenceSW = Coherence_whelch_overlap(snapSignal.psdw,waveSignal.psdw,3600,1,0,1,0)

figure()
loglog(coherenceSW.f*86400,coherenceSW.psda)

figure()
loglog(coherenceSW.f*86400,coherenceSW.psdb)

figure()
loglog(coherenceSW.f*86400,coherenceSW.cspd)

figure()
loglog(coherenceSW.f*86400,coherenceSW.phase)

%
coherenceSN = Coherence_whelch_overlap(snapSignal.psdw,noiseSignal.psdw,3600,1,0,1,0)


%%
%
fs = 1 / 3600;  % Sampling frequency in Hz (1 sample per hour)
fc = 1 / (40 * 3600);  % Cutoff frequency for 40-hour period in Hz
filteredData_highpass = highpass(envData, fc, fs);

fc = 1 / (48 * 3600);  % Cutoff frequency for 48-hour period in Hz
filteredData_lowpass = lowpass(envData, fc, fs);




%%
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
    %Remove NaNs
    index = isnan(envData{K}.windSpd);
    envData{K}.windSpd = fillmissing(envData{K}.windSpd, 'linear');
    % Detrending the signal
    detrendedWindSignal{K} = detrend(envData{K}.windSpd);
    %Removing the mean from the signal:
    windSignal{K} = detrendedWindSignal{K} - mean(detrendedWindSignal{K});
end

%Sampling frequency: Hourly (Hz) 1 Hz = second, so 1/(seconds*minutes)
fs = 1/3600;

% Set window to cover the whole signal, no overlap, FFT length = length of signal
window = rectwin(length(noiseSignal{1}));  % Rectangular window with no tapering (i.e., no windowing)
noverlap = 0;          % Number of overlapping samples
nfft = length(windSignal{1});              % Number of FFT points

[Cxy, f] = mscohere(windSignal{1}, snapSignal{1}, window, noverlap, nfft, fs);

[Cxy, f] = mscohere(envData{1}.windSpd, hourSnaps{1}.SnapCount, window, noverlap, nfft, fs);

when 1000 data:
window = hamming(256);   % Define a window function (Hamming window)



clearvars detrended* minute*


