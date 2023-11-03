
%Frank's attempt at rotating the currents to be parallel or perpendicular
%to a transceiver pairing. In 2014, this was done purposefully so cross and
%along shore are easy to separate; in 2020, it is much more challenging. So
%instead of using the major axes of the ellipses, we can compare magnitude
%in different directions to see if the relationship is clear.

%Transceiver pairings:
% 1.  FS6 hearing SURTASS05In
% 2.  SURTASS05In hearing FS6
% 3.  STSNEW2 hearing SURTASS05In
% 4.  SURTASS05In hearing STSNEW2
% 5.  SURTASS05IN hearing 39IN
% 6.  39IN hearing SURTASS05IN
% 7.  39IN hearing FS6
% 8.  FS6 hearing 39IN
% 9.  STSNEW2 hearing FS6
% 10. FS6 hearing STSNew2

load mooredGPS 
transmitters = {'63074' '63075' '63081' '63064'};
%     
% moored = {'STSNew2','FS6','39IN','SURTASS_05IN'}.';

%testing real tidal angles to fix discrepancy
%%FRANK TESTING: Adding +90 degrees to the angle measurements; this is so
%%that, when I rotate my perspective, my X axis will be source to receiver.
%%Let's try it, what do i have to lose.

tideAnglesD(1) = 123.3773;
tideAnglesD(2) = 303.3773;
tideAnglesD(3) = tideAnglesD(1)-90;
tideAnglesD(4) = tideAnglesD(2)-90;
% AnglesR = deg2rad(AnglesD);
tideAnglesR = deg2rad(tideAnglesD);


%% Original
% tideAnglesD(1) = 123.3773;
% tideAnglesD(2) = 303.3773;
% tideAnglesD(3) = tideAnglesD(1)-90;
% tideAnglesD(4) = tideAnglesD(2)-90;
% AnglesR = deg2rad(AnglesD);
% tideAnglesR = deg2rad(tideAnglesD);

%%
%Okay: How do I use that information?

% Instead of rotating the tidal currents by the major axes found through
% pca, lets rotate the vectors by these values. That gives a parallel and
% perpendicular current for each pairing.


% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\ADCP'
cd ([oneDrive,'ADCP'])

load GR_adcp_30minave_magrot.mat;
% Cleaning data
uz = nanmean(adcp.u);
vz = nanmean(adcp.v);
xin = (uz+sqrt(-1)*vz);
[struct, xout] = t_tide(xin,'interval',adcp.dth,'start time',adcp.dn(1),'latitude',adcp.lat);
%Separate tidal output into vectors
tideU = real(xout);
tideV = imag(xout);

%Sets timing
datetide = [00,00,01,2020];

%t_tide order of constituents:
% 15 = M2, Lunar semidiurnal
% 17 = S2, Solar semidiurnal
% 14 = N2, Lunar elliptical, perigee
% 8 = K1,  Lunar diurnal
% 6 = O1,  Lunar Diurnal
% 5 = Q1,  Larger lunar elliptical diurnal
tTideOrder = [15,17,14,8,6,5]; % Full tides for consideration
% tTideOrder = [14]; %Isolating certain tides.


% uvpred order of constituents: 
% 1 = M2, 2 = S2, 3 = N2, 4 = K1, 6 = O1, 26 = Q1
UVOrder    = [1,2,3,4,6,26];% Full tides for consideration
% UVOrder    = [3]; %Isolating certain tides.
%Predict tides for our location
[timePrediction,ut,vt] = uvpred(struct.tidecon(tTideOrder,1),struct.tidecon(tTideOrder,3),struct.tidecon(tTideOrder,7),...
    struct.tidecon(tTideOrder,5),UVOrder,datetide,0.5,366);

%Create timing for our tidal predictions.
tideDN=datenum(2020,1,01):0.5/24:datenum(2021,1,01);
tideDT=datetime(tideDN,'ConvertFrom','datenum','TimeZone','UTC')';

%Results: ut and vt are the tides for the timing tideDT
%%

