
cd G:\Glider\Data\Environmental\test1

[gridpoints,gridrays,sumRays] = loadray('test1R')


%%
%Separate stuff, looking at detection efficiency while binned
%Currently: 2020

xLabels = { '<100m';        % 10-20%, Blue
            '100m-200m';    % 30-40%, Cyan
            '200m-300m';    % >=50%, Yellow
            '300m-400m';    % 20-30%, Red
            '400m-500m';    % 20-30%, Red
            '500m-600m';    % 20-30%, Red
            '600m-700m';    % 10-20%, Blue
            '700m-800m';    % 10-20%, Blue
            '800m-900m';    % 10-20%, Blue
            '9000m-1000m';   % 10-20%, Blue
            '1000m-1100m';  % <10%, White
            '1100m-1200m'}; % <10%, White

x = 1:length(xLabels);

BinnedEfficiencies20 = [0.1546391753;
0.3731859019;
0.4963516036;
0.285553127;
0.2461103253;
0.2542496005;
0.1627125761;
0.1677563661;
0.1300821303;
0.1020523869;
0.04099308373;
0.02362251225];
    


figure()
plot(x,BinnedEfficiencies20,'LineWidth',5)
hold on
scatter(x,BinnedEfficiencies20,'filled');
xticks([1:12]);
xtickangle(45);
xticklabels(xLabels);
grid on;
xlabel('Distance (m)');
ylabel('Detection Efficiency (%)');
title('2020 Binned Detection Efficiency');

figure()
t=0:0.001:2*pi;
x=cos(t);
y=sin(t);
x1=2*cos(t);y1=2*sin(t);x2=3*cos(t);y2=3*sin(t);x3=4*cos(t);y3=4*sin(t);x4=5*cos(t);y4=5*sin(t);x5=6*cos(t);y5=6*sin(t);
x6=7*cos(t);y6=7*sin(t);x7=8*cos(t);y7=8*sin(t);x8=9*cos(t);y8=9*sin(t);x9=10*cos(t);y9=10*sin(t);x10=11*cos(t);y10=11*sin(t);x11=12*cos(t);
y11=12*sin(t);
fill(x11,y11,'w',x10,y10,'w',x9,y9,'b',x8,y8,'b',x7,y7,'b',x6,y6,'b',x5,y5,'r',x4,y4,'r',...
    x3,y3,'r',x2,y2,'y',x1,y1,'c',x,y,'b');
axis equal
axis 'off'
% title('Visualized Efficiency');



%%
%Current: For 2019
xLabels = { '<100m';        % >50%,    Yellow 
            '100m-200m';    % 40-50%,  Green
            '200m-300m';    % 20-30%,  Red
            '300m-400m';    % 20-30%,  Red
            '400m-500m';    % 20-30%,  Red
            '500m-600m';    % 10-20%,  Blue
            '600m-700m';    % 10-20%,  Blue
            '700m-800m';    % 10-20%,  Blue
            '800m-900m';    % 10-20%,  Blue
            '9000m-1000m';   % 10-20%,  Blue
            '1000m-1100m';  % <10%,    White
            '1100m-1200m'}; % <10%,    White

x = 1:length(xLabels);

BinnedEfficiencies19 = [0.5732484076;
0.4378851768;
0.2762662202;
0.2337322364;
0.2998865294;
0.1981796829;
0.1695937288;
0.1773502908;
0.1407529572;
0.1013887182;
0.08132401198;
0.08705965479];
    


figure()
plot(x,BinnedEfficiencies19,'LineWidth',5)
hold on
scatter(x,BinnedEfficiencies19,'filled');
xticks([1:12]);
xtickangle(45);
xticklabels(xLabels);
grid on;
xlabel('Distance (m)');
ylabel('Detection Efficiency (%)');
title('2019 Binned Detection Efficiency');

