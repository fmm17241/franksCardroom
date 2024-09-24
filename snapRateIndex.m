%Frank's gotta find times to study with snap rate/frequency

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
%%
for i = 1:length(snapRateTables)

    % Filter rows where the 'View' column contains the string 'Waveform 1'
    waveFormTable{i} = snapRateTables{i}(contains(snapRateTables{i}.View, 'Waveform 1'), :);
    spectrogramTable{i} = snapRateTables{i}(contains(snapRateTables{i}.View, 'Spectrogram 1'), :);

    SnapCountTable{i} = timetable(snapRateTables{i}.EventDateTime,snapRateTables{i}.Channel);
    SnapCountTable{i}.Properties.VariableNames = {'SnapCount'};
    
    PeakAmpTable{i} = timetable(waveFormTable{i}.EventDateTime,waveFormTable{i}.PeakAmp_U_);
    PeakAmpTable{i}.Properties.VariableNames = {'PeakAmp'};
    
    EnergyTable{i} = timetable(spectrogramTable{i}.EventDateTime,spectrogramTable{i}.Energy_dBFS_);
    EnergyTable{i}.Properties.VariableNames = {'Energy'};
end
%%
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

