% Mooring groupingz. Separating by location. I live my life.


%Mooring groups: 
%1st is 2,3,4,15;  
%3rd is 7,8,9,16;
%2nd is 11,12,13,14;
% Singles: 1,5,6,10

setgroup(1,:) = [2,3,4,15];
setgroup(2,:) = [7,8,9,16];
setgroup(3,:) = [11,12,13,14];
setgroup(4,:) = [1,5,6,10];
x = 1:4;

for k = 1:4
    groupies.timespent(k,:)  = timez{1,1}(setgroup(k,:));
    groupies.alldetects(k,:) = alldets{1}(setgroup(k,:));
    groupies.efficiency(k,:) = efficiency20.onekm(setgroup(k,:));
end
groupies.names = moored;


fig = tiledlayout(2,2);
left_color  = [0 0 1]; % Blue
right_color = [0 0 0]; % Black
set(fig,'defaultAxesColorOrder',[left_color; right_color]);


ax1 = nexttile;
yyaxis left
b = bar(groupies.timespent(1,:),'b');
ylim([0 2000])
yyaxis right
plot(x,groupies.efficiency(1,:),'w*');
ylim([0 0.4]);

ax2 = nexttile;
yyaxis left
bb = bar(groupies.timespent(2,:),'g');
ylim([0 2000])
ax2.YColor = [0 0.5 0];
set(ax2,'yticklabel',[]);
yyaxis right
ylabel('Detection Efficiency');
plot(x,groupies.efficiency(2,:),'k*');
ylim([0 0.4]);

ax3 = nexttile;
yyaxis left
bbb = bar(groupies.timespent(3,:),'r');
ylim([0 2000])
ax3.YColor = [0.5 0 0];
yyaxis right
plot(x,groupies.efficiency(1,:),'k*');
ylim([0 0.4]);

ax4 = nexttile;
yyaxis left
bbbb = bar(groupies.timespent(4,:),'m');
ylim([0 2000])
ax4.YColor = [1 0 1];
set(ax4,'yticklabel',[]);
yyaxis right
ylabel('Detection Efficiency');
plot(x,groupies.efficiency(1,:),'k*');
ylim([0 0.4]);

set(ax1,'xticklabel',[]);
set(ax1,'yticklabel',[]);
set(ax2,'xticklabel',[]);
set(ax3,'yticklabel',[]);

fig.Padding = 'compact';
fig.TileSpacing = 'none';
