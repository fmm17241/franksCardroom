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
SBLbins(1,:) = surfaceData.SBLcapped < 2;
SBLbins(2,:) = surfaceData.SBLcapped > 4 & surfaceData.SBLcapped < 6;
SBLbins(3,:) = surfaceData.SBLcapped > 6 & surfaceData.SBLcapped < 8;
SBLbins(4,:) = surfaceData.SBLcapped > 8 & surfaceData.SBLcapped < 10;
SBLbins(5,:) = surfaceData.SBLcapped > 10 & surfaceData.SBLcapped < 12;
SBLbins(6,:) = surfaceData.SBLcapped > 12 & surfaceData.SBLcapped < 14;
SBLbins(7,:) = surfaceData.SBLcapped > 14;

% Binning the data
for k = 1:height(SBLbins)
    SBLenvData{k}           = envData(SBLbins(k,:),:);
    SBLsurfData{k}          = surfaceData(SBLbins(k,:),:);

    noiseVsSBL(k) = mean(SBLenvData{1,k}.Noise); 
    windsVsSBL(k)   =mean(SBLsurfData{1,k}.SBLcapped) 
    
    % Calculate standard error of the mean (SEM)
    noiseSBLSEM(k) = std(SBLenvData{k}.Noise) / sqrt(height(SBLenvData{k}));
    windSBLSEM(k) = std(SBLsurfData{k}.WSPD) / sqrt(height(SBLsurfData{k}));


    countBINS(k)            = height(SBLsurfData{k})
end
% x = 750:750:6750;
x = 2:2:14



figure()
plot(x,noiseVsSBL,'k','LineWidth',1.75)
hold on
scatter(x,noiseVsSBL,'k','filled')







