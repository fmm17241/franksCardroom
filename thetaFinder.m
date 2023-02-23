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
%FM: Adding my bowties to main panel figures

% figure()
% 
% for COUNT = 1:length(parallelDT)
%     nameit= sprintf('Pairing %d Parallel(R) and Perp.(G) to Tides',COUNT)
%     nexttile
%     plot(rotUtide(COUNT,:),rotVtide(COUNT,:))
%     hold on
%     scatter(parallelU{COUNT},parallelV{COUNT},'r','filled')
%     scatter(perpendicularU{COUNT},perpendicularV{COUNT},'g','filled')
%     axis equal
%     title(nameit)
% end

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
    difference{COUNT}    = paraAverage{COUNT}-perpAverage{COUNT}
end











