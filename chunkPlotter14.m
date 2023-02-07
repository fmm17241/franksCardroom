
%Use chunkAnalyzer, then use this to plot the transceivers you want. Below
%are the transceivers that can be used at Gray's Reef:

% 1 SURTASSTN20    63062
% 2 SURTASS_05IN   63064
% 3 Roldan         63066
% 4 33OUT          63067 * none heard
% 5 FS17           63068  *none heard
% 6 08C            63070
% 7 STSNew1        63073
% 8 STSNew2        63074
% 9 FS6            63075
% 10 08ALTIN       63076
% 11 34ALTOUT      63079
% 12 09T           63080
% 13 39IN          63081

%% 
% List the pairings used for this analysis. All plots will show the relationships of the
% first listed vs the second, then vice versa. So in example, first
% pairing, first row will be SURTASSSTN20 vs STSNew1, and the second row
% will be STSNew1 vs SURTASSSTN20.

%Pairing 1: SURTASSSTN20(63062) and STSNew1(63073), index 1 and 2
%Pairing 2: SURTASS05IN(63064) and FS6(63075), index 3 and 4
%Pairing 3: Roldan (63066) and 08ALTIN (63076), index 5 and 6
%Pairing 4: 34ALTOUT (63079) and SURTASSSTN20 (63062), index 7 and 8
%Pairing 5: SURTASS05IN (63064) and STSNew2 (63074), index 9 and 10
%Pairing 6: 39IN (63081) and SURTASS05IN (63064), index 11 and 12

%This converts :00 to :30; when plotting, middle of the bin looks more
%correct when visualizing the phases of the detections.

rec.timeDT = rec.timeDT + minutes(30); 

%%Set limits for our figures.
% limitsTide  = [min(rotUtide) max(rotUtide)]; % Chosen to be abs(0.4).
limitsWind     = [min(windsAverage.WSPD) max(windsAverage.WSPD)];    
limitsDets     = [0 50];
% limitsStrat    = [0 5];
% limitsHeight   = [min(seas.waveHeight) max(seas.waveHeight)];
axDN(1,1:4) = [0 0 -12 12];
axDNTide(1,1:4) = [0 0 -0.25 0.25];
% axDN(1,1:4) = [0 0 -0.5 0.5]; For currents

%Turned shading off for 30 days, too distracting
for k = 1:length(cycleTime)-1
% for k = 145 %Way to make a specific plot that I need
    %Creates axis for each part of the figure
   ax = [cycleTime(k) cycleTime(k+1)];
   axDN(1,1:2) = [datenum(ax(1)) datenum(ax(2))];
   axDNTide(1,1:2) = [datenum(ax(1)) datenum(ax(2))];
%    %Attempting to automatically shade certain hours for diurnal differences
   findersX(1) = ax(1) + duration(hours(12.5));
   findersX(2) = ax(1) + duration(hours(23.5));
   findersX(3) = findersX(1) + duration(hours(24));
   findersX(4) = findersX(2) + duration(hours(24));
   findersY    = [0 6 6 0];
   
   %add other findersX when doing 4 days instead of 2 to shade
   findersX(5) = findersX(3) + duration(hours(24));
   findersX(6) = findersX(4) + duration(hours(24));
   findersX(7) = findersX(5) + duration(hours(24));
   findersX(8) = findersX(6) + duration(hours(24));
% 
%    %Ugh, doing 7 for posterity
%    findersX(9) = findersX(7) + duration(hours(24));
%    findersX(10) = findersX(8) + duration(hours(24));
%    findersX(11) = findersX(9) + duration(hours(24));
%    findersX(12) = findersX(10) + duration(hours(24));
%     
%    findersX(13) = findersX(11) + duration(hours(24));
%    findersX(14) = findersX(12) + duration(hours(24));
    

    ff = figure()
    set(gcf, 'Position',  [30, 20, 1100, 950])
    nexttile([1 2])
    plot(rec.timeDT,detsCompare1(:,1),'k');
    %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
    title('Receiver 1, 4M');
    ylim([0 45])
    xlim(ax);
    datetick('x','mmm,dd,yyyy','keeplimits');
    ylabel('Detections');
%     ylim([0 6]);
%     a = fill([findersX(1) findersX(1) findersX(2) findersX(2)],findersY,[0 0 0]);
%     a.FaceAlpha = 0.15;
%     b = fill([findersX(3) findersX(3) findersX(4) findersX(4)],findersY,[0 0 0]);
%     b.FaceAlpha = 0.15;
%     %Below adds shading for extra 2 days when showing 4 days instead of 2.
%     c = fill([findersX(5) findersX(5) findersX(6) findersX(6)],findersY,[0 0 0]);
%     c.FaceAlpha = 0.15;
%     d = fill([findersX(7) findersX(7) findersX(8) findersX(8)],findersY,[0 0 0]);
%     d.FaceAlpha = 0.15;
    
    
    
