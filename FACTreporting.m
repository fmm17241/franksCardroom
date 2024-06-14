%Frank figuring out how to efficiently report our detections

% vemdir = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\Vemco'
vemdir = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\Vemco\franklin20190621'

%Starting line: feed it where the .vem files are.
[vems] = vemProcess(vemdir)
% or vemprocessSignle


%Now, have to contextualize them.
load Deployment_May_2019_franklin_sbds.mat
load Deployment_May_2019_franklin_tbds.mat



[detections, detectionReporting, detectionDN,detectionLat,detectionLon,detectionGPS,gliderDN,...
    temperature,density,depth,pressure,salt,speed] = processDetections(fstruct,sstruct,vems);

