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
shnidman

freq2wavelen
npwgnthresh
rocpfa
rocsnr

tl2range
range2tl
spectrogram

cranerainpl

phased.IsoSpeedUnderwaterPaths
phased.UnderwaterRadiatedNoise


%
nsamp = 100;
x = exp(1i*2*pi*rand(nsamp,1));

linspectrum = gausswin(nsamp);
spectrum = mag2db(linspectrum);
[y,info] = shapespectrum(spectrum,x,DesiredSpectrumRange="centered");


shapespectrum(spectrum,x,DesiredSpectrumRange="centered")

