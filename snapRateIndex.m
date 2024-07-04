%Frank's gotta find times to study with snap rate/frequency

buildReceiverData

clearvars index
% FM now trying to find times with high winds, along with 4 hours before
% and after these times to compare the difference in noise.
for k = 1:length(receiverData)
    % Find high wind events
    highWindIndex{k} = receiverData{k}.windSpd > 6;
    
    % Initialize logical arrays for periods of high wind
    sustainedHighWindIndex{k} = false(size(highWindIndex{k}));
    
    % Define the window size (more than 4 hours means at least 5 consecutive hours)
    windowSize = 5;
    
    % Check for sustained high winds
    for i = 1:(length(highWindIndex{k}) - windowSize + 1)
        if all(highWindIndex{k}(i:i+windowSize-1))
            sustainedHighWindIndex{k}(i:i+windowSize-1) = true;
        end
    end
    
    % Find the start and end of each sustained high wind period
    sustainedPeriods = sustainedHighWindIndex{k};
    diffPeriods = diff([false; sustainedPeriods; false]);
    startIndices = find(diffPeriods == 1);
    endIndices = find(diffPeriods == -1) - 1;
    
    % Initialize logical arrays for 5 hours before and after
    beforeSustained{k} = false(size(highWindIndex{k}));
    afterSustained{k} = false(size(highWindIndex{k}));
    
    % Mark the 5 hours before and after each sustained period
    for i = 1:length(startIndices)
        if startIndices(i) > 5
            beforeSustained{k}(startIndices(i)-5:startIndices(i)-1) = true;
        else
            beforeSustained{k}(1:startIndices(i)-1) = true;
        end
        if endIndices(i) <= length(highWindIndex{k}) - 5
            afterSustained{k}(endIndices(i)+1:endIndices(i)+5) = true;
        else
            afterSustained{k}(endIndices(i)+1:end) = true;
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
scatter(receiverData{4}.DT(sustainedHighWindIndex{4}),receiverData{4}.windSpd(sustainedHighWindIndex{4}),'r')
scatter(receiverData{4}.DT(beforeSustained{4}),receiverData{4}.windSpd(beforeSustained{4}),'k')
scatter(receiverData{4}.DT(afterSustained{4}),receiverData{4}.windSpd(afterSustained{4}),'g')


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


