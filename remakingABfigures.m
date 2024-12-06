

%%
%
buildReceiverData   
% buildReceiverDataFISH
% load receiverDataONLYMOORINGS.mat

for k = 1:length(receiverData)
    receiverData{k}.Temp = fillmissing(receiverData{k}.Temp,'linear')
    receiverData{k}.HourlyDets = fillmissing(receiverData{k}.HourlyDets,'linear')
    receiverData{k}.Noise = fillmissing(receiverData{k}.Noise,'linear')
    receiverData{k}.windSpd = fillmissing(receiverData{k}.windSpd,'linear')
    receiverData{k}.waveHeight = fillmissing(receiverData{k}.waveHeight,'linear')
    receiverData{k}.bulkThermalStrat = fillmissing(receiverData{k}.bulkThermalStrat,'linear')
        
end


clearvars only*
noiseCondition = receiverData{5}.Noise <650;
seasonCondition = receiverData{5}.Season == 5;

selectedRows = noiseCondition & seasonCondition;

onlymyRows = receiverData{5}(selectedRows,:);
onlySSNRows = receiverData{5}(seasonCondition,:);




[R,P] = corrcoef(receiverData{2}.windSpd,receiverData{2}.bulkThermalStrat)
R(1,2)*R(1,2)


%%
% Collision analysis
cd ('C:\Users\fmm17241\OneDrive - University of Georgia\data\collisionAnalysis')

fishTagAnalysis = readtable('fishTagCollisions.csv')
mooringTagAnalysis = readtable('mooringCollisions.csv')
choTagAnalysis = readtable('choCollisions.csv')

fishTagAnalysis.CollisionProb = 1-fishTagAnalysis.mean;
mooringTagAnalysis.CollisionProb = 1-mooringTagAnalysis.mean;
choTagAnalysis.CollisionProb = 1-choTagAnalysis.mean;


figure()
plot(fishTagAnalysis.Var1,fishTagAnalysis.CollisionProb,'r','LineWidth',3);
hold on
plot(mooringTagAnalysis.Var1,mooringTagAnalysis.CollisionProb,'b','LineWidth',3);
title('Collision Probability Analysis: Gray''s Reef 2020','(1-Detection Probability)')
scatter(fishTagAnalysis.Var1(6),fishTagAnalysis.CollisionProb(6),70,'k','filled')
scatter(mooringTagAnalysis.Var1(4),mooringTagAnalysis.CollisionProb(4),70,'k','filled')
plot(choTagAnalysis.Var1,choTagAnalysis.CollisionProb,'k--','LineWidth',4)
legend('Fish Tags','Moorings','Worst Case 2020','','Cho et al 2016')
ylabel('Collision Probability')
xlabel('# of Transmitters within Detection Range')



figure()
plot(mooringTagAnalysis.Var1,mooringTagAnalysis.CollisionProb)


%%


for k = 1:length(receiverData)
    hourlyAVG{k} = retime(receiverData{k},'hourly','mean');
    hourlyVAR{k}= retime(receiverData{k},'hourly',@std);

    dailyAVG{k} = retime(receiverData{k},'daily','mean');
    dailyVAR{k} = retime(receiverData{k},'daily',@std);
    
    monthlyAVG{k} = retime(receiverData{k},'monthly','mean');
    monthlyVAR{k} = retime(receiverData{k},'monthly',@std);
end

for k = 1:length(receiverDataFISH)
    hourlyAVGFISH{k} = retime(receiverDataFISH{k}(15:end,:),'hourly','mean');
    hourlyVARFISH{k}= retime(receiverDataFISH{k}(15:end,:),'hourly',@std);
    
    dailyAVGFISH{k} = retime(receiverDataFISH{k}(15:end,:),'daily','mean');
    dailyVARFISH{k} = retime(receiverDataFISH{k}(15:end,:),'daily',@std);
    
    monthlyAVGFISH{k} = retime(receiverDataFISH{k}(15:end,:),'monthly','mean');
    monthlyVARFISH{k} = retime(receiverDataFISH{k}(15:end,:),'monthly',@std);
end

index = receiverData{1}.daytime ==1;



figure()
tiledlayout(2,4)
ax1 = nexttile([1,4])
plot(dailyAVG{1}.DT,dailyAVG{1}.Noise)
ylabel('HF Noise (mV)')
yyaxis right
plot(dailyAVG{1}.DT,dailyAVG{1}.HourlyDets)
ylabel('Hourly Dets')
title('Daily Averages: Low Tag Environment','Only Other Moorings!')
ax2 = nexttile([1,4])
plot(dailyAVGFISH{1}.DT,dailyAVGFISH{1}.Noise)
ylabel('HF Noise (mV)')
yyaxis right
plot(dailyAVGFISH{1}.DT,dailyAVGFISH{1}.HourlyDets_2)
ylabel('Hourly Dets')
title('','Only Fish!')
%
figure()
tiledlayout(2,4)
ax1 = nexttile([1,4])
plot(monthlyAVG{1}.DT,monthlyAVG{1}.Noise)
ylabel('HF Noise (mV)')
yyaxis right
plot(monthlyAVG{1}.DT,monthlyAVG{1}.HourlyDets)
ylabel('Hourly Dets')
title('monthly Averages: Low Tag Environment','Only Other Moorings!')
ax2 = nexttile([1,4])
plot(monthlyAVGFISH{1}.DT,monthlyAVGFISH{1}.Noise)
ylabel('HF Noise (mV)')
yyaxis right
plot(monthlyAVGFISH{1}.DT,monthlyAVGFISH{1}.HourlyDets_2)
ylabel('Hourly Dets')
title('','Only Fish!')
%

figure()
plot(dailyAVG{2}.DT,dailyAVG{2}.Noise)
yyaxis right
plot(monthlyAVG{2}.DT,monthlyAVG{2}.HourlyDets)



[r,p] = corrcoef(dailyAVG{2}.Noise,dailyAVG{2}.HourlyDets)
Rsqrd = r(1,2)*r(1,2)


[r,p] = corrcoef(monthlyAVG{2}.Noise,monthlyAVG{2}.HourlyDets)
Rsqrd = r(1,2)*r(1,2)

[r,p] = corrcoef(monthlyAVG{1}.bulkThermalStrat,monthlyAVG{1}.HourlyDets)
Rsqrd = r(1,2)*r(1,2)


[r,p] = corrcoef(monthlyAVG{2}.Temp,monthlyAVG{2}.HourlyDets)
Rsqrd = r(1,2)*r(1,2)