
%Use justdoit first. Im tired

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Glider\Data\Environmental\full'

bellhop('Mar28Late')
[gridpoints,gridrays,sumRays] = loadray('Mar28Late');

bellhop('SpringMidnight')
[gridpoints2,gridrays2,sumRays2] = loadray('SpringMidnight');

bellhop('Nov24Afternoon')
[gridpoints3,gridrays3,sumRays3] = loadray('Nov24Afternoon');


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
BinnedEfficienciesBoth = flip(BinnedEfficienciesBoth)*100;
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
BinnedEfficiencies19 = flip(BinnedEfficiencies19)*100;


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
BinnedEfficiencies20 = flip(BinnedEfficiencies20)*100;


x2 = x*100;
percents1 = sumRays/(sumRays(200))*100;
index     = percents1 >100;
percents1(index) = 100;
percents2 = sumRays2/(sumRays2(200))*100;
index     = percents2 >100;
percents2(index) = 100;
percents3 = sumRays3/(sumRays3(200))*100;
index     = percents3 >100;
percents3(index) = 100;
left_color = [0 0 0];
right_color = [0 .3 .3];

c9 = figure()
set(c9,'defaultAxesColorOrder',[left_color; right_color]);
yyaxis left
scatter(gridpoints,percents1,3.5,'k','filled');
hold on
scatter(gridpoints,percents2,3.5,'b','filled');
scatter(gridpoints,percents3,3.5,'r','filled');
ylabel('Rays Present (%)');
% xticks([0 500 1000 1500 2000]);
% set(gca,'XTickLabel',{0 '500m' '1000m' '1500m' '2000m'}),
xtickangle(45);
ylim([0 50]);
xlabel('Range (m)')
yyaxis right
scatter(x2,BinnedEfficiencies20,40,'bsq','filled');
scatter(x2,BinnedEfficiencies19,40,'r^','filled');
j =  scatter(600,20,300,'d','filled');
ff = scatter(167,32,300,'sq','filled');
ylim([0 50]);
yticks([0 10 20 30 40 50]);

ylabel('Detection Efficiency (%)');

% scatter(x2,BinnedEfficienciesBoth,'b','filled');
title('Beam Density Analysis & Experimental Efficiency');
legend('March','April','November','April Efficiency','Nov. Efficiency');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



testrays = isfinite(gridrays(:,:));
testrays2 = isfinite(gridrays2(:,:));
testrays3 = isfinite(gridrays3(:,:));



test1bot= sum(testrays(1:500,:),1);
test1top= sum(testrays(501:1000,:),1);

test2bot= sum(testrays2(1:500,:),1);
test2top= sum(testrays2(501:1000,:),1);

test3bot= sum(testrays3(1:500,:),1);
test3top= sum(testrays3(501:1000,:),1);



figure()
scatter(gridpoints,test1bot,'r');
hold on
scatter(gridpoints,test1top,'b');

figure()
scatter(gridpoints,test2bot,'r');
hold on
scatter(gridpoints,test2top,'b');

figure()
scatter(gridpoints,test3bot,'r');
hold on
scatter(gridpoints,test3top,'b');



























%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
copy19 = interp1(gridpoints,percents3,x2);
copy20 = interp1(gridpoints,percents2,x2);



correlation19= corrcoef(copy19,BinnedEfficiencies19);
correlation20= corrcoef(copy20,BinnedEfficiencies20);

correlation19
correlation20


subcorrelation19= corrcoef(copy19(2:end),BinnedEfficiencies19(2:end));
subcorrelation20= corrcoef(copy20(2:end),BinnedEfficiencies20(2:end));

subcorrelation19
subcorrelation20

rsqrd19 = subcorrelation19.^2
rsqrd20 = subcorrelation20.^2



test19 = [copy19';BinnedEfficiencies19];
test20 = [copy20';BinnedEfficiencies20];

poop = rms(test19);
poopy= rms(test20);









