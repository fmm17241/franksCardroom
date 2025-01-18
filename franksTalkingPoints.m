%%
%FM, we got this.


buildReceiverData   

fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)
% 
load envDataFall.mat
load snapRateDataFall.mat
load snapRateHourlyFall.mat
load surfaceDataFall.mat
load filteredData4Bin40HrLowFALLpruned.mat
times = envData.DT;

%%
% Load in saved data
% Environmental data matched to the hourly snaps.
load envDataSpring
% % Full snaprate dataset
load snapRateDataSpring
% % Snaprate binned hourly
load snapRateHourlySpring
% % Snaprate binned per minute
load snapRateMinuteSpring
load surfaceDataSpring
load filteredData4Bin40HrLowSPRING.mat
load gliderDataAprilMay.mat
times = surfaceData.time;



%%



[R,P] = corrcoef(filteredData.SBLcapped,filteredData.Noise)
Rsqrd = R(1,2)*R(1,2)


[R,P] = corrcoef(surfaceData.SBLcapped,envData.Noise)
Rsqrd = R(1,2)*R(1,2)

[R,P] = corrcoef(filteredData.BulkStrat,filteredData.Noise)
Rsqrd = R(1,2)*R(1,2)

[R,P] = corrcoef(filteredData.BottomTemp,filteredData.Snaps)
Rsqrd = R(1,2)*R(1,2)


% load snapRateDataFall.mat
% 
% load snapRateHourlyFall.mat

%Create monthly variables
surface = retime(surfaceData,'monthly','mean')
enviro = retime(envData,'monthly','mean')

shnapsAVG = retime(snapRateHourly,'monthly','mean')
shnapsVAR = retime(snapRateHourly,'monthly',@std)



%% 
%Frank calculating AVG/VARS for snap rate.
for k = 1:length(receiverData)
    hourlyAVG{k} = retime(receiverData{k},'hourly','mean');
    hourlyVAR{k}= retime(receiverData{k},'hourly',@std);

    dailyAVG{k} = retime(receiverData{k},'daily','mean');
    dailyVAR{k} = retime(receiverData{k},'daily',@std);
    
    monthlyAVG{k} = retime(receiverData{k},'monthly','mean');
    monthlyVAR{k} = retime(receiverData{k},'monthly',@std);
end
%
figure()
yyaxis left
plot(snapRateHourly.Time,snapRateHourly.SnapCount,'b','LineWidth',2)
ylabel('Snaprate (\hr)')
yyaxis right
plot(receiverData{1}.DT,receiverData{1}.HourlyDets,'LineWidth',2)
yyaxis right
ylabel('Detections')
legend('SnapRate','Detections')
title('Raw Hourly Snaps and Detections','Spring 2020, SURTASSTN20')
hold on
plot(monthlyAVG{1}.DT,monthlyAVG{1}.HourlyDets,'LineWidth',5)


%%AI generated testing.
% Aggregate daily
dailyAVG = retime(receiverData{1}, 'daily', 'mean');
dailySTD = retime(receiverData{1}, 'daily', @std);
dailyCOUNT = retime(receiverData{1}, 'daily', 'count'); % Count of observations per day

% Compute daily 95% CI
alpha = 0.05;
t_crit = tinv(1-alpha/2, dailyCOUNT.Variables - 1); % t critical values
dailyCI_upper = dailyAVG.Variables + t_crit .* (dailySTD.Variables ./ sqrt(dailyCOUNT.Variables));
dailyCI_lower = dailyAVG.Variables - t_crit .* (dailySTD.Variables ./ sqrt(dailyCOUNT.Variables));

% Aggregate monthly
monthlyAVG = retime(receiverData{1}, 'monthly', 'mean');
monthlySTD = retime(receiverData{1}, 'monthly', @std);
monthlyCOUNT = retime(receiverData{1}, 'monthly', 'count'); % Count of observations per month

% Compute monthly 95% CI
t_crit_monthly = tinv(1-alpha/2, monthlyCOUNT.Variables - 1);
monthlyCI_upper = monthlyAVG.Variables + t_crit_monthly .* (monthlySTD.Variables ./ sqrt(monthlyCOUNT.Variables));
monthlyCI_lower = monthlyAVG.Variables - t_crit_monthly .* (monthlySTD.Variables ./ sqrt(monthlyCOUNT.Variables));

% Interpolate NaNs in dailyCI_lower
dailyCI_lower = fillmissing(dailyCI_lower, 'linear', 'EndValues', 'nearest');

% Interpolate NaNs in dailyCI_upper
dailyCI_upper = fillmissing(dailyCI_upper, 'linear', 'EndValues', 'nearest');

% Interpolate NaNs in dailyAVG (mean values)
dailyAVG.Variables = fillmissing(dailyAVG.Variables, 'linear', 'EndValues', 'nearest');

% Aggregate daily averages and standard deviations
snapDailyAVG = retime(snapRateHourly, 'daily', 'mean');
snapDailySTD = retime(snapRateHourly, 'daily', @std);
snapDailyCOUNT = retime(snapRateHourly, 'daily', 'count'); % Count of observations per day

