%Frank's gotta find times to study with snap rate/frequency

buildReceiverData

clearvars index
for k = 1:length(receiverData)
    indexDay{k} = receiverData{k}.windSpd > 6 & receiverData{k}.daytime ==1;
    indexNight{k} = receiverData{k}.windSpd > 6 & receiverData{k}.daytime ==0;


end



for k = 1:length(receiverData)
    % Find high wind events during day and night
    indexDay{k} = receiverData{k}.windSpd > 6 & receiverData{k}.daytime == 1;
    indexNight{k} = receiverData{k}.windSpd > 6 & receiverData{k}.daytime == 0;
    
    % Initialize logical arrays for hours before and after
    before4HoursIndexDay{k} = false(size(indexDay{k}));
    after4HoursIndexDay{k} = false(size(indexDay{k}));
    before4HoursIndexNight{k} = false(size(indexNight{k}));
    after4HoursIndexNight{k} = false(size(indexNight{k}));

    % Shift indices to find 4 hours before and after high wind events
    for i = 1:4
        if length(indexDay{k}) > i
            before4HoursIndexDay{k}(i+1:end) = before4HoursIndexDay{k}(i+1:end) | indexDay{k}(1:end-i);
            after4HoursIndexDay{k}(1:end-i) = after4HoursIndexDay{k}(1:end-i) | indexDay{k}(i+1:end);
        end
        if length(indexNight{k}) > i
            before4HoursIndexNight{k}(i+1:end) = before4HoursIndexNight{k}(i+1:end) | indexNight{k}(1:end-i);
            after4HoursIndexNight{k}(1:end-i) = after4HoursIndexNight{k}(1:end-i) | indexNight{k}(i+1:end);
        end
    end
end