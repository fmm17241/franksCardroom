%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FM 9/24/24
% Frank is analyzing the activity of snapping shrimp.
%Step 1: Raven Pro amplitude threshold detector gives snaps, I bin them hourly
%Step 2: load in that snapdata and relevant environmental data.
%Step 3: Convert the data from time domain to power domain, frequency spectrum
%Step 4: Compare the different signals using coherence
%%
%Run snapRateAnalyzer and Plotter.
fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

% fileLocation = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis';
% [snapRateData, snapRateHourly, snapRateMinute] = snapRateAnalyzer(fileLocation);
% Second step: this bins, averages, and plots some of their
% [receiverData, envData, windSpeedBins, windSpeedScenario, avgSnaps, averageDets] = snapRatePlotter(oneDrive, snapRateHourly, snapRateMinute);
%%
% Load in saved data
% Environmental data matched to the hourly snaps.
load envDataSpring
% Full snaprate dataset
load snapRateDataSpring
% Snaprate binned hourly
load snapRateHourlySpring
% Snaprate binned per minute
load snapRateMinuteSpring

%This removes a few NaNs by interpolating from the hours next to it
snapRateHourly.SnapCount(isnan(snapRateHourly.SnapCount)) = interp1(snapRateHourly.Time(~isnan(snapRateHourly.SnapCount)),...
    snapRateHourly.SnapCount(~isnan(snapRateHourly.SnapCount)),snapRateHourly.Time(isnan(snapRateHourly.SnapCount))) ;

envData.windSpd(isnan(envData.windSpd)) = interp1(envData.DT(~isnan(envData.windSpd)),...
    envData.windSpd(~isnan(envData.windSpd)),envData.DT(isnan(envData.windSpd))) ;


%%
% Using filters to focus on either the high frequency (less than 40 hours) or low frequency (greater than 48-hour) 
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
fc = 1 / (40 * 3600);  % Cutoff frequency for 40-hours
filteredSnaps_lowpass = lowpass(snapRateHourly.SnapCount, fc, fs);
filteredVariables_Lowpass.snaps = lowpass(snapRateHourly.SnapCount, fc, fs);
filteredVariables_Lowpass.noise = lowpass(envData.Noise, fc, fs);
filteredVariables_Lowpass.waveheight = lowpass(envData.waveHeight, fc, fs);
filteredVariables_Lowpass.temp = lowpass(envData.Temp, fc, fs);
filteredVariables_Lowpass.windspd = lowpass(envData.windSpd, fc, fs);
filteredVariables_Lowpass.tides = lowpass(envData.crossShore, fc, fs);
%%
%Coherence: comparing the signals created by Power_spectra
% Coherence_whelch_overlap(datainA, datainB, samplinginterval, bins, windoww, DT, cutoff)
% coherences = Coherence_whelch_overlap(envData.Noise,envData.waveHeight,3600,4,1,1,0)


% Plots HF noise, windspeed, and hourly snaps to visualize the relationship.
% figure()
% tiledlayout(2,1)
% ax1 = nexttile()
% yyaxis left
% plot(envData.DT,envData.Noise,'b');
% ylabel('HF Noise')
% yyaxis right
% plot(envData.DT,envData.windSpd,'r')
% ylabel('Winds')
% title('Environmental Noise and Winds')
% ax2 = nexttile()
% plot(snapRateHourly.Time,snapRateHourly.SnapCount,'k');
% ylabel('SnapCount')
% title('Hourly Recorded Snaps')
% 
% linkaxes([ax1, ax2],'x')



%%

figure()
% yyaxis left
plot(envData.DT,envData.windSpd,'r')
hold on
ylabel('WindSpd (m/s)')
% yyaxis right
plot(envData.DT,filteredVariables_Lowpass.windspd,'k','LineWidth',2)
ylabel('Wind-Lowpass')

