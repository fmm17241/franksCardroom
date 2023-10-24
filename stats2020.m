%FM Exporting data to .csv to use in R.

binnedAVG


%oneMatrix = [fullData{1,1}; fullData{1,2};fullData{1,3}; fullData{1,4};fullData{1,5}; fullData{1,6};fullData{1,7}; fullData{1,10}];
oneMatrix =  [fullData{1,1}; fullData{1,2};fullData{1,3}; fullData{1,4};fullData{1,5}; fullData{1,6};fullData{1,7};fullData{1,8};fullData{1,9}; fullData{1,10}];

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\statisticalAnalysis'

writetimetable(oneMatrix,'oneMatrix.csv')