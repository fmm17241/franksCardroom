LineSpecLowDayOn = ['r','*']
LineSpecLowDayOff = ['b','*']

LineSpecHighDayOn = ['r','^']
LineSpecHighDayOff = ['b','^']

%Night
LineSpecLowNightOn = ['r','*']
LineSpecLowNightOff = ['b','*']

LineSpecHighNightOn = ['r','^']
LineSpecHighNightOff = ['b','^']


X = 1:5;

figure()
tiledlayout(2,2,'TileSpacing',"compact")
ax1 = nexttile()
hold on
errorbar(X,dayLowNoise(4,:),SEMnoiseDayLow{4}(:,2),SEMnoiseDayLow{4}(:,1),0,0,LineSpecLowDayOn)
errorbar(X,dayLowNoise(5,:),SEMnoiseDayLow{5}(:,2),SEMnoiseDayLow{5}(:,1),0,0,LineSpecLowDayOff)
legend('On Reef','','','','','Off Reef')
title('Daytime, Low Winds')
xlim([0.8 5.2])
ylim([350 800])
ylabel('HF Noise (mV)')
set(gca, 'XTickLabel', [])

ax2 = nexttile()
hold on
errorbar(X,dayHighNoise(4,:),SEMnoiseDayHigh{4}(:,2),SEMnoiseDayHigh{4}(:,1),0,0,LineSpecHighDayOn)
errorbar(X,dayHighNoise(5,:),SEMnoiseDayHigh{5}(:,2),SEMnoiseDayHigh{5}(:,1),0,0,LineSpecHighDayOff)
legend('On Reef','','','','','Off Reef')
title('Daytime, High Winds')
xlim([0.8 5.2])
ylim([350 800])
ylabel('HF Noise (mV)')
set(gca, 'XTickLabel', [])

ax3 = nexttile()
hold on
errorbar(X,nightLowNoise(4,:),SEMnoiseNightLow{4}(:,2),SEMnoiseNightLow{4}(:,1),0,0,LineSpecLowNightOn)
errorbar(X,nightLowNoise(5,:),SEMnoiseNightLow{5}(:,2),SEMnoiseNightLow{5}(:,1),0,0,LineSpecLowNightOff)
legend('On Reef','','','','','Off Reef')
title('Nighttime, Low Winds')
xlim([0.8 5.2])
ylim([350 800])
ylabel('HF Noise (mV)')
xticks(ax3,[1 2 3 4 5])
xticklabels(ax3,{'Winter','Spring','Summer','Fall','Mariner''s Fall'})



ax4 = nexttile()
hold on
errorbar(X,nightHighNoise(4,:),SEMnoiseNightHigh{4}(:,2),SEMnoiseNightHigh{4}(:,1),0,0,LineSpecHighNightOn)
errorbar(X,nightHighNoise(5,:),SEMnoiseNightHigh{5}(:,2),SEMnoiseNightHigh{5}(:,1),0,0,LineSpecHighNightOff)
legend('On Reef','','','','','Off Reef')
title('Nighttime, High Winds')
xlim([0.8 5.2])
ylim([350 800])
ylabel('HF Noise (mV)')
xticks(ax4,[1 2 3 4 5])
xticklabels(ax4,{'Winter','Spring','Summer','Fall','Mariner''s Fall'})

%%
%
figure()
tiledlayout(2,2,'TileSpacing',"compact")
ax1 = nexttile()
hold on
errorbar(X,dayLowNoise(4,:),SEMnoiseDayLow{4}(:,2),SEMnoiseDayLow{4}(:,1),0,0,LineSpecLowDayOn)
errorbar(X,dayHighNoise(4,:),SEMnoiseDayHigh{4}(:,2),SEMnoiseDayHigh{4}(:,1),0,0,LineSpecHighDayOn)
legend('Low Wind','','','','','High Wind')
title('Daytime, On Reef')
xlim([0.8 5.2])
ylim([350 800])
ylabel('HF Noise (mV)')
set(gca, 'XTickLabel', [])





ax2 = nexttile()
hold on
errorbar(X,dayLowNoise(5,:),SEMnoiseDayLow{5}(:,2),SEMnoiseDayLow{5}(:,1),0,0,LineSpecLowDayOff)
errorbar(X,dayHighNoise(5,:),SEMnoiseDayHigh{5}(:,2),SEMnoiseDayHigh{5}(:,1),0,0,LineSpecHighDayOff)
legend('Low Wind','','','','','High Wind')
title('Daytime, Off Reef')
xlim([0.8 5.2])
ylim([350 800])
ylabel('HF Noise (mV)')
set(gca, 'XTickLabel', [])

ax3 = nexttile()
hold on
errorbar(X,nightLowNoise(4,:),SEMnoiseNightLow{4}(:,2),SEMnoiseNightLow{4}(:,1),0,0,LineSpecLowNightOn)
errorbar(X,nightHighNoise(4,:),SEMnoiseNightHigh{4}(:,2),SEMnoiseNightHigh{4}(:,1),0,0,LineSpecHighNightOn)
legend('Low Wind','','','','','High Wind')
title('Nighttime, On Reef')
xlim([0.8 5.2])
ylim([350 800])
ylabel('HF Noise (mV)')
xticks(ax3,[1 2 3 4 5])
xticklabels(ax3,{'Winter','Spring','Summer','Fall','Mariner''s Fall'})



