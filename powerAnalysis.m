buildReceiverData
clearvars -except receiverData oneDrive githubToolbox
close all




%
%Brock's Code: data, # of bins, Detrend?, Window?, Interval (secs), cutoff
% dataout=Power_spectra(datainA,bins,DT,windoww,samplinginterval,cutoff)
for COUNT = 1:length(receiverData)
    signalNoise{COUNT}  =   receiverData{COUNT}.Noise;
    signalDets{COUNT}   =   receiverData{COUNT}.HourlyDets;
    signalWinds{COUNT}  =   receiverData{COUNT}.windSpd;
    signalTilt{COUNT}  =   receiverData{COUNT}.Tilt;
    signalTemp{COUNT}  =   receiverData{COUNT}.Temp;
    signalCrossTides{COUNT}  =  receiverData{COUNT}.crossShore;
end


%%
        
%Frank's using the cross-shore tidal predictions to test his FFT skills.
%Let's see.
figure()
tiledlayout(2,1,'TileSpacing','compact')
ax1 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.Noise)
ylabel('Noise (mV)')
title('ON Reef, 33OUT')
ylim([200 900])
ax2 = nexttile()
plot(receiverData{5}.DT,receiverData{5}.Noise)
ylabel('Noise (mV)')
title('OFF Reef, FS17')
ylim([200 900])

linkaxes([ax1,ax2],'x')

% Receiver 1, so 7760 hours total
% # of hours (or days) / bins
% whole Dataset / 1 bin
% 60 days / 6 bins
% 30 days / 11 bins
% 14 days / 23 bins
% 10 days / 33 bins
% 7 days / 47 bins
% 40 hours / 194 bins
orderUp = [1;11;33;47;194]; %Whole time, 30 day, 10 day, 7 day, and 40 hours



sizeLabels   = [{'WHOLE'};{'30 Days'};{'10 Days'};{'7 Days'};{'40 Hours'}];

%Number of hours in each bin; 1st value represents whole dataset
binLength = [NaN;720;240;168;40]; 

%%

