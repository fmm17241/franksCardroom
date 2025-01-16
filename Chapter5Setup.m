%%

%Frank getting serious about last chapter. Needs extensive work but looking
%to build off the 2021 WUWnet paper. I'm considering working in Python,
%I'll build my environmental data here then use Python to plot/model.

% Required steps:
% 1. Collect/Create environmental data as a medium for acoustic propagation
% datadir = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Chapter5Scenarios\environmentalData\AprilMay2020';
datadir = 'C:\Users\fmac4\OneDrive - University of Georgia\data\Chapter5Scenarios\environmentalData\November2019';

cd (datadir)
% load angusdbdAprilMay
% load angusebdAprilMay
load nov19dbd
load nov19ebd

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
% count =1;

for k = 1:10:length(yoSSP)
    if k == 1
        count = 1;
    else
        count = count+1;
    end
    %
    time = datetime(yoSSP{1,k}(:,1),'convertfrom','datenum');
    sspExample{count} = timetable(time,yoSSP{1,k}(:,2),yoSSP{1,k}(:,3));
    sspExample{count}.Properties.VariableNames = {'Depth', 'SoundSpeed'};
end


%find SSPs that are deepest
for ex = 1:length(sspExample)
    maxDepth(ex) = max(sspExample{1,ex}.Depth);
end

indexx = maxDepth >= 17;

deepSSPs = sspExample(indexx);

depths = 0:0.5:20;



% 
for k = 1:length(deepSSPs)
    figure()
    plot(deepSSPs{1,k}.SoundSpeed,deepSSPs{1,k}.Depth)
    title(sprintf('My Plot %d',k))
    set(gca,'ydir','reverse')
end




figure()
plot(ssp{1}.SoundSpeed,ssp{1}.Depth)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NOVEMBER 2019
%Pruning, monotonic.
ssp{1} = deepSSPs{1};
ssp{2} = deepSSPs{3};
ssp{3} = deepSSPs{5};
ssp{4} = deepSSPs{6};
ssp{5} = deepSSPs{7};
ssp{6} = deepSSPs{8};
ssp{7} = deepSSPs{11};
ssp{8} = deepSSPs{12};


for K = 1:8
    cutoffTop = min(ssp{K}.Depth);
    cutoffBot = max(ssp{K}.Depth);
    %
    surface_depths{K} = [0:0.2:cutoffTop]; % Replace with your surface depth increments
    bottom_depths{K} = [cutoffBot:0.2:20]; % Replace with your bottom depth increments
    %
    interpolated_surface{K} = interp1(ssp{K}.Depth, ssp{K}.SoundSpeed, surface_depths{K}, 'linear', 'extrap');
    interpolated_bottom{K} = interp1(ssp{K}.Depth, ssp{K}.SoundSpeed, bottom_depths{K}, 'linear', 'extrap');
    
    % Combine original and interpolated data
    completeSSP{K}(:,1) = [surface_depths{K}'; ssp{K}.Depth; bottom_depths{K}'];
    completeSSP{K}(:,2) = [interpolated_surface{K}'; ssp{K}.SoundSpeed; interpolated_bottom{K}'];

    figure()
    plot(completeSSP{K}(:,2),completeSSP{K}(:,1),'LineWidth',2)
    title(sprintf('DeepSSP %d',K))
    set(gca,'ydir','reverse')
end


completeSSP{7}(1:18,2) = 1517.73;
completeSSP{6}(1:16,2) = 1520.00;
completeSSP{5}(1:19,2) = 1519.36;
completeSSP{4}(82:end,2) = 1519.64;
completeSSP{3}(1:18,2) = 1519.3;
completeSSP{1}(1:19,2) = 1521.49;


figure()
Tiled = tiledlayout(4,2)
ax1 = nexttile([1,1])
plot(completeSSP{1}(:,2),completeSSP{1}(:,1),'LineWidth',2)
title(sprintf('SSP1: November 16, 2019 11:55',8))
set(gca,'ydir','reverse')
xlim([1516 1522])
ylabel('Depth (m)')

ax2 = nexttile([1,1])
plot(completeSSP{2}(:,2),completeSSP{2}(:,1),'LineWidth',2)
title(sprintf('SSP2: November 16, 2019 19:55',8))
set(gca,'ydir','reverse')
xlim([1516 1522])

ax3 = nexttile([1,1])
plot(completeSSP{3}(:,2),completeSSP{3}(:,1),'LineWidth',2)
title(sprintf('SSP3: November 18, 2019 10:26',8))
set(gca,'ydir','reverse')
xlim([1516 1522])
ylabel('Depth (m)')

ax4 = nexttile([1,1])
plot(completeSSP{4}(:,2),completeSSP{4}(:,1),'LineWidth',2)
title(sprintf('SSP4: November 18, 2019 12:05',8))
set(gca,'ydir','reverse')
xlim([1516 1522])

ax5 = nexttile([1,1])
plot(completeSSP{5}(:,2),completeSSP{5}(:,1),'LineWidth',2)
title(sprintf('SSP5: November 18, 2019 12:48',8))
set(gca,'ydir','reverse')
xlim([1516 1522])
ylabel('Depth (m)')

