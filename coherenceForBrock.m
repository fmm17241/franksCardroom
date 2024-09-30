%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Frank tries his own data now
%Run snapRateAnalyzer and Plotter.

% fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
% fileLocation = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis';
% [snapRateData, snapRateHourly, snapRateMinute] = snapRateAnalyzer(fileLocation);

% Second step: this bins, averages, and plots some of their
% [receiverData, envData, windSpeedBins, windSpeedScenario, avgSnaps, averageDets] = snapRatePlotter(oneDrive, snapRateHourly, snapRateMinute);

% cd (fileLocation)
load envDataSpring
load receiverData
load snapRateDataSpring
load snapRateHourlySpring
load snapRateMinuteSpring

%This removes a few NaNs by interpolating from the hours next to it
snapRateHourly.SnapCount(isnan(snapRateHourly.SnapCount)) = interp1(snapRateHourly.Time(~isnan(snapRateHourly.SnapCount)),...
    snapRateHourly.SnapCount(~isnan(snapRateHourly.SnapCount)),snapRateHourly.Time(isnan(snapRateHourly.SnapCount))) ;

envData.windSpd(isnan(envData.windSpd)) = interp1(envData.DT(~isnan(envData.windSpd)),...
    envData.windSpd(~isnan(envData.windSpd)),envData.DT(isnan(envData.windSpd))) ;


figure()
tiledlayout(2,1)
ax1 = nexttile()
yyaxis left
plot(envData.DT,envData.Noise,'b');
ylabel('HF Noise')
yyaxis right
plot(envData.DT,envData.windSpd,'r')
ylabel('Winds')
title('Environmental Noise and Winds')
ax2 = nexttile()
plot(snapRateHourly.Time,snapRateHourly.SnapCount,'k');
ylabel('SnapCount')
title('Hourly Recorded Snaps')

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

%First attempt is to compare something I know is very related, snaprate and noise levels.
coherenceSnapNoise = Coherence_whelch_overlap(snapSignal.psdw,noiseSignal.psdw,3600,1,0,1,0)

% Power spectral density of signal A, Snaprate
% This still shows odd spikes at every hour possible if I don't window.
figure()
loglog(coherenceSnapNoise.f*86400,coherenceSnapNoise.psda)
title('SnapRate')

% Power spectral density of signal B, HF noise levels
figure()
loglog(coherenceSnapNoise.f*86400,coherenceSnapNoise.psdb)
title('HF Noise levels')


% The co-spectral power of both A and B
figure()
loglog(coherenceSnapNoise.f*86400,coherenceSnapNoise.cspd)
title('Co-Spectral Power','Comparing Snaps and Noise')

figure()
loglog(coherenceSnapNoise.f*86400,coherenceSnapNoise.phase)


%%
% Using filters to focus on either the high frequency (less than 40 hours) or low frequency (greater than 72-hour) 
% components.
fs = 1 / 3600;  % Sampling frequency in Hz (1 sample per hour)
fc = 1 / (40 * 3600);  % Cutoff frequency for 40-hour period in Hz
filteredSnaps_highpass = highpass(snapRateHourly.SnapCount, fc, fs);
filteredVariables_Highpass.snaps = highpass(snapRateHourly.SnapCount, fc, fs);
filteredVariables_Highpass.noise = highpass(envData.Noise, fc, fs);
filteredVariables_Highpass.waveheight = highpass(envData.waveHeight, fc, fs);
filteredVariables_Highpass.temp = highpass(envData.Temp, fc, fs);
filteredVariables_Highpass.windspd = highpass(envData.windSpd, fc, fs);
filteredVariables_Highpass.tides = highpass(envData.crossShore, fc, fs);

%%
fc = 1 / (72 * 3600);  % Cutoff frequency for 72-hours
filteredSnaps_lowpass = lowpass(snapRateHourly.SnapCount, fc, fs);
filteredVariables_Lowpass.snaps = lowpass(snapRateHourly.SnapCount, fc, fs);
filteredVariables_Lowpass.noise = lowpass(envData.Noise, fc, fs);
filteredVariables_Lowpass.waveheight = lowpass(envData.waveHeight, fc, fs);
filteredVariables_Lowpass.temp = lowpass(envData.Temp, fc, fs);
filteredVariables_Lowpass.windspd = lowpass(envData.windSpd, fc, fs);
filteredVariables_Lowpass.tides = lowpass(envData.crossShore, fc, fs);


figure()
yyaxis left
plot(envData.DT,envData.windSpd,'r')
ylabel('WindSpd (m/s)')
yyaxis right
plot(envData.DT,filteredVariables_Lowpass.windspd,'k','LineWidth',2)
ylabel('Wind-Lowpass')

figure()
yyaxis left
plot(envData.DT,envData.Noise,'r')
ylabel('Noise')
hold on
plot(envData.DT,filteredVariables_Lowpass.noise,'k','LineWidth',2)
% ylabel('Noise-Lowpass')
legend('Raw','72hr-Lowpass')

%%
%Same power analysis, but after lowpass filtering it to focus on frequencies lower than every 3 days.
filteredSnapSignal = Power_spectra(filteredVariables_Lowpass.snaps,1,1,0,3600,0);
filteredWindSignal = Power_spectra(filteredVariables_Lowpass.windspd,1,1,0,3600,0);
filteredNoiseSignal = Power_spectra(filteredVariables_Lowpass.noise,1,1,0,3600,0);
filteredTempSignal  = Power_spectra(filteredVariables_Lowpass.temp,1,1,0,3600,0);
filteredWaveSignal  = Power_spectra(filteredVariables_Lowpass.waveheight,1,1,0,3600,0);


coherenceSNfiltered = Coherence_whelch_overlap(filteredSnapSignal.psdw,filteredNoiseSignal.psdw,3600,1,0,1,0)

% Power spectral density of signal A, filtered Snaps
figure()
loglog(coherenceSNfiltered.f*86400,coherenceSNfiltered.psda)
title('PSD','Snaprate')

% Power spectral density of signal B, filtered Noise
figure()
loglog(coherenceSNfiltered.f*86400,coherenceSNfiltered.psdb)
title('PSD','HF Noise')


% The co-spectral power of both A and B
figure()
loglog(coherenceSNfiltered.f*86400,coherenceSNfiltered.cspd)
title('Co-Spectral Power','Comparing Snaps and Noise')


%%