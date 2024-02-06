cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\passiveSounds'

%Lists the files in the directory chosen above.
broadBandFiles = dir('*BB*');
octaveFiles = dir('*_ol*');
oneThirdOctaveFiles = dir('*tol*');
psdFiles = dir('*psd*');


%

%Open the files and creates the data

%Broadband
for COUNT = 1:length(broadBandFiles)
    fid = fopen(broadBandFiles(COUNT,1).name);
    indata = textscan(fid, '%s%s', 'HeaderLines',1);
    fclose(fid);
    BBdata{COUNT} = [indata{1}, indata{2}];
end

clear indata

% One Octave
fid = fopen(octaveFiles.name);
indata = textscan(fid, '%s%s%s%s%s%s%s%s%s%s%s', 'HeaderLines',1);
fclose(fid);
OLdata = [indata{1}, indata{2}, indata{3}, indata{4}, indata{5}, indata{6}, indata{7}, indata{8}, indata{9}, indata{10}, indata{11}];
clear indata

% 1/3rd Octave
fid = fopen(oneThirdOctaveFiles.name);
indata = textscan(fid, '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s', 'HeaderLines',1);
fclose(fid);
TOLdata = [indata{1}, indata{2}];
clear indata

% PSD
fid = fopen(psdFiles.name);
indata = textscan(fid, '%s%s', 'HeaderLines',1);
fclose(fid);
PSDdata = [indata{1}, indata{2}];
clear indata




%%