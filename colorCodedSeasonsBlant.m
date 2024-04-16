%

%%FM: 9/27, changed winterBin to have all of Winter, and instead plotted it
%%twice, separating beginning and end of year for ease of visualization.


figure()
plot(winterBin.Time(1:1440),winterBin.Detections(1:1440),'b');
hold on
plot(springBin.Time,springBin.Detections,'g');
plot(summerBin.Time,summerBin.Detections,'r');
plot(fallBin.Time,fallBin.Detections,'k');
plot(MfallBin.Time,MfallBin.Detections,'c');
plot(winterBin.Time(1441:end),winterBin.Detections(1441:end),'b');
yValue = [0 10000];
for k = 1:length(sunset)-1
    x = [sunset(k) sunrise(k+1)];
    area(x,yValue,'FaceColor','k','FaceAlpha',0.2);
end
ylim([4 16])
title('Ch-Ch-Changes: Turn and Face the Strange');
ylabel('Detections, Hourly');
[~,linez,~,~] = legend({'Winter','Spring','Summer','Fall','Mariner''s Fall'},'Fontsize',12);
h1 = findobj(linez,'type','line');
set(h1,'LineWidth', 1.5);
hold off




% %%
% rr= 3;
% cc=4;
% figure()
% set(gcf,'Position',[300 10 1000 600]);
% % s1 = subaxis(rr,cc,1:8,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.03,'MarginBot',0.15,'SpacingHoriz',0.02,'SpacingVert',0.04);
% s1 = subaxis(3,4,1:2);
% 
% 
% plot(winterBin.Time(1:1440),winterBin.Detections(1:1440),'b');
% hold on
% plot(springBin.Time,springBin.Detections,'g');
% plot(summerBin.Time,summerBin.Detections,'r');
% plot(fallBin.Time,fallBin.Detections,'k');
% plot(MfallBin.Time,MfallBin.Detections,'c');
% plot(winterBin.Time(1441:end),winterBin.Detections(1441:end),'b');
% title('Seasonal Detections');
% ylabel('Detections, Hourly');
% [~,linez,~,~] = legend({'Winter','Spring','Summer','Fall', 'Mariner''s Fall'},'Fontsize',12);
% h1 = findobj(linez,'type','line');
% set(h1,'LineWidth', 1.5);
% 
% s2 = subaxis(rr,cc,9,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.03,'MarginBot',0.10,'SpacingHoriz',0.02,'SpacingVert',0.06);
% hold on
% histogram([winterBin.Detections; winterBin.Detections],'FaceColor','b','BinWidth',0.5,'BinLimits',[4 16]);
% % xticks('');
% ylim([0 450]);
% ylabel('Hours');
% title('Winter');
% 
% s3 = subaxis(rr,cc,10,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.03,'MarginBot',0.10,'SpacingHoriz',0.02,'SpacingVert',0.06);
% histogram(springBin.Detections,'FaceColor','g','BinWidth',0.5,'BinLimits',[4 16]);
% % xticks('');
% yticks('');
% ylim([0 450]);
% title('Spring');
% 
% s4 = subaxis(rr,cc,11,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.03,'MarginBot',0.10,'SpacingHoriz',0.02,'SpacingVert',0.06);
% histogram(summerBin.Detections,'FaceColor','r','BinWidth',0.5,'BinLimits',[4 16]);
% % ylabel('Hours');
% yticks('');
% ylim([0 450]);
% xTootz = xlabel('Detections, Hourly','fontweight','bold');
% title('Summer');
% 
% s5 = subaxis(rr,cc,12,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.03,'MarginBot',0.10,'SpacingHoriz',0.02,'SpacingVert',0.06);
% histogram(fallBin.Detections,'FaceColor','k','BinWidth',0.5,'BinLimits',[4 16]);
% yticks('');
% ylim([0 450]);
% title('Fall');
% 
% s5 = subaxis(rr,cc,12,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.03,'MarginBot',0.10,'SpacingHoriz',0.02,'SpacingVert',0.06);
% histogram(MfallBin.Detections,'FaceColor','k','BinWidth',0.5,'BinLimits',[4 16]);
% yticks('');
% ylim([0 450]);
% title('Mariner''s Fall');
% 

edges = [0 650 1000];
[x y] = discretize(MfallBin.Noise,edges)
hist(x)



% xTootz.Position(1) = xTootz.Position(1) - 8;
tableDetections = timetable(receiverData{2}.DT,receiverData{2}.HourlyDets);


%Resetting the monthly avg. All transceivers is a crappy way of doing it,
%lets focus on 2 or 4 or something.

monthlyAVG = retime(tableDetections,'monthly','mean');
monthlyVAR = retime(tableDetections,'monthly',@std);
%% Noise, seasonality



ff = figure()
tiledlayout(3,5,'TileSpacing','Compact','Padding','Compact')
set(gcf,'Position',[300 10 1000 600]);
nexttile([2 5])
yyaxis left
yyaxis left
plot(winterBin.Time(1:1440),winterBin.Noise(1:1440),'-','Color','b');
hold on
plot(springBin.Time,springBin.Noise,'-','Color','g');
plot(summerBin.Time,summerBin.Noise,'-','Color','r');
plot(fallBin.Time,fallBin.Noise,'-','Color','k');
plot(MfallBin.Time,MfallBin.Noise,'-','Color','c');
plot(winterBin.Time(1441:end),winterBin.Noise(1441:end),'-','Color','b');
yline(650,'--',{'Challenging','Environment'})
title('Gray''s Reef Soundscape & Detection Efficiency','High Frequency Noise (50-90 kHz) and Monthly Avg. Detections');
ylabel('Average Noise (mV)');
yyaxis right
scatter(monthlyAVG.Time, monthlyAVG.Var1,65,'k','d','filled');
ylabel('Avg. Hourly Detections');
legend(' Hourly Noise','','','','','','',' Monthly Avg. Detections')
ax = gca;
ax.YAxis(2).Color = 'k'

nexttile()
hold on
histogram(winterBin.Noise,'FaceColor','b','BinWidth',10,'BinLimits',[350 800]);
% xticks('');
ylim([0 200]);
xline(650,'--')
ylabel('Hours');
title('Winter');

nexttile()
histogram(springBin.Noise,'FaceColor','g','BinWidth',10,'BinLimits',[350 800]);
% xticks('');
yticks('');
ylim([0 200]);
xline(650,'--')
title('Spring');


nexttile()
histogram(summerBin.Noise,'FaceColor','r','BinWidth',10,'BinLimits',[350 800]);
% ylabel('Hours');
yticks('');
ylim([0 200]);
xTootz = xlabel('Measured Hourly HF Noise (mV)','fontweight','bold');
title('Summer');
xline(650,'--')

nexttile()
histogram(fallBin.Noise,'FaceColor','k','BinWidth',10,'BinLimits',[350 800]);
yticks('');
ylim([0 200]);
title('Fall');
xline(650,'--',{'Challenging', 'Environment'})

nexttile()
histogram(MfallBin.Noise,'FaceColor','c','BinWidth',10,'BinLimits',[350 800]);
yticks('');
ylim([0 200]);
title('Mariner''s Fall');
xline(650,'--')


export_fig annualDifferences.jpeg -r600 -transparent

%%