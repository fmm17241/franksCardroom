%march timeseries figure
figure()
tiledlayout(5,1,'TileSpacing','compact')
% ax1 = nexttile()
% plot(bulktime,bulktemp);
% title('Bulk Thermal Strat. From Glider')

ax1 = nexttile([2 1])
pcolor(matrixDT,matrixDepth(1,:),matrixTemp'); shading interp; colorbar; set(gca,'ydir','reverse'); datetick('x');
title('Thermal Stratification','Glider Data')
clim([18 20])


% figure; h1=pcolor(dn,z,temp'); shading interp; colorbar; set(gca,'ydir','reverse'); datetick('x','keeplimits');
ax2 = nexttile()
yyaxis left
plot(receiverData{4}.DT,receiverData{4}.bulkThermalStrat);
ylabel('Thermal Strat.')
yyaxis right
plot(receiverData{4}.DT,receiverData{4}.windSpd);
ylabel('Windspeed (m/s)')
title('Wind Mixing','Bulk Thermal Strat and Windspeed')

% ax3 = nexttile()
% plot(receiverData{4}.DT,receiverData{4}.windSpd);
% title('Windspeed')


ax4 = nexttile()
% yyaxis left
plot(receiverData{4}.DT,receiverData{4}.Noise,'--');
yline(650)
ylabel('Noise (mV)')
% yyaxis right
% plot(receiverData{4}.DT,receiverData{4}.HourlyDets);
title('High-Frequency Noise','50-90 kHz')
% ylim([0 10])


ax5 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.HourlyDets);
title('Hourly Detections')

linkaxes([ax1 ax2 ax4 ax5],'x')


%%

figure()
tiledlayout(4,1,'TileSpacing','compact')
% ax1 = nexttile()
% plot(bulktime,bulktemp);
% title('Bulk Thermal Strat. From Glider')
% 
% ax1 = nexttile([2 1])
% pcolor(matrixDT,matrixDepth(1,:),matrixTemp'); shading interp; colorbar; set(gca,'ydir','reverse'); datetick('x');
% title('Thermal Stratification','Glider Data')
% clim([20 22])


% figure; h1=pcolor(dn,z,temp'); shading interp; colorbar; set(gca,'ydir','reverse'); datetick('x','keeplimits');
ax1 = nexttile()
% yyaxis left
plot(receiverData{9}.DT,receiverData{9}.bulkThermalStrat);
ylim([0 6])
ylabel('Thermal Strat.')
% yyaxis right
% plot(receiverData{9}.DT,receiverData{9}.windSpd);

title('Daily Stratification','Bulk Thermal Strat')

ax2 = nexttile()
plot(receiverData{9}.DT,receiverData{9}.windSpd);
title('Windspeed')
ylabel('Windspeed (m/s)')
ylim([0 7])


ax3 = nexttile()
% yyaxis left
plot(receiverData{9}.DT,receiverData{9}.Noise,'--');
yline(650)
ylabel('Noise (mV)')
% yyaxis right
% plot(receiverData{4}.DT,receiverData{4}.HourlyDets);
title('High-Frequency Noise','50-90 kHz')
% ylim([0 10])


ax4 = nexttile()
plot(receiverData{9}.DT,receiverData{9}.HourlyDets);
title('Hourly Detections')
ylabel('Detections')

linkaxes([ax1 ax2 ax3 ax4],'x')

%%
%Frank testing
figure()
hold on
for k =1:length(receiverData)
plot(receiverData{k}.DT,receiverData{k}.HourlyDets);
end
