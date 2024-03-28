%Frank trying to pinpoint effects of wind on coastal ocean

%First, bring in wind data: "windsAverage"
windsAnalysis2014
clearvars time winds10Mins WDIR WSPD windsDN windsDT windsMonthly windsOriginal
close all

%Predict tides during 2014, and keep the ADCP data as well. Real currents
%(ADCP) vs predicted.
tidalAnalysis2014


%Okay, data loaded in, now I have to do some work. Going to subtract
%predicted tides from ADCP measured currents.

%Predicted tides: ut and vt, names changed for Frank's clarity. Gonna
%regret this.
predictedTime = tideDT;
predictedU = correctUT;
predictedV = correctVT;

%Original depth-averaged currents: uz and vz
measuredTime = adcp.time(2:2:end)';
measuredU = uz(2:2:end);
measuredV = vz(2:2:end);

%Let's go for it: finding anomaly
anomalyU = predictedU-measuredU;
anomalyV = predictedV-measuredV;

winds2014 = windsAverage(5562:8276,:)

winds2014.WDIR(isnan(winds2014.WDIR)) = 0;
winds2014.WSPD(isnan(winds2014.WSPD)) = 0;
%Frank needs to test this value, check to see if I broke it 

figure()
plot(measuredU,measuredV,'r');
hold on
plot(anomalyU,anomalyV,'k')

figure()
plot(measuredTime,measuredU)
hold on
plot(measuredTime,anomalyU)

figure()
tiledlayout(4,1,'Tilespacing','Compact')
ax1 = nexttile()
plot(winds2014.time,winds2014.WSPD,'k')
title('WindSpeed')
ax2 = nexttile()
plot(winds2014.time,winds2014.WDIR,'k')
title('WindDir')
ax3 = nexttile
scatter(measuredTime,anomalyU,'r','filled')
title('Current Anom., U')
ax4 = nexttile
scatter(measuredTime,anomalyV,'b','filled')
title('Current Anom., V')
linkaxes([ax1 ax2 ax3 ax4],'x')

%% Try to best plot this

startCyclePre = measuredTime(1);
%THIS IS WHERE I SET MY CHUNKS! 2 days gives clear patterns and is visually
%appealing, but can be changed for longer dataset analysis.

cycleDuration  = duration(days(2));

startCycle = startCyclePre
cycleTime = startCycle;
for k = 1:60 %roughly a full year of 2 day chunks
% for k  = 1:95 % for 4 day chunks
% for k = 1:35 %~30 day chunks
% for k = 1:25     %15 day chunks
% for k = 1:53 %weeks
%    cycleTime(k+1) = cycleTime(k) + fixOffset;  Use this to put in :30
%    offset here, but I've changed that.
   cycleTime(k+1) = cycleTime(k) + cycleDuration;
end
% 
% cd (localPlots)
% 
% 
% for k = 1:length(cycleTime)-1
%    ax = [cycleTime(k) cycleTime(k+1)];
%    axDN(1,1:2) = [datenum(ax(1)) datenum(ax(2))];
% 
% 
%     ff = figure()
%     set(gcf, 'Position',  [20, -20, 800, 1100])
%     nexttile([1 2])
%     plot(winds2014.time,winds2014.WSPD,'k');
%     %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
%     title('WindSpeeds');
%     xlim(ax);
%     ylim([0 14])
%     datetick('x','mmm,dd,yyyy','keeplimits');
%     ylabel('Wind Magnitudes');
%     hold on
% 
%     nexttile([1 2])
%     plot(winds2014.time,winds2014.WDIR,'k');
%     title('Wind Directions');
%     xlim(ax);
%     ylim([0 360])
%     datetick('x','mmm,dd,yyyy','keeplimits');
%     ylabel('Hourly Detections');
%     yline(300,'label','Onshore')
%     yline(118,'label','Offshore')
%     yline(30,'label','Along,NE')
%     yline(210,'label','Along,SW')
% 
% 
%     %     
%     nexttile([1 2])
%     plot(measuredTime,anomalyU,'r')
%     title('Current Anomaly, U')
%     ylabel('Mag (m/s)');
%     xlim(ax);
%     ylim([-.2 .2])
%     datetick('x','keeplimits');
%     yline(0);
%     xL=xlim;
%     yL=ylim;
%     str = 'East'
%     str1 = 'West'
%     text(xL(2),yL(2),str,'HorizontalAlignment','right','VerticalAlignment','top')
%     text(xL(2),yL(1),str1,'HorizontalAlignment','right','VerticalAlignment','bottom')
% 
%     nexttile([1 2])
%     plot(measuredTime,anomalyV,'b')
%     title('Current Anomaly, V');
%     ylabel('Mag (m/s)');
%     ylim([-.2 .2])
%     xlim(ax);
%     datetick('x','keeplimits');
%     yline(0);
%     str = 'North'
%     str1 = 'South'
%     text(xL(2),yL(2),str,'HorizontalAlignment','right','VerticalAlignment','top')
%     text(xL(2),yL(1),str1,'HorizontalAlignment','right','VerticalAlignment','bottom')
% 
% 
% %         
%     exportgraphics(ff,sprintf('saveIt%d.png',k))
%     close all
% end

