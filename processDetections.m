
% Must have already run vemProcess on the correct vemco directory.
%Then, load in correct glider data from that mission. This can be done in
%real-time or afterwards.

% fstruct = dbd or sbd, glider data. sstruct = ebd or tbd, glider data. Vems = vem structure

function [detections, detectionReporting, detectionDN,gliderLat,gliderLon,gliderGPS,gliderDN,...
    temperature,density,depth,pressure,salt,speed] = processDetections(fstruct,sstruct,vems)

%Detection datenums from glider
detectionTime = vems.dn;

%Glider data cleanup; finds unique time values without NaNs.
gliderDN = sstruct.dn;
[~,ind2,~] = unique(gliderDN);
gliderDN = gliderDN(ind2);
temperature = sstruct.sci_water_temp(ind2);
cond = sstruct.sci_water_cond(ind2);
cndr = ((cond)/(sw_c3515/10));
pressure = sstruct.sci_water_pressure(ind2);
pressure = pressure*10;
index = ~(isnan(temperature) | isnan(pressure)| isnan(cond));
temperature = temperature(index);
pressure = pressure(index);
latmean = nanmean(fstruct.m_gps_lat);
gliderDN = gliderDN(index);
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


% Strip nans, and interpolate to make it complete
knownIndices = ~isnan(rawLat);
nanIndices   = isnan(rawLat);
Lat = rawLat;
Lon = rawLon;
Lat(nanIndices) = interp1(rawDN(knownIndices), rawLat(knownIndices), rawDN(nanIndices), 'linear');
Lon(nanIndices) = interp1(rawDN(knownIndices), rawLon(knownIndices), rawDN(nanIndices), 'linear');


detectionDN = rawDN;
detectionDT = datetime(detectionDN,'ConvertFrom','datenum');
gliderLat = Lat(1:end-1);
gliderLon = Lon(1:end-1);
gliderGPS = [gliderLat,gliderLon];

detectionlat = interp1(detectionDN,gliderLat,vems.dn);
detectionlon = interp1(detectionDN,gliderLon,vems.dn);

% I used to take out detections because both receivers caught it, but doing
% to stop doing that for now.
% [~,TransIndex] = unique(vems.dn);
%I'm keeping this one memorialized so I remember how I did it.
% detections.DN = vems.dn(TransIndex);

detectionSalt = interp1(gliderDN,salt,detectionTime);
detectionTemp = interp1(gliderDN,temperature,detectionTime);
detectionPress = interp1(gliderDN,pressure,detectionTime);
detectionDensity = interp1(gliderDN,density,detectionTime);
detectionDepth = interp1(gliderDN,depth,detectionTime);



detections.DN = vems.dn;
detections.DT = datetime(detections.DN,'ConvertFrom','datenum');

detections.receiver = vems.rec.';
detections.tag = cell2mat(vems.tag.');
detections.id = cellfun(@str2double,vems.id.');
detections.gps_lat = detectionlat;
detections.gps_lon = detectionlon;


detections.density = detectionDensity;
detections.depth = detectionDepth;
detections.press = detectionPress;
detections.salt = detectionSalt;
detections.temp = detectionTemp;
spd = sndspd(detectionSalt,detectionTemp,detectionDepth);
detections.speedsound = spd;
detections.latmean    = latmean;

detectionReporting = [detections.DN, detections.id, detections.gps_lat, detections.gps_lon, detections.depth, detections.temp, detections.density]
end

