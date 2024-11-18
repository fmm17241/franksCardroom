%%
%Frank responding to a critique about diurnal cycles. Not just day and night, instead take average values at the different hours.

%load in environmental and detection data
buildReceiverData   

% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis\matlabVariables'
% % Full snaprate dataset
load snapRateDataSpring
% % Snaprate binned hourly
load snapRateHourlySpring
% % Snaprate binned per minute
load snapRateMinuteSpring
load surfaceDataSpring
load filteredData4Bin40HrLowSPRING.mat
times = surfaceData.time;


%FM testing
%frank sees a difference in phasing, I think noise is reported an hour
%later than it should.

% test = timetable(receiverData{1}.DT(1:end-1), receiverData{1}.Noise(2:end), receiverData{1}.HourlyDets(1:end-1));
% test.Var1(1471) = 735;
% [R,P] = corrcoef(test.Var1(1:7755),test.Var2(1:7755))
% [R,P] = corrcoef(receiverData{1}.Noise,receiverData{1}.HourlyDets)
% 
% sum(isnan(test.Var2(1:7755)))
% 
% indx = isnan(test.Var1);
% findem = test(indx,:)
% 

%Breakdown array by hours, not months or anything
% Preallocate cell array to store data for each hour
hourlyData = cell(13, 24);

% Loop over all 24 hours
for transceiver = 1:length(receiverData)
    for h = 0:23
        hourlyData{transceiver,h+1} = receiverData{transceiver}(hour(receiverData{transceiver}.DT) == h, :);
        %This is frank changing the hourly data by one to compare phasing.
        % hourlyData{transceiver,h+1}.DT = hourlyData{transceiver,h+1}.DT - hours(1);
        snapsByHour{h+1} = snapRateHourly(hour(snapRateHourly.Time)==h,:);
        
    end
end

% hourlyData{1,1}.DT = hourlyData{1,1}.DT - hour(1);



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
    CIhourlyNoise(h,:) = mean(totalEachHour.Noise{h},'all','omitnan') + ts*SEM; 
end

for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(snapsByHour{h}.SnapCount,'omitnan')/sqrt(length(snapsByHour{h}.SnapCount));  
    ts = tinv([0.025  0.975],length(snapsByHour{h}.SnapCount)-1);  
    CIhourlySnaps(h,:) = mean(snapsByHour{h}.SnapCount,'all','omitnan') + ts*SEM; 
end

for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(totalEachHour.Detections{h},'omitnan')/sqrt(length(totalEachHour.Detections{h}));  
    ts = tinv([0.025  0.975],length(totalEachHour.Detections{h})-1);  
    CIhourlyDetections(h,:) = mean(totalEachHour.Detections{h},'all','omitnan') + ts*SEM; 
end

for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(totalEachHour.Temp{h},'omitnan')/sqrt(length(totalEachHour.Temp{h}));  
    ts = tinv([0.025  0.975],length(totalEachHour.Temp{h})-1);  
    CIhourlyTemp(h,:) = mean(totalEachHour.Temp{h},'all','omitnan') + ts*SEM; 
end


for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(totalEachHour.windSpd{h},'omitnan')/sqrt(length(totalEachHour.windSpd{h}));  
    ts = tinv([0.025  0.975],length(totalEachHour.windSpd{h})-1);  
    CIhourlyWinds(h,:) = mean(totalEachHour.windSpd{h},'all','omitnan') + ts*SEM; 
end

for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(totalEachHour.bulkThermalStrat{h},'omitnan')/sqrt(length(totalEachHour.bulkThermalStrat{h}));  
    ts = tinv([0.025  0.975],length(totalEachHour.bulkThermalStrat{h})-1);  
    CIhourlyStrat(h,:) = mean(totalEachHour.bulkThermalStrat{h},'all','omitnan') + ts*SEM; 
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

X = 1:24;

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
%%

figure()
tiledlayout(2,4)
ax1 = nexttile([1,4])
hold on
yyaxis left
ciplot(CIhourlyNoise(:,1),CIhourlyNoise(:,2),1:24,'b')
ylabel('HF Noise (mV)')
yyaxis right
ciplot(CIhourlySnaps(:,1),CIhourlySnaps(:,2),1:24,'r')
ylabel('Snaps/hr')
xlabel('Seasons, 2020')
% ylabel('Average Noise (mV)')
title('Noise Creation by Time of Day','95% Conf. Interval')
legend('Noise','Snaps')
xticks(X);
xticklabels({'Sunset','','22','','00','','','03','','','','Sunrise','Sunrise','09','','','Midday','','','15','','','','Sunset'})

ax1.YAxis(1).Color = 'k';
ax1.YAxis(2).Color = 'k';

ax2 = nexttile([1,4])
hold on
yyaxis left
ciplot(CIhourlyNoise(:,1),CIhourlyNoise(:,2),1:24,'b')
ylabel('HF Noise (mV)')
yyaxis right
ciplot(CIhourlyDetections(:,1),CIhourlyDetections(:,2),1:24,'k')
ylabel('Detections/hr')
xlabel('Seasons, 2020')
% ylabel('Average Noise (mV)')
title('Noise Interference by Time of Day','95% Conf. Interval')
legend('Noise','Detections')
xticks(X);
xticklabels({'Sunset','','22','','00','','','03','','','','Sunrise','Sunrise','09','','','Midday','','','15','','','','Sunset'})

ax2.YAxis(1).Color = 'k';
ax2.YAxis(2).Color = 'k';
