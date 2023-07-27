% FM20222, Read in moored detection & noise data from transceivers at
% Gray's Reef

%First section: Read in and format data

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Moored'

%Separate dets, temps, and noise by which receiver is giving the data
data = readtable('VUE_Export.csv');
%SWITCHED: BELOW LINES TAKES OUT TWO TRANSCEIVERS WHICH WERE NOT HEARD AT
%ALL, NOT EVEN BY THEMSELVES, HURTING AVERAGE FM 4/7/22
forbiddenReceivers = ['VR2Tx-483067';'VR2Tx-483068'];
data(ismember(data.Receiver,forbiddenReceivers),:)=[];
%


%%
dataDN = datenum(data.DateAndTime_UTC_);
uniqueReceivers = unique(data.Receiver);
for PT = 1:length(uniqueReceivers)
    tempIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Temperature');
    detectionIndex{PT,1} = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Detections on 69 kHz');
    noiseIndex{PT,1}     = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Average noise');
    pingIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Pings on 69 kHz');
    
    
    receiverData{PT}.bottomTemp(:,1) = dataDN(tempIndex{PT}); receiverData{PT}.bottomTemp(:,2) = data.Data(tempIndex{PT});
    receiverData{PT}.hourlyDets(:,1) = dataDN(detectionIndex{PT}); receiverData{PT}.hourlyDets(:,2) = data.Data(detectionIndex{PT});
    receiverData{PT}.avgNoise(:,1)   = dataDN(noiseIndex{PT}); receiverData{PT}.avgNoise(:,2) = data.Data(noiseIndex{PT});
    receiverData{PT}.pings(:,1)      = dataDN(pingIndex{PT});  receiverData{PT}.pings(:,2)    = data.Data(pingIndex{PT});
end
%%
for PT = 1:length(receiverData)
    TotalAvgNoise(PT,1) = mean(receiverData{PT}.avgNoise(:,2));
    time = datetime(receiverData{PT}.avgNoise(:,1),'ConvertFrom','datenum','TimeZone','UTC');
    time.TimeZone = 'local';
    uniqueNoise{PT} = table2timetable(table(time,receiverData{PT}.avgNoise(:,2)));
    uniqueNoise{PT}.Properties.VariableNames = {'Noise'};
    uniqueDets{PT} = table2timetable(table(time,receiverData{PT}.hourlyDets(:,2)));
end

for PT = 1:length(uniqueNoise)
    dailyUniqueNoise{PT} = retime(uniqueNoise{PT},'daily','mean');
    dailyUniqueDets{PT}   = retime(uniqueDets{PT}, 'daily','mean');
end

%%
%Second section: Plot "flag" graphs, showing easy/medium/challenging
%environments

%Create limits for "Noise Flag"
ylimE   = [0 300];        % Optimal mode, good for transmission
ylimM   = [301 650];   %Moderate mode, variable for transmission
ylimH   = [651 950];   %Challenging mode, tough on transmissions

%Plot the daily averaged noise values over the course of 2020
figure()
plot(dailyUniqueNoise{11}.time(20:end),dailyUniqueNoise{11}.Noise(20:end));
hold on
patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimE(1) ylimE(1), ylimE(2) ylimE(2)], [0 1 0],'FaceAlpha',0.4)
patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimM(1) ylimM(1), ylimM(2) ylimM(2)], [1 1 0],'FaceAlpha',0.4)
patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimH(1) ylimH(1), ylimH(2) ylimH(2)], [1 0 0],'FaceAlpha',0.4)
for PT = 1:length(uniqueNoise)
    plot(dailyUniqueNoise{PT}.time(20:end),dailyUniqueNoise{PT}.Noise(20:end));
    caption = sprintf('Ayo, this is %d',PT);
    fprintf('%s\n',caption);
%     pause
end
ylabel('Ambient Noise (mV)');
xlabel('Daily');
title('VEMCO''s Reported Environmental Noise Levels');

