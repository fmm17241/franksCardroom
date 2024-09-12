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
% %     % Initialize logical arrays for periods of high wind
% %     sustainedHighWindIndex{k} = false(size(highWindIndex{k}));
% % 
% %     % Define the window size (more than 4 hours means at least 5 consecutive hours)
% %     windowSize = 5;
% % 
% %     % Check for sustained high winds
% %     for i = 1:(length(highWindIndex{k}) - windowSize + 1)
% %         if all(highWindIndex{k}(i:i+windowSize-1))
% %             sustainedHighWindIndex{k}(i:i+windowSize-1) = true;
% %         end
% %     end
% % 
% %     % Find the start and end of each sustained high wind period
% %     sustainedPeriods = sustainedHighWindIndex{k};
% %     diffPeriods = diff([false; sustainedPeriods; false]);
% %     startIndices = find(diffPeriods == 1);
% %     endIndices = find(diffPeriods == -1) - 1;
% % 
% %     % Initialize logical arrays for 5 hours before and after
% %     beforeSustained{k} = false(size(highWindIndex{k}));
% %     afterSustained{k} = false(size(highWindIndex{k}));
% % 
% %     % Mark the 5 hours before and after each sustained period
% %     for i = 1:length(startIndices)
% %         if startIndices(i) > 5
% %             beforeSustained{k}(startIndices(i)-5:startIndices(i)-1) = true;
% %         else
% %             beforeSustained{k}(1:startIndices(i)-1) = true;
% %         end
% %         if endIndices(i) <= length(highWindIndex{k}) - 5
% %             afterSustained{k}(endIndices(i)+1:endIndices(i)+5) = true;
% %         else
% %             afterSustained{k}(endIndices(i)+1:end) = true;
% %         end
% %     end
% % end
% %%
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%
% % Define the datetime array (assuming hourly data)
% timeArray = receiverData{4}.DT; % This should be an array of datetime objects
% windSpdArray = receiverData{4}.windSpd;
% 
% % Initialize a cell array to store the event periods
% eventPeriods = {};
% 
% highWindIndex = receiverData{4}.windSpd > 7;
% 
% % Initialize logical arrays for periods of high wind
% sustainedHighWindIndex = false(size(highWindIndex));
% 
% % Define the window size (more than 4 hours means at least 5 consecutive hours)
% windowSize = 3;
% 
% % Check for sustained high winds
% for i = 1:(length(highWindIndex) - windowSize + 1)
%     if all(highWindIndex(i:i+windowSize-1))
%         sustainedHighWindIndex(i:i+windowSize-1) = true;
%     end
% end
% 
% % Find the start and end of each sustained high wind period
% sustainedPeriods = sustainedHighWindIndex;
% diffPeriods = diff([false; sustainedPeriods; false]);
% startIndices = find(diffPeriods == 1);
% endIndices = find(diffPeriods == -1) - 1;
% 
% % Initialize logical arrays for 5 hours before and after
% beforeSustained = false(size(highWindIndex));
% afterSustained = false(size(highWindIndex));
% 
% % Mark the 5 hours before and after each sustained period
% for i = 1:length(startIndices)
%     % Ensure indices do not exceed array bounds and are valid
%     if startIndices(i) > 5
%         beforePeriod = startIndices(i) - 5:startIndices(i) - 1;
%     else
%         beforePeriod = 1:startIndices(i) - 1;
%     end
%     if endIndices(i) <= length(highWindIndex) - 5
%         afterPeriod = endIndices(i) + 1:endIndices(i) + 5;
%     else
%         afterPeriod = endIndices(i) + 1:length(highWindIndex);
%     end
% 
%     % Ensure beforePeriod and afterPeriod are non-empty and valid
%     if ~isempty(beforePeriod) && beforePeriod(1) > 0
%         eventPeriods{end+1, 1} = timeArray(beforePeriod);
%     else
%         eventPeriods{end+1, 1} = [];
%     end
%     eventPeriods{end, 2} = timeArray(startIndices(i):endIndices(i));
% 
%     if ~isempty(afterPeriod) && afterPeriod(1) <= length(timeArray)
%         eventPeriods{end, 3} = timeArray(afterPeriod);
%     else
%         eventPeriods{end, 3} = [];
%     end
% end
% 
% % Write the event periods to a text file
% fid = fopen('WindEvents.txt', 'w');
% for i = 1:size(eventPeriods, 1)
%     fprintf(fid, 'Wind Event #%d\n', i);
% 
%     if ~isempty(eventPeriods{i, 1})
%         beforeStr = sprintf('%s - %s', datestr(eventPeriods{i, 1}(1)), datestr(eventPeriods{i, 1}(end)));
%         fprintf(fid, 'Before: %s\n', beforeStr);
%     else
%         fprintf(fid, 'Before: N/A\n');
%     end
% 
%     duringStr = sprintf('%s - %s', datestr(eventPeriods{i, 2}(1)), datestr(eventPeriods{i, 2}(end)));
%     fprintf(fid, 'Wind Event: %s\n', duringStr);
% 
%     if ~isempty(eventPeriods{i, 3})
%         afterStr = sprintf('%s - %s', datestr(eventPeriods{i, 3}(1)), datestr(eventPeriods{i, 3}(end)));
%         fprintf(fid, 'After: %s\n', afterStr);
%     else
%         fprintf(fid, 'After: N/A\n');
%     end
% 
%     fprintf(fid, '\n'); % Add a blank line between events for readability
% end
% fclose(fid);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% cd ([oneDrive,'\windEventPlots'])
% 
% 
% ylimNoise = [400 800];
% ylimWind  = [0 14];
% % ylimTemp  = []
% ylimDets  = [0 10];
% 
% for i = 1:size(eventPeriods, 1)
%     figure()
%     tiledlayout(5,1,'TileSpacing','compact')
% 
%     % Determine the x-axis limits
%     if ~isempty(eventPeriods{i, 1})
%         xLimits = [eventPeriods{i, 1}(1), eventPeriods{i, 3}(end)];
%     else
%         xLimits = [eventPeriods{i, 2}(1), eventPeriods{i, 3}(end)];
%     end
% 
%     % Plot Noise
%     ax1 = nexttile();
%     hold on
%     % for k = 1:length(receiverData)
%     for k = 4
%         plot(receiverData{k}.DT, receiverData{k}.Noise);
%     end
%     title('Noise')
%     xlim(xLimits)
%     ylim(ylimNoise)
% 
%     % Plot Wind Speed
%     ax2 = nexttile();
%     hold on
%     plot(receiverData{4}.DT, receiverData{4}.windSpd);
%     title('Windspeed')
%     xlim(xLimits)
%     ylim(ylimWind)
% 
%     % Plot Tide
%     ax3 = nexttile();
%     hold on
%     % for k = 1:length(receiverData)
%     for k = 4
%         plot(receiverData{k}.DT, receiverData{k}.crossShore);
%     end
%     hold on
%     yline(0)
%     title('Cross-Shore Tide')
%     xlim(xLimits)
%     % ylim(ylimTemp)
% 
%     % Plot Temperature
%     ax4 = nexttile();
%     hold on
%     % for k = 1:length(receiverData)
%     for k = 4
%         plot(receiverData{k}.DT, receiverData{k}.Temp);
%     end
%     title('Temperature')
%     xlim(xLimits)
%     % ylim(ylimTemp)
% 
%     % Plot Detections
%     ax5 = nexttile();
%     hold on
%     % for k = 1:length(receiverData)
%     for k = 4
%         plot(receiverData{k}.DT, receiverData{k}.HourlyDets);
%     end
%     title('Detections')
%     xlim(xLimits)
%     ylim(ylimDets)
% 
%     % Link axes
%     linkaxes([ax1, ax2, ax3, ax4, ax5], 'x');
% 
% 
%     filename = sprintf('figure_%d.png', i);
% 
%     % saveas(gcf,filename)
% end
% close all
% 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Frank doing some manual labor. Not sure how to make it prettier, but this
%works for now.
% Dec 12
cd ([oneDrive,'\acousticAnalysis\windEvent2019Dec12'])
dataFiles = dir('*.txt')
fileNames = {dataFiles.name};
snapRateTables = cell(1, length(fileNames));



