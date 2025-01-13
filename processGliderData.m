function [DT,temperature,density,depth,pressure,salt,speed,gliderGPS] = processGliderData(fstruct,sstruct)

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
rawDT = datetime(fstruct.dn,'convertfrom','datenum');
[~,uniqIndex] = unique(rawDT);
uniqueDT = rawDT(uniqIndex);


gliderLat = fstruct.m_gps_lat(uniqIndex);
gliderLon = fstruct.m_gps_lon(uniqIndex);


% Strip nans, and linearly interpolate between surfacings.
knownIndices = ~isnan(gliderLat);
nanIndices   = isnan(gliderLat);
gliderLat(nanIndices) = interp1(uniqueDT(knownIndices), gliderLat(knownIndices), uniqueDT(nanIndices), 'linear');
gliderLon(nanIndices) = interp1(uniqueDT(knownIndices), gliderLon(knownIndices), uniqueDT(nanIndices), 'linear');

%Just the flight pathing.
DT = uniqueDT;
% pathDT = datetime(sciDN,'ConvertFrom','datenum');
gliderGPS = [gliderLat; gliderLon];
