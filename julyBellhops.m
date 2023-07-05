%McQuarrie 2023, changing 'surfacings.m' to experiment with different acoustic environment scenarios. 
% running scripts at surfacings to model sound speed
%profiles and sound propagation.

%Data directory that holds nbd. Change as needed.
datadir  = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test\';


%Reading data out of specific nbd
files = wilddir(datadir, 'nbdasc');
nfile = size(files,1);
sstruct = read_gliderasc([datadir,files(nfile,:)]);



%Current iteration (11/29/2021) of Frank's data cleanup
[dn,temperature,salt,density,depth,speed]=beautifyData(sstruct);


%%  Defining single profile, creating SSP
[yoSSP,yotemps,yotimes,yodepths,yosalt,yospeed] = yoDefinerAuto(dn, depth, temperature, salt, speed);


%% Creates and uses Bellhop Environmental File. Saves environmental file, rayfile, and plotted
%Bellhop model into a directory chosen in CreateEnv.

%Directory to put all files; change as needed.
directory = 'C:\Users\fmm17241\Documents\Plots';


%Full ray tracing, show all
[waterdepth,beamFile] = ModelSoundSingle(yoSSP,directory);


% Beam Density Analysis, finding ray propagation down range
[gridpoints, gridrays, sumRays] = bdaSingle(beamFile, directory);


% Beam Density Plot, visualization of the beam density analysis
bdaPlotSingle(beamFile,gridpoints,sumRays)



%Gives output file for the yo, giving percentage of rays reaching
%distances down range, and by proxy estimated detection efficiency.
[percentage]=writeBDAoutput(sumRays,gridpoints);