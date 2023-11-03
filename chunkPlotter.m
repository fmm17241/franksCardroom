
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
% for k = 1:length(hourlyDetections)
%     hourlyDetections{k}.time = hourlyDetections{k}.time + offset; 
% end

%%Set limits for our figures.
% limitsTide  = [min(rotUtide) max(rotUtide)]; % Chosen to be abs(0.4).
limitsWind     = [min(windsU) max(windsU)];    
limitsDets     = [0 6];
limitsStrat    = [0 5];
limitsHeight   = [min(seas.waveHeight) max(seas.waveHeight)];
axDN(1,1:4) = [0 0 -12 12];
% axDN(1,1:4) = [0 0 -0.5 0.5]; For currents

%Change this to one of the pairings listed above to save
cd  'C:\Users\fmm17241\OneDrive - University of Georgia\data\Moored\tidalCycles\pairing3'

%These modify the mooredEfficiency transceiver pairings to use. 2 is the
%one that has been most successful, but we want to analyze other pairings.
% Changing this to reflect that we will be using all transceiver's data in
% a huge loop, not just 2 chosen ones.

%Frank has erased the need for these, long may he reign. 3/1/23
% useThisTransceiver = 3;
% alsoUseThis         = 4;


%Turned shading off for 30 days, too distracting
for COUNT = 1:2:length(receiverData)
    for k = 1:length(cycleTime)-1
    % for k = 145 %Way to make a specific plot that I need
        %Creates axis for each part of the figure
       ax = [cycleTime(k) cycleTime(k+1)];
       axDN(1,1:2) = [datenum(ax(1)) datenum(ax(2))];
    
    %    %Attempting to automatically shade certain hours for diurnal differences
%        findersX(1) = ax(1) + duration(hours(12.5));
%        findersX(2) = ax(1) + duration(hours(23.5));
%        findersX(3) = findersX(1) + duration(hours(24));
%        findersX(4) = findersX(2) + duration(hours(24));
%        findersY    = [0 6 6 0];
%        
%        %add other findersX when doing 4 days instead of 2 to shade
%        findersX(5) = findersX(3) + duration(hours(24));
%        findersX(6) = findersX(4) + duration(hours(24));
%        findersX(7) = findersX(5) + duration(hours(24));
%        findersX(8) = findersX(6) + duration(hours(24));
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
        set(gcf, 'Position',  [30, 20, 800, 1100])
        nexttile('south')
        plot(hourlyDetections{COUNT}.time,hourlyDetections{COUNT}.detections,'k');
        %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
        title('Detections, hourly binned');
        xlim(ax);
        datetick('x','mmm,dd,yyyy','keeplimits');
        ylabel('Hourly Detections');
        ylim([0 6]);
        hold on
    %     a = fill([findersX(1) findersX(1) findersX(2) findersX(2)],findersY,[0 0 0]);
    %     a.FaceAlpha = 0.15;
    %     b = fill([findersX(3) findersX(3) findersX(4) findersX(4)],findersY,[0 0 0]);
    %     b.FaceAlpha = 0.15;
    %     %Below adds shading for extra 2 days when showing 4 days instead of 2.
    %     c = fill([findersX(5) findersX(5) findersX(6) findersX(6)],findersY,[0 0 0]);
    %     c.FaceAlpha = 0.15;
    %     d = fill([findersX(7) findersX(7) findersX(8) findersX(8)],findersY,[0 0 0]);
    %     d.FaceAlpha = 0.15;
        
        
        
        nexttile('south')
        plot(hourlyDetections{COUNT+1}.time,hourlyDetections{COUNT+1}.detections,'k');
        %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
        title('Detections, hourly binned');
        xlim(ax);
        datetick('x','mmm,dd,yyyy','keeplimits');
        ylabel('Hourly Detections');
        ylim([0 6]);
        hold on
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
        nexttile('south')
        plot(noiseDT{COUNT},receiverData{1,COUNT}.avgNoise(:,2));
        ylabel('Ambient Noise');
        ylim([500 900])
        yline(650)
        xlim(ax);
        datetick('x','keeplimits');
        title('Ambient Noise');
        
        %     
        nexttile('south')
        plot(tideDT,rotUtide(COUNT,:))
        title('Rotated Tides, Parallel');
        ylabel('Parallel Velocity');
        xlim(ax);
        ylim([-0.3 0.3]);
        datetick('x','keeplimits');
        yline(0);
        
%         nexttile([1 2])
%         plot(tideDT,rotVtide(COUNT,:))
%         title('Rotated Tides, Perpendicular');
%         ylabel('Pependicular Velocity');
%         xlim(ax);
%         ylim([-0.3 0.3]);
%         datetick('x','keeplimits');
%         yline(0);
        
        
    %     nexttile([1 2])
    %     plot(leftoversDT,leftovers)
    %     title('Failed Pieces of Transmissions');
    %     ylim([0 80])
    %     xlim(ax)
    %     datetick('x','keeplimits');
        
    
    %     hold on
    %     a = fill([findersX(1) findersX(1) findersX(2) findersX(2)],findersY,[0 0 0]);
    %     a.FaceAlpha = 0.15;
    %     b = fill([findersX(3) findersX(3) findersX(4) findersX(4)],findersY,[0 0 0]);
    %     b.FaceAlpha = 0.15;
    
        nexttile('south')
        plot(bottomStats{COUNT}.Time,bottomStats{COUNT}.Tilt,'r');
        ylabel('Tilt Angle, °');
        ylim([0 40]);
        xlim(ax);
        title('Transceiver Tilt, 1');
    %     
%         nexttile ([1 2])
%         plot(bottomStats{COUNT}.Time,bottomStats{COUNT}.Tilt)
%         ylim([0 40])
%         xlim(ax);
%         datetick('x','keeplimits');
%         title('Transceiver Tilt, 2');
%     
        
        nexttile('south')
        plot(bottomStats{COUNT}.Time,stratification{COUNT},'r');
        ylabel('Temp \Delta °C)');
        ylim(limitsStrat);
        xlim(ax);
        title('Bulk Stratification at Gray''s Reef, ~20m Depth');
        nexttile([1 2])
        plot(fullData{1}.time,fullData{1}.windSpeed)
        ylabel('Wind Magnitude, m/s');
        datetick('x','keeplimits');
        title('Windspeed');
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
%         
        exportgraphics(ff,sprintf('saveIt%dand%d.png',COUNT,k))
        close all
    end
end
