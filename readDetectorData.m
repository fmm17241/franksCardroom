%Frank's analysis. 
function [output] = readDetectorData(fileDirectory)
%Run Raven Pro 1.6's amplitude detector on a 4-hour sanctuary sound file
% 1 ms smoothing, 1000.0 amplitude threshold

%Go to folder containing the detector output files
% cd ([oneDrive,'acousticAnalysis'])
cd (fileDirectory)

%Read in detector tables
%Need to automate the date and time when files start and end
%File has many characters; we need to convert the 10 characters after the
%11th underscore into datetime
audioFiles   = dir('*.txt')
counter      = 0;
startDT        = [];
endDT         = [];
totalSnaps   =  [];

for k = 1:length(audioFiles)                %Loop to process each file
   
    file = audioFiles(k).name;

    % Extract the 12-digit number before ".wav..."
    match = regexp(file, '(\d{12})\.wav', 'tokens');
    
    if ~isempty(match)
        % Convert the matched string to a datetime if necessary
        numStr = match{1}{1};
        disp(['Found number: ', numStr]);
        
        % Example: Convert to datetime if the number represents a timestamp
        dt = datetime(numStr, 'InputFormat', 'yyMMddHHmmss');
        startDT = [startDT; dt];
    else
        disp(['No match found in file name: ', file]);

    end
end




rawFile = cell(1,length(audioFiles));
snapStartDT = cell(1,length(audioFiles));
snapEndDT = cell(1,length(audioFiles));
for k = 1:length(audioFiles)
    rawFile{k} = readtable(audioFiles(k).name)
    % rawFile{k}.Properties.VariableNames = {'Detection','View','Number','Channel','BeginSecs','EndSecs','LowFreq','HighFreq','RMSamp','F-RMSamp','MaxAmp','PeakFreq','PWD'}
    
% Initialize datetime arrays for each file
    snapStartDT{k} = NaT(size(rawFile{k}.BeginTime_s_));
    snapEndDT{k} = NaT(size(rawFile{k}.EndTime_s_));
    
    % Convert BeginSecs and EndSecs to datetime
    for i = 1:length(rawFile{k}.BeginTime_s_)
        snapStartDT{k}(i) = startDT(k) + seconds(rawFile{k}.BeginTime_s_(i));
        snapEndDT{k}(i) = startDT(k) + seconds(rawFile{k}.EndTime_s_(i));
    end
end



% Assume snapStartDT is a cell array of datetime arrays
% Flatten all datetime arrays into one array
allSnaps = vertcat(snapStartDT{:});

% Create an array of hour bins from the earliest to the latest datetime
startHour = dateshift(min(allSnaps), 'start', 'hour');
endHour = dateshift(max(allSnaps), 'start', 'hour') + hours(1);
hourBins = startHour:hours(1):endHour;

% Initialize an array to count snaps per hour
snapsPerHour = zeros(size(hourBins));

% Count the number of snaps in each hour bin
for i = 1:length(hourBins)-1
    snapsPerHour(i) = sum(allSnaps >= hourBins(i) & allSnaps < hourBins(i+1));
end

% Display the results
for i = 1:length(hourBins)-1
    fprintf('Hour starting at %s: %d snaps\n', datestr(hourBins(i)), snapsPerHour(i));
end

%%
%Frank needs to edit:
% Assume rawFile is a cell array of tables read from each file
waveformData = [];
spectrogramData = [];

for k = 1:length(rawFile)
    % Extract the current table
    dataTable = rawFile{k};
    
    % Logical indexing to separate rows by 'View'
    isWaveform = strcmp(dataTable.View, 'Waveform 1');
    isSpectrogram = strcmp(dataTable.View, 'Spectrogram 1');
    
    % Extract Waveform data (X and Y columns)
    waveformData = [waveformData; dataTable(isWaveform, {'Selection','BeginTime_s_', 'EndTime_s_','RMSAmp_U_','F_RMSAmp_U_'})];
    
    % Extract Spectrogram data (A and B columns)
    spectrogramData = [spectrogramData; dataTable(isSpectrogram, {'Selection', 'BeginTime_s_', 'EndTime_s_','PeakFreq_Hz_','PeakPowerDensity_dBFS_Hz_'})];
end

% Display results for verification
disp('Waveform Data:');
disp(waveformData);

disp('Spectrogram Data:');
disp(spectrogramData);





















