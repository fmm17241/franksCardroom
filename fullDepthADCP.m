%FM Frank trying to figure out full depth tidal predictions


cd G:\Glider\Data\ADCP\
load GR_adcp_30minave_magrot.mat;
adcp;
adcp.time = datetime(adcp.dn,'convertfrom','datenum')';


figure()
[h,hc] = contourf(adcp.uc)
hc.EdgeColor = 'none'
title('ADCP Cross-shore Velocity 2014')
colorbar
caxis([-0.45 0.45])

figure()
[h,hc] = contourf(adcp.ua)
hc.EdgeColor = 'none'
title('ADCP Along-shore Velocity 2014')
colorbar
caxis([-0.2 0.2])





xin = (adcp.u+sqrt(-1)*adcp.v);


for COUNT = 1:height(xin)-1
    [struct{COUNT}, xout(COUNT,:)] = t_tide(xin(COUNT,:),'interval',adcp.dth,'start time',adcp.dn(1),'latitude',adcp.lat);
end


tideU = real(xout);
tideV = imag(xout);

datetide = [00,20,08,2014];
tTideOrder = [15,17,14,8,6,5]; % Full tides for consideration
% tTideOrder = [14]; %Isolating certain tides.
% uvpred order of constituents: 
% 1 = M2, 2 = S2, 3 = N2, 4 = K1, 6 = O1, 26 = Q1
UVOrder    = [1,2,3,4,6,26];% Full tides for consideration
% UVOrder    = [3]; %Isolating certain tides.
% [time,ut,vt] = uvpred(struct.tidecon(constituents,1),struct.tidecon(constituents,3),struct.tidecon(constituents,7),...
%     struct.tidecon(constituents,5),constituents,datetide,0.5,366);
%Below is the one I use. Commenting out to test
for COUNT = 1:length(struct)
    [tideSteps,ut(COUNT,:),vt(COUNT,:)] = uvpred(struct{COUNT}.tidecon(tTideOrder,1),struct{COUNT}.tidecon(tTideOrder,3),struct{COUNT}.tidecon(tTideOrder,7),...
        struct{COUNT}.tidecon(tTideOrder,5),UVOrder,datetide,0.5,114);
end

%Takes only Aug 20, 2014 15:30 to Dec 11, 2014 18:00
ut = ut( : , 31:5460);
vt = vt( : , 31:5460);

tideDN=datenum(2014,08,20,15,30,00):0.5/24:datenum(2014,12,11,18,00,00);
tideDT=datetime(tideDN,'ConvertFrom','datenum','TimeZone','UTC')';


uTwist = nanmean(tideU);
vTwist = nanmean(tideV);
tidalz = [uTwist;vTwist].';
[coef, ~,~,~] = pca(tidalz);
theta = coef(3);
[rotUtide,rotVtide] = rot(ut,vt,theta);

figure()
[h,hc] = contourf(rotUtide)
hc.EdgeColor = 'none'
title('TidePrediction Cross-shore Velocity 2014')
colorbar
caxis([-0.5 0.5])

figure()
[h,hc] = contourf(rotVtide)
hc.EdgeColor = 'none'
title('TidePrediction Along-shore Velocity 2014')
colorbar
caxis([-0.1 0.1])


differenceU = adcp.uc(1:18,:) - rotUtide;
differenceV = adcp.ua(1:18,:) - rotVtide;

figure()
[h,hc] = contourf(differenceU)
hc.EdgeColor = 'none'
colorbar
title('Experimental vs Theoretical Cross-Shore Velocity')


figure()
[h,hc] = contourf(differenceV)
hc.EdgeColor = 'none'
colorbar
title('Experimental vs Theoretical Along-Shore Velocity')
caxis([-0.3 0.2])


avgDiffU = nanmean(differenceU);
avgDiffV = nanmean(differenceV);

windsAnalysis2014
%Takes only Aug 20, 2014 15:30 to Dec 11, 2014 18:00
windsComp = windsAverage(5561:8276,:);


figure()
yyaxis left
plot(tideDT,avgDiffU);
hold on
yyaxis right
scatter(windsComp.time,windsComp.WSPD);














