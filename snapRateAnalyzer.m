%Frank's gotta find times to study with snap rate/frequency

function [snapRateData, snapRateHourly, snapRateMinute] = snapRateAnalyzer(fileDirectory)

%% February 28th
% cd ([oneDrive,'\acousticAnalysis\windEvent2020Feb28'])
cd (fileDirectory)

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

    %There are two rows for each snap, one being waveform, one being
    %spectrogram. I've arbitrarily chosen waveform, this just gives a "1"
    %for each snap so I can find hourly averages.
    SnapCountTable{i} = timetable(waveFormTable{i}.EventDateTime,waveFormTable{i}.Channel,waveFormTable{i}.PeakAmp_U_);
    SnapCountTable{i}.Properties.VariableNames = {'SnapCount','PeakAmp'};
    %
    EnergyTable{i} = timetable(spectrogramTable{i}.EventDateTime,spectrogramTable{i}.Energy_dBFS_,spectrogramTable{i}.PeakPowerDensity_dBFS_Hz_);
    EnergyTable{i}.Properties.VariableNames = {'Energy','PeakPower'};
end

%%
%This is Frank combining the datasets. This only works for the single season, connected files.

for i = 1:length(snapRateTables)
    comboTable{i} = [SnapCountTable{i} EnergyTable{i}];
end



platter = synchronize(comboTable{1},comboTable{2},comboTable{3});

% combinedSnaps = sum([platter, 2, 'omitnan');

index = ismissing(platter(:,{'SnapCount_1','PeakAmp_1','Energy_1','PeakPower_1','SnapCount_2','PeakAmp_2','Energy_2','PeakPower_2','SnapCount_3','PeakAmp_3','Energy_3','PeakPower_3'}));

platter{:,{'SnapCount_1','PeakAmp_1','Energy_1','PeakPower_1','SnapCount_2','PeakAmp_2','Energy_2','PeakPower_2','SnapCount_3','PeakAmp_3','Energy_3','PeakPower_3'}}(index) = 0;

Time = platter.Time;
SnapCount = platter.SnapCount_1 + platter.SnapCount_2 + platter.SnapCount_3;
PeakAmp = platter.PeakAmp_1 + platter.PeakAmp_2 + platter.PeakAmp_3;
Energy = platter.Energy_1 + platter.Energy_2 + platter.Energy_3;
PeakPower = platter.PeakPower_1 + platter.PeakPower_2 + platter.PeakPower_3;

snapRateData = timetable(Time,SnapCount,PeakAmp,Energy,PeakPower)
% snapRateData.Time.TimeZone = 'UTC';
snapRateData.Time.TimeZone = 'UTC';

snapRateHourly = retime(snapRateData, 'hourly', 'mean');
snapRateHourly.SnapCount = retime(snapRateData(:, 'SnapCount'), 'hourly', 'sum').SnapCount;

snapRateMinute = retime(snapRateData, 'minute', 'mean');
snapRateMinute.SnapCount = retime(snapRateData(:, 'SnapCount'), 'minute', 'sum').SnapCount;

%%
%FM This is just for the Spring 2020 dataset, two small times had bad data and so I'm removing those hours.
badTimesMinute = [67554, 79327, 94902, 94903];
badTimesHour    = [1127, 1323, 1582];
if snapRateMinute.Time(1) == '30-Jan-2020 15:12:00.000';
    % Set the rows at the specified indices to NaN, ensuring you use an array of NaNs 
    snapRateMinute(badTimesMinute,:) = array2table(NaN(numel(badTimesMinute), width(snapRateMinute)), ...
                'VariableNames', snapRateMinute.Properties.VariableNames);
    snapRateHourly(badTimesHour,:) = array2table(NaN(numel(badTimesHour), width(snapRateHourly)), ...
                'VariableNames', snapRateHourly.Properties.VariableNames);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%