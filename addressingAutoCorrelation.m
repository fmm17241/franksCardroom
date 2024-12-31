
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

filteredACF = autocorr(filteredData.Snaps,'NumLags',100)
rawACF = autocorr(receiverData{1}.Noise,'NumLags',100)

% Plot
lags = 0:100; % Include lag 0
plot(lags, rawACF, '-o', 'DisplayName', 'Raw Data');
hold on;
plot(lags, filteredACF, '-s', 'DisplayName', 'Filtered Data');
xlabel('Lag (hours)');
ylabel('Autocorrelation');
legend;
title('Autocorrelation Comparison');
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

plot(model)


crosscorr(receiverData{1}.windSpd, receiverData{1}.Noise, 'NumLags', 50);

laggedWind = lagmatrix(filteredData.Winds, [0 2]); % Includes current and lag-2 values
model = fitlm(laggedWind, filteredData.Noise);

residuals = model.Residuals.Raw;
autocorr(residuals, 'NumLags', 50);

%
%Frank needs to use ARIMA model to reduce autocorrelation which persists



