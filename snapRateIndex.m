%Frank's gotta find times to study with snap rate/frequency

%builldReceiverData

clearvars index
for k = 1:length(receiverData)
    indexDay{k} = receiverData{k}.windSpd > 6 & receiverData{k}.daytime ==1;
    indexNight{k} = receiverData{k}.windSpd > 6 & receiverData{k}.daytime ==0;


end



