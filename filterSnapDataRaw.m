function [powerSnapWind, powerSnapWave, powerSnapNoiseLP, powerWindWave,...
    powerNoiseWaveLP,powerSnapTides,powerSnapAbsTides] = filterSnapDataRaw(envData, snapRateHourly, surfaceData, bins)



powerSnapWind   = Coherence_whelch_overlap(snapRateHourly.SnapCount,filteredData.Winds,3600,bins,1,1,1)
powerSnapWave   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Waves,3600,bins,1,1,1)
powerWindWave   = Coherence_whelch_overlap(filteredData.Winds,filteredData.Waves,3600,bins,1,1,1)
powerSnapTides = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Tides,3600,bins,1,1,1)
powerSnapAbsTides = Coherence_whelch_overlap(filteredData.Snaps,filteredData.TidesAbsolute,3600,bins,1,1,1)
% In Fall, we have more wind/tides/snaps than we do noise, so this is accounting for that difference.
if length(filteredData.Snaps) == length(filteredData.Noise)
    powerSnapNoiseLP   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Noise,3600,bins,1,1,1)
    powerNoiseWaveLP   = Coherence_whelch_overlap(filteredData.Noise,filteredData.Waves,3600,bins,1,1,1)
    %
    powerSnapNoiseLP.coh(powerSnapNoiseLP.coh < powerSnapNoiseLP.pr95bendat) = 0;
    powerNoiseWaveLP.coh(powerNoiseWaveLP.coh < powerNoiseWaveLP.pr95bendat) = 0;
    %
    powerSnapNoiseLP.phase(powerSnapNoiseLP.coh < powerSnapNoiseLP.pr95bendat) = 0;
    powerNoiseWaveLP.phase(powerNoiseWaveLP.coh < powerNoiseWaveLP.pr95bendat) = 0;
end
% This creates a placeholder if  I don't have noise data for the entire dataset.
if length(filteredData.Snaps) ~= length(filteredData.Noise)
    powerSnapNoiseLP   = NaN;
    powerNoiseWaveLP   = NaN;
end

%Frank is trying to remove non-significant peaks; it gets furry at the bottom of the Y, let's clean up.
powerSnapWind.coh(powerSnapWind.coh < powerSnapWind.pr95bendat) = 0;
powerSnapWave.coh(powerSnapWave.coh < powerSnapWave.pr95bendat) = 0;
powerWindWave.coh(powerWindWave.coh < powerWindWave.pr95bendat) = 0;
powerSnapTides.coh(powerSnapTides.coh < powerSnapTides.pr95bendat) = 0;
powerSnapAbsTides.coh(powerSnapAbsTides.coh < powerSnapAbsTides.pr95bendat) = 0;

%Frank doing the same for phases
powerSnapWind.phase(powerSnapWind.coh < powerSnapWind.pr95bendat) = 0;
powerSnapWave.phase(powerSnapWave.coh < powerSnapWave.pr95bendat) = 0;
powerWindWave.phase(powerWindWave.coh < powerWindWave.pr95bendat) = 0;
powerSnapTides.phase(powerSnapTides.coh < powerSnapTides.pr95bendat) = 0;
powerSnapAbsTides.phase(powerSnapAbsTides.coh < powerSnapAbsTides.pr95bendat) = 0;



%%
figure()
tiledlayout(2,3)
ax1 = nexttile()
semilogx(powerSnapWind.f*86400,powerSnapWind.coh);
title('Coherence - SnapsWinds',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs,filterType))
yline(powerSnapWind.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWind.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

ax2 = nexttile()
semilogx(powerSnapWave.f*86400,powerSnapWave.coh);
title('Coherence - SnapsWaves',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins,filterOrder, cutoffHrs, filterType))
yline(powerSnapWave.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWave.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

ax3 = nexttile()
semilogx(powerWindWave.f*86400,powerWindWave.coh);
title('Coherence - WindsWaves',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs,filterType))
yline(powerWindWave.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerWindWave.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

% ax4 = nexttile()
% semilogx(powerNoiseWaveLP.f*86400,powerNoiseWaveLP.coh);
% title('Coherence - NoiseWave');
% yline(powerNoiseWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerNoiseWaveLP.pr95bendat))
% ylim([0 0.9])
% xlim([0.1 1.2])

% ax5 = nexttile()
% semilogx(powerSnapNoiseLP.f*86400,powerSnapNoiseLP.coh);
% title('Coherence - SnapHFNoise');
% yline(powerSnapNoiseLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapNoiseLP.pr95bendat))
% ylim([0 0.9])
% xlabel('Freq: Per Day')
% xlim([0.1 1.2])

ax6 = nexttile()
semilogx(powerSnapAbsTides.f*86400,powerSnapAbsTides.coh);
title('Coherence - SnapTidalMagnitude(ABS)');
yline(powerSnapAbsTides.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapAbsTides.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

% linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'x')
linkaxes([ax1,ax2,ax3,ax6],'x')
%%

figure()
tiledlayout(2,1)
ax1 = nexttile()
semilogx(powerSnapTides.f*86400,powerSnapTides.coh);
title('Coherence - SnapTidalVelocity',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder,cutoffHrs, filterType));
yline(powerSnapTides.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapTides.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

ax2 = nexttile()
semilogx(powerSnapAbsTides.f*86400,powerSnapAbsTides.coh);
title('Coherence - SnapTidalMagnitude',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs, filterType));
yline(powerSnapAbsTides.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapAbsTides.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

%%
figure()
loglog(powerSnapWind.f*86400,powerSnapWind.psda,'b','LineWidth',2);
hold on
loglog(powerSnapWind.f*86400,powerSnapWind.psdb,'r','LineWidth',2);
loglog(powerSnapWave.f*86400,powerSnapWave.psdb,'k','LineWidth',2);
loglog(powerSnapTides.f*86400,powerSnapTides.psdb,'m','LineWidth',2);
loglog(powerSnapAbsTides.f*86400,powerSnapAbsTides.psdb,'g','LineWidth',2)
% loglog(powerNoiseWaveLP.f*86400,powerNoiseWaveLP.psda,'c','LineWidth',2)
% legend('Snaps','Winds','Waveheight','Tides','AbsTideMagnitude','Noise')
legend('Snaps','Winds','Waveheight','Tides','AbsTideMagnitude')
title('Power Spectral Density',sprintf('Per Day: %d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs, filterType));

