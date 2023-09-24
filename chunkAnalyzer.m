%Instead of slicing the data into chunks, this instead moves a window and
%gives us glimpses at chunks of the larger set.

%Tidal predictions, rotated to be along vs cross-shore. Uses tideDT,
%rotUtide
% tidalAnalysis2020
%FRANK TEST: ADD ON angles
matchAngles
close all
%Detections with one transceiver pair, ~0.53 km. Uses
%hourlyDetections{X}.time/detections
mooredEfficiency

%Thermal stratification between transceiver temperature measurements and
%NOAA buoy SST measurements. Uses bottom.bottomTime, buoyStratification,
%bottom.tilt, and leftovers (disconnected pings, measure of transmission
%failure)
bottomAnalysis2020

%Winds magnitude and direction from the buoy. Uses windsDN/U/V.
windsAnalysis2020

%TESTING: Detections on the wind rose for different seasons
windsAverage(691:8445,3) = hourlyDetections{1,1};
% %Astronomical
% %Winter start to March 20th 1:11349 OR 691:1898
% WindRose(windsAverage.WDIR(691:1898),windsAverage.Var3(691:1898),'AngleNorth',0,'AngleEast',90,'nDirections',5,'FreqLabelAngle','ruler');
% title('Wind Rose, Winter');
% %Spring March 20th to June 21st 11350:24715 OR 1899:4130
% WindRose(windsAverage.WDIR(1899:4130),windsAverage.Var3(1899:4130),'AngleNorth',0,'AngleEast',90,'nDirections',5,'FreqLabelAngle','ruler');
% title('Wind Rose, Spring');
% %Summer June 21st to Sept 22nd 24716:37689 OR 4131:6362
% WindRose(windsAverage.WDIR(4131:6362),windsAverage.Var3(4131:6362),'AngleNorth',0,'AngleEast',90,'nDirections',5,'FreqLabelAngle','ruler');
% title('Wind Rose, Summer');
% %Fall Sept 22nd to December 21st 37689:end OR 6363:8445
% WindRose(windsAverage.WDIR(6363:8445),windsAverage.Var3(6363:8445),'AngleNorth',0,'AngleEast',90,'nDirections',5,'FreqLabelAngle','ruler');
% title('Wind Rose, Fall');



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
for k = 1:175 %roughly a full year of 2 day chunks
% for k  = 1:95 % for 4 day chunks
% for k = 1:35 %~30 day chunks
% for k = 1:25     %15 day chunks
% for k = 1:53 %weeks
%    cycleTime(k+1) = cycleTime(k) + fixOffset;  Use this to put in :30
%    offset here, but I've changed that.
   cycleTime(k+1) = cycleTime(k) + cycleDuration;
end




%% 
% Okay. I can plot the chunks with "chunkPlotter", now I need to correctly separate 
% the times to compare them quantitatively.

%I want to put my cycles back to hourly, less focused on visualization
cycleTime2 = cycleTime;

% for k = 1:length(hourlyDetections)
%     hourlyDetections{k}.time = hourlyDetections{k}.time - offset; 
% end
% This little section is to make things hourly. Please refer to this if
% anything gets messed up.


%These modify the mooredEfficiency transceiver pairings to use. 2 is the
%one that has been most successful, but we want to analyze other pairings.


for COUNT = 1:length(receiverData)
    noiseDT{COUNT} = datetime(receiverData{1,COUNT}.avgNoise(:,1),'convertfrom','datenum');
    noiseDT{COUNT}.TimeZone = 'UTC';
end

chunkTime = cell(1,length(cycleTime2)-1);

for P = 1:length(chunkTime)
    currentChunk1 = cycleTime2(P);
    currentChunk2 = cycleTime2(P+1);
    chunkTime{P}  = [currentChunk1,currentChunk2];
end
%%
%Currently this shows chunks of time and has the values for characteristics
%at those times. Compared to detections, might tell us something.
for COUNT = 1:length(receiverData)
    for PT = 1:length(chunkTime)
        % Detections, chose transceivers above
        indexDet = isbetween(hourlyDetections{COUNT}.time,...
             chunkTime{PT}(1),chunkTime{PT}(2));
        cStructure{COUNT}{PT}.detections = hourlyDetections{COUNT}(indexDet,:);
    
        % Tides for time period
        indexTide = isbetween(tideDT,chunkTime{PT}(1),chunkTime{PT}(2));
        cStructure{COUNT}{PT}.tides = timetable(tideDT(indexTide),rotUtide(COUNT,indexTide)',rotVtide(COUNT,indexTide)');
        cStructure{COUNT}{PT}.tides = cStructure{COUNT}{PT}.tides(1:2:end,:);
        cStructure{COUNT}{PT}.tides.Properties.VariableNames = {'XShore','AlongShore'}';
        
        % Winds
        indexWinds = isbetween(windsDT,chunkTime{PT}(1),chunkTime{PT}(2));
        cStructure{COUNT}{PT}.winds = timetable(windsDT(indexWinds),windsU(indexWinds),windsV(indexWinds),windsAverage.WSPD(indexWinds),windsAverage.WDIR(indexWinds));
         cStructure{COUNT}{PT}.winds.Properties.VariableNames = {'Uwinds','Vwinds','windSpd','windDir'};
         cStructure{COUNT}{PT}.winds.windSpd(isnan(cStructure{COUNT}{PT}.winds.windSpd)) = 0;
        
    %     % Bulk Thermal stratification
    %     indexStrat = isbetween(bottom{PT}.Time,chunkTime{PT}(1),chunkTime{PT}(2));
    %     cStructure{PT}.strat = timetable(bottom{PT}.Time(indexStrat),stratification{PT}(indexStrat));
    %     cStructure{PT}.strat.Properties.VariableNames = {'bulkTstrat'};
    
        %Noise
       
        indexNoise = isbetween(noiseDT{COUNT},chunkTime{PT}(1),chunkTime{PT}(2));
        cStructure{COUNT}{PT}.noise = timetable(noiseDT{COUNT}(indexNoise),receiverData{1,COUNT}.avgNoise(indexNoise,2));
        cStructure{COUNT}{PT}.noise.Properties.VariableNames = {'noise'};
    end
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