%Plot the hourly averaged noise values over the course of 2020
% figure()
% plot(uniqueNoise{11}.time,uniqueNoise{11}.Noise);
% hold on
% patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimE(1) ylimE(1), ylimE(2) ylimE(2)], [0 1 0],'FaceAlpha',0.4)
% patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimM(1) ylimM(1), ylimM(2) ylimM(2)], [1 1 0],'FaceAlpha',0.4)
% patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimH(1) ylimH(1), ylimH(2) ylimH(2)], [1 0 0],'FaceAlpha',0.4)
% for PT = 1:length(uniqueNoise)
%     plot(uniqueNoise{PT}.time,uniqueNoise{PT}.Noise);
% end
% ylabel('Ambient Noise (mV)');
% xlabel('Hourly');
% 
% title('VEMCO''s Reported Environmental Noise Levels');

%%
%Third section: separate data by type and isolates the 2020 data. This is
%the year where almost all transceivers were  operating for the entire year



%Separates data by type, doesn't care what receiver gives it
allTempIndex      = strcmp(data.Description,'Temperature');
allDetectionIndex = strcmp(data.Description,'Hourly Detections on 69 kHz');
allNoiseIndex     = strcmp(data.Description,'Average noise');
allPingsIndex     = strcmp(data.Description,'Hourly Pings on 69 kHz');


allTemperatures(:,1)   = dataDN(allTempIndex); allTemperatures(:,2)   = data.Data(allTempIndex);
allDetections(:,1)     = dataDN(allDetectionIndex); allDetections(:,2)   = data.Data(allDetectionIndex);
allNoises(:,1)         =dataDN(allNoiseIndex); allNoises(:,2)   = data.Data(allNoiseIndex);
allPings(:,1)         =dataDN(allPingsIndex); allPings(:,2)   = data.Data(allPingsIndex);
estTemperatures(:,1) = datetime(allTemperatures(:,1),'ConvertFrom','datenum');

index2020 = [9009:99261];
% %Separate only the 2020 data
detections2020   = allDetections(index2020,:);
noises2020       = allNoises(index2020,:);
pings2020        = allPings(index2020,:);
temp2020         = allTemperatures(index2020,:);




%Datetimes for both detections and noise data, and tables
Time= datetime(detections2020(:,1),'ConvertFrom','datenum','TimeZone','UTC'); Time.TimeZone = 'local';
start1 = table(Time,detections2020(:,2),noises2020(:,2),temp2020(:,2)); tableDetections   = table2timetable(start1);


tableDetections.Properties.VariableNames = {'Detections','Noise','Temperature'};

%Retiming: this takes averages from a timetable. Hourly, daily, and monthly
%averages and standard deviations
hourlyAVG= retime(tableDetections,'hourly','mean');
hourlyVAR= retime(tableDetections,'hourly',@std);

dailyAVG = retime(tableDetections,'daily','mean');
dailyVAR = retime(tableDetections,'daily',@std);

monthlyAVG = retime(tableDetections,'monthly','mean');
monthlyVAR = retime(tableDetections,'monthly',@std);
% 
% rr=3;
% cc=4;
% figure()
% set(gcf,'Position',[300 10 1000 600]);
% s1 = subaxis(rr,cc,1:4,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.08,'MarginBot',0.15,'SpacingHoriz',0.02,'SpacingVert',0.04);
% yyaxis left
% scatter(hourlyAVG.Time,hourlyAVG.Detections);
% title('Ambient Noise''s Relationship to Detections: Hourly, Daily & Monthly');
% yyaxis right
% scatter(hourlyAVG.Time,hourlyAVG.Noise);
% s2 = subaxis(rr,cc,5:8,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.08,'MarginBot',0.15,'SpacingHoriz',0.02,'SpacingVert',0.04);
% yyaxis left
% scatter(dailyAVG.Time,dailyAVG.Detections);
% ylabel('Detections');
% yyaxis right
% scatter(dailyAVG.Time,dailyAVG.Noise);
% ylabel('Noise (mV, 69 kHz)');
% s3 = subaxis(rr,cc,9:12,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.08,'MarginBot',0.15,'SpacingHoriz',0.02,'SpacingVert',0.04);
% yyaxis left
% plot(monthlyAVG.Time,monthlyAVG.Detections);
% scatter(monthlyAVG.Time,monthlyAVG.Detections,'filled');
% ylim([7 13])
% yyaxis right
% plot(monthlyAVG.Time,monthlyAVG.Noise);
% scatter(monthlyAVG.Time,monthlyAVG.Noise,'filled');
% ylim([500 750])
% 


%Separating Challenging vs Not Challenging
indexUp     = hourlyAVG.Noise > 650;
indexDown= hourlyAVG.Noise < 650;
howMany(1) = sum(indexUp)
howMany(2) = sum(indexDown)

