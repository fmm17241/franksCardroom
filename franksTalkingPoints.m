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

%Frank pruning hourly detection data
badDets = [2229:2241];
envData.HourlyDets(badDets) = 0;


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



%
%FUFKDSFSGFDG 
[R P] = corrcoef(filteredData.TidesAbsolute,filteredData.Snaps)
Rsqwrd = R(1,2)*R(1,2)


[R P] = corrcoef(absoluteTides,snapRateHourly.SnapCount)
Rsqwrd = R(1,2)*R(1,2)


%%
%loops, find the loops, save the world

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
fdg = tiledlayout(2,3)
ax1 = nexttile([1,3])
plot(times(1429:1534),envData.Noise(1429:1534),'LineWidth',1.5)
title('HF Noise')

ax2 = nexttile([1,3])
plot(times(1429:1534),surfaceData.SBLcapped(1429:1534),'LineWidth',1.5)
title('SBL')

X = 1:length(filteredData.Noise);

figure()
scatter(filteredData.SBL,filteredData.Noise,[],X);
hold on
% scatter(filteredData.SBL(1429:1534),filteredData.Noise(1429:1534),[],X(1429:1534),'filled');
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


figure()
TTTT = tiledlayout(6,2)
ax1 = nexttile([2,1])
yyaxis left
scatter(times(1722:1805),filteredData.SBLcapped(1722:1805),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(1722:1805),filteredData.Noise(1722:1805),'r','filled')
ylabel('Noise (mV)')
title('Noise Attenuation due to SBL','40Hr Lowpass')

ax2 = nexttile([2,1])
yyaxis left
scatter(times(1722:1805),surfaceData.SBLcapped(1722:1805),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(1722:1805),envData.Noise(1722:1805),'r','filled')
ylabel('Noise (mV)')
title('','Raw Data')


ax3 = nexttile([2,1])
yyaxis left
scatter(times(1722:1805),filteredData.SBLcapped(1722:1805),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(1722:1805),filteredData.Detections(1722:1805),'r','filled')
ylabel('Detections')
title('Surface Attenuation Enabling Acoustic Telemetry','40Hr Lowpass')

ax4 = nexttile([2,1])
yyaxis left
scatter(times(1722:1805),surfaceData.SBLcapped(1722:1805),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(1722:1805),envData.HourlyDets(1722:1805),'r','filled')
ylabel('Detections')
title('','Raw Data')

ax5 = nexttile([2,1])
yyaxis left
scatter(times(1722:1805),filteredData.SBLcapped(1722:1805),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(1722:1805),filteredData.Snaps(1722:1805),'r','filled')
ylabel('Snaps')
title('Snaprate Unnaffected by Winds','40Hr Lowpass')

ax6 = nexttile([2,1])
yyaxis left
scatter(times(1722:1805),surfaceData.SBLcapped(1722:1805),'filled')
ylabel('SBL (dB)')
yyaxis right
scatter(times(1722:1805),snapRateHourly.SnapCount(1722:1805),'r','filled')
ylabel('Snaps')
title('','Raw Data')








figure()
plot(times,envData.HourlyDets)





%Yellow loop
figure()
scatter(filteredData.SBLcapped(2140:2230),filteredData.Noise(2140:2230),[],X(2140:2230))
[R P] = corrcoef(envData.Noise(2140:2230),surfaceData.SBLcapped(2140:2230))
[R P] = corrcoef(filteredData.Noise(2140:2230),filteredData.SBLcapped(2140:2230))
squrd = R(1,2)*R(1,2)

figure()
scatter(filteredData.SBLcapped(2140:2230),filteredData.Noise(2140:2230),[],X(2140:2230))
%1792 loud
% 1818 quiet

%weird blue
[R P] = corrcoef(envData.Noise(93:229),surfaceData.SBLcapped(93:229))
[R P] = corrcoef(filteredData.Noise(93:229),filteredData.SBLcapped(93:229))
squrd = R(1,2)*R(1,2)

%2097 quiet
% 2141 loud


%Green loop:
% 1679 quiet
%1609 loud
%1566 mini quiet




% 130 loud
% 187 quiet
% 259 loud

%941 loud
%871 quiet
%810 loud












