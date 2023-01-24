% truthing2014.m has become corrupted and we shall not speak of it going
% forward, under penalty of intense frowning and sighing.
%Go to correct data folder
cd D:\Glider\Data\2014

% Load in processed receiver and detection data 
load receiver_reordered.mat

rec.timeDT = datetime(rec.timeDN,'convertfrom','datenum','timezone','utc');

%Picking receiver pairs that were successful and oriented in certain
%directions.
detsCross1 = [rec.r4_5m rec.r6_5m rec.r1_2m]; detsCross = nanmean(detsCross1,2);
detsAlong1 = [rec.r1_4m rec.r4_1m rec.r6_3m]; detsAlong = nanmean(detsAlong1,2);


%%
%Load in ADCP data from 2014, allows for prediction and truthing of tides.

load GR_adcp_magrot
adcp.time = datetime(adcp.dn,'convertfrom','datenum','timezone','utc')';
% Cleaning data
uz = nanmean(adcp.u);
vz = nanmean(adcp.v);
xin = (uz+sqrt(-1)*vz);

%t_tide, separating currents into constituents
[struct, xout] = t_tide(xin,'interval',adcp.dth,'start time',adcp.dn(1),'latitude',adcp.lat);


%Separate tides into vectors
tideU = real(xout);
tideV = imag(xout);

datetide = [16,20,08,2014];

%t_tide order of constituents:
% 15 = M2, Lunar semidiurnal
% 17 = S2, Solar semidiurnal
% 14 = N2, Lunar elliptical, perigee
% 8 = K1,  Lunar diurnal
% 6 = O1,  Lunar Diurnal
% 5 = Q1,  Larger lunar elliptical diurnal
tTideOrder = [15,17,14,8,6,5]; % Full tides for consideration
% tTideOrder = [14]; %Isolating certain tides.


% uvpred order of constituents: 
% 1 = M2, 2 = S2, 3 = N2, 4 = K1, 6 = O1, 26 = Q1
UVOrder    = [1,2,3,4,6,26];% Full tides for consideration
% UVOrder    = [3]; %Isolating certain tides.

%Below is the one I use. Commenting out to test
[timePrediction,ut,vt] = uvpred(struct.tidecon(tTideOrder,1),struct.tidecon(tTideOrder,3),struct.tidecon(tTideOrder,7),...
    struct.tidecon(tTideOrder,5),UVOrder,datetide,1,53.125);


tideDN=datenum(2014,08,20,16,00,00):1/24:datenum(2014,10,12,19,00,00);
tideDT=datetime(tideDN,'ConvertFrom','datenum','TimeZone','UTC')';

tidalz = [tideU;tideV].';
[coef, ~,~,~] = pca(tidalz);
theta = coef(3);


[rotUtide,rotVtide] = rot(ut,vt,theta);
tides = [rotUtide' rotVtide']';


%%
windsAnalysis2014

%%
%Now process it all and put it in one pretty box widda BOW.
fullTime = [datetime(2014,08,20,16,00,00),datetime(2014,10,12,19,00,00)];
fullTime.TimeZone = 'UTC';

windsIndex = isbetween(windsAverage.time,fullTime(1,1),fullTime(1,2),'closed');
fullWindsData = [windsU(windsIndex) windsV(windsIndex) WSPD(windsIndex) WDIR(windsIndex)];


