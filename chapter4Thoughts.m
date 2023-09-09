% FM 8/2/23

%Okay. Previously did a conference paper on Beam Density Analysis (BDA):
%simple modeling of sound propagation through a water column collected by a
%glider. By design the inputs were very basic and still gave good agreement
%between measured detection efficiency and the number of beam arrivals that
%each distance saw.

% surfacings.m is running into some issues with how it reads in the data,
% going to move past that for now.


cd ([oneDrive,'Glider\Transform\R\'])






figure()
bellhop('test15R');
plotray('test15R');
% xlim([0 1500]);
figure()
plotshd('test15R.shd')


figure()
plotssp('test15R','r');


figure()
bellhop('test21R');
plotray('test21R');
xlim([0 1500]);



figure()
bellhop('test7R');
plotray('test7R');

figure()
plotssp('test7R','r');


%Alright, bellhop still works, feel good about that. Now I need to figure
%out how best to create/replicate scenarios to look at the processes from
%conference paper.

%Original: April versus November, Stratified versus unstratified

%NOW: Tidal, daily, synoptic, seasonal?

% How to show Tidal: tough, I found that currents were the biggest factor
% in detection efficiency, not changing pycnocline or thermoclines. Maybe
% boundary layers?

% How to show Daily: diurnal differences in noise levels, need to bring in
% transmission loss or something. Have not done anything like that, just
% had propagation until it hit a boundary layer at certain angles of
% incidence.

%How to show synoptic: fun part. Winds changed stratification and
%waveheight, but also noise dropped intensely. Need to figure out how to
%bring in noise

% Seasonal: Easy. We've done this, but need to flesh it out.

cd ('C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AcTUP\')
actup



%FM 8/7/23 19:43 testing

% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\bellhopTesting'
cd ([oneDrive,'bellhopTesting'])


bellhop('guiTest')              %Testing, 6900 Hz frequency
figure()
plotshd('guiTest.shd')

%
bellhop('guiTestHF')            %High frequency, 69 kHz signal
figure()
plotshd('guiTestHF.shd')        %Looking better and better!!!!

bellhop('uniform')            
figure()
plotshd('uniform.shd') 

bellhop('uniformTest')            
figure()
plotshd('uniformTest.shd') 



figure()
bellhop('twoD')
figure()
plotssp2d 'twoD'

figure()
plotbty 'twoD'
ylim([0 5500])


%%
% Dead meat, can't think or do the work. 

WUWEfficiency
binnedAVG

%Find distance between lat/lons, lets go, I need this in my life


lldistkm(mooredGPS(1,1:2),mooredGPS(2,1:2))


lldistkm(mooredGPS(13,1:2),mooredGPS(14,1:2))


% lat = [33.47914 33.47914 33.47915 33.47917]; 
% lon = [-88.7943 -88.7943 -88.7943 -88.7943]; 
lat = mooredGPS(:,1);
lon = mooredGPS(:,2);
% Use WGS84 ellipsoid model
wgs84 = wgs84Ellipsoid; 
% Calculate individual distances 
d1 = distance(lat(1),lon(1),lat(2),lon(2),wgs84); 
d2 = distance(lat(2),lon(2),lat(3),lon(3),wgs84); 
d3 = distance(lat(3),lon(3),lat(4),lon(4),wgs84); 















