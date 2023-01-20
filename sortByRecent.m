datadir = 'G:\Glider\Data\nbdasc\'; %insert datadir here
cd (datadir)

%List the .nbd files, use datenum in the structure to find most recently
%added
dirc=dir('*.nbdasc');
[A,I]=max([dirc(:).datenum]);

if ~isempty(I)
    latestfile = dirc(I).name
end
