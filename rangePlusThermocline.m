

[dn,z] = meshgrid(matstruct.dn,matstruct.z);


figure()
pcolor(dn,z,matstruct.rho')
shading interp; colorbar; set(gca,'ydir','reverse'); datetick('x','keeplimits'); ylim([0 18]);
% caxis([1021 1024]);
caxis([1023 1025]);


hold on
plot(transmitters.DN,transmitters.depth,'k*');

plot(matstruct.dn,depthdiff,'b')


hold off

%%
% many = length(GRtransmitters.id);
transmitters.distkm = [];
for hp = 1:length(transmittersID)
    currentmooring = hp;
    currentindex = recdet{hp};
    currentdist  = sortedbypings.distkm{hp};
    transmitters.distkm(currentindex) = currentdist;
end
transmitters.distkm = transmitters.distkm'



belowThermocline.dist = transmitters.distkm(AASBindex);
belowThermocline.dn   = transmitters.DN(AASBindex);
belowThermocline.dt   = datetime(belowThermocline.dn,'ConvertFrom','datenum')
% below.bindn= GRtransmitters.binnedDN(AASBindex);
belowThermocline.z    = transmitters.depth(AASBindex);
belowThermocline.lat  = transmitters.gps_lat(AASBindex); 
belowThermocline.lon  = transmitters.gps_lon(AASBindex);
aboveThermocline.dist = transmitters.distkm(~AASBindex);
aboveThermocline.dn   = transmitters.DN(~AASBindex);
aboveThermocline.dt   = datetime(aboveThermocline.dn,'ConvertFrom','datenum')
aboveThermocline.z    = transmitters.depth(~AASBindex);
aboveThermocline.lat  = transmitters.gps_lat(~AASBindex);
aboveThermocline.lon  = transmitters.gps_lon(~AASBindex);
% above.bindn= GRtransmitters.binnedDN(~AASBindex);
%%

everythingis = length(aboveThermocline.dist);
aboveThermocline.points = [];
for k = 1:everythingis
    if aboveThermocline.dist(k) <200
        aboveThermocline.points(k) = 1;
        continue
    end
    if aboveThermocline.dist(k) >200 && aboveThermocline.dist(k)<400
        aboveThermocline.points(k) = 2;
        continue
    end
    if aboveThermocline.dist(k) >400 && aboveThermocline.dist(k) <600
        aboveThermocline.points(k) = 3;
        continue
    end
    if aboveThermocline.dist(k) >600 && aboveThermocline.dist(k)<800
        aboveThermocline.points(k) = 4;
        continue
    end
    if aboveThermocline.dist(k) >800 && aboveThermocline.dist(k)<1000
        aboveThermocline.points(k) = 5;
        continue
    end
    if aboveThermocline.dist(k) >1000 && aboveThermocline.dist(k)<1200
        aboveThermocline.points(k) = 6;
        continue
    end
    if aboveThermocline.dist(k) >1200 && aboveThermocline.dist(k)<1400
        aboveThermocline.points(k) = 7;
        continue
    end
    if aboveThermocline.dist(k) >1400 && aboveThermocline.dist(k)<1600
        aboveThermocline.points(k) = 8;
        continue
    end
    if aboveThermocline.dist(k) >1600 && aboveThermocline.dist(k)<1800
        aboveThermocline.points(k) = 9;
        continue
    end
    if aboveThermocline.dist(k) >1800 && aboveThermocline.dist(k)<2000
        aboveThermocline.points(k) = 10;
        continue
    end
    if aboveThermocline.dist(k) >2000 && aboveThermocline.dist(k)<2200
        aboveThermocline.points(k) = 11;
        continue
    end
    if aboveThermocline.dist(k) >2200 && aboveThermocline.dist(k)<2400
        aboveThermocline.points(k) = 12;
        continue
    end
    if aboveThermocline.dist(k) >2400 && aboveThermocline.dist(k)<2600
        aboveThermocline.points(k) = 13;
        continue
    end
    if aboveThermocline.dist(k) >2600 && aboveThermocline.dist(k)<2800
        aboveThermocline.points(k) = 14;
        continue
    end
    if aboveThermocline.dist(k) >2800 && aboveThermocline.dist(k)<3000
        aboveThermocline.points(k) = 15;
        continue
    end
    if aboveThermocline.dist(k) >3000 && aboveThermocline.dist(k)<3200
        aboveThermocline.points(k) = 16;
        continue
    end
    if aboveThermocline.dist(k) >3200 && aboveThermocline.dist(k)<3400
        aboveThermocline.points(k) = 17;
        continue
    end
    if aboveThermocline.dist(k) >3400 && aboveThermocline.dist(k)<3600
        aboveThermocline.points(k) = 18;
        continue
    end
    if aboveThermocline.dist(k) >3600 && aboveThermocline.dist(k)<3800
        aboveThermocline.points(k) = 19;
        continue
    end
    if aboveThermocline.dist(k) >3800 && aboveThermocline.dist(k)4000
        aboveThermocline.points(k) = 20;
        continue
    end
    if aboveThermocline.dist(k) >4000
        aboveThermocline.points(k) = 21;
        continue
    end
end
aboveThermocline.points = aboveThermocline.points';


wonderful = length(belowThermocline.dist);
belowThermocline.points = [];
for k = 1:wonderful
    if belowThermocline.dist(k) <200
        belowThermocline.points(k) = 1;
        continue
    end
    if belowThermocline.dist(k) >200 && belowThermocline.dist(k)<400
        belowThermocline.points(k) = 2;
        continue
    end
    if belowThermocline.dist(k) >400 && belowThermocline.dist(k) <600
        belowThermocline.points(k) = 3;
        continue
    end
    if belowThermocline.dist(k) >600 && belowThermocline.dist(k)<800
        belowThermocline.points(k) = 4;
        continue
    end
    if belowThermocline.dist(k) >800 && belowThermocline.dist(k)<1000
        belowThermocline.points(k) = 5;
        continue
    end
    if belowThermocline.dist(k) >1000 && belowThermocline.dist(k)<1200
        belowThermocline.points(k) = 6;
        continue
    end
    if belowThermocline.dist(k) >1200 && belowThermocline.dist(k)<1400
        belowThermocline.points(k) = 7;
        continue
    end
    if belowThermocline.dist(k) >1400 && belowThermocline.dist(k)<1600
        belowThermocline.points(k) = 8;
        continue
    end
    if belowThermocline.dist(k) >1600 && belowThermocline.dist(k)<1800
        belowThermocline.points(k) = 9;
        continue
    end
    if belowThermocline.dist(k) >1800 && belowThermocline.dist(k)<2000
        belowThermocline.points(k) = 10;
        continue
    end
    if belowThermocline.dist(k) >2000 && belowThermocline.dist(k)<2200
        belowThermocline.points(k) = 11;
        continue
    end
    if belowThermocline.dist(k) >2200 && belowThermocline.dist(k)<2400
        belowThermocline.points(k) = 12;
        continue
    end
    if belowThermocline.dist(k) >2400 && belowThermocline.dist(k)<2600
        belowThermocline.points(k) = 13;
        continue
    end
    if belowThermocline.dist(k) >2600 && belowThermocline.dist(k)<2800
        belowThermocline.points(k) = 14;
        continue
    end
    if belowThermocline.dist(k) >2800 && belowThermocline.dist(k)<3000
        belowThermocline.points(k) = 15;
        continue
    end
    if belowThermocline.dist(k) >3000 && belowThermocline.dist(k)<3200
        belowThermocline.points(k) = 16;
        continue
    end
    if belowThermocline.dist(k) >3200 && belowThermocline.dist(k)<3400
        belowThermocline.points(k) = 17;
        continue
    end
    if belowThermocline.dist(k) >3400 && belowThermocline.dist(k)<3600
        belowThermocline.points(k) = 18;
        continue
    end
    if belowThermocline.dist(k) >3600 && belowThermocline.dist(k)<3800
        belowThermocline.points(k) = 19;
        continue
    end
    if belowThermocline.dist(k) >3800 && belowThermocline.dist(k)<4000
        belowThermocline.points(k) = 20;
        continue
    end
    if belowThermocline.dist(k) >4000 
        belowThermocline.points(k) = 21;
        continue
    end
end
belowThermocline.points = belowThermocline.points';
% 
% figure()
% hold on
% 
% for k = 1:wonderful
%     if below.points(k) == 1
%         scatter(below.dn(k),below.z(k),'r','filled')
%         continue
%     end
%     if below.points(k) == 2
%         scatter(below.dn(k),below.z(k),'k','filled')
%         continue
%     end
%     if below.points(k) == 3
%         scatter(below.dn(k),below.z(k),'g','filled')
%         continue
%     end
%     if below.points(k) == 4
%         scatter(below.dn(k),below.z(k),'b','filled')
%         continue
%     end
%         if below.points(k) == 5
%         scatter(below.dn(k),below.z(k),'m','filled')
%         continue
%     end
% end
% 
% for k = 1:everythingis
%     if above.points(k) == 1
%         scatter(above.dn(k),above.z(k),'r','filled')
%         continue
%     end
%     if above.points(k) == 2
%         scatter(above.dn(k),above.z(k),'k','filled')
%         continue
%     end
%     if above.points(k) == 3
%         scatter(above.dn(k),above.z(k),'g','filled')
%         continue
%     end
%     if above.points(k) == 4
%         scatter(above.dn(k),above.z(k),'b','filled')
%         continue
%     end
%      if above.points(k) == 5
%         scatter(above.dn(k),above.z(k),'m','filled')
%         continue
%     end
% end




TotalAboveBinnedDistance{1} = sum(aboveThermocline.points==1,'all');
TotalAboveBinnedDistance{2} = sum(aboveThermocline.points==2,'all'); 
TotalAboveBinnedDistance{3} = sum(aboveThermocline.points==3,'all');
TotalAboveBinnedDistance{4} = sum(aboveThermocline.points==4,'all');
TotalAboveBinnedDistance{5} = sum(aboveThermocline.points==5,'all');
TotalAboveBinnedDistance{6} = sum(aboveThermocline.points==6,'all');
TotalAboveBinnedDistance{7} = sum(aboveThermocline.points==7,'all');
TotalAboveBinnedDistance{8} = sum(aboveThermocline.points==8,'all');
TotalAboveBinnedDistance{9} = sum(aboveThermocline.points==9,'all');
TotalAboveBinnedDistance{10} = sum(aboveThermocline.points==10,'all');
TotalAboveBinnedDistance{11} = sum(aboveThermocline.points==11,'all');
TotalAboveBinnedDistance{12} = sum(aboveThermocline.points==12,'all');
TotalAboveBinnedDistance{13} = sum(aboveThermocline.points==13,'all');
TotalAboveBinnedDistance{14} = sum(aboveThermocline.points==14,'all');
TotalAboveBinnedDistance{15} = sum(aboveThermocline.points==15,'all');
TotalAboveBinnedDistance{16} = sum(aboveThermocline.points==16,'all');
TotalAboveBinnedDistance{17} = sum(aboveThermocline.points==17,'all');
TotalAboveBinnedDistance{18} = sum(aboveThermocline.points==18,'all');
TotalAboveBinnedDistance{19} = sum(aboveThermocline.points==19,'all');
TotalAboveBinnedDistance{20} = sum(aboveThermocline.points==20,'all');
TotalAboveBinnedDistance{21} = sum(aboveThermocline.points==21,'all');




TotalBelowBinnedDistance{1} = sum(belowThermocline.points==1,'all');
TotalBelowBinnedDistance{2} = sum(belowThermocline.points==2,'all');
TotalBelowBinnedDistance{3} = sum(belowThermocline.points==3,'all');
TotalBelowBinnedDistance{4} = sum(belowThermocline.points==4,'all');
TotalBelowBinnedDistance{5} = sum(belowThermocline.points==5,'all');
TotalBelowBinnedDistance{6} = sum(belowThermocline.points==6,'all');
TotalBelowBinnedDistance{7} = sum(belowThermocline.points==7,'all');
TotalBelowBinnedDistance{8} = sum(belowThermocline.points==8,'all');
TotalBelowBinnedDistance{9} = sum(belowThermocline.points==9,'all');
TotalBelowBinnedDistance{10} = sum(belowThermocline.points==10,'all');
TotalBelowBinnedDistance{11} = sum(belowThermocline.points==11,'all');
TotalBelowBinnedDistance{12} = sum(belowThermocline.points==12,'all');
TotalBelowBinnedDistance{13} = sum(belowThermocline.points==13,'all');
TotalBelowBinnedDistance{14} = sum(belowThermocline.points==14,'all');
TotalBelowBinnedDistance{15} = sum(belowThermocline.points==15,'all');
TotalBelowBinnedDistance{16} = sum(belowThermocline.points==16,'all');
TotalBelowBinnedDistance{17} = sum(belowThermocline.points==17,'all');
TotalBelowBinnedDistance{18} = sum(belowThermocline.points==18,'all');
TotalBelowBinnedDistance{19} = sum(belowThermocline.points==19,'all');
TotalBelowBinnedDistance{20} = sum(belowThermocline.points==20,'all');
TotalBelowBinnedDistance{21} = sum(belowThermocline.points==21,'all');

