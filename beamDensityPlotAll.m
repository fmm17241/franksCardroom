%

function beamDensityPlotAll(beamFiles,gridpoints,sumRays)

howmany = length(beamFiles);

figure()
hold on
for k=1:howmany
    scatter(gridpoints,sumRays{k});
    title('Absence/Presence of Acoustic Rays By Distance');
    xlabel('Distance (m)');
    ylabel('# of Rays Present');
    xticks([0 100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000]);
    xtickangle(45);
    set(gca, 'YScale', 'log')
end
hold off
end
