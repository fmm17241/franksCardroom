buildReceiverData
clearvars -except receiverData oneDrive githubToolbox
close all

%
%Brock's Code: data, # of bins, Detrend?, Window?, Interval (secs), cutoff
% dataout=Power_spectra(datainA,bins,DT,windoww,samplinginterval,cutoff)
for COUNT = 1:length(receiverData)
    signalNoise{COUNT}  =   receiverData{COUNT}.Noise;
    signalDets{COUNT}   =   receiverData{COUNT}.HourlyDets;
    signalPings{COUNT}  =   receiverData{COUNT}.Pings;
    signalWinds{COUNT}  =   receiverData{COUNT}.windSpd;
end

%%

Fs = (2*pi)/(60*60);            % Sampling frequency, 1 sample every 60 minutes. Added 2pi.
FsPerDay = Fs*86400;



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





for COUNT = 1:length(receiverData)
    figure()
    plot(FsPerDay/L{COUNT}*(0:L{COUNT}-1),struct.psdf)
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


for COUNT = 1:length(receiverData)
    figure(COUNT)
    % plot(FsPerDay/L{1}*(0:L{1}-1),abs(rawSignalProcess.*conj(rawSignalProcess)),'r',"LineWidth",3)
    plot(FsPerDay/L{COUNT}*(0:L{COUNT}-1),abs(Y{COUNT}),'r',"LineWidth",3)    
    title("", "FFT Output, Log")
    xlabel("f (Hz)")
    ylabel("|fft(X)|")
    set(gca,'XScale','log')
    set(gca,'YScale','log')
end


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


for COUNT = 1:length(receiverData)
    figure(COUNT)
    % plot(FsPerDay/L{1}*(0:L{1}-1),abs(rawSignalProcess.*conj(rawSignalProcess)),'r',"LineWidth",3)
    plot(FsPerDay/L{COUNT}*(0:L{COUNT}-1),abs(averageWindowOutput{COUNT}),'r',"LineWidth",3)    
    title("", "FFT Output, Log")
    xlabel("f (Hz)")
    ylabel("|fft(X)|")
    set(gca,'XScale','log')
    set(gca,'YScale','log')
end













