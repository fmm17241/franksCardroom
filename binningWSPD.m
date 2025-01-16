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
windBins(1,:) = surfaceData.WSPD < 2;
windBins(2,:) = surfaceData.WSPD > 4 & surfaceData.WSPD < 6;
windBins(3,:) = surfaceData.WSPD > 6 & surfaceData.WSPD < 8;
windBins(4,:) = surfaceData.WSPD > 8 & surfaceData.WSPD < 10;
windBins(5,:) = surfaceData.WSPD > 10 & surfaceData.WSPD < 12;
windBins(6,:) = surfaceData.WSPD > 12 & surfaceData.WSPD < 14;
windBins(7,:) = surfaceData.WSPD > 14;

% Binning the data
for k = 1:height(windBins)
    windEnvData{k}           = envData(windBins(k,:),:);
    windSurfData{k}          = surfaceData(windBins(k,:),:);
    windSnapData{k}          = snapRateHourly.SnapCount(windBins(k,:));

    noiseVsWind(k) = mean(windEnvData{1,k}.Noise); 
    snapsVsWind(k)   =mean(windSnapData{1,k}) 
    
    % Calculate standard error of the mean (SEM)
    noiseWindSEM(k) = std(windEnvData{k}.Noise) / sqrt(height(windEnvData{k}));
    windSnapSEM(k) = std(windSnapData{k}) / sqrt(height(windSnapData{k}));


    countBINS(k)            = height(windSurfData{k})
end
% x = 750:750:6750;
x = 2:2:14



% figure()
% semilogx(x,noiseVsWind,'k','LineWidth',1.75)
% hold on
% scatter(x,noiseVsWind,'k','filled')




% figure()
% semilogx(x,windsVsSnaps)
% 
% scatter(x,snapsVsSBL)