%Hmmmmm how do I automate this part? Let's try.
for COUNT = 1:length(receiverData)
    datasetLength(COUNT) = length(receiverData{COUNT}.Noise)

    % Bins
    for binCOUNT = 1:length(binLength)
        % Sets the first bin as the whole dataset
        if binCOUNT == 1
        numberOfBins(COUNT,binCOUNT) = 1;
        noiseStruct{COUNT,binCOUNT} = Power_spectra(signalNoise{COUNT}',numberOfBins(COUNT,binCOUNT),1,0,3600,0)
        detectionStruct{COUNT,binCOUNT} = Power_spectra(signalDets{COUNT}',numberOfBins(COUNT,binCOUNT),1,0,3600,0)
        tideStruct{COUNT,binCOUNT} = Power_spectra(signalCrossTides{COUNT}',numberOfBins(COUNT,binCOUNT),1,0,3600,0)  
        continue
        end
        numberOfBins(COUNT,binCOUNT) = datasetLength(COUNT)/binLength(binCOUNT)

        noiseStruct{COUNT,binCOUNT} = Power_spectra(signalNoise{COUNT}',numberOfBins(COUNT,binCOUNT),1,0,3600,0)
        detectionStruct{COUNT,binCOUNT} = Power_spectra(signalDets{COUNT}',numberOfBins(COUNT,binCOUNT),1,0,3600,0)
        tideStruct{COUNT,binCOUNT} = Power_spectra(signalCrossTides{COUNT}',numberOfBins(COUNT,binCOUNT),1,0,3600,0)  
    end
end



% Okay, plot one variable's full spectrum

for COUNT = 1:length(receiverData)
    figure()
    tiledlayout(length(binLength),1,'TileSpacing','Compact')
    for binCOUNT = 1:length(binLength)
    nexttile()
    plot(noiseStruct{COUNT,binCOUNT}.f*86400,noiseStruct{COUNT,binCOUNT}.psdT)
    % xlim([0.7 12])
    set(gca,'XScale','log')
    set(gca,'YScale','log')
    title(sprintf('FFT Analysis: Noise, %s',sizeLabels{binCOUNT}),'No Window, Detrended')
    ylabel('Noise?')
    xticks([10^0 2 3 4])
    xticklabels({'Once','Twice','Thrice','4x'})
    if binCOUNT == length(binLength)
        xlabel('Cycles per Day')
    end
    end
end


%%
%Frank spot-checking some things, comparing between "on and off" reef.
%Still unsure of this metric, we'll see.

%Noise
figure()
tiledlayout(2,3,'TileSpacing','Compact')
for COUNT = 4:5
    nexttile()
    plot(receiverData{COUNT}.DT,receiverData{COUNT}.Noise)
    ylabel('HF. Noise (mV)')
    if COUNT == 4
    title('ON Reef Noises')
    else
    title('OFF Reef Noises')
    end

    ylim([200 850])
    for binCOUNT = [1,4]
    nexttile()
    plot(noiseStruct{COUNT,binCOUNT}.f*86400,noiseStruct{COUNT,binCOUNT}.psdT)
    % xlim([0.7 12])
    set(gca,'XScale','log')
    set(gca,'YScale','log')
    if binCOUNT == 4
        title(sprintf('FFT Analysis: Noise, Weekly',sizeLabels{binCOUNT}),'No Window, Detrended')
    else
        title('FFT Analysis: Noise, Entire Series','No Window, Detrended')
    end
    ylabel('Noise?')
    xticks([10^0 2 3 4])
    xticklabels({'Once','Twice','Thrice','4x'})
    xlim([0.4 4.2])
    if COUNT == 5
        xlabel('Cycles per Day')
    end
    if binCOUNT ==1
        ylim([10^-1 10^6])
    end
    if binCOUNT == 4
        ylim([10^2 10^4])
    end

    end
end

%Detections
figure()
tiledlayout(2,3,'TileSpacing','Compact')
for COUNT = 4:5
    nexttile()
    plot(receiverData{COUNT}.DT,receiverData{COUNT}.HourlyDets)
    ylabel('Detections')
    if COUNT == 4
    title('ON Reef Detections')
    else
    title('OFF Reef Detections')
    end

    % ylim([200 850])
    for binCOUNT = [1,4]
    nexttile()
    plot(detectionStruct{COUNT,binCOUNT}.f*86400,detectionStruct{COUNT,binCOUNT}.psdT*(2*pi))
    % xlim([0.7 12])
    set(gca,'XScale','log')
    set(gca,'YScale','log')
    if binCOUNT == 4
        title(sprintf('FFT Analysis: Detections, Weekly',sizeLabels{binCOUNT}),'No Window, Detrended')
    else
        title('FFT Analysis: Detections, Entire Series','No Window, Detrended')
    end
    ylabel('Detections?')
    xticks([10^0 2 3 4])
    xticklabels({'Once','Twice','Thrice','4x'})
    xlim([0.4 4.2])
    if COUNT == 5
        xlabel('Cycles per Day')
    end
    if binCOUNT ==1
        ylim([10^-4 10^2])
    end

    if binCOUNT == 4
        ylim([0 4])
    end
    end
end





%%
%Frank plotting different outputs in the structure.

figure()
tiledlayout(4,1,'TileSpacing','Compact')
tideStruct = Power_spectra(signalCrossTides{1}',33,1,0,3600,0)

nexttile()
plot(tideStruct.f*86400,tideStruct.s)
% xlim([0.7 12])
set(gca,'XScale','log')
set(gca,'YScale','log')
title('FFT Analysis: Predicted Tides, S','10 Day Bin, Detrended')

nexttile()
plot(tideStruct.f*86400,tideStruct.psdf)
% xlim([0.7 12])
set(gca,'XScale','log')
set(gca,'YScale','log')
title('FFT Analysis: Predicted Tides, PSDF','10 Day Bin, Detrended')

nexttile()
plot(tideStruct.f*86400,tideStruct.psdw)
% xlim([0.7 12])
set(gca,'XScale','log')
set(gca,'YScale','log')
title('FFT Analysis: Predicted Tides, PSDW','10 Day Bin, Detrended')

nexttile()
plot(tideStruct.f*86400,tideStruct.psdT)
% xlim([0.7 12])
set(gca,'XScale','log')
set(gca,'YScale','log')
title('FFT Analysis: Predicted Tides, PSDT','10 Day Bin, Detrended')
xlabel('Cycles per Day')








%%
Fs = (2*pi)/(60*60);            % Sampling frequency, 1 sample every 60 minutes. Added 2pi; this is per second, Hz
FsPerDay = Fs*86400;            % This turns it to how many times per day
%%



for COUNT = 1:length(receiverData)
    struct{COUNT} = Power_spectra(signalNoise{COUNT}',2,0,0,3600,0)
end

for COUNT = 1:length(receiverData)
    figure()
    plot(struct{COUNT}.f*86400,struct{COUNT}.psdf)
    set(gca,'XScale','log')
    set(gca,'YScale','log')
    title(sprintf('%d, Per Day, PSDF',COUNT))

    figure()
    plot(struct{COUNT}.f*86400,struct{COUNT}.psdw)
    set(gca,'XScale','log')
    set(gca,'YScale','log')
    title(sprintf('%d, Per Day, PSDW',COUNT))

    figure()
    plot(struct{COUNT}.f*86400,struct{COUNT}.v)
    set(gca,'XScale','log')
    set(gca,'YScale','log')
    title(sprintf('%d, Per Day, V',COUNT))


end


%%
%Set up FFT variables
Fs = (2*pi)/(60*60);            % Sampling frequency, 1 sample every 60 minutes. Added 2pi.
FsPerDay = Fs*86400;

for COUNT =  1:length(receiverData)
    Y{COUNT} = fft(signalNoise{COUNT})              % FFT of the processed signals 
    L{COUNT} = height(signalNoise{COUNT})        % Length of signal
    magnitude{COUNT} = abs(Y{COUNT});
    averageWindowOutput{COUNT}(:,1) = mean(Y{COUNT},2); %Averaging all my windows
end


% for COUNT = 1:length(receiverData)
%     figure(COUNT)
%     % plot(FsPerDay/L{1}*(0:L{1}-1),abs(rawSignalProcess.*conj(rawSignalProcess)),'r',"LineWidth",3)
%     plot(FsPerDay/L{COUNT}*(0:L{COUNT}-1),abs(Y{COUNT}),'r',"LineWidth",3)    
%     title("", "FFT Output, Log")
%     xlabel("f (Hz)")
%     ylabel("|fft(X)|")
%     set(gca,'XScale','log')
%     set(gca,'YScale','log')
% end


%%
%Processing
clearvars Y L magnitude averageWindowOutput
for COUNT =  1:length(receiverData)
    signalNoiseProcessed{COUNT} = buffer(signalNoise{COUNT},40,20);  
    signalNoiseProcessed{COUNT} = padarray(signalNoiseProcessed{COUNT},height(signalNoiseProcessed{COUNT})*2,'post');
end


for COUNT =  1:length(receiverData)
    Y{COUNT} = fft(signalNoiseProcessed{COUNT})              % FFT of the processed signals 
    L{COUNT} = height(signalNoiseProcessed{COUNT})        % Length of signal
    magnitude{COUNT} = abs(Y{COUNT});
    averageWindowOutput{COUNT}(:,1) = mean(Y{COUNT},2); %Averaging all my windows
end


% for COUNT = 1:length(receiverData)
%     figure(COUNT)
%     % plot(FsPerDay/L{1}*(0:L{1}-1),abs(rawSignalProcess.*conj(rawSignalProcess)),'r',"LineWidth",3)
%     plot(FsPerDay/L{COUNT}*(0:L{COUNT}-1),abs(averageWindowOutput{COUNT}),'r',"LineWidth",3)    
%     title("", "FFT Output, Log")
%     xlabel("f (Hz)")
%     ylabel("|fft(X)|")
%     set(gca,'XScale','log')
%     set(gca,'YScale','log')
% end


%%
% Passing
wpass = (2*pi)/172800;
Fs = (2*pi)/3600 %Frequency, hertz
% Fs = (2*pi) %Frequency, hertz

%First band: between 2 and 30 days
bandWork1 = [(2*pi)/2592000 (2*pi)/172800]

%Second band: between 14 and 30 days
bandWorkMid = [(2*pi)/2592000 (2*pi)/1209600]

%Third band: between 30 and 100 days
bandWorkLow = [(2*pi)/8640000 (2*pi)/2592000]

%Fourth band: between 2 hours and 2 days
bandWorkHigh = [(2*pi)/2592000 (2*pi)/7200]



%%
figure()
bandpass(signalNoise{1},bandWorkLow,Fs)

figure()
bandpass(signalNoise{1},bandWorkHigh,Fs)

figure()
bandpass(signalNoise{1},bandWorkMid,Fs)

figure()
bandpass(signalNoise{1},bandWorkHigh,Fs)
title('Transceiver 1')

%X is the filtered signal, hmmmmm
[x{1},y] = bandpass(signalNoise{1},bandWorkHigh,Fs);
[x{2},y] = bandpass(signalNoise{2},bandWorkHigh,Fs);
[x{3},y] = bandpass(signalNoise{3},bandWorkHigh,Fs);
[x{4},y] = bandpass(signalNoise{4},bandWorkHigh,Fs);
[x{5},y] = bandpass(signalNoise{5},bandWorkHigh,Fs);
[x{6},y] = bandpass(signalNoise{6},bandWorkHigh,Fs);
[x{7},y] = bandpass(signalNoise{7},bandWorkHigh,Fs);
[x{8},y] = bandpass(signalNoise{8},bandWorkHigh,Fs);
[x{9},y] = bandpass(signalNoise{9},bandWorkHigh,Fs);
[x{10},y] = bandpass(signalNoise{10},bandWorkHigh,Fs);
[x{11},y] = bandpass(signalNoise{11},bandWorkHigh,Fs);
[x{12},y] = bandpass(signalNoise{12},bandWorkHigh,Fs);
[x{13},y] = bandpass(signalNoise{13},bandWorkHigh,Fs);


figure()
tiledlayout(3,1,'TileSpacing','Compact')
ax1 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.Noise,'r')
hold on
plot(receiverData{4}.DT,x{4},'b');
ylabel('HF Noise (mV)')
title('ON Reef')
ax2 = nexttile()
plot(receiverData{5}.DT,receiverData{5}.Noise,'r')
hold on
plot(receiverData{5}.DT,x{5},'b');
ylabel('HF Noise (mV)')
title('OFF Reef')
ax3 = nexttile()
plot(receiverData{5}.DT,receiverData{5}.crossShore,'k')
title('XShore Tides','Flood Negative, Ebb Positive')
ylabel('Tidal Magnitude (m/s)')

linkaxes([ax1 ax2 ax3],'x')





figure()
tiledlayout(2,1,'TileSpacing','Compact')
ax1 = nexttile()
plot(receiverData{4}.DT,x{4},'b');
ylabel('HF Noise (mV)')
title('ON Reef')
ax2 = nexttile()
plot(receiverData{5}.DT,x{5},'b');
ylabel('HF Noise (mV)')
title('OFF Reef')

linkaxes([ax1 ax2],'x')

figure()
for COUNT = 1:length(receiverData)
hold on
plot(receiverData{COUNT}.DT,x{COUNT})
end
title('All 13 Transceiver Noise','Highpass filter, 2 days')
title('13 Instruments: HF Noise','Highpass filter, 2 days')
ylabel('HF Noise (mV)')


%%
[xLow{1},y] = bandpass(signalNoise{1},bandWorkLow,Fs);
[xLow{2},y] = bandpass(signalNoise{2},bandWorkLow,Fs);
[xLow{3},y] = bandpass(signalNoise{3},bandWorkLow,Fs);
[xLow{4},y] = bandpass(signalNoise{4},bandWorkLow,Fs);
[xLow{5},y] = bandpass(signalNoise{5},bandWorkLow,Fs);
[xLow{6},y] = bandpass(signalNoise{6},bandWorkLow,Fs);
[xLow{7},y] = bandpass(signalNoise{7},bandWorkLow,Fs);
[xLow{8},y] = bandpass(signalNoise{8},bandWorkLow,Fs);
[xLow{9},y] = bandpass(signalNoise{9},bandWorkLow,Fs);
[xLow{10},y] = bandpass(signalNoise{10},bandWorkLow,Fs);
[xLow{11},y] = bandpass(signalNoise{11},bandWorkLow,Fs);
[xLow{12},y] = bandpass(signalNoise{12},bandWorkLow,Fs);
[xLow{13},y] = bandpass(signalNoise{13},bandWorkLow,Fs);


figure()
tiledlayout(2,1,'TileSpacing','Compact')
ax1 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.Noise,'r')
hold on
plot(receiverData{4}.DT,x{4},'b');
ylabel('HF Noise (mV)')
title('ON Reef')
ax2 = nexttile()
plot(receiverData{5}.DT,receiverData{5}.Noise,'r')
hold on
plot(receiverData{5}.DT,x{5},'b');
ylabel('HF Noise (mV)')
title('OFF Reef')

linkaxes([ax1 ax2],'x')

figure()
tiledlayout(2,1,'TileSpacing','Compact')
ax1 = nexttile()
plot(receiverData{4}.DT,x{4},'b');
ylabel('HF Noise (mV)')
title('ON Reef')
ax2 = nexttile()
plot(receiverData{5}.DT,x{5},'b');
ylabel('HF Noise (mV)')
title('OFF Reef')

linkaxes([ax1 ax2],'x')

figure()
for COUNT = 1:length(receiverData)
hold on
plot(receiverData{COUNT}.DT,xLow{COUNT})
end
title('13 Instruments: HF Noise','Bandpass filter, 30-100 days')
ylabel('HF Noise (mV)')

%%
[xMid{1},y] = bandpass(signalNoise{1},bandWorkMid,Fs);
[xMid{2},y] = bandpass(signalNoise{2},bandWorkMid,Fs);
[xMid{3},y] = bandpass(signalNoise{3},bandWorkMid,Fs);
[xMid{4},y] = bandpass(signalNoise{4},bandWorkMid,Fs);
[xMid{5},y] = bandpass(signalNoise{5},bandWorkMid,Fs);
[xMid{6},y] = bandpass(signalNoise{6},bandWorkMid,Fs);
[xMid{7},y] = bandpass(signalNoise{7},bandWorkMid,Fs);
[xMid{8},y] = bandpass(signalNoise{8},bandWorkMid,Fs);
[xMid{9},y] = bandpass(signalNoise{9},bandWorkMid,Fs);
[xMid{10},y] = bandpass(signalNoise{10},bandWorkMid,Fs);
[xMid{11},y] = bandpass(signalNoise{11},bandWorkMid,Fs);
[xMid{12},y] = bandpass(signalNoise{12},bandWorkMid,Fs);
[xMid{13},y] = bandpass(signalNoise{13},bandWorkMid,Fs);

figure()
for COUNT = 1:length(receiverData)
hold on
plot(receiverData{COUNT}.DT,xMid{COUNT})
end
title('13 Instruments: HF Noise','Bandpass filter, 14-30 days')
ylabel('HF Noise (mV)')
%%
%%
%
figure()
bandpass(signalNoise{1},bandWorkHigh,Fs);
title('A')
figure()
bandpass(signalNoise{2},bandWorkHigh,Fs);
title('B')
figure()
bandpass(signalNoise{3},bandWorkHigh,Fs);
title('C')
figure()
bandpass(signalNoise{4},bandWorkHigh,Fs);
title('D')
figure()
bandpass(signalNoise{5},bandWorkHigh,Fs);
title('E')
figure()
bandpass(signalNoise{6},bandWorkHigh,Fs);
title('F')
figure()
bandpass(signalNoise{7},bandWorkHigh,Fs);
title('G')
figure()
bandpass(signalNoise{8},bandWorkHigh,Fs);
title('H')
figure()
bandpass(signalNoise{9},bandWorkHigh,Fs);
title('I')
figure()
bandpass(signalNoise{10},bandWorkHigh,Fs);
title('J')
figure()
bandpass(signalNoise{11},bandWorkHigh,Fs);
title('K')
figure()
bandpass(signalNoise{12},bandWorkHigh,Fs);
title('L')
figure()
bandpass(signalNoise{13},bandWorkHigh,Fs);
title('M')

%%


figure()
bandpass(signalNoise{2},bandWorkHigh,Fs)
title('Transceiver 2')

figure()
bandpass(signalNoise{3},bandWorkHigh,Fs)
title('Transceiver 3')

figure()
bandpass(signalNoise{4},bandWorkHigh,Fs)
title('Transceiver 4')

figure()
bandpass(signalNoise{5},bandWorkHigh,Fs)
title('Transceiver 5')

figure()
bandpass(signalNoise{6},bandWorkHigh,Fs)
title('Transceiver 6')

figure()
bandpass(signalNoise{7},bandWorkHigh,Fs)
title('Transceiver 7')

figure()
bandpass(signalNoise{8},bandWorkHigh,Fs)
title('Transceiver 8')

figure()
bandpass(signalNoise{9},bandWorkHigh,Fs)
title('Transceiver 9')

figure()
bandpass(signalNoise{10},bandWorkHigh,Fs)
title('Transceiver 10')

figure()
bandpass(signalNoise{11},bandWorkHigh,Fs)
title('Transceiver 11')

figure()
bandpass(signalNoise{12},bandWorkHigh,Fs)
title('Transceiver 12')

figure()
bandpass(signalNoise{13},bandWorkHigh,Fs)
title('Transceiver 13')

%
figure()
mscohere(signalNoise{5},signalCrossTides{5})




% Filter white noise sampled at 1 kHz with a bandpass filter with
% passband frequencies of [150, 350] Hz. Use different steepness values.
% Plot the spectra of the filtered signals as well as the responses
% of the resulting filters. 
Fs = 1000;
x = randn(2000,1);
[y1, D1] = bandpass(x,[150,350],Fs,'Steepness',0.5);
[y2, D2] = bandpass(x,[150,350],Fs,'Steepness',0.8);
[y3, D3] = bandpass(x,[150,350],Fs,'Steepness',0.95);
pspectrum([y1 y2 y3], Fs)
legend('Steepness = 0.5','Steepness = 0.8','Steepness = 0.95')
fvt = fvtool(D1,D2,D3);
legend(fvt,'Steepness = 0.5','Steepness = 0.8','Steepness = 0.95')