clearvars SnapCountTable PeakAmpTable EnergyTable snapDates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sep29
cd ([oneDrive,'\acousticAnalysis\windEvent2020Sep29'])
dataFiles = dir('*.txt')
fileNames = {dataFiles.name};
snapRateTables = cell(1, length(fileNames));


clearvars SnapCountTable PeakAmpTable EnergyTable snapDates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%April 12
cd ([oneDrive,'\acousticAnalysis\windEvent2020Apr12'])
dataFiles = dir('*.txt')
fileNames = {dataFiles.name};
snapRateTables = cell(1, length(fileNames));

originalDatetime= datetime(2020,04,12,0,0,0);

for i = 1:length(fileNames)
snapRateTables{i} = readtable(fileNames{i});
end


for i = 1:length(snapRateTables)
    snapRateTables{i}.DateTime = snapDates{i} + snapRateTables{i}.BeginClockTime;

    SnapCountTable{i} = timetable(snapRateTables{i}.DateTime,snapRateTables{i}.Channel)
    SnapCountTable{i}.Properties.VariableNames = {'SnapCount'}
    
    PeakAmpTable{i} = timetable(snapRateTables{i}.DateTime,snapRateTables{i}.PeakAmp_U_)
    PeakAmpTable{i}.Properties.VariableNames = {'PeakAmp'}
    
    EnergyTable{i} = timetable(snapRateTables{i}.DateTime,snapRateTables{i}.Energy_dBFS_)
    EnergyTable{i}.Properties.VariableNames = {'Energy'}

    %Average it by hour, or minute.
    hourSnaps{i} = retime(SnapCountTable{i},'hourly','sum');
    hourSnaps{i}.Time.TimeZone = 'UTC';
    hourAmp{i} = retime(PeakAmpTable{i},'hourly','mean');
    hourAmp{i}.Time.TimeZone = 'UTC';
    hourEnergy{i} = retime(EnergyTable{i},'hourly','mean');
    hourEnergy{i}.Time.TimeZone = 'UTC';
    %Average it by hour, or minute.
    minuteSnaps{i} = retime(SnapCountTable{i},'minute','sum');
    minuteSnaps{i}.Time.TimeZone = 'UTC';
    minuteAmp{i} = retime(PeakAmpTable{i},'minute','mean');
    minuteAmp{i}.Time.TimeZone = 'UTC';
    minuteEnergy{i} = retime(EnergyTable{i},'minute','mean');
    minuteEnergy{i}.Time.TimeZone = 'UTC';
