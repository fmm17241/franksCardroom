%Alright, we need to figure this out.
%Frank needs to correctly use the spectrum to separate the timeseries.

%Sampling frequency: 1 kHz
%Signal duration: 1.5 seconds

Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector

S = 0.8 + 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);

data = S + 2*randn(size(t));


figure()
plot(1000*t,data)
title("Signal Corrupted with Zero-Mean Random Noise")
xlabel("t (milliseconds)")
ylabel("X(t)")

figure()
plot(1000*t,S)
title("Signal")
xlabel("t (milliseconds)")
ylabel("X(t)")


Y = fft(data)
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);


f = Fs/L*(0:(L/2));
figure()
plot(f,P1,"LineWidth",3) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")


segmentLength = 1000;
noverlap = 500;
[pxx,f] = pwelch(data,segmentLength,noverlap,40,Fs);

[pxx,f] = pwelch(data);

figure()
plot(f,10*log10(pxx))
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')
title('Example Signal, 50% overlap')



figure()
plot(Fs/L*(0:L-1),abs(Y),"LineWidth",3)
title("Complex Magnitude of fft Spectrum")
xlabel("f (Hz)")
ylabel("|fft(X)|")
figure()
plot(Fs/L*(-L/2:L/2-1),abs(fftshift(Y)),"LineWidth",3)
title("fft Spectrum in the Positive and Negative Frequencies")
xlabel("f (Hz)")
ylabel("|fft(X)|")


Y = fft(S);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
figure()
plot(f,P1,"LineWidth",3) 
title("Single-Sided Amplitude Spectrum of S(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")

 %Franks Hanning Window Implementation

Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector
f = Fs/L*(0:(L/2));

S = 0.8 + 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);

data = S + 2*randn(size(t));
hannWind = hanning(40);


dataTest = data.*hannWind;

figure()
wvtool(hannWind)


Ywindow = fft(dataTest);
P2window = abs(Ywindow/L);
P1window = P2window(1:L/2+1);
P1window(2:end-1) = 2*P1window(2:end-1);
figure()
plot(f,P1window,"LineWidth",3) 
title("Single-Sided Amplitude Spectrum of S(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")




Y = fft(data);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
figure()
plot(f,P1,"LineWidth",3) 
title("Single-Sided Amplitude Spectrum of S(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")




%%
% Okay, gotta experiment with my data
% 1hz = 1 per second
% 1/3600 Hz = 1 per hour? I think
% Frank ran "deepCutz"
deepCutz
clearvars -except receiverData oneDrive githubToolbox
close all

%
Fs = 1/3600;        % Sampling Frequency, hourly
T = 1/Fs            % Sample Period
L = length(receiverData{5}.HourlyDets)          % Length of Signal
t = (0:L-1)*T;

%Testing my data
T = receiverData{5}.DT
% T2 = receiverData{5}.DT
data = receiverData{5}.HourlyDets';
window = hanning(40);

f = Fs/L*(0:(L/2));

figure()
plot(T,data)
title("Row in the Time Domain")

%
Y = fft(data);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
figure()
plot(f,P1,"LineWidth",3) 
title("FFT: Off Reef, No Window")
xlabel("f (Hz)")
ylabel("|P1(f)|")


%%
dataTest = data.*window;


Ywindow = fft(dataTest);
P2window = abs(Ywindow/L);
P1window = P2window(1:L/2+1);
P1window(2:end-1) = 2*P1window(2:end-1);
figure()
plot(f,P1window,"LineWidth",3) 
title("Single-Sided Amplitude Spectrum, Data: 80-Hour  Hanning Window, Off Reef")
xlabel("f (Hz)")
ylabel("|P1(f)|")


















%%




Y = fft(data,L);
windowY = fft(window.*data,:)

figure()
plot(Fs/L*(0:L-1),abs(Y),"LineWidth",3)
title("Complex Magnitude of fft Spectrum")
xlabel("f (Hz)")
ylabel("|fft(X)|")


%
figure()
plot(Fs/L*(-L/2:L/2-1),abs(fftshift(Y)),"LineWidth",3)
title("fft Spectrum in the Positive and Negative Frequencies")
xlabel("f (Hz)")
ylabel("|fft(X)|")


P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);


f = Fs/L*(0:(L/2));
plot(f,P1,"LineWidth",3) 
title("Single-Sided Amplitude Spectrum of X(t),NoFilter")
xlabel("f (Hz)")
ylabel("|P1(f)|")







%%
%Off reef is super obvious: tides and daily.
%On reef is not. Need to look at lowpass/highpass filters, or windowing.
Fs = 1/3600;        % Sampling Frequency
T = 1/Fs            % Sample Period
L = length(receiverData{5}.HourlyDets)          % Length of Signal
% L = length(receiverData{5}.HourlyDets)
t = (0:L-1)*T;


%Testing my data
T = receiverData{4}.DT
% T2 = receiverData{5}.DT
data = receiverData{4}.HourlyDets;
% X2 = receiverData{5}.HourlyDets;




