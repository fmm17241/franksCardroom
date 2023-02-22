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
%FM: Trying to add my bowties to main panel figures




for COUNT = 1:2:length(AnglesR)
    nameit= sprintf('Pairing %d Angle vs Tidal Ellipses',pairing(COUNT))
    
    figure()
    set(gcf, 'Position',  [0, 0, 1000, 1000])

    tiledlayout(2,2)
    nexttile
    polarscatter(AnglesR(1,COUNT),x(1),280,'X')
    hold on
    polarplot(AnglesR(1,COUNT:COUNT+1),x(1:2),'-.');
    polarscatter(AnglesR(1,COUNT+1),x(1),200,'square','filled','k')
    polarplot(tideAnglesR(1:2),x2(1:2),'r')
    polarplot(tideAnglesR(3:4),x3(1:2),'r')
    polarscatter(tideAnglesR(1:2),x2(1:2),130,'r','filled')
    polarscatter(tideAnglesR(3:4),x3(1:2),'r','filled')
    pax = gca;
    pax.ThetaZeroLocation = 'top';
    pax.ThetaDir = 'clockwise';
    title(nameit)
    
    nexttile
    plot(ut,vt)
    hold on
    scatter(ut(15393),vt(15393),'filled','r')
    scatter(ut(15430),vt(15430),'filled','k')
    title('OG')
    xline(0)
    yline(0)
    axis equal

    nexttile
    plot(rotUtide(COUNT+1,:),rotVtide(COUNT+1,:))
    hold on
    scatter(rotUtide(COUNT+1,15393),rotVtide(COUNT+1,15393),'filled','r')
    scatter(rotUtide(COUNT+1,15430),rotVtide(COUNT+1,15430),'filled','k')
    xline(0)
    yline(0)
%     title(sprintf('Should be %0.1f CCW',rotatorsD(1,COUNT+1)))
    title('X Axis: Square to X +')
    axis equal
    
    nexttile
    plot(rotUtide(COUNT,:),rotVtide(COUNT,:))
    hold on
    scatter(rotUtide(COUNT,15393),rotVtide(COUNT,15393),'filled','r')
    scatter(rotUtide(COUNT,15430),rotVtide(COUNT,15430),'filled','k')
%     plot(rotated1(COUNT,:),rotated2(COUNT,:),'k')
%     plot(rotated3(COUNT,:),rotated4(COUNT,:),'k')
%     scatter(rotated1(COUNT,:),rotated2(COUNT,:),'r','filled')
%     scatter(rotated3(COUNT,:),rotated4(COUNT,:),'k','filled')
    xline(0)
    yline(0)
%     title(sprintf('Should be %0.1f CCW',rotatorsD(1,COUNT)))
    title('X Axis: X to Square +')
    axis equal

end







