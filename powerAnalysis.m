buildReceiverData

close all

%
%Brock's Code: data, # of bins, Detrend?, Window?, Interval (secs), cutoff
% dataout=Power_spectra(datainA,bins,DT,windoww,samplinginterval,cutoff)
signalNoise = receiverData{4}.Noise;
signalDets  =   receiverData{4}.HourlyDets;
signalPings  =   receiverData{4}.Pings;
signalWinds  =   receiverData{4}.windSpd;

Fs = (2*pi)/(60*60);            % Sampling frequency, 1 sample every 60 minutes. Added 2pi.
FsPerDay = Fs*86400;





PS = Power_spectra(signalNoise',1,0,0,3600,0)
%Why is there only 20 bins?

%Set up FFT variables


figure()
plot(FsPerDay/L{COUNT}*(0:L{COUNT}-1),PS.psdf)














