%Frank's gotta find times to study with snap rate/frequency

buildReceiverData
close all
clearvars index
% FM now trying to find times with high winds, along with 4 hours before
% and after these times to compare the difference in noise.
% for k = 1:length(receiverData)
%     % Find high wind events
%     highWindIndex{k} = receiverData{k}.windSpd > 6;
% 
%     % Initialize logical arrays for periods of high wind
%     sustainedHighWindIndex{k} = false(size(highWindIndex{k}));
% 
%     % Define the window size (more than 4 hours means at least 5 consecutive hours)
%     windowSize = 5;
% 
%     % Check for sustained high winds
%     for i = 1:(length(highWindIndex{k}) - windowSize + 1)
%         if all(highWindIndex{k}(i:i+windowSize-1))
%             sustainedHighWindIndex{k}(i:i+windowSize-1) = true;
%         end
%     end
% 
%     % Find the start and end of each sustained high wind period
%     sustainedPeriods = sustainedHighWindIndex{k};
%     diffPeriods = diff([false; sustainedPeriods; false]);
%     startIndices = find(diffPeriods == 1);
%     endIndices = find(diffPeriods == -1) - 1;
% 
%     % Initialize logical arrays for 5 hours before and after
%     beforeSustained{k} = false(size(highWindIndex{k}));
%     afterSustained{k} = false(size(highWindIndex{k}));
% 
%     % Mark the 5 hours before and after each sustained period
%     for i = 1:length(startIndices)
%         if startIndices(i) > 5
%             beforeSustained{k}(startIndices(i)-5:startIndices(i)-1) = true;
%         else
%             beforeSustained{k}(1:startIndices(i)-1) = true;
%         end
%         if endIndices(i) <= length(highWindIndex{k}) - 5
%             afterSustained{k}(endIndices(i)+1:endIndices(i)+5) = true;
%         else
%             afterSustained{k}(endIndices(i)+1:end) = true;
%         end
%     end
% end
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the datetime array (assuming hourly data)
timeArray = receiverData{4}.DT; % This should be an array of datetime objects
windSpdArray = receiverData{4}.windSpd;

% Initialize a cell array to store the event periods
eventPeriods = {};

highWindIndex = receiverData{4}.windSpd > 7;

% Initialize logical arrays for periods of high wind
sustainedHighWindIndex = false(size(highWindIndex));

% Define the window size (more than 4 hours means at least 5 consecutive hours)
windowSize = 3;

% Check for sustained high winds
for i = 1:(length(highWindIndex) - windowSize + 1)
    if all(highWindIndex(i:i+windowSize-1))
        sustainedHighWindIndex(i:i+windowSize-1) = true;
    end
end

% Find the start and end of each sustained high wind period
sustainedPeriods = sustainedHighWindIndex;
diffPeriods = diff([false; sustainedPeriods; false]);
startIndices = find(diffPeriods == 1);
endIndices = find(diffPeriods == -1) - 1;

% Initialize logical arrays for 5 hours before and after
beforeSustained = false(size(highWindIndex));
afterSustained = false(size(highWindIndex));

% Mark the 5 hours before and after each sustained period
for i = 1:length(startIndices)
    % Ensure indices do not exceed array bounds and are valid
    if startIndices(i) > 5
        beforePeriod = startIndices(i) - 5:startIndices(i) - 1;
    else
        beforePeriod = 1:startIndices(i) - 1;
    end
    if endIndices(i) <= length(highWindIndex) - 5
        afterPeriod = endIndices(i) + 1:endIndices(i) + 5;
    else
        afterPeriod = endIndices(i) + 1:length(highWindIndex);
    end
    
    % Ensure beforePeriod and afterPeriod are non-empty and valid
    if ~isempty(beforePeriod) && beforePeriod(1) > 0
        eventPeriods{end+1, 1} = timeArray(beforePeriod);
    else
        eventPeriods{end+1, 1} = [];
    end
    eventPeriods{end, 2} = timeArray(startIndices(i):endIndices(i));

    if ~isempty(afterPeriod) && afterPeriod(1) <= length(timeArray)
        eventPeriods{end, 3} = timeArray(afterPeriod);
    else
        eventPeriods{end, 3} = [];
    end
