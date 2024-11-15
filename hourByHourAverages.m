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

