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
times = surfaceData.time;

% Environmental data matched to the hourly snaps.
% load envDataFall
% % Full snaprate dataset
% load snapRateDataFall
% % Snaprate binned hourly
% load snapRateHourlyFall
% % Snaprate binned per minute
% load snapRateMinuteFall
% % Separate wind and wave data
% load surfaceDataFall
% times = surfaceData.time;



% COHsnapWind = Coherence_whelch_overlap(snapRateHourly.SnapCount,surfaceData.waveHeight,3600,10,1,1,0)
% COHnoiseWave = Coherence_whelch_overlap(envData.Noise,surfaceData.waveHeight,3600,10,1,1,0)
% 
% wavePower = Power_spectra(envData.waveHeight,4,0,0,3600,0)
% snapPower = Power_spectra(snapRateHourly.SnapCount,4,0,0,3600,0)
% 
% figure()
% loglog(wavePower.f*86400,wavePower.psdf)
% title('Wave PSD')
% 
% 
% figure()
% loglog(COHnoiseWave.f*86400,COHnoiseWave.psdb)
% title('Wave PSD')
% 
% figure()
% semilogx(COHnoiseWave.f*86400,COHnoiseWave.coh)
% title('Coherence NoiseWave')
% 
% close all

%%
% I want to smooth some of the snapt data. Technically snaps are events that are counted instantly
% but binned by minute or hour.
%Fall has 137 days, Spring has 94.5 days
% FALL
% 2 Bins: 68.5  days
% 3 Bins: 45.6  days
% 4 Bins: 34.3  days
% 5 Bins: 27.4  days
% 6 Bins: 22.8  days
% 8 Bins: 17.1  days
%10 Bins: 13.7  days

% SPRING
% 2 Bins: 47.3  days
% 3 Bins: 31.5  days
% 4 Bins: 23.6  days
% 5 Bins: 18.9  days
% 6 Bins: 15.8  days
% 8 Bins: 11.8  days



%Bandpass Creation
% % Frequency cutoff for filter.
% cutoffHrs = 40;
% %Create the cutoff
% % cutoff = 1/(cutoffHrs);
% % Bandpass filtering between 40 hours and 10 days; I want to focus on the
% % effect of synoptic winds and the Spring/Neap tidal cycle on snaps, and
% % use those snaps as a proxy for noise creation.
% cutoff = [1/240; 1/40]
% filterType = 'bandpass';
% bins = 5;
% 
% [lowpassData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP...
%     powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
%     cutoff, cutoffHrs, filterType, bins, filterOrder)

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
bins = 6;
filterOrder = 4;

[filteredData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP...
    powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)

%%
%Phase
figure()
tiledlayout(2,3)
ax1 = nexttile()
semilogx(powerSnapWindLP.f*86400,powerSnapWindLP.phase);
title('Phase - SnapsWinds',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs,filterType))
% yline(powerSnapWindLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWindLP.pr95bendat))
ylim([-pi pi])
xlim([0.1 1.2])

ax2 = nexttile()
semilogx(powerSnapWaveLP.f*86400,powerSnapWaveLP.phase);
title('Phase - SnapsWaves',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins,filterOrder, cutoffHrs, filterType))
% yline(powerSnapWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWaveLP.pr95bendat))
ylim([-pi pi])
xlim([0.1 1.2])

ax3 = nexttile()
semilogx(powerWindWaveLP.f*86400,powerWindWaveLP.phase);
title('Phase - WindsWaves',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs,filterType))
% yline(powerWindWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerWindWaveLP.pr95bendat))
ylim([-pi pi])
xlim([0.1 1.2])

ax4 = nexttile()
semilogx(powerNoiseWaveLP.f*86400,powerNoiseWaveLP.phase);
title('Phase - NoiseWave');
% yline(powerNoiseWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerNoiseWaveLP.pr95bendat))
ylim([-pi pi])
xlim([0.1 1.2])

ax5 = nexttile()
semilogx(powerSnapNoiseLP.f*86400,powerSnapNoiseLP.phase);
title('Phase - SnapHFNoise');
% yline(powerSnapNoiseLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapNoiseLP.pr95bendat))
ylim([-pi pi])
xlabel('Freq: Per Day')
xlim([0.1 1.2])

ax6 = nexttile()
semilogx(powerSnapAbsTidesLP.f*86400,powerSnapAbsTidesLP.phase);
title('Phase - SnapTidalMagnitude(ABS)');
% yline(powerSnapAbsTidesLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapAbsTidesLP.pr95bendat))
ylim([-pi pi])
xlim([0.1 1.2])

linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'x')


%%
figure()
yyaxis left
plot(times,filteredData.Winds,'b','LineWidth',2)
ylabel('WSPD (m/s)')
yyaxis right
plot(times,filteredData.Noise,'r','LineWidth',2)
ylabel('HF Noise (mV)')
title(sprintf('%s Filter (1-10day) Results',filterType),'HF Noise and Windspeed')
legend('Windspeed','HF Noise')



figure()
yyaxis left
plot(times,filteredData.Winds,'b','LineWidth',2)
ylabel('WSPD (m/s)')
yyaxis right
plot(times,filteredData.Snaps,'r','LineWidth',2)
ylabel('Snaprate')
title('','Windspeeds and Snaprates')
legend('Windspeed','Hourly Snaprate')

%%
% Filter Creation
% Frequency cutoff for filter.
cutoffHrs = 20;
%Create the cutoff
% cutoff = 1/(cutoffHrs);
% Bandpass filtering between 40 hours and 10 days; I want to focus on the
% effect of synoptic winds and the Spring/Neap tidal cycle on snaps, and
% use those snaps as a proxy for noise creation.
cutoff = [1/20]
filterType = 'high';
bins = 6;
filterOrder = 6;

[filteredData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP...
    powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)


figure()
yyaxis left
plot(times,filteredData.Winds,'b','LineWidth',2)
ylabel('WSPD (m/s)')
yyaxis right
plot(times,filteredData.Noise,'r','LineWidth',2)
ylabel('HF Noise (mV)')
title(sprintf('%s Filter (1-10day) Results',filterType),'HF Noise and Windspeed')
legend('Windspeed','HF Noise')


figure()
yyaxis left
plot(times,filteredData.Winds,'b','LineWidth',2)
ylabel('WSPD (m/s)')
yyaxis right
plot(times,filteredData.Snaps,'r','LineWidth',2)
ylabel('Snaprate')
title(sprintf('%s Filter (1-10day) Results',filterType),'Windspeed and Snaprates')
legend('Windspeed','Hourly Snaprate')


figure()
semilogx(powerSnapWindLP.f*86400,powerSnapWindLP.phase)



figure()
yyaxis left
plot(times,filteredData.TidesAbsolute,'b','LineWidth',2)
ylabel('Tidal Magnitude (m/s)')
yyaxis right
plot(times,filteredData.Snaps,'r','LineWidth',2)
ylabel('Snaprate')
title(sprintf('%s Filter (1-10day) Results',filterType),'Tides and Snaprates')
legend('Tidal Magnitude','Hourly Snaprate')