R = corrcoef(anomalyU,winds2014.WSPD);


%%
testing = mean(anomalyU)

testing2= mean(anomalyV)
clearvars -except oneDrive githubToolbox windsAverage predicted* anomaly* measured*

%%
%Compare detections from that time?

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\2014'

% Load in processed receiver and detection data 
load receiver_reordered.mat

rec.timeDT = datetime(rec.timeDN,'convertfrom','datenum','timezone','utc');

%Picking receiver pairs that were successful and oriented in certain
%directions.
detsTime   = rec.timeDT;
detsCross1 = [rec.r4_5m rec.r6_5m rec.r1_2m]; detsCross = mean(detsCross1,2,'OmitNan');
detsAlong1 = [rec.r1_4m rec.r4_1m rec.r6_3m]; detsAlong = mean(detsAlong1,2, 'omitnan');


fullTime = [datetime(2014,08,20,16,00,00),datetime(2014,10,12,19,00,00)];
fullTime.TimeZone = 'UTC';

windsIndex = isbetween(windsAverage.time,fullTime(1,1),fullTime(1,2),'closed');
tideIndex = isbetween(measuredTime,fullTime(1,1),fullTime(1,2),'closed'); tideIndex(1276) = 1;
fullWindsData = [windsAverage.WSPD(windsIndex) windsAverage.WDIR(windsIndex)];


