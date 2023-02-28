%FM 2/16/23
% Trying an idea from advisors/Yargo: We have transceiver orientation as
% compared to 0N rose, done, constant. For each hour timestep, we have the
% angle at which the tides are flowing compared to 0N rose; comparing the
% two will let us know when the tides are parallel or perpendicular to the
% known transceiver angle (+/- a few degrees, TBD).

%rotUtide/rotVtide (1-12,:)
matchAngles
close all

%Gives hourlyDetections {1-12}
mooredEfficiency

%%
%Isolating when transceivers were deployed
fullTime = [datetime(2020,01,29,17,00,00),datetime(2020,12,10,13,00,00)];
fullTime.TimeZone = 'UTC';

fullTideIndex = isbetween(tideDT,fullTime(1,1),fullTime(1,2),'closed');

tideDT = tideDT(fullTideIndex);
tideDT = tideDT(:,1:2:end);
rotUtide = rotUtide(:,fullTideIndex);
rotUtide = rotUtide(:,1:2:end);
rotVtide = rotVtide(:,fullTideIndex);
rotVtide = rotVtide(:,1:2:end);
%%


tideAnglesD(1) = 303.3761;
tideAnglesD(2) = 123.3761;
tideAnglesD(3) = tideAnglesD(1)-90;
tideAnglesD(4) = tideAnglesD(2)-90;

% figure()
% plot(ut,vt)
% title('Original tides')

%Frank is finding angle of tides compared to 0.
hourlyAngle = atan2d(rotVtide,rotUtide);
hourlyAngleR = deg2rad(hourlyAngle);

%FM: Can change this number to change the length/width of the fan
% Parallel:
thetaIndex{1} = hourlyAngle > -10 & hourlyAngle < 10| hourlyAngle > 170 | hourlyAngle <-170;

%Perpendicular:
thetaIndex{2} = hourlyAngle < -80 & hourlyAngle > -100 | hourlyAngle > 80 & hourlyAngle < 100;



for COUNT = 1:height(hourlyAngle)
    parallelDT{COUNT}           = tideDT(thetaIndex{1}(COUNT,:));
    parallelU{COUNT}            = rotUtide(COUNT,thetaIndex{1}(COUNT,:));
    parallelV{COUNT}            =  rotVtide(COUNT,thetaIndex{1}(COUNT,:));

    perpendicularDT{COUNT}      = tideDT(thetaIndex{2}(COUNT,:));
    perpendicularU{COUNT}       = rotUtide(COUNT,thetaIndex{2}(COUNT,:));
    perpendicularV{COUNT}       =  rotVtide(COUNT,thetaIndex{2}(COUNT,:));
end


% figure()
% plot(tideDT,ut)
% hold on
% scatter(parallelDT{1},parallelU{1},'r','filled')
% scatter(perpendicularDT{1},perpendicularU{1})

for COUNT = 1:length(parallelDT)
    nameit= sprintf('Pairing %d Parallel(R) and Perp.(G) to Tides',COUNT)
    figure()
    plot(rotUtide(COUNT,:),rotVtide(COUNT,:))
    hold on
    scatter(parallelU{COUNT},parallelV{COUNT},'r','filled')
    scatter(perpendicularU{COUNT},perpendicularV{COUNT},'g','filled')
    axis equal
    title(nameit)
end

%% 
%Frank's adding in detections for each transceiver pair, cause he's
%fantastic at this. 

for COUNT = 1:length(hourlyDetections)
    fullDetsIndex{COUNT} = isbetween(hourlyDetections{COUNT}.time,fullTime(1,1),fullTime(1,2),'closed');
end

clearvars detections time

for COUNT = 1:length(fullDetsIndex)
    detTimes{COUNT}   = [hourlyDetections{COUNT}.time(fullDetsIndex{COUNT})];
    detections{COUNT} = [hourlyDetections{COUNT}.detections(fullDetsIndex{COUNT})];
end
%%
%Frank needs to use the indices above, perp and parallel, to compare the
%two directions


for COUNT = 1:10
    
    parallel{COUNT}      = detections{1,COUNT}(thetaIndex{1}(COUNT,:));
    perpendicular{COUNT} = detections{1,COUNT}(thetaIndex{2}(COUNT,:));
    paraAverage{COUNT}   = mean(parallel{COUNT});
    perpAverage{COUNT}   = mean(perpendicular{COUNT});
    countDiff{COUNT}     = [length(parallel{COUNT}), length(perpendicular{COUNT})]
    difference{COUNT}    = paraAverage{COUNT}-perpAverage{COUNT}
