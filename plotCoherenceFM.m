%Run coherenceFM,then:

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




figure()
yyaxis left
plot(times,filteredData.TidesAbsolute,'b','LineWidth',2)
ylabel('Tidal Magnitude (m/s)')
yyaxis right
plot(times,filteredData.Snaps,'r','LineWidth',2)
ylabel('Snaprate')
title(sprintf('%s Filter (1-10day) Results',filterType),'Tides and Snaprates')
legend('Tidal Magnitude','Hourly Snaprate')