%40 hour pass
wpass = 1/(40*3600);


dataHighFilter = highpass(data,wpass);
dataLowFilter   = lowpass(data,wpass);

Y = fft(dataHighFilter,L);
% Y2 = fft(X2,L2);

figure()
plot(Fs/L*(0:L-1),abs(Y),"LineWidth",3)
title("Complex Magnitude of fft Spectrum")
xlabel("f (Hz)")
ylabel("|fft(X)|")


%
figure()
plot(Fs/L*(-L/2:L/2-1),abs(fftshift(Y)),"LineWidth",3)
title("fft Spectrum in the Positive and Negative Frequencies")
xlabel("f (Hz)")
ylabel("|fft(X)|")


P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);


f = Fs/L*(0:(L/2));
plot(f,P1,"LineWidth",3) 
title("Single-Sided Amplitude Spectrum of X(t), HighFilter")
xlabel("f (Hz)")
ylabel("|P1(f)|")

%
Y = fft(dataLowFilter,L);
% Y2 = fft(X2,L2);

figure()
plot(Fs/L*(0:L-1),abs(Y),"LineWidth",3)
title("Complex Magnitude of fft Spectrum")
xlabel("f (Hz)")
ylabel("|fft(X)|")


%
figure()
plot(Fs/L*(-L/2:L/2-1),abs(fftshift(Y)),"LineWidth",3)
title("fft Spectrum in the Positive and Negative Frequencies")
xlabel("f (Hz)")
ylabel("|fft(X)|")


P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);


f = Fs/L*(0:(L/2));
plot(f,P1,"LineWidth",3) 
title("Single-Sided Amplitude Spectrum of X(t), LowFilter")
xlabel("f (Hz)")
ylabel("|P1(f)|")







%%


Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sampling period
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector

x1 = cos(2*pi*50*t);          % First row wave
x2 = cos(2*pi*150*t);         % Second row wave
x3 = cos(2*pi*300*t);         % Third row wave

data = [x1; x2; x3];

figure()
for i = 1:3
    subplot(3,1,i)
    plot(t(1:100),data(i,1:100))
    title("Row " + num2str(i) + " in the Time Domain")
end


dim = 2;
Y = fft(data,L,dim);
P2 = abs(Y/L);
P1 = P2(:,1:L/2+1);
P1(:,2:end-1) = 2*P1(:,2:end-1);

figure()
for i=1:3
    subplot(3,1,i)
    plot(0:(Fs/L):(Fs/2-Fs/L),P1(i,1:L/2))
    title("Row " + num2str(i) + " in the Frequency Domain")
end


%%
%Frank testing ADCP?

tidalAnalysis2020
clearvars -except githubToolbox localplots oneDrive adcp rotUtideShore ut vt localPlots matlabToolbox oneDrive tideDN tideDT rotUtideShore rotVtideShore uz vz
close all

time = datetime(adcp.dn(1:2:end),'convertFrom','datenum')
uz = uz(1:2:end);
vz = vz(1:2:end);


Fs = 1/3600;        % Sampling Frequency, hourly
T = 1/Fs            % Sample Period
L = length(vz)          % Length of Signal
t = (0:L-1)*T;

%Testing my data
T = time;
% T2 = receiverData{5}.DT
data = ut;
dataY = vt;
% window = hanning(1000);


segmentLength = 80;
noverlap = 40;
f = Fs/L*(0:(L/2));


[pxx,f] = pwelch(data,segmentLength,noverlap,40,Fs);



figure()
plot(f,10*log10(pxx))

xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')
title('ADCP VZ Raw, 50% overlap')


starts = 1:20:2700;

dataNew = data(1:40);
for k = 2:134
    dataNew(k,:) = data(starts(k):starts(k)+39)
end


Y = fft(dataNew)

Ytest = fft(data)



%
wpass = 1/(40*3600);
dataHighFilter = highpass(data,wpass);
dataLowFilter   = lowpass(data,wpass);
%

f = Fs/L*(0:(L/2));

test = cwtfilterbank(signalLength=1000, samplingFrequency=Fs)





figure()
plot(T,data)
title("Row in the Time Domain")


Y = fft(data);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
figure()
plot(f,P1,"LineWidth",3) 
title("ADCP no Window, U")
xlabel("f (Hz)")
ylabel("|P1(f)|")


%%
dataTest = data.*window;


Ywindow = fft(dataTest);
P2window = abs(Ywindow/L);
P1window = P2window(1:L/2+1);
P1window(2:end-1) = 2*P1window(2:end-1);
figure()
plot(f,P1window,"LineWidth",3) 
title("ADCP, 40 Window, U")
xlabel("f (Hz)")
ylabel("|P1(f)|")



%%
FRANK you need to use pwelch() and buffer() and filtfilt(). Buffer makes the windows and does the zero padding, makes life a lot easier



