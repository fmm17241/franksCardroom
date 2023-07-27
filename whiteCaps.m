%Frank's testing for white caps: I want to use the data from 2014 to check
%how the physics change while the winds blow.


windsAnalysis2014

cd G:\Glider\Data\ADCP\
load GR_adcp_30minave_magrot.mat
adcp

% Cleaning data
uz = nanmean(adcp.u);
vz = nanmean(adcp.v);
xin = (uz+sqrt(-1)*vz);
[struct, xout] = t_tide(xin,'interval',adcp.dth,'start time',adcp.dn(1),'latitude',adcp.lat);
tideU = real(xout);
tideV = imag(xout);


datetide = [15,20,08,2014];

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

[timePrediction,ut,vt] = uvpred(struct.tidecon(tTideOrder,1),struct.tidecon(tTideOrder,3),struct.tidecon(tTideOrder,7),...
    struct.tidecon(tTideOrder,5),UVOrder,datetide,0.5,113.125);
%need to subtract 42...

tideDN=datenum(2014,08,020,015,00,00):0.5/24:datenum(2014,12,11,18,00,00);
tideDT=datetime(tideDN,'ConvertFrom','datenum','TimeZone','UTC')';

tidalz = [tideU;tideV].';
[coef, ~,~,~] = pca(tidalz);
theta = coef(3);