figure()
% yyaxis left
plot(snapRateHourly.Time,snapRateHourly.SnapCount,'r')
hold on
ylabel('Hourly Snaps')
% yyaxis right
plot(snapRateHourly.Time,filteredVariables_Lowpass.snaps,'k','LineWidth',2)
% ylabel('Snaps-Lowpass')
legend('Raw','40hr-Lowpass')

figure()
yyaxis left
plot(envData.DT,envData.Noise,'r')
ylabel('Noise')
hold on
plot(envData.DT,filteredVariables_Lowpass.noise,'k','LineWidth',2)
% ylabel('Noise-Lowpass')
legend('Raw','40hr-Lowpass')
title('Lowpass Filtered - HF Noise')

%%
% Coherence_whelch_overlap(datainA, datainB, samplinginterval, bins, windoww, DT, cutoff)
coherenceNoiseWavefilt = Coherence_whelch_overlap(filteredVariables_Lowpass.noise,filteredVariables_Lowpass.waveheight,3600,4,1,1,0)
coherenceWindWavefilt = Coherence_whelch_overlap(filteredVariables_Lowpass.windspd,filteredVariables_Lowpass.waveheight,3600,4,1,1,0)
coherenceSnapsNoisefilt = Coherence_whelch_overlap(filteredVariables_Lowpass.snaps,filteredVariables_Lowpass.noise,3600,4,1,1,0)
coherenceSnapsWindfilt = Coherence_whelch_overlap(filteredVariables_Lowpass.snaps,filteredVariables_Lowpass.windspd,3600,4,1,1,0)
coherenceSnapsTidesfilt = Coherence_whelch_overlap(filteredVariables_Lowpass.snaps,filteredVariables_Lowpass.tides,3600,4,1,1,0)
coherenceTidesNoisefilt = Coherence_whelch_overlap(filteredVariables_Lowpass.tides,filteredVariables_Lowpass.noise,3600,4,1,1,0)

% % Power spectral density of signal A, filtered Snaps
% figure()
% loglog(coherenceNoiseWavefilt.f*86400,coherenceNoiseWavefilt.psda)
% title('PSD','A')
% 
% % Power spectral density of signal B, filtered Noise
% figure()
% loglog(coherenceNoiseWavefilt.f*86400,coherenceNoiseWavefilt.psdb)
% title('PSD','B')

%Coherence between A and B
figure()
semilogx(coherenceNoiseWavefilt.f*86400,coherenceNoiseWavefilt.coh,'LineWidth',2)
hold on
% semilogx(coherenceWindWavefilt.f*86400,coherenceWindWavefilt.coh,'LineWidth',2)
semilogx(coherenceSnapsNoisefilt.f*86400,coherenceSnapsNoisefilt.coh,'LineWidth',2)
semilogx(coherenceSnapsWindfilt.f*86400,coherenceSnapsWindfilt.coh,'LineWidth',2)
% semilogx(coherenceSnapsTidesfilt.f*86400,coherenceSnapsTidesfilt.coh,'LineWidth',2)
% semilogx(coherenceTidesNoisefilt.f*86400,coherenceTidesNoisefilt.coh,'LineWidth',2)
yline(0.4128,'-','95% Significance')
legend([{'Noise-Wave'},{'Snaps-Noise'},{'Snaps-Wind'}])
% legend([{'Noise-Wave'},{'Wind-Wave'},{'Snaps-Noise'},{'Snaps-Wind'},{'Snaps-Tides'},{'Tides-Noise'}])
title('Coherence in Spring 2020','Lowpass (40hr) Filtered; 23 Day Windows')
ylabel('Coherence')
xlabel('Times Per Day')


