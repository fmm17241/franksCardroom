
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
% Create periodic terms for diurnal cycle
t = (1:height(receiverData{1}))'; % Time index
omega = 2 * pi / 24; % Diurnal frequency
sinTerm = sin(omega * t);
cosTerm = cos(omega * t);

% Add periodic terms to GLS model
predictors = [receiverData{1}.windSpd, sinTerm, cosTerm];
modelWithPeriodicity = fitlm(predictors, receiverData{1}.Noise);

% Extract residuals
glsResidualsWithPeriodicity = modelWithPeriodicity.Residuals.Raw;

% Check autocorrelation of new residuals
figure()
autocorr(glsResidualsWithPeriodicity, 'NumLags', 50);

% Detrend the data
detrendedNoise = detrend(receiverData{1}.Noise, 'linear');
detrendedWinds = detrend(receiverData{1}.windSpd, 'linear');

% Fit GLS with detrended data and periodic terms
modelDetrendedWithPeriodicity = fitlm([detrendedWinds, sinTerm, cosTerm], detrendedNoise);

figure()
plot(modelDetrendedWithPeriodicity)




