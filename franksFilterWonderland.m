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

close all

%%
% Creating and using a better filter now.

% Frequency cutoff for filter.
cutoffHrs = 40;
%Create the cutoff
% cutoff = 1/(cutoffHrs);
cutoff = [1/240; 1/40]
filterType = 'bandpass';
bins = 4;

[lowpassData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP...
    powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins)









