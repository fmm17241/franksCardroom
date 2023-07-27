
%Beam Density Analysis, to run after BELLHOP ray tracing.
function [gridpoints,gridrays,sumRays]= beamDensityAnalysis(beamFiles, directory, typevariable)

%Type variable defines how BELLHOP was run.
if any((typevariable ~= 'E') & (typevariable ~= 'R') & (typevariable ~= 'C') )
       fprintf('ERROR:You entered incorrect choice for typevariable, give ''E'', ''R'', or ''C''.')
       return
end
%Directory should be wherever the .ray files from BELLHOP have been placed.
location = sprintf('%s\\%s',directory,(typevariable));

cd (location)

howmany=length(beamFiles);
sumRays=cell(1,1);
    for k=1:howmany
        whichBeamfile=sprintf('%s',beamFiles{k});
        [gridpoints,gridrays,fullRays] = loadrayAuto(whichBeamfile); 
        sumRays{k} = fullRays;
    end
end
