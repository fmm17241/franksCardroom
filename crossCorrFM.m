buildReceiverData   

% Compute the cross-correlation
[c,lags] = xcorr(receiverData{4}.Noise,receiverData{4}.HourlyDets)

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