figure()
tiledlayout(3,1)
ax1 = nexttile()
semilogx(coherenceNoiseWavefilt.f*86400,coherenceNoiseWavefilt.coh,'LineWidth',2)
yline(0.4128,'-','95% Significance')
title('Coherence','HF Noise and Waveheight')
ylim([0 1])
ax2 = nexttile()
semilogx(coherenceSnapsNoisefilt.f*86400,coherenceSnapsNoisefilt.coh,'r','LineWidth',2)
yline(0.4128)
ylabel('Coherence')
title('','Snaprate and HF Noise');
ylim([0 1])
ax3 = nexttile()
semilogx(coherenceSnapsWindfilt.f*86400,coherenceSnapsWindfilt.coh,'k','LineWidth',2)
yline(0.4128)
title('','Snaprate and Winds');
xlabel('Freq. Per Day')
ylim([0 1])
linkaxes([ax1,ax2,ax3],'x');


figure()
tiledlayout(3,1)
ax1 = nexttile()
semilogx(coherenceNoiseWavefilt.f*86400,coherenceNoiseWavefilt.phase,'LineWidth',2)
% yline(0.4128,'-','95% Significance')
title('Phase','HF Noise and Waveheight')
% ylim([0 1])
ax2 = nexttile()
semilogx(coherenceSnapsNoisefilt.f*86400,coherenceSnapsNoisefilt.phase,'r','LineWidth',2)
% yline(0.4128)
ylabel('Phase')
title('','Snaprate and HF Noise');
% ylim([0 1])
ax3 = nexttile()
semilogx(coherenceSnapsWindfilt.f*86400,coherenceSnapsWindfilt.phase,'k','LineWidth',2)
% yline(0.4128)
title('','Snaprate and Winds');
xlabel('Freq. Per Day')
% ylim([0 1])
linkaxes([ax1,ax2,ax3],'x');



figure()
semilogx(coherenceNoiseWavefilt.f*86400,coherenceNoiseWavefilt.phase)
title('Phase, Lowpass Filtered','Snaps and Windspeed')


%Converting Phase Angle to time shift.
% Phase Angle (degs) = time delay (ms) x Frequency f (Hz) x 360
% Time Delay (ms) = Phase Angle/(Freq*360)

phaseNW = rad2deg(coherenceNoiseWavefilt.phase); %converting phase from rads to degs
fs; %frequency, set above
% fs = 1/3600;
% period = 3600;
timeDelay = phaseNW/(fs*360); %Should be in seconds.
timeDelayHoursNW = timeDelay./3600;

phaseSN = rad2deg(coherenceSnapsNoisefilt.phase); %converting phase from rads to degs
fs; %frequency, set above
% fs = 1/3600;
% period = 3600;
timeDelay = phaseSN/(fs*360); %Should be in seconds.
timeDelayHoursSN = timeDelay./3600;

phaseSW = rad2deg(coherenceSnapsWindfilt.phase); %converting phase from rads to degs
fs; %frequency, set above
% fs = 1/3600;
% period = 3600;
timeDelay = phaseSW/(fs*360); %Should be in seconds.
timeDelayHoursSW = timeDelay./3600;


figure()
tiledlayout(3,1)
ax1 = nexttile()
semilogx(coherenceNoiseWavefilt.f*86400,timeDelayHoursNW,'LineWidth',2)
% yline(0.4128,'-','95% Significance')
title('Phase- Converted to HourDelay','HF Noise and Waveheight')
% ylim([0 1])
ax2 = nexttile()
semilogx(coherenceSnapsNoisefilt.f*86400,timeDelayHoursSN,'r','LineWidth',2)
% yline(0.4128)
ylabel('Phase')
title('','Snaprate and HF Noise');
% ylim([0 1])
ax3 = nexttile()
semilogx(coherenceSnapsWindfilt.f*86400,timeDelayHoursSW,'k','LineWidth',2)
% yline(0.4128)
title('','Snaprate and Winds');
xlabel('Freq. Per Day')
% ylim([0 1])
linkaxes([ax1,ax2,ax3],'x');




figure()
semilogx(coherenceNoiseWavefilt.f*86400,timeDelayHours)
title('Phase, Noise and Waveheight','Lowpass (40hr) Filtered')
ylabel('TimeDelay (hrs)')
xlabel('Times Per Day')

%%



