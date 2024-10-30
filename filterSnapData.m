function [filteredData, powerSnapWindFilt, powerSnapWaveFilt, powerSnapNoiseFilt, powerWindWaveFilt,...
    powerNoiseWaveFilt,powerSnapTidesFilt,powerSnapAbsTidesFilt,powerSnapSBLcappedFilt] = filterSnapData(envData, snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)



[Bsignal,Asignal] = butter(filterOrder,cutoff,filterType);
%Apply the filter
filteredData.Snaps = filtfilt(Bsignal,Asignal,snapRateHourly.SnapCount);
filteredData.Noise = filtfilt(Bsignal,Asignal,envData.Noise);
filteredData.Winds = filtfilt(Bsignal,Asignal,surfaceData.WSPD);
filteredData.Waves = filtfilt(Bsignal,Asignal,surfaceData.waveHeight);
filteredData.Tides  = filtfilt(Bsignal,Asignal,surfaceData.crossShore);
filteredData.TidesAbsolute = filtfilt(Bsignal,Asignal,abs(surfaceData.crossShore));
filteredData.WindDir = filtfilt(Bsignal,Asignal,surfaceData.WDIR);
filteredData.SBL = filtfilt(Bsignal,Asignal,surfaceData.SBL);
filteredData.SBLcapped = filtfilt(Bsignal,Asignal,surfaceData.SBLcapped);
filteredData.Detections = filtfilt(Bsignal,Asignal,envData.HourlyDets);
filteredData.SST = filtfilt(Bsignal,Asignal,surfaceData.SST);
filteredData.BottomTemp = filtfilt(Bsignal,Asignal,envData.Temp);

% figure()
% plot(snapRateHourly.Time,snapRateHourly.SnapCount,'LineWidth',1)
% hold on
% plot(snapRateHourly.Time,filteredData.Snaps,'LineWidth',3)


windLowPass  = Power_spectra(filteredData.Winds,bins,0,0,3600,0)
snapsLowPass = Power_spectra(filteredData.Snaps,bins,0,0,3600,0)


% figure()
% loglog(snapsLowPass.f*86400,snapsLowPass.psdw,'LineWidth',3)
% hold on
% loglog(windLowPass.f*86400,windLowPass.psdw)
% legend('Snaps','Winds')


powerSnapWindFilt   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Winds,3600,bins,1,1,1)
powerSnapWaveFilt   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Waves,3600,bins,1,1,1)
powerWindWaveFilt   = Coherence_whelch_overlap(filteredData.Winds,filteredData.Waves,3600,bins,1,1,1)
powerSnapTidesFilt = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Tides,3600,bins,1,1,1)
powerSnapAbsTidesFilt = Coherence_whelch_overlap(filteredData.Snaps,filteredData.TidesAbsolute,3600,bins,1,1,1)
powerWaveWindDirFilt = Coherence_whelch_overlap(filteredData.Waves,filteredData.WindDir,3600,bins,1,1,1)
powerSnapSBLcappedFilt   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.SBLcapped,3600,bins,1,1,1)
powerSnapSBLFilt   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.SBL,3600,bins,1,1,1)
powerSnapTempFilt    = Coherence_whelch_overlap(filteredData.Snaps,filteredData.SST,3600,bins,1,1,1)

% In Fall, we have more wind/tides/snaps than we do noise, so this is accounting for that difference.
if length(filteredData.Snaps) == length(filteredData.Noise)
    powerSnapNoiseFilt   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Noise,3600,bins,1,1,1)
    powerNoiseWaveFilt   = Coherence_whelch_overlap(filteredData.Noise,filteredData.Waves,3600,bins,1,1,1)
    %
    powerSnapNoiseFilt.coh(powerSnapNoiseFilt.coh < powerSnapNoiseFilt.pr95bendat) = 0;
    powerNoiseWaveFilt.coh(powerNoiseWaveFilt.coh < powerNoiseWaveFilt.pr95bendat) = 0;
    %
    powerSnapNoiseFilt.phase(powerSnapNoiseFilt.coh < powerSnapNoiseFilt.pr95bendat) = 0;
    powerNoiseWaveFilt.phase(powerNoiseWaveFilt.coh < powerNoiseWaveFilt.pr95bendat) = 0;
end
% This creates a placeholder if  I don't have noise data for the entire dataset.
if length(filteredData.Snaps) ~= length(filteredData.Noise)
    powerSnapNoiseFilt   = NaN;
    powerNoiseWaveFilt   = NaN;
end

%Frank is trying to remove non-significant peaks; it gets furry at the bottom of the Y, let's clean up.
powerSnapWindFilt.coh(powerSnapWindFilt.coh < powerSnapWindFilt.pr95bendat) = 0;
powerSnapWaveFilt.coh(powerSnapWaveFilt.coh < powerSnapWaveFilt.pr95bendat) = 0;
powerWindWaveFilt.coh(powerWindWaveFilt.coh < powerWindWaveFilt.pr95bendat) = 0;
powerSnapTidesFilt.coh(powerSnapTidesFilt.coh < powerSnapTidesFilt.pr95bendat) = 0;
powerSnapAbsTidesFilt.coh(powerSnapAbsTidesFilt.coh < powerSnapAbsTidesFilt.pr95bendat) = 0;
powerWaveWindDirFilt.coh(powerWaveWindDirFilt.coh < powerWaveWindDirFilt.pr95bendat) = 0;
powerSnapSBLFilt.coh(powerSnapSBLFilt.coh < powerSnapSBLFilt.pr95bendat) = 0;
powerSnapSBLcappedFilt.coh(powerSnapSBLcappedFilt.coh < powerSnapSBLcappedFilt.pr95bendat) = 0;
powerSnapTempFilt.coh(powerSnapTempFilt.coh < powerSnapTempFilt.pr95bendat) = 0;

