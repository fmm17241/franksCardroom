%%
%Frank responding to a critique about diurnal cycles. Not just day and night, instead take average values at the different hours.

%load in environmental and detection data
buildReceiverData   


%Breakdown array by hours, not months or anything
% Preallocate cell array to store data for each hour
hourlyData = cell(13, 24);

% Loop over all 24 hours
for transceiver = 1:length(receiverData)
    for h = 0:23
        hourlyData{transceiver,h+1} = receiverData{transceiver}(hour(receiverData{transceiver}.DT) == h, :);
    end
end

%Okay, hourlyData now has each hour separated. How do I use it? Hmmhfgmhgdhnjhd
for transceiver = 1:length(receiverData)
    for h = 0:23
        hourlyAverages{transceiver,h+1} = mean(hourlyData{transceiver,h+1}.Noise,'Omitnan');
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

end

X = 1:24
figure();
yyaxis left
plot(X,avrgNoise,'LineWidth',3);
ylabel('Noise (mV)')
yyaxis right
plot(X,avgDetections,'LineWidth',3);
ylabel('Detections')
title('Hourly Averages','UTC, Jan-May')