%     nexttile([1 2])
%     plot(rec.timeDT,detsCompare1(:,2),'k');
%     %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
%     title('Receiver 4, 1M');
%     ylim([0 45])
%     xlim(ax);
%     datetick('x','mmm,dd,yyyy','keeplimits');
%     ylabel('Detections');
% %     ylim([0 6]);
%     hold on
%     a = fill([findersX(1) findersX(1) findersX(2) findersX(2)],findersY,[0 0 0]);
%     a.FaceAlpha = 0.15;
%     b = fill([findersX(3) findersX(3) findersX(4) findersX(4)],findersY,[0 0 0]);
%     b.FaceAlpha = 0.15;
%     %Below adds shading for extra 2 days when showing 4 days instead of 2.
%     c = fill([findersX(5) findersX(5) findersX(6) findersX(6)],findersY,[0 0 0]);
%     c.FaceAlpha = 0.15;
%     d = fill([findersX(7) findersX(7) findersX(8) findersX(8)],findersY,[0 0 0]);
%     d.FaceAlpha = 0.15;
%     %MORE!!!
%     e = fill([findersX(9) findersX(9) findersX(10) findersX(10)],findersY,[0 0 0]);
%     e.FaceAlpha = 0.15;
%     f = fill([findersX(11) findersX(11) findersX(12) findersX(12)],findersY,[0 0 0]);
%     f.FaceAlpha = 0.15;
%     g = fill([findersX(13) findersX(13) findersX(14) findersX(14)],findersY,[0 0 0]);
%     g.FaceAlpha = 0.15;
    
    %     
    nexttile([1 2])
    plot(tideDT,rotUtide)
    title('Rotated Tidal Predictions, U');
    ylabel('Cross-Shore Velocity');
    xlim(ax);
    ylim([-0.5 0.5]);
    datetick('x','keeplimits');
    yline(0);

    nexttile([1 2])
    plot(tideDT,rotVtide)
    title('Rotated Tidal Predictions, V');
    ylabel('Along-Shore Velocity');
    xlim(ax);
    ylim([-0.11 0.11]);
    datetick('x','keeplimits');
    yline(0);
    
    nexttile([1 2])
    stickplot(tideDN,ut,vt,axDNTide)
    title('Tidal Predictions');
    ylabel('Cross-Shore Velocity');
    datetick('x','keeplimits');

%     ylim([-0.5 0.5]);
%     datetick('x','keeplimits');
%     yline(0);

%     nexttile([1 2])
%     stickplot(windsDN,windsU,windsV,axDN);
%     ylabel('Wind Velocity, m/s');
%     datetick('x','keeplimits');
%     title('Wind Velocities, Gray''s Reef Buoy');
%     
%     nexttile([1 2])
%     plot(seas.time,seas.waveHeight);
%     title('Wave Height, Gray''s Reef');
%     ylabel('Wave height (m)');
%     ylim(limitsHeight);
%     xlim(ax);

%         nexttile([1 2])
%     plot(bottom.bottomTime,bottom.Tilt,'r');
%     ylabel('Tilt Angle, °');
%     ylim([0 40]);
%     xlim(ax);
%     title('Transceiver Tilt from 90°, Straight up');
    
%     exportgraphics(ff,sprintf('SpringNeap%d.png',k))
end


