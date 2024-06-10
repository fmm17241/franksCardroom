

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data'

%Build the map
load contourinfo
yes=figure()
hb=plot(coastline.x,coastline.y,'k'); set(hb,'linewidth',2); hold on;
axis equal
hold on
xlabel('Longitude');
ylabel('Latitude');
title('SAB Ben Work');
for i=1:length(bathymetry)
  hc(i)=line(bathymetry(i).x(:),bathymetry(i).y(:),'color',[.6 .6 .6],'LineWidth',0.5);
end
SkiO = [31.988137878676937, -81.0219881445705]
scatter(SkiO(2),SkiO(1),600,'r','p','filled');
%%

load September_21_salacia_dbds.mat
load September_21_salacia_ebds.mat


[matstruct,dn,z,temp,rho] = Bindata(fstruct,sstruct);





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

benVariable = timetable(correcttime,correctedLat,correctedLon,)


dtSep21 = datetime(fstruct.dn,'convertfrom','datenum');
hold on
plot(correctedLon,correctedLat,'r')
title('SAB Ben Work: Sep 25-Nov 02, 2021')


load November_21_angus_dbds.mat
load November_21_angus_ebds.mat

load July_21_franklin_dbds.mat
load July_21_franklin_ebds.mat

load September_21_salacia_dbds.mat
load September_21_salacia_ebds.mat
