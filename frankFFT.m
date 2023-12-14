%Alright, we need to figure this out.
%Frank needs to correctly use the spectrum to separate the timeseries.

%Sampling frequency: 1 kHz
%Signal duration: 1.5 seconds

Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector

S = 0.8 + 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);

X = S + 2*randn(size(t));

figure()
plot(1000*t,X)
title("Signal Corrupted with Zero-Mean Random Noise")
xlabel("t (milliseconds)")
ylabel("X(t)")

Y = fft(X)

figure()
plot(Fs/L*(0:L-1),abs(Y),"LineWidth",3)
title("Complex Magnitude of fft Spectrum")
xlabel("f (Hz)")
ylabel("|fft(X)|")

plot(Fs/L*(-L/2:L/2-1),abs(fftshift(Y)),"LineWidth",3)
title("fft Spectrum in the Positive and Negative Frequencies")
xlabel("f (Hz)")
ylabel("|fft(X)|")