% Here's where it gets interesting: below is the way I rotate my tides
% normally, I find the major axes using Principle Component Analysis and
% rotate my axes to better fit the ellipses.


%%


%%
%Classic rotation like a DJ's record
tidalz = [tideU;tideV].';
[coef, ~,~,~] = pca(tidalz);
tidalTheta = coef(3);
thetaDegree = rad2deg(tidalTheta);

[rotUtideShore,rotVtideShore] = rot(ut,vt,tidalTheta);

%%
%HERE'S FM'S NEW ROTATIONS
%FRANK needs to take ut and vt, and rotate it once to x/alongshore, flip
%it, then rotate it back.
flippedAlong = -rotVtideShore;
tidalThetaEvil = -coef(3);
thetaDegreeEvil = rad2deg(tidalTheta);

[ut,vt] = rot(rotUtideShore,flippedAlong,tidalThetaEvil);
%%

%%
% Frank's second attempt: instead of creating that many sets of vectors, find and plot the angle on top of the tidal ellipses to
% more clearly show which way they're oriented; it got confusing when I started working with 12 different ellipses in addition to my original AND
% rotated tides. 

% %Make values to polarplot with. Not pretty.
% x = ones(1,10);
% x = x+.5;
% x2 = x +1;
% x3 = x2 -.75;
% 
% figure()
% h = polarscatter(AnglesR,x,'filled','k')
% 
% title('Transceiver Pairing, Full Array')
% hold on
% h = polarscatter(AnglesR(1,6),x(1),'filled','r')
% for COUNT = 1:2:length(AnglesR)
%     polarplot(AnglesR(1,COUNT:COUNT+1),x(1:2),'--','LineWidth',2);
% end
% polarplot(tideAnglesR(1:2),x2(1:2))
% polarplot(tideAnglesR(3:4),x2(3:4))
% polarscatter(tideAnglesR,x2(1:4),'r')
% pax = gca;
% pax.ThetaZeroLocation = 'top';
% pax.ThetaDir = 'clockwise';


