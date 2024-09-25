

%Frank's work for chapter 4.
% Current work explained.
% 1. snapRateAnalyzer       - Processes Raven Pro outputs from CSV into Matlab datastructures.
%
% 2. snapRatePlotter        - Builds the environmental data and plots a few basic examples.
%
%                                   - Only takes hours that has recording data analyzed.
%
% 3. snapRateWindRose       - visualizes the wind speed and direction as context.
%
% 4. frankSpectralAnalysis  - This is where we're at. Converting from time domain to frequency domain.
%                                   - Power_spectra
%

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
frankSpectralAnalysis

%
coherenceLearning








%%
%Wind direction and speed
snapRateWindRose

%%
% %This is a way of analyzing whether or not I missed a datafile, finds the
% %difference between seconds
% % Assuming your time series is stored in a vector called `timeSeries`
% for K = 1:length(snapRateTables)
%     timeSeriesDiff = diff(snapRateTables{K}.BeginClockTime);
%     timeSeriesDiffSeconds = seconds(timeSeriesDiff);    
% % To identify the missing times (i.e., where the difference is larger than 1 second)
%     missingTimesIdx = find(timeSeriesDiffSeconds > 1800);
% 
% % To get the actual missing time gaps and where they occur
%     missingGaps = timeSeriesDiff(missingTimesIdx);
%     missingTimes{K} = snapRateTables{K}(missingTimesIdx,:); % This gives you the times just before the gaps
% end
%

powerAnalysis
Fs = (2*pi)/(60*60);            % Sampling frequency, 1 sample every 60 minutes. Added 2pi; this is per second, Hz
FsPerDay = Fs*86400;            % This turns it to how many times per day


%Set up FFT variables
Fs = (2*pi)/(60*60);            % Sampling frequency, 1 sample every 60 minutes. Added 2pi.
FsPerDay = Fs*86400;

for COUNT =  1:length(receiverData)
    Y{COUNT} = fft(signalNoise{COUNT})              % FFT of the processed signals 
    L{COUNT} = height(signalNoise{COUNT})        % Length of signal
    magnitude{COUNT} = abs(Y{COUNT});
    averageWindowOutput{COUNT}(:,1) = mean(Y{COUNT},2); %Averaging all my windows
end
% Passing
wpass = (2*pi)/172800;
Fs = (2*pi)/3600 %Frequency, hertz
% Fs = (2*pi) %Frequency, hertz

%First band: between 2 and 30 days
bandWork1 = [(2*pi)/2592000 (2*pi)/172800]

%Second band: between 14 and 30 days
bandWorkMid = [(2*pi)/2592000 (2*pi)/1209600]

%Third band: between 30 and 100 days
bandWorkLow = [(2*pi)/8640000 (2*pi)/2592000]

%Fourth band: between 2 hours and 2 days
bandWorkHigh = [(2*pi)/2592000 (2*pi)/7200]

%%
crossCorrFM


%mscohere()











