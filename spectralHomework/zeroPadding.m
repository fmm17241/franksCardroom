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
waterLevel{1} = wl;     %Full 30 days, Data
windowLevel{1} = buffer(waterLevel{1},400)



%15 Day Chunk
DT{2} = DT{1}(1:3600); DN{2} = DN{1}(1:3600); % 15 days
waterLevel{2} = wl(1:3600);  % 15 days, Data
windowLevel{2} = buffer(waterLevel{2},400)


%14 Day Chunk
DT{3} = DT{1}(1:3360); DN{3} = DN{1}(1:3360); %14 days
waterLevel{3} = wl(1:3360); % 14 days, Data
windowLevel{3} = buffer(waterLevel{3},400)


for COUNT = 1:18
    windowPadLevel{1, COUNT} = [windowLevel{1}(:,COUNT); zeros(2*length(windowLevel{1}(:,COUNT)),1)]; 
    if COUNT == 10|11|12|13|14|15|16|17|18
        continue 
    end
    windowPadLevel{2, COUNT} = [windowLevel{2}(:,COUNT); zeros(2*length(windowLevel{2}(:,COUNT)),1)]; 
    windowPadLevel{3, COUNT} = [windowLevel{3}(:,COUNT); zeros(2*length(windowLevel{3}(:,COUNT)),1)]; 
end


%%
%Padded FFT
Y{1} = fft(WLPadded{1})           % 30 day sample
L{1} = length(WLPadded{1})        % 30 day: 30 days *24 hours *10 samples per hour
magnitude{1} = abs(Y{1});
%
Y{2} = fft(WLPadded{2})           % 15 day sample
L{2} = length(WLPadded{2})        % 15 day: 15 days *24 hours *10 samples per hour
magnitude{2} = abs(Y{2});
%
Y{3} = fft(WLPadded{3})           % 14 day sample
L{3} = length(WLPadded{3})        % 14 day: 14 days *24 hours *10 samples per hour
magnitude{3} = abs(Y{3});

%Set up FFT variables
Fs = (2*pi)/(6*60);            % Sampling frequency, 1 sample every 6 minutes. Added 2pi.


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



% close all

WLPadded{1} = [wl,zeros(1,2*length(waterLevel{1}))];     %Full 30 days, Data
WLPadded{2} = [wl,zeros(1,2*length(waterLevel{2}))];     %Full 30 days, Data
WLPadded{3} = [wl,zeros(1,2*length(waterLevel{3}))];     %Full 30 days, Data



