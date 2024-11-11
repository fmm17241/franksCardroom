%%
%FM, we got this.



fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

%%
% % Load in saved data
% % Environmental data matched to the hourly snaps.
load envDataSpring
% % Full snaprate dataset
load snapRateDataSpring
% % Snaprate binned hourly
load snapRateHourlySpring
% % Snaprate binned per minute
load snapRateMinuteSpring
load surfaceDataSpring
load filteredData4Bin40HrLowSPRING.mat
times = surfaceData.time;


bulkStrat = surfaceData.SST - envData.Temp;
envData.bulkStrat = bulkStrat;



[R,P] = corrcoef(filteredData.Winds,filteredData.Noise)
Rsqrd = R(1,2)*R(1,2)


%Create monthly variables
surface = retime(surfaceData,'monthly','mean')
enviro = retime(envData,'monthly','mean')
snhaps = retime(snapRateHourly,'monthly','mean')
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

figure()
TT = tiledlayout(2,4)
ax1 = nexttile([2,2])
yyaxis left
plot(times,filteredData.Snaps,'LineWidth',3)
ylabel('Snaprate (per Hour))')
yyaxis right
plot(times,filteredData.BottomTemp,'LineWidth',3)
ylabel('Bottom Temp.(C)')
title('Seasonal Warming Leads to Increased Benthic Activity','40Hr Lowpass')

ax2 = nexttile([2,2])
plot(times,snapRateHourly.SnapCount,'k','LineWidth',3)
set(gca,'YAxisLocation','right')
ylabel('Snaps Per Hour')
title('Hourly/Daily Shrimp Activity')
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
% times = surfaceData.time;
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
[R P] = corrcoef(filteredData.Detections(loop1Index),filteredData.SBLcapped(loop1Index))
loop1.StratWindssqrd
loop1.StratDetssqrd


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

%1766 quiet
%1722 loud
figure()
TTTT = tiledlayout(6,2)
ax1 = nexttile([2,1])
yyaxis left
scatter(times(461:601),filteredData.SBLcapped(461:601),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(461:601),filteredData.Noise(461:601),'r','filled')
ylabel('Noise (mV)')
title('Noise Attenuation due to SBL','40Hr Lowpass')

ax2 = nexttile([2,1])
yyaxis left
scatter(times(461:601),surfaceData.SBLcapped(461:601),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(461:601),envData.Noise(461:601),'r','filled')
ylabel('Noise (mV)')
title('','Raw Data')


ax3 = nexttile([2,1])
yyaxis left
scatter(times(461:601),filteredData.SBLcapped(461:601),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(461:601),filteredData.Detections(461:601),'r','filled')
ylabel('Detections')
title('Surface Attenuation Enabling Acoustic Telemetry','40Hr Lowpass')

ax4 = nexttile([2,1])
yyaxis left
scatter(times(461:601),surfaceData.SBLcapped(461:601),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(461:601),envData.HourlyDets(461:601),'r','filled')
ylabel('Detections')
title('','Raw Data')

ax5 = nexttile([2,1])
yyaxis left
scatter(times(461:601),filteredData.SBLcapped(461:601),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(461:601),filteredData.Snaps(461:601),'r','filled')
ylabel('Snaps')
title('Snaprate Unnaffected by Winds','40Hr Lowpass')

ax6 = nexttile([2,1])
yyaxis left
scatter(times(461:601),surfaceData.SBLcapped(461:601),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(461:601),snapRateHourly.SnapCount(461:601),'r','filled')
ylabel('Snaps')
title('','Raw Data')

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
yyaxis left
h1=pcolor(dn,z,temp'); shading interp; colorbar; set(gca,'ydir','reverse'); 
datetick('x','keeplimits');
clim([20.5 22])
xlim([dn(1,1) dn(1,170)])
title('Water Column Profile: Temperature','Glider mission')
ylabel('Z (m)')
ylim([4 15])

yyaxis right
plot(datenum(times),surfaceData.WSPD,'LineWidth',4)
ylabel('Windspeed (m/s)')


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
plot(times,surfaceData.SBLcapped,'r','LineWidth',3)
yline(4.85,'--','Whitecaps  ')
ylabel('SBL (dB)')
title('','Surface Bubble Loss, Attenuation')

ax4 = nexttile([1,3])
plot(times,snapRateHourly.SnapCount,'k','LineWidth',2)
title('','Benthic Activity')
ylabel('Snaps (\hr)')

linkaxes([ax2 ax3 ax4],'x')









