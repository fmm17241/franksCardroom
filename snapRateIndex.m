%Frank's gotta find times to study with snap rate/frequency

buildReceiverData

clearvars index
% FM now trying to find times with high winds, along with 4 hours before
% and after these times to compare the difference in noise.
for k = 1:length(receiverData)
    % Find high wind events during day and night
    index{k} = receiverData{k}.windSpd > 6;
    
    % Initialize logical arrays for hours before and after
    before4HoursIndex{k} = false(size(index{k}));
    after4HoursIndex{k} = false(size(index{k}));

    % Shift indices to find 4 hours before and after high wind events
    for i = 1:4
        if length(index{k}) > i
            before4HoursIndex{k}(i+1:end) = before4HoursIndex{k}(i+1:end) | index{k}(1:end-i);
            after4HoursIndex{k}(1:end-i) = after4HoursIndex{k}(1:end-i) | index{k}(i+1:end);
        end
    end
end


%%


figure()
tiledlayout(4,1,'tileSpacing','compact')

ax1 = nexttile()
hold on
for k = 1:length(receiverData)
plot(receiverData{k}.DT,receiverData{k}.Noise)

end
title('Noise')

ax2 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd)
hold on
scatter(receiverData{4}.DT(index{4}),receiverData{4}.windSpd(index{4}),'r')
% scatter(receiverData{4}.DT(before4HoursIndex{4}),receiverData{4}.windSpd(before4HoursIndex{4}),'k')
% scatter(receiverData{4}.DT(after4HoursIndex{4}),receiverData{4}.windSpd(after4HoursIndex{4}),'g')


title('Windspeed')

ax3 = nexttile()
hold on
for k = 1:length(receiverData)
plot(receiverData{k}.DT,receiverData{k}.Temp)
end
% plot(receiverData{4}.DT,receiverData{4}.surfaceTemp,'k','LineWidth',3)
title('Temperature')
% 
ax4 = nexttile()
for k = 1:length(receiverData)
plot(receiverData{k}.DT,receiverData{k}.HourlyDets)
end
title('Detections')


linkaxes([ax1,ax2,ax3,ax4],'x')


