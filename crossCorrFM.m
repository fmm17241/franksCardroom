buildReceiverData   

detections = receiverData{4}.HourlyDets;
noise      = receiverData{4}.Noise;


% Compute the cross-correlation
[c,lags] = xcorr(noise,detections,'coeff')

figure;
plot(lags, c);
xlabel('Lag');
ylabel('Cross-Correlation Coefficient');
title('Cross-Correlation between HourlyDetections and Noise');
grid on;

% Plot the cross-correlation
figure()
stem(lags, c);
xlabel('Lag');
ylabel('Cross-correlation');
title('Cross-correlation between x and y');





[c,lags] = xcorr(receiverData{5}.Noise,receiverData{5}.HourlyDets)

% Plot the cross-correlation
figure()
stem(lags, c);
xlabel('Lag');
ylabel('Cross-correlation');
title('Cross-correlation between x and y');



