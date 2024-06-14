
% Must have already run vemprocess on the correct vemco directory.
% fstruct = dbd or sbd, glider data. sstruct = ebd or tbd, glider data. Vems = vem structure

function [transmitters, correctedDN,correctedLat,correctedLon,correctedGPS,scidn,...
    temperature,density,depth,pressure,salt,speed] = processDetections(fstruct,sstruct,vems)

% dtdet = vems.dn;
dtrec = vems.mooredDN;


scidn = sstruct.dn;
[~,ind2,~] = unique(scidn);
scidn = scidn(ind2);
temperature = sstruct.sci_water_temp(ind2);
cond = sstruct.sci_water_cond(ind2);
cndr = ((cond)/(sw_c3515/10));
pressure = sstruct.sci_water_pressure(ind2);
pressure = pressure*10;
index = ~(isnan(temperature) | isnan(pressure)| isnan(cond));
temperature = temperature(index);
pressure = pressure(index);
latmean = nanmean(fstruct.m_gps_lat);
scidn = scidn(index);
% scidn = sstruct.dn(index);
cndr = cndr(index);
salt = sw_salt(cndr,temperature,pressure);
salt(imag(salt) ~= 0) = 0;
density = sw_dens(salt,temperature,pressure);
depth = sw_dpth(pressure,latmean);
speed = sndspd(salt,temperature,depth);

% saltdet = interp1(scidn,salt,dtdet);
% tempdet = interp1(scidn,temperature, dtdet);
% pressdet = interp1(scidn,pressure,dtdet);
% densdet = interp1(scidn,density,dtdet);
% depthdet = interp1(scidn,depth,dtdet);
transmittersalt = interp1(scidn,salt,dtrec);
transmittertemp = interp1(scidn,temperature,dtrec);
transmitterpress = interp1(scidn,pressure,dtrec);
transmitterdensity = interp1(scidn,density,dtrec);
transmitterdepth = interp1(scidn,depth,dtrec);

dn = fstruct.dn;
x = fstruct.m_gps_lat;
y = fstruct.m_gps_lon;
% Strip nans; lat and lon full of them. Around 1 coord set every 4 hours
index = ~(isnan(x) | isnan(y) | isnan(dn));

nanx = isnan(x);
t = 1:numel(x);

x(nanx) = interp1(t(~nanx),x(~nanx),t(nanx));
y(nanx) = interp1(t(~nanx),y(~nanx),t(nanx));


[~, u] = unique(fstruct.dn);
udn = fstruct.dn(u);
% uvx = fstruct.m_final_water_vx(u);
% uvy = fstruct.m_final_water_vy(u);
% waterdepthtemp = fstruct.m_water_depth(u);
xuniq = x(u);
yuniq = y(u);
index = ~(isnan(udn) | isnan(xuniq));
dn = fstruct.dn(index);
% waterdepth = waterdepthtemp(index);
% dt = datetime(dn,'ConvertFrom','datenum');
% vx = fstruct.m_final_water_vx(index);
% vy = fstruct.m_final_water_vy(index);
% vx = fillmissing(vx,'next');
% vy = fillmissing(vy,'next');
xnew = xuniq(index);
ynew = yuniq(index);

correctedDN = (dn(2:end)+dn(1:end-1))/2;
correcttime = datetime(correctedDN,'ConvertFrom','datenum');
% correctedVX = vx(1:end-1);
% correctedVY = vy(1:end-1);
correctedLat = xnew(1:end-1);
correctedLon = ynew(1:end-1);
correctedGPS = [correctedLat,correctedLon];

% currents = [correctedDN correctedVX correctedVY];
% vemsvxall = interp1(correctedDN,correctedVX,vems.dn,'next');
% vemsvyall = interp1(correctedDN,correctedVY,vems.dn,'next');
detectionlat = interp1(correctedDN,correctedLat,vems.mooredDN);
detectionlon = interp1(correctedDN,correctedLon,vems.mooredDN);
%
% testlat = interp1(correctdn,correctlat,vems.dn);
% testlon = interp1(correctdn,correctlon,vems.dn);
%
[~,TransIndex] = unique(vems.mooredDN);
transmitters.DN = vems.mooredDN(TransIndex);
transmitters.datetime = datetime(transmitters.DN,'ConvertFrom','datenum');
% transmitters.tag = vems.mooredTag(TransIndex).';
transmitters.id = vems.mooredID(TransIndex).';
% transmitters.rec = vems.mooredRec(TransIndex).';
% for k =1:length(transmitters.DN)
%     if transmitters.rec(k) == 450282
%        transmitters.UpDown{k,1} = 'UP';
%     elseif transmitters.rec(k) ==450283
%         transmitters.UpDown{k,1} = 'DOWN';
%     end
% end
transmitters.gps_lat = detectionlat(TransIndex);
transmitters.gps_lon = detectionlon(TransIndex);
%
% transmitters.badlat = testlat(TransIndex);
% transmitters.badlon = testlon(TransIndex);
%
% transmitters.vx = interp1(correctedDN,correctedVX,vems.mooredDN,'next');
% transmitters.vx = transmitters.vx(TransIndex);
% transmitters.vy = interp1(correctedDN,correctedVY,vems.mooredDN,'next');
% transmitters.vy = transmitters.vy(TransIndex);
transmitters.density = transmitterdensity(TransIndex);
transmitters.depth = transmitterdepth(TransIndex);
transmitters.press = transmitterpress(TransIndex);
transmitters.salt = transmittersalt(TransIndex);
transmitters.temp = transmittertemp(TransIndex);
spd = sndspd(transmittersalt,transmittertemp,transmitterdepth);
transmitters.speedsound = spd(TransIndex);
transmitters.latmean    = latmean;
% transmitters.waterdepth = waterdepth(TransIndex);
end

