%Instead of slicing the data into chunks, this instead moves a window and
%gives us glimpses at chunks of the larger set.

%Tidal predictions, rotated to be along vs cross-shore. Uses tideDT,
%rotUtide
tidalAnalysis2014

%Detections with one transceiver pair, ~0.53 km. Uses
%hourlyDetections{X}.time/detections
% mooredEfficiency
cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\2014'
load receiver_reordered.mat
rec.timeDT = datetime(rec.timeDN,'convertfrom','datenum','timezone','utc');

%Picking receiver pairs that were successful and oriented in certain
%directions.
detsCross1 = [rec.r4_5m rec.r6_5m rec.r1_2m]; detsCross = mean(detsCross1,2,'omitnan');
detsAlong1 = [rec.r1_4m rec.r4_1m rec.r6_3m]; detsAlong = mean(detsAlong1,2,'omitnan');
detsCompare1 = [rec.r1_4m rec.r4_1m]; detsCompare = mean(detsCompare1,2,'omitnan');


%Thermal stratification between transceiver temperature measurements and
%NOAA buoy SST measurements. Uses bottom.bottomTime, buoyStratification,
%bottom.tilt, and leftovers (disconnected pings, measure of transmission
%failure)
% sstAnalysis2014

%Winds magnitude and direction from the buoy. Uses windsDN/U/V.
windsAnalysis2014

close all
%% Aims to break up our time series into chunks of time.
%Begins Jan 4th, 2020 11:30 UTC.
% startCyclePre = tideDT(168)

% FM CHANGE 8/4/2022 Wanted to start at midnight
startCyclePre = tideDT(97);
%THIS IS WHERE I SET MY CHUNKS! 2 days gives clear patterns and is visually
%appealing, but can be changed for longer dataset analysis.
% 
% % Basic:
% cycleDuration  = duration(days(2));

%Changed:
cycleDuration  = duration(days(2));


%old
% fixOffset = 0.5*cycleDuration;

% startCycle = startCyclePre - fixOffset
startCycle = startCyclePre

cycleTime = startCycle;
% for k = 1:181 %roughly a full year of 2 day chunks
for k  = 1:30 % for day chunks
%    cycleTime(k+1) = cycleTime(k) + fixOffset;  Use this to put in :30
%    offset here, but I've changed that.
   cycleTime(k+1) = cycleTime(k) + cycleDuration;
end




%% 
% Okay. I can plot the chunks with "chunkPlotter", now I need to correctly separate 
% the times to compare them quantitatively.

% noiseDT = datetime(receiverData{1,1}.avgNoise(:,1),'convertfrom','datenum');
% noiseDT.TimeZone = 'UTC';

chunkTime = cell(1,length(cycleTime)-1);

for P = 1:length(chunkTime)
    currentChunk1 = cycleTime(P);
    currentChunk2 = cycleTime(P+1);
    chunkTime{P}  = [currentChunk1,currentChunk2];
end
%%
%Currently this shows chunks of time and has the values for characteristics
%at those times. Compared to detections, might tell us something.
for PT = 1:length(chunkTime)
    % Detections, chose transceivers above
    indexDet = isbetween(rec.timeDT,chunkTime{PT}(1),chunkTime{PT}(2));
    cStructure{PT}.detections = detsCompare(indexDet,:);

    % Tides for time period
    indexTide = isbetween(tideDT,chunkTime{PT}(1),chunkTime{PT}(2));
    cStructure{PT}.tides = timetable(tideDT(indexTide),rotUtide(indexTide)',rotVtide(indexTide)');
    cStructure{PT}.tides = cStructure{PT}.tides(1:2:end,:);
    cStructure{PT}.tides.Properties.VariableNames = {'XShore','AlongShore'}';
    
    % Winds
    indexWinds = isbetween(windsDT,chunkTime{PT}(1),chunkTime{PT}(2));
    cStructure{PT}.winds = timetable(windsDT(indexWinds),windsU(indexWinds),windsV(indexWinds),windsAverage.WSPD(indexWinds),windsAverage.WDIR(indexWinds));
     cStructure{PT}.winds.Properties.VariableNames = {'Uwinds','Vwinds','windSpd','windDir'};
     cStructure{PT}.winds.windSpd(isnan(cStructure{PT}.winds.windSpd)) = 0;
