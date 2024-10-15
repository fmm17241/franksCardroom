function [lowpassData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP...
    powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins)



[b24,a24] = butter(4,cutoff,filterType);
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


windLowPass  = Power_spectra(lowpassData.Winds,bins,0,0,3600,0)
snapsLowPass = Power_spectra(lowpassData.Snaps,bins,0,0,3600,0)


figure()
loglog(snapsLowPass.f*86400,snapsLowPass.psdw,'LineWidth',3)
hold on
loglog(windLowPass.f*86400,windLowPass.psdw)
legend('Snaps','Winds')


powerSnapWindLP   = Coherence_whelch_overlap(lowpassData.Snaps,lowpassData.Winds,3600,bins,1,1,1)
powerSnapWaveLP   = Coherence_whelch_overlap(lowpassData.Snaps,lowpassData.Waves,3600,bins,1,1,1)
powerSnapNoiseLP   = Coherence_whelch_overlap(lowpassData.Snaps,lowpassData.Noise,3600,bins,1,1,1)
powerWindWaveLP   = Coherence_whelch_overlap(lowpassData.Winds,lowpassData.Waves,3600,bins,1,1,1)
powerNoiseWaveLP   = Coherence_whelch_overlap(lowpassData.Noise,lowpassData.Waves,3600,bins,1,1,1)
powerSnapTidesLP = Coherence_whelch_overlap(lowpassData.Snaps,lowpassData.Tides,3600,bins,1,1,1)
powerSnapAbsTidesLP = Coherence_whelch_overlap(lowpassData.Noise,lowpassData.TidesAbsolute,3600,bins,1,1,1)


figure()
tiledlayout(2,3)
ax1 = nexttile()
semilogx(powerSnapWindLP.f*86400,powerSnapWindLP.coh);
title('Coherence - SnapsWinds',sprintf('%d Bins, %d Hr Lowpass',bins,cutoffHrs))
yline(powerSnapWindLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWindLP.pr95bendat))
ylim([0 0.9])

ax2 = nexttile()
semilogx(powerSnapWaveLP.f*86400,powerSnapWaveLP.coh);
title('Coherence - SnapsWaves',sprintf('%d Bins, %d Hr Lowpass',bins,cutoffHrs))
yline(powerSnapWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWaveLP.pr95bendat))
ylim([0 0.9])


ax3 = nexttile()
semilogx(powerWindWaveLP.f*86400,powerWindWaveLP.coh);
title('Coherence - WindsWaves',sprintf('%d Bins, %d Hr Lowpass',bins,cutoffHrs))
yline(powerWindWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerWindWaveLP.pr95bendat))
ylim([0 0.9])


ax4 = nexttile()
semilogx(powerNoiseWaveLP.f*86400,powerNoiseWaveLP.coh);
title('Coherence - NoiseWave');
yline(powerNoiseWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerNoiseWaveLP.pr95bendat))
ylim([0 0.9])


ax5 = nexttile()
semilogx(powerSnapNoiseLP.f*86400,powerSnapNoiseLP.coh);
title('Coherence - SnapNoise');
yline(powerSnapNoiseLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapNoiseLP.pr95bendat))
ylim([0 0.9])
xlabel('Freq: Per Day')

ax6 = nexttile()
semilogx(powerSnapAbsTidesLP.f*86400,powerSnapAbsTidesLP.coh);
title('Coherence - SnapTidalMagnitude');
yline(powerSnapAbsTidesLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapAbsTidesLP.pr95bendat))
ylim([0 0.9])


figure()
tiledlayout(2,1)
ax1 = nexttile()
semilogx(powerSnapTidesLP.f*86400,powerSnapTidesLP.coh);
title('Coherence - SnapTidalVelocity',sprintf('%d Bins, %d Hr Lowpass',bins,cutoffHrs));
yline(powerSnapTidesLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapTidesLP.pr95bendat))
ylim([0 0.9])

ax2 = nexttile()
semilogx(powerSnapAbsTidesLP.f*86400,powerSnapAbsTidesLP.coh);
title('Coherence - SnapTidalMagnitude',sprintf('%d Bins, %d Hr Lowpass',bins,cutoffHrs));
yline(powerSnapAbsTidesLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapAbsTidesLP.pr95bendat))
ylim([0 0.9])



