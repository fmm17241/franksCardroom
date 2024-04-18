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