% Compute daily 95% CI
alpha = 0.05;
t_crit_daily = tinv(1-alpha/2, snapDailyCOUNT.SnapCount - 1);
snapDailyCI_upper = snapDailyAVG.SnapCount + t_crit_daily .* (snapDailySTD.SnapCount ./ sqrt(snapDailyCOUNT.SnapCount));
snapDailyCI_lower = snapDailyAVG.SnapCount - t_crit_daily .* (snapDailySTD.SnapCount ./ sqrt(snapDailyCOUNT.SnapCount));

% Handle NaNs
snapDailyCI_upper = fillmissing(snapDailyCI_upper, 'linear', 'EndValues', 'nearest');
snapDailyCI_lower = fillmissing(snapDailyCI_lower, 'linear', 'EndValues', 'nearest');
snapDailyAVG.SnapCount = fillmissing(snapDailyAVG.SnapCount, 'linear', 'EndValues', 'nearest');
% Aggregate monthly averages and standard deviations
snapMonthlyAVG = retime(snapRateHourly, 'monthly', 'mean');
snapMonthlySTD = retime(snapRateHourly, 'monthly', @std);
snapMonthlyCOUNT = retime(snapRateHourly, 'monthly', 'count'); % Count of observations per month

% Compute monthly 95% CI
t_crit_monthly = tinv(1-alpha/2, snapMonthlyCOUNT.SnapCount - 1);
snapMonthlyCI_upper = snapMonthlyAVG.SnapCount + t_crit_monthly .* (snapMonthlySTD.SnapCount ./ sqrt(snapMonthlyCOUNT.SnapCount));
snapMonthlyCI_lower = snapMonthlyAVG.SnapCount - t_crit_monthly .* (snapMonthlySTD.SnapCount ./ sqrt(snapMonthlyCOUNT.SnapCount));

% Handle NaNs
snapMonthlyCI_upper = fillmissing(snapMonthlyCI_upper, 'linear', 'EndValues', 'nearest');
snapMonthlyCI_lower = fillmissing(snapMonthlyCI_lower, 'linear', 'EndValues', 'nearest');
snapMonthlyAVG.SnapCount = fillmissing(snapMonthlyAVG.SnapCount, 'linear', 'EndValues', 'nearest');


% Example plot for daily CI
time = dailyAVG.DT;
snapTime = snapDailyAVG.Time;

%
figure()
ciplot(dailyCI_lower(:,1), dailyCI_upper(:,1), time,'b'); % Confidence interval shaded region
hold on;
plot(time, dailyAVG.Noise, 'r'); % Mean line
xlabel('Date');
ylabel('Daily Average');
title('Daily Average with 95% CI');

%%
figure()
% tiledlayout(2,4)
% ax1 = nexttile([2,2]);
ciplot(dailyCI_lower(:,14), dailyCI_upper(:,14), time,'r'); % Confidence interval shaded region
hold on;
plot(time, dailyAVG.HourlyDets, 'r'); % Mean line
xlabel('Date');
ylabel('Daily Average');
ylabel('Hourly Detections')
ylim([0 13])
yyaxis right
ciplot(snapDailyCI_lower, snapDailyCI_upper, snapTime,'b'); % Confidence interval shaded region
hold on
plot(snapTime, snapDailyAVG.SnapCount, 'r'); % Mean line
ylabel('Snaprate')
ylim([500 , 4700])
legend('Detections','','Snaprate')
% Change right axis color to black
ax = gca; % Get current axes
ax.YColor = 'k'; % Set right y-axis color to black
title('Daily Averages, Spring 2020 SURTASSTN20','95% CI shaded')
xlim([time(4) time(95)])


[R,P] = corrcoef(snapDailyAVG.SnapCount(4:95),dailyAVG.HourlyDets(4:95))

[R,P] = corrcoef(snapDailyAVG.SnapCount(4:95),dailyAVG.HourlyDets(4:95))

% Fuck it, lets try it.

figure()
tiledlayout(4,9)
ax1 = nexttile([3,9]);
ciplot(dailyCI_lower(:,14), dailyCI_upper(:,14), time,'r'); % Confidence interval shaded region
hold on;
plot(time, dailyAVG.HourlyDets, 'r'); % Mean line
xlabel('Date');
ylabel('Daily Average');
ylabel('Hourly Detections')
ylim([0 13])
yyaxis right
ciplot(snapDailyCI_lower, snapDailyCI_upper, snapTime,'b'); % Confidence interval shaded region
hold on
plot(snapTime, snapDailyAVG.SnapCount, 'r'); % Mean line
ylabel('Snaprate')
ylim([500 , 4700])
legend('Detections','','Snaprate')
% Change right axis color to black
ax = gca; % Get current axes
ax.YColor = 'k'; % Set right y-axis color to black
title('Daily Averages, Spring 2020 SURTASSTN20','95% CI shaded')
xlim([time(4) time(95)])


