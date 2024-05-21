buildReceiverData   

detections = receiverData{4}.HourlyDets;
temp = receiverData{4}.Temp;
noise      = receiverData{4}.Noise;


% Compute the cross-correlation
[c,lags] = xcorr(noise,temp,'coeff')

figure;
plot(lags, c);
xlabel('Lag');
ylabel('Cross-Correlation Coefficient');
title('Cross-Correlation between Temp and Noise');
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



