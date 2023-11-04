
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
transmitters = {'63064' '63074' '63075' '63081'};
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
datetide = [00,09,11,2019];

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
    struct.tidecon(tTideOrder,5),UVOrder,datetide,0.5,419);

%Create timing for our tidal predictions.
tideDN=datenum(2019,11,09):0.5/24:datenum(2021,1,01);
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
