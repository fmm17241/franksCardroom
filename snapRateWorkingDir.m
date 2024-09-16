

%Frank's work for chapter 4.


%%
%First step: load in the processed files. This gives tables and
%datastructures with the number of snaps and the energy.

fileLocation = ([oneDrive,'\acousticAnalysis']);
% fileLocation = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis';
[SnapCountTable, snapRateTables, PeakAmpTable, EnergyTable, hourSnaps, hourAmp, hourEnergy, minuteSnaps, minuteAmp, minuteEnergy] = snapRateAnalyzer(fileLocation)


% Second step: this bins, averages, and plots some of their
[receiverData, windSpeedBins, windSpeedScenario, avgSnaps, averageDets] = snapRatePlotter(oneDrive, SnapCountTable, snapRateTables, ...
    hourSnaps, hourEnergy, hourAmp, minuteSnaps, minuteAmp, minuteEnergy);

%%


for K = 1:length(hourSnaps)
    clear snapTimeRange envFit
    snapTimeRange = [hourSnaps{K}.Time(1); hourSnaps{K}.Time(end)];
    
    envFit = isbetween(receiverData{4}.DT, snapTimeRange(1),snapTimeRange(2));

    envData{K} = receiverData{4}(envFit,:);

end









%mscohere()











