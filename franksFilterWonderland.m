%
% I'm tired, but I have to try and test my filtering. I tried to use lowpass() but clearly something was wrong. 
% After applying a 40-hr lowpass filter, I could still find power and coherence at a diurnal and semidiurnal frequency.
% Instead of lowpass(), I'm going to try creating and applying a butterworth filter.
% I believe I've tried that before, but I'm flawed and need to figure it out.

% Load in data.
fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

% Environmental data matched to the hourly snaps.
load envDataSpring
% Full snaprate dataset
load snapRateDataSpring
% Snaprate binned hourly
load snapRateHourlySpring
% Snaprate binned per minute
load snapRateMinuteSpring
% Separate wind and wave data
load surfaceDataSpring



COHsnapWind = Coherence_whelch_overlap(snapRateHourly.SnapCount,surfaceData.waveHeight,3600,10,1,1,0)
COHnoiseWave = Coherence_whelch_overlap(envData.Noise,surfaceData.waveHeight,3600,10,1,1,0)

wavePower = Power_spectra(envData.waveHeight,4,0,0,3600,0)
snapPower = Power_spectra(snapRateHourly.SnapCount,4,0,0,3600,0)

figure()
loglog(wavePower.f*86400,wavePower.psdf)
title('Wave PSD')


figure()
loglog(COHnoiseWave.f*86400,COHnoiseWave.psdb)
title('Wave PSD')

figure()
semilogx(COHnoiseWave.f*86400,COHnoiseWave.coh)
title('Coherence NoiseWave')

%%
% Okay, we've got all this set. I created and plotted some PSDs for the raw data.
% Now, lets try to filter.

% This is the way frank approached it.
% fs = 1 / 3600;  % Sampling frequency in Hz (1 sample per hour)
% fc = 1 / (40 * 3600);  % Cutoff frequency for 40-hour period in Hz
% filteredVar_Lowpass.Snaps = lowpass(snapRateHourly.SnapCount, fc, fs);
% filteredVar_Lowpass.Noise = lowpass(envData.Noise, fc, fs);
% filteredVar_Lowpass.waveHeight = lowpass(surfaceData.waveHeight, fc, fs);
% filteredVar_Lowpass.Windspd = lowpass(surfaceData.WSPD, fc, fs);
% 
% 
% wavePowerFilt = Power_spectra(filteredVar_Lowpass.waveHeight,4,0,0,3600,0)
% 
% %This is odd because diurnal still exists, after trying to filter past 40 hours. Banananananas.
% figure()
% loglog(wavePowerFilt.f*86400,wavePowerFilt.psdf)


%%
% Creating and using a better filter now.
% Confused whether I need to go 1/(3600*40). 1/40 seems to work.

% Anything lower than 24-hour frequencies
cutoff = 1/(24);

%Create the lowpass filter
[b24,a24] = butter(4,cutoff,'low');
%Apply the filter
lowpassData.Snaps = filtfilt(b24,a24,snapRateHourly.SnapCount);
lowpassData.Noise = filtfilt(b24,a24,envData.Noise);
lowpassData.Winds = filtfilt(b24,a24,envData.windSpd);
lowpassData.Waves = filtfilt(b24,a24,envData.waveHeight);
lowpassData.Tides  = filtfilt(b24,a24,envData.crossShore);
lowpassData.TidesAbsolute = filtfilt(b24,a24,abs(envData.crossShore));





figure()
plot(snapRateHourly.Time,snapRateHourly.SnapCount,'LineWidth',1)
hold on
plot(snapRateHourly.Time,lowpassData.Snaps,'LineWidth',3)


windLowPass  = Power_spectra(lowpassData.Winds,4,0,0,3600,0)
snapsLowPass = Power_spectra(lowpassData.Snaps,4,0,0,3600,0)


figure()
loglog(snapsLowPass.f*86400,snapsLowPass.psdw,'LineWidth',3)
hold on
loglog(windLowPass.f*86400,windLowPass.psdw)
legend('Snaps','Winds')


powerSnapWindLP   = Coherence_whelch_overlap(lowpassData.Snaps,lowpassData.Winds,3600,4,1,1,1)
powerSnapWaveLP   = Coherence_whelch_overlap(lowpassData.Snaps,lowpassData.Waves,3600,4,1,1,1)
powerSnapNoiseLP   = Coherence_whelch_overlap(lowpassData.Snaps,lowpassData.Noise,3600,4,1,1,1)
powerWindWaveLP   = Coherence_whelch_overlap(lowpassData.Winds,lowpassData.Waves,3600,4,1,1,1)
powerNoiseWaveLP   = Coherence_whelch_overlap(lowpassData.Noise,lowpassData.Waves,3600,4,1,1,1)
powerSnapTidesLP = Coherence_whelch_overlap(lowpassData.Snaps,lowpassData.Tides,3600,4,1,1,1)
powerSnapAbsTidesLP = Coherence_whelch_overlap(lowpassData.Noise,lowpassData.TidesAbsolute,3600,4,1,1,1)


figure()
tiledlayout(2,3)
ax1 = nexttile()
semilogx(powerSnapWindLP.f*86400,powerSnapWindLP.coh);
title('Coherence - SnapsWinds','24 Hr Lowpass')
yline(powerSnapWindLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWindLP.pr95bendat))
ylim([0 0.9])

ax2 = nexttile()
semilogx(powerSnapWaveLP.f*86400,powerSnapWaveLP.coh);
title('Coherence - SnapsWaves','24 Hr Lowpass')
yline(powerSnapWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWaveLP.pr95bendat))
ylim([0 0.9])


ax3 = nexttile()
semilogx(powerWindWaveLP.f*86400,powerWindWaveLP.coh);
title('Coherence - WindsWaves','24 Hr Lowpass')
yline(powerWindWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerWindWaveLP.pr95bendat))
ylim([0 0.9])


ax4 = nexttile()
semilogx(powerNoiseWaveLP.f*86400,powerNoiseWaveLP.coh);
title('Coherence - NoiseWave','24 Hr Lowpass')
yline(powerNoiseWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerNoiseWaveLP.pr95bendat))
ylim([0 0.9])


ax5 = nexttile()
semilogx(powerSnapNoiseLP.f*86400,powerSnapNoiseLP.coh);
title('Coherence - SnapNoise','24 Hr Lowpass')
yline(powerSnapNoiseLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapNoiseLP.pr95bendat))
ylim([0 0.9])

ax6 = nexttile()
semilogx(powerSnapAbsTidesLP.f*86400,powerSnapAbsTidesLP.coh);
title('Coherence - SnapTidalMagnitude','24 Hr Lowpass')
yline(powerSnapAbsTidesLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapAbsTidesLP.pr95bendat))
ylim([0 0.9])


figure()
tiledlayout(2,1)
ax1 = nexttile()
semilogx(powerSnapTidesLP.f*86400,powerSnapTidesLP.coh);
title('Coherence - SnapTidalVelocity','24 Hr Lowpass')
yline(powerSnapTidesLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapTidesLP.pr95bendat))
ylim([0 0.9])

ax2 = nexttile()
semilogx(powerSnapAbsTidesLP.f*86400,powerSnapAbsTidesLP.coh);
title('Coherence - SnapTidalMagnitude','24 Hr Lowpass')
yline(powerSnapAbsTidesLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapAbsTidesLP.pr95bendat))
ylim([0 0.9])










