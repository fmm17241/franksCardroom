
buildReceiverData   

fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)
% 
% load envDataFall.mat
% load snapRateDataFall.mat
% load snapRateHourlyFall.mat
% load surfaceDataFall.mat
% load filteredData4Bin40HrLowFALLpruned.mat
% times = envData.DT;

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


%%
%%
%Auto correlation testing

filteredACF = autocorr(filteredData.Noise,'NumLags',100)
rawACF = autocorr(receiverData{1}.Noise,'NumLags',100)

% Plot
lags = 0:100; % Include lag 0
plot(lags, rawACF, '-o', 'DisplayName', 'Raw Data');
hold on;
plot(lags, filteredACF, '-s', 'DisplayName', 'Filtered Data');
xlabel('Lag (hours)');
ylabel('Autocorrelation');
legend;
title('Autocorrelation Comparison','Raw and Lowpass-Filtered (40hr) HF Noise');
hold off;

disp(['Lag 1 Raw ACF: ', num2str(rawACF(2)), ', Filtered ACF: ', num2str(filteredACF(2))]);
disp(['Lag 24 Raw ACF: ', num2str(rawACF(25)), ', Filtered ACF: ', num2str(filteredACF(25))]);


%%
% This tells me there's significant auto-correlation in our noise data
residuals = filteredData.Noise - mean(filteredData.Noise);

% Durbin-Watson statistic
numerator = sum(diff(residuals).^2);
denominator = sum(residuals.^2);
DW = numerator / denominator;

disp(['Durbin-Watson Statistic: ', num2str(DW)]);
%

laggedValue = lagmatrix(filteredData.Noise, 1); % Creates a 1-hour lag
model = fitlm([laggedValue, filteredData.Winds], filteredData.Noise);
figure()
plot(model)

figure()
crosscorr(receiverData{1}.windSpd, receiverData{1}.Noise, 'NumLags', 50)

laggedWind = lagmatrix(filteredData.Winds, [0 2]); % Includes current and lag-2 values
model = fitlm(laggedWind, filteredData.Noise);

residuals = model.Residuals.Raw;
autocorr(residuals, 'NumLags', 50);

%
%Frank needs to use ARIMA model to reduce autocorrelation which persists, or GLS



% STEPS TO PERFORMING Generalized Least Square Analysis GLS
% Estimate autocorrelation structure using Ordinary Least Squares (OLS) model
% OLS model
olsRawModel = fitlm(receiverData{1}.windSpd, receiverData{1}.Noise);
olsFiltModel = fitlm(filteredData.Winds, filteredData.Noise);

figure()
plot(olsRawModel)

figure()
plot(olsFiltModel)


% Extract residuals
residualsRaw = olsRawModel.Residuals.Raw;
residualsFilt = olsFiltModel.Residuals.Raw;

% Check autocorrelation in residuals
figure()
autocorr(residualsRaw, 'NumLags', 100);
title('Sample Autocorrelation Function','Raw, Wind speed and HF Noise')


figure()
autocorr(residualsFilt, 'NumLags', 100);



% Estimate autoregressive Structure

% Fit an AR(1) model to the residuals
arModel = arima('ARLags', 1, 'Constant', 0);
estARraw = estimate(arModel, residualsRaw)
estARfilt = estimate(arModel, residualsFilt)

% Extract AR coefficient (phi)
phiRaw = estARraw.AR{1};
phiFilt = estARfilt.AR{1};
disp(['Estimated AR coefficient: ', num2str(phiRaw)]);
disp(['Estimated AR coefficient: ', num2str(phiFilt)]);



%Transform data for GLS
% Transform predictors (winds) and response (noise)
transformedRawNoise = receiverData{1}.Noise(2:end) - phiRaw * receiverData{1}.Noise(1:end-1);
transformedRawWinds = receiverData{1}.windSpd(2:end) - phiRaw * receiverData{1}.windSpd(1:end-1);

transformedFiltNoise = filteredData.Noise(2:end) - phiFilt * filteredData.Noise(1:end-1);
transformedFiltWinds = filteredData.Winds(2:end) - phiFilt * filteredData.Winds(1:end-1);

