%Need to buildreceiverdata then run 

%march timeseries figure
figure()
tiledlayout(5,1,'TileSpacing','compact')
% ax1 = nexttile()
% plot(bulktime,bulktemp);
% title('Bulk Thermal Strat. From Glider')

ax1 = nexttile([2 1])
pcolor(matrixDT,matrixDepth(1,:),matrixTemp'); shading interp; cb = colorbar; set(gca,'ydir','reverse'); datetick('x');
title('Thermal Stratification','Glider Data')
set(gca,'Xticklabel',[]); set(gca,'xtick',[]); cb.Label.String = 'Temp (C)';
title('Thermal Stratification','Glider Data')
ylabel('Depth (m)')
clim([18 20])


% figure; h1=pcolor(dn,z,temp'); shading interp; colorbar; set(gca,'ydir','reverse'); datetick('x','keeplimits');
ax2 = nexttile()
yyaxis left
plot(receiverData{4}.DT,receiverData{4}.bulkThermalStrat,'LineWidth',3);
set(gca,'Xticklabel',[]); set(gca,'xtick',[]);
ylabel('Thermal Strat. (C)')
yyaxis right
plot(receiverData{4}.DT,receiverData{4}.windSpd,'LineWidth',3);
ylabel('Windspeed (m/s)')
title('Wind Mixing','Bulk Thermal Stratification and Windspeed')
set(gca,'Clipping','on')

% ax3 = nexttile()
% plot(receiverData{4}.DT,receiverData{4}.windSpd);
% title('Windspeed')


ax4 = nexttile()
% yyaxis left
plot(receiverData{4}.DT,receiverData{4}.Noise,'--','LineWidth',3);
y1 = yline(650,'-','Challenging Acoustic Threshold'); y1.LabelHorizontalAlignment = 'Center'; y1.LabelVerticalAlignment = 'Bottom';
ylabel('Noise (mV)')
set(gca,'Xticklabel',[]); set(gca,'xtick',[]);
% yyaxis right
% plot(receiverData{4}.DT,receiverData{4}.HourlyDets);
title('High-Frequency (50-90 kHz) Noise')
ylim([500 750])


ax5 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.HourlyDets,'k','LineWidth',3);
title('Hourly Detections')
ylabel('Detections')

linkaxes([ax1 ax2 ax4 ax5],'x')

print(gcf,'timeseriesApril23.png','-dpng','-r300'); 
%%

figure()
tiledlayout(3,1,'TileSpacing','compact')
% ax1 = nexttile()
% plot(bulktime,bulktemp);
% title('Bulk Thermal Strat. From Glider')
% 
% ax1 = nexttile([2 1])
% pcolor(matrixDT,matrixDepth(1,:),matrixTemp'); shading interp; colorbar; set(gca,'ydir','reverse'); datetick('x');
% title('Thermal Stratification','Glider Data')
% clim([20 22])

ax1 = nexttile()
yyaxis left
plot(receiverData{4}.DT,receiverData{4}.bulkThermalStrat,'LineWidth',3);
set(gca,'Xticklabel',[]); set(gca,'xtick',[]);
ylabel('Thermal Strat. (C)')
ylim([1 4])
yyaxis right
plot(receiverData{4}.DT,receiverData{4}.windSpd,'LineWidth',3);
ylabel('Windspeed (m/s)')
title('Wind Mixing','Bulk Thermal Stratification and Windspeed')
set(gca,'Clipping','on')



ax2 = nexttile()
% yyaxis left
plot(receiverData{4}.DT,receiverData{4}.Noise,'--','LineWidth',3);
hold on
y1 = yline(650,'-','Challenging Acoustic Threshold'); y1.LabelHorizontalAlignment = 'Right'; y1.LabelVerticalAlignment = 'Top';
ylabel('Noise (mV)')
set(gca,'Xticklabel',[]); set(gca,'xtick',[]);
yValue = [0 10000];
for k = 1:length(sunset)-1
    x = [sunset(k) sunrise(k+1)];
    area(x,yValue,'FaceColor','k','FaceAlpha',0.2);
end
ylim([250 800])
title('High-Frequency (50-90 kHz) Noise')


ax3 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.HourlyDets,'k','LineWidth',3);
title('Hourly Detections')
ylabel('Detections')
yValue = [0 10000];
hold on
for k = 1:length(sunset)-1
    x = [sunset(k) sunrise(k+1)];
    area(x,yValue,'FaceColor','k','FaceAlpha',0.2);
end
ylim([0 8])


linkaxes([ax1 ax2 ax3],'x')

print(gcf,'TimeseriesJuly.png','-dpng','-r300'); 