ax2 = nexttile([1,3])
yyaxis left
plot(surfaceData.time,surfaceData.WSPD,'LineWidth',3)
ylabel('Windspeed (m/s)')
ylim([0 15])
yyaxis right
plot(receiverData{1}.DT,receiverData{1}.HourlyDets,'k')
ylim([0 10])
% plot(dailyAVG.DT,dailyAVG.HourlyDets)
xlim([surfaceData.time(442), surfaceData.time(586)])
% ylabel('Detections')
title('Example Wind Event #1')
ax = gca; % Get current axes
ax.YColor = 'k'; % Set right y-axis color to black

ax3 = nexttile([1,3])
yyaxis left
plot(surfaceData.time,surfaceData.WSPD,'LineWidth',3)
% ylabel('Windspeed (m/s)')
ylim([0 15])
yyaxis right
plot(receiverData{1}.DT,receiverData{1}.HourlyDets,'k')
ylim([0 10])
xlim([surfaceData.time(630), surfaceData.time(793)])
% ylabel('Detections')
title('Example Wind Event #2')
ax = gca; % Get current axes
ax.YColor = 'k'; % Set right y-axis color to black

ax4 = nexttile([1,3])
yyaxis left
plot(surfaceData.time,surfaceData.WSPD,'LineWidth',3)
ylim([0 15])
% ylabel('Windspeed (m/s)')
yyaxis right
plot(receiverData{1}.DT,receiverData{1}.HourlyDets,'k')
ylim([0 10])
xlim([surfaceData.time(1402), surfaceData.time(1555)])
ylabel('Detections')
title('Example Wind Event #3')
legend('Windspeed','Detections')
ax = gca; % Get current axes
ax.YColor = 'k'; % Set right y-axis color to black

% ax2 = nexttile([2,2]);
% ciplot(dailyCI_lower(:,14), dailyCI_upper(:,14), time,'r'); % Confidence interval shaded region
% hold on;
% plot(time, dailyAVG.HourlyDets, 'r'); % Mean line
% xlabel('Date');
% ylabel('Daily Average');
% ylabel('Hourly Detections')
% ylim([0 13])
% yyaxis right
% ciplot(dailyCI_lower(:,7), dailyCI_upper(:,7), time,'k'); % Confidence interval shaded region
% hold on
% plot(time, dailyAVG.windSpd, 'k'); % Mean line
% ylabel('Windspeed (m/s)')
% ylim([0 15])
% legend('Detections','','Windspeed')
% % Change right axis color to black
% ax = gca; % Get current axes
% ax.YColor = 'k'; % Set right y-axis color to black
% title('Daily Averages, Spring 2020 SURTASSTN20','95% CI shaded')
% xlim([time(4) time(95)])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %Day Noise Confidence Intervals
% for k = 1:length(seasons)
%     %Finding standard deviations/CIs of values
%     SEM = std(daySounds{1,k}(:),'omitnan')/sqrt(length(daySounds{1,k}));  
%     ts = tinv([0.025  0.975],length(daySounds{1,k})-1);  
%     CIdayNoise(k,:) = mean(daySounds{:,k},'all','omitnan') + ts*SEM; 
% end

%Confidence Intervals

%Finding standard deviations/CIs of values
SEM = std(receiverData{1}.HourlyDets,'omitnan')/sqrt(length(receiverData{1}.HourlyDets));  
ts = tinv([0.025  0.975],length(receiverData{1}.HourlyDets-1));  
CIDets = mean(receiverData{1}.HourlyDets,'all','omitnan') + ts*SEM; 



figure()
hold on
% ciplot(CIsunsetNoise(:,1),CIsunsetNoise(:,2),1:5,'k')
ciplot(CInightNoise(:,1),CInightNoise(:,2),1:5,'b')
ciplot(CIdayNoise(:,1),CIdayNoise(:,2),1:5,'r')
xlabel('Seasons, 2020')
ylabel('Average Noise (mV)')
title('Average Noise By Time of Day and Season','95% Conf. Interval, 69 kHz')
legend('Night','Day')


%
decimatedData.Snaps = decimate(filteredData.Snaps,4);
decimatedData.Noise = decimate(filteredData.Noise,4);
decimatedData.Winds = decimate(filteredData.Winds,4);
decimatedData.Waves = decimate(filteredData.Waves,4);
decimatedData.Tides = decimate(filteredData.Tides,4);
decimatedData.TidesAbsolute = decimate(filteredData.TidesAbsolute,4);
decimatedData.WindDir = decimate(filteredData.WindDir,4);
decimatedData.SBL = decimate(filteredData.SBL,4);
decimatedData.SBLcapped = decimate(filteredData.SBLcapped,4);
decimatedData.Detections = decimate(filteredData.Detections,4);
decimatedData.SST = decimate(filteredData.SST,4);

%%
% Frank creating a variable to shade the darkness.
time = receiverData{1}.DT;
daytime = receiverData{1}.daytime;
nightmask = daytime == 0;