ax6 = nexttile([1,1])
plot(completeSSP{6}(:,2),completeSSP{6}(:,1),'LineWidth',2)
title(sprintf('SSP6: November 18, 2019 14:50',8))
set(gca,'ydir','reverse')
xlim([1516 1522])

ax7 = nexttile([1,1])
plot(completeSSP{7}(:,2),completeSSP{7}(:,1),'LineWidth',2)
title(sprintf('SSP7: November 21, 2019 11:04',8))
set(gca,'ydir','reverse')
xlim([1516 1522])
ylabel('Depth (m)')
xlabel('Sound Speed Profile (m/s)')

ax8 = nexttile([1,1])
plot(completeSSP{8}(:,2),completeSSP{8}(:,1),'LineWidth',2)
title(sprintf('SSP8: November 25, 2019 14:09',8))
set(gca,'ydir','reverse')
xlim([1516 1522])
xlabel('Sound Speed Profile (m/s)')



cd 'C:\Users\fmac4\OneDrive - University of Georgia\data\Chapter5Scenarios\SSPs\november'
writematrix(completeSSP{1}, 'ssp1.csv');
writematrix(completeSSP{2}, 'ssp2.csv');
writematrix(completeSSP{3}, 'ssp3.csv');
writematrix(completeSSP{4}, 'ssp4.csv');
writematrix(completeSSP{5}, 'ssp5.csv');
writematrix(completeSSP{6}, 'ssp6.csv');
writematrix(completeSSP{7}, 'ssp7.csv');
writematrix(completeSSP{8}, 'ssp8.csv');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% APRIL/MAY

ssp{1} = deepSSPs{2};
ssp{2} = deepSSPs{4};
ssp{3} = deepSSPs{5};
ssp{4} = deepSSPs{8};
ssp{5} = deepSSPs{9};
ssp{6} = deepSSPs{11};
ssp{7} = deepSSPs{12};
ssp{8} = deepSSPs{13};

% Frank adding top and bottom to the profiles due to the glider inflections.
%Had to remove some repeat rows, one in ssp7 (ssp{1, 7}(79,:) = [];) 
% and two in ssp8 (ssp{1, 8}(32,:) = []; ssp{1, 8}(41,:) = [];)
for K = 1:8
    cutoffTop = min(ssp{K}.Depth);
    cutoffBot = max(ssp{K}.Depth);
    %
    surface_depths{K} = [0:0.2:cutoffTop]; % Replace with your surface depth increments
    bottom_depths{K} = [cutoffBot:0.2:20]; % Replace with your bottom depth increments
    %
    interpolated_surface{K} = interp1(ssp{K}.Depth, ssp{K}.SoundSpeed, surface_depths{K}, 'linear', 'extrap');
    interpolated_bottom{K} = interp1(ssp{K}.Depth, ssp{K}.SoundSpeed, bottom_depths{K}, 'linear', 'extrap');
    
    % Combine original and interpolated data
    completeSSP{K}(:,1) = [surface_depths{K}'; ssp{K}.Depth; bottom_depths{K}'];
    completeSSP{K}(:,2) = [interpolated_surface{K}'; ssp{K}.SoundSpeed; interpolated_bottom{K}'];

    figure()
    plot(completeSSP{K}(:,2),completeSSP{K}(:,1),'LineWidth',2)
    title(sprintf('DeepSSP %d',K))
    set(gca,'ydir','reverse')
end
% Manually pruning some that had bad interpolated fits.
completeSSP{1}(1:22,2) = 1521.24
figure()
plot(completeSSP{1}(:,2),completeSSP{1}(:,1),'LineWidth',2)
title(sprintf('DeepSSP %d',1))
set(gca,'ydir','reverse')

completeSSP{3}(1:22,2) = 1520.93
figure()
plot(completeSSP{3}(:,2),completeSSP{3}(:,1),'LineWidth',2)
title(sprintf('DeepSSP %d',3))
set(gca,'ydir','reverse')

completeSSP{6}(1:15,2) = 1526.00
completeSSP{6}(91:end,2) = 1524.95

figure()
plot(completeSSP{6}(:,2),completeSSP{6}(:,1),'LineWidth',2)
title(sprintf('DeepSSP %d',6))
set(gca,'ydir','reverse')

completeSSP{8}(1:19,2) = 1524.75

figure()
plot(completeSSP{8}(:,2),completeSSP{8}(:,1),'LineWidth',2)
title(sprintf('DeepSSP %d',8))
set(gca,'ydir','reverse')
%%

figure()
Tiled = tiledlayout(4,2)
ax1 = nexttile([1,1])
plot(completeSSP{1}(:,2),completeSSP{1}(:,1),'LineWidth',2)
title(sprintf('SSP1: April 21, 2020 23:43',8))
set(gca,'ydir','reverse')
xlim([1520 1526])
ylabel('Depth (m)')

ax2 = nexttile([1,1])
plot(completeSSP{2}(:,2),completeSSP{2}(:,1),'LineWidth',2)
title(sprintf('SSP2: April 22, 2020 03:07',8))
set(gca,'ydir','reverse')
xlim([1520 1526])