%Find averages of hourly detections between moderate and challenging
%environments
detectionsOver = hourlyAVG.Detections(indexUp);
detectionsUnder = hourlyAVG.Detections(indexDown);
avgDetectionsOver  = mean(detectionsOver)
avgDetectionsUnder= mean(detectionsUnder)

%26% increase in average detections when going from Challenging
%Environments to Optimal/Moderate





%%
%Fourth section: play with shading of day and night. SunriseSunset finds
%the time

SunriseSunsetUTC
sunlightShading

lightIndex = [sunrise; sunset];

binaryLight = zeros(8569,1);
for k =1:length(sunrise)
    current = [sunrise(k); sunset(k)]
    index = isbetween(hourlyAVG.Time,sunrise(k),sunset(k))
    binaryLight = binaryLight + index
end



%Datetimes FYI
dtDetections = datetime(allDetections(:,1),'ConvertFrom','datenum');
dtNoise = datetime(allNoises(:,1),'ConvertFrom','datenum');







%%
%Fifth section: Preparing data for statistical analysis

% Exporting data to R or otherwise, .csv matrices
averagesDaily     = [dailyAVG.Detections, dailyAVG.Noise, dailyAVG.Temperature];
averagesMonthly   = [monthlyAVG.Detections, monthlyAVG.Noise, monthlyAVG.Temperature];
%Maybe just to 8562? Steep drop off in detections, few may have gone out of
%service

averagesHourly      = [hourlyAVG.Detections, hourlyAVG.Noise, hourlyAVG.Temperature];
% 
% writematrix(averagesHourly,'averagesHourlyNew.csv');
% 
% writematrix(averagesDaily, 'averagesDailyNew.csv');
% writematrix(averagesMonthly, 'averagesMonthlyNew.csv');

%%
% Adding daylength and sunlight cycles
close all

figure()
SunriseSunsetUTC

dayLength = sunset - sunrise;




x = 1:length(dayLength);

figure()
plot(x,dayLength);
xlabel('Day');
ylabel('Hours of Sunlight');
title('Annual Day Length, 2020');
xlim([0 365])


minDayL = min(dayLength);
maxDayL = max(dayLength);

figure()
plot(dailyAVG.Time,dailyAVG.Detections);
title('AVG Daily Dets');
ylabel('Hr. Detections');

figure()
plot(dailyAVG.Time,dailyAVG.Noise);
title('AVG Daily Noise');
ylabel('Hr. Noise (mV, 69 kHz)');

%How to make a variable out of "is it day or night?"
%Sun up is 1, sun down is 0
sunRun = [sunrise; sunset];
xx = length(sunRun);

hourlyAvg{4} = 0;
sunlight = zeros(1,height(hourlyAVG));


for k = 1:xx
    currentSun = sunRun(:,k);
    currentHours = isbetween(hourlyAVG.Time,currentSun(1,1),currentSun(2,1))
    currentDays = find(currentHours);
    sunlight(currentDays) = 1;
end

