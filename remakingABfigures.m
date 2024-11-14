

%%
%
% buildReceiverData   
% buildReceiverDataFISH
% load receiverDataONLYMOORINGS.mat


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