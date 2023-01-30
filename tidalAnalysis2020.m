% load the data
% cd G:\Glider\Data\ADCP\
cd D:\Glider\Data\ADCP

load GR_adcp_30minave_magrot.mat
adcp

% Cleaning data
uz = nanmean(adcp.u);
vz = nanmean(adcp.v);
xin = (uz+sqrt(-1)*vz);

%Checking: clear semidiurnal signal in 2014 tidal data, as expected
figure()
plot(adcp.dn,uz);
% dynamicDateTicks();

%t_tide, separating currents into constituents
[struct, xout] = t_tide(xin,'interval',adcp.dth,'start time',adcp.dn(1),'latitude',adcp.lat);


%Separate tides into vectors
tideU = real(xout);
tideV = imag(xout);

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


% [time,ut,vt] = uvpred(struct.tidecon(constituents,1),struct.tidecon(constituents,3),struct.tidecon(constituents,7),...
%     struct.tidecon(constituents,5),constituents,datetide,0.5,366);

%Below is the one I use. Commenting out to test
[timePrediction,ut,vt] = uvpred(struct.tidecon(tTideOrder,1),struct.tidecon(tTideOrder,3),struct.tidecon(tTideOrder,7),...
    struct.tidecon(tTideOrder,5),UVOrder,datetide,0.5,366);




tideDN=datenum(2020,1,01):0.5/24:datenum(2021,1,01);
tideDT=datetime(tideDN,'ConvertFrom','datenum','TimeZone','UTC')';



% figure()
% plot(dtnew,ut);
% dynamicDateTicks();
% 
% figure()
% plot(dtnew,vt);
% dynamicDateTicks();


% dnnew=(datenum(2020,4,22):0.5/24:datenum(2020,5,15));
% dtnew = datetime(dnnew,'ConvertFrom','datenum');

% dtnew.TimeZone='EST';


tidalz = [tideU;tideV].';
[coef, ~,~,~] = pca(tidalz);
theta = coef(3);


[rotUtide,rotVtide] = rot(ut,vt,theta);
tides = [tideDN'; rotUtide'; rotVtide']';
% writematrix(tides,'tidals.csv')
figure()
plot(tideU,tideV);
title('ADCP Tides')

figure()
plot(ut,vt)
axis equal
title('Tides, Entire 2020')



figure()
plot(ut,vt);



figure()
plot(rotUtide,rotVtide)
title('Rotated Tidal Predictions, 2020 Mission');
axis equal
xlabel('Cross-Shore Velocity, m/s')
ylabel('Along-Shore Velocity, m/s')


figure()
plot(tideDN',rotUtide','LineWidth',2);
datetick('x','keeplimits');
title('Tidal Magnitude, Rotated, X-Shore');
ylabel('Cross-Shore Velocity');

figure()
plot(tideDN',rotUtide','LineWidth',2);
datetick('x');
title('Tidal Magnitude, Rotated, X-Shore');
ylabel('Cross-Shore Velocity');



% 
% cutoff = (1/144000);     %40 hours
% cutoff   = (1/259200); % 3 days
% cutoff = (1/345600)    % 4 days
% cutoff = (1/432000)      % 5 days

%Sampling rate
% fs     = (1/3600);
% Wn = cutoff/(0.5*fs);
% [B,A] = butter(5,Wn,'low');
% tideVx = filtfilt(B,A,rotUtide);
% tideVy = filtfilt(B,A,rotVtide);
% 
% figure()
% plot(tideVx,tideVy);
% 
% 
% figure()
% ax = [[737903.020833333] [737906.041666667] -0.4 0.4];
% stickplot(tideDN,ut,vt,ax);
% datetick('x','KeepLimits');
% xlabel('Time');
% ylabel('Current Magnitude,m/s');
% title('Tidal Currents');
% 
% 
% [ebbindex,floodindex,floodtime,floodpoints,floodDT,ebbDT,ebbtime,ebbpoints,tidalrange,tidalduration,highTide,lowTide,crosspoints] = findebbflood(tideDN,rotUtide);
% 
% 
% figure()
% plot(tideDT,rotUtide,'k','LineWidth',2);
% yline(0);
% dynamicDateTicks();
% hold on
% scatter(tideDT(floodindex),rotUtide(floodindex),'r*');
% scatter(tideDT(ebbindex),rotUtide(ebbindex),'b*');
% % hold off
% title('Max Flood Velocities(-) and Max Ebb Velocities(+), GR 2020');
% ylabel('Velocity (m/s)');

%This date "startSN" is later than it looks on the graph; not sure why.
%Originally picked 117; 168 gives a more accurate line for our graph for
%now.





% Spring= datenum(2020,01,01,00,00,00):datenum(days(14.27)):datenum(2020,12,31,00,00,00)
% y2 = zeros(1,length(Spring));
% 
% scatter(Spring,y2,400,'g','filled');
% 
% 
% perigee= datenum(2020,01,13,15,22,00):datenum(days(27.5)):datenum(2020,12,31,00,00,00)
% y3 = zeros(1,length(perigee));
% 
% scatter(perigee,y3,250,'b','filled');

% 
% figure()
% yyaxis left
% plot(tideDN,rotUtide,'k','LineWidth',2);
% yline(0);
% dynamicDateTicks();
% hold on
% scatter(tideDN(floodindex),rotUtide(floodindex),'r*');
% scatter(tideDN(ebbindex),rotUtide(ebbindex),'b*');
% yyaxis right 
% plot(ebbtime,tidalrange,'LineWidth',5);
% 
% figure()
% plot(ebbtime,tidalrange,'LineWidth',5);
% dynamicDateTicks();
% title('Tidal Velocity Range, Abs Value');
% ylabel('Sum of Velocity, m/s');
% 
% figure()
% scatter(ebbtime,tidalduration');
% dynamicDateTicks()



