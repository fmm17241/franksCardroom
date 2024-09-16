

%Frank's work for chapter 4.


%%
%First step: load in the processed files. This gives tables and
%datastructures with the number of snaps and the energy.

fileLocation = ([oneDrive,'\acousticAnalysis']);
% fileLocation = 'C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis';
[SnapCountTable, snapRateTables, PeakAmpTable, EnergyTable, hourSnaps, hourAmp, hourEnergy, minuteSnaps, minuteAmp, minuteEnergy] = snapRateAnalyzer(fileLocation)


% Second step: this bins, averages, and plots some of their
[receiverData, envData, windSpeedBins, windSpeedScenario, avgSnaps, averageDets] = snapRatePlotter(oneDrive, SnapCountTable, snapRateTables, ...
    hourSnaps, hourEnergy, hourAmp, minuteSnaps, minuteAmp, minuteEnergy);

%%

%Okay, so I currently have hourly/minute snaps and the environment they
%occur in. I Need to convert to spectral/frequency domain to start
%experimenting.

springNeapSpectralTesting
springNeapSpectral
Power_spectra
noiseDetrended
powerAnalysis
crossCorrFM


%mscohere()











