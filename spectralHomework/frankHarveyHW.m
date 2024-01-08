%Frank Completing HW3
% 1/5/24

% Step 1: Load in data, format it the way I want.

%Working Directory
cd 'C:\Users\fmm17241\OneDrive - University of Georgia\harveyNotes\hwdata'

%Load in data
%Year, month, day, hour, minute, second
%Water level: wl
load wl.mat
% Turn wl.mat's date info into DT/DN
dateArray = [year', month', day', hour', minute', second'];

%30 Day Chunk
DT{1} = datetime(dateArray); DN{1} = datenum(DT{1}); %Full 30 days
WL{1} = wl;     %Full 30 days, Data

%15 Day Chunk
DT{2} = DT{1}(1:3600); DN{2} = DN{1}(1:3600); % 15 days
WL{2} = wl(1:3600);  % 15 days, Data

%14 Day Chunk
DT{3} = DT{1}(1:3360); DN{3} = DN{1}(1:3360); %14 days
WL{3} = wl(1:3360); % 14 days, Data


figure()
tiledlayout(3,1,'TileSpacing',"compact")
ax1 = nexttile()
plot(DT{1},WL{1})
title("Raw Water Level, 30 day")
xlabel("Time")
ylabel("Waterlevel (m)")

ax2 = nexttile()
plot(DT{2},WL{2})
title("Raw Water Level, 15 day")
xlabel("Time")
ylabel("Waterlevel (m)")


ax3 = nexttile()
plot(DT{3},WL{3})
title("Raw Water Level, 14 day")
xlabel("Time")
ylabel("Waterlevel (m)")

% linkaxes([ax1 ax2 ax3],'x')


% 2pi added
% close all
%%
% Run basic FFT and give length
Y{1} = fft(WL{1})           % 30 day sample
L{1} = 7180                 % 30 day: 30 days *24 hours *10 samples per hour
magnitude{1} = abs(Y{1});
%
Y{2} = fft(WL{2})           % 15 day sample
L{2} = 3600                 % 15 day: 15 days *24 hours *10 samples per hour
magnitude{2} = abs(Y{2});
%
Y{3} = fft(WL{3})           % 14 day sample
L{3} = 3360                 % 14 day: 14 days *24 hours *10 samples per hour
magnitude{3} = abs(Y{3});

%Set up FFT variables
Fs = (2*pi)/(6*60);            % Sampling frequency, 1 sample every 6 minutes. Added 2pi.

% Plot results of FFT analysis on all 3 samples
figure()
tiledlayout(3,1,'TileSpacing',"compact")
ax1 = nexttile()
plot(Fs/L{1}*(0:L{1}-1),abs(Y{1}),"LineWidth",3)
title("Magnitude of FFT Results", "30 Day")
xlabel("f (Hz)")
ylabel("|fft(X)|")
set(gca,'XScale','log')
set(gca,'YScale','log')


ax2 = nexttile()
plot(Fs/L{2}*(0:L{2}-1),abs(Y{2}),"LineWidth",3)
title("", "15 Day")
xlabel("f (Hz)")
ylabel("|fft(X)|")
set(gca,'XScale','log')
set(gca,'YScale','log')

ax3 = nexttile()
plot(Fs/L{3}*(0:L{3}-1),abs(Y{3}),"LineWidth",3)
title('',"14 Day")
xlabel("f (Hz)")
ylabel("|fft(X)|")
set(gca,'XScale','log')
set(gca,'YScale','log')

linkaxes([ax1 ax2 ax3],'x')
%%
% B) use t_tide WITHOUT start time/latitude

[struct{1}, xout{1}] = t_tide(WL{1},'interval', 0.1) % Tidal Predictions, no lat/datetime, 30 days
[struct{2}, xout{2}] = t_tide(WL{2},'interval', 0.1) % Tidal Predictions, no lat/datetime, 15 days
[struct{3}, xout{3}] = t_tide(WL{3},'interval', 0.1) % Tidal Predictions, no lat/datetime, 14 days


x30 = 1:length(xout{1}); x15 = 1:length(xout{2}); x14 = 1:length(xout{3}); % Time/X-axis for plotting tidal predictions, 30/15/14 day length

