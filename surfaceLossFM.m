%FM 4/2024
%Studying the surface loss code from the acoustics toolbox
x = 1: 5;
theta = 90;
freq = 69;
U = [0 2 5 8 12]


calculatedLoss = SurfLoss(theta, U, freq)