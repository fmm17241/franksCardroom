

%Running this after snapRateAnalyzer and snapRatePlotter, so I have nice
%variables and structures to work with.
% 
% envData : cell structure of environmental and detection data during the
% times that we have analyzed hydrophone data.
%
% envData{X}.DT datetime, hourly
% envData{X}.Noise  high-frequency (50-90 khz) noise, averaged hourly
% envData{X}.Tilt   instrument tilt
% envData{X}.Temp   Deg C, ~1 m off bottom
% envData{X}.windSpd  hourly m/s, magnitude
% envData{X}.windDir  dir, wind is GOING TOWARDS, CW from True N
% envData{X}.bulkThermalStrat  surface-bottom temps
% envData{X}.waveHeight   Significant waveheight from NDBC buoy 41008
% envData{X}.crossShore   Cross-shore tidal velocity
% envData{X}.hourlyDets   Detections collected by transceiver 4,
%                         same mooring as hydrophone
%
%
% hourSnaps : hourly count of snaps at a certain threshold, 1000U if not
% specified.

%This processes our snap counts, removing the trend and mean from the data.
for K = 1:length(envData)
    % Detrending the signal
    detrendedSignal{K} = detrend(hourSnaps{K}.SnapCount,'constant')
    %Removing the mean from the signal:
    processedSignal{K} = detrendedSignal{K} - mean(detrendedSignal{K});
end


%This visualizes the different hydrophone analysis.
for K = 1:length(envData)
    figure()
    tiledlayout(3,1)
    nexttile()
    ax1 = plot(envData{K}.DT,envData{K}.crossShore)
    title('','Tidal Magnitude')
    % nexttile()
    % ax2 = plot(envData{1}.DT,envData{1}.Noise)
    % title('','Noise')
    nexttile()
    ax3 = plot(hourSnaps{K}.Time,processedSignal{K})
    title('','SnapCounts')
    nexttile()
    ax4 = plot(envData{K}.DT,envData{K}.windSpd);
    title('','Winds')
% linkaxes([ax1,ax3,ax4],'x')
end


%%
rawSignal = Power_spectra(hourSnaps{1}.SnapCount,1,1,0,3600,0);

testSignal = Power_spectra(receiverData{4}.crossShore,1,1,0,3600,0)

for K = 1:length(envData)
    %Find the frequency of the signal
    powerAnalysis{K} = Power_spectra(processedSignal{K},1,1,0,3600,0)
end

%Power_spectra inputs
% dataout=Power_spectra(datainA,bins,DT,windoww,samplinginterval,cutoff)

figure()
loglog(rawSignal.f*86400,rawSignal.psdw);
title('Snaps','Raw Data')


X = 1:length(processedSignal)



% I need to add windows and bins; if the signal is whole there's too much
% aliasing and leakage.


% %This cuts the entire year+ dataset into 40 hour chunks
% windowedSignal = buffer(processedSignal,40,20);  
% paddedSignal = padarray(processedSignal,height(processedSignal)*2,'post');
% 


figure()
plot(powerAnalysis.f*86400,powerAnalysis.psdw);
title('Snaps','Detrended-Mean Data')




tides = envData{1}.crossShore;

rawSignal = Power_spectra(tides,1,1,0,3600,0);

figure()
loglog(rawSignal.f*86400,rawSignal.psdw);
title('Tides','Raw Data')


winds = envData{1}.windSpd;

rawSignal = Power_spectra(winds,1,1,0,3600,0);

figure()
loglog(rawSignal.f*86400,rawSignal.psdw);
title('Winds','Raw Data')




% freqDomainSignal = fft(processedSnaps);   % FFT to convert to frequency domain
% 
% % Optional: To visualize the frequency content
% n = length(processedSnaps);                          % Number of points in the signal
% frequencies = (0:n-1)*(1/(n*1));             % Frequency vector
% amplitude = abs(freqDomainSignal/n);         % Amplitude of the frequencies
% 
% figure()
% plot(frequencies, amplitude);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude');
% title('Frequency Domain Signal');
% 


%%
%Frank playing with mscohere

