end

cd 

% Write the event periods to a text file
fid = fopen('WindEvents.txt', 'w');
for i = 1:size(eventPeriods, 1)
    fprintf(fid, 'Wind Event #%d\n', i);
    
    if ~isempty(eventPeriods{i, 1})
        beforeStr = sprintf('%s - %s', datestr(eventPeriods{i, 1}(1)), datestr(eventPeriods{i, 1}(end)));
        fprintf(fid, 'Before: %s\n', beforeStr);
    else
        fprintf(fid, 'Before: N/A\n');
    end
    
    duringStr = sprintf('%s - %s', datestr(eventPeriods{i, 2}(1)), datestr(eventPeriods{i, 2}(end)));
    fprintf(fid, 'Wind Event: %s\n', duringStr);
    
    if ~isempty(eventPeriods{i, 3})
        afterStr = sprintf('%s - %s', datestr(eventPeriods{i, 3}(1)), datestr(eventPeriods{i, 3}(end)));
        fprintf(fid, 'After: %s\n', afterStr);
    else
        fprintf(fid, 'After: N/A\n');
    end
    
    fprintf(fid, '\n'); % Add a blank line between events for readability
end
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\windEventPlots'

ylimNoise = [400 800];
ylimWind  = [0 14];
% ylimTemp  = []
ylimDets  = [0 10];

for i = 1:size(eventPeriods, 1)
    figure()
    tiledlayout(5,1,'TileSpacing','compact')
    
    % Determine the x-axis limits
    if ~isempty(eventPeriods{i, 1})
        xLimits = [eventPeriods{i, 1}(1), eventPeriods{i, 3}(end)];
    else
        xLimits = [eventPeriods{i, 2}(1), eventPeriods{i, 3}(end)];
    end
    
    % Plot Noise
    ax1 = nexttile();
    hold on
    % for k = 1:length(receiverData)
    for k = 4
        plot(receiverData{k}.DT, receiverData{k}.Noise);
    end
    title('Noise')
    xlim(xLimits)
    ylim(ylimNoise)
    
    % Plot Wind Speed
    ax2 = nexttile();
    hold on
    plot(receiverData{4}.DT, receiverData{4}.windSpd);
    title('Windspeed')
    xlim(xLimits)
    ylim(ylimWind)

    % Plot Tide
    ax3 = nexttile();
    hold on
    % for k = 1:length(receiverData)
    for k = 4
        plot(receiverData{k}.DT, receiverData{k}.crossShore);
    end
    hold on
    yline(0)
    title('Cross-Shore Tide')
    xlim(xLimits)
    % ylim(ylimTemp)

    % Plot Temperature
    ax4 = nexttile();
    hold on
    % for k = 1:length(receiverData)
    for k = 4
        plot(receiverData{k}.DT, receiverData{k}.Temp);
    end
    title('Temperature')
    xlim(xLimits)
    % ylim(ylimTemp)

    % Plot Detections
    ax5 = nexttile();
    hold on
    % for k = 1:length(receiverData)
    for k = 4
        plot(receiverData{k}.DT, receiverData{k}.HourlyDets);
    end
    title('Detections')
    xlim(xLimits)
    ylim(ylimDets)

    % Link axes
    linkaxes([ax1, ax2, ax3, ax4, ax5], 'x');


    filename = sprintf('figure_%d.png', i);

    % saveas(gcf,filename)
end
close all




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure()
tiledlayout(4,1,'tileSpacing','compact')

ax1 = nexttile()
hold on
for k = 1:length(receiverData)
plot(receiverData{k}.DT,receiverData{k}.Noise)

end
title('Noise')

ax2 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd)
hold on
title('Windspeed')

ax3 = nexttile()
hold on
for k = 1:length(receiverData)
plot(receiverData{k}.DT,receiverData{k}.Temp)
end
title('Temperature')
% 
ax4 = nexttile()
for k = 1:length(receiverData)
plot(receiverData{k}.DT,receiverData{k}.HourlyDets)
end
title('Detections')


linkaxes([ax1,ax2,ax3,ax4],'x')


