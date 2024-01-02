
tidalAnalysis2020
clearvars -except githubToolbox localplots oneDrive adcp rotUtideShore ut vt localPlots matlabToolbox oneDrive tideDN tideDT rotUtideShore rotVtideShore uz vz
close all

time = datetime(adcp.dn(1:2:end),'convertFrom','datenum')
uz = uz(1:2:end);
vz = vz(1:2:end);
ut = ut(1:2:end);
vt = vt(1:2:end);


Fs = 1/3600;        % Sampling Frequency, hourly
T = 1/Fs            % Sample Period
L = length(vz)          % Length of Signal
t = (0:L-1)*T;

%Testing my data
T = time;
% T2 = receiverData{5}.DT
data = ut;
dataY = vt;
% window = hanning(1000);


segmentLength = 40;
noverlap = 20;


[pxx,f] = pwelch(data);



figure()
plot(f,10*log10(pxx))

xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')
title('ADCP Predicted Tide, No Window/Overlap')

%
clearvars pxx f
[pxx,f] = pwelch(data,segmentLength,noverlap,40,Fs);



figure()
plot(f,10*log10(pxx))

xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')
title('ADCP Predicted Tide, 40 hour window, 50% overlap')
%

clearvars pxx f
[pxx,f] = pwelch(data,segmentLength,0,40,Fs);



figure()
plot(f,10*log10(pxx))

xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')
title('ADCP Predicted Tide, 40 hour window, 0% overlap')