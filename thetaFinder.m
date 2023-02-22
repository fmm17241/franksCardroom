%FM 2/16/23
% Trying an idea from advisors/Yargo: We have transceiver orientation as
% compared to 0N rose, done, constant. For each hour timestep, we have the
% angle at which the tides are flowing compared to 0N rose; comparing the
% two will let us know when the tides are parallel or perpendicular to the
% known transceiver angle (+/- a few degrees, TBD).


%Idea: Tide is XX degrees, Transceivers are oriented forever at YY

% thetaHourly = YY-XX
% closeNuff = thetaHourly < 5 & thetaHourly >-5

matchAngles
close all

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


figure()
plot(tideDT,ut)
hold on
scatter(parallelDT{1},parallelU{1},'r','filled')
scatter(perpendicularDT{1},perpendicularU{1})

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






