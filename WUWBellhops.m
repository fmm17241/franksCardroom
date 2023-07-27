
cd G:\Glider\Data\Environmental\full
% figure()
bellhop('Mar28Late')
[gridpoints,gridrays,sumRays] = loadray('Mar28Late');
% figure()
bellhop('SpringMidnight')
[gridpoints2,gridrays2,sumRays2] = loadray('SpringMidnight');
% figure()
bellhop('Nov24Afternoon')
[gridpoints3,gridrays3,sumRays3] = loadray('Nov24Afternoon');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%Testing subplot and subaxis from Caitlin Amos, rockstar, MSGSA
rr = 5; cc = 8; 
fig = figure();
% set(gcf,'Position',[300 100 1000 700])
set(gcf,'Position',[300 100 1000 700])
% CA: I changed the figure window width to 800 but the spacing in the code
% below works for 100 also

s1=subaxis(rr,cc,1:2,'MarginTop',0.04,'MarginLeft',0.06,'MarginRight',0.03,'SpacingHoriz',0.01,'SpacingVert',0.04);
hold on
plotssp('Mar28Late','k')
ticks = [1513.5 1515.5 1517.5];
xticks(ticks)
% xlabel('SSP (m/s)');
xlim([1513 1518]);
title('Sound Speed Profiles','FontSize',08);
% set(gca,'FontSize',08)
xlabel('');
ylabel('Depth (m)');


s2=subaxis(rr,cc,3:8);
bellhopM('Mar28Late')
ylim([0 17]);
xlim([0 2000]);
xticks([0 500 1000 1500 2000])
xticklabels({0 '500m' '1km' '1.5km' '2km'})
% ylabel('Depth (m)');
yticks('')
set(gca,'YTickLabel',[],'XTickLabel',[]);
% xtickangle(10);
title('A) March');
set(gca,'FontSize',11);


s3=subaxis(rr,cc,9:10);
plotssp('SpringMidnight','b')
ylabel('Depth (m)');
xlabel('');
xlim([1521.25 1523.9]);
ticks = [1521.55 1522.55 1523.55];
xticks(ticks);
% title('B) April');

s4=subaxis(rr,cc,11:16);
hold on
bellhopM('SpringMidnight')
ylim([0 16.5]);
xlim([0 2000]);
xticks([0 500 1000 1500 2000]);
set(gca,'YTickLabel',[],'XTickLabel',[]);
% xtickangle(10);
yticks('')
title('B) April');
set(gca,'FontSize',11);


s5=subaxis(rr,cc,17:18);
plotssp('Nov24Afternoon','r');
xlim([1517 1519]);
% xlabel('Sound Speed (m/s');
xlabel('');
ylabel('Depth(m)');
ticks = [1517.25 1518 1518.75];
xticks(ticks);
% title('C) November');


s6=subaxis(rr,cc,19:24);
bellhopM('Nov24Afternoon');
ylim([0 17]);
xlim([0 2000]);
set(gca,'YTickLabel',[]);
xticks([0 500 1000 1500 2000])
xticklabels({0 '0.5km' '1km' '1.5km' '2km'})
% xlabel('Distance Traveled')
yticks('')
title('C) November');
set(gca,'FontSize',11);


s7 = subaxis(rr,cc,[25:26 33:34],'MarginBottom',0.1,'MarginTop',0.12,'MarginRight',0.14);
hold on
plotssp('Mar28Late','k')
plotssp('SpringMidnight','b')
plotssp('Nov24Afternoon','r');
title('SSP Comparison');
xlim([1512 1525]);
xticks([1514 1518 1523]);



s8 = subaxis(rr,cc,[27:32 35:40],'MarginBottom',0.1,'MarginTop',0.12,'MarginRight',0.03);
hold on
scatter(gridpoints,sumRays,'k')
scatter(gridpoints,sumRays2,'b');
scatter(gridpoints,sumRays3,'r');
set(gca,'Yscale','log')
xlabel('Distance (m)');
% ylabel('# of Rays Present');
ylabel('');

xticks([0 200 400 600 800 1000 1200 1400 1600 1800 2000]);
xtickangle(45);
title('Beam Density Analysis: # of Rays Present');


%%%%%%%%%
% example for how to change title font size:
% title('A) March','FontSize',14);

% change font size for tick and x/y labels:
% set(gca,'FontSize',14)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