% Use area to shade the nighttime
hold on; % Keep the snap rate plot
area(time, nightMask * max(snapRateHourly.SnapCount), 'FaceColor', [0.8 0.8 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);



%%



figure()
TT = tiledlayout(3,4)
ax1 = nexttile([2,2])
yyaxis left
plot(times,filteredData.Snaps,'LineWidth',3)
ylabel('Snaprate (per Hour))')
yyaxis right
plot(times,filteredData.BottomTemp,'-.','LineWidth',3)
ylabel('Bottom Temp.(C)')
title('Snapping Shrimp Activity, Spring','40-Hr Lowpass Filter')

ax2 = nexttile([1,4])
plot(snapRateHourly.Time,snapRateHourly.SnapCount,'k','LineWidth',3)
set(gca,'YAxisLocation','left')
ylabel('Snaps Per Hour')
title('Daily Shrimp Activity')
% Use area to shade the nighttime
hold on; % Keep the snap rate plot
area(time, nightmask * max(snapRateHourly.SnapCount), 'FaceColor', [0.8 0.8 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
plot(snapRateHourly.Time,snapRateHourly.SnapCount,'k','LineWidth',3)

ax2 = nexttile([2,2])
yyaxis left
plot(times,filteredData.Snaps,'LineWidth',3)
ylabel('Snaprate (per Hour))')
yyaxis right
plot(times,filteredData.BottomTemp,'-.','LineWidth',3)
ylabel('Bottom Temp.(C)')
legend('Snap rate','Bottom Temp')
title('Snapping Shrimp Activity, Fall','40-Hr Lowpass Filter')

yyaxis left
ylabel('')
title('Snapping Shrimp Activity, Spring','40-Hr Lowpass Filter')
title('Snapping Shrimp Activity, Fall','40-Hr Lowpass Filter')


figure()
TT = tiledlayout(2,4)
ax1 = nexttile([1,4])
yyaxis left
plot(times(92:948),filteredData.SBLcapped(92:948),'b--','LineWidth',2)
ylim([0 16])
ylabel('SBL (dB)')
title('Surface Bubble Loss and Detections','SURTASSTN20, 40-hour lowpass filter')

yyaxis right
plot(times(92:948),filteredData.Detections(92:948),'r','LineWidth',2)
ylim([0 2.8])
ylabel('Detections')

legend('SBL','Detections')

ax2 = nexttile([1,4])
yyaxis left
plot(times(92:948),filteredData.SBLcapped(92:948),'b--','LineWidth',2)
ylim([0 16])
ylabel('SBL (dB)')


yyaxis right
plot(times(92:948),filteredData.Noise(92:948),'k','LineWidth',2)
ylim([525 700])
ylabel('HF Noise (mV)')
legend('SBL','Noise')

linkaxes([ax1,ax2],'x')
ax2.YAxis(2).Color = 'k';
title('Surface Bubble Loss and Noise (50-90 kHz)','SURTASSTN20, 40-hour lowpass filter')


% Make stats for above figure
starttime =   times(92);%Feb 3rd, 10:00
endtime    =  times(948);%Mar 10th, 02:00

noise = filteredData.Noise(92:948);
dets  = filteredData.Detections(92:948);
SBL   = filteredData.SBLcapped(92:948);

[R,P] = corrcoef(SBL,dets)
R(1,2)*R(1,2)
% R^2 = 0.39, p-val<0.01


[R,P] = corrcoef(SBL,noise)
R(1,2)*R(1,2)
% R^2 = 0.52, p-val<0.01

% 

% 
% 
% load envDataFall
% % Full snaprate dataset
% load snapRateDataFall
% % Snaprate binned hourly
% load snapRateHourlyFall
% % Snaprate binned per minute
% load snapRateMinuteFall
% load surfaceDataFall
% load filteredData4Bin40HrLowFALLpruned.mat
% 
% times = envData.DT;

figure()
yyaxis left
plot(filteredData.DT)




% 
% 
% if length(surfaceData.time) == 3308
%     surfaceData = surfaceData(1:2078,:);
%     snapRateHourly = snapRateHourly(1:2078,:);
%     times = times(1:2078,:);
% end
%%
% CReating daily averages
dayIndex = envData.daytime ==1;
daySnaps = snapRateHourly(dayIndex,:)
nightSnaps = snapRateHourly(~dayIndex,:)
dayAvgs = retime(daySnaps,'monthly','mean')
nightAvgs = retime(nightSnaps,'monthly','mean')
testingAvgPercent = (nightAvgs - dayAvgs)./dayAvgs
absoluteTides = abs(surfaceData.crossShore);


%%
%loops, find the loops, save the world
X = 1:length(filteredData.Noise);

%%
%Franks creating loop tables.

%Feb 5 00:00 - Feb 10 09:00 
%130-259
loop1Index = 130:259;
%
figure()
TR = tiledlayout(3,3)
ax0 = nexttile([3,1])
scatter(filteredData.SBLcapped,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBLcapped(loop1Index),filteredData.Noise(loop1Index),[],X(loop1Index),'filled')
xlabel('SBL')
ylabel('HFnoise')
title('Noise Attenuation')
legend({'Full','Selected'})

ax1 = nexttile([1,2])
yyaxis left
plot(times(loop1Index),filteredData.SBL(loop1Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop1Index),filteredData.Snaps(loop1Index),'LineWidth',2);
ylabel('Snaps')
title('Loop 1','SBL and Snaps')

ax2 = nexttile([1,2])
yyaxis left
plot(times(loop1Index),filteredData.SBL(loop1Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop1Index),filteredData.Noise(loop1Index),'LineWidth',2);
ylabel('Noise (mV)')
title('','SBL and Noise')

ax3 = nexttile([1,2])
yyaxis left
plot(times(loop1Index),filteredData.SBL(loop1Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop1Index),filteredData.Detections(loop1Index),'LineWidth',2);
ylabel('Detections')
title('','SBL and Detections')


%
loop1.Duration = length(surfaceData.WSPD(loop1Index))
loop1.WindMin = min(surfaceData.WSPD(loop1Index))
loop1.WindMax = max(surfaceData.WSPD(loop1Index))
%
loop1.DetsMin = min(envData.HourlyDets(loop1Index))
loop1.DetsMax = max(envData.HourlyDets(loop1Index))
%
[R P] = corrcoef(filteredData.Snaps(loop1Index),filteredData.SBLcapped(loop1Index))
loop1.SnapSBLRsqrd = R(1,2)*R(1,2)
loop1.SnapSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Noise(loop1Index),filteredData.SBLcapped(loop1Index))
loop1.NoiseSBLsqrd = R(1,2)*R(1,2)
loop1.NoiseSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Detections(loop1Index),filteredData.SBLcapped(loop1Index))
loop1.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop1.DetectionsSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.BulkStrat(loop1Index),filteredData.SBLcapped(loop1Index))
loop1.StratSBLsqrd = R(1,2)*R(1,2)
loop1.StratSBLpvalue = P(1,2)
%
[R P] = corrcoef(filteredData.BulkStrat(loop1Index),filteredData.Detections(loop1Index))
loop1.StratDetssqrd = R(1,2)*R(1,2)
loop1.StratDetspvalue = P(1,2)



