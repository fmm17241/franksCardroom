stationWindsAnalysis


%Load in the detection files
cd ([oneDrive,'Moored\GRNMS\VRLs'])
rawDetFile{1,1} = readtable('VR2Tx_483062_20211112_1.csv'); %SURTASSSTN20
rawDetFile{2,1} = readtable('VR2Tx_483064_20211025_1.csv'); %SURTASS05IN
rawDetFile{3,1} = readtable('VR2Tx_483066_20211018_1.csv'); %Roldan
rawDetFile{4,1} = readtable('VR2Tx_483067_20211112_3.csv'); %33OUT
rawDetFile{5,1} = readtable('VR2Tx_483068_20211223_1.csv'); %FS17
rawDetFile{6,1} = readtable('VR2Tx_483070_20211223_1.csv'); % 08C
rawDetFile{7,1} = readtable('VR2Tx_483073_20211112_4.csv'); %STSNew1
rawDetFile{8,1} = readtable('VR2Tx_483074_20211025_1.csv'); %STSNEW2
rawDetFile{9,1} = readtable('VR2Tx_483075_20211025_1.csv'); %FS6
rawDetFile{10,1} = readtable('VR2Tx_483076_20211018_1.csv'); %08ALTIN
rawDetFile{11,1} = readtable('VR2Tx_483079_20211130_1.csv'); %34ALTOUT
rawDetFile{12,1} = readtable('VR2Tx_483080_20211223_1.csv'); %09T
rawDetFile{13,1} = readtable('VR2Tx_483081_20211005_1.csv'); %39IN

%Frank's adding in measure of when they hear themselves
selfID = ['A69-1601-63062';'A69-1601-63064';'A69-1601-63066';'A69-1601-63067';...
    'A69-1601-63068';'A69-1601-63070';'A69-1601-63073';'A69-1601-63074';...
    'A69-1601-63075';'A69-1601-63076';'A69-1601-63079';'A69-1601-63080';...
    'A69-1601-63081'];

for transceiver = 1:length(rawDetFile)
    heardSelf{transceiver} = strcmp(rawDetFile{transceiver,1}.Var3,selfID(transceiver,:))
    countSelfDetects(transceiver,1) = sum(heardSelf{transceiver});
end

%4 and 5 never heard themselves

selfDetects{transceiver} = rawDetFile{transceiver,heardSelf{transceiver}};

%%FM 5/24: trying bulk strat using bottom receiver + buoy info
cd ([oneDrive,'Moored'])
% Separate dets, temps, and noise by which receiver is giving the data
data = readtable('VUE_Export.csv');


dataDN = datenum(data.DateAndTime_UTC_);
dataDT = datetime(dataDN,'convertFrom','datenum');

%FM 3/6/23 Ordered the transceivers and doubled some up; this is to match
%the transceiver order listed in "matchAngles"/"thetaFinder"
%FM 11/16/23 NEW Frank says that's dumb. We shall go in numerical order, so
%it is written so shall it be done.
uniqueReceivers =  [{'VR2Tx-483062';  % 'VR2Tx-483062' SURTASSSTN20, A
                     'VR2Tx-483064';   % 'VR2Tx-483064' SURTASS_05IN, B
                     'VR2Tx-483066';   % 'VR2Tx-483066' Roldan, C
                     'VR2Tx-483067';    % 33OUT, D
                     'VR2Tx-483068';    %FS17, E
                     'VR2Tx-483070';    %08C, F
                     'VR2Tx-483073';  % 'VR2Tx-483073' STSNew1, G
                     'VR2Tx-483074';   % 'VR2Tx-483074' STSNew2, H
                     'VR2Tx-483075';   % 'VR2Tx-483075' FS6, I
                     'VR2Tx-483076';     % 'VR2Tx-483076' 08ALTIN, J
                     'VR2Tx-483079';   % 34ALTOUT, K
                     'VR2Tx-483080';     %09T, L
                     'VR2Tx-483081'}]   % 'VR2Tx-483081' 39IN, M


