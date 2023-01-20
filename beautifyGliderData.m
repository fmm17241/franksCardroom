

function [dn,scidn,temperature,salt,density,depth,speed]=beautifyGliderData(sstruct)

%
startdn = sstruct.dn;
[~,uniqueindex,~] = unique(startdn); %This stops duplicate values
uniquedn = startdn(uniqueindex); %Use new variable name,
firsttemperature = sstruct.sci_water_temp(uniqueindex);
cond = sstruct.sci_water_cond(uniqueindex);
cndr = ((cond)/(sw_c3515/10));
pressure = sstruct.sci_water_pressure(uniqueindex)*10; %Units of pressure are dBars, converting to other units, check SW_density/depth


nanindex = ~(isnan(firsttemperature) | isnan(pressure)| isnan(cond));
temperature = firsttemperature(nanindex);
pressure = pressure(nanindex);
%for latitude, rough estimate at gray's reef rather than read in .dbd
% latmean = nanmean(fstruct.m_gps_lat);
latmean = 31.3960;

dn = uniquedn(nanindex);
scidn = sstruct.dn(nanindex);
cndr = cndr(nanindex);
salt = sw_salt(cndr,temperature,pressure);
% salt(imag(saltfirst) ~= 0) = 0;
density = sw_dens(salt,temperature,pressure);
depth = sw_dpth(pressure,latmean);
speed = sndspd(salt,temperature,depth);

end