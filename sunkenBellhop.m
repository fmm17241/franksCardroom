%FM 2/20/24
%Creating bellhop ray traces to support "sunken reef" idea

% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\bellhopTesting' % Laptop
cd 'C:\Users\fmac4\OneDrive - University of Georgia\data\bellhopTesting'  %  Home  PC


bellhop('frank2D')

figure()
plotray('frank2D')

%Frank needs to test soundsource depths and distances from sunken portion
%of reef. Might end up being separate work
figure()
tiledlayout(3,1,'TileSpacing','Compact')
bellhop('frank2D')
nexttile()
plotray('frank2D')




mooredEfficiency
%We're looking at {11}, FS17 hearing STSNew1
% stationWindsAnalysis
buildReceiverData

figure()
tiledlayout(3,1,'TileSpacing','Compact')
ax1 = nexttile()
scatter(hourlyDetections{11}.time,hourlyDetections{11}.detections)
ylabel('Dets')

ax2 = nexttile()
scatter(receiverData{4}.DT,receiverData{4}.windSpd)
ylabel('Windspeed (m/s)')
title('','Windspeed')

ax3 = nexttile()
scatter(receiverData{5}.DT,receiverData{5}.Noise)
ylabel('Noise')
title('','Noise')

linkaxes([ax1 ax2 ax3],'x')

figure()
tiledlayout(3,1,'TileSpacing','Compact')

ax1 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd)
title('Windspeed')

ax2 = nexttile()
hold on
for COUNT = 1:length(receiverData)
    plot(receiverData{COUNT}.DT,receiverData{COUNT}.HourlyDets)
end
title('Detections')

ax3 = nexttile()
hold on
for COUNT = 1:length(receiverData)
    plot(receiverData{COUNT}.DT,receiverData{COUNT}.Noise)
end
title('HF Noise')

linkaxes([ax1 ax2 ax3],'x')

figure()
hold on
plot(receiverData{2}.DT,receiverData{2}.HourlyDets)


%%
%Need to account for difference in reflection? Hmmmmm
figure()
scatter(signalWinds{4},signalPings{4});
title('Flatreef Pings')
figure()
scatter(signalWinds{4},signalDets{4});
title('Flatreef Dets')

figure()
scatter(signalWinds{5},signalPings{5});
title('Sunken Pings')
figure()
scatter(signalWinds{5},signalDets{5});
title('Sunken Dets')



figure()
tiledlayout(3,1,'TileSpacing','Compact')

ax1 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd)
title('Windspeed')

ax2 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.PingRatio)
title('Flat, Dense Reef')
ylabel('PingRatio')
ylim([0 1])

ax3 = nexttile()
plot(receiverData{5}.DT,receiverData{5}.PingRatio)
ylabel('PingRatio')
title('Protected, Lower Reef')
ylim([0 1])

linkaxes([ax1 ax2 ax3],'x')

