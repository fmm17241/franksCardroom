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








load envDataFall
% Full snaprate dataset
load snapRateDataFall
% Snaprate binned hourly
load snapRateHourlyFall
% Snaprate binned per minute
load snapRateMinuteFall
load surfaceDataFall
load filteredData4Bin40HrLowFALLpruned.mat

times = surfaceData.time;


if length(surfaceData.time) == 3308
    surfaceData = surfaceData(1:2078,:);
    snapRateHourly = snapRateHourly(1:2078,:);
    times = times(1:2078,:);
end
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
scatter(filteredData.SBL(1429:1534),filteredData.Noise(1429:1534),[],X(1429:1534),'filled');
xlabel('SBL')
ylabel('HFnoise')

[R P] = corrcoef(envData.Noise(1429:1534),surfaceData.SBLcapped(1429:1534))

[R P] = corrcoef(filteredData.Noise(1429:1534),filteredData.SBLcapped(1429:1534))

squrd = R(1,2)*R(1,2)


%Yellow loop:
% 1844 quiet
%1892 loud

%1792 loud
% 1818 quiet

%2097 quiet
% 2141 loud

%Green loop:
% 1679 quiet
%1609 loud
%1566 mini quiet
%  1534 loud
% 1481 quiet
% 1429 loud

%Blue loop:
% 601 loud
% 524 quiet
% 461 loud


% 130 loud
% 187 quiet
% 259 loud

%941 loud
%871 quiet
%810 loud












