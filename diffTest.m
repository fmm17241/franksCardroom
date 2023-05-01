
%Testing difference, does it correlate to tides?



diffTest = fullData{7}.detections - fullData{8}.detections;
x = 1:length(diffTest);
xTime = fullData{7}.time;

figure()
scatter(xTime,diffTest);
ylabel('Diff in Dets')


figure()
scatter(xTime,rotUtideShore);
ylabel('Diff in Dets')
