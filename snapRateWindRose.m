% Frank's work on Chapter 4. This quantifies and visualizes the wind during
% periods of hydrophone analysis.
%
% Run snapRateAnalyzer and snapRatePlotter. Creates variables:
% 
% envData : cell structure of environmental and detection data during the
% times that we have analyzed hydrophone data.
%
% envData{X}.DT datetime, hourly
% envData{X}.Noise  high-frequency (50-90 khz) noise, averaged hourly
% envData{X}.windSpd  hourly m/s, magnitude
% envData{X}.windDir  dir, wind is GOING TOWARDS, CW from True N
%
%
% hourSnaps : hourly count of snaps at a certain threshold, 1000U if not
% specified.

Options.AngleNorth     = 0;
Options.AngleEast      = 90;
Options.nDirections    = 6;
Options.nSpeeds        = 5;
% Options.
% Options.Labels         = {'N (0Â°)','E (90°)','S (180°)','W (270°)'};
Options.labelnorth     = 'N'
Options.labelsouth     = 'S'
Options.labelwest      = 'W'
Options.labeleast      = 'E'

Options.FreqLabelAngle = 45;

% Properties = {'AngleNorth',0,'AngleEast',90,'nDirections',6,'FreqLabelAngle','ruler'};
for K = 1:length(envData)
    WindRose(envData{K}.windDir,envData{K}.windSpd,Options);
    title(sprintf('WindRose,%d',K))
end





% WindRose(winds.WDIR(1:11349),winds.WSPD(1:11349),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% title('Wind Rose, Winter');
% %Spring March 20th to June 21st 11350:24715
% WindRose(winds.WDIR(11350:24715),winds.WSPD(11350:24715),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% title('Wind Rose, Spring');
% %Summer June 21st to Sept 22nd 24716:37689
% WindRose(winds.WDIR(24716:37689),winds.WSPD(24716:37689),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% title('Wind Rose, Summer');
% %Fall Sept 22nd to December 21st 37689:end
% WindRose(winds.WDIR(37689:end),winds.WSPD(37689:end),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% title('Wind Rose, Fall');
% 
% 
% WindRose(winds.WDIR(1:11349),winds.WSPD(1:11349),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% title('Wind Rose, Winter');
%
