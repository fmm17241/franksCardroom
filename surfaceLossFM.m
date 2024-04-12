%FM 4/2024
%Studying the surface loss code from the acoustics toolbox
U = 2:0.1:12;
AcuteTheta = 45;
ObtuseTheta = 110;
BasicAngle = 90;
LowFreq = 0.6
MidFreq = 2
HighFreq = 69;


calculatedHighFreq      = SurfLoss(BasicAngle, U, HighFreq)
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
plot(U,calculatedLowFreq,'--ob','LineWidth',2)
legend('High Frequency','Low Frequency')


