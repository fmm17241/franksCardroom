%Frank Completing HW3
% 1/5/24

% Step 1: Load in data, format it the way I want.

%Working Directory
% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\harveyNotes\hwdata'
cd 'C:\Users\fmac4\OneDrive - University of Georgia\harveyNotes\hwdata'

%Load in data
%Year, month, day, hour, minute, second
%Water level: wl
load wl.mat
% Turn wl.mat's date info into DT/DN
dateArray = [year', month', day', hour', minute', second'];

%30 Day Chunk
DT{1} = datetime(dateArray); DN{1} = datenum(DT{1}); %Full 30 days
WL{1} = wl;     %Full 30 days, Data
WLprocessed{1} = buffer(WL{1},400);  WLprocessed{1} = padarray(WLprocessed{1},length(WLprocessed{1})*2,'post');



%15 Day Chunk
DT{2} = DT{1}(1:3600); DN{2} = DN{1}(1:3600); % 15 days
WL{2} = wl(1:3600);  % 15 days, Data
WLprocessed{2} = buffer(WL{2},400); WLprocessed{2} = padarray(WLprocessed{2},length(WLprocessed{2})*2,'post');


%14 Day Chunk
DT{3} = DT{1}(1:3360); DN{3} = DN{1}(1:3360); %14 days
WL{3} = wl(1:3360); % 14 days, Data
WLprocessed{3} = buffer(WL{3},400); WLprocessed{3} = padarray(WLprocessed{3},length(WLprocessed{3})*2,'post');


% 
% 
% for COUNT = 1:18
%     windowPadLevel{1, COUNT} = [WLprocessed{1}(:,COUNT); zeros(2*length(WLprocessed{1}(:,COUNT)),1)]; 
%     if COUNT == 10|11|12|13|14|15|16|17|18
%         continue 
%     end
%     windowPadLevel{2, COUNT} = [WLprocessed{2}(:,COUNT); zeros(2*length(WLprocessed{2}(:,COUNT)),1)]; 
%     windowPadLevel{3, COUNT} = [WLprocessed{3}(:,COUNT); zeros(2*length(WLprocessed{3}(:,COUNT)),1)]; 
% end


%%
%Padded FFT
Y{1} = fft(WLprocessed{1})           % 30 day sample
L{1} = length(WLprocessed{1})        % 30 day: 30 days *24 hours *10 samples per hour
magnitude{1} = abs(Y{1});
averageWindowOutput(:,1) = mean(Y{1},2);


%
Y{2} = fft(WLprocessed{2})           % 15 day sample
L{2} = length(WLprocessed{2})        % 15 day: 15 days *24 hours *10 samples per hour
magnitude{2} = abs(Y{2});
averageWindowOutput(:,2) = mean(Y{2},2);

%
Y{3} = fft(WLprocessed{3})           % 14 day sample
L{3} = length(WLprocessed{3})        % 14 day: 14 days *24 hours *10 samples per hour
magnitude{3} = abs(Y{3});
averageWindowOutput(:,3) = mean(Y{3},2);



%Set up FFT variables
Fs = (2*pi)/(6*60);            % Sampling frequency, 1 sample every 6 minutes. Added 2pi.

for COUNT = 1:3
    figure(COUNT)
    plot(Fs/L{COUNT}*(0:L{COUNT}-1),abs(averageWindowOutput(:,COUNT)),'r',"LineWidth",3)
    title("", "FFT Output, Log")
    xlabel("f (Hz)")
    ylabel("|fft(X)|")
    set(gca,'XScale','log')
    set(gca,'YScale','log')
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

