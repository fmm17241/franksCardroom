
% Must have already run vemProcess on the correct vemco directory.
%Then, load in correct glider data from that mission. This can be done in
%real-time or afterwards.

% fstruct = dbd or sbd, glider data. sstruct = ebd or tbd, glider data. Vems = vem structure


function [detections, detectionReporting] = processDetections(fstruct,sstruct,vems)

%Glider data cleanup; finds unique time values without NaNs.
sciDN = sstruct.dn;
[~,ind2,~] = unique(sciDN);
sciDN = sciDN(ind2);
temperature = sstruct.sci_water_temp(ind2);
cond = sstruct.sci_water_cond(ind2);
cndr = ((cond)/(sw_c3515/10));
pressure = sstruct.sci_water_pressure(ind2);
pressure = pressure*10;
index = ~(isnan(temperature) | isnan(pressure)| isnan(cond));
temperature = temperature(index);
pressure = pressure(index);
latmean = nanmean(fstruct.m_gps_lat);
sciDN = sciDN(index);
cndr = cndr(index);
salt = sw_salt(cndr,temperature,pressure);
salt(imag(salt) ~= 0) = 0;
density = sw_dens(salt,temperature,pressure);
depth = sw_dpth(pressure,latmean);
speed = sndspd(salt,temperature,depth);

%Take the GPS points from the flight side of the glider.
rawDN = fstruct.dn;
rawLat = fstruct.m_gps_lat;
rawLon = fstruct.m_gps_lon;


% Strip nans, and linearly interpolate between surfacings.
knownIndices = ~isnan(rawLat);
nanIndices   = isnan(rawLat);
gliderLat = rawLat;
gliderLon = rawLon;
gliderLat(nanIndices) = interp1(rawDN(knownIndices), rawLat(knownIndices), rawDN(nanIndices), 'linear');
gliderLon(nanIndices) = interp1(rawDN(knownIndices), rawLon(knownIndices), rawDN(nanIndices), 'linear');

%Just the flight pathing.
pathDN = rawDN;
pathDT = datetime(sciDN,'ConvertFrom','datenum');
gliderGPS = [gliderLat,gliderLon];

% I used to take out detections because both receivers caught it, but doing
% to stop doing that for now.
% [~,TransIndex] = unique(vems.dn);
%I'm keeping this one memorialized so I remember how I did it.
% detections.DN = vems.dn(TransIndex);

%Timing of detections
detections.DN = vems.dn;
detections.DT = datetime(detections.DN,'ConvertFrom','datenum');

%The receiver that detected it, and the tag/id of the transmitter.
detections.receiver = vems.rec.';
detections.tag = cell2mat(vems.tag.');
detections.id = cellfun(@str2double,vems.id.');

%Interpolated positioning at time of detection
detections.gps_lat = interp1(pathDN,gliderLat,vems.dn);
detections.gps_lon = interp1(pathDN,gliderLon,vems.dn);

%Environmental context for the detection
detections.density = interp1(sciDN,density,vems.dn);
detections.depth = interp1(sciDN,depth,vems.dn);
detections.pressure = interp1(sciDN,pressure,vems.dn);
detections.salt = interp1(sciDN,salt,vems.dn);
detections.temp = interp1(sciDN,temperature,vems.dn);
detections.speedsound = sndspd(detections.salt,detections.temp,detections.depth);

%One variable. We can play with output, but spits out an array telling us
%the time, identity of receiver and transmitter, GPS of detection, and some
%environmental data.
detectionReporting = table(detections.DT,detections.DN, detections.tag, detections.id, detections.gps_lat, detections.gps_lon, detections.depth, detections.temp, detections.density);
columnLabels = {'TimeUTC','Datenum','Tag','ID','Lat','Lon','Z','Temp','Rho'};
detectionReporting.Properties.VariableNames = columnLabels;
end