% Make rotations for each transceiver pairing
% pairing = [1 1 2 2 3 3 4 4 5 5];
% % for COUNT = 1:2:length(AnglesR)
% %     nameit= sprintf('Pairing %d Angle vs Tidal Ellipses, Diff: %d',pairing(COUNT),round(diff(COUNT)))
% %     figure()
% %     polarscatter(AnglesR(1,COUNT),x(1),280,'X')
% %     hold on
% %     polarplot(AnglesR(1,COUNT:COUNT+1),x(1:2),'-.');
% %     polarscatter(AnglesR(1,COUNT+1),x(1),200,'square','filled','k')
% %     polarplot(tideAnglesR,x2(1:2),'r')
% %     polarscatter(tideAnglesR,x2(1:2),130,'r','filled')
% %     pax = gca;
% %     pax.ThetaZeroLocation = 'top';
% %     pax.ThetaDir = 'clockwise';
% %     title(nameit)
% % end
% 
% %NOW need to figure out how to use these rotations and orientations
% %together. Let's experiment. REMEMBER ROT() is CCWise, so adding negatives
% %to both angles to make it clockwise like our compass.
% 
% %%%%%%%% FM 2/22/23
% rotatorsR = deg2rad(90)+AnglesR;
% % rotatorsR = -AnglesR;
% %%%%%%%
% rotatorsD = rad2deg(rotatorsR);
% 
% 
% for COUNT = 1:length(rotatorsR)
%     [rotUtide(COUNT,:) rotVtide(COUNT,:)] = rot(ut,vt,rotatorsR(1,COUNT));
% end
% 
% %Create test vectors as 0/1
% yOriginal = [0 0; 0 0.35];
% xOriginal = [0 0.35;0 0];
% 
% 
% for COUNT = 1:length(rotatorsR)
% %     [rotUTide(COUNT,:),rotVTide(COUNT,:)] = rot(ut,vt,rotatorsR(COUNT));
%     [rotatedXOriginalX(COUNT,:),rotatedXOriginalY(COUNT,:)] = rot(xOriginal(1,:),xOriginal(2,:),rotatorsR(COUNT));
%     [rotatedYOriginalX(COUNT,:),rotatedYOriginalY(COUNT,:)] = rot(yOriginal(1,:),yOriginal(2,:),rotatorsR(COUNT));
% end
% % 
% % 
% % for COUNT = 1:length(rotatorsR)
% %     [rotatedUTide(COUNT,:),rotatedVTide(COUNT,:)] = rot(ut,vt,rotatorsR(COUNT));
% %     [rotated1(COUNT,:),rotated2(COUNT,:)] = rot(xOriginal(1,:),xOriginal(2,:),rotatorsR(COUNT));
% %     [rotated3(COUNT,:),rotated4(COUNT,:)] = rot(yOriginal(1,:),yOriginal(2,:),rotatorsR(COUNT));
% % end
% 
% % figure()
% % plot(rotUtide,rotVtide)
% % axis equal
% % hold on
% % scatter(rotated1,rotated2,'filled','r')
% % plot(rotated1,rotated2,'k')
% % scatter(rotated3,rotated4,'filled','k')
% % plot(rotated3,rotated4,'k')
% % title('Rotated Tides; Black = original Axes')
% 
% 
% 
% % cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\exportedFigures'
% 
% 
% 
% for COUNT = 1:2:length(AnglesR)
%     nameit= sprintf('Pairing %d Angle vs Tidal Ellipses',pairing(COUNT))
%     
%     figure()
%     set(gcf, 'Position',  [0, 0, 1000, 1000])
%     polarscatter(AnglesR(1,COUNT),x(1),280,'X')
%     hold on
%     polarplot(AnglesR(1,COUNT:COUNT+1),x(1:2),'-.');
%     polarscatter(AnglesR(1,COUNT+1),x(1),200,'square','filled','k')
%     polarplot(tideAnglesR(1:2),x2(1:2),'r')
%     polarplot(tideAnglesR(3:4),x3(1:2),'r')
%     polarscatter(tideAnglesR(1:2),x2(1:2),130,'r','filled')
%     polarscatter(tideAnglesR(3:4),x3(1:2),'r','filled')
%     pax = gca;
%     pax.ThetaZeroLocation = 'top';
%     pax.ThetaDir = 'clockwise';
%     title(nameit)
% end
% 
% cd ([localPlots])
% 
% 
% %%Combine in big tiled picture. You can do this!!!!
% for COUNT = 1:2:length(AnglesR)
%     nameit= sprintf('Pairing %d Angle vs Tidal Ellipses',pairing(COUNT))
%     
%     figure()
%     set(gcf, 'Position',  [0, 0, 1000, 1000])
% 
%     tiledlayout(2,2)
%     nexttile
%     polarscatter(AnglesR(1,COUNT),x(1),280,'X')
%     hold on
%     polarplot(AnglesR(1,COUNT:COUNT+1),x(1:2),'-.');
%     polarscatter(AnglesR(1,COUNT+1),x(1),200,'square','filled','k')
%     polarplot(tideAnglesR(1:2),x2(1:2),'r')
%     polarplot(tideAnglesR(3:4),x3(1:2),'r')
%     polarscatter(tideAnglesR(1:2),x2(1:2),130,'r','filled')
%     polarscatter(tideAnglesR(3:4),x3(1:2),'r','filled')
%     pax = gca;
%     pax.ThetaZeroLocation = 'top';
%     pax.ThetaDir = 'clockwise';
%     title(nameit)
%     
%     nexttile
%     plot(ut,vt)
%     hold on
%     scatter(ut(15393),vt(15393),'filled','r')
%     scatter(ut(15430),vt(15430),'filled','k')
%     title('OG')
%     xline(0)
%     yline(0)
%     axis equal
% 
%     nexttile
%     plot(rotUtide(COUNT+1,:),rotVtide(COUNT+1,:))
%     hold on
%     scatter(rotUtide(COUNT+1,15393),rotVtide(COUNT+1,15393),'filled','r')
%     scatter(rotUtide(COUNT+1,15430),rotVtide(COUNT+1,15430),'filled','k')
%     xline(0)
%     yline(0)
% %     title(sprintf('Should be %0.1f CCW',rotatorsD(1,COUNT+1)))
%     title('X Axis: Square to X +')
%     axis equal
%     
%     nexttile
%     plot(rotUtide(COUNT,:),rotVtide(COUNT,:))
%     hold on
%     scatter(rotUtide(COUNT,15393),rotVtide(COUNT,15393),'filled','r')
%     scatter(rotUtide(COUNT,15430),rotVtide(COUNT,15430),'filled','k')
% %     plot(rotated1(COUNT,:),rotated2(COUNT,:),'k')
% %     plot(rotated3(COUNT,:),rotated4(COUNT,:),'k')
% %     scatter(rotated1(COUNT,:),rotated2(COUNT,:),'r','filled')
% %     scatter(rotated3(COUNT,:),rotated4(COUNT,:),'k','filled')
%     xline(0)
%     yline(0)
% %     title(sprintf('Should be %0.1f CCW',rotatorsD(1,COUNT)))
%     title('X Axis: X to Square +')
%     axis equal
% %     exportgraphics(gcf,sprintf('AnglesTides%d.png',COUNT),'Resolution',300)
% end
% 
% 
% %%
% %Okay, Frank has now changed the axes to be parallel and perpendicular with
% %acoustic transmissions. WHAT WILL HE DO WITH THIS NEW FOUND POWER???
% %
% % close all
% 
% figure()
% plot(ut,vt)
% axis equal
% hold on
% scatter(ut(5:10),vt(5:10),'r','filled')
% scatter(ut(11:15),vt(11:15),'y','filled')
% scatter(ut(16:20),vt(16:20),'k','filled')
% 
% % Points are going clockwise instead of counterclockwise, ooops.
% figure()
% plot(rotUtideShore,rotVtideShore)
% axis equal
% hold on
% title('Shore Rotated')
% scatter(rotUtideShore(5:10),rotVtideShore(5:10),'filled')
% scatter(rotUtideShore(11:15),rotVtideShore(11:15),'y','filled')
% scatter(rotUtideShore(16:20),rotVtideShore(16:20),'k','filled')
% 
% %Testing flip
% figure()
% plot(rotUtideShore,-rotVtideShore)
% axis equal
% hold on
% title('Flip')
% scatter(rotUtideShore(5:10),-rotVtideShore(5:10),'filled')
% 
% flippedAlong = -rotVtideShore;
% 
% figure()
% plot(rotUtideShore,flippedAlong)
% axis equal
% hold on
% title('Flip')
% scatter(rotUtideShore(5:10),flippedAlong(5:10),'filled')
% scatter(rotUtideShore(11:15),flippedAlong(11:15),'k','filled')
% 
% 
% %FM's attempt at rotating back the other way now that I've mirrored over
% %the X axis.
% flippedAlong = -rotVtideShore;
% tidalz = [tideU;tideV].';
% [coef, ~,~,~] = pca(tidalz);
% tidalThetaEvil = -coef(3);
% thetaDegreeEvil = rad2deg(tidalTheta);
% 
% [rotUtideShoreEvil,rotVtideShoreEvil] = rot(rotUtideShore,flippedAlong,tidalThetaEvil);
% 
% figure()
% plot(rotUtideShoreEvil,rotVtideShoreEvil)
% axis equal
% hold on
% title('Evil')
% scatter(rotUtideShoreEvil(5:10),rotVtideShoreEvil(5:10),'r','filled')
% scatter(rotUtideShoreEvil(11:15),rotVtideShoreEvil(11:15),'y','filled')
% scatter(rotUtideShoreEvil(16:20),rotVtideShoreEvil(16:20),'k','filled')
% 
% %%
% 
% % uzRot = nanmean(adcp.uc);
% % vzRot = nanmean(adcp.ua);
% % 
% % uzRaw = nanmean(adcp.u);
% % vzRaw = nanmean(adcp.v);
% % 
% % figure()
% % plot(uzRaw,vzRaw);
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