%%
% uniqueReceivers = unique(data.Receiver);
letters = 'A':'M';
transceiverNames = {'SURTASSSTN20','SURTASS_05IN','Roldan','33OUT','FS17','08C','STSNew1','STSNew2',...
    'FS6','08ALTIN','34ALTOUT','09T','39IN'};

%Frank testing
for PT = 1:length(uniqueReceivers)
%     clearvars tempIndex detectionIndex noiseIndex pingIndex tiltIndex
    tempIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Temperature');
    detectionIndex{PT,1} = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Detections on 69 kHz');
    noiseIndex{PT,1}     = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Average noise');
    pingIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Pings on 69 kHz');
    tiltIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Tilt angle');
    

    receiverData{PT}     = table2timetable(table(datetime(dataDN(detectionIndex{PT}),'ConvertFrom','datenum','TimeZone','UTC'), ...
                                    dataDN(detectionIndex{PT}), ...
                                    data.Data(detectionIndex{PT}), ...
                                    data.Data(noiseIndex{PT}), ...
                                    data.Data(pingIndex{PT}), ...
                                    data.Data(tiltIndex{PT}), ...
                                    data.Data(tempIndex{PT})))
    receiverData{PT}.Properties.VariableNames = {'DN','HourlyDets','Noise','Pings','Tilt','Temp'};
    receiverData{PT}.Properties.DimensionNames{1} = 'DT'; 



    receiverIdentity{PT}        = {uniqueReceivers{PT},transceiverNames{PT}, letters(PT)};
end


months = month(dataDT);

%Winter: Jan/Feb/Nov/Dec
seasonIndex{1} = [1:2,11:12];
%Spring: Mar/Apr/May
seasonIndex{2} = [3:5];
%Summer: Jun/Jul
seasonIndex{3} = [6:7];
%Fall: Aug
seasonIndex{4} = [8];
%Mariner's Fall: Sept/Oct
seasonIndex{5} = [9:10];

%Frank trying to automate separation of months/seasons
for k = 1:length(receiverData)
    originalSeason   = zeros(height(receiverData{k}),1);
    % receiverData{k}.Season = 
    whatMonth{k}     = month(receiverData{k}.DT);
    receiverData{k}.Season = originalSeason;
    winter{k} = ismember(whatMonth{k},seasonIndex{1});
    spring{k} = ismember(whatMonth{k},seasonIndex{2});
    summer{k} = ismember(whatMonth{k},seasonIndex{3});
    fall{k}   = ismember(whatMonth{k},seasonIndex{4});
    mFall{k}  = ismember(whatMonth{k},seasonIndex{5});

    receiverData{k}.Season(winter{k}) = 1;
    receiverData{k}.Season(spring{k}) = 2;
    receiverData{k}.Season(summer{k}) = 3;
    receiverData{k}.Season(fall{k}) = 4;
    receiverData{k}.Season(mFall{k}) = 5;
end

%Frank cleaning up data from deploy/retrieve
%Not the prettiest, but this removes times where tilt and temperature are
%clearly showing its out of the water, or datetimes years after the last
%reliable data.
receiverData{1}= receiverData{1}(20:end,:);
receiverData{2}= receiverData{2}(17:end,:);
receiverData{3}= receiverData{3}(15:10154,:);
receiverData{4}= receiverData{4}(24:end,:);
% receiverData{5}= receiverData{5}(20:end,:);
receiverData{5}= receiverData{5}(555:end,:);

receiverData{6}= receiverData{6}(96:end,:);
receiverData{7}= receiverData{7}(96:end,:);
receiverData{8}= receiverData{8}(23:end,:);
receiverData{9}= receiverData{9}(17:end,:);
receiverData{10}= receiverData{10}(25:end,:);
receiverData{11}= receiverData{11}(4:7685,:);

receiverData{12}= receiverData{12}(3:end,:);
receiverData{13}= receiverData{13}(17:9373,:);


%%
%Frank adding sunlight variable
%Creates diurnal data
figure()
SunriseSunsetUTC2019
figure()
SunriseSunsetUTC2020
figure()
SunriseSunsetUTC2021


date    = [date2019, date2020, date2021];
sunrise = [sunrise2019,sunrise2020, sunrise2021];
sunset  = [sunset2019, sunset2020, sunset2021];

