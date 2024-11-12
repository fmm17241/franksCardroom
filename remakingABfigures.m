

%%
%
buildReceiverData   


for k = 1:length(receiverData)
    hourlyAVG{k} = retime(receiverData{k},'hourly','mean');
    hourlyVAR{k}= retime(receiverData{k},'hourly',@std);
    
    dailyAVG{k} = retime(receiverData{k},'daily','mean');
    dailyVAR{k} = retime(receiverData{k},'daily',@std);
    
    monthlyAVG{k} = retime(receiverData{k},'monthly','mean');
    monthlyVAR{k} = retime(receiverData{k},'monthly',@std);
end

figure()
plot(dailyAVG{2}.DT,dailyAVG{2}.Noise)
yyaxis right
plot(dailyAVG{2}.DT,dailyAVG{2}.HourlyDets)


figure()
plot(dailyAVG{2}.DT,dailyAVG{2}.Noise)
yyaxis right
plot(monthlyAVG{2}.DT,monthlyAVG{2}.HourlyDets)

[r,p] = corrcoef(dailyAVG{2}.Noise,dailyAVG{2}.HourlyDets)
Rsqrd = r(1,2)*r(1,2)


[r,p] = corrcoef(monthlyAVG{2}.Noise,monthlyAVG{2}.HourlyDets)
Rsqrd = r(1,2)*r(1,2)

[r,p] = corrcoef(monthlyAVG{2}.bulkThermalStrat,monthlyAVG{2}.HourlyDets)
Rsqrd = r(1,2)*r(1,2)


[r,p] = corrcoef(monthlyAVG{2}.Temp,monthlyAVG{2}.HourlyDets)
Rsqrd = r(1,2)*r(1,2)