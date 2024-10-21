%FM 4/2024
%Studying the surface loss code from the acoustics toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Installed the Phased Array System Toolbox in Matlab
%Looking at albersheim and range2tl
% 
% %Albersheim equation
% SNR (dB) = -5log110(N) + [6.2 + 4.54/N + 044]log10(A+0.12AB-1.7B)
% % Where 
% % N = Number of noncoherently integrated samples
% % A = ln(0.62 * Pfa)
% % B = ln(Pd/(1-Pd))
% 
% 
% albersheim
% freq2wavelen
% %This calculates the SNR threshold T (in dB) to detect a signal, given a certain probability
% % of false alarm (PFA), the number of pulses (N), coherent/noncoherent.
% [threshold] = npwgnthresh(0.01,8,'coherent')
% 
% rocsnr
% 
% tl2range
% range2tl
% spectrogram
% phased.UnderwaterRadiatedNoise

%%
% Frank adding losses
fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)


load envDataFall
% Full snaprate dataset
load snapRateDataFall
% Snaprate binned hourly
load snapRateHourlyFall
% Snaprate binned per minute
load snapRateMinuteFall
load surfaceDataFall
times = surfaceData.time;

%This is Frank pruning from Sept-Feb to Sept-Dec.
if length(surfaceData.time) == 3308
    surfaceData = surfaceData(1:2078,:);
    snapRateHourly = snapRateHourly(1:2078,:);
end
times = surfaceData.time;

% Load in saved data
% Environmental data matched to the hourly snaps.
% load envDataSpring
% % Full snaprate dataset
% load snapRateDataSpring
% % Snaprate binned hourly
% load snapRateHourlySpring
% % Snaprate binned per minute
% load snapRateMinuteSpring
% load surfaceDataSpring
% times = surfaceData.time;

% surface loss
% bubble losses are assumed to be the dominant effect for the total field
% (as opposed to just the coherent field)
% see the discussion in
% High-Frequency Ocean Environmental Acoustic Models Handbook


midAngle = 90 %Angle of incidence, theta (degrees)

U = surfaceData.WSPD; % Windspeed (m/s). Messed this up previously, can't use " if U > 6" with large dataset.
f = 69; %Frequency (kHz)
% LOSS   = surface bubble loss (dB)

%Frank's got to slow it down
for k = 1:length(U)
    LOSS(k,1) = SurfLoss(midAngle,U(k),f);
end

%Think this is uneccessary, calculated it wrong. I'm flawed.
index = LOSS > 40;
% UWAPL gives a suggestion to cap the upper limit of SBL at 15 dB. Believe this is outdated.
% Chua et al 2018, -40 dB is more recent and is more intuitive. 
cappedLOSS = LOSS; cappedLOSS(index) = 40;

%at midAngle, cap is at 9+ m/s

figure()
plot(times,LOSS,'k')
hold on
plot(times,cappedLOSS,'r','LineWidth',2)
 legend('SBL','Capped SBL')
title('Surface Bubble Loss- HF (69 kHz) Attenuation')
ylabel('Noise Loss (dBs)')

% WOW.
[a,b] = corrcoef(LOSS,snapRateHourly.SnapCount)
[a,b] = corrcoef(LOSS,envData.Noise)

% 
% figure()
% scatter(cappedLOSS,envData.Noise)
% xlabel('Calculated SBL (dB)')
% ylabel('HF Noise (mV)')
% title(['Capped Sound Attenuation due to Wind-Drive Surface Bubbles'])
% 
% 
% figure()
% scatter(cappedLOSS,snapRateHourly.SnapCount)
% xlabel('Calculated SBL (dB)')
% ylabel('Hourly Snaps')
% title(['Capped Sound Attenuation due to Wind-Drive Surface Bubbles'])



surfaceData.SBL = LOSS;
surfaceData.SBLcapped = cappedLOSS;



%%
% %Franks testing
%Found odd values in my code, so checking now

U = surfaceData.WSPD(12);


theta = 90;
f = 69;


%Test 1
SBL1 = 1.26e-3 * U^1.57 * f^0.85 / sin( theta * pi / 180 )

%Test 2
SBL2= 1.26e-3 * 6^1.57 * f^0.85 / sin( theta * pi / 180 ) * exp( 1.2 * ( U - 6 ) )


% 
% if U > 6
%     SBL = 1.26e-3 * U^1.57 * f^0.85 / sin( theta * pi / 180 );
% else
%     SBL = 1.26e-3 * 6^1.57 * f^0.85 / sin( theta * pi / 180 ) * exp( 1.2 * ( U - 6 ) );
% end


Loss = SBL;


