%Plot 3 tidal predictions
figure()
tiledlayout(3,1,'TileSpacing',"compact")
ax1 = nexttile()
plot(x30,xout{1})
title('Tidal Predictions. No Date/Lat','30 Day')

ax2 = nexttile()
plot(x15,xout{2})
title('','15 Day')

ax3 = nexttile()
plot(x14,xout{3})
title('','14 Day')


%%
% B) use t_tide WITH start time/latitude

[structContext{1}, xoutContext{1}] = t_tide(WL{1},'interval', 0.1, 'start time', DN{1}(1,1),'latitude',35.760) % Tidal Predictions, estimated Lat and DT given, 30 days
[structContext{2}, xoutContext{2}] = t_tide(WL{2},'interval', 0.1, 'start time', DN{1}(1,1),'latitude',35.760) % Tidal Predictions, estimated Lat and DT given, 15 days
[structContext{3}, xoutContext{3}] = t_tide(WL{3},'interval', 0.1, 'start time', DN{1}(1,1),'latitude',35.760) % Tidal Predictions, estimated Lat and DT given, 14 days


x30 = 1:length(xout{1}); x15 = 1:length(xout{2}); x14 = 1:length(xout{3}); % Time/X-axis for plotting tidal predictions, 30/15/14 day length


%Plot 3 tidal predictions
figure()
tiledlayout(3,1,'TileSpacing',"compact")
ax1 = nexttile()
plot(x30,xoutContext{1})
title('Tidal Predictions. With Correct Date/Lat','30 Day')

ax2 = nexttile()
plot(x15,xoutContext{2})
title('','15 Day')

ax3 = nexttile()
plot(x14,xoutContext{3})
title('','14 Day')


figure()
tiledlayout(3,1,'TileSpacing',"compact")

ax1 = nexttile()
plot(x30,WL{1},'b');
title('Original Waterlevel')

ax2 = nexttile()
plot(x30,xout{1},'r')
title('Prediction, no DT/Lat')

ax3 = nexttile()
plot(x30,xoutContext{1},'r')
title('Prediction, added DT/Lat')


linkaxes([ax1 ax2 ax3],'x')

%%
% c. Generate synthetic time series to test
clearvars Y L Fs

t = 1:256;

signal = 30*sin(2*pi*50*t);
noisySignal = signal + 2.*randn(size(t));
xSignal = 1:length(noisySignal);


Y = fft(noisySignal)           % 30 day sample
L =  length(noisySignal)                          % 30 day: 30 days *24 hours *10 samples per hour
magnitude = abs(Y);

%use all 3 Fs 
Fs(1,1) = 1/96;
Fs(2,1) = 1/24;
Fs(3,1) = 1/6;


for COUNT = 1:3

    figure(COUNT)
    tiledlayout(3,1,'TileSpacing',"compact")
    ax1 = nexttile()
    plot(xSignal,Y,'k', "LineWidth",2)
    title(" FFT Comparisons", "Noisy Signal, Original")
    xlabel("Time")
    ylabel("Amplitude")
    
    ax2 = nexttile()
    plot(Fs(COUNT)/L*(0:L-1),abs(Y),"LineWidth",3)
    title("", "FFT Output, Linear")
    xlabel("f (Hz)")
    ylabel("|fft(X)|")
    % set(gca,'XScale','log')
    % set(gca,'YScale','log')
    
    ax3 = nexttile()
    plot(Fs(COUNT)/L*(0:L-1),abs(Y),'r',"LineWidth",3)
    title("", "FFT Output, Log")
    xlabel("f (Hz)")
    ylabel("|fft(X)|")
    set(gca,'XScale','log')
    % set(gca,'YScale','log')

end


%Frank figuring out "buffer()" to use windowing & zero-padding
% Y = buffer(X,N,P)
%X = signal;

N =  40; %  Length of each segment
P =  20; %  Overlap of segments. Actual samples, not percentage.
windowData = buffer(noisySignal,N)

lengthPad = 2*length(noisySignal)


test = fft(windowData,lengthPad);

% Discrete Fourier Series coefficients:
DFS = fft(windowData)/N






