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


%Processs raw .vem files, the outputs of our sensors
cd ([oneDrive,'Glider\Data\Vemco\SpringFallDets'])

vems = vemProcess(pwd);

% 2. Separate the data into single glider yos (yoDefiner or something)
[yoSSP,yotemps,yotimes,yodepths,yosalt,yospeed] = yoDefinerAuto(dn, depth, temperature, salt, speed)

%
% 3. Convert the yo into a sound speed profile (SSP), and format it into a
%       *.env file to feed into Bellhop.
%
% 4. Run Bellhop, tracking beams/arrival times/transmission loss
%
% 5. Publish and graduate



