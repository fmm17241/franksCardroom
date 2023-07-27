
xLabels = { '<100m';        
%             '100m-200m';    
%             '200m-300m';    
            '300m-400m';    
%             '400m-500m';    
%             '500m-600m';    
            '600m-700m';    
%             '700m-800m';    
%             '800m-900m';    
            '900m-1000m';   
%             '1000m-1100m'; 
%             '1100m-1200m';
            '1200-1300m';
%             '1300-1400';
%             '1400-1500';
            '1500-1600';
%             '1600-1700';
%             '1700-1800';
            '1800-1900';
            '1900-2000';}; 
            

x = 1:20;

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
color = [0.9 .8 1]
left_color = [0 0 0];
right_color = [0 .3 .3];



c4 = figure()
set(c4,'defaultAxesColorOrder',[left_color; right_color]);
yyaxis right
p1=bar(x,FullTiming);
yticks([0,2000,4000,10000,12000]);
set(p1,'FaceColor',color);
% set(p1,'EdgeColor',([1 1 1]));
set(p1,'FaceAlpha',.25);
ylabel('Time Spent (min)');

yyaxis left
c  = plot(x,BinnedEfficiencies20,'b-.','LineWidth',3)
hold on
v  = plot(x,BinnedEfficiencies19,'r--','LineWidth',3)
plot(x,BinnedEfficienciesBoth,'g-','LineWidth',3)
j =  scatter(6,0.2,300,'d','filled');
ff = scatter(2,0.32,300,'sq','filled');
j.MarkerFaceAlpha = 0.75;
ff.MarkerFaceAlpha = 0.75
xticks([1:3:20]);
xtickangle(45);
xticklabels(xLabels);
ylim([0 0.5]);
yticks([0,0.1,0.2,0.3,0.4,0.5]);
xlabel('Distance (m)');
ylabel('Detection Efficiency (%)');
title('Acoustic Detection Efficiency, AUV Receiver Platform');
% legend('Time Spent','Both Efficiency','2020 Efficiency','2019 Efficiency');
legend('April','November','Average');








