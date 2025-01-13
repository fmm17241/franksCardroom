%%

%Frank getting serious about last chapter. Needs extensive work but looking
%to build off the 2021 WUWnet paper. I'm considering working in Python,
%I'll build my environmental data here then use Python to plot/model.

% Required steps:
% 1. Collect/Create environmental data as a medium for acoustic propagation
datadir = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Chapter5Scenarios\environmentalData\AprilMay2020';
cd (datadir)
load angusdbdAprilMay
load angusebdAprilMay
[matstruct,dn,z,temp] = Bindata(fstruct,sstruct);

%Frank removing extreme outliers before/after mission


% %Reading data out of specific nbd
% files = wilddir(datadir, 'nbdasc');
% nfile = size(files,1);
% sstruct = read_gliderasc([datadir,files(nfile,:)]);



% %Processs raw .vem files, the outputs of our sensors
% cd ([oneDrive,'Glider\Data\Vemco\SpringFallDets'])
% 
% vems = vemProcess(pwd);

%Detection subset, no doubles
% [transmitters, correctedDN,correctedLat,correctedLon,correctedGPS,scidn,...
%     temperature,density,depth,pressure,salt,speed] =processDetections(fstruct,sstruct,vems);

%Used for EBD/TBDs
[dn,scidn,temperature,salt,density,depth,speed]=beautifyGliderData(sstruct);


%Used for NBDs
%[dn,temperature,salt,density,depth,speed]=beautifyData(sstruct);


% 2. Separate the data into single glider yos (yoDefiner or something)
[yoSSP,yotemps,yotimes,yodepths,yosalt,yospeed] = yoDefiner(dn, depth, temperature, salt, speed);

for k = 4000:4200
    figure()
plot(yoSSP{1,k}(:,3),yoSSP{1,k}(:,2))
title(sprintf('My Plot %d',k))

end


%
% 3. Convert the yo into a sound speed profile (SSP), and format it into a
%       *.env file to feed into Bellhop.
%Directory to put all files; change as needed.
directory = (localPlots);

%Full ray tracing, show all
[waterdepth,beamFile] = ModelSoundSingle(yoSSP,directory, datadir);

% 4. Run Bellhop, tracking beams/arrival times/transmission loss
%
% 5. Publish and be happy.


%%
%Previous version from matlab
% %Current iteration of Frank's data cleanup
% [dn,temperature,salt,density,depth,speed]=beautifyData(sstruct);
% %%  Defining single profile, creating SSP
% [yoSSP,yotemps,yotimes,yodepths,yosalt,yospeed] = yoDefinerAuto(dn, depth, temperature, salt, speed);
% %Full ray tracing, show all
% directory = (localPlots);
% [waterdepth,beamFile] = ModelSoundSingle(yoSSP,directory, datadir);
% % Beam Density Analysis, finding ray propagation down range
% [gridpoints, gridrays, sumRays] = bdaSingle(beamFile, directory);
% % Beam Density Plot, visualization of the beam density analysis
% bdaPlotSingle(beamFile,gridpoints,sumRays)
% %Gives output file for the yo, giving percentage of rays reaching
% %distances down range, and by proxy estimated detection efficiency.
% [percentage]=writeBDAoutput(sumRays,gridpoints);






