%%
%Frank responding to a critique about diurnal cycles. Not just day and night, instead take average values at the different hours.
%THIS ONLY TAKES ONE TRANSCEIVER'S WORTH OF DATA.
%load in environmental and detection data
buildReceiverData   
transceiver = 2;

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


%FM testing

%Breakdown array by hours, not months or anything
% Preallocate cell array to store data for each hour
hourlyData = cell(1, 24);

% Loop over all 24 hours

for h = 0:23
    hourlyData{h+1} = receiverData{transceiver}(hour(receiverData{transceiver}.DT) == h, :);
    %This is frank changing the hourly data by one to compare phasing.
    % hourlyData{transceiver,h+1}.DT = hourlyData{transceiver,h+1}.DT - hours(1);
    snapsByHour{h+1} = snapRateHourly(hour(snapRateHourly.Time)==h,:);
end


% hourlyData{1,1}.DT = hourlyData{1,1}.DT - hour(1);



%Combines all the hourly data from the entire set.
% for h = 1:24
%     %Noise
%     totalEachHour.Noise{h} = [hourlyData{1,h}.Noise; hourlyData{2,h}.Noise;hourlyData{3,h}.Noise; hourlyData{4,h}.Noise;hourlyData{5,h}.Noise; hourlyData{6,h}.Noise;...
%         hourlyData{7,h}.Noise; hourlyData{8,h}.Noise;hourlyData{9,h}.Noise; hourlyData{10,h}.Noise;hourlyData{11,h}.Noise; hourlyData{12,h}.Noise;hourlyData{13,h}.Noise];
%     %Bottom Temp
%     totalEachHour.Temp{h} = [hourlyData{1,h}.Temp; hourlyData{2,h}.Temp;hourlyData{3,h}.Temp; hourlyData{4,h}.Temp;hourlyData{5,h}.Temp; hourlyData{6,h}.Temp;...
%         hourlyData{7,h}.Temp; hourlyData{8,h}.Temp;hourlyData{9,h}.Temp; hourlyData{10,h}.Temp;hourlyData{11,h}.Temp; hourlyData{12,h}.Temp;hourlyData{13,h}.Temp];
%     %Windspeed
%     totalEachHour.windSpd{h} = [hourlyData{1,h}.windSpd; hourlyData{2,h}.windSpd;hourlyData{3,h}.windSpd; hourlyData{4,h}.windSpd;hourlyData{5,h}.windSpd; hourlyData{6,h}.windSpd;...
%         hourlyData{7,h}.windSpd; hourlyData{8,h}.windSpd;hourlyData{9,h}.windSpd; hourlyData{10,h}.windSpd;hourlyData{11,h}.windSpd; hourlyData{12,h}.windSpd;hourlyData{13,h}.windSpd];
%     %Bulk thermal strat
%     totalEachHour.bulkThermalStrat{h} = [hourlyData{1,h}.bulkThermalStrat; hourlyData{2,h}.bulkThermalStrat;hourlyData{3,h}.bulkThermalStrat; hourlyData{4,h}.bulkThermalStrat;hourlyData{5,h}.bulkThermalStrat; hourlyData{6,h}.bulkThermalStrat;...
%         hourlyData{7,h}.bulkThermalStrat; hourlyData{8,h}.bulkThermalStrat;hourlyData{9,h}.bulkThermalStrat; hourlyData{10,h}.bulkThermalStrat;hourlyData{11,h}.bulkThermalStrat; hourlyData{12,h}.bulkThermalStrat;hourlyData{13,h}.bulkThermalStrat];
%     %Detections
%     totalEachHour.Detections{h} = [hourlyData{1,h}.HourlyDets; hourlyData{2,h}.HourlyDets;hourlyData{3,h}.HourlyDets; hourlyData{4,h}.HourlyDets;hourlyData{5,h}.HourlyDets; hourlyData{6,h}.HourlyDets;...
%         hourlyData{7,h}.HourlyDets; hourlyData{8,h}.HourlyDets;hourlyData{9,h}.HourlyDets; hourlyData{10,h}.HourlyDets;hourlyData{11,h}.HourlyDets; hourlyData{12,h}.HourlyDets;hourlyData{13,h}.HourlyDets];
% 
% end