ax3 = nexttile([1,1])
plot(completeSSP{3}(:,2),completeSSP{3}(:,1),'LineWidth',2)
title(sprintf('SSP3: April 22, 2020 05:36',8))
set(gca,'ydir','reverse')
xlim([1520 1526])
ylabel('Depth (m)')

ax4 = nexttile([1,1])
plot(completeSSP{4}(:,2),completeSSP{4}(:,1),'LineWidth',2)
title(sprintf('SSP4: April 30, 2020 06:02',8))
set(gca,'ydir','reverse')
xlim([1520 1526])

ax5 = nexttile([1,1])
plot(completeSSP{5}(:,2),completeSSP{5}(:,1),'LineWidth',2)
title(sprintf('SSP5: May 2, 2020 21:15',8))
set(gca,'ydir','reverse')
xlim([1520 1526])
ylabel('Depth (m)')

ax6 = nexttile([1,1])
plot(completeSSP{6}(:,2),completeSSP{6}(:,1),'LineWidth',2)
title(sprintf('SSP6: May 2, 2020 22:53',8))
set(gca,'ydir','reverse')
xlim([1520 1526])

ax7 = nexttile([1,1])
plot(completeSSP{7}(:,2),completeSSP{7}(:,1),'LineWidth',2)
title(sprintf('SSP7: May 4, 2020 19:29',8))
set(gca,'ydir','reverse')
xlim([1520 1526])
ylabel('Depth (m)')
xlabel('Sound Speed Profile (m/s)')

ax8 = nexttile([1,1])
plot(completeSSP{8}(:,2),completeSSP{8}(:,1),'LineWidth',2)
title(sprintf('SSP8: May 4, 2020 22:05',8))
set(gca,'ydir','reverse')
xlim([1520 1526])
xlabel('Sound Speed Profile (m/s)')

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Chapter5Scenarios\SSPs'
writematrix(completeSSP{1}, 'ssp1.csv');
writematrix(completeSSP{2}, 'ssp2.csv');
writematrix(completeSSP{3}, 'ssp3.csv');
writematrix(completeSSP{4}, 'ssp4.csv');
writematrix(completeSSP{5}, 'ssp5.csv');
writematrix(completeSSP{6}, 'ssp6.csv');
writematrix(completeSSP{7}, 'ssp7.csv');
writematrix(completeSSP{8}, 'ssp8.csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%
% Alright, now I've gotta figure out which ones and how to move it to Python for processing. 
% Matlab's Bellhop can work, but I believe Python will be smoother and prettier.

%List of some sspExample{1,X} that I want:
% 14, 180/181, 189, 247, 297, 413, 496, 498, 547, 544, 556, 561,..
%   572, 578, 598, 721, 763, 817


examples = [14; 180; 189; 247; 297; 496; 547; 556; 561; 572; 721; 763; 817];

for ex = 1:length(examples)
    figure()
    plot(sspExample{1,examples(ex)}.SoundSpeed,sspExample{1,examples(ex)}.Depth)
    title('Example of a Sound Speed Profile')
    set(gca,'ydir','reverse')
end

%find SSPs that are deepest
for ex = 1:length(examples)
    maxDepth(ex) = max(sspExample{ex}.Depth);
end




save('sspExamples.mat','sspExample')


%
% 3. Convert the yo into a sound speed profile (SSP), and format it into a
%       *.env file to feed into Bellhop.
%Directory to put all files; change as needed.
directory = (localPlots);

%Full ray tracing, show all
[waterdepth,beamFile] = ModelSoundSingle(yoSSP{5},directory, datadir);

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


%%%%%%%%%%%%%%%%%%%%%%%%%
%Lets try summer
cd 'C:\Users\fmac4\OneDrive - University of Georgia\data'
load Summer_2019_angus_dbds.mat
load Summer_2019_angus_ebds.mat


[matstruct,dn,z,temp] = Bindata(fstruct,sstruct);


%Used for EBD/TBDs
[dn,scidn,temperature,salt,density,depth,speed]=beautifyGliderData(sstruct);


%Used for NBDs
%[dn,temperature,salt,density,depth,speed]=beautifyData(sstruct);


% 2. Separate the data into single glider yos (yoDefiner or something)
[yoSSP,yotemps,yotimes,yodepths,yosalt,yospeed] = yoDefiner(dn, depth, temperature, salt, speed);
% count =1;

for k = 1:10:length(yoSSP)
    if k == 1
        count = 1;
    else
        count = count+1;
    end
    %
    time = datetime(yoSSP{1,k}(:,1),'convertfrom','datenum');
    sspExample{count} = timetable(time,yoSSP{1,k}(:,2),yoSSP{1,k}(:,3));
    sspExample{count}.Properties.VariableNames = {'Depth', 'SoundSpeed'};
end


%find SSPs that are deepest
for ex = 1:length(sspExample)
    maxDepth(ex) = max(sspExample{1,ex}.Depth);
end

indexx = maxDepth >= 17;

deepSSPs = sspExample(indexx);

depths = 0:0.5:20;



