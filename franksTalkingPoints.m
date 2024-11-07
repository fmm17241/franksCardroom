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


%Create monthly variables

surface = retime(surfaceData,'monthly','mean')
enviro = retime(envData,'monthly','mean')

snhaps = retime(snapRateHourly,'monthly','mean')



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
figure()
scatter(filteredData.SBL,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBL(130:259),filteredData.Noise(130:259),[],X(130:259),'filled');
xlabel('SBL')
ylabel('HFnoise')

figure()


%
loop1.Duration = length(surfaceData.WSPD(130:259))
loop1.WindMin = min(surfaceData.WSPD(130:259))
loop1.WindMax = max(surfaceData.WSPD(130:259))
%
loop1.DetsMin = min(envData.HourlyDets(130:259))
loop1.DetsMax = max(envData.HourlyDets(130:259))
%
[R P] = corrcoef(filteredData.Snaps(130:259),filteredData.SBLcapped(130:259))
loop1.SnapSBLRsqrd = R(1,2)*R(1,2)
loop1.SnapSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Noise(130:259),filteredData.SBLcapped(130:259))
loop1.NoiseSBLsqrd = R(1,2)*R(1,2)
loop1.NoiseSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Detections(130:259),filteredData.SBLcapped(130:259))
loop1.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop1.DetectionsSBLpvalue = P(1,2);
%



%%
%Feb 12 04:00 - Feb 18 18:00 
%302-460
figure()
scatter(filteredData.SBL,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBL(302:460),filteredData.Noise(302:460),[],X(302:460),'filled');
xlabel('SBL')
ylabel('HFnoise')
%
loop2.Duration = length(surfaceData.WSPD(302:460))
loop2.WindMin = min(surfaceData.WSPD(302:460))
loop2.WindMax = max(surfaceData.WSPD(302:460))
%
loop2.DetsMin = min(envData.HourlyDets(302:460))
loop2.DetsMax = max(envData.HourlyDets(302:460))
%
[R P] = corrcoef(filteredData.Snaps(302:460),filteredData.SBLcapped(302:460))
loop2.SnapSBLsqrd = R(1,2)*R(1,2)
loop2.SnapSBLpvalue = P(1,2);

[R P] = corrcoef(filteredData.Noise(302:460),filteredData.SBLcapped(302:460))
loop2.NoiseSBLsqrd = R(1,2)*R(1,2)
loop2.NoiseSBLpvalue = P(1,2);

[R P] = corrcoef(filteredData.Detections(302:460),filteredData.SBLcapped(302:460))
loop2.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop2.DetectionsSBLpvalue = P(1,2);

%%
%Feb 18 19:00 - Feb 24 15:00
%461:601
figure()
scatter(filteredData.SBL,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBL(461:601),filteredData.Noise(461:601),[],X(461:601),'filled');
xlabel('SBL')
ylabel('HFnoise')

%
loop3.Duration = length(surfaceData.WSPD(461:601))
loop3.WindMin = min(surfaceData.WSPD(461:601))
loop3.WindMax = max(surfaceData.WSPD(461:601))
%
loop3.DetsMin = min(envData.HourlyDets(461:601))
loop3.DetsMax = max(envData.HourlyDets(461:601))
%
[R P] = corrcoef(filteredData.Snaps(461:601),filteredData.SBLcapped(461:601))
loop3.SnapSBLsqrd = R(1,2)*R(1,2)
loop3.SnapSBLpvalue = P(1,2)

[R P] = corrcoef(filteredData.Noise(461:601),filteredData.SBLcapped(461:601))
loop3.NoiseSBLsqrd = R(1,2)*R(1,2)
loop3.NoiseSBLpvalue = P(1,2)

[R P] = corrcoef(filteredData.Detections(461:601),filteredData.SBLcapped(461:601))
loop3.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop3.DetectionsSBLpvalue = P(1,2)

%%
%Mar. 30 03:00 - Apr. 3 12:00
%1429:1534
figure()
scatter(filteredData.SBL,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBL(1429:1534),filteredData.Noise(1429:1534),[],X(1429:1534),'filled');
xlabel('SBL')
ylabel('HFnoise')
%
loop4.Duration = length(surfaceData.WSPD(1429:1534))
loop4.WindMin = min(surfaceData.WSPD(1429:1534))
loop4.WindMax = max(surfaceData.WSPD(1429:1534))
%
loop4.DetsMin = min(envData.HourlyDets(1429:1534))
loop4.DetsMax = max(envData.HourlyDets(1429:1534))
%
[R P] = corrcoef(filteredData.Snaps(1429:1534),filteredData.SBLcapped(1429:1534))
loop4.SnapSBLsqrd = R(1,2)*R(1,2)
loop4.SnapSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Noise(1429:1534),filteredData.SBLcapped(1429:1534))
loop4.NoiseSBLsqrd = R(1,2)*R(1,2)
loop4.NoiseSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Detections(1429:1534),filteredData.SBLcapped(1429:1534))
loop4.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop4.DetectionsSBLpvalue = P(1,2);
%
%%
%Apr. 11 08:00 - Apr. 14 19:00
%1722:1805
figure()
scatter(filteredData.SBL,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBL(1722:1805),filteredData.Noise(1722:1805),[],X(1722:1805),'filled');
xlabel('SBL')
ylabel('HFnoise')

