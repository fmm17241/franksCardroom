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

cd (localPlots)


for k = 1:length(cycleTime)-1
   ax = [cycleTime(k) cycleTime(k+1)];
   axDN(1,1:2) = [datenum(ax(1)) datenum(ax(2))];
    
    
    ff = figure()
    set(gcf, 'Position',  [20, -20, 800, 1100])
    nexttile([1 2])
    plot(winds2014.time,winds2014.WSPD,'k');
    %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
    title('WindSpeeds');
    xlim(ax);
    ylim([0 14])
    datetick('x','mmm,dd,yyyy','keeplimits');
    ylabel('Wind Magnitudes');
    hold on
    
    nexttile([1 2])
    plot(winds2014.time,winds2014.WDIR,'k');
    title('Wind Directions');
    xlim(ax);
    ylim([0 360])
    datetick('x','mmm,dd,yyyy','keeplimits');
    ylabel('Hourly Detections');
    yline(300,'label','Onshore')
    yline(118,'label','Offshore')
    yline(30,'label','Along,NE')
    yline(210,'label','Along,SW')


    %     
    nexttile([1 2])
    plot(measuredTime,anomalyU,'r')
    title('Current Anomaly, U')
    ylabel('Mag (m/s)');
    xlim(ax);
    ylim([-.2 .2])
    datetick('x','keeplimits');
    yline(0);
    xL=xlim;
    yL=ylim;
    str = 'East'
    str1 = 'West'
    text(xL(2),yL(2),str,'HorizontalAlignment','right','VerticalAlignment','top')
    text(xL(2),yL(1),str1,'HorizontalAlignment','right','VerticalAlignment','bottom')

    nexttile([1 2])
    plot(measuredTime,anomalyV,'b')
    title('Current Anomaly, V');
    ylabel('Mag (m/s)');
    ylim([-.2 .2])
    xlim(ax);
    datetick('x','keeplimits');
    yline(0);
    str = 'North'
    str1 = 'South'
    text(xL(2),yL(2),str,'HorizontalAlignment','right','VerticalAlignment','top')
    text(xL(2),yL(1),str1,'HorizontalAlignment','right','VerticalAlignment','bottom')

  
%         
    exportgraphics(ff,sprintf('saveIt%d.png',k))
    close all
end

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

clearvars -except fullData detections time bottom* receiverData github* oneDrive predicted* anomaly* measured*