[rotUtide,rotVtide] = rot(ut,vt,theta);
tides = [tideDN'; rotUtide'; rotVtide']';

[realRotU,realRotV] = rot(uz,vz,theta);
realTides = [tideDN(2:end); realRotU; realRotV];


% figure()
% plot(tideDN,ut);
% datetick('x');


%Have to remove first value from ut/vt; our real dataset starts at 17:30 not
%17:00.
% diffU = uz-ut(2:end);
% diffV = vz-vt(2:end);

diffU = realRotU - rotUtide(2:end);
diffV = realRotV - rotVtide(2:end);


figure()
plot(tideDT(2:end),diffU);

figure()
plot(windsAverage.time(5567:8276),WSPD(5567:8276));
dynamicDateTicks()
hold on
% yValue = [0 100];
% for k = 1:length(sunset)-1
%     x = [sunset(k) sunrise(k+1)];
%     area(x,yValue,'FaceColor','k','FaceAlpha',0.2);
% end
title('Wind Speeds');
ylabel('Magnitude, m/s');

%% Adding in waveheight
cd G:\Moored\WeatherData
seas = readtable('temp2014.csv'); %IN UTC!!!!!

timeVectorsst = table2array(seas(:,1:5)); timeVectorsst(:,6) = zeros(1,length(timeVectorsst));
time = datetime(timeVectorsst,'TimeZone','UTC'); time = time + min(1/144);

seas    = table2timetable(table(time,seas.WTMP, seas.WVHT));
% seas = seas(8675:17343,:); %This is for full 2020
% seas = seas(9340:17003,:);
seas = retime(seas,'hourly','previous');

seas.Properties.VariableNames = {'SST','waveHeight'};
index99 = seas.waveHeight >50;
seas.waveHeight(index99) = NaN;


%Setting cycles for the evidence
cycleTime = tideDT(2);
cycleDuration  = duration(days(7));

% for k = 1:181 %roughly a full year of 2 day chunks
for k  = 1:16 % for 4 day chunks
% for k = 1:35 %~30 day chunks
% for k = 1:25     %15 day chunks
% for k = 1:53 %weeks
%    cycleTime(k+1) = cycleTime(k) + fixOffset;  Use this to put in :30
%    offset here, but I've changed that.
   cycleTime(k+1) = cycleTime(k) + cycleDuration;
end


limitsWind     = [min(windsU) max(windsV)];    
axWinds(1,1:4) = [0 0 -15 15];
axTides(1,1:4) = [0 0 -0.5 0.5];
limitsHeight   = [min(seas.waveHeight) max(seas.waveHeight)];

cd G:\Moored\WeatherData\weatherTesting
for k = 1:length(cycleTime)-1
% for k = 145 %Way to make a specific plot that I need
    %Creates axis for each part of the figure
   ax = [cycleTime(k) cycleTime(k+1)];
   axWinds(1,1:2) = [datenum(ax(1)) datenum(ax(2))];
%    axWinds2       = datetime(ax,'Convertfrom','datenum');
   axTides(1,1:2) = [datenum(ax(1,1)) datenum(ax(1,2))];
   axNoise(1,1:2) = [datenum(ax(1,1)) datenum(ax(1,2))];
    
    
    ff = figure()
    set(gcf, 'Position',  [30, 10, 1100, 1100])

%     nexttile([1 2])
%     plot(windsAverage.time,windsAverage.WSPD);
%     ylabel('Wind Velocity, m/s');
%     ylim([0 16])
%     xlim(ax);
%     datetick('x','keeplimits');
%     title('Wind Velocities, Gray''s Reef Buoy');
    
%     nexttile([1 2])
%     plot(seas.time,seas.waveHeight);
%     title('Wave Height, Gray''s Reef');
%     ylabel('Wave height (m)');
%     ylim(limitsHeight);
%     xlim(ax);
    
    nexttile([1 2])
    stickplot(windsDN,windsU,windsV,axWinds);
    ylabel('Wind Velocity, m/s');
    datetick('x','keeplimits');
    title('Wind Velocities, Gray''s Reef Buoy');
    
    nexttile([1 2])
    plot(tideDT,rotUtide)
    title('Rotated Tidal Predictions, U');
    ylabel('Cross-Shore Velocity');
    xlim(ax);
    ylim([-0.5 0.5]);
    datetick('x','keeplimits');
    yline(0);

    nexttile([1 2])
    plot(tideDT(2:end),realRotU)
    title('Rotated True Currents, Z-Avg');
    ylabel('Cross-Shore Velocity');
    xlim(ax);
    ylim([-0.5 0.5]);
    datetick('x','keeplimits');
    yline(0);

    nexttile([1 2])
    stickplot(tideDN(2:end),diffU,diffV,axTides);
    ylabel('Difference in V');
    ylim([-.2 .2]);
    datetick('x','keeplimits');
    title('Difference in Tidal Predictions vs Real (ADCP) Currents, Z-Averaged');
    
    exportgraphics(ff,sprintf('WeatherTesting%d.png',k))
end

%%

for k = 1:length(cycleTime)-1
% for k = 145 %Way to make a specific plot that I need
    %Creates axis for each part of the figure
   ax = [cycleTime(k) cycleTime(k+1)];
   axWinds(1,1:2) = [datenum(ax(1)) datenum(ax(2))];
%    axWinds2       = datetime(ax,'Convertfrom','datenum');
   axTides(1,1:2) = [datenum(ax(1,1)) datenum(ax(1,2))];
   axNoise(1,1:2) = [datenum(ax(1,1)) datenum(ax(1,2))];
    
    
    ff = figure()
    set(gcf, 'Position',  [30, 10, 1100, 1100])

%     nexttile([1 2])
%     plot(windsAverage.time,windsAverage.WSPD);
%     ylabel('Wind Velocity, m/s');
%     ylim([0 16])
%     xlim(ax);
%     datetick('x','keeplimits');
%     title('Wind Velocities, Gray''s Reef Buoy');
    
%     nexttile([1 2])
%     plot(seas.time,seas.waveHeight);
%     title('Wave Height, Gray''s Reef');
%     ylabel('Wave height (m)');
%     ylim(limitsHeight);
%     xlim(ax);
    
    nexttile([1 2])
    stickplot(windsDN,windsU,windsV,axWinds);
    ylabel('Wind Velocity, m/s');
    datetick('x','keeplimits');
    title('Wind Velocities, Gray''s Reef Buoy');
    
    nexttile([1 2])
    plot(tideDT,rotVtide)
    title('Rotated Tidal Predictions, V');
    ylabel('Along-Shore Velocity');
    xlim(ax);
    ylim([-0.5 0.5]);
    datetick('x','keeplimits');
    yline(0);

    nexttile([1 2])
    plot(tideDT(2:end),realRotV)
    title('Rotated True Currents, V');
    ylabel('Along-Shore Velocity');
    xlim(ax);
    ylim([-0.5 0.5]);
    datetick('x','keeplimits');
    yline(0);

    nexttile([1 2])
    stickplot(tideDN(2:end),diffU,diffV,axTides);
    ylabel('Difference in Currents vs Tides');
    ylim([-.2 .2]);
    datetick('x','keeplimits');
    title('Difference in Tidal Predictions vs Real (ADCP) Currents, Z-Averaged');
    
%     exportgraphics(ff,sprintf('WeatherTesting%d.png',k))
end

%%

cd G:\Glider\Data\2014

datadir= 'G:\Glider\Data\2014'

load receiver_reordered.mat; load glider_gr.mat;