sunRun = [sunrise2019, sunrise2020; sunset2019, sunset2020];
close all
%Binary data: night or day
xx = length(sunRun);
sunlight = zeros(1,height(time));
for k = 1:xx
    currentSun = sunRun(:,k);
    currentHours = isbetween(time,currentSun(1,1),currentSun(2,1)); %FM 7/1
    currentDays = find(currentHours);
    sunlight(currentDays) = 1;
end

%Binary data: night or day
xx = length(sunRun);
for COUNT = 1:length(receiverData)
    receiverData{COUNT}.daytime = zeros(height(receiverData{COUNT}),1);
    for k = 1:xx
        currentSun = sunRun(:,k);
        currentHours = isbetween(receiverData{COUNT}.DT,currentSun(1,1),currentSun(2,1)); %FM 7/1
        currentDays = find(currentHours);
        receiverData{COUNT}.daytime(currentDays) = 1;
    end
end

%Frank needs to edit, add wind to data
for COUNT = 1:length(receiverData)
    fullWindIndex{COUNT} = isbetween(windsDT,receiverData{COUNT}.DT(1,1),receiverData{COUNT}.DT(end,1),'closed');
    receiverData{COUNT}.windSpd(:,1) = WSPD(fullWindIndex{COUNT});
    receiverData{COUNT}.windDir(:,1) = WDIR(fullWindIndex{COUNT});
end


%Frank creating Ping Ratio, very rough measure of efficiency
for COUNT = 1:length(receiverData)
    detPings = receiverData{COUNT}.HourlyDets.*8;
    receiverData{COUNT}.PingRatio = detPings./receiverData{COUNT}.Pings;
end




%%
% %Frank's testing which had the most pings/dets/noise to check hypothesis of
% %the reef being very loud
% for k = 1:length(receiverData)
%     testingAnnualPings(k) = mean(receiverData{k}.Pings);
%     testingAnnualNoise(k) = mean(receiverData{k}.Noise);
%     testingAnnualDets(k)  = mean(receiverData{k}.HourlyDets);
% end
% 
% 
% %Test difference in variables during different seasons
% for k = 1:length(receiverData)
%     for season = 1:5
%         testingPings(k,season) = mean(receiverData{k}.Pings(receiverData{k}.Season == season));
%         testingNoise(k,season) = mean(receiverData{k}.Noise(receiverData{k}.Season == season));
%         testingDets(k,season)  = mean(receiverData{k}.HourlyDets(receiverData{k}.Season == season));
% 
%         %Creating Confidence Intervals
%         %Noise
%         clearvars ts
%         SEMnoise{k}(season,:) = std(receiverData{k}.Noise(receiverData{k}.Season == season),'omitnan')/sqrt(length(receiverData{k}.Noise(receiverData{k}.Season == season)));  
%         ts = tinv([0.025  0.975],height(receiverData{k})-1);  
%         ciNoise{k}(season,:) = (mean(receiverData{k}.Noise(receiverData{k}.Season == season),'all','omitnan') + ts*SEMnoise{k}(season,:)); 
% 
% 
%         %Dets
%         clearvars ts
%         SEMdets{k}(season,:) = std(receiverData{k}.HourlyDets(receiverData{k}.Season == season),'omitnan')/sqrt(length(receiverData{k}.HourlyDets(receiverData{k}.Season == season)));  
%         ts = tinv([0.025  0.975],height(receiverData{k})-1);  
%         ciHourlyDets{k}(season,:) = (mean(receiverData{k}.HourlyDets(receiverData{k}.Season == season),'all','omitnan') + ts*SEMdets{k}(season,:)); 
% 
% 
% 
%         %Pings
%         clearvars ts
%         SEMpings{k}(season,:) = std(receiverData{k}.Pings(receiverData{k}.Season == season),'omitnan')/sqrt(length(receiverData{k}.Pings(receiverData{k}.Season == season)));  
%         ts = tinv([0.025  0.975],height(receiverData{k})-1);  
%         ciPings{k}(season,:) = (mean(receiverData{k}.Pings(receiverData{k}.Season == season),'all','omitnan') + ts*SEMpings{k}(season,:)); 
% 
% 
% 
%         %Tilt
%         clearvars ts
%         SEMtilt{k}(season,:) = std(receiverData{k}.Tilt(receiverData{k}.Season == season),'omitnan')/sqrt(length(receiverData{k}.Tilt(receiverData{k}.Season == season)));  
% 
%         ts = tinv([0.025  0.975],height(receiverData{k})-1);  
%         ciTilt{k}(season,:) = (mean(receiverData{k}.Tilt(receiverData{k}.Season == season),'all','omitnan') + ts*SEMtilt{k}(season,:)); 
% 
%     end
%     SEMnoise{k}(:,2)     = -SEMnoise{k};
%     SEMdets{k}(:,2)     = -SEMdets{k};
%     SEMtilt{k}(:,2)     = -SEMtilt{k};
%     SEMpings{k}(:,2)     = -SEMpings{k};
% end
% 
% X = 1:5;

