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
adcp.time = datetime(adcp.dn,'ConvertFrom','datenum','TimeZone','UTC')



datetide = [16,20,08,2014];
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

%Below is the one I use. Commenting out to test
[timePrediction,ut,vt] = uvpred(struct.tidecon(tTideOrder,1),struct.tidecon(tTideOrder,3),struct.tidecon(tTideOrder,7),...
    struct.tidecon(tTideOrder,5),UVOrder,datetide,1,113.1);


tideDN=datenum(2014,08,20,16,00,00):1/24:datenum(2014,12,11,18,00,00);
tideDT=datetime(tideDN,'ConvertFrom','datenum','TimeZone','UTC')';

% figure()
% plot(tideDT,ut');
% 
% figure()
% plot(ut,vt)


tidalz = [tideU;tideV].';
[coef, ~,~,~] = pca(tidalz);
theta = coef(3);


[rotUtide,rotVtide] = rot(ut,vt,theta);
tides = [rotUtide' rotVtide']';


flippedAlong = -rotVtide;
tidalThetaEvil = -coef(3);
thetaDegreeEvil = rad2deg(theta);

[correctedUT,correctedVT] = rot(rotUtide,flippedAlong,tidalThetaEvil);

%%
%Doing same rotation to original uz/vz
[rotUoriginal, rotVoriginal] = rot(uz,vz,theta)
flippedAlongOG = -rotVoriginal;

[uz,vz] = rot(rotUoriginal,flippedAlongOG,tidalThetaEvil);

