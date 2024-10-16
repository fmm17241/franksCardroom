%%
%Frank needs to cut fall at some point. I have lots of snap, wind, and wave data but less noise data from the transceiver.
% Maybe include detections too?

% Load in data.
fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

% Environmental data matched to the hourly snaps.
load envDataFall
% Full snaprate dataset
load snapRateDataFall
% Snaprate binned hourly
load snapRateHourlyFall
% Snaprate binned per minute
load snapRateMinuteFall
% Separate wind and wave data
load surfaceDataFall


surfaceData = surfaceData(1:2078,:);