%%
% Finding the means and variances of all these mooks.
for h = 1:24
    avrgNoise(h) = nanmean(hourlyData{h}.Noise);
    varNoise(h)  = nanvar(hourlyData{h}.Noise);

    avgDetections(h) = nanmean(hourlyData{h}.HourlyDets);
    varDetections(h)  = nanvar(hourlyData{h}.HourlyDets);

    avgSnaps(h) = nanmean(snapsByHour{h}.SnapCount)

end


%%
%Day Noise Confidence Intervals
for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(hourlyData{h}.Noise,'omitnan')/sqrt(length(hourlyData{h}.Noise));  
    ts = tinv([0.025  0.975],length(hourlyData{h}.Noise)-1);  
    CIhourlyNoise(h,:) = mean(hourlyData{h}.Noise,'all','omitnan') + ts*SEM; 
end

for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(snapsByHour{h}.SnapCount,'omitnan')/sqrt(length(snapsByHour{h}.SnapCount));  
    ts = tinv([0.025  0.975],length(snapsByHour{h}.SnapCount)-1);  
    CIhourlySnaps(h,:) = mean(snapsByHour{h}.SnapCount,'all','omitnan') + ts*SEM; 
end

for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(hourlyData{h}.HourlyDets,'omitnan')/sqrt(length(hourlyData{h}.HourlyDets));  
    ts = tinv([0.025  0.975],length(hourlyData{h}.HourlyDets)-1);  
    CIhourlyDetections(h,:) = mean(hourlyData{h}.HourlyDets,'all','omitnan') + ts*SEM; 
end

for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(hourlyData{h}.Temp,'omitnan')/sqrt(length(hourlyData{h}.Temp));  
    ts = tinv([0.025  0.975],length(hourlyData{h}.Temp)-1);  
    CIhourlyTemp(h,:) = mean(hourlyData{h}.Temp,'all','omitnan') + ts*SEM; 
end


for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(hourlyData{h}.windSpd,'omitnan')/sqrt(length(hourlyData{h}.windSpd));  
    ts = tinv([0.025  0.975],length(hourlyData{h}.windSpd)-1);  
    CIhourlyWinds(h,:) = mean(hourlyData{h}.windSpd,'all','omitnan') + ts*SEM; 
end

for h=1:24
    %Finding standard deviations/CIs of values
    SEM = std(hourlyData{h}.bulkThermalStrat,'omitnan')/sqrt(length(hourlyData{h}.bulkThermalStrat));  
    ts = tinv([0.025  0.975],length(hourlyData{h}.bulkThermalStrat)-1);  
    CIhourlyStrat(h,:) = mean(hourlyData{h}.bulkThermalStrat,'all','omitnan') + ts*SEM; 
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
xticklabels({'Sunset','Sunset','22','','00','','','03','','','','Sunrise','Sunrise','09','','','Midday','','','15','','','','Sunset'})

ax1.YAxis(1).Color = 'k';
ax1.YAxis(2).Color = 'k';

ax2 = nexttile([1,4])
hold on
yyaxis left
ciplot(CIhourlyNoise(:,1),CIhourlyNoise(:,2),1:24,'b')
ylabel('HF Noise (mV)')
yyaxis right
ciplot(CIhourlyDetections(:,1),CIhourlyDetections(:,2),1:24,'r')
xlabel('Seasons, 2020')
% ylabel('Average Noise (mV)')
title('Noise Interference by Time of Day','95% Conf. Interval')
legend('Noise','Detections')
xticks(X);
xticklabels({'Sunset','Sunset','22','','00','','','03','','','','Sunrise','Sunrise','09','','','Midday','','','15','','','','Sunset'})

ax2.YAxis(1).Color = 'k';
ax2.YAxis(2).Color = 'k';