%This variable now gives a 1 if daytime and a 0 if nighttime!
hourlyAVG = addvars(hourlyAVG,sunlight','NewVariableNames','DayNight')




%breaking the year into seasons, not a very novel idea BUT shows stronger
%diurnal signal in winter, more mixed water column
seasonalSignalsBlant
% 

seasons = zeros(1,height(hourlyAVG));
%Using seasonalSignalsBlant, need to give 1-5 to denote season.
seasons(winter) = 1; seasons(spring) = 2; seasons(summer) = 3; seasons(fall) = 4; seasons(Mfall) = 5;

hourlyAVG = addvars(hourlyAVG,seasons','NewVariableNames','Season');

%FM 12/4 creating averages for day and night, focusing on seasonal &
%diurnal differences

idxy = winterBin{:,4}>0;
winterDays   = winterBin{idxy,:};
winterNights = winterBin{~idxy,:};
winterDayMean = mean(winterDays(:,1:2))
winterNightMean = mean(winterNights(:,1:2))
daymax = max(winterDays(:,2))
nightmax = max(winterNights(:,2))



idxy = springBin{:,4}>0;
springDays   = springBin{idxy,:};
springNights = springBin{~idxy,:};
springDayMean = mean(springDays(:,1:2))
springNightMean = mean(springNights(:,1:2))
daymax = max(springDays(:,2))
nightmax = max(springNights(:,2))

idxy = summerBin{:,4}>0;
summerDays   = summerBin{idxy,:};
summerNights = summerBin{~idxy,:};
summerDayMean = mean(summerDays(:,1:2))
summerNightMean = mean(summerNights(:,1:2))
daymax = max(summerDays(:,2))
nightmax = max(summerNights(:,2))

idxy = fallBin{:,4}>0;
fallDays   = fallBin{idxy,:};
fallNights = fallBin{~idxy,:};
fallDayMean = mean(fallDays(:,1:2))
fallNightMean = mean(fallNights(:,1:2))
daymax = max(fallDays(:,2))
nightmax = max(fallNights(:,2))

idxy = MfallBin{:,4}>0;
MfallDays   = MfallBin{idxy,:};
MfallNights = MfallBin{~idxy,:};
MfallDayMean = mean(MfallDays(:,1:2))
MfallNightMean = mean(MfallNights(:,1:2))
daymax = max(MfallDays(:,2))
nightmax = max(MfallNights(:,2))







%Now I can use all the bins (winterBin,
%springBin,summerBin,fallBin,MfallBin)
% testDay = summerBin(useColumn==1,:);





% %Signal
% detectionSignal = hourlyAVG.Detections;
% %Windowing: Looking at 15 day window
% win=24*15;
% %Sampling: once per hour
% sampleFreq = 1/3600;
% 
% %Welch's Power Spectrum for our signal, 95% confidence, then plotting on
% %loglog scale
% [pxx,f]= pwelch(detectionSignal,win,[],[],sampleFreq,'onesided','ConfidenceLevel',.95);
% figure()
% loglog(f.*86400,pxx.*f);
% ylabel('Power');
% xlabel('1 Day Frequency');
% title('2020 Detection, Freq. Spectrum');
% 
% %Signal
% noiseSignal= hourlyAVG.Noise;
% %Same window and sampling frequency as above
% [pxxNoise,fNoise]= pwelch(noiseSignal,win,[],[],sampleFreq,'onesided','ConfidenceLevel',.95);
% 
% figure()
% loglog(fNoise.*86400,pxxNoise.*fNoise,'r');
% ylabel('Power');
% xlabel('1 Day Frequency');
% title('2020 Noise, Freq. Spectrum');



%%
%Seventh Section: Failed attempts at lowpass filtering. Just slices off the
%parts I don't like, this ain't shop class, not effective

% cutoff = (1/18000);     %40 hours
% Wn = cutoff/(0.5*sampleFreq);
% [B,A] = butter(5,Wn,'low');
% detsX = filtfilt(B,A,detectionSignal);
% 
% [pxxLow,fLow]= pwelch(detsX,win,[],[],sampleFreq,'onesided','ConfidenceLevel',.99);
% 
% figure()
% loglog(fLow.*86400,pxxLow.*fLow,'b');
% title('Det Frequency, Lowpass 5 hours');
% 
% 
% cutoff = (1/18000);     %40 hours
% Wn = cutoff/(0.5*sampleFreq);
% [B,A] = butter(5,Wn,'low');
% detsF = filtfilt(B,A,noiseSignal);
% 
% [pxxLowN,fLowN]= pwelch(detsF,win,[],[],sampleFreq,'onesided','ConfidenceLevel',.99);
% 
% figure()
% loglog(fLowN.*86400,pxxLowN.*fLowN,'r');
% title('Noise Frequency, Lowpass 5 hours');
% 
% 
% figure()
% loglog(fLowN.*86400,pxxLowN.*fLowN,'r');
% hold on
% loglog(fLow.*86400,pxxLow.*fLow,'b');
% legend('Hourly Noise','Hourly Dets');
% title('Lowpass Filter of Noise & Detections, 15 day window');
% ylabel('Power');
% xlabel('Cycles Per Day');
% 
% %% Temperature examples
% 
% tempSignal = hourlyAVG.Temperature;
% sampleFreq = 1/3600;
% win = 24*200;
% [pxxTemp,fTemp] = pwelch(tempSignal,win,[],[],sampleFreq,'onesided','ConfidenceLevel',.95);
% 
% figure()
% loglog(fTemp.*86400,pxxTemp.*fTemp,'r');
% ylabel('Power');
% xlabel('1 Day Frequency');
% title('2020 Temp, Freq. Spectrum');
% 
% 
% %% Plotting together
% 
% 
% 
% figure()
% yyaxis left 
% loglog(f.*86400,pxx.*f,'b');
% ylabel('Power');
% xlabel('1 Day Frequency');
% yyaxis right
% loglog(fNoise.*86400,pxxNoise.*fNoise,'r');
% legend('Detections','Noise Levels');
% title('Correlation between Detection & Noise Trends');
% 
% 
% 
% 
%%



figure()
yyaxis left
scatter(dailyAVG.Time,dailyAVG.Detections)
hold on
plot(dailyAVG.Time,dailyAVG.Detections)
ylabel('Detections');
yyaxis right
scatter(dailyAVG.Time,dailyAVG.Noise);
plot(dailyAVG.Time,dailyAVG.Noise);
ylabel('Noise (mV)');
title('Daily Averages @ Gray''s Reef, 2020');
dynamicDateTicks()
%%
detectionSignal = dailyAVG.Detections;

win=30;
sampleFreq = 1/86400;
% [pxx,f]= pwelch(FMsignal,win,[],[],sampleFreq,'onesided','ConfidenceLevel',.95);
[pxx,f]= pwelch(detectionSignal,win,[],[],sampleFreq,'onesided','ConfidenceLevel',.99);
figure()
loglog(f,pxx.*f);
ylabel('Power');
xlabel('');
title('2020 Daily Avgs, Freq. Spectrum');


%%





figure()
yyaxis left
scatter(monthlyAVG.Time,monthlyAVG.Detections,60,'filled')
ylabel('Detections');
title('Monthly Averages @ Gray''s Reef');
hold on
yyaxis right
scatter(monthlyAVG.Time,monthlyAVG.Noise,60,'filled');
ylabel('Noise (mV)');

figure()
yyaxis left
scatter(hourlyAVG.Time,hourlyAVG.Detections,'filled');
hold on 
plot(hourlyAVG.Time,hourlyAVG.Detections);
ylabel('Detections');
yyaxis right
scatter(hourlyAVG.Time,hourlyAVG.Noise,'filled');
plot(hourlyAVG.Time,hourlyAVG.Noise);
ylabel('Noise (mV)');
title('Hourly Averages @ Gray''s Reef, 2020');
dynamicDateTicks()


%% Adding errorbars testing for variance
figure()
scatter(hourlyAVG.Time,hourlyAVG.Noise);
hold on
errorbar(hourlyAVG.Time,hourlyAVG.Noise,hourlyVAR.Noise);
% plot(hourlyNoiseAVG.noiseTime,hourlyNoiseAVG.Noise);
ylabel('Noise (mV)');
title('Hourly Avg. Noise @ Reef, 2020');

figure()
scatter(dailyAVG.Time,dailyAVG.Noise);
hold on
errorbar(dailyAVG.Time,dailyAVG.Noise,dailyVAR.Noise);
% plot(hourlyNoiseAVG.noiseTime,hourlyNoiseAVG.Noise);
ylabel('Noise (mV)');
title('Daily Avg. Noise @ Reef, 2020');

figure()
scatter(monthlyAVG.Time,monthlyAVG.Noise);
hold on
errorbar(monthlyAVG.Time,monthlyAVG.Noise,monthlyVAR.Noise);
% plot(hourlyNoiseAVG.noiseTime,hourlyNoiseAVG.Noise);
ylabel('Noise (mV)');
title('Hourly Avg. Noise @ Reef, 2020');
% 
% figure()
% rr = 2
% cc = 8
% s1 = subaxis(rr,cc,1:8,'SpacingVert',0.1)
% hold on
% scatter(hourlyAVG.Time,hourlyAVG.Detections,'b')
% hold on
% plot(hourlyAVG.Time,hourlyAVG.Detections,'b')
% title('2020, Detections and Noise');
% ylabel('Hourly Detections');
% dynamicDateTicks()
% hold off
% 
% s2=subaxis(rr,cc,9:16)
% scatter(hourlyAVG.Time,hourlyAVG.Noise,'r');
% hold on
% plot(hourlyAVG.Time,hourlyAVG.Noise,'r'); 
% ylabel('Ambient Noise (mV)');
% dynamicDateTicks()