end

clearvars SnapCountTable PeakAmpTable EnergyTable snapDates

%%%%%%%%%%%%%%%%%%%%%%%%
%April 15
cd ([oneDrive,'\acousticAnalysis\windEvent2020Apr15'])
dataFiles = dir('*.txt')
fileNames = {dataFiles.name};
snapRateTables = cell(1, length(fileNames));


clearvars SnapCountTable PeakAmpTable EnergyTable snapDates


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% February 28th
cd ([oneDrive,'\acousticAnalysis\windEvent2020Feb28'])
dataFiles = dir('*.txt')
fileNames = {dataFiles.name};
snapRateTables = cell(1, length(fileNames));

for i = 1:length(fileNames)
snapRateTables{i} = readtable(fileNames{i});
end

% Initialize a cell array to store the formatted datetime strings
formattedDates = cell(size(fileNames));

for i = 1:length(fileNames)
    % Extract the date and time portion from the filename
    dateStr = regexp(fileNames{i}, '\d{12}', 'match', 'once');
    
    % Convert the string to a datetime object
    if ~isempty(dateStr)
        % Define the input format of the datetime string
        dt(i,1) = datetime(dateStr, 'InputFormat', 'yyMMddHHmmss');
    else
        % Handle cases where the pattern is not found
        formattedDates{i} = 'Date not found';
    end