%%
%Feb 12 04:00 - Feb 18 18:00 
%302-460
loop2Index = 302:460;
%
figure()
TR = tiledlayout(3,3)
ax0 = nexttile([3,1])
scatter(filteredData.SBLcapped,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBLcapped(loop2Index),filteredData.Noise(loop2Index),[],X(loop2Index),'filled');
xlabel('SBL')
ylabel('HFnoise')
title('Noise Attenuation')
legend({'Full','Selected'})

ax1 = nexttile([1,2])
yyaxis left
plot(times(loop2Index),filteredData.SBL(loop2Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop2Index),filteredData.Snaps(loop2Index),'LineWidth',2);
ylabel('Snaps')
title('Loop 2','SBL and Snaps')

ax2 = nexttile([1,2])
yyaxis left
plot(times(loop2Index),filteredData.SBL(loop2Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop2Index),filteredData.Noise(loop2Index),'LineWidth',2);
ylabel('Noise (mV)')
title('','SBL and Noise')

ax3 = nexttile([1,2])
yyaxis left
plot(times(loop2Index),filteredData.SBL(loop2Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop2Index),filteredData.Detections(loop2Index),'LineWidth',2);
ylabel('Detections')
title('','SBL and Detections')
%
loop2.Duration = length(surfaceData.WSPD(loop2Index))
loop2.WindMin = min(surfaceData.WSPD(loop2Index))
loop2.WindMax = max(surfaceData.WSPD(loop2Index))
%
loop2.DetsMin = min(envData.HourlyDets(loop2Index))
loop2.DetsMax = max(envData.HourlyDets(loop2Index))
%
[R P] = corrcoef(filteredData.Snaps(loop2Index),filteredData.SBLcapped(loop2Index))
loop2.SnapSBLsqrd = R(1,2)*R(1,2)
loop2.SnapSBLpvalue = P(1,2);

[R P] = corrcoef(filteredData.Noise(loop2Index),filteredData.SBLcapped(loop2Index))
loop2.NoiseSBLsqrd = R(1,2)*R(1,2)
loop2.NoiseSBLpvalue = P(1,2);

[R P] = corrcoef(filteredData.Detections(loop2Index),filteredData.SBLcapped(loop2Index))
loop2.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop2.DetectionsSBLpvalue = P(1,2);

%%
%Feb 18 19:00 - Feb 24 15:00
%461:601
loop3Index = 461:601;
%
figure()
TR = tiledlayout(3,3)
ax0 = nexttile([3,1])
scatter(filteredData.SBLcapped,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBLcapped(loop3Index),filteredData.Noise(loop3Index),[],X(loop3Index),'filled');
xlabel('SBL')
ylabel('HFnoise')
title('Noise Attenuation')
legend({'Full','Selected'})
ax1 = nexttile([1,2])
yyaxis left
plot(times(loop3Index),filteredData.SBL(loop3Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop3Index),filteredData.Snaps(loop3Index),'LineWidth',2);
ylabel('Snaps')
title('Loop 3','SBL and Snaps')

ax2 = nexttile([1,2])
yyaxis left
plot(times(loop3Index),filteredData.SBL(loop3Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop3Index),filteredData.Noise(loop3Index),'LineWidth',2);
ylabel('Noise (mV)')
title('','SBL and Noise')

ax3 = nexttile([1,2])
yyaxis left
plot(times(loop3Index),filteredData.SBL(loop3Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop3Index),filteredData.Detections(loop3Index),'LineWidth',2);
ylabel('Detections')
title('','SBL and Detections')