%
loop5.Duration = length(surfaceData.WSPD(1722:1805))
loop5.WindMin = min(surfaceData.WSPD(1722:1805))
loop5.WindMax = max(surfaceData.WSPD(1722:1805))
%
loop5.DetsMin = min(envData.HourlyDets(1722:1805))
loop5.DetsMax = max(envData.HourlyDets(1722:1805))
%
[R P] = corrcoef(filteredData.Snaps(1722:1805),filteredData.SBLcapped(1722:1805))
loop5.SnapSBLsqrd = R(1,2)*R(1,2)
loop5.SnapSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Noise(1722:1805),filteredData.SBLcapped(1722:1805))
loop5.NoiseSBLsqrd = R(1,2)*R(1,2)
loop5.NoiseSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Detections(1722:1805),filteredData.SBLcapped(1722:1805))
loop5.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop5.DetectionsSBLpvalue = P(1,2);

%%
%Apr. 14 20:00 - Apr. 18 09:00
%1806:1891
figure()
scatter(filteredData.SBL,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBL(1806:1891),filteredData.Noise(1806:1891),[],X(1806:1891),'filled');
xlabel('SBL')
ylabel('HFnoise')
%
loop6.Duration = length(surfaceData.WSPD(1806:1891))
loop6.WindMin = min(surfaceData.WSPD(1806:1891))
loop6.WindMax = max(surfaceData.WSPD(1806:1891))
%
loop6.DetsMin = min(envData.HourlyDets(1806:1891))
loop6.DetsMax = max(envData.HourlyDets(1806:1891))
%
[R P] = corrcoef(filteredData.Snaps(1806:1891),filteredData.SBLcapped(1806:1891))
loop6.SnapSBLsqrd = R(1,2)*R(1,2)
loop6.SnapSBLpvalue = P(1,2);

[R P] = corrcoef(filteredData.Noise(1806:1891),filteredData.SBLcapped(1806:1891))
loop6.NoiseSBLsqrd = R(1,2)*R(1,2)
loop6.NoiseSBLpvalue = P(1,2);

[R P] = corrcoef(filteredData.Detections(1806:1891),filteredData.SBLcapped(1806:1891))
loop6.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop6.DetectionsSBLpvalue = P(1,2);

%%
%Apr. 25 00:00 - Apr. 28 18:00
%2050:2140
figure()
scatter(filteredData.SBL,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBL(2050:2140),filteredData.Noise(2050:2140),[],X(2050:2140),'filled');
xlabel('SBL')
ylabel('HFnoise')
%
loop7.Duration = length(surfaceData.WSPD(2050:2140))
loop7.WindMin = min(surfaceData.WSPD(2050:2140))
loop7.WindMax = max(surfaceData.WSPD(2050:2140))
%
[R P] = corrcoef(filteredData.Snaps(2050:2140),filteredData.SBLcapped(2050:2140))
loop7.SnapSBLsqrd = R(1,2)*R(1,2)
loop7.SnapSBLpvalue = P(1,2)
%
[R P] = corrcoef(filteredData.Noise(2050:2140),filteredData.SBLcapped(2050:2140))
squrd = R(1,2)*R(1,2)
loop7.NoiseSBLpvalue = P(1,2)
%
[R P] = corrcoef(filteredData.Detections(2050:2140),filteredData.SBLcapped(2050:2140))
loop7.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop7.DetectionsSBLpvalue = P(1,2)

