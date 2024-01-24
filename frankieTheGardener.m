%Frank's data-pruning, maybe removing the crazy outliers helps make
%detection data more obvious when FFT'd.

%run this after running "buildReceiver"data

for COUNT = 1:length(receiverData)
    figure()
    plot(receiverData{COUNT}.DT,receiverData{COUNT}.HourlyDets)
    ylabel('Detections')
    title(sprintf('Checkin Em Up: %d',COUNT))
end