end

%Okay, now I have to add seconds.
for i = 1:length(fileNames)
snapRateTables{i}.EventDateTime = dt(i) + seconds(snapRateTables{i}.BeginTime_s_);
snapRateTables{i}.EventDateTime.Format = 'dd-MMM-yyyy HH:mm:ss.SSS';
end

for i = 1:length(snapRateTables)

    % Filter rows where the 'View' column contains the string 'Waveform 1'
    waveFormTable{i} = snapRateTables{i}(contains(snapRateTables{1}.View, 'Waveform 1'), :);
    spectrogramTable{i} = snapRateTables{i}(contains(snapRateTables{1}.View, 'Spectrogram 1'), :);

    SnapCountTable{i} = timetable(snapRateTables{i}.EventDateTime,snapRateTables{i}.Channel);
    SnapCountTable{i}.Properties.VariableNames = {'SnapCount'};
    
    PeakAmpTable{i} = timetable(waveFormTable{i}.EventDateTime,waveFormTable{i}.PeakAmp_U_);
    PeakAmpTable{i}.Properties.VariableNames = {'PeakAmp'};
    
    EnergyTable{i} = timetable(waveFormTable{i}.EventDateTime,waveFormTable{i}.Energy_dBFS_);
    EnergyTable{i}.Properties.VariableNames = {'Energy'};
end

for i = 1:fileNames
    %Average it by hour, or minute.
    hourSnaps{i} = retime(SnapCountTable{i},'hourly','sum');
    hourSnaps{i}.Time.TimeZone = 'UTC';
    hourAmp{i} = retime(PeakAmpTable{i},'hourly','mean');
    hourAmp{i}.Time.TimeZone = 'UTC';
    hourEnergy{i} = retime(EnergyTable{i},'hourly','mean');
    hourEnergy{i}.Time.TimeZone = 'UTC';
    %Average it by hour, or minute.
    minuteSnaps{i} = retime(SnapCountTable{i},'minute','sum');
    minuteSnaps{i}.Time.TimeZone = 'UTC';
    minuteAmp{i} = retime(PeakAmpTable{i},'minute','mean');
    minuteAmp{i}.Time.TimeZone = 'UTC';
    minuteEnergy{i} = retime(EnergyTable{i},'minute','mean');
    minuteEnergy{i}.Time.TimeZone = 'UTC';
end

clearvars SnapCountTable PeakAmpTable EnergyTable snapDates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%March 31
cd ([oneDrive,'\acousticAnalysis\windEvent2020Mar31'])
dataFiles = dir('*.txt')
fileNames = {dataFiles.name};
snapRateTables = cell(1, length(fileNames));

originalDatetime= datetime(2020,03,31,0,0,0);

for i = 1:length(fileNames)
snapRateTables{i} = readtable(fileNames{i});
end

snapDates{1}(1:114478,1) = datetime(2020,03,31,0,0,0);
snapDates{1}(114479:262424,1) = datetime(2020,04,01,0,0,0);
snapDates{1}(262425:length(snapRateTables{1}.Selection),1) = datetime(2020,04,02,0,0,0);

snapDates{2}(1:35902,1) = datetime(2020,03,31,0,0,0);
snapDates{2}(35903:81658,1) = datetime(2020,04,01,0,0,0);
snapDates{2}(81659:length(snapRateTables{2}.Selection),1) = datetime(2020,04,02,0,0,0);

snapDates{3}(1:665870,1) = datetime(2020,03,31,0,0,0);
snapDates{3}(665871:1499324,1) = datetime(2020,04,01,0,0,0);
snapDates{3}(1499325:length(snapRateTables{3}.Selection),1) = datetime(2020,04,02,0,0,0);