% Fit the GLS Model
% Fit GLS model
glsModelRaw = fitlm(transformedRawWinds, transformedRawNoise);
glsModelFilt = fitlm(transformedFiltWinds, transformedFiltNoise);


% Display GLS model summary
disp(glsModelRaw);
disp(glsModelFilt);


% Check residuals
% Extract GLS residuals
glsResidualsRaw = glsModelRaw.Residuals.Raw;

glsResidualsFilt = glsModelFilt.Residuals.Raw;

% Check autocorrelation of GLS residuals
figure()
autocorr(glsResidualsRaw, 'NumLags', 50);

figure()
autocorr(glsResidualsFilt, 'NumLags', 50);



%%
%%
%From CBW: 
%My comment on the correlations for the filtered data refers to that when you filter a data set, 
% you need to subsample it to get the right number of independent data points. e.g. if you have 1 
% hour data and apply a 40 hour filter, then you take every 40th data point to create new time series 
% and use these to estimate the correlations.

% Much simpler than what I was trying to do. Let me try below.
% Load in data.
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
disp(filteredData)


%%
% Decimate() applies its own lowpass filter, but I've previously filtered.
% Instead of:
% decimatedData.Snaps = decimate(filteredData.Snaps,4);
% I am going to instead use a simple (1:4:end) downsampling.
decimatedData.Snaps = filteredData.Snaps(1:4:end);
decimatedData.Noise = filteredData.Noise(1:4:end);
decimatedData.Winds = filteredData.Winds(1:4:end);
decimatedData.Waves = filteredData.Waves(1:4:end);
decimatedData.Tides = filteredData.Tides(1:4:end);
decimatedData.TidesAbsolute = filteredData.TidesAbsolute(1:4:end);
decimatedData.WindDir = filteredData.WindDir(1:4:end);
decimatedData.SBL = filteredData.SBL(1:4:end);
decimatedData.SBLcapped = filteredData.SBLcapped(1:4:end);
decimatedData.Detections = filteredData.Detections(1:4:end);
decimatedData.SST = filteredData.SST(1:4:end);
decimatedData.BulkStrat = filteredData.BulkStrat(1:4:end);
decimatedData.BottomTemp = filteredData.BottomTemp(1:4:end);

decimatedData.Time = times(1:4:end);


X = 1:length(decimatedData.SBL);

figure()
plot(decimatedData.Time,decimatedData.SBLcapped,'b')
hold on
plot(times,filteredData.SBLcapped,'r')

[R,P] = corrcoef(decimatedData.Detections,decimatedData.Snaps)



[R,P] = corrcoef(decimatedData.SBLcapped,decimatedData.Snaps)

[R,P] = corrcoef(decimatedData.SBLcapped,decimatedData.Snaps)
[R,P] = corrcoef(surfaceData.SBLcapped,snapRateHourly.SnapCount)
[R,P] = corrcoef(decimatedData.Winds,decimatedData.Snaps)
[R,P] = corrcoef(surfaceData.WSPD,snapRateHourly.SnapCount)

[R,P] = corrcoef(decimatedData.Waves,decimatedData.Snaps)
[R,P] = corrcoef(surfaceData.waveHeight,snapRateHourly.SnapCount)

[R,P] = corrcoef(decimatedData.SBLcapped,decimatedData.Noise)
Rsqrd = R(1,2)*R(1,2)


[R,P] = corrcoef(surfaceData.SBLcapped,envData.Noise)
Rsqrd = R(1,2)*R(1,2)




[R,P] = corrcoef(decimatedData.BulkStrat,decimatedData.Noise)
Rsqrd = R(1,2)*R(1,2)

[R,P] = corrcoef(decimatedData.Winds,decimatedData.Detections)
Rsqrd = R(1,2)*R(1,2)

[R,P] = corrcoef(decimatedData.SBLcapped,decimatedData.Detections)
Rsqrd = R(1,2)*R(1,2)

[R,P] = corrcoef(decimatedData.BottomTemp,decimatedData.Snaps)
Rsqrd = R(1,2)*R(1,2)

[R,P] = corrcoef(decimatedData.BottomTemp,decimatedData.Noise)
Rsqrd = R(1,2)*R(1,2)

%Frank has to decimate the data after separating it from the full.

