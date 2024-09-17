%Frank tried FFTs in powerAnalysis, now I want to compare
% at different tides. We'll see, IDK anymore.


%Running this after snapRateAnalyzer and snapRatePlotter, so I have nice
%variables and structures to work with.
% 
% envData : cell structure of environmental and detection data during the
% times that we have analyzed hydrophones.
% 
% hourSnaps : hourly count of snaps at a certain threshold, 1000U if not
% specified.

rawSignal = Power_spectra(hourSnaps{1}.SnapCount,1,1,0,3600,0)

figure()
plot(rawSignal.f*86400,rawSignal.psdw);
title('Snaps','Raw Data')

% Detrending the signal
detrendedSignal = detrend(hourSnaps{1}.SnapCount,'constant')

%Removing the mean from the signal:
processedSignal = detrendedSignal - mean(detrendedSignal);

%Find the frequency of the signal
signalDetrended = Power_spectra(processedSignal,1,1,0,3600,0)

% %This cuts the entire year+ dataset into 40 hour chunks
% windowedSignal = buffer(processedSignal,40,20);  
% paddedSignal = padarray(processedSignal,height(processedSignal)*2,'post');
% 


figure()
plot(signalDetrended.f*86400,signalDetrended.psdw);
title('Snaps','Detrended-Mean Data')










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