fullData = table2timetable(table(tideDT, detsAlong,detsCross, WSPD(windsIndex), WDIR(windsIndex), tides'));
fullData.Properties.VariableNames = {'detsAlong','detsCross','windSpeed','windDir','tidalData'};

clearvars -except fullData detections time bottom* receiverData

%%
%Okay, working it. Now have to rehab and create wind + tide bins.



windBins(1,:) = fullData.windSpeed < 1; 
windBins(2,:) = fullData.windSpeed > 1 & fullData.windSpeed < 2; 
windBins(3,:) = fullData.windSpeed > 2 & fullData.windSpeed < 3; 
windBins(4,:) = fullData.windSpeed > 3 & fullData.windSpeed < 4; 
windBins(5,:) = fullData.windSpeed > 4 & fullData.windSpeed < 5; 
windBins(6,:) = fullData.windSpeed > 5 & fullData.windSpeed < 6; 
windBins(7,:) = fullData.windSpeed > 6 & fullData.windSpeed < 7; 
windBins(8,:) = fullData.windSpeed > 7 & fullData.windSpeed < 8; 
windBins(9,:) = fullData.windSpeed > 8 & fullData.windSpeed < 9; 
windBins(10,:) = fullData.windSpeed > 9 & fullData.windSpeed < 10; 
windBins(11,:) = fullData.windSpeed > 10 & fullData.windSpeed < 11; 
windBins(12,:) = fullData.windSpeed > 11 & fullData.windSpeed < 12;
windBins(13,:) = fullData.windSpeed > 12 & fullData.windSpeed < 13; 
windBins(14,:) = fullData.windSpeed > 13 & fullData.windSpeed < 14; 
windBins(15,:) = fullData.windSpeed > 14; 

%%

% average = zeros(1,height(windBins))

for k = 1:height(windBins)
    windScenario{k}= fullData(windBins(k,:),:);
    averageWindX(1,k) = mean(windScenario{1,k}.detsCross);
    averageWindA(1,k) = mean(windScenario{1,k}.detsAlong);
end
normalizedWindX  = averageWindX/(max(averageWindX));
normalizedWindA  = averageWindA/(max(averageWindA));


x = 0.5:14.5;
figure()

scatter(x,normalizedWindA,'r','filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
hold on
scatter(x,normalizedWindX,'b','filled','MarkerFaceAlpha',.6,'MarkerEdgeAlpha',1)
xlabel('Windspeed (m/s)');
ylabel('Normalized Detections');
legend({'Along-Pairs','Cross-Pairs'});
title('2014 Cross and Alongshore Pairs');


%%
%Okay, now tides:
clearvars -except fullData


tideBinsX(1,:) = fullData.tidalData(:,1) < -.4 ;
tideBinsX(2,:) =  fullData.tidalData(:,1) > -.4 &  fullData.tidalData(:,1) < -.35 ;
tideBinsX(3,:) =  fullData.tidalData(:,1) > -.35 &  fullData.tidalData(:,1) < -.30 ;
tideBinsX(4,:) =  fullData.tidalData(:,1) > -.30 & fullData.tidalData(:,1) <-.25 ;
tideBinsX(5,:) =  fullData.tidalData(:,1) > -.25 &  fullData.tidalData(:,1) < -.20 ;
tideBinsX(6,:) =  fullData.tidalData(:,1) > -.20 &  fullData.tidalData(:,1) < -.15 ;
tideBinsX(7,:) =  fullData.tidalData(:,1) > -.15 &  fullData.tidalData(:,1) < -.10 ;
tideBinsX(8,:) =  fullData.tidalData(:,1) > -.1 &  fullData.tidalData(:,1) < -.05 ;
tideBinsX(9,:) =  fullData.tidalData(:,1) > -.05 &  fullData.tidalData(:,1) < 0.05 ;
%     tideBinsX(10,:) = fullData.tidalData(:,1) < .05 &  fullData.tidalData(:,1) > 0 ;
tideBinsX(10,:) =  fullData.tidalData(:,1) > .05 &  fullData.tidalData(:,1) < .1 ;
tideBinsX(11,:) =  fullData.tidalData(:,1) > .1 &  fullData.tidalData(:,1) < .15 ;
tideBinsX(12,:) =  fullData.tidalData(:,1) > .15 & fullData.tidalData(:,1) < .2 ;
tideBinsX(13,:) =  fullData.tidalData(:,1) > .2 &  fullData.tidalData(:,1) < .25 ;
tideBinsX(14,:) =  fullData.tidalData(:,1) > .25&  fullData.tidalData(:,1) < .3 ;
tideBinsX(15,:) =  fullData.tidalData(:,1) > .3 &  fullData.tidalData(:,1) < .35 ;
tideBinsX(16,:) =  fullData.tidalData(:,1) > .35 &  fullData.tidalData(:,1) < .4 ;
tideBinsX(17,:) =  fullData.tidalData(:,1) > .4 ;

%Alongshore
tideBinsAlong(1,:) = fullData.tidalData(:,2) < -.1;
tideBinsAlong(2,:) = fullData.tidalData(:,2) > -.1 & fullData.tidalData(:,2) < -.09 ;
tideBinsAlong(3,:) = fullData.tidalData(:,2) > -.09 & fullData.tidalData(:,2) < -.08 ;
tideBinsAlong(4,:) = fullData.tidalData(:,2) > -.08 & fullData.tidalData(:,2) < -.07 ;
tideBinsAlong(5,:) = fullData.tidalData(:,2) > -.07 & fullData.tidalData(:,2) < -.06 ;
tideBinsAlong(6,:) = fullData.tidalData(:,2) > -.06 & fullData.tidalData(:,2) < -.05 ;
tideBinsAlong(7,:) = fullData.tidalData(:,2) > -.05 & fullData.tidalData(:,2) < -.04 ;
tideBinsAlong(8,:) = fullData.tidalData(:,2) > -.04 & fullData.tidalData(:,2) < -.03 ;
tideBinsAlong(9,:) = fullData.tidalData(:,2) > -.03 & fullData.tidalData(:,2) < -.02 ;
tideBinsAlong(9,:) = fullData.tidalData(:,2) > -.02 & fullData.tidalData(:,2) < -.01 ;

tideBinsAlong(10,:) = fullData.tidalData(:,2) > -.01 & fullData.tidalData(:,2) < .01 ;

tideBinsAlong(11,:) = fullData.tidalData(:,2) > .01 & fullData.tidalData(:,2) < .02 ;
tideBinsAlong(12,:) = fullData.tidalData(:,2) > .02 & fullData.tidalData(:,2) < .03 ;
tideBinsAlong(13,:) = fullData.tidalData(:,2) > .03 & fullData.tidalData(:,2) < .04 ;
tideBinsAlong(14,:) = fullData.tidalData(:,2) > .04 & fullData.tidalData(:,2) < .05 ;
tideBinsAlong(15,:) = fullData.tidalData(:,2) > .05 & fullData.tidalData(:,2) < .06 ;
tideBinsAlong(16,:) = fullData.tidalData(:,2) > .06 & fullData.tidalData(:,2) < .07 ;
tideBinsAlong(17,:) = fullData.tidalData(:,2) > .07 & fullData.tidalData(:,2) < .08 ;
tideBinsAlong(18,:) = fullData.tidalData(:,2) > .08 & fullData.tidalData(:,2) < .09 ;
tideBinsAlong(19,:) = fullData.tidalData(:,2) > .09 & fullData.tidalData(:,2) < .1 ;
tideBinsAlong(20,:) = fullData.tidalData(:,2) > .1 ;



for k = 1:height(tideBinsX)
    tideScenarioX{k}= fullData(tideBinsX(k,:),:);
    averageXX(1,k) = mean(tideScenarioX{1,k}.detsCross);
    averageXA(1,k) = mean(tideScenarioX{1,k}.detsAlong);
end
moddedAverageXX  = averageXX/(max(averageXX));
moddedAverageXA  = averageXA/(max(averageXA));



for k = 1:height(tideBinsAlong)
    tideScenarioA{k}= fullData(tideBinsAlong(k,:),:);
    averageAA(1,k) = mean(tideScenarioA{1,k}.detsAlong);
    averageAX(1,k) = mean(tideScenarioA{1,k}.detsCross);
end
moddedAverageAA  = averageAA/(max(averageAA));
moddedAverageAX  = averageAX/(max(averageAX));


x = -.09:.01:.1;
figure()
scatter(x,moddedAverageAA,'k','filled');
hold on
scatter(x,moddedAverageAX,'m','filled');
legend('Along-Shore','Cross-shore');
xlabel('Current Magnitude')
ylabel('Normalized Detection Efficiency')
title('2014 AShore current vs Transceiver Pairs')



x = -0.4:0.05:.4;
figure()
scatter(x,moddedAverageXA,'r','filled');
hold on
scatter(x,moddedAverageXX,'b','filled');
legend('Along-Shore','Cross-shore');
xlabel('Current Magnitude')
ylabel('Normalized Detection Efficiency')
title('2014 XShore current vs Transceiver Pairs')










