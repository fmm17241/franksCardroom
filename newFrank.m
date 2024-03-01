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

sunkenLowNoiseIndex = receiverData{5}.Noise < 650;
flatLowNoiseIndex   = receiverData{4}.Noise < 650;

sunkenHighNoiseIndex = receiverData{5}.Noise > 650;
flatHighNoiseIndex = receiverData{4}.Noise > 650;

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
tiledlayout(2,2,'TileSpacing','Compact')
nexttile()
hist(sunkenLowNoise.Noise)
title('Low Noise Levels, <650','Sunken Lagoon')
ylabel('Hours')
% xlabel(' HF Noise (mV)')
ylim([0 2300])
xlim([200 650])

nexttile()
hist(sunkenHighNoise.Noise)
title('High Noise Levels, >650','Sunken Lagoon')
% ylabel('Hours')
% xlabel(' HF Noise (mV)')
ylim([0 2300])
xlim([650 850])
set(gca, 'YTickLabel', [])

nexttile()
hist(flatLowNoise.Noise)
title('','Flat Reef')
ylabel('Hours')
xlabel(' HF Noise (mV)')
ylim([0 2300])
xlim([200 650])

nexttile()
hist(flatHighNoise.Noise)
title('','Flat Reef')
% ylabel('Hours')
xlabel(' HF Noise (mV)')
ylim([0 2300])
xlim([650 850])
set(gca, 'YTickLabel', [])

figure()
scatter(1, flatLowNoise.HourlyDets)
hold on
scatter(2, flatHighNoise.HourlyDets)
scatter(3, sunkenLowNoise.HourlyDets)
scatter(4, sunkenHighNoise.HourlyDets)





figure()
scatter(1, avgSunkLow,'filled','b')
hold on
errorbar(1,avgSunkLow,sunkenLowSTD)




sunkenLMWindNoise = fitlm(sunkenReef.windSpd,sunkenReef.Noise)
sunkenLMWindDets = fitlm(sunkenReef.windSpd,sunkenReef.HourlyDets)
sunkenLMTempNoise = fitlm(sunkenReef.Temp,sunkenReef.Noise)
sunkenLMNoiseDets = fitlm(sunkenReef.Noise,sunkenReef.HourlyDets)


for COUNT = 1:4
    flatLMWindNoise{COUNT}   = fitlm(flatReef{COUNT}.windSpd,flatReef{COUNT}.Noise)
    flatLMTempNoise{COUNT}   = fitlm(flatReef{COUNT}.Temp,flatReef{COUNT}.Noise)
    flatLMWindDets{COUNT}    = fitlm(flatReef{COUNT}.windSpd,flatReef{COUNT}.HourlyDets)
    flatLMNoiseDets{COUNT}   = fitlm(flatReef{COUNT}.Noise,flatReef{COUNT}.HourlyDets)
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
%Alright, gotta bring in environmental data from the gliders. Instead
%of just seasonal differences, I need to find times where stratification
%was minimal, there was winds, and STILL the detection rate increased

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\whatever'


cd 03192020_04112020\


load Mar_2020_angus_alldbds.mat
load Mar_2020_angus_ebds.mat




