ax4 = nexttile()
hold on
errorbar(X,nightLowNoise(5,:),SEMnoiseNightLow{5}(:,2),SEMnoiseNightLow{5}(:,1),0,0,LineSpecLowNightOff)
errorbar(X,nightHighNoise(5,:),SEMnoiseNightHigh{5}(:,2),SEMnoiseNightHigh{5}(:,1),0,0,LineSpecHighNightOff)
legend('Low Wind','','','','','High Wind')
title('Nighttime, Off Reef')
xlim([0.8 5.2])
ylim([350 800])
ylabel('HF Noise (mV)')
xticks(ax4,[1 2 3 4 5])
xticklabels(ax4,{'Winter','Spring','Summer','Fall','Mariner''s Fall'})


%%
%"FIND IT IN THE TIMESERIES"


figure()
tiledlayout(4,1,'TileSpacing',"compact")
ax1 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.HourlyDets,'r')
ylabel('Detections')
% hold on
% yyaxis right
% scatter(receiverData{5}.DT,receiverData{5}.daytime,'k','filled')
% ylim([-0.1 1.1])
% yticks([0 1])
% yticklabels([{'Night'},{'Day'}])

title('Hourly Detections: ON Reef')


ax2 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd,'k','LineWidth',1.5)
ylim([0 12])
ylabel('Windspeed (m/s)')
title('Windspeed')


ax3 = nexttile()
plot(receiverData{5}.DT,receiverData{5}.Noise,'b')
ylabel('Noise')
% hold on
% yyaxis right
% scatter(receiverData{5}.DT,receiverData{5}.daytime,'k','filled')
% ylim([-0.1 1.1])
% yticks([0 1])
% yticklabels([{'Night'},{'Day'}])
title('Hourly Detections: OFF Reef')


ax4 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.crossShore,'k')
% ylim([-0.4 0.4])
ylabel('Tidal Velocity (m/s)')
title('Tidal Currents, Cross-shore','Positive: Ebb, Negative: Flood,')
% legend('On Reef','Off Reef')

linkaxes([ax1 ax2 ax3 ax4],'x')

%%
% 1/2/24
figure()
tiledlayout(3,1,'TileSpacing',"compact")
ax1 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.Noise,'r')
ylabel('HF Noise')
hold on
plot(receiverData{5}.DT,receiverData{5}.Noise,'b')
yyaxis right
scatter(receiverData{5}.DT,receiverData{5}.daytime,'k','filled')
ylim([-0.1 1.1])
yticks([0 1])
yticklabels([{'Night'},{'Day'}])

title('ON and OFF Reef Noise')



ax2 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd,'k','LineWidth',1.5)
ylim([0 12])
ylabel('Windspeed (m/s)')

linkaxes([ax1 ax2 ax3],'x')
title('Windspeed')

ax3 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.crossShore,'k')
% ylim([-0.4 0.4])
ylabel('Tidal Velocity (m/s)')
title('Tidal Currents, Cross-shore','Positive: Ebb, Negative: Flood,')
% legend('On Reef','Off Reef')


% ax4 = nexttile()
% plot(receiverData{4}.DT,receiverData{4}.bulkStrat,'r')
% hold on
% plot(receiverData{5}.DT,receiverData{5}.bulkStrat,'b')
% ylabel('Thermal Stratification')
% title('Bulk Stratification, On and Off Reef')



linkaxes([ax1 ax2 ax3],'x')

%%
%Checking tilt of BIG BOY LETS OGOOOGOFDFGODFKHBVLCHBM JDF MGBJ NCFJBM

% figure()
% tiledlayout(4,1,'TileSpacing',"compact")
% ax1 = nexttile()
% plot(receiverData{4}.DT,receiverData{4}.Pings,'r')
% hold on
% plot(receiverData{5}.DT,receiverData{5}.Pings,'b')
% ylabel('Pings')
% title('PINGS PINGS PINGS')
% 
% 
% ax2 = nexttile()
% title('Instrument Tilt')
% plot(receiverData{7}.DT,receiverData{7}.Tilt,'k')
% title('Tilt Angle of Middle Transmitter')
% 
% ax3 = nexttile()
% plot(receiverData{4}.DT,receiverData{4}.crossShore,'k','LineWidth',1.5)
% ylim([-0.4 0.4])
% ylabel('Tidal Current (m/s)')
% title('Tides')
% 
% ax4 = nexttile()
% plot(receiverData{4}.DT,receiverData{4}.windSpd,'k','LineWidth',1.5)
% ylim([0 14])
% ylabel('Windspeed (m/s)')
% 
% 
% linkaxes([ax1 ax2 ax3 ax4],'x')
% title('Windspeed')
% 
% %%
% 
% figure()
% tiledlayout(4,1,'TileSpacing',"compact")
% ax1 = nexttile()
% plot(receiverData{4}.DT,receiverData{4}.HourlyDets,'r')
% hold on
% plot(receiverData{5}.DT,receiverData{5}.HourlyDets,'b')
% ylabel('Pings')
% title('PINGS PINGS PINGS')
% 
% 
% ax2 = nexttile()
% title('Instrument Tilt')
% plot(receiverData{7}.DT,receiverData{7}.Tilt,'k')
% title('Tilt Angle of Middle Transmitter')
% 
% ax3 = nexttile()
% plot(receiverData{4}.DT,receiverData{4}.crossShore,'k','LineWidth',1.5)
% ylim([-0.4 0.4])
% ylabel('Tidal Current (m/s)')
% title('Tides')
% 
% ax4 = nexttile()
% plot(receiverData{4}.DT,receiverData{4}.windSpd,'k','LineWidth',1.5)
% ylim([0 14])
% ylabel('Windspeed (m/s)')
% 
% 
% linkaxes([ax1 ax2 ax3 ax4],'x')
% title('Windspeed')




