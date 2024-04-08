%FM 4/2024
%Studying the surface loss code from the acoustics toolbox
x = 1: 6;
AcuteTheta = 45;
ObtuseTheta = 110;
LowFreq = 0.6
MidFreq = 2
HighFreq = 69;


U = [4 10]


calculatedHighFreqAcute = SurfLoss(AcuteTheta, U, HighFreq)
calculatedHighFreqObtuse = SurfLoss(ObtuseTheta, U, HighFreq)
% calculatedMidFreqAcute = SurfLoss(AcuteTheta, U, MidFreq)
% calculatedMidFreqObtuse = SurfLoss(ObtuseTheta, U, MidFreq)
calculatedLowFreqAcute = SurfLoss(AcuteTheta, U, LowFreq)
calculatedLowFreqObtuse = SurfLoss(ObtuseTheta, U, LowFreq)

figure()
plot(x,calculatedHighFreqLoss,'r')
hold on
plot(x,calculatedLowFreqLoss,'b')
legend('High Frequency','Low Frequency')


