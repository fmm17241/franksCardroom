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
bins = 6

powerSnapSBLcapped = Coherence_whelch_overlap(snapRateHourly.SnapCount,surfaceData.SBLcapped,3600,bins,1,1,1)


%Frank is trying to remove non-significant peaks; it gets furry at the bottom of the Y, let's clean up.
powerSnapSBLcapped.coh(powerSnapSBLcapped.coh < powerSnapSBLcapped.pr95bendat) = 0;

%Frank doing the same for phases
powerSnapSBLcapped.phase(powerSnapSBLcapped.coh < powerSnapSBLcapped.pr95bendat) = 0;


figure()
loglog(powerSnapSBLcapped.f*86400,powerSnapSBLcapped.psdb)
hold on
loglog(powerSnapSBLcapped.f*86400,powerSnapSBLcapped.psda)

figure()
semilogx(powerSnapSBLcapped.f*86400,powerSnapSBLcapped.coh)