end
%%
%%
%This finds correlation each week between noise and detections
% for k = 2:11
%          testCor = corrcoef(cStructure{1,k}.noise.noise,cStructure{1,k}.detections.detections);
%         correlationNoise(k)    = testCor(1,2)
% end
% 
% xMonths= 1:11;
% figure()
% scatter(xMonths,correlationNoise,'filled','red');
% title('Correlation: Noise vs Detections');
% xlabel('Months');
% ylabel('Dets vs Noise Coeff');
% 
% 
% %This finds correlation each week between wind magnitude and detections
% for k = 2:11
%          testCor = corrcoef(cStructure{1,k}.winds.windSpd,cStructure{1,k}.detections.detections);
%         correlationWinds(k)    = testCor(1,2)
% end
% 
% %This finds correlation each week between wind magnitude and noise
% for k = 2:11
%          testCor = corrcoef(cStructure{1,k}.winds.windSpd,cStructure{1,k}.noise.noise);
%         correlationBoth(k)    = testCor(1,2)
% end
% 
% figure()
% scatter(xMonths,correlationBoth,'filled','k');
% title('Noise and WindSpd Correlation');
% xlabel('Months')
% ylabel('Correlation Coeff');
% 
% 
% xMonths= 1:11;
% 
% figure()
% nexttile([1 2])
% scatter(xMonths,correlationWinds,'filled','blue');
% hold on
% plot(xMonths,correlationWinds,'blue');
% ylabel('Winds Correlation');
% title('Winds (+) and Noise (-) as drivers for Detection Efficiency');
% 
% nexttile([1 2])
% scatter(xMonths,correlationNoise,'filled','red');
% hold on
% plot(xMonths,correlationNoise,'red');
% % xlabel('Months');
% ylabel('Noise Correlation');
% xlabel('Months');
% xlim([2 11])
% 
% 
% 
% figure()
% scatter(xMonths,correlationNoise,'filled','red');
% hold on
% yline(0);
% plot(xMonths,correlationNoise,'red');
% scatter(xMonths,correlationWinds,'filled','blue');
% plot(xMonths,correlationWinds,'blue');
% ylabel('Correlation Coefficient');
% xlabel('Months');
% title('Wind(Blue) and Noise(Red) Correlations to Hourly Detections');

%% Testing different visualizations of hourly success.
% 
% for PT = 2:11
%     formatOut = 'mm/dd/yy';
%     start = datestr(cStructure{1,PT}.detections.time(1),formatOut);
%     finish = datestr(cStructure{1,PT}.detections.time(end),formatOut);
%     figure()
%     scatter(cStructure{1,PT}.winds.windSpd,cStructure{1,PT}.detections.detections);
%     title(sprintf('Dets vs WindSpd, %s to %s',start,finish));
%     xlabel('WindSpeed (m/s)');
%     ylabel('Detections, Hourly');
% end
% 
% for PT = 2:11
%     formatOut = 'mm/dd/yy';
%     start = datestr(cStructure{1,PT}.detections.time(1),formatOut);
%     finish = datestr(cStructure{1,PT}.detections.time(end),formatOut);
%     h =  figure()
%     scatter(cStructure{1,PT}.winds.windDir,cStructure{1,PT}.detections.detections);
%     t = xline(242,'r');
%     v = xline(62,'b');
%     title(sprintf('Dets vs WindDir, %s to %s',start,finish));
%     xlabel('WindDir, CW from N');
%     ylabel('Detections, Hourly');
%     legend([t,v],'same','against');
% end




% relation = corrcoef(leftovers,compareTide);








