%Frank's attempt at rotating the currents to be parallel or perpendicular
%to a transceiver pairing. In 2014, this was done purposefully so cross and
%along shore are easy to separate; in 2020, it is much more challenging. So
%instead of using the major axes of the ellipses, we can compare magnitude
%in different directions to see if the relationship is clear.

%Transceiver pairings:
%FRANK SWITCHED SO POSITIVE ALWAYS FIRST
% 1.  SURTASSSTN20 hearing STSNew1
% 2.  STSNew1 hearing SURTASSSTN20
% 3.  SURTASS05In hearing FS6
% 4.  FS6 hearing SURTASS05In
% 5.  Roldan hearing 08ALTIN
% 6.  08ALTIN hearing Roldan
% 7.  SURTASS05In hearing STSNEW2
% 8.  STSNEW2 hearing SURTASS05In
% 9.  39IN hearing SURTASS05IN
% 10. SURTASS05IN hearing 39IN
% 11. STSNEW2 hearing FS6
% 12. FS6 hearing STSNew2

load mooredGPS 
% transmitters = {'63068' '63073' '63067' '63079' '63080' '63066' '63076' '63078' '63063'...
%         '63070' '63074' '63075' '63081' '63064' '63062' '63071'};
%     
% moored = {'FS17','STSNew1','33OUT','34ALTOUT','09T','Roldan',...
%           '08ALTIN','14IN','West15','08C','STSNew2','FS6','39IN','SURTASS_05IN',...
%           'SURTASS_STN20','SURTASS_FS15'}.';

%SURTASSSTN20 and STSNew1
AnglesD(1) = atan2d((mooredGPS(15,2)-mooredGPS(2,2)),(mooredGPS(15,1)-mooredGPS(2,1)));
AnglesD(2) = atan2d((mooredGPS(2,2)-mooredGPS(15,2)),(mooredGPS(2,1)-mooredGPS(15,1)));
%SURTASS05IN and FS6
AnglesD(3) = atan2d((mooredGPS(12,2)-mooredGPS(14,2)),(mooredGPS(12,1)-mooredGPS(14,1)));
AnglesD(4) = atan2d((mooredGPS(14,2)-mooredGPS(12,2)),(mooredGPS(14,1)-mooredGPS(12,1)));
%Roldan and 08ALTIN
AnglesD(5) = atan2d((mooredGPS(6,2)-mooredGPS(7,2)),(mooredGPS(6,1)-mooredGPS(7,1)));
AnglesD(6) = atan2d((mooredGPS(7,2)-mooredGPS(6,2)),(mooredGPS(7,1)-mooredGPS(6,1)));
%SURTASS05IN and STSNew2
AnglesD(7) = atan2d((mooredGPS(11,2)-mooredGPS(14,2)),(mooredGPS(11,1)-mooredGPS(14,1)));
AnglesD(8) = atan2d((mooredGPS(14,2)-mooredGPS(11,2)),(mooredGPS(14,1)-mooredGPS(11,1)));
%39IN and SURTASS05IN
AnglesD(9) = atan2d((mooredGPS(14,2)-mooredGPS(13,2)),(mooredGPS(14,1)-mooredGPS(13,1)));
AnglesD(10) = atan2d((mooredGPS(13,2)-mooredGPS(14,2)),(mooredGPS(13,1)-mooredGPS(14,1)));
%STSNEW2 and FS6
AnglesD(11) = atan2d((mooredGPS(12,2)-mooredGPS(11,2)),(mooredGPS(12,1)-mooredGPS(11,1)));
AnglesD(12) = atan2d((mooredGPS(11,2)-mooredGPS(12,2)),(mooredGPS(11,1)-mooredGPS(12,1)));

%FMFMFMFM Adding in tidal ellipses angle, 2/8/23. These are found using
% PCA coefficients in tidalAnalysis scripts.
% tideAnglesD(1) = 326.6;
% tideAnglesD(2) = 146.6;
% tideAnglesD(3) = tideAnglesD(1)-90;
% tideAnglesD(4) = tideAnglesD(2)-90;
% AnglesR = deg2rad(AnglesD);
% tideAnglesR = deg2rad(tideAnglesD);

