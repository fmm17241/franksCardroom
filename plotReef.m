

GRNMSlat = [31.4210667 31.3627333];
GRNMSlon = [-80.9212 -80.82815];
reef1 = [GRNMSlat(1) GRNMSlon(1)];
reef2 = [GRNMSlat(1) GRNMSlon(2)];
reef3 = [GRNMSlat(2) GRNMSlon(1)];
reef4 = [GRNMSlat(2) GRNMSlon(2)];



points_x=[];
points_y=[];
num_points = 4;
for i=1:num_points
points_x(i,1)=(reef1(2)*i+reef2(2)*(num_points-i+1))/(num_points+1);
points_y(i,1)=(reef1(1)*i+reef2(1)*(num_points-i+1))/(num_points+1);
points_x(i,2)=(reef1(2)*i+reef3(2)*(num_points-i+1))/(num_points+1);
points_y(i,2)=(reef2(1)*i+reef3(1)*(num_points-i+1))/(num_points+1);
points_x(i,3)=(reef2(2)*i+reef4(2)*(num_points-i+1))/(num_points+1);
points_y(i,3)=(reef2(1)*i+reef4(1)*(num_points-i+1))/(num_points+1);
points_x(i,4)=(reef3(2)*i+reef4(2)*(num_points-i+1))/(num_points+1);
points_y(i,4)=(reef3(1)*i+reef4(1)*(num_points-i+1))/(num_points+1);
end


[ronda,rousey] = meshgrid(points_x,points_y);


figure()
plot(ronda,rousey,'k*')
xlabel('Longitude');
ylabel('Latitude');
axis equal
title('Gridded Grays Reef');

% distkm{k}(distcount) = lldistkm(geeps{k},currentgps(distcount,:));
distkm{1} = lldistkm(reef1,reef2);
distkm{2} = lldistkm(reef1,reef3);
areaGR   = distkm{1}*distkm{2};
% 
load contourinfo


yes=figure()
hb=plot(coastline.x,coastline.y,'k'); set(hb,'linewidth',2); hold on;
axis equal
hold on
plot(reef1(2),reef1(1),'linestyle','none','marker','*','color','k');
plot(reef2(2),reef2(1),'linestyle','none','marker','*','color','k');
plot(reef3(2),reef3(1),'linestyle','none','marker','*','color','k');
plot(reef4(2),reef4(1),'linestyle','none','marker','*','color','k');
xlabel('Longitude');
ylabel('Latitude');
title('Georgia''s Inner Coastal Shelf');
for i=1:length(bathymetry)
  hc(i)=line(bathymetry(i).x(:),bathymetry(i).y(:),'color',[.6 .6 .6],'LineWidth',0.5);
end
SkiO = [31.988137878676937, -81.0219881445705]
scatter(SkiO(2),SkiO(1),600,'r','p','filled');

h(1) = plot(nan,nan,'rp','MarkerSize',50,'DisplayName','Skidaway Institute of Oceanography');
h(2) = plot(nan,nan,'-.k','DisplayName','Gray''s Reef NMS');
legend(h);

exportgraphics(yes,'GRNMSBigPic5.jpeg');




load mooredGPS 
% transmitters = {'63068' '63073' '63067' '63079' '63080' '63066' '63076' '63078' '63063'...
%         '63070' '63074' '63075' '63081' '63064' '63062' '63071'};
%     
% moored = {'FS17','STSNew1','33OUT','34ALTOUT','09T','Roldan',...
%           '08ALTIN','14IN','West15','08C','STSNew2','FS6','39IN','SURTASS_05IN',...
%           'SURTASS_STN20','SURTASS_FS15'}.';
%       
%       
figure()
scatter(mooredGPS(:,2),mooredGPS(:,1),'k');      
xlabel('Longitude');
ylabel('Latitude');
axis equal
hold on
scatter(mooredGPS(5,2),mooredGPS(5,1),'k','filled');  
% legend('Moored Acoustic Transmitters');
scatter(mooredGPS(10,2),mooredGPS(10,1),'r','filled');  
scatter(mooredGPS(4,2),mooredGPS(4,1),['g'],'filled');  


distances(1) = lldistkm(mooredGPS(5,:),mooredGPS(10,:))
distances(1) = lldistkm(mooredGPS(4,:),mooredGPS(5,:))


buoyLocation =  [31.4 -80.866];



localdir= 'C:\Users\fmm17241\Documents\GitHub\franksCardroom\';	% where on your computer you want to write mafiles and plots; copy ec2001.mat here
load([localdir,'contourinfo.mat'],'bathymetry','coastline');


hb=plot(coastline.x,coastline.y,'k'); set(hb,'linewidth',2); hold on;
for i=1:length(bathymetry)
  hc(i)=line(bathymetry(i).x(:),bathymetry(i).y(:),'color',[.6 .6 .6],'LineWidth',0.5);
end

%small pic

pp = figure()
scatter(mooredGPS(:,2),mooredGPS(:,1),'k','filled'); 
hold on
plot(reef1(2),reef1(1),'linestyle','none','marker','*','color','k');
plot(reef2(2),reef2(1),'linestyle','none','marker','*','color','k');
plot(reef3(2),reef3(1),'linestyle','none','marker','*','color','k');
plot(reef4(2),reef4(1),'linestyle','none','marker','*','color','k');
title('Gray''s Reef National Marine Sanctuary');
xlabel('');
ylabel('');
axis equal
set(gca,'Color',[0.8,0.8,0.8]);
legend('Moored Transmitters');
set(gca,'YTick',[]);
set(gca,'Xticklabel',[])

exportgraphics(pp,'GNMSLilPic4.jpeg');

%SURTASSSTN20 and STSNew1
pairingAngle1 = atan2d((mooredGPS(2,2)-mooredGPS(15,2)),(mooredGPS(2,1)-mooredGPS(15,1)));
%SURTASS05IN and FS6
pairingAngle2 = atan2d((mooredGPS(14,2)-mooredGPS(12,2)),(mooredGPS(14,1)-mooredGPS(12,1)));
%Roldan and 08ALTIN
pairingAngle3 = atan2d((mooredGPS(7,2)-mooredGPS(6,2)),(mooredGPS(7,1)-mooredGPS(6,1)));
%SURTASS05IN and STSNew2
pairingAngle4 = atan2d((mooredGPS(14,2)-mooredGPS(11,2)),(mooredGPS(14,1)-mooredGPS(11,1)));
%39IN and SURTASS05IN
pairingAngle5 = atan2d((mooredGPS(14,2)-mooredGPS(13,2)),(mooredGPS(14,1)-mooredGPS(13,1)));


distances(1) = lldistkm(mooredGPS(2,:),mooredGPS(15,:))
distances(2) = lldistkm(mooredGPS(14,:),mooredGPS(12,:))
distances(3) = lldistkm(mooredGPS(7,:),mooredGPS(6,:))
distances(4) = lldistkm(mooredGPS(14,:),mooredGPS(11,:))
distances(5) = lldistkm(mooredGPS(13,:),mooredGPS(14,:))



buoyDistance = lldistkm(mooredGPS(14,:),buoyLocation)



















 
% Use this after textbox placement