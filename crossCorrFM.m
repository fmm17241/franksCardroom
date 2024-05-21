buildReceiverData   



time = receiverData{4}.DT

detections = receiverData{4}.HourlyDets
temp = receiverData{4}.Temp
noise      = receiverData{4}.Noise


%Frank isolates spring to check cross-correlation.
time = receiverData{4}.DT(1685:3271);

detections = receiverData{4}.HourlyDets(1685:3271);
temp = receiverData{4}.Temp(1685:3271);
noise      = receiverData{4}.Noise(1685:3271);


figure()
plot(time,detections)
% Compute the cross-correlation
[c,lags] = xcorr(noise,detections,'coeff')

figure;
plot(lags, c);
xlabel('Lag');
ylabel('Cross-Correlation Coefficient');
title('Cross-Correlation between Detections and Noise');
grid on;


%%%%%%%%%%%%%%%%%%%%
clear time detections temp noise
time = receiverData{4}.DT(4407:6270);

detections = receiverData{4}.HourlyDets(4407:6270);
temp = receiverData{4}.Temp(4407:6270);
noise      = receiverData{4}.Noise(4407:6270);

[c,lags] = xcorr(noise,detections,'coeff')

figure;
plot(lags, c);
xlabel('Lag');
ylabel('Cross-Correlation Coefficient');
title('Cross-Correlation between Dets and Noise');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear time detections temp noise
time = receiverData{4}.DT(6554:9425);

detections = receiverData{4}.HourlyDets(6554:9425);
temp = receiverData{4}.Temp(6554:9425);
noise      = receiverData{4}.Noise(6554:9425);

[c,lags] = xcorr(noise,detections,'coeff')

figure;
plot(lags, c);
xlabel('Lag');
ylabel('Cross-Correlation Coefficient');
title('Cross-Correlation between Dets and Noise');
grid on;



DiffDetections = diff(detections);
DiffNoise = diff(noise);
[c, lags] = xcorr(DiffDetections, DiffNoise, 'coeff');
