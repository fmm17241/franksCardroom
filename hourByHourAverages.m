%%
%Frank responding to a critique about diurnal cycles. Not just day and night, instead take average values at the different hours.

%load in environmental and detection data
buildReceiverData   

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis\matlabVariables'
% % Full snaprate dataset
load snapRateDataSpring
% % Snaprate binned hourly
load snapRateHourlySpring
% % Snaprate binned per minute
load snapRateMinuteSpring
load surfaceDataSpring
load filteredData4Bin40HrLowSPRING.mat
times = surfaceData.time;





%Breakdown array by hours, not months or anything
% Preallocate cell array to store data for each hour
hourlyData = cell(13, 24);

% Loop over all 24 hours
for transceiver = 1:length(receiverData)
    for h = 0:23
        hourlyData{transceiver,h+1} = receiverData{transceiver}(hour(receiverData{transceiver}.DT) == h, :);
        snapsByHour{h+1} = snapRateHourly(hour(snapRateHourly.Time)==h,:);
    end
end

%Combines all the hourly data from the entire set.
for h = 1:24
    %Noise
    totalEachHour.Noise{h} = [hourlyData{1,h}.Noise; hourlyData{2,h}.Noise;hourlyData{3,h}.Noise; hourlyData{4,h}.Noise;hourlyData{5,h}.Noise; hourlyData{6,h}.Noise;...
        hourlyData{7,h}.Noise; hourlyData{8,h}.Noise;hourlyData{9,h}.Noise; hourlyData{10,h}.Noise;hourlyData{11,h}.Noise; hourlyData{12,h}.Noise;hourlyData{13,h}.Noise];
    %Bottom Temp
    totalEachHour.Temp{h} = [hourlyData{1,h}.Temp; hourlyData{2,h}.Temp;hourlyData{3,h}.Temp; hourlyData{4,h}.Temp;hourlyData{5,h}.Temp; hourlyData{6,h}.Temp;...
        hourlyData{7,h}.Temp; hourlyData{8,h}.Temp;hourlyData{9,h}.Temp; hourlyData{10,h}.Temp;hourlyData{11,h}.Temp; hourlyData{12,h}.Temp;hourlyData{13,h}.Temp];
    %Windspeed
    totalEachHour.windSpd{h} = [hourlyData{1,h}.windSpd; hourlyData{2,h}.windSpd;hourlyData{3,h}.windSpd; hourlyData{4,h}.windSpd;hourlyData{5,h}.windSpd; hourlyData{6,h}.windSpd;...
        hourlyData{7,h}.windSpd; hourlyData{8,h}.windSpd;hourlyData{9,h}.windSpd; hourlyData{10,h}.windSpd;hourlyData{11,h}.windSpd; hourlyData{12,h}.windSpd;hourlyData{13,h}.windSpd];
    %Bulk thermal strat
    totalEachHour.bulkThermalStrat{h} = [hourlyData{1,h}.bulkThermalStrat; hourlyData{2,h}.bulkThermalStrat;hourlyData{3,h}.bulkThermalStrat; hourlyData{4,h}.bulkThermalStrat;hourlyData{5,h}.bulkThermalStrat; hourlyData{6,h}.bulkThermalStrat;...
        hourlyData{7,h}.bulkThermalStrat; hourlyData{8,h}.bulkThermalStrat;hourlyData{9,h}.bulkThermalStrat; hourlyData{10,h}.bulkThermalStrat;hourlyData{11,h}.bulkThermalStrat; hourlyData{12,h}.bulkThermalStrat;hourlyData{13,h}.bulkThermalStrat];
    %Detections
    totalEachHour.Detections{h} = [hourlyData{1,h}.HourlyDets; hourlyData{2,h}.HourlyDets;hourlyData{3,h}.HourlyDets; hourlyData{4,h}.HourlyDets;hourlyData{5,h}.HourlyDets; hourlyData{6,h}.HourlyDets;...
        hourlyData{7,h}.HourlyDets; hourlyData{8,h}.HourlyDets;hourlyData{9,h}.HourlyDets; hourlyData{10,h}.HourlyDets;hourlyData{11,h}.HourlyDets; hourlyData{12,h}.HourlyDets;hourlyData{13,h}.HourlyDets];

end


%%
% Finding the means and variances of all these mooks.
for h = 1:24
    avrgNoise(h) = nanmean(totalEachHour.Noise{h})
    varNoise(h)  = nanvar(totalEachHour.Noise{h})

    avgDetections(h) = nanmean(totalEachHour.Detections{h});
    varDetections(h)  = nanvar(totalEachHour.Detections{h})

    avgSnaps(h) = nanmean(snapsByHour{h}.SnapCount)

end


%%
%Day Noise Confidence Intervals
for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(totalEachHour.Noise{h},'omitnan')/sqrt(length(totalEachHour.Noise{h}));  
    ts = tinv([0.025  0.975],length(totalEachHour.Noise{h})-1);  
    CIdayNoise(h,:) = mean(totalEachHour.Noise{h},'all','omitnan') + ts*SEM; 
end



%%

X = 1:24
figure();
tiledlayout(2,4)
ax1 = nexttile([1,4])
yyaxis left
plot(X,avrgNoise,'LineWidth',3);
ylabel('Noise (mV)')
yyaxis right
plot(X,avgSnaps,'LineWidth',3);
ylabel('Snaps')
title('Hourly Averages','UTC, Jan-May')
ax2 = nexttile([1,4])
yyaxis left
plot(X,avrgNoise,'LineWidth',3);
ylabel('Noise (mV)')
yyaxis right
plot(X,avgDetections,'LineWidth',3)
ylabel('Detections')

%%
%Okay I want to make this prettier. 
% Right now, 1:24 stands for 00:00 - 23:00 UTC! I want to switch to EST to make
% the trend more obvious.
% or Duh, don't change it, just change "X" to plot it prettier. Hmmhtmg dhthskl;bgmk;lgbf;m m    gfog 


figure()
tiledlayout(2,4)
ax1 = nexttile([1,4])
yyaxis left
plot(X,avrgNoise,'lineWidth',3);

yyaxis right
plot(X,avgSnaps,'lineWidth',3);
xticks(X);
xticklabels({'Sunset','Sunset','22','','00','','','03','','','','Sunrise','Sunrise','09','','','Midday','','','15','','','','Sunset'})
legend('HF Noise','Snaps')

ax2 = nexttile([1,4])
yyaxis left
plot(X,avrgNoise,'lineWidth',3);
ylabel('HF Noise (mV)')
yyaxis right
plot(X,avgDetections,'lineWidth',3);
ylabel('Detections')
legend('HF Noise','Detections')
xticks(X);
xticklabels({'Sunset','Sunset','22','','00','','','03','','','','Sunrise','Sunrise','09','','','Midday','','','15','','','','Sunset'})


% ax1.YAxis(1).Color = 'k';
% ax1.YAxis(2).Color = 'k';


