%FM 4/2024
%Studying the surface loss code from the acoustics toolbox
x = 2:2:10;
AcuteTheta = 45;
ObtuseTheta = 110;
LowFreq = 0.6
MidFreq = 2
HighFreq = 69;


U = [2 4 6 8 10]


calculatedHighFreqAcute = SurfLoss(AcuteTheta, U, HighFreq)
calculatedHighFreqObtuse = SurfLoss(ObtuseTheta, U, HighFreq)
% calculatedMidFreqAcute = SurfLoss(AcuteTheta, U, MidFreq)
% calculatedMidFreqObtuse = SurfLoss(ObtuseTheta, U, MidFreq)
calculatedLowFreqAcute = SurfLoss(AcuteTheta, U, LowFreq)
calculatedLowFreqObtuse = SurfLoss(ObtuseTheta, U, LowFreq)

figure()
plot(x,calculatedHighFreqAcute,'r')
hold on
plot(x,calculatedLowFreqAcute,'b')
legend('High Frequency','Low Frequency')
ylabel('Noise Loss (dBs)')
xlabel('Windspeed')
title('Loss of Noise at the Surface due to Bubbles')