figure()
t=0:0.001:2*pi;
x=cos(t);
y=sin(t);
x1=2*cos(t);y1=2*sin(t);x2=3*cos(t);y2=3*sin(t);x3=4*cos(t);y3=4*sin(t);x4=5*cos(t);y4=5*sin(t);x5=6*cos(t);y5=6*sin(t);
x6=7*cos(t);y6=7*sin(t);x7=8*cos(t);y7=8*sin(t);x8=9*cos(t);y8=9*sin(t);x9=10*cos(t);y9=10*sin(t);x10=11*cos(t);y10=11*sin(t);x11=12*cos(t);
y11=12*sin(t);
fill(x11,y11,'w',x10,y10,'w',x9,y9,'b',x8,y8,'b',x7,y7,'b',x6,y6,'b',x5,y5,'b',x4,y4,'r',...
    x3,y3,'r',x2,y2,'r',x1,y1,'g',x,y,'y');
axis equal
axis 'off'
% title('Visualized Efficiency');



%%
%Current: Sum of 2019 2020
FullTime = [330.8666667;
973.8666667;
1685.133333;
2273;
2710.6;
3010.066667;
3982.333333;
4734.266667;
5301.133333;
5479.2;
6033.933333;
6980.933333];



xLabels = { '<100m';        % 30-40%,  Cyan
            '100m-200m';    % 40-50%,  Green
            '200m-300m';    % 30-40%,  Cyan
            '300m-400m';    % 20-30%,  Red
            '400m-500m';    % 20-30%,  Red
            '500m-600m';    % 20-30%,  Red
            '600m-700m';    % 10-20%,  Blue
            '700m-800m';    % 10-20%,  Blue
            '800m-900m';    % 10-20%,  Blue
            '9000m-1000m';   % 10-20%,  Blue
            '1000m-1100m';  % <10%,    White
            '1100m-1200m'}; % <10%,    White

x = 1:length(xLabels);
BinnedEfficienciesBoth = [0.3841676368;
0.4029550034;
0.3855716152;
0.258047441;
0.2736167155;
0.2263599854;
0.166025548;
0.1722939274;
0.1351278673;
0.1017705466;
0.05810153243;
0.05142269455];
    
figure()
plot(x,BinnedEfficienciesBoth,'LineWidth',5)
hold on
scatter(x,BinnedEfficienciesBoth,'filled');
xticks([1:12]);
xtickangle(45);
xticklabels(xLabels);
grid on;
xlabel('Distance (m)');
ylabel('Detection Efficiency (%)');
title('2019+2020 Detection Efficiency');

figure()
t=0:0.001:2*pi;
x=cos(t);
y=sin(t);
x1=2*cos(t);y1=2*sin(t);x2=3*cos(t);y2=3*sin(t);x3=4*cos(t);y3=4*sin(t);x4=5*cos(t);y4=5*sin(t);x5=6*cos(t);y5=6*sin(t);
x6=7*cos(t);y6=7*sin(t);x7=8*cos(t);y7=8*sin(t);x8=9*cos(t);y8=9*sin(t);x9=10*cos(t);y9=10*sin(t);x10=11*cos(t);y10=11*sin(t);x11=12*cos(t);
y11=12*sin(t);
fill(x11,y11,'w',x10,y10,'w',x9,y9,'b',x8,y8,'b',x7,y7,'b',x6,y6,'b',x5,y5,'r',x4,y4,'r',...
    x3,y3,'r',x2,y2,'c',x1,y1,'g',x,y,'c');
axis equal
axis 'off'
% title('Visualized Efficiency');
color = [0.9 .8 1]
%%All plot, you punk
x = (1:length(xLabels))';

%%


figure()
yyaxis right
p1=bar(x,FullTime);
set(p1,'FaceColor',color);
% set(p1,'EdgeColor',([1 1 1]));
set(p1,'FaceAlpha',.25);
ylabel('Time Spent (min)');

yyaxis left
plot(x,BinnedEfficienciesBoth,'k','LineWidth',3)
hold on
c  = plot(x,BinnedEfficiencies20,'r','LineWidth',3)
v  = plot(x,BinnedEfficiencies19,'b','LineWidth',3)
j =  scatter(6,0.2,800,'ms','filled');
j.MarkerFaceAlpha = 0.5;

