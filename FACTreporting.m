%Frank figuring out how to efficiently report our detections

% vemdir = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\Vemco'
vemdir = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\Vemco\angus20190621'

%Starting line: feed it where the .vem files are.
[vems] = vemProcess(vemdir)
% or vemprocessSignle


%Now, have to contextualize them.





[transmitters, correctedDN,correctedLat,correctedLon,correctedGPS,scidn,...
    temperature,density,depth,pressure,salt,speed] = processDetections(fstruct,sstruct,vems)

