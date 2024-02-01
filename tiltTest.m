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

figure()
tiledlayout(5,1,'TileSpacing','Compact')
ax1 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd,'k')
ylabel('Windspd (m/s)')
title('Wind Magnitude')

ax2 = nexttile()
plot(receiverData{5}.DT,receiverData{5}.Tilt,'r')
ylabel('Tilt (degs)')
title('Isolated Reef','Tilt')

ax3 = nexttile()
plot(receiverData{5}.DT,receiverData{5}.Noise,'r')
ylabel('HF Noise (mV)')
title('','Noise')

ax4 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.Tilt,'b')
ylabel('Tilt (degs)')
title('Open Reef','Tilt')

ax5 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.Noise,'b')
ylabel('HF Noise (mV)')
title('','Noise')


linkaxes([ax1 ax2 ax3 ax4 ax5],'x')

