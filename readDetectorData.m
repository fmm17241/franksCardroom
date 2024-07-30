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

counter      = 0;
audioFiles   = dir('*.txt')
startDT        =
endDT         =
totalSnaps   = 

%
testing = readtable('sanctsound_audio_gr01_sanctsound_gr01_04_audio_SanctSound_GR01_04_5421_200129231235.wav.Table01.txt')
