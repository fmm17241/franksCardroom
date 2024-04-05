%FM 4/2024
%Studying the surface loss code from the acoustics toolbox
x = 1: 13;
theta = 90;
freq = 69;
U = [0 1 2 3 4 5 6 7 8 9 10 11 ...
    12 ]


calculatedLoss = SurfLoss(theta, U, freq)

figure()
plot(x,calculatedLoss)