%%
% FM detrending the noise data: removing the mean from all of my
% transceivers

% for k = 1:length(receiverData)
%     testingDetrend{k} = detrend(receiverData{k}.Noise,'constant')
% end

cd ([oneDrive,'exportedfigures\NoiseTesting'])

%Frank needs to define loud and quiet stations from the data
%LOUD: Average noise above 600 mV
%QUIET: Average noise below 600 mV
%Problem with this is that some were deployed for longer winter and such,
%might have to break down by season.

% 
% loudStations  = ['A','B','D','H','I','K','L']
% quietStations = ['C','E','F','G','J','M']
% 
% 
% figure()
% tiledlayout(3,1,'TileSpacing',"compact")
% ax1 = nexttile()
% hold on
% for k = 1:length(receiverData)
%     plot(receiverData{k}.DT,receiverData{k}.Noise)
% end
% title('Hourly High-Frequency Noise')
% ylabel('HF Noise (mV)')
% 
% ax2 = nexttile()
% hold on
% for k = 1:length(receiverData)
%     plot(receiverData{k}.DT,testingDetrend{k})
% end
% title('Hourly High-Frequency Noise','DeTrended, Removed Mean')
% ylabel('Detrended HF Noise (mV)')
% 
% ax3 = nexttile()
% plot(receiverData{4}.DT,receiverData{4}.windSpd,'k','LineWidth',1.5)
% ylim([0 12])
% ylabel('Windspeed (m/s)')
% title('Windspeed')
% 
% linkaxes([ax1 ax2 ax3],'x')
% 


%%

%Frank using "Point-Biserial Correlation Coefficient"
% %Continuous and nominal (day/night) variables
% clear tail r h p ci d x
% d = receiverData{5}.daytime;
% x = receiverData{5}.Noise;
% alpha = 0.05;
% tail  = 'right' ; % Left: Noise louder during nighttime; Right: Noise louder during daytime; Both: means are not equal.
% [r,h,p,ci] = pointbiserial(d,x,alpha,tail)
% 
% 
% %Now, two continuous variables: Noise and Windspeed
% 
% X = receiverData{4}.Noise;
% Y = receiverData{4}.windSpd;
% [rho,pval] = corr(X,Y,'rows','complete')
% 
% clearvars X Y rho pval
% X = receiverData{5}.Noise;
% Y = receiverData{5}.windSpd;
% [rho,pval] = corr(X,Y,'rows','complete')
% %Detrended noise did nothing to the relationship
% 
% % Two continuous variables: Hourly Dets and Windspeed
% X = receiverData{4}.HourlyDets;
% Y = receiverData{4}.windSpd;
% [rho,pval] = corr(X,Y,'rows','complete')
% 
% clearvars X Y rho pval
% X = receiverData{5}.HourlyDets;
% Y = receiverData{5}.windSpd;
% [rho,pval] = corr(X,Y,'rows','complete')

%%
%Frank tested "on and off reef", now do the same thing for all 13
%transcievers blind; let's see if its obvious which ones are on reef and
%which are not.


