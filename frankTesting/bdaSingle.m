
%Beam Density Analysis, to run after BELLHOP ray tracing.
function [gridpoints,gridrays,sumRays]= bdaSingle(beamFile, directory)

%Directory should be wherever the .ray files from BELLHOP have been placed.
location = sprintf('%s',directory);

cd (location)

[gridpoints,gridrays,fullRays] = loadrayAuto(beamFile); 
sumRays = fullRays;
end