for i = 1:length(snapRateTables)
    snapRateTables{i}.DateTime = snapDates{i} + snapRateTables{i}.BeginClockTime;

    SnapCountTable{i} = timetable(snapRateTables{i}.DateTime,snapRateTables{i}.Channel)
    SnapCountTable{i}.Properties.VariableNames = {'SnapCount'}
    
    PeakAmpTable{i} = timetable(snapRateTables{i}.DateTime,snapRateTables{i}.PeakAmp_U_)
    PeakAmpTable{i}.Properties.VariableNames = {'PeakAmp'}
    
    EnergyTable{i} = timetable(snapRateTables{i}.DateTime,snapRateTables{i}.Energy_dBFS_)
    EnergyTable{i}.Properties.VariableNames = {'Energy'}

    %Average it by hour, or minute.
    hourSnaps{i} = retime(SnapCountTable{i},'hourly','sum');
    hourSnaps{i}.Time.TimeZone = 'UTC';
    hourAmp{i} = retime(PeakAmpTable{i},'hourly','mean');
    hourAmp{i}.Time.TimeZone = 'UTC';
    hourEnergy{i} = retime(EnergyTable{i},'hourly','mean');
    hourEnergy{i}.Time.TimeZone = 'UTC';
    %Average it by hour, or minute.
    minuteSnaps{i} = retime(SnapCountTable{i},'minute','sum');
    minuteSnaps{i}.Time.TimeZone = 'UTC';
    minuteAmp{i} = retime(PeakAmpTable{i},'minute','mean');
    minuteAmp{i}.Time.TimeZone = 'UTC';
    minuteEnergy{i} = retime(EnergyTable{i},'minute','mean');
    minuteEnergy{i}.Time.TimeZone = 'UTC';
end

clearvars SnapCountTable PeakAmpTable EnergyTable snapDates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Dreaded November 14th
cd ([oneDrive,'\acousticAnalysis\windEvent2020Nov14'])
dataFiles = dir('*.txt')
fileNames = {dataFiles.name};
snapRateTables = cell(1, length(fileNames));

originalDatetime= datetime(2020,11,14,0,0,0);

for i = 1:length(fileNames)
snapRateTables{i} = readtable(fileNames{i});
end

snapDates{1}(1:60306,1) = datetime(2020,11,14,0,0,0);
snapDates{1}(60307:109148,1) = datetime(2020,11,15,0,0,0);
snapDates{1}(109149:376378,1) = datetime(2020,11,16,0,0,0);
snapDates{1}(376379:519430,1) = datetime(2020,11,17,0,0,0);
snapDates{1}(519431:662738,1) = datetime(2020,11,18,0,0,0);
snapDates{1}(662739:797650,1) = datetime(2020,11,19,0,0,0);
snapDates{1}(797651:length(snapRateTables{1}.Selection),1) = datetime(2020,11,20,0,0,0);

snapDates{2}(1:19278,1) = datetime(2020,11,14,0,0,0);
snapDates{2}(19279:67544,1) = datetime(2020,11,15,0,0,0);
snapDates{2}(67545:118090,1) = datetime(2020,11,16,0,0,0);
snapDates{2}(118091:161552,1) = datetime(2020,11,17,0,0,0);
snapDates{2}(161553:202864,1) = datetime(2020,11,18,0,0,0);
snapDates{2}(202865:241536,1) = datetime(2020,11,19,0,0,0);
snapDates{2}(241537:length(snapRateTables{2}.Selection),1) = datetime(2020,11,20,0,0,0);