%%
%Apr. 28 19:00 - May 2 12:00
%2141:2230
figure()
scatter(filteredData.SBL,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBL(2141:2230),filteredData.Noise(2141:2230),[],X(2141:2230),'filled');
xlabel('SBL')
ylabel('HFnoise')
%
loop8.Duration = length(surfaceData.WSPD(2141:2230))
loop8.WindMin = min(surfaceData.WSPD(2141:2230))
loop8.WindMax = max(surfaceData.WSPD(2141:2230))
%
[R P] = corrcoef(filteredData.Snaps(2141:2230),filteredData.SBLcapped(2141:2230))
loop8.SnapSBLsqrd = R(1,2)*R(1,2)
loop8.SnapSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Noise(2141:2230),filteredData.SBLcapped(2141:2230))
loop8.NoiseSBLsqrd = R(1,2)*R(1,2)
loop8.NoiseSBLpvalue = P(1,2);
%
[R P] = corrcoef(filteredData.Detections(2141:2230),filteredData.SBLcapped(2141:2230))
loop8.DetectionsSBLsqrd = R(1,2)*R(1,2)
loop8.DetectionsSBLpvalue = P(1,2);


%%

figure()
fdg = tiledlayout(2,3)
ax1 = nexttile([1,3])
plot(times,filteredData.Noise)

ax2 = nexttile([1,3])
plot(times,filteredData.Winds)

linkaxes([ax1 ax2],'x')


figure()
fdg = tiledlayout(2,3)
ax1 = nexttile([1,3])
plot(times,envData.Noise,'LineWidth',1.5)
title('HF Noise')

ax2 = nexttile([1,3])
plot(times,surfaceData.SBLcapped,'LineWidth',1.5)
title('SBL')

linkaxes([ax1 ax2],'x')



figure()
scatter(filteredData.SBL,filteredData.Noise,[],X);
hold on
scatter(filteredData.SBL(1805:1891),filteredData.Noise(1805:1891),[],X(1805:1891),'filled');
xlabel('SBL')
ylabel('HFnoise')

%Green loop
%  1534 loud
% 1481 quiet
% 1429 loud
[R P] = corrcoef(envData.Noise(1429:1534),surfaceData.SBLcapped(1429:1534))
[R P] = corrcoef(filteredData.Noise(1429:1534),filteredData.SBLcapped(1429:1534))
squrd = R(1,2)*R(1,2)

%Blue loop:
% 601 loud
% 524 quiet
% 461 loud
scatter(filteredData.SBL(461:601),filteredData.Noise(461:601),[],X(461:601),'filled');
[R P] = corrcoef(envData.Noise(461:601),surfaceData.SBLcapped(461:601))
[R P] = corrcoef(filteredData.Noise(461:601),filteredData.SBLcapped(461:601))
squrd = R(1,2)*R(1,2)

[R P] = corrcoef(envData.HourlyDets(461:601),surfaceData.SBLcapped(461:601))
squrd = R(1,2)*R(1,2)
[R P] = corrcoef(filteredData.Detections(461:601),filteredData.SBLcapped(461:601))
squrd = R(1,2)*R(1,2)

[R P] = corrcoef(snapRateHourly.SnapCount(461:601),surfaceData.SBLcapped(461:601))
squrd = R(1,2)*R(1,2)
[R P] = corrcoef(filteredData.Snaps(461:601),filteredData.SBLcapped(461:601))
squrd = R(1,2)*R(1,2)


%Yellow loop:
% 1844 quiet
%1892 loud
scatter(filteredData.SBL(1795:1891),filteredData.Noise(1795:1891),[],X(1795:1891),'filled')
[R P] = corrcoef(envData.Noise(1795:1891),surfaceData.SBLcapped(1795:1891))
[R P] = corrcoef(filteredData.Noise(1795:1891),filteredData.SBLcapped(1795:1891))
squrd = R(1,2)*R(1,2)

%Yellow loop:
%1780 loud
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



figure()
scatter(filteredData.SBL(1722:1805),filteredData.Noise(1722:1805),[],X(1722:1805),'filled')
[R P] = corrcoef(envData.Noise(1722:1805),surfaceData.SBLcapped(1722:1805))
[R P] = corrcoef(filteredData.Noise(1722:1805),filteredData.SBLcapped(1722:1805))
squrd = R(1,2)*R(1,2)







%Yellow loop
figure()
scatter(filteredData.SBLcapped(2140:2230),filteredData.Noise(2140:2230),[],X(2140:2230))
[R P] = corrcoef(envData.Noise(2140:2230),surfaceData.SBLcapped(2140:2230))
[R P] = corrcoef(filteredData.Noise(2140:2230),filteredData.SBLcapped(2140:2230))
squrd = R(1,2)*R(1,2)

figure()
scatter(filteredData.SBLcapped(1566:1679),filteredData.Noise(1566:1679),[],X(1566:1679),'filled')
%1792 loud
% 1818 quiet

%weird blue
[R P] = corrcoef(envData.Noise(93:229),surfaceData.SBLcapped(93:229))
[R P] = corrcoef(filteredData.Noise(93:229),filteredData.SBLcapped(93:229))
squrd = R(1,2)*R(1,2)














