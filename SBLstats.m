%%
% Okay, I calculated and capped the attenuation at the surface, now I have to
%   figure out what percentage of the difference is from this bubble layer,
%   and whether the snaprate changes.


fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)

%%
% Load in saved data
% Environmental data matched to the hourly snaps.
load envDataSpring
% % Full snaprate dataset
load snapRateDataSpring
% % Snaprate binned hourly
load snapRateHourlySpring
% % Snaprate binned per minute
load snapRateMinuteSpring
load surfaceDataSpring
times = surfaceData.time;
%%
% load envDataFall
% % Full snaprate dataset
% load snapRateDataFall
% % Snaprate binned hourly
% load snapRateHourlyFall
% % Snaprate binned per minute
% load snapRateMinuteFall
% load surfaceDataFall
% times = surfaceData.time;
%%