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

powerDetsSBLcapped = Coherence_whelch_overlap(envData.HourlyDets,surfaceData.SBLcapped,3600,bins,1,1,1)

%Frank is trying to remove non-significant peaks; it gets furry at the bottom of the Y, let's clean up.
powerDetsSBLcapped.coh(powerDetsSBLcapped.coh < powerDetsSBLcapped.pr95bendat) = 0;

%Frank doing the same for phases
powerDetsSBLcapped.phase(powerDetsSBLcapped.coh < powerDetsSBLcapped.pr95bendat) = 0;


figure()
loglog(powerDetsSBLcapped.f*86400,powerDetsSBLcapped.psda,'k')
hold on
loglog(powerDetsSBLcapped.f*86400,powerDetsSBLcapped.psdb,'r')
legend('Snaprate','SBLoss')

figure()
semilogx(powerDetsSBLcapped.f*86400,powerDetsSBLcapped.coh)
yline(powerDetsSBLcapped.pr95bendat,'-','95%')
title('Coherence - Detections and SBL')



%%
%
[R,P,RL,RU] =corrcoef(surfaceData.WSPD,surfaceData.SBLcapped)

[R,P,RL,RU] =corrcoef(surfaceData.WSPD,surfaceData.SBL)


[R,P,RL,RU]= corrcoef(surfaceData.WSPD,snapRateHourly.SnapCount)
[R,P,RL,RU] = corrcoef(filteredData.Winds,filteredData.Snaps)












