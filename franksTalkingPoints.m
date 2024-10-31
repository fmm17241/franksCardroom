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
plot(times,envData.Noise)

ax2 = nexttile([1,3])
plot(times,surfaceData.WSPD)

linkaxes([ax1 ax2],'x')




















