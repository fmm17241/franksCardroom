%McQuarrie 2021
%Plotting the Beam Density Analysis, visualizing the ray propagation.


%beamFile comes from ModelSoundSingle.m
% gridpoints and sumRays comes from bdaSingle.m
function beamDensityPlot(beamFile,gridpoints,sumRays)

figure()
scatter(gridpoints,sumRays);
title('Absence/Presence of Acoustic Rays By Distance');
xlabel('Distance (m)');
ylabel('# of Rays Present');
xticks([0 100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000]);
xtickangle(45);
set(gca, 'YScale', 'log')


end