%
loop3.Duration = length(surfaceData.WSPD(loop3Index))
loop3.WindMin = min(surfaceData.WSPD(loop3Index))
loop3.WindMax = max(surfaceData.WSPD(loop3Index))
%
loop3.DetsMin = min(envData.HourlyDets(loop3Index))
loop3.DetsMax = max(envData.HourlyDets(loop3Index))
%
[R P] = corrcoef(filteredData.Snaps(loop3Index),filteredData.SBLcapped(loop3Index))
loop3.SnapSBLsqrd = R(1,2)*R(1,2)
loop3.SnapSBLpvalue = P(1,2)

[R P] = corrcoef(filteredData.Noise(loop3Index),filteredData.SBLcapped(loop3Index))
loop3.NoiseSBLsqrd = R(1,2)*R(1,2)
loop3.NoiseSBLpvalue = P(1,2)

[R P] = corrcoef(filteredData.Detections(loop3Index),filteredData.SBLcapped(loop3Index))
loop3.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop3.DetectionsSBLpvalue = P(1,2)

    
    [R P] = corrcoef(envData.HourlyDets(loop3Index),surfaceData.SBLcapped(loop3Index))

    
%%
%Mar. 30 03:00 - Apr. 3 12:00
%1429:1534
loop4Index = 1429:1534;
%
figure()
TR = tiledlayout(3,3)
ax0 = nexttile([3,1])
scatter(filteredData.SBLcapped,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBLcapped(loop4Index),filteredData.Noise(loop4Index),[],X(loop4Index),'filled');
xlabel('SBL')
ylabel('HFnoise')
title('Noise Attenuation')
legend({'Full','Selected'})
ax1 = nexttile([1,2])
yyaxis left
plot(times(loop4Index),filteredData.SBL(loop4Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop4Index),filteredData.Snaps(loop4Index),'LineWidth',2);
ylabel('Snaps')
title('Loop 4','SBL and Snaps')

ax2 = nexttile([1,2])
yyaxis left
plot(times(loop4Index),filteredData.SBL(loop4Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop4Index),filteredData.Noise(loop4Index),'LineWidth',2);
ylabel('Noise (mV)')
title('','SBL and Noise')

ax3 = nexttile([1,2])
yyaxis left
plot(times(loop4Index),filteredData.SBL(loop4Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop4Index),filteredData.Detections(loop4Index),'LineWidth',2);
ylabel('Detections')
title('','SBL and Detections')

%
loop4.Duration = length(surfaceData.WSPD(loop4Index))
loop4.WindMin = min(surfaceData.WSPD(loop4Index))
loop4.WindMax = max(surfaceData.WSPD(loop4Index))
%
loop4.DetsMin = min(envData.HourlyDets(loop4Index))
loop4.DetsMax = max(envData.HourlyDets(loop4Index))
%
[R P] = corrcoef(filteredData.Snaps(loop4Index),filteredData.SBLcapped(loop4Index))
loop4.SnapSBLsqrd = R(1,2)*R(1,2)
loop4.SnapSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Noise(loop4Index),filteredData.SBLcapped(loop4Index))
loop4.NoiseSBLsqrd = R(1,2)*R(1,2)
loop4.NoiseSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Detections(loop4Index),filteredData.SBLcapped(loop4Index))
loop4.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop4.DetectionsSBLpvalue = P(1,2);
%
%%
%Apr. 11 08:00 - Apr. 14 19:00
%1722:1805
loop5Index = 1722:1805;
%
figure()
TR = tiledlayout(3,3)
ax0 = nexttile([3,1])
scatter(filteredData.SBLcapped,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBLcapped(loop5Index),filteredData.Noise(loop5Index),[],X(loop5Index),'filled');
xlabel('SBL')
ylabel('HFnoise')
title('Noise Attenuation')
legend({'Full','Selected'})
ax1 = nexttile([1,2])
yyaxis left
plot(times(loop5Index),filteredData.SBL(loop5Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop5Index),filteredData.Snaps(loop5Index),'LineWidth',2);
ylabel('Snaps')
title('Loop 5','SBL and Snaps')

ax2 = nexttile([1,2])
yyaxis left
plot(times(loop5Index),filteredData.SBL(loop5Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop5Index),filteredData.Noise(loop5Index),'LineWidth',2);
ylabel('Noise (mV)')
title('','SBL and Noise')

ax3 = nexttile([1,2])
yyaxis left
plot(times(loop5Index),filteredData.SBL(loop5Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop5Index),filteredData.Detections(loop5Index),'LineWidth',2);
ylabel('Detections')
title('','SBL and Detections')

%
loop5.Duration = length(surfaceData.WSPD(loop5Index))
loop5.WindMin = min(surfaceData.WSPD(loop5Index))
loop5.WindMax = max(surfaceData.WSPD(loop5Index))
%
loop5.DetsMin = min(envData.HourlyDets(loop5Index))
loop5.DetsMax = max(envData.HourlyDets(loop5Index))
%
[R P] = corrcoef(filteredData.Snaps(loop5Index),filteredData.SBLcapped(loop5Index))
loop5.SnapSBLsqrd = R(1,2)*R(1,2)
loop5.SnapSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Noise(loop5Index),filteredData.SBLcapped(loop5Index))
loop5.NoiseSBLsqrd = R(1,2)*R(1,2)
loop5.NoiseSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Detections(loop5Index),filteredData.SBLcapped(loop5Index))
loop5.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop5.DetectionsSBLpvalue = P(1,2);

