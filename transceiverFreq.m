%Run binnedAVG, then figure this out. 4/7/23


%% Creating test signals to look at what's expected.
fs = 1/3600; % Sampling frequency (samples per second)
dt = 1/fs; % seconds per sample.
StopTime = 1000000; % seconds.
t = (0:dt:StopTime-dt)'; % seconds.
F = 60; % Sine wave frequency (hertz)
F2 = 1/86400;
data = sin(2*pi*F*t);
data2 = sin(2*pi*F2*t);
mySignal = data+data2;

figure()
plot(t,mySignal);

[pxx,f] = pwelch(mySignal);

figure()
plot(f,pxx);

%%
for COUNT = 1:length(fullData)
    FMsignal(COUNT,:)    = fullData{COUNT}.detections;
    noiseSignal(COUNT,:) = fullData{COUNT}.noise;
end

%window
win=24*5;
clearvars pxx f pxxNoise fNoise

%Pwelch, Welch's power spectrum. Given window and sampling frequency, spits
%out one sided
for COUNT = 1:height(FMsignal)
    [pxx(COUNT,:),f(COUNT,:)]= pwelch(FMsignal(COUNT,:),win,[],[],1/3600,'onesided');
% [pxx,f]= pwelch(FMsignal(2,:),win,[],[],1/3600);
end


for COUNT = 1:height(noiseSignal)
    [pxxNoise(COUNT,:),fNoise(COUNT,:)]= pwelch(noiseSignal(COUNT,:),win,[],[],1/3600,'onesided');
end



figure()
for COUNT = 1:height(pxx)
    nexttile()
    loglog(f(COUNT,:).*86400,pxx(COUNT,:).*f);
    title(sprintf('%d Transceiver',COUNT));
end
ylabel('Power');
xlabel('1 Day Frequency');




figure()
for COUNT = 1:height(pxxNoise)
    nexttile()
    loglog(fNoise.*86400,pxxNoise.*fNoise,'r');
    title(sprintf('%d Transceiver',COUNT));
end
ylabel('Power');
xlabel('1 Day Frequency');
title('2020 Noise, Freq. Spectrum');



    figure()
for COUNT = 1:height(pxx)
    nexttile()
    loglog(f(COUNT,:).*86400,pxx(COUNT,:).*f);
    title(sprintf('%d Transceiver',COUNT));
end
    ylabel('Power');
    xlabel('1 Day Frequency');


%Not sure how to develop the lowpass. Given signal, I put in double the
%Nyquist frequency, 4 hours (1/14400), and the sampling frequency, 1/3600


y = lowpass(noiseSignal(COUNT,:), 1/14400 , 1/3600);

[pxxNoise,fNoise]= pwelch(y,win,[],[],1/3600,'onesided');
figure()
loglog(fNoise.*86400,pxxNoise.*fNoise,'r');
ylabel('Power');
xlabel('1 Day Frequency');
title('2020 Noise, Freq. Spectrum, Lowpass');


