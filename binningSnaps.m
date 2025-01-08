%FM 2025
% Binning snap rate to use in tiled raw vs filt comparison figure in JMSE
%%
%Load data
load envDataSpring
% % Full snaprate dataset
load snapRateDataSpring
% % Snaprate binned hourly
load snapRateHourlySpring
load surfaceDataSpring
load filteredData4Bin40HrLowSPRING.mat
load decimatedDataSpring
load loopIndices

times = surfaceData.time;
disp(filteredData)
%%
%Creating indices to bin.
snapRateBins(1,:) = snapRateHourly.SnapCount < 750;
snapRateBins(2,:) = snapRateHourly.SnapCount > 750 & snapRateHourly.SnapCount < 1500;
snapRateBins(3,:) = snapRateHourly.SnapCount > 1500 & snapRateHourly.SnapCount < 2250;
snapRateBins(4,:) = snapRateHourly.SnapCount > 2250 & snapRateHourly.SnapCount < 3000;
snapRateBins(5,:) = snapRateHourly.SnapCount > 3000 & snapRateHourly.SnapCount < 3750;
snapRateBins(6,:) = snapRateHourly.SnapCount > 3750 & snapRateHourly.SnapCount < 4500;
snapRateBins(7,:) = snapRateHourly.SnapCount > 4500 & snapRateHourly.SnapCount < 5250;
snapRateBins(8,:) = snapRateHourly.SnapCount > 5250 & snapRateHourly.SnapCount < 6000;
snapRateBins(9,:) = snapRateHourly.SnapCount > 6000;

% Binning the data
for k = 1:height(snapRateBins)
    snapRateBinData{k}           = envData(snapRateBins(k,:),:);
    noiseVsSnaps(k) = mean(snapRateBinData{1,k}.Noise);    
    countAnnual(k)            = height(snapRateBinData{k})
end
x = 750:750:6750;


figure()
semilogx(x,noiseVsSnaps)
hold on
scatter(x,noiseVsSnaps,'filled')
