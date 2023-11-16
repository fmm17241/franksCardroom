%Chunks of time to plot:
startCyclePre = tideDT(97);
%THIS IS WHERE I SET MY CHUNKS! 2 days gives clear patterns and is visually
%appealing, but can be changed for longer dataset analysis.
% 
% % Basic:
cycleDuration  = duration(days(4));



%old
% fixOffset = 0.5*cycleDuration;

% startCycle = startCyclePre - fixOffset
startCycle = startCyclePre

cycleTime = startCycle;
for k = 1:98 %
% for k  = 1:95 % for 4 day chunks
% for k = 1:35 %~30 day chunks
% for k = 1:25     %15 day chunks
% for k = 1:53 %weeks
%    cycleTime(k+1) = cycleTime(k) + fixOffset;  Use this to put in :30
%    offset here, but I've changed that.
   cycleTime(k+1) = cycleTime(k) + cycleDuration;
end

%%


%%Set limits for our figures.
% limitsTide  = [min(rotUtide) max(rotUtide)]; % Chosen to be abs(0.4).
limitsWind     = [min(windsU) max(windsU)];    
limitsDets     = [0 6];
limitsStrat    = [0 5];
limitsHeight   = [min(seas.waveHeight) max(seas.waveHeight)];
axDN(1,1:4) = [0 0 -12 12];
% axDN(1,1:4) = [0 0 -0.5 0.5]; For currents


%Change this to one of the pairings listed above to save
% cd  'C:\Users\fmm17241\OneDrive - University of Georgia\data\Moored\tidalCycles\pairing4'
cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\exportedFigures\timeseries'

receiverLetter = ['A','B','C','D']

for COUNT = 1:length(receiverData)
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
        
    
        ff = tiledlayout('vertical')
        set(gcf, 'Position',  [-100, 100, 2000, 1100])
                nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.hourlyDets(:,2),'k','LineWidth',2);
        %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
        title(sprintf('Station %s, Hourly Dets',receiverLetter(COUNT)));
        xlim(ax);
        datetick('x','mmm,dd,yyyy','keeplimits');
        ylabel('Hourly Detections');


        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{1,COUNT}.avgNoise(:,2));
        ylabel('Ambient Noise');
        ylim([500 900])
        yline(650)
        xlim(ax);
        datetick('x','keeplimits');
        title('Ambient Noise');
        yyaxis right
        scatter(receiverTimes{COUNT},receiverData{COUNT}.daytime,'r','filled')
        set(gca, 'YTick', [0.1 0.9])
        yticklabels({'Night','Day'})
        % xticklabels([])

        nexttile([1 2])
        yyaxis left
        plot(windsDT,WSPD);
        ylabel('Windspeed');
        ylim([0 10])
%         yline(650)
        xlim(ax);
        datetick('x','keeplimits');
        title('Winds');
        
        
        
        
%         nexttile([1 2])
%         plot(receiverTimes{COUNT},receiverData{COUNT}.hourlyDets(:,2),'k');
%         %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
%         title(sprintf('Station %s, Hourly Dets',receiverLetter(COUNT)));
%         xlim(ax);
%         datetick('x','mmm,dd,yyyy','keeplimits');
%         ylabel('Hourly Detections');
% %         ylim([6 16]);
% 


%         nexttile([1 2])
%         plot(windsDT,WSPD);
%         ylabel('Windspeed');
%         ylim([2 12])
% %         yline(650)
%         xlim(ax);
%         datetick('x','keeplimits');
%         title('Winds');
% 
%         %     
%         nexttile([1 2])
%         plot(tideDT,rotUtideShore)
%         title('Rotated Tides, Parallel');
%         ylabel('Parallel Velocity');
%         xlim(ax);
%         ylim([-0.4 0.4]);
%         datetick('x','keeplimits');
%         yline(0);
% 
        % nexttile([1 2])
        % plot(receiverTimes{COUNT},receiverData{COUNT}.pings(:,2),'r');
        % ylabel('Pings');
        % % ylim([20 140]);
        % xlim(ax);
        % title('Single Pings Received, Hourly');
        % 
        % 
        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.ratio(:,2),'r');
        ylabel('Ratio');
        % ylim([20 140]);
        xlim(ax);
        title('Ratio, Used/Total Pings');
    %     
        % nexttile([1 2])
        % plot(receiverTimes{COUNT},receiverData{COUNT}.tilt(:,2),'k');
        % ylabel('Tilt');
        % ylim([6 17]);
        % xlim(ax);
        % title('Instrument Tilt');
