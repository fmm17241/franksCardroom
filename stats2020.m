%FM Exporting data to .csv to use in R.

binnedAVG

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\statisticalAnalysis'

%Working on matrices
oneMatrix =  [fullData{1,1}; fullData{1,2};fullData{1,3}; fullData{1,4};fullData{1,5}; fullData{1,6};fullData{1,7};fullData{1,8};fullData{1,9}; fullData{1,10}];

for K = 1:length(fullData)
    writetimetable(fullData{1,K},sprintf('matrix%d.csv',K))
end





% writetimetable(oneMatrix,'oneMatrix.csv')