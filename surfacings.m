%McQuarrie 2021, running scripts at surfacings to model sound speed
%profiles and sound propagation.

%Data directory that holds nbd. Change as needed.
datadir  = 'C:\Users\fmac4\OneDrive - University of Georgia\data\Glider\Data\nbdasc\Test\';

%Reading data out of specific nbd
files = wilddir(datadir, 'nbdasc');-09 8
nfile = size(files,1);
sstruct = read_gliderasc([datadir,files(nfile,:)]);



%Current iteration of Frank's data cleanup
[dn,temperature,salt,density,depth,speed]=beautifyData(sstruct);


%%  Defining single profile, creating SSP
[yoSSP,yotemps,yotimes,yodepths,yosalt,yospeed] = yoDefinerAuto(dn, depth, temperature, salt, speed);


%% Creates and uses Bellhop Environmental File. Saves environmental file, rayfile, and plotted
%Bellhop model into a directory chosen in CreateEnv.

%Directory to put all files; change as needed.
directory = (localPlots);


%Full ray tracing, show all
[waterdepth,beamFile] = ModelSoundSingle(yoSSP,directory);

% FM 8/21: Commented out these sections for now. I want the bellhop to run
% but can't make it find the .ray file thats being created.

% % Beam Density Analysis, finding ray propagation down range
% [gridpoints, gridrays, sumRays] = bdaSingle(beamFile, directory);
% 
% 
% % Beam Density Plot, visualization of the beam density analysis
% bdaPlotSingle(beamFile,gridpoints,sumRays)
% 
% 
% 
% %Gives output file for the yo, giving percentage of rays reaching
% %distances down range, and by proxy estimated detection efficiency.
% [percentage]=writeBDAoutput(sumRays,gridpoints);