xticks([1:12]);
xtickangle(45);
xticklabels(xLabels);
grid on;
xlabel('Distance (m)');
ylabel('Detection Efficiency (%)');
title('Detection Efficiency');
legend('Both Efficiency','2020 Efficiency','2019 Efficiency','Oliver et al. 2017','Time Spent');

%% New stuff

xLabels = { '<100m';        
            '100m-200m';    
            '200m-300m';    
            '300m-400m';    
            '400m-500m';    
            '500m-600m';    
            '600m-700m';    
            '700m-800m';    
            '800m-900m';    
            '900m-1000m';   
            '1000m-1100m'; 
            '1100m-1200m';
            '1200-1300m';
            '1300-1400';
            '1400-1500';
            '1500-1600';
            '1600-1700';
            '1700-1800';
            '1800-1900';
            '1900-2000';}; 
            

x = 1:length(xLabels);

BinnedEfficiencies19 = [0.01102973617;
    0.0244086451;
    0.01918925402;
    0.02836123621;	
    0.01737605084;
    0.0201809559;	
    0.0519959133;
    0.09118051955;
    0.0659744134;
    0.0592626479;
    0.07679419157;
    0.1135555505;
    0.1416828347;
    0.133033761;
    0.1461144383;
    0.2121397447;
    0.1694455741;
    0.2106741573;
    0.3085009141;
    0.4045549895];
BinnedEfficiencies19 = flip(BinnedEfficiencies19);


BinnedEfficiencies20 = [0.002963753297;
    0.003199385718;
    0.01135564808;
    0.01817432816;
    0.006028292787;
    0.006648052121;
    0.02187992298;
    0.02055044754;
    0.01997403376;
    0.0339047884;
    0.09138169117;
    0.1118960902;
    0.1522961575;
    0.143231172;
    0.2094637727;
    0.220980442;
    0.2497841372;
    0.4310980103;
    0.3109882516;
    0.1204819277];
BinnedEfficiencies20 = flip(BinnedEfficiencies20);

BinnedEfficienciesBoth = [0.006204903647;
    0.01208425515;
    0.01451612903;
    0.02238615043;
    0.01110485949;
    0.012976697;
    0.03526035925;
    0.05303186023;
    0.0413807833;
    0.04545239335;
    0.08458402013;
    0.112707331;
    0.1469375129;
    0.1380277866;
    0.1761964306;
    0.2159356119;
    0.2034163515;
    0.312991722;
    0.3097395893;
    0.2831645787];
BinnedEfficienciesBoth = flip(BinnedEfficienciesBoth);



FullTiming = [11281.4;
    10757.8;
    10333.3;
    9380.8;
    9005.1;
    8476.7;
    8224.5;
    8108.3;
    7491.4;
    7040.3;
    6147.7;
    5944.6;
    5172.3;
    4419.4;
    3518.8;
    3056.5;
    2556.3;
    1948.9;
    1162.3;
    388.5];

FullTiming = flip(FullTiming);

figure()
yyaxis left
bar(x,FullTiming,'k');
ylabel('Time Spent (min)');

yyaxis right
plot(x,BinnedEfficienciesBoth,'g','LineWidth',3)
hold on
c  = plot(x,BinnedEfficiencies20,'r','LineWidth',3)
v  = plot(x,BinnedEfficiencies19,'b','LineWidth',3)
j =  scatter(6,0.2,800,'ms','filled');
j.MarkerFaceAlpha = 0.5;

xticks([1:20]);
xtickangle(45);
xticklabels(xLabels);
grid on;
xlabel('Distance (m)');
ylabel('Detection Efficiency (%)');
title('Detection Efficiency');
% legend('Time Spent','Both Efficiency','2020 Efficiency','2019 Efficiency');
legend('','Both Efficiency','2020 Efficiency','2019 Efficiency','Oliver et. al,2017');


distance = 600;

[DetEfficiencyRange,Efficiency] = SASGliderRange(distance);







