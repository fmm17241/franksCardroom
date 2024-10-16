function [filteredData, powerSnapWindLP, powerSnapWaveLP, powerSnapNoiseLP, powerWindWaveLP,...
    powerNoiseWaveLP,powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)



[Bsignal,Asignal] = butter(filterOrder,cutoff,filterType);
%Apply the filter
filteredData.Snaps = filtfilt(Bsignal,Asignal,snapRateHourly.SnapCount);
filteredData.Noise = filtfilt(Bsignal,Asignal,envData.Noise);
filteredData.Winds = filtfilt(Bsignal,Asignal,surfaceData.WSPD);
filteredData.Waves = filtfilt(Bsignal,Asignal,surfaceData.waveHeight);
filteredData.Tides  = filtfilt(Bsignal,Asignal,surfaceData.crossShore);
filteredData.TidesAbsolute = filtfilt(Bsignal,Asignal,abs(surfaceData.crossShore));



figure()
plot(snapRateHourly.Time,snapRateHourly.SnapCount,'LineWidth',1)
hold on
plot(snapRateHourly.Time,filteredData.Snaps,'LineWidth',3)


windLowPass  = Power_spectra(filteredData.Winds,bins,0,0,3600,0)
snapsLowPass = Power_spectra(filteredData.Snaps,bins,0,0,3600,0)


figure()
loglog(snapsLowPass.f*86400,snapsLowPass.psdw,'LineWidth',3)
hold on
loglog(windLowPass.f*86400,windLowPass.psdw)
legend('Snaps','Winds')


powerSnapWindLP   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Winds,3600,bins,1,1,1)
powerSnapWaveLP   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Waves,3600,bins,1,1,1)
powerWindWaveLP   = Coherence_whelch_overlap(filteredData.Winds,filteredData.Waves,3600,bins,1,1,1)
powerSnapTidesLP = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Tides,3600,bins,1,1,1)
powerSnapAbsTidesLP = Coherence_whelch_overlap(filteredData.Snaps,filteredData.TidesAbsolute,3600,bins,1,1,1)
% In Fall, we have more wind/tides/snaps than we do noise, so this is accounting for that difference.
if length(filteredData.Snaps) == length(filteredData.Noise)
    powerSnapNoiseLP   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Noise,3600,bins,1,1,1)
    powerNoiseWaveLP   = Coherence_whelch_overlap(filteredData.Noise,filteredData.Waves,3600,bins,1,1,1)
    %
    powerSnapNoiseLP.coh(powerSnapNoiseLP.coh < powerSnapNoiseLP.pr95bendat) = 0;
    powerNoiseWaveLP.coh(powerNoiseWaveLP.coh < powerNoiseWaveLP.pr95bendat) = 0;
end
% This creates a placeholder if  I don't have noise data for the entire dataset.
if length(filteredData.Snaps) ~= length(filteredData.Noise)
    powerSnapNoiseLP   = NaN;
    powerNoiseWaveLP   = NaN;
end

%Frank is trying to remove non-significant peaks; it gets furry at the bottom of the Y, let's clean up.
powerSnapWindLP.coh(powerSnapWindLP.coh < powerSnapWindLP.pr95bendat) = 0;
powerSnapWaveLP.coh(powerSnapWaveLP.coh < powerSnapWaveLP.pr95bendat) = 0;
powerWindWaveLP.coh(powerWindWaveLP.coh < powerWindWaveLP.pr95bendat) = 0;
powerSnapTidesLP.coh(powerSnapTidesLP.coh < powerSnapTidesLP.pr95bendat) = 0;
powerSnapAbsTidesLP.coh(powerSnapAbsTidesLP.coh < powerSnapAbsTidesLP.pr95bendat) = 0;




%%
figure()
tiledlayout(2,3)
ax1 = nexttile()
semilogx(powerSnapWindLP.f*86400,powerSnapWindLP.coh);
title('Coherence - SnapsWinds',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs,filterType))
yline(powerSnapWindLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWindLP.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

ax2 = nexttile()
semilogx(powerSnapWaveLP.f*86400,powerSnapWaveLP.coh);
title('Coherence - SnapsWaves',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins,filterOrder, cutoffHrs, filterType))
yline(powerSnapWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWaveLP.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

ax3 = nexttile()
semilogx(powerWindWaveLP.f*86400,powerWindWaveLP.coh);
title('Coherence - WindsWaves',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs,filterType))
yline(powerWindWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerWindWaveLP.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

ax4 = nexttile()
semilogx(powerNoiseWaveLP.f*86400,powerNoiseWaveLP.coh);
title('Coherence - NoiseWave');
yline(powerNoiseWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerNoiseWaveLP.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

ax5 = nexttile()
semilogx(powerSnapNoiseLP.f*86400,powerSnapNoiseLP.coh);
title('Coherence - SnapNoise');
yline(powerSnapNoiseLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapNoiseLP.pr95bendat))
ylim([0 0.9])
xlabel('Freq: Per Day')
% xlim([0.1 1.1])

ax6 = nexttile()
semilogx(powerSnapAbsTidesLP.f*86400,powerSnapAbsTidesLP.coh);
title('Coherence - SnapTidalMagnitude');
yline(powerSnapAbsTidesLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapAbsTidesLP.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'x')

%%

figure()
tiledlayout(2,1)
ax1 = nexttile()
semilogx(powerSnapTidesLP.f*86400,powerSnapTidesLP.coh);
title('Coherence - SnapTidalVelocity',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder,cutoffHrs, filterType));
yline(powerSnapTidesLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapTidesLP.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

ax2 = nexttile()
semilogx(powerSnapAbsTidesLP.f*86400,powerSnapAbsTidesLP.coh);
title('Coherence - SnapTidalMagnitude',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs, filterType));
yline(powerSnapAbsTidesLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapAbsTidesLP.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

%%
figure()
loglog(powerSnapWindLP.f*86400,powerSnapWindLP.psda,'b','LineWidth',2);
hold on
loglog(powerSnapWindLP.f*86400,powerSnapWindLP.psdb,'r','LineWidth',2);
loglog(powerSnapWaveLP.f*86400,powerSnapWaveLP.psdb,'k','LineWidth',2);
loglog(powerSnapTidesLP.f*86400,powerSnapTidesLP.psdb,'m','LineWidth',2);
loglog(powerSnapAbsTidesLP.f*86400,powerSnapAbsTidesLP.psdb,'g','LineWidth',2)
loglog(powerNoiseWaveLP.f*86400,powerNoiseWaveLP.psda,'c','LineWidth',2)
legend('Snaps','Winds','Waveheight','Tides','AbsTideMagnitude','Noise')
title('Power Spectral Density',sprintf('Per Day: %d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs, filterType));


