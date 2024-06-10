

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data'


load September_21_salacia_dbds.mat
load September_21_salacia_ebds.mat

septMissionDT = datetime(fstruct.dn,'convertfrom','datenum')
[matstruct,dn,z,temp,rho] = Bindata(fstruct,sstruct);

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
%Plot the trail on the map
hold on
plot(matstruct.lon,matstruct.lat,'r','LineWidth',4)
plot(matstruct.lon(659:662),matstruct.lat(659:662),'b','LineWidth',4)

plot(correctedLon(548223:548237),correctedLat(548223:548237),'b','LineWidth',50)
plot(correctedLon(548283:548298),correctedLat(548283:548298),'b','LineWidth',50)






load November_21_angus_dbds.mat
load November_21_angus_ebds.mat

load July_21_franklin_dbds.mat
load July_21_franklin_ebds.mat

load September_21_salacia_dbds.mat
load September_21_salacia_ebds.mat
