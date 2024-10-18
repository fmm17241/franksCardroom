%FM 4/2024
%Studying the surface loss code from the acoustics toolbox

x = 2:2:10;
U = 2:0.1:12;

AcuteTheta = 45;
ObtuseTheta = 110;
BasicAngle = 90;
LowFreq = 0.26;
MidFreq = 17;
HighFreq = 69;


calculatedHighFreq      = SurfLoss(BasicAngle, U, HighFreq)
calculatedMidFreq      = SurfLoss(BasicAngle, U, MidFreq)
calculatedLowFreq      = SurfLoss(BasicAngle, U, LowFreq)


calculatedHighFreqAcute = SurfLoss(AcuteTheta, U, HighFreq)
calculatedHighFreqObtuse = SurfLoss(ObtuseTheta, U, HighFreq)
% calculatedMidFreqAcute = SurfLoss(AcuteTheta, U, MidFreq)
% calculatedMidFreqObtuse = SurfLoss(ObtuseTheta, U, MidFreq)
calculatedLowFreqAcute = SurfLoss(AcuteTheta, U, LowFreq)
calculatedLowFreqObtuse = SurfLoss(ObtuseTheta, U, LowFreq)

figure()
plot(U,calculatedHighFreq,'r','LineWidth',2)
hold on
plot(U,calculatedMidFreq,'--sqk','LineWidth',2)
plot(U,calculatedLowFreq,'--ob','LineWidth',2)
legend('High Frequency','Mid Frequency','Low Frequency')
ylabel('Noise Loss (dBs)')
xlabel('Windspeed')
title('Loss of Noise at the Surface due to Bubbles')


% exportgraphics(gcf,'NoiseLoss.png')
U = [3, 10];
AcuteTheta = 45;
ObtuseTheta = 110;
LowFreq = 0.26;
MidFreq = 17;
HighFreq = 69;


calculatedHighFreqAcute = SurfLoss(AcuteTheta, U, HighFreq)
calculatedHighFreqObtuse = SurfLoss(ObtuseTheta, U, HighFreq)
calculatedMidFreqAcute = SurfLoss(AcuteTheta, U, MidFreq)
calculatedMidFreqObtuse = SurfLoss(ObtuseTheta, U, MidFreq)
calculatedLowFreqAcute = SurfLoss(AcuteTheta, U, LowFreq)
calculatedLowFreqObtuse = SurfLoss(ObtuseTheta, U, LowFreq)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Installed the Phased Array System Toolbox in Matlab
%Looking at albersheim and range2tl

%Albersheim equation

SNR (dB) = -5log110(N) + [6.2 + 4.54/N + 044]log10(A+0.12AB-1.7B)

% Where 
% N = Number of noncoherently integrated samples
% A = ln(0.62 * Pfa)
% B = ln(Pd/(1-Pd))


albersheim


freq2wavelen

%This calculates the SNR threshold T (in dB) to detect a signal, given a certain probability
% of false alarm (PFA), the number of pulses (N), coherent/noncoherent.

[threshold] = npwgnthresh(0.01,8,'coherent')


rocpfa
rocsnr

tl2range
range2tl
spectrogram




phased.UnderwaterRadiatedNoise


%%
% Frank adding losses
fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)


% load envDataFall
% % Full snaprate dataset
% load snapRateDataFall
% % Snaprate binned hourly
% load snapRateHourlyFall
% % Snaprate binned per minute
% load snapRateMinuteFall
% load surfaceDataFall
% times = surfaceData.time;
% 
% %This is Frank pruning from Sept-Feb to Sept-Dec.
% if length(surfaceData.time) == 3308
%     surfaceData = surfaceData(1:2078,:);
%     snapRateHourly = snapRateHourly(1:2078,:);
% end
% times = surfaceData.time;

% Load in saved data
% Environmental data matched to the hourly snaps.
load envDataSpring
% Full snaprate dataset
load snapRateDataSpring
% Snaprate binned hourly
load snapRateHourlySpring
% Snaprate binned per minute
load snapRateMinuteSpring
load surfaceDataSpring
times = surfaceData.time;

% surface loss
% bubble losses are assumed to be the dominant effect for the total field
% (as opposed to just the coherent field)
% see the discussion in
% High-Frequency Ocean Environmental Acoustic Models Handbook

% theta = grazing angle (degrees)
directAngle = 20
midAngle = 90
grazingAngle = 130;
% U     = wind speed (m/s)
U = surfaceData.WSPD;
% f     = frequency (kHz)
f = 69;
% LOSS   = surface bubble loss (dB)

LOSS = SurfLoss(midAngle, U, f );

index = LOSS > 40;


% UWAPL gives a suggestion to cap the upper limit of SBL at 15 dB. Believe this is outdated.
% Chua et al 2018, -40 dB is more recent and is more intuitive. 
cappedLOSS = LOSS; cappedLOSS(index) = 40;

%at midAngle, cap is at 9+ m/s

figure()
plot(times,LOSS,'k')
hold on
plot(times,cappedLOSS,'r')


% WOWWWW!!!!!
[a,b] = corrcoef(cappedLOSS,envData.Noise)
[a,b] = corrcoef(LOSS,envData.Noise)


figure()
scatter(LOSS,envData.Noise)

surfaceData.SBL = LOSS;
surfaceData.SBLcapped = cappedLOSS;