%%
%Apr. 14 20:00 - Apr. 18 09:00
%1806:1891
loop6Index = 1806:1891;
%
figure()
TR = tiledlayout(3,3)
ax0 = nexttile([3,1])
scatter(filteredData.SBLcapped,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBLcapped(loop6Index),filteredData.Noise(loop6Index),[],X(loop6Index),'filled');
xlabel('SBL')
ylabel('HFnoise')
title('Noise Attenuation')
legend({'Full','Selected'})
ax1 = nexttile([1,2])
yyaxis left
plot(times(loop6Index),filteredData.SBL(loop6Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop6Index),filteredData.Snaps(loop6Index),'LineWidth',2);
ylabel('Snaps')
title('Loop 6','SBL and Snaps')

ax2 = nexttile([1,2])
yyaxis left
plot(times(loop6Index),filteredData.SBL(loop6Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop6Index),filteredData.Noise(loop6Index),'LineWidth',2);
ylabel('Noise (mV)')
title('','SBL and Noise')

ax3 = nexttile([1,2])
yyaxis left
plot(times(loop6Index),filteredData.SBL(loop6Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop6Index),filteredData.Detections(loop6Index),'LineWidth',2);
ylabel('Detections')
title('','SBL and Detections')
%
figure()
TR = tiledlayout(3,3)
ax0 = nexttile([3,1])
scatter(filteredData.SBLcapped,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBLcapped(loop6Index),filteredData.Noise(loop6Index),[],X(loop6Index),'filled');
xlabel('SBL')
ylabel('HFnoise')
title('Noise Attenuation')
legend({'Full','Selected'})
ax1 = nexttile([1,2])
yyaxis left
plot(times(loop6Index),surfaceData.SBLcapped(loop6Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop6Index),snapRateHourly.SnapCount(loop6Index),'LineWidth',2);
ylabel('Snaps')
title('Loop 6','SBL and Snaps')

ax2 = nexttile([1,2])
yyaxis left
plot(times(loop6Index),surfaceData.SBLcapped(loop6Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop6Index),envData.Noise(loop6Index),'LineWidth',2);
ylabel('Noise (mV)')
title('','SBL and Noise')

ax3 = nexttile([1,2])
yyaxis left
plot(times(loop6Index),surfaceData.SBLcapped(loop6Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop6Index),envData.HourlyDets(loop6Index),'LineWidth',2);
ylabel('Detections')
title('','SBL and Detections')


%
loop6.Duration = length(surfaceData.WSPD(loop6Index))
loop6.WindMin = min(surfaceData.WSPD(loop6Index))
loop6.WindMax = max(surfaceData.WSPD(loop6Index))
%
loop6.DetsMin = min(envData.HourlyDets(loop6Index))
loop6.DetsMax = max(envData.HourlyDets(loop6Index))
%
[R P] = corrcoef(filteredData.Snaps(loop6Index),filteredData.SBLcapped(loop6Index))
loop6.SnapSBLsqrd = R(1,2)*R(1,2)
loop6.SnapSBLpvalue = P(1,2);

[R P] = corrcoef(filteredData.Noise(loop6Index),filteredData.SBLcapped(loop6Index))
loop6.NoiseSBLsqrd = R(1,2)*R(1,2)
loop6.NoiseSBLpvalue = P(1,2);

[R P] = corrcoef(filteredData.Detections(loop6Index),filteredData.SBLcapped(loop6Index))
loop6.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop6.DetectionsSBLpvalue = P(1,2);

%%
%Apr. 25 00:00 - Apr. 28 18:00
%2050:2140
loop7Index = 2050:2140;
%
figure()
TR = tiledlayout(3,3)
ax0 = nexttile([3,1])
scatter(filteredData.SBLcapped,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBLcapped(loop7Index),filteredData.Noise(loop7Index),[],X(loop7Index),'filled');
xlabel('SBL')
ylabel('HFnoise')
title('Noise Attenuation')
legend({'Full','Selected'})
ax1 = nexttile([1,2])
yyaxis left
plot(times(loop7Index),filteredData.SBL(loop7Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop7Index),filteredData.Snaps(loop7Index),'LineWidth',2);
ylabel('Snaps')
title('Loop 7','SBL and Snaps')

ax2 = nexttile([1,2])
yyaxis left
plot(times(loop7Index),filteredData.SBL(loop7Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop7Index),filteredData.Noise(loop7Index),'LineWidth',2);
ylabel('Noise (mV)')
title('','SBL and Noise')

ax3 = nexttile([1,2])
yyaxis left
plot(times(loop7Index),filteredData.SBL(loop7Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop7Index),filteredData.Detections(loop7Index),'LineWidth',2);
ylabel('Detections')
title('','SBL and Detections')

