buildReceiverData


closedData = receiverData{5};

openData = receiverData{4};

%
closedWeakTideIndex = receiverData{5}.crossShore < abs(.25);
closedStrongTideIndex = receiverData{5}.crossShore > abs(.25);
openWeakTideIndex = receiverData{4}.crossShore < abs(.25);
openStrongTideIndex = receiverData{4}.crossShore > abs(.25);


%
closedWeakWindsIndex = receiverData{5}.windSpd < abs(5);
closedStrongWindsIndex = receiverData{5}.windSpd > abs(9);
openWeakWindsIndex = receiverData{4}.windSpd < abs(5);
openStrongWindsIndex = receiverData{4}.windSpd > abs(9);


mean(receiverData{5}.Tilt(closedWeakWindsIndex))
mean(receiverData{5}.Tilt(closedStrongWindsIndex))
mean(receiverData{4}.Tilt(openWeakWindsIndex))
mean(receiverData{4}.Tilt(openStrongWindsIndex))