%         nexttile ([1 2])
%         plot(bottomStats{COUNT}.Time,bottomStats{COUNT}.Tilt)
%         ylim([0 40])
%         xlim(ax);
%         datetick('x','keeplimits');
%         title('Transceiver Tilt, 2');
%     
%         
%         nexttile([1 2])
%         plot(bottomStats{COUNT}.Time,stratification{COUNT},'r');
%         ylabel('Temp \Delta °C)');
%         ylim(limitsStrat);
%         xlim(ax);
%         title('Bulk Stratification at Gray''s Reef, ~20m Depth');
%         nexttile([1 2])
%         plot(fullData{1}.time,fullData{1}.windSpeed)
%         ylabel('Wind Magnitude, m/s');
%         datetick('x','keeplimits');
%         title('Windspeed');
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
        exportgraphics(ff,sprintf('4Day%dnumber%d.png',COUNT,k))
        close all
    end
end


%% 
%FM spot checking for committee
%Sept 1-Sept 6
%Dets and WInds

ax = [receiverTimes{1,1}(280), receiverTimes{1,1}(380)];
COUNT = 1;
receiverLetter = ['A','B','C','D']


%FRANK: add sunlight.
ff = figure()

        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.hourlyDets(:,2),'k','LineWidth',2);
        %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
        title(sprintf('Station %s, Hourly Dets',receiverLetter(COUNT)));
        xlim(ax);
        % datetick('x','mmm,dd,yyyy','keeplimits');
        ylabel('Hourly Detections');

        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.pings(:,2),'k','LineWidth',2);
        %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
        title('Hourly Pings');
        xlim(ax);
        % datetick('x','mmm,dd,yyyy','keeplimits');
        ylabel('Hourly Pings');

        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.ratio(:,2),'k','LineWidth',2);
        %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
        title('Ping Ratio');
        xlim(ax);
        % datetick('x','mmm,dd,yyyy','keeplimits');
        ylabel('Ping Ratio');


        % nexttile([1 2])
        % plot(receiverTimes{COUNT},receiverData{1,COUNT}.avgNoise(:,2));
        % ylabel('Ambient Noise');
        % ylim([400 680])
        % yline(650)
        % xlim(ax);
        % datetick('x','keeplimits');
        % title('HF Noise')
        % 
        % nexttile([1 2])
        % plot(tideDT,crossShore)
        % title('Rotated Tides, Parallel');
        % ylabel('Parallel Velocity');
        % xlim(ax);
        % ylim([-0.4 0.4]);
        % datetick('x','keeplimits');
        % yline(0);
        % yyaxis right
        % scatter(receiverTimes{COUNT},receiverData{COUNT}.daytime,'r','filled')
        % set(gca,'XTick',[], 'YTick', [])
        % xticklabels([])

        % nexttile([1 2])
        % plot(receiverTimes{COUNT},receiverData{COUNT}.tilt,'r');
        % ylabel('Tilt Angle, °');
        % ylim([5 20]);
        % xlim(ax);
        % title('Transceiver Tilt from 90°, Straight up');

        nexttile([1 2])
        yyaxis left
        plot(windsDT,WSPD);
        ylabel('Windspeed');
        ylim([0 12])
%         yline(650)
        xlim(ax);
        datetick('x','keeplimits');
        title('Winds');

        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.bulkStrat,'r');
        ylabel('Temp \Delta °C)');
        % ylim(limitsStrat);
        xlim(ax);
        title('Bulk Stratification at Gray''s Reef, ~20m Depth');
        yyaxis right
        scatter(receiverTimes{COUNT},receiverData{COUNT}.daytime,'r','filled')
        set(gca,'XTick',[], 'YTick', [])
        xticklabels([])


        % yyaxis right
        % scatter(receiverTimes{COUNT},receiverData{COUNT}.daytime,'r','filled')
        % set(gca,'XTick',[], 'YTick', [])
        % xticklabels([])
        % title('Ambient Noise');



exportgraphics(ff,sprintf('test4Day%d.png',COUNT))


%%
ax = [receiverTimes{1,1}(5500), receiverTimes{1,1}(5580)];
COUNT = 1;
receiverLetter = ['A','B','C','D']


%FRANK: add sunlight.
ff = figure()

        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.hourlyDets(:,2),'k','LineWidth',2);
        %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
        title(sprintf('Station %s, Hourly Dets',receiverLetter(COUNT)));
        xlim(ax);
        % datetick('x','mmm,dd,yyyy','keeplimits');
        ylabel('Hourly Detections');

        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.pings(:,2),'k','LineWidth',2);
        %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
        title('Hourly Pings');
        xlim(ax);
        % datetick('x','mmm,dd,yyyy','keeplimits');
        ylabel('Hourly Pings');

        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.ratio(:,2),'k','LineWidth',2);
        %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
        title('Ping Ratio');
        xlim(ax);
        % datetick('x','mmm,dd,yyyy','keeplimits');
        ylabel('Ping Ratio');