% % Numbered in "filteredData"
% %Feb 5 00:00 - Feb 10 09:00 
% loop1Index = 130:259;
% %Feb 12 04:00 - Feb 18 18:00 
% loop2Index = 302:460;
% %Feb 18 19:00 - Feb 24 15:00
% loop3Index = 461:601;
% %Mar. 30 03:00 - Apr. 3 12:00
% loop4Index = 1429:1534;
% %Apr. 11 08:00 - Apr. 14 19:00
% loop5Index = 1722:1805;
% %Apr. 14 20:00 - Apr. 18 09:00
% loop6Index = 1806:1891;
% %Apr. 25 00:00 - Apr. 28 18:00
% loop7Index = 2050:2140;
% %Apr. 28 19:00 - May 2 12:00
% loop8Index = 2141:2230;

% Numbered in "decimatedData"
%Feb 4 23:00 - Feb 10 11:00 
loopIndexFilt{1} = 129:261;
loopIndexDS{1} = 33:66;

%Feb 12 03:00 - Feb 18 19:00 
loopIndexFilt{2} = 301:461;
loopIndexDS{2} = 76:116;

%Feb 18 19:00 - Feb 24 15:00
loopIndexFilt{3} = 461:601;
loopIndexDS{3} = 116:151;

%Mar. 30 03:00 - Apr. 3 15:00
loopIndexFilt{4} = 1429:1537;
loopIndexDS{4} = 358:385;

%Apr. 11 07:00 - Apr. 14 19:00
loopIndexFilt{5} =  1721:1805;
loopIndexDS{5} = 431:452;

%Apr. 14 19:00 - Apr. 18 12:00
loopIndexFilt{6} = 1805:1894;
loopIndexDS{6} = 452:474;

%Apr. 24 23:00 - Apr. 28 19:00
loopIndexFilt{7} = 2049:2141;
loopIndexDS{7} = 513:536;

%Apr. 28 19:00 - May 2 15:00
loopIndexFilt{8} = 2141:2233;
loopIndexDS{8} = 536:559;

for k = 1:length(loopIndexFilt)
    singleLoop{k}.Duration = length(surfaceData.WSPD(loopIndexFilt{k}))
    singleLoop{k}.WindMin = min(surfaceData.WSPD(loopIndexFilt{k}))
    singleLoop{k}.WindMax = max(surfaceData.WSPD(loopIndexFilt{k}))
    %
    singleLoop{k}.DetsMin = min(envData.HourlyDets(loopIndexFilt{k}))
    singleLoop{k}.DetsMax = max(envData.HourlyDets(loopIndexFilt{k}))
    %
    [R P] = corrcoef(decimatedData.Snaps(loopIndexDS{k}),decimatedData.SBLcapped(loopIndexDS{k}))
    singleLoop{k}.SnapSBLRsqrd = R(1,2)*R(1,2)
    singleLoop{k}.SnapSBLpvalue = P(1,2);
    %
    [R P] = corrcoef(decimatedData.Noise(loopIndexDS{k}),decimatedData.SBLcapped(loopIndexDS{k}))
    singleLoop{k}.NoiseSBLsqrd = R(1,2)*R(1,2)
    singleLoop{k}.NoiseSBLpvalue = P(1,2);
    %
    [R P] = corrcoef(decimatedData.Detections(loopIndexDS{k}),decimatedData.SBLcapped(loopIndexDS{k}))
    singleLoop{k}.DetectionsSBLsqrd = R(1,2)*R(1,2)
    singleLoop{k}.DetectionsSBLpvalue = P(1,2);
    %
    [R P] = corrcoef(decimatedData.BulkStrat(loopIndexDS{k}),decimatedData.SBLcapped(loopIndexDS{k}))
    singleLoop{k}.StratSBLsqrd = R(1,2)*R(1,2)
    singleLoop{k}.StratSBLpvalue = P(1,2)
    %
    [R P] = corrcoef(decimatedData.BulkStrat(loopIndexDS{k}),decimatedData.Detections(loopIndexDS{k}))
    singleLoop{k}.StratDetssqrd = R(1,2)*R(1,2)
    singleLoop{k}.StratDetspvalue = P(1,2)
end