for i = 1:length(snapRateTables)
    snapRateTables{i}.DateTime = snapDates{i} + snapRateTables{i}.BeginClockTime;

    SnapCountTable{i} = timetable(snapRateTables{i}.DateTime,snapRateTables{i}.Channel)
    SnapCountTable{i}.Properties.VariableNames = {'SnapCount'}
    
    PeakAmpTable{i} = timetable(snapRateTables{i}.DateTime,snapRateTables{i}.PeakAmp_U_)
    PeakAmpTable{i}.Properties.VariableNames = {'PeakAmp'}
    
    EnergyTable{i} = timetable(snapRateTables{i}.DateTime,snapRateTables{i}.Energy_dBFS_)
    EnergyTable{i}.Properties.VariableNames = {'Energy'}

    %Average it by hour, or minute.
    hourSnaps{i} = retime(SnapCountTable{i},'hourly','sum');
    hourSnaps{i}.Time.TimeZone = 'UTC';
    hourAmp{i} = retime(PeakAmpTable{i},'hourly','mean');
    hourAmp{i}.Time.TimeZone = 'UTC';
    hourEnergy{i} = retime(EnergyTable{i},'hourly','mean');
    hourEnergy{i}.Time.TimeZone = 'UTC';
    %Average it by hour, or minute.
    minuteSnaps{i} = retime(SnapCountTable{i},'minute','sum');
    minuteSnaps{i}.Time.TimeZone = 'UTC';
    minuteAmp{i} = retime(PeakAmpTable{i},'minute','mean');
    minuteAmp{i}.Time.TimeZone = 'UTC';
    minuteEnergy{i} = retime(EnergyTable{i},'minute','mean');
    minuteEnergy{i}.Time.TimeZone = 'UTC';
end

clearvars SnapCountTable PeakAmpTable EnergyTable snapDates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
tiledlayout(5,1,'tileSpacing','compact')

% ax1 = nexttile()
% hold on
% for k = 1:length(receiverData)
% plot(receiverData{k}.DT,receiverData{k}.Noise)

ax1 = nexttile()
hold on
plot(receiverData{4}.DT,receiverData{4}.Noise,'k')
title('Noise')

ax2 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd)
hold on
title('Windspeed')

ax3 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.crossShore)
hold on
yline(0)
title('CrossShore Tide')

% 
ax4 = nexttile()
hold on
for i = 1:length(hourSnaps)
plot(minuteSnaps{i}.Time,minuteSnaps{i}.SnapCount)
end
legend({'Mid','High','Low'})
title('SnapRate')

ax5 = nexttile()
hold on
for i = 1:length(hourAmp)
    plot(minuteAmp{i}.Time,minuteAmp{i}.PeakAmp)
end
legend({'Mid','High','Low'})
title('Peak Amplitude')


% ax3 = nexttile()
% for k = 1:length(receiverData)
% plot(receiverData{k}.DT,receiverData{k}.HourlyDets,'r')
% end
% title('Detections')


linkaxes([ax1,ax2,ax3,ax4, ax5],'x')


%%
%Okay, I brute forced it above but with these new huge files I NEEEED to do
%this more efficiently.
%Instead of using clock time, we'll use begin time
cd ([oneDrive,'\acousticAnalysis'])
dataFiles = dir('*.txt')
fileNames = {dataFiles.name};
snapRateTables = cell(1, length(fileNames));

% originalDatetime= datetime(2020,03,31,0,0,0);

for i = 1:length(fileNames)
snapRateTables{i} = readtable(fileNames{i});
end

% Example cell array of filenames
filenames = {'sanctsound_audio_gr01_sanctsound_gr01_04_audio_SanctSound_GR01_04_5421_200302231236.wav.March1000U.txt'};

% Initialize a cell array to store the formatted datetime strings
formattedDates = cell(size(fileNames));

for i = 1:length(fileNames)
    % Extract the date and time portion from the filename
    dateStr = regexp(fileNames{i}, '\d{12}', 'match', 'once');
    
    % Convert the string to a datetime object
    if ~isempty(dateStr)
        % Define the input format of the datetime string
        dt(i,1) = datetime(dateStr, 'InputFormat', 'yyMMddHHmmss');
    else
        % Handle cases where the pattern is not found
        formattedDates{i} = 'Date not found';
    end
end

%Okay, now I have to add seconds.
snapRateTables{1}.EventDateTime = dt + seconds(snapRateTables{1}.BeginTime_s_);
snapRateTables{1}.EventDateTime.Format = 'dd-MMM-yyyy HH:mm:ss.SSS';