%
loop7.Duration = length(surfaceData.WSPD(loop7Index))
loop7.WindMin = min(surfaceData.WSPD(loop7Index))
loop7.WindMax = max(surfaceData.WSPD(loop7Index))
%
[R P] = corrcoef(filteredData.Snaps(loop7Index),filteredData.SBLcapped(loop7Index))
loop7.SnapSBLsqrd = R(1,2)*R(1,2)
loop7.SnapSBLpvalue = P(1,2)
%
[R P] = corrcoef(filteredData.Noise(loop7Index),filteredData.SBLcapped(loop7Index))
loop7.NoiseSBLsqrd = R(1,2)*R(1,2)
loop7.NoiseSBLpvalue = P(1,2)
%
[R P] = corrcoef(filteredData.Detections(loop7Index),filteredData.SBLcapped(loop7Index))
loop7.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop7.DetectionsSBLpvalue = P(1,2)

%%
%Apr. 28 19:00 - May 2 12:00
%2141:2230
loop8Index = 2141:2230;
%
figure()
TR = tiledlayout(3,3)
ax0 = nexttile([3,1])
scatter(filteredData.SBLcapped,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBLcapped(loop8Index),filteredData.Noise(loop8Index),[],X(loop8Index),'filled');
xlabel('SBL')
ylabel('HFnoise')
title('Noise Attenuation')
legend({'Full','Selected'})
ax1 = nexttile([1,2])
yyaxis left
plot(times(loop8Index),filteredData.SBL(loop8Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop8Index),filteredData.Snaps(loop8Index),'LineWidth',2);
ylabel('Snaps')
title('Loop 8','SBL and Snaps')

ax2 = nexttile([1,2])
yyaxis left
plot(times(loop8Index),filteredData.SBL(loop8Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop8Index),filteredData.Noise(loop8Index),'LineWidth',2);
ylabel('Noise (mV)')
title('','SBL and Noise')

ax3 = nexttile([1,2])
yyaxis left
plot(times(loop8Index),filteredData.SBL(loop8Index),'LineWidth',2);
ylabel('SBL (dB)')
yyaxis right
plot(times(loop8Index),filteredData.Detections(loop8Index),'LineWidth',2);
ylabel('Detections')
title('','SBL and Detections')

%
loop8.Duration = length(surfaceData.WSPD(loop8Index))
loop8.WindMin = min(surfaceData.WSPD(loop8Index))
loop8.WindMax = max(surfaceData.WSPD(loop8Index))
%
[R P] = corrcoef(filteredData.Snaps(loop8Index),filteredData.SBLcapped(loop8Index))
loop8.SnapSBLsqrd = R(1,2)*R(1,2)
loop8.SnapSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Noise(loop8Index),filteredData.SBLcapped(loop8Index))
loop8.NoiseSBLsqrd = R(1,2)*R(1,2)
loop8.NoiseSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Detections(loop8Index),filteredData.SBLcapped(loop8Index))
loop8.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop8.DetectionsSBLpvalue = P(1,2);


%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % FM changing format

min(surfaceData.WSPD(461:601))

%%%%%%%%%%%%%%%%%%%%%%%%
%%

load angusdbdAprilMay
load angusebdAprilMay

% Bindata for different missions
[matstruct,dn,z,temp] = Bindata(fstruct,sstruct);

dt = datetime(dn,'convertfrom','datenum')


% test plot
figure; 
TTT = tiledlayout(5,3)
ax1 = nexttile([2,3])
% yyaxis left
% h1=pcolor(dn,z,temp'); shading interp; colorbar; set(gca,'ydir','reverse'); 
% datetick('x','keeplimits');
% clim([20.5 22])

title('Water Column Profile: Temperature','Glider mission')
ylabel('Z (m)')
ylim([4 15])

pcolor(dn,z,matstruct.rho')
shading interp; colorbar; set(gca,'ydir','reverse'); datetick('x','keeplimits'); ylim([0 18]);
% caxis([1021 1024]);
caxis([1021.5 1024]);
xlim([dn(1,1) dn(1,170)])
% yyaxis right
% plot(datenum(times),surfaceData.WSPD,'LineWidth',4)
% ylabel('Windspeed (m/s)')


ax2 = nexttile([1,3])
yyaxis left 
plot(times,envData.HourlyDets,'LineWidth',2)
ylim([0 6])
ylabel('Dets (\hr)')

yyaxis right
plot(times,envData.Noise,'LineWidth',2)
ylim([500 780])
ylabel('Noise (mV)')
yline(650,'--','Challenging')
title('','Detection Efficiency Versus Noise Interference')

ax3 = nexttile([1,3])
plot(surfaceData.time,surfaceData.SBLcapped,'r','LineWidth',3)
yline(4.85,'--','Whitecaps  ')
ylabel('SBL (dB)')
title('','Surface Bubble Loss, Attenuation')
% Frank: add thermal strat from glider here? Brunt Vaisalla?

ax4 = nexttile([1,3])
plot(snapRateHourly.Time,snapRateHourly.SnapCount,'k','LineWidth',2)
title('','Benthic Activity')
ylabel('Snaps (\hr)')

linkaxes([ax2 ax3 ax4],'x')



% 
% 
% 
% 
% 
% 
