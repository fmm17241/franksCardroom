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
    rawFile{k}.Properties.VariableNames = {'Detection','View','Number','Channel','BeginSecs','EndSecs','LowFreq','HighFreq'}
    
% Initialize datetime arrays for each file
    snapStartDT{k} = NaT(size(rawFile{k}.BeginSecs));
    snapEndDT{k} = NaT(size(rawFile{k}.EndSecs));
    
    % Convert BeginSecs and EndSecs to datetime
    for i = 1:length(rawFile{k}.BeginSecs)
        snapStartDT{k}(i) = startDT(k) + seconds(rawFile{k}.BeginSecs(i));
        snapEndDT{k}(i) = startDT(k) + seconds(rawFile{k}.EndSecs(i));
    end
end

























