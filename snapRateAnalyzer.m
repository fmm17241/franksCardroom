%Frank's gotta find times to study with snap rate/frequency

function [SnapCountTable, snapRateTables, PeakAmpTable, EnergyTable, hourSnaps, hourAmp, hourEnergy, minuteSnaps, minuteAmp, minuteEnergy] = snapRateAnalyzer(fileDirectory)

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
% for i = 1:length(snapRateTables)
% 
%     % Filter rows where the 'View' column contains the string 'Waveform 1'
%     waveFormTable{i} = snapRateTables{i}(contains(snapRateTables{i}.View, 'Waveform 1'), :);
%     spectrogramTable{i} = snapRateTables{i}(contains(snapRateTables{i}.View, 'Spectrogram 1'), :);
% 
%     %There are two rows for each snap, one being waveform, one being
%     %spectrogram. I've arbitrarily chosen waveform, this just gives a "1"
%     %for each snap so I can find hourly averages.
%     SnapCountTable{i} = timetable(waveFormTable{i}.EventDateTime,waveFormTable{i}.Channel);
%     SnapCountTable{i}.Properties.VariableNames = {'SnapCount'};
% 
%     PeakAmpTable{i} = timetable(waveFormTable{i}.EventDateTime,waveFormTable{i}.PeakAmp_U_);
%     PeakAmpTable{i}.Properties.VariableNames = {'PeakAmp'};
% 
%     EnergyTable{i} = timetable(spectrogramTable{i}.EventDateTime,spectrogramTable{i}.Energy_dBFS_);
%     EnergyTable{i}.Properties.VariableNames = {'Energy'};
% end

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



platter = synchronize(comboTable{1},comboTable{2})
% combinedSnaps = sum([platter, 2, 'omitnan');

index = ismissing(platter(:,{'SnapCount_1','PeakAmp_1','Energy_1','PeakPower_1','SnapCount_2','PeakAmp_2','Energy_2','PeakPower_2'}))

platter{:,{'SnapCount_1','PeakAmp_1','Energy_1','PeakPower_1','SnapCount_2','PeakAmp_2','Energy_2','PeakPower_2'}}(index) = 0;

Time = platter.Time;
allSnapCount = platter.SnapCount_1 + platter.SnapCount_2;
allPeakAmp = platter.PeakAmp_1 + platter.PeakAmp_2;
allEnergy = platter.Energy_1 + platter.Energy_2;
allPeakPower = platter.PeakPower_1 + platter.PeakPower_2;

snapRateData = timetable(Time,allSnapCount,allPeakAmp,allEnergy,allPeakPower)


comboTable{i}(index,:) = 0;

%%
for i = 1:length(fileNames)
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

    %Removes outliers, two random huge spikes that appear.
    wayTooHigh = minuteSnaps{i}.SnapCount > 300;
    minuteSnaps{i}.SnapCount(wayTooHigh) = NaN;

    minuteAmp{i} = retime(PeakAmpTable{i},'minute','mean');
    minuteAmp{i}.Time.TimeZone = 'UTC';
    minuteEnergy{i} = retime(EnergyTable{i},'minute','mean');
    minuteEnergy{i}.Time.TimeZone = 'UTC';

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