% fullData = table2timetable(table(tideDT, detsAlong,detsCross, windsAverage.WSPD(windsIndex), windsAverage.WDIR(windsIndex), tides'));
fullData = table2timetable(table(detsTime, detsAlong,detsCross, windsAverage.WSPD(windsIndex), windsAverage.WDIR(windsIndex), ...
    measuredU(tideIndex)',measuredV(tideIndex)',anomalyU(tideIndex)',anomalyV(tideIndex)'));
fullData.Properties.VariableNames = {'detsAlong','detsCross','windSpeed','windDir','TideU','TideV','AnomalyU','AnomalyV'};

separateData = table2timetable(table(detsTime, detsAlong1,detsCross1, windsAverage.WSPD(windsIndex), windsAverage.WDIR(windsIndex), ...
    measuredU(tideIndex)',measuredV(tideIndex)',anomalyU(tideIndex)',anomalyV(tideIndex)'));
separateData.Properties.VariableNames = {'detsAlong','detsCross','windSpeed','windDir','TideU','TideV','AnomalyU','AnomalyV'};

clearvars -except fullData detections time bottom* receiverData github* oneDrive predicted* anomaly* measured* separateData



windBins(1,:) = fullData.windSpeed < 2; 
windBins(2,:) = fullData.windSpeed > 1 & fullData.windSpeed < 2; 
windBins(3,:) = fullData.windSpeed > 2 & fullData.windSpeed < 3; 
windBins(4,:) = fullData.windSpeed > 3 & fullData.windSpeed < 4; 
windBins(5,:) = fullData.windSpeed > 4 & fullData.windSpeed < 5; 
windBins(6,:) = fullData.windSpeed > 5 & fullData.windSpeed < 6; 
windBins(7,:) = fullData.windSpeed > 6 & fullData.windSpeed < 7; 
windBins(8,:) = fullData.windSpeed > 7 & fullData.windSpeed < 8; 
windBins(9,:) = fullData.windSpeed > 8 & fullData.windSpeed < 9; 
windBins(10,:) = fullData.windSpeed > 9 & fullData.windSpeed < 10; 
windBins(11,:) = fullData.windSpeed > 10 & fullData.windSpeed < 11; 
windBins(12,:) = fullData.windSpeed > 11;


% indWindBins(1,:) = separateData.windSpeed < 2; 
% indWindBins(2,:) = separateData.windSpeed > 1 & separateData.windSpeed < 2; 
% indWindBins(3,:) = separateData.windSpeed > 2 & separateData.windSpeed < 3; 
% indWindBins(4,:) = separateData.windSpeed > 3 & separateData.windSpeed < 4; 
% indWindBins(5,:) = separateData.windSpeed > 4 & separateData.windSpeed < 5; 
% indWindBins(6,:) = separateData.windSpeed > 5 & separateData.windSpeed < 6; 
% indWindBins(7,:) = separateData.windSpeed > 6 & separateData.windSpeed < 7; 
% indWindBins(8,:) = separateData.windSpeed > 7 & separateData.windSpeed < 8; 
% indWindBins(9,:) = separateData.windSpeed > 8 & separateData.windSpeed < 9; 
% indWindBins(10,:) = separateData.windSpeed > 9 & separateData.windSpeed < 10; 
% indWindBins(11,:) = separateData.windSpeed > 10 & separateData.windSpeed < 11; 
% indWindBins(12,:) = separateData.windSpeed > 11;



for k = 1:height(windBins)
    windScenario{k}= fullData(windBins(k,:),:);
    averageWindX(1,k) = mean(windScenario{1,k}.detsCross);
    averageWindA(1,k) = mean(windScenario{1,k}.detsAlong);
end
normalizedWindX  = averageWindX/(max(averageWindX));
normalizedWindA  = averageWindA/(max(averageWindA));


x = 0.5:11.5;
figure()
scatter(x,normalizedWindA,'r','filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
hold on
scatter(x,normalizedWindX,'b','filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
xlabel('Windspeed (m/s)');
ylabel('Normalized Detections');
legend({'Along-Pairs','Cross-Pairs'});
title('2014 Cross and Alongshore Pairs','High Transmission Density');

%
anomalyUBins(1,:) = fullData.AnomalyU < -0.15; 
anomalyUBins(2,:) = fullData.AnomalyU > -0.15 & fullData.AnomalyU < -0.1; 
anomalyUBins(3,:) = fullData.AnomalyU > -0.1 & fullData.AnomalyU < -0.05; 
anomalyUBins(4,:) = fullData.AnomalyU > -0.05 & fullData.AnomalyU < 0; 
anomalyUBins(5,:) = fullData.AnomalyU > 0 & fullData.AnomalyU < 0.05; 
anomalyUBins(6,:) = fullData.AnomalyU > 0.05 & fullData.AnomalyU < 0.1; 
anomalyUBins(7,:) = fullData.AnomalyU > 0.1 & fullData.AnomalyU < 0.15; 
anomalyUBins(8,:) = fullData.AnomalyU > 0.15; 

anomalyVBins(1,:) = fullData.AnomalyV < -0.15; 
anomalyVBins(2,:) = fullData.AnomalyV > -0.15 & fullData.AnomalyV < -0.1; 
anomalyVBins(3,:) = fullData.AnomalyV > -0.1 & fullData.AnomalyV < -0.05; 
anomalyVBins(4,:) = fullData.AnomalyV > -0.05 & fullData.AnomalyV < 0; 
anomalyVBins(5,:) = fullData.AnomalyV > 0 & fullData.AnomalyV < 0.05; 
anomalyVBins(6,:) = fullData.AnomalyV > 0.05 & fullData.AnomalyV < 0.1; 
anomalyVBins(7,:) = fullData.AnomalyV > 0.1 & fullData.AnomalyV < 0.15; 
anomalyVBins(8,:) = fullData.AnomalyV > 0.15; 


for k = 1:height(anomalyUBins)
    anomalyUScenario{k}= fullData(anomalyUBins(k,:),:);
    averageAnomUX(1,k) = mean(anomalyUScenario{1,k}.detsCross);
    averageAnomUA(1,k) = mean(anomalyUScenario{1,k}.detsAlong);
end
normalizedAnomUX  = averageAnomUX/(max(averageAnomUX));
normalizedAnomUA  = averageAnomUA/(max(averageAnomUA));

for k = 1:height(anomalyVBins)
    anomalyVScenario{k}= fullData(anomalyVBins(k,:),:);
    averageAnomVX(1,k) = mean(anomalyVScenario{1,k}.detsCross);
    averageAnomVA(1,k) = mean(anomalyVScenario{1,k}.detsAlong);
end
normalizedAnomVX  = averageAnomVX/(max(averageAnomVX));
normalizedAnomVA  = averageAnomVA/(max(averageAnomVA));

x = -0.15:0.05:0.20;
figure()
plot(x,normalizedAnomUA,'r')
hold on
plot(x,normalizedAnomUX,'b')
plot(x,normalizedAnomVA,'--')
plot(x,normalizedAnomVX,'-.')
xlabel(' Current Anomaly');
ylabel('Normalized Detections');
legend({'Cross-Shore Anomaly Effect on Along-Shore Pairs','Cross-Shore Anomaly Effect on Cross-Shore Pairs','Along-Shore Anomaly Effect on Along-Shore Pairs','Along-Shore Anomaly Effect on Cross-Shore Pairs'});
title('2014 Cross and Alongshore Pairs','High Transmission Density');