% for COUNT = 1:length(receiverData)
%     clearvars d x X Y
%     d = receiverData{COUNT}.daytime;
%     x = receiverData{COUNT}.Noise;
%     alpha = 0.05;
%     tail  = 'right' ; % Left: Noise louder during nighttime; Right: Noise louder during daytime; Both: means are not equal.
%     [r{COUNT},h{COUNT},p{COUNT},ci{COUNT}] = pointbiserial(d,x,alpha,tail)
% end
% 
% for COUNT = 1:length(receiverData)
%     X = receiverData{COUNT}.Noise;
%     Y = receiverData{COUNT}.windSpd;
%     [rho{COUNT},pval{COUNT}] = corr(X,Y,'rows','complete')
% end


%%
%FRANK add windspd vs season and noise vs season
%ANOVA
% for COUNT = 1:length(receiverData)
%     for SEASON = 1:5
%         currentIndex = receiverData{COUNT}.Season == SEASON;
% 
%         X = receiverData{COUNT}.Noise(currentIndex)
%         Y = receiverData{COUNT}.windSpd(currentIndex)
% 
%         [rhoSSN(COUNT,SEASON),pvalSSN(COUNT,SEASON)] = corr(X,Y,'rows','complete')
%     end
% end
% 
% for COUNT = 1:length(receiverData)
%     for SEASON = 1:5
%         currentIndex = receiverData{COUNT}.Season == SEASON;
% 
%         clearvars d x 
%         d = receiverData{COUNT}.daytime(currentIndex);
%         x = receiverData{COUNT}.Noise(currentIndex);
%         alpha = 0.05;
%         tail  = 'left' ; % Left: Noise louder during nighttime; Right: Noise louder during daytime; Both: means are not equal.
%         [rNightNoise{COUNT,SEASON},hNightNoise{COUNT,SEASON},pNightNoise{COUNT,SEASON},ciNightNoise{COUNT,SEASON}] = pointbiserial(d,x,alpha,tail)
%     end
% end

%%
%FRANK create ping ratio
% for COUNT = 1:length(receiverData)
%     X = receiverData{COUNT}.PingRatio;
%     Y = receiverData{COUNT}.windSpd;
%     [rho{COUNT},pval{COUNT}] = corr(X,Y,'rows','complete')
% end
%%
%FFT
% Using: receiverData{1-13}.Noise, Detections, yup
clearvars -except receiverData
%What I'm looking at. Starting with just one transceiver's data
signalNoise = receiverData{4}.Noise;


%This cuts the entire year+ dataset into 40 hour chunks
signalProcessed{1} = buffer(signalNoise,40,20);  

%This zero pads, adding 0s to the end of the signals to better resolve
%frequencies, tripling the length 
signalProcessed{1} = padarray(signalProcessed{1},height(signalProcessed{1})*2,'post');

%Set up FFT variables
Fs = (2*pi)/(60*60);            % Sampling frequency, 1 sample every 60 minutes. Added 2pi.
FsPerDay = Fs*86400;


Y{1} = fft(signalProcessed{1})              % FFT of the processed signals 
L{1} = length(signalProcessed{1})        % Length of signal
magnitude{1} = abs(Y{1});
averageWindowOutput(:,1) = mean(Y{1},2); %Averaging all my windows

figure()
plot(signalProcessed{1})

%Raw data
rawSignalProcess = fft(signalNoise)*Fs;
for COUNT = 1
    figure(COUNT)
    plot(FsPerDay/L{1}*(0:L{1}-1),abs(rawSignalProcess.*conj(rawSignalProcess)),'r',"LineWidth",3)
    
    title("", "FFT Output, Log")
    xlabel("f (Hz)")
    ylabel("|fft(X)|")
    set(gca,'XScale','log')
    set(gca,'YScale','log')
end



for COUNT = 1
    figure(COUNT)
    plot(Fs/L{COUNT}*(0:L{COUNT}-1),abs(averageWindowOutput(:,COUNT)),'r',"LineWidth",3)
    title("", "FFT Output, Log")
    xlabel("f (Hz)")
    ylabel("|fft(X)|")
    set(gca,'XScale','log')
    set(gca,'YScale','log')
end

%% 
%new Script
% data, bins, detrend?,window?,smpInterval(secs),cutoff,
PS = Power_spectra(signalNoise',80,0,1,1,0)