%Frank doing the same for phases
powerSnapWindFilt.phase(powerSnapWindFilt.coh < powerSnapWindFilt.pr95bendat) = 0;
powerSnapWaveFilt.phase(powerSnapWaveFilt.coh < powerSnapWaveFilt.pr95bendat) = 0;
powerWindWaveFilt.phase(powerWindWaveFilt.coh < powerWindWaveFilt.pr95bendat) = 0;
powerSnapTidesFilt.phase(powerSnapTidesFilt.coh < powerSnapTidesFilt.pr95bendat) = 0;
powerSnapAbsTidesFilt.phase(powerSnapAbsTidesFilt.coh < powerSnapAbsTidesFilt.pr95bendat) = 0;
powerSnapSBLFilt.phase(powerSnapSBLFilt.coh < powerSnapSBLFilt.pr95bendat) = 0;
powerSnapSBLcappedFilt.phase(powerSnapSBLcappedFilt.coh < powerSnapSBLcappedFilt.pr95bendat) = 0;
powerSnapTempFilt.phase(powerSnapTempFilt.coh < powerSnapTempFilt.pr95bendat) = 0;

%%
figure()
tiledlayout(2,3)
ax1 = nexttile()
semilogx(powerSnapWindFilt.f*86400,powerSnapWindFilt.coh);
title('Coherence - SnapsWinds',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs,filterType))
yline(powerSnapWindFilt.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWindFilt.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

ax2 = nexttile()
semilogx(powerSnapWaveFilt.f*86400,powerSnapWaveFilt.coh);
title('Coherence - SnapsWaves',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins,filterOrder, cutoffHrs, filterType))
yline(powerSnapWaveFilt.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWaveFilt.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

ax3 = nexttile()
semilogx(powerWindWaveFilt.f*86400,powerWindWaveFilt.coh);
title('Coherence - WindsWaves',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs,filterType))
yline(powerWindWaveFilt.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerWindWaveFilt.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

ax4 = nexttile()
semilogx(powerNoiseWaveFilt.f*86400,powerNoiseWaveFilt.coh);
title('Coherence - NoiseWave');
yline(powerNoiseWaveFilt.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerNoiseWaveFilt.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

ax5 = nexttile()
semilogx(powerSnapNoiseFilt.f*86400,powerSnapNoiseFilt.coh);
title('Coherence - SnapHFNoise');
yline(powerSnapNoiseFilt.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapNoiseFilt.pr95bendat))
ylim([0 0.9])
xlabel('Freq: Per Day')
xlim([0.1 1.2])

ax6 = nexttile()
semilogx(powerWaveWindDirFilt.f*86400,powerWaveWindDirFilt.coh);
title('Coherence - Waves and Wind Dir');
yline(powerWaveWindDirFilt.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerWaveWindDirFilt.pr95bendat))
ylim([0 0.9])
xlim([0.1 1.2])

linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'x')
% linkaxes([ax1,ax2,ax3,ax6],'x')
%%

figure()
tiledlayout(2,1)
ax1 = nexttile()
semilogx(powerSnapTidesFilt.f*86400,powerSnapTidesFilt.coh);
title('Coherence - SnapTidalVelocity',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder,cutoffHrs, filterType));
yline(powerSnapTidesFilt.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapTidesFilt.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

ax2 = nexttile()
semilogx(powerSnapAbsTidesFilt.f*86400,powerSnapAbsTidesFilt.coh);
title('Coherence - SnapTidalMagnitude',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs, filterType));
yline(powerSnapAbsTidesFilt.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapAbsTidesFilt.pr95bendat))
ylim([0 0.9])
% xlim([0.1 1.1])

%%
figure()
loglog(powerSnapWindFilt.f*86400,powerSnapWindFilt.psda,'b','LineWidth',2);
hold on
loglog(powerSnapWindFilt.f*86400,powerSnapWindFilt.psdb,'r','LineWidth',2);
loglog(powerSnapWaveFilt.f*86400,powerSnapWaveFilt.psdb,'k','LineWidth',2);
loglog(powerSnapTidesFilt.f*86400,powerSnapTidesFilt.psdb,'m','LineWidth',2);
% loglog(powerSnapAbsTidesFilt.f*86400,powerSnapAbsTidesFilt.psdb,'g','LineWidth',2)
loglog(powerNoiseWaveFilt.f*86400,powerNoiseWaveFilt.psda,'c','LineWidth',2)
loglog(powerSnapSBLcappedFilt.f*86400,powerSnapSBLcappedFilt.psdb,'g','LineWidth',2)
legend('Snaps','Winds','Waveheight','Tides','Noise','SBL')
% legend('Snaps','Winds','Waveheight','Tides','AbsTideMagnitude')
title('Power Spectral Density',sprintf('Per Day: %d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs, filterType));