%testing real tidal angles to fix discrepancy
%%FRANK TESTING: Adding +90 degrees to the angle measurements; this is so
%%that, when I rotate my perspective, my X axis will be source to receiver.
%%Let's try it, what do i have to lose.

tideAnglesD(1) = 123.3773;
tideAnglesD(2) = 303.3773;
tideAnglesD(3) = tideAnglesD(1)-90;
tideAnglesD(4) = tideAnglesD(2)-90;
AnglesR = deg2rad(AnglesD);
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

cd D:\Glider\Data\ADCP
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

%Classic rotation like a DJ's record
tidalz = [tideU;tideV].';
[coef, ~,~,~] = pca(tidalz);
tidalTheta = coef(3);
thetaDegree = rad2deg(tidalTheta);

% [rotUtide,rotVtide] = rot(ut,vt,tidalTheta);

%%
% Frank's second attempt: instead of creating that many sets of vectors, find and plot the angle on top of the tidal ellipses to
% more clearly show which way they're oriented; it got confusing when I started working with 12 different ellipses in addition to my original AND
% rotated tides. 

%Make values to polarplot with. Not pretty.
x = ones(1,12);
x = x+.5;
x2 = x +1;
x3 = x2 -.75;

figure()
h = polarscatter(AnglesR,x,'filled','k')

title('Transceiver Pairing, Full Array')
hold on
h = polarscatter(AnglesR(1,6),x(1),'filled','r')
for COUNT = 1:2:length(AnglesR)
    polarplot(AnglesR(1,COUNT:COUNT+1),x(1:2),'--','LineWidth',2);
end
polarplot(tideAnglesR(1:2),x2(1:2))
polarplot(tideAnglesR(3:4),x2(3:4))
polarscatter(tideAnglesR,x2(1:4),'r')
pax = gca;
pax.ThetaZeroLocation = 'top';
pax.ThetaDir = 'clockwise';


% Make rotations for each transceiver pairing
pairing = [1 1 2 2 3 3 4 4 5 5 6 6];

diff = [60 60 85.5 85.5 144.7 144.7 -6.6 -6.6 -0.2 -0.2 121.3 121.3]
% for COUNT = 1:2:length(AnglesR)
%     nameit= sprintf('Pairing %d Angle vs Tidal Ellipses, Diff: %d',pairing(COUNT),round(diff(COUNT)))
%     figure()
%     polarscatter(AnglesR(1,COUNT),x(1),280,'X')
%     hold on
%     polarplot(AnglesR(1,COUNT:COUNT+1),x(1:2),'-.');
%     polarscatter(AnglesR(1,COUNT+1),x(1),200,'square','filled','k')
%     polarplot(tideAnglesR,x2(1:2),'r')
%     polarscatter(tideAnglesR,x2(1:2),130,'r','filled')
%     pax = gca;
%     pax.ThetaZeroLocation = 'top';
%     pax.ThetaDir = 'clockwise';
%     title(nameit)
% end

%NOW need to figure out how to use these rotations and orientations
%together. Let's experiment. REMEMBER ROT() is CCWise, so adding negatives
%to both angles to make it clockwise like our compass.

%%%%%%%% FM 2/22/23
rotatorsR = deg2rad(90)+AnglesR;
% rotatorsR = -AnglesR;
%%%%%%%
rotatorsD = rad2deg(rotatorsR);


for COUNT = 1:length(rotatorsR)
    [rotUtide(COUNT,:) rotVtide(COUNT,:)] = rot(ut,vt,rotatorsR(1,COUNT));
end

%Create test vectors as 0/1
yOriginal = [0 0; 0 0.35];
xOriginal = [0 0.35;0 0];


