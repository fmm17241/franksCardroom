function [powerSnapWind, powerSnapWave, powerSnapNoise, powerWindWave,...
    powerNoiseWave,powerSnapTides,powerSnapAbsTides] = filterSnapDataRaw(envData, snapRateHourly, surfaceData, bins)



powerSnapWind   = Coherence_whelch_overlap(snapRateHourly.SnapCount,surfaceData.WSPD,3600,bins,1,1,1)
powerSnapWave   = Coherence_whelch_overlap(snapRateHourly.SnapCount,surfaceData.waveHeight,3600,bins,1,1,1)
powerWindWave   = Coherence_whelch_overlap(surfaceData.WSPD,surfaceData.waveHeight,3600,bins,1,1,1)
powerSnapTides = Coherence_whelch_overlap(snapRateHourly.SnapCount,surfaceData.crossShore,3600,bins,1,1,1)
powerSnapAbsTides = Coherence_whelch_overlap(snapRateHourly.SnapCount,abs(surfaceData.crossShore),3600,bins,1,1,1)
% In Fall, we have more wind/tides/snaps than we do noise, so this is accounting for that difference.
if length(snapRateHourly.SnapCount) == length(envData.Noise)
    powerSnapNoise   = Coherence_whelch_overlap(snapRateHourly.SnapCount,envData.Noise,3600,bins,1,1,1)
    powerNoiseWave   = Coherence_whelch_overlap(envData.Noise,surfaceData.waveHeight,3600,bins,1,1,1)
    %
    powerSnapNoise.coh(powerSnapNoise.coh < powerSnapNoise.pr95bendat) = 0;
    powerNoiseWave.coh(powerNoiseWave.coh < powerNoiseWave.pr95bendat) = 0;
    %
    powerSnapNoise.phase(powerSnapNoise.coh < powerSnapNoise.pr95bendat) = 0;
    powerNoiseWave.phase(powerNoiseWave.coh < powerNoiseWave.pr95bendat) = 0;
end
% This creates a placeholder if  I don't have noise data for the entire dataset.
if length(snapRateHourly.SnapCount) ~= length(envData.Noise)
    powerSnapNoise   = NaN;
    powerNoiseWave   = NaN;
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
title('Coherence - SnapsWinds',sprintf('%d Bins',bins))
yline(powerSnapWind.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWind.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

ax2 = nexttile()
semilogx(powerSnapWave.f*86400,powerSnapWave.coh);
title('Coherence - SnapsWaves',sprintf('%d Bins',bins))
yline(powerSnapWave.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWave.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

ax3 = nexttile()
semilogx(powerWindWave.f*86400,powerWindWave.coh);
title('Coherence - WindsWaves',sprintf('%d Bins',bins))
yline(powerWindWave.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerWindWave.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

ax4 = nexttile()
semilogx(powerNoiseWave.f*86400,powerNoiseWave.coh);
title('Coherence - NoiseWave');
yline(powerNoiseWave.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerNoiseWave.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

ax5 = nexttile()
semilogx(powerSnapNoise.f*86400,powerSnapNoise.coh);
title('Coherence - SnapHFNoise');
yline(powerSnapNoise.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapNoise.pr95bendat))
ylim([0 0.9])
xlabel('Freq: Per Day')
xlim([0.1 1.2])

ax6 = nexttile()
semilogx(powerSnapAbsTides.f*86400,powerSnapAbsTides.coh);
title('Coherence - SnapTidalMagnitude(ABS)');
yline(powerSnapAbsTides.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapAbsTides.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'x')
% linkaxes([ax1,ax2,ax3,ax6],'x')
%%

figure()
tiledlayout(2,1)
ax1 = nexttile()
semilogx(powerSnapTides.f*86400,powerSnapTides.coh);
title('Coherence - SnapTidalVelocity',sprintf('%d Bins',bins));
yline(powerSnapTides.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapTides.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

ax2 = nexttile()
semilogx(powerSnapAbsTides.f*86400,powerSnapAbsTides.coh);
title('Coherence - SnapTidalMagnitude',sprintf('%d Bins',bins));
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
loglog(powerNoiseWave.f*86400,powerNoiseWave.psda,'c','LineWidth',2)
legend('Snaps','Winds','Waveheight','Tides','AbsTideMagnitude','Noise')
legend('Snaps','Winds','Waveheight','Tides','AbsTideMagnitude')
title('Power Spectral Density',sprintf('Per Day: %d Bins',bins));

