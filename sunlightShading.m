%FM, run SunriseSunset
%editing to remember
%This is to shade a figure for every nighttime, to show diurnal changes.

startDT = datetime(2020,01,01,00,00,00);
endDT   = datetime(2020,12,31,23,00,00);


figure()
plot(hourlyAVG.Time,hourlyAVG.Detections,'LineWidth',0.0001);
hold on
yValue = [0 10000];
for k = 1:length(sunset)-1
    x = [sunset(k) sunrise(k+1)];
    area(x,yValue,'FaceColor','k','FaceAlpha',0.2);
end
ylim([2 17])
plot(hourlyAVG.Time,hourlyAVG.Detections,'r','LineWidth',2);
% dynamicDateTicks()
title('(Semi)Diurnal Signals in Detections');
label_y = ylabel('Detections');
% label_y.Position(1) = -20;


% useDT = datetime(receiverData{5}.avgNoise(:,1),'ConvertFrom','datenum','TimeZone','UTC');
% useDT.TimeZone = 'local';


% figure()
% plot(useDT,receiverData{5}.avgNoise(:,2));
% hold on
% yValue = [0 10000];
% for k = 1:length(sunset)-1
%     x = [sunset(k) sunrise(k+1)];
%     area(x,yValue,'FaceColor','k','FaceAlpha',0.2);
% end
% ylim([250 800])
% plot(useDT,receiverData{5}.avgNoise(:,2),'LineWidth',4);
% scatter(useDT,receiverData{5}.avgNoise(:,2));
% dynamicDateTicks()
% ylabel('Noise (dB)');
% title('Increasing Noise as Sunlight changes');

%%using avg instead 
figure()
plot(hourlyAVG.Time,hourlyAVG.Noise);
hold on
yValue = [0 10000];
for k = 1:length(sunset)-1
    x = [sunset(k) sunrise(k+1)];
    area(x,yValue,'FaceColor','k','FaceAlpha',0.2);
end
ylim([250 800])
plot(hourlyAVG.Time,hourlyAVG.Noise,'LineWidth',4);
scatter(hourlyAVG.Time,hourlyAVG.Noise);
% dynamicDateTicks()
ylabel('Noise (dB)');
title('Increasing Noise as Sunlight changes');