for COUNT = 1:length(rotatorsR)
%     [rotUTide(COUNT,:),rotVTide(COUNT,:)] = rot(ut,vt,rotatorsR(COUNT));
    [rotatedXOriginalX(COUNT,:),rotatedXOriginalY(COUNT,:)] = rot(xOriginal(1,:),xOriginal(2,:),rotatorsR(COUNT));
    [rotatedYOriginalX(COUNT,:),rotatedYOriginalY(COUNT,:)] = rot(yOriginal(1,:),yOriginal(2,:),rotatorsR(COUNT));
end
% 
% 
% for COUNT = 1:length(rotatorsR)
%     [rotatedUTide(COUNT,:),rotatedVTide(COUNT,:)] = rot(ut,vt,rotatorsR(COUNT));
%     [rotated1(COUNT,:),rotated2(COUNT,:)] = rot(xOriginal(1,:),xOriginal(2,:),rotatorsR(COUNT));
%     [rotated3(COUNT,:),rotated4(COUNT,:)] = rot(yOriginal(1,:),yOriginal(2,:),rotatorsR(COUNT));
% end

% figure()
% plot(rotUtide,rotVtide)
% axis equal
% hold on
% scatter(rotated1,rotated2,'filled','r')
% plot(rotated1,rotated2,'k')
% scatter(rotated3,rotated4,'filled','k')
% plot(rotated3,rotated4,'k')
% title('Rotated Tides; Black = original Axes')




%%Combine in big tiled picture. You can do this!!!!
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


%%
%Okay, Frank has now changed the axes to be parallel and perpendicular with
%acoustic transmissions. WHAT WILL HE DO WITH THIS NEW FOUND POWER???
%

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
useThisTransceiver = 1;
alsoUseThis        = 2;
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
for PT = 1:length(chunkTime)
    % Detections, chose transceivers above
    indexDet = isbetween(hourlyDetections{useThisTransceiver}.time,...
         chunkTime{PT}(1),chunkTime{PT}(2));
    cStructure{PT}.detections = hourlyDetections{useThisTransceiver}(indexDet,:);

    % Tides for time period
    indexTide = isbetween(tideDT,chunkTime{PT}(1),chunkTime{PT}(2));
    cStructure{PT}.tides = timetable(tideDT(indexTide),rotUtide(useThisTransceiver,indexTide)',rotVtide(useThisTransceiver,indexTide)');
    cStructure{PT}.tides = cStructure{PT}.tides(1:2:end,:);
    cStructure{PT}.tides.Properties.VariableNames = {'XShore','AlongShore'}';
    
    % Winds
    indexWinds = isbetween(windsDT,chunkTime{PT}(1),chunkTime{PT}(2));
    cStructure{PT}.winds = timetable(windsDT(indexWinds),windsU(indexWinds),windsV(indexWinds),rotUwinds(indexWinds),...
        rotVwinds(indexWinds),windsAverage.WSPD(indexWinds),windsAverage.WDIR(indexWinds));
     cStructure{PT}.winds.Properties.VariableNames = {'Uwinds','Vwinds','rotUwinds','rotVwinds','windSpd','windDir'};
     cStructure{PT}.winds.windSpd(isnan(cStructure{PT}.winds.windSpd)) = 0;
    
%     % Bulk Thermal stratification
%     indexStrat = isbetween(bottom{PT}.Time,chunkTime{PT}(1),chunkTime{PT}(2));
%     cStructure{PT}.strat = timetable(bottom{PT}.Time(indexStrat),stratification{PT}(indexStrat));
%     cStructure{PT}.strat.Properties.VariableNames = {'bulkTstrat'};

    %Noise
   
    indexNoise = isbetween(noiseDT,chunkTime{PT}(1),chunkTime{PT}(2));
    cStructure{PT}.noise = timetable(noiseDT(indexNoise),receiverData{1,1}.avgNoise(indexNoise,2));
    cStructure{PT}.noise.Properties.VariableNames = {'noise'};
end











