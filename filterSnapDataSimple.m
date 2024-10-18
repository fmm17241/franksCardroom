function [filteredData, powerSnapWindLP, powerSnapWaveLP, powerWindWaveLP,...
    powerSnapTidesLP,powerSnapAbsTidesLP] = filterSnapDataSimple(snapRateHourly, surfaceData,...
    cutoff, cutoffHrs, filterType, bins, filterOrder)



[Bsignal,Asignal] = butter(filterOrder,cutoff,filterType);
%Apply the filter
filteredData.Snaps = filtfilt(Bsignal,Asignal,snapRateHourly.SnapCount);
filteredData.Winds = filtfilt(Bsignal,Asignal,surfaceData.WSPD);
filteredData.Waves = filtfilt(Bsignal,Asignal,surfaceData.waveHeight);
filteredData.Tides  = filtfilt(Bsignal,Asignal,surfaceData.crossShore);
filteredData.TidesAbsolute = filtfilt(Bsignal,Asignal,abs(surfaceData.crossShore));
filteredData.WindDir = filtfilt(Bsignal,Asignal,surfaceData.WDIR);


% figure()
% loglog(snapsLowPass.f*86400,snapsLowPass.psdw,'LineWidth',3)
% hold on
% loglog(windLowPass.f*86400,windLowPass.psdw)
% legend('Snaps','Winds')


powerSnapWindLP   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Winds,3600,bins,1,1,1)
powerSnapWaveLP   = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Waves,3600,bins,1,1,1)
powerWindWaveLP   = Coherence_whelch_overlap(filteredData.Winds,filteredData.Waves,3600,bins,1,1,1)
powerSnapTidesLP = Coherence_whelch_overlap(filteredData.Snaps,filteredData.Tides,3600,bins,1,1,1)
powerSnapAbsTidesLP = Coherence_whelch_overlap(filteredData.Snaps,filteredData.TidesAbsolute,3600,bins,1,1,1)
powerWaveWindDirLP = Coherence_whelch_overlap(filteredData.Waves,filteredData.WindDir,3600,bins,1,1,1)

%Frank is trying to remove non-significant peaks; it gets furry at the bottom of the Y, let's clean up.
powerSnapWindLP.coh(powerSnapWindLP.coh < powerSnapWindLP.pr95bendat) = 0;
powerSnapWaveLP.coh(powerSnapWaveLP.coh < powerSnapWaveLP.pr95bendat) = 0;
powerWindWaveLP.coh(powerWindWaveLP.coh < powerWindWaveLP.pr95bendat) = 0;
powerSnapTidesLP.coh(powerSnapTidesLP.coh < powerSnapTidesLP.pr95bendat) = 0;
powerSnapAbsTidesLP.coh(powerSnapAbsTidesLP.coh < powerSnapAbsTidesLP.pr95bendat) = 0;
powerWaveWindDirLP.coh(powerWaveWindDirLP.coh < powerWaveWindDirLP.pr95bendat) = 0;

%Frank doing the same for phases
powerSnapWindLP.phase(powerSnapWindLP.coh < powerSnapWindLP.pr95bendat) = 0;
powerSnapWaveLP.phase(powerSnapWaveLP.coh < powerSnapWaveLP.pr95bendat) = 0;
powerWindWaveLP.phase(powerWindWaveLP.coh < powerWindWaveLP.pr95bendat) = 0;
powerSnapTidesLP.phase(powerSnapTidesLP.coh < powerSnapTidesLP.pr95bendat) = 0;
powerSnapAbsTidesLP.phase(powerSnapAbsTidesLP.coh < powerSnapAbsTidesLP.pr95bendat) = 0;



%%
figure()
tiledlayout(2,2)
ax1 = nexttile()
semilogx(powerSnapWindLP.f*86400,powerSnapWindLP.coh);
title('Coherence - SnapsWinds',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs,filterType))
yline(powerSnapWindLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWindLP.pr95bendat))
ylim([0 0.9])
xlim([0.03 1.2])

ax2 = nexttile()
semilogx(powerSnapWaveLP.f*86400,powerSnapWaveLP.coh);
title('Coherence - SnapsWaves',sprintf('%d Bins, %d OrderFilt, %d Hr %s',bins,filterOrder, cutoffHrs, filterType))
yline(powerSnapWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerSnapWaveLP.pr95bendat))
ylim([0 0.9])
xlim([0.03 1.2])

ax3 = nexttile()
semilogx(powerWindWaveLP.f*86400,powerWindWaveLP.coh);
title('Coherence - WindsWaves')
yline(powerWindWaveLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerWindWaveLP.pr95bendat))
ylim([0 0.9])
xlim([0.03 1.2])

ax4 = nexttile()
semilogx(powerWaveWindDirLP.f*86400,powerWaveWindDirLP.coh);
title('Coherence - Waves and Wind Dir');
yline(powerWaveWindDirLP.pr95bendat,'-',sprintf('95%% Sig: %.02g',powerWaveWindDirLP.pr95bendat))
ylim([0 0.9])
xlim([0.03 1.2])

linkaxes([ax1,ax2,ax3,ax4],'x')
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
legend('Snaps','Winds','Waveheight','Tides','AbsTideMagnitude')
% legend('Snaps','Winds','Waveheight','Tides','AbsTideMagnitude')
title('Power Spectral Density',sprintf('Per Day: %d Bins, %d OrderFilt, %d Hr %s',bins, filterOrder, cutoffHrs, filterType));