end



%%
Damnit Frank

% for COUNT = 1:length(rotatorsD)
%     figure()
%     nexttile
%     plot(tideDT,rotUtide)
%     title('Cross-shore tide 2020')
%     nexttile
%     plot(tideDT,rotUtide(COUNT,:));
%     title(sprintf('%d rotation, X',COUNT))
%     ylabel('Velocity')
%     nexttile
%     plot(tideDT,rotVtide(COUNT,:))
%     title(sprintf('%d rotation, Y',COUNT))
% end
close all
%Detections with one transceiver pair, ~0.53 km. Uses
%hourlyDetections{X}.time/detections
mooredEfficiency

%Thermal stratification between transceiver temperature measurements and
%NOAA buoy SST measurements. Uses bottom.bottomTime, buoyStratification,
%bottom.tilt, and leftovers (disconnected pings, measure of transmission
%failure)
sstAnalysis2020

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
cycleDuration  = duration(days(4));


%old
% fixOffset = 0.5*cycleDuration;

% startCycle = startCyclePre - fixOffset
startCycle = startCyclePre

cycleTime = startCycle;
% for k = 1:181 %roughly a full year of 2 day chunks
for k  = 1:95 % for 4 day chunks
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
%I'm replacing this when I added the rotated tides
% useThisTransceiver = 1;
% alsoUseThis        = 2;
noiseDT = datetime(receiverData{1,1}.avgNoise(:,1),'convertfrom','datenum');
noiseDT.TimeZone = 'UTC';

chunkTime = cell(1,length(cycleTime2)-1);

for P = 1:length(chunkTime)
    currentChunk1 = cycleTime2(P);
    currentChunk2 = cycleTime2(P+1);
    chunkTime{P}  = [currentChunk1,currentChunk2];
end
%%
%Currently this shows chunks of time and has the values for characteristics
%at those times. Compared to detections, might tell us something.
%Frank has to make tides ALSO a loop I guess?
Frank needs to fix "sstAnalysis2020" so I can bring each transceiver's noise and tilt data in.

for COUNT = 1:2:height(rotUtide)
    for PT = 1:length(chunkTime)
        % Detections, chose transceivers above
        indexDet = isbetween(hourlyDetections{COUNT}.time,...
             chunkTime{PT}(1),chunkTime{PT}(2));
        cStructure{COUNT}{PT}.detections = hourlyDetections{COUNT}(indexDet,:);
    
        % Tides for time period
        indexTide = isbetween(tideDT,chunkTime{PT}(1),chunkTime{PT}(2));
        cStructure{COUNT}{PT}.tides = timetable(tideDT(indexTide),rotUtide(COUNT,indexTide)',rotVtide(COUNT,indexTide)');
        cStructure{COUNT}{PT}.tides = cStructure{COUNT}{PT}.tides(1:2:end,:);
        cStructure{COUNT}{PT}.tides.Properties.VariableNames = {'Parallel','Perpendicular'}';
        
        % Winds
        indexWinds = isbetween(windsDT,chunkTime{PT}(1),chunkTime{PT}(2));
        cStructure{COUNT}{PT}.winds = timetable(windsDT(indexWinds),windsU(indexWinds),windsV(indexWinds),rotUwinds(indexWinds),...
            rotVwinds(indexWinds),windsAverage.WSPD(indexWinds),windsAverage.WDIR(indexWinds));
         cStructure{COUNT}{PT}.winds.Properties.VariableNames = {'Uwinds','Vwinds','rotUwinds','rotVwinds','windSpd','windDir'};
         cStructure{COUNT}{PT}.winds.windSpd(isnan(cStructure{COUNT}{PT}.winds.windSpd)) = 0;
        
    %     % Bulk Thermal stratification
    %     indexStrat = isbetween(bottom{PT}.Time,chunkTime{PT}(1),chunkTime{PT}(2));
    %     cStructure{PT}.strat = timetable(bottom{PT}.Time(indexStrat),stratification{PT}(indexStrat));
    %     cStructure{PT}.strat.Properties.VariableNames = {'bulkTstrat'};
    
        %Noise
       
        indexNoise = isbetween(noiseDT,chunkTime{PT}(1),chunkTime{PT}(2));
        cStructure{COUNT}{PT}.noise = timetable(noiseDT(indexNoise),receiverData{1,1}.avgNoise(indexNoise,2));
        cStructure{COUNT}{PT}.noise.Properties.VariableNames = {'noise'};
    end

end








