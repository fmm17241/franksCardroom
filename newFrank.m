%Frank needs to focus on FS17 and 33OUT and the relationship between


mooredEfficiency
%We're looking at {11}, FS17 hearing STSNew1
% stationWindsAnalysis
buildReceiverData

clearvars -except receiverData hourlyDetections mooredReceivers oneDrive githubToolbox
close all

sunkenReef = receiverData{5};
flatReef{1}   = receiverData{4};
flatReef{2}   = receiverData{1};
flatReef{3}   = receiverData{2};
flatReef{4}   = receiverData{13};


hillToSunken = hourlyDetections{11};
hillToFlat   = hourlyDetections{14};

clearvars -except receiverData sunkenReef flatReef hillTo* oneDrive githubToolbox
close all

%Okay. Two scenarios to compare, quantitatively

sunkenLowNoiseIndex = receiverData{5}.Noise < 600;
flatLowNoiseIndex   = receiverData{4}.Noise < 600;

sunkenHighNoiseIndex = receiverData{5}.Noise > 700;
flatHighNoiseIndex = receiverData{4}.Noise > 700;

sunkenLowNoise = receiverData{5}(sunkenLowNoiseIndex,:);
sunkenHighNoise = receiverData{5}(sunkenHighNoiseIndex,:);
flatLowNoise = receiverData{4}(flatLowNoiseIndex,:);
flatHighNoise = receiverData{4}(flatHighNoiseIndex,:);


avgSunkLow  = mean(sunkenLowNoise.HourlyDets)
avgSunkHigh = mean(sunkenHighNoise.HourlyDets)

avgFlatLow  = mean(flatLowNoise.HourlyDets)
avgFlatHigh = mean(flatHighNoise.HourlyDets)


sunkenLowSTD = std(sunkenLowNoise.HourlyDets);
sunkenHighSTD = std(sunkenHighNoise.HourlyDets);
flatLowSTD = std(flatLowNoise.HourlyDets);
flatHighSTD = std(flatHighNoise.HourlyDets);

sunkenLowInterval = [sunkenLowNoise.HourlyDets + sunkenLowSTD,sunkenLowNoise.HourlyDets - sunkenLowSTD ];
sunkenHighInterval = [sunkenHighNoise.HourlyDets + sunkenHighSTD,sunkenHighNoise.HourlyDets - sunkenHighSTD ];
flatLowInterval = [flatLowNoise.HourlyDets + flatLowSTD,flatLowNoise.HourlyDets - flatLowSTD ];
flatHighInterval = [flatHighNoise.HourlyDets + flatHighSTD,flatHighNoise.HourlyDets - flatHighSTD ];




figure()
(1, avgSunkLow)





sunkenLMWindNoise = fitlm(sunkenReef.windSpd,sunkenReef.Noise)
sunkenLMWindDets = fitlm(sunkenReef.windSpd,sunkenReef.HourlyDets)
sunkenLMTempNoise = fitlm(sunkenReef.Temp,sunkenReef.Noise)


for COUNT = 1:4
    flatLMWindNoise{COUNT}   = fitlm(flatReef{COUNT}.windSpd,flatReef{COUNT}.Noise)
    flatLMTempNoise{COUNT}   = fitlm(flatReef{COUNT}.Temp,flatReef{COUNT}.Noise)
    flatLMWindDets{COUNT}   = fitlm(flatReef{COUNT}.windSpd,flatReef{COUNT}.HourlyDets)
end




%%
%
figure()
tiledlayout(3,1,'TileSpacing','Compact')
ax1 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd)
title('Seasonal Differences','Windspeed')
ylabel('W.Speed (m/s)')

% ax2 = nexttile()
% plot(receiverData{4}.DT,receiverData{4}.crossShore)
% title('','X-Shore Tides, Neg Flood Pos Ebb')
% ylabel('Currents (m/s)')

ax2 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.Noise,'k')
title('','HF Noise (50-100 kHz)')
ylabel('Noise (mV)')

ax3 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.HourlyDets)
title('','DETECTIONS')
ylabel('Hourly Dets')

linkaxes([ax1,ax2,ax3],'x')


figure()
plot(sunkenReef.DT,sunkenReef.Temp)



%%
%Bring in 2014? Too much?











