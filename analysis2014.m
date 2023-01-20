cd G:\Glider\Data\ADCP\
load 'GR_adcp_30minave_magrot.mat'


cd G:\Glider\Data\Modena\
load modena2014DBD.mat
load modena2014EBD.mat

index = ~(isnan(sstruct.sci_water_temp) | isnan(sstruct.sci_water_pressure) | isnan(sstruct.sci_water_cond)) ;

temp = sstruct.sci_water_temp(index);
cond = sstruct.sci_water_cond(index);
cndr = ((cond)/(sw_c3515/10));
pressur = sstruct.sci_water_pressure(index);
pressure = pressur*10;
datenum = sstruct.dn(index);
latmean = nanmean(fstruct.m_gps_lat);
salt = sw_salt(cndr,temp,pressure);
salt(imag(salt) ~= 0) = 0;
density = sw_dens(salt,temp,pressure);
depth = sw_dpth(pressure,latmean);
speed = sndspd(salt,temp,depth);



dn = fstruct.dn;
x = fstruct.m_gps_lat;
y = fstruct.m_gps_lon;
% Strip nans; lat and lon full of them. Around 1 coord set every 4 hours
index = ~(isnan(x) | isnan(y) | isnan(dn));
xlil = x(index);
ylil = y(index);
dnlil = dn(index);

nanx = isnan(x);
t = 1:numel(x);

x(nanx) = interp1(t(~nanx),x(~nanx),t(nanx));
y(nanx) = interp1(t(~nanx),y(~nanx),t(nanx));


[t, u] = unique(fstruct.dn);
udn = fstruct.dn(u);
uvx = fstruct.m_final_water_vx(u);
uvy = fstruct.m_final_water_vy(u);
xtest = x(u);
ytest = y(u);
index = ~(isnan(udn) | isnan(xtest));
dn = fstruct.dn(index);
dt = datetime(dn,'ConvertFrom','datenum');
vx = fstruct.m_final_water_vx(index);
vy = fstruct.m_final_water_vy(index);
vx = fillmissing(vx,'next');
vy = fillmissing(vy,'next');
xnew = xtest(index);
ynew = ytest(index);


% Started at 134 instead of 1; the first were days before and far from
% Gray's Reef. Not very relevant.


correctedDN = (dn(135:end)+dn(134:end-1))/2;
correctedtime = datetime(correctedDN,'ConvertFrom','datenum');
correctedVX = vx(134:end-1);
correctedVY = vy(134:end-1);
correctedLat = xnew(134:end-1);
correctedLon = ynew(134:end-1);

currents = [correctedDN correctedLon correctedLat correctedVX correctedVY];


%%
load mooredGPS  

moored = {'FS17','STSNew1','33OUT','34ALTOUT','09T','Roldan',...
          '08ALTIN','14IN','West15','08C','STSNew2','FS6','39IN','SURTASS_05IN',...
          'SURTASS_STN20','SURTASS_FS15'}.';
      
recs = {'63068' '63073' '63067' '63079' '63080' '63066' '63076' '63078' '63063'...
        '63070' '63074' '63075' '63081' '63064' '63062' '63071'};
    
GRNMSlat = [31.4210667 31.3627333];
GRNMSlon = [-80.9212 -80.82815];
reef1 = [GRNMSlat(1) GRNMSlon(1)];
reef2 = [GRNMSlat(1) GRNMSlon(2)];
reef3 = [GRNMSlat(2) GRNMSlon(1)];
reef4 = [GRNMSlat(2) GRNMSlon(2)];    
   
% load contourinfo
% figure()
% hb=plot(coastline.x,coastline.y,'k'); set(hb,'linewidth',2); hold on;
% axis equal
% hold on
% plot(reef1(2),reef1(1),'linestyle','none','marker','*','color','k');
% plot(reef2(2),reef2(1),'linestyle','none','marker','*','color','k');
% plot(reef3(2),reef3(1),'linestyle','none','marker','*','color','k');
% plot(reef4(2),reef4(1),'linestyle','none','marker','*','color','k');
% 
% plot(mooredGPS(:,2),mooredGPS(:,1),'linestyle','none','marker','*','MarkerSize',8)
% % plot(mooredGPS(2,2),mooredGPS(2,1),'linestyle','none','MarkerSize',35,'marker','o')
% % set(gca,'XTick',[], 'YTick', [])
% plot(correctedLon,correctedLat)
% title('2014 Glider Mission Grays Reef');
% xlabel('Lon, Deg');
% ylabel('Lat, Deg');
% hold off

%%
% BVfm2014

cath2014
close all

figure()
scatter(rec.lon,rec.lat, 'filled');

listy = fields(justrecs)
lengthOfList= length(listy)

allYall = zeros(1276,1);
for yes = 1:lengthOfList
    currentFile = sprintf('rec.%d',listy{yes});
    
    
end