%Make similar graphs focusing on tilt of the transceiver
% for k = 5:length(cycleTime)-1
% for k = 145 %Way to make a specific plot that I need
%     Creates axis for each part of the figure
%    ax = [cycleTime(k) cycleTime(k+1)];
%    axWinds(1,1:2) = [datenum(ax(1)) datenum(ax(2))];
%    axTides(1,1:2) = [datenum(ax(1,1)) datenum(ax(1,2))];
%    
%    %Attempting to automatically shade certain hours for diurnal differences
%    findersX(1) = ax(1) + duration(hours(12.5));
%    findersX(2) = ax(1) + duration(hours(23.5));
%    findersX(3) = findersX(1) + duration(hours(24));
%    findersX(4) = findersX(2) + duration(hours(24));
%    findersY    = [0 6 6 0];
%    
%    %add other findersX when doing 4 days instead of 2 to shade
%    findersX(5) = findersX(3) + duration(hours(24));
%    findersX(6) = findersX(4) + duration(hours(24));
%    findersX(7) = findersX(5) + duration(hours(24));
%    findersX(8) = findersX(6) + duration(hours(24));
% 
%     f = figure()
%     set(gcf, 'Position',  [30, 20, 800, 950])
%     nexttile([1 2])
%     plot(hourlyDetections{useThisTransceiver}.time,hourlyDetections{useThisTransceiver}.detections,'k');
%         title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
%     title('Detections, hourly binned');
%     xlim(ax);
%     datetick('x','mmm,dd,yyyy','keeplimits');
%     ylabel('Hourly Detections');
%     ylim([0 6]);
%     hold on
%     a = fill([findersX(1) findersX(1) findersX(2) findersX(2)],findersY,[0 0 0]);
%     a.FaceAlpha = 0.15;
%     b = fill([findersX(3) findersX(3) findersX(4) findersX(4)],findersY,[0 0 0]);
%     b.FaceAlpha = 0.15;
%     %Below adds shading for extra 2 days when showing 4 days instead of 2.
%     c = fill([findersX(5) findersX(5) findersX(6) findersX(6)],findersY,[0 0 0]);
%     c.FaceAlpha = 0.15;
%     d = fill([findersX(7) findersX(7) findersX(8) findersX(8)],findersY,[0 0 0]);
%     d.FaceAlpha = 0.15;
%     
%     
%     
%     nexttile([1 2])
%     plot(hourlyDetections{alsoUseThis}.time,hourlyDetections{alsoUseThis}.detections,'k');
%         title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
%     title('Detections, hourly binned');
%     xlim(ax);
%     datetick('x','mmm,dd,yyyy','keeplimits');
%     ylabel('Hourly Detections');
%     ylim([0 6]);
%     hold on
%     a = fill([findersX(1) findersX(1) findersX(2) findersX(2)],findersY,[0 0 0]);
%     a.FaceAlpha = 0.15;
%     b = fill([findersX(3) findersX(3) findersX(4) findersX(4)],findersY,[0 0 0]);
%     b.FaceAlpha = 0.15;
%     %Below adds shading for extra 2 days when showing 4 days instead of 2.
%     c = fill([findersX(5) findersX(5) findersX(6) findersX(6)],findersY,[0 0 0]);
%     c.FaceAlpha = 0.15;
%     d = fill([findersX(7) findersX(7) findersX(8) findersX(8)],findersY,[0 0 0]);
%     d.FaceAlpha = 0.15;
%     
%     nexttile([1 2])
%     plot(tideDT,rotUtide)
%     title('Rotated Tidal Predictions, U');
%     ylabel('Cross-Shore Velocity');
%     xlim(ax);
%     ylim([-0.5 0.5]);
%     datetick('x','keeplimits');
%     yline(0);
%     
%     nexttile([1 2])
%     stickplot(tideDN,ut,vt,axTides);
%     ylabel('Tide Velocity, m/s');
%     datetick('x','keeplimits');
%     title('Tide Velocities, Gray''s Reef Buoy');
%     
%     nexttile([1 2])
%     plot(bottom.bottomTime,bottom.Tilt,'r');
%     ylabel('Tilt Angle, °');
%     ylim([0 40]);
%     xlim(ax);
%     title('Transceiver Tilt from 90°, Straight up');
%     nexttile([1 2])
%     plot(receiverData{1,11}.tilt(:,1),receiverData{1,11}.tilt(:,2))
%     ylim([0 40])
%     xlim(datenum(ax));
%     datetick('x','keeplimits');
%     title('Tilt of moored transceiver 1');
%     
%     nexttile ([1 2])
%     plot(receiverData{1,2}.tilt(:,1),receiverData{1,2}.tilt(:,2))
%     ylim([0 40])
%     xlim(datenum(ax));
%     datetick('x','keeplimits');
%     title('Tilt of moored transceiver 2');
%     nexttile([1 2])
%     plot(bottom.bottomTime,buoyStratification,'r');
%     ylabel('Temp \Delta °C)');
%     ylim(limitsStrat);
%     xlim(ax);
%     title('Bulk Stratification at Gray''s Reef, ~20m Depth');
%     
%     nexttile([1 2])
%     plot(seas.time,seas.waveHeight);
%     title('Wave Height, Gray''s Reef');
%     ylabel('Wave height (m)');
%     ylim(limitsHeight);
%     xlim(ax);
%     saveas(f,sprintf('SpringNeap%d.png',k))
%     nexttile([1 2])
%     stickplot(windsDN,windsU,windsV,axWinds);
%     ylabel('Wind Velocity, m/s');
%     datetick('x','keeplimits');
%     title('Wind Velocities, Gray''s Reef Buoy');
    
%     exportgraphics(f,sprintf('SpringNeapTilt%d.png',k))
% end

