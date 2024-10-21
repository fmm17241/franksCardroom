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
%Frank is flawed, he needs to fix his understanding of modeling SBL
U = 0:2:16;

% Frequency Examples
lowFrequency = 50;
highFrequency = 90;

% Angles
grazingAngle = 10; 
hardAngle    = 60;


%Frank's got to slow it down
for k = 1:length(U)
    highFreqLoss.grazing(k,1) = SurfLoss(grazingAngle,U(k),69);
    highFreqLoss.hard(k,1) = SurfLoss(hardAngle,U(k),69);
end
for k = 1:length(U)
    lowFreqLoss.grazing(k,1) = SurfLoss(grazingAngle,U(k),lowFrequency);
    lowFreqLoss.hard(k,1) = SurfLoss(hardAngle,U(k),lowFrequency);
end


% UWAPL gives a suggestion to cap the upper limit of SBL at 15 dB. 
indexHFLgrazing = highFreqLoss.grazing > 15;
indexLFLgrazing = lowFreqLoss.grazing > 15;
indexHFLhard = highFreqLoss.hard > 15;
indexLFLhard = lowFreqLoss.hard > 15;

highFreqLoss.grazingCap = highFreqLoss.grazing; highFreqLoss.grazingCap(indexHFLgrazing) = 15;
highFreqLoss.hardCap = highFreqLoss.hard; highFreqLoss.hardCap(indexHFLhard) = 15;
lowFreqLoss.grazingCap = lowFreqLoss.grazing; lowFreqLoss.grazingCap(indexLFLgrazing) = 15;
lowFreqLoss.hardCap = lowFreqLoss.hard; lowFreqLoss.hard(indexLFLhard) = 15;


figure()
tiledlayout(2,1)
ax1 = nexttile()
plot(U,lowFreqLoss.grazing,'LineWidth',2)
hold on
plot(U,lowFreqLoss.hard,'LineWidth',2)
plot(U,cappedLFLgrazing,'LineWidth',2)
plot(U,cappedLFLhard,'LineWidth',2)
xlim([0 15])
ylim([0 20])
ylabel('SBL (dB)')
legend('GrazingAngle','HardAngle','Grazing(Cap)','Hard(Cap)')
title('Calculated Surface Bubble Loss','50 kHz')

ax2 = nexttile()
plot(U,highFreqLoss.grazing,'LineWidth',2)
hold on
plot(U,highFreqLoss.hard,'LineWidth',2)
plot(U,cappedHFLgrazing,'LineWidth',2)
plot(U,cappedHFLhard,'LineWidth',2)
xlim([0 15])
ylim([ 0 20])
ylabel('SBL (dB)')
legend('GrazingAngle','HardAngle','Grazing(Cap)','Hard(Cap)')
title('','90 kHz')


%%
%OKay, showed the cap, now I'll move on
%Adding +/- dB buffer to each signal without worrying about cap.

bufferLowHard = [lowFreqLoss.hardCap-3 lowFreqLoss.hardCap+3]
bufferLowGrazing = [lowFreqLoss.grazingCap-3 lowFreqLoss.grazingCap+3]

bufferHighHard = [highFreqLoss.hardCap-3 highFreqLoss.hardCap+3]
bufferHighGrazing = [highFreqLoss.grazingCap-3 highFreqLoss.grazingCap+3]



figure()
tiledlayout('flow')
ax1 = nexttile([1,1])
plot(U,lowFreqLoss.grazingCap,'LineWidth',2)
hold on
ciplot(bufferLowGrazing(:,1),bufferLowGrazing(:,2),0:2:16)
xlim([0 15])
ylim([0 18])
xlabel('SBL')
yline(15,'--','SBL Boundary','LabelHorizontalAlignment', 'left')
title('Calculated Surface Bubble Loss','50 kHz, 10deg Angle')

ax2 = nexttile([1,1])
plot(U,lowFreqLoss.hardCap,'LineWidth',2)
hold on
ciplot(bufferLowHard(:,1),bufferLowHard(:,2),0:2:16)
xlim([0 15])
ylim([0 18])
legend('','+/- 3 dB')
title('Angle of Incidence vs the Surface','50 kHz, 60deg Angle')

ax3 = nexttile([1,1])
plot(U,highFreqLoss.grazingCap,'r','LineWidth',2)
hold on
ciplot(bufferHighGrazing(:,1),bufferHighGrazing(:,2),0:2:16,'r')
xlim([0 15])
ylim([0 18])
xlabel('SBL')
xlabel('Windspeed (m/s')
yline(15,'--','SBL Boundary','LabelHorizontalAlignment', 'left')
title('','90 kHz, 10deg Angle')

ax4 = nexttile([1,1])
plot(U,highFreqLoss.hardCap,'r','LineWidth',2)
hold on
ciplot(bufferHighHard(:,1),bufferHighHard(:,2),0:2:16,'r')
xlim([0 15])
ylim([0 18])
xlabel('Windspeed (m/s')
legend('','+/- 3 dB')
title('','90 kHz, 60deg Angle')

ax5 = nexttile([1,2])
ciplot(bufferLowGrazing(:,1),bufferLowGrazing(:,2),0:2:16)
hold on
ciplot(bufferHighGrazing(:,1),bufferHighGrazing(:,2),0:2:16,'r')
xlim([0 15])
ylim([0 18])
yline(15,'--','SBL Boundary','LabelHorizontalAlignment', 'left','LineWidth',2)
title('Comparison between 50-90 kHz','The High-Frequency Bandwidth')
xlabel('Windspeed (m/s')



figure()
ciplot(bufferLowGrazing(:,1),bufferLowGrazing(:,2),0:2:16)
hold on
ciplot(bufferHighGrazing(:,1),bufferHighGrazing(:,2),0:2:16,'r')


plot(U,lowFreqLoss.hard,'LineWidth',2)
plot(U,cappedLFLgrazing,'LineWidth',2)
plot(U,cappedLFLhard,'LineWidth',2)
xlim([0 15])
ylim([0 20])
ylabel('SBL (dB)')
legend('GrazingAngle','HardAngle','Grazing(Cap)','Hard(Cap)')
title('Calculated Surface Bubble Loss','50 kHz')

ax2 = nexttile()
plot(U,highFreqLoss.grazing,'LineWidth',2)
hold on
plot(U,highFreqLoss.hard,'LineWidth',2)
plot(U,cappedHFLgrazing,'LineWidth',2)
plot(U,cappedHFLhard,'LineWidth',2)
xlim([0 15])
ylim([ 0 20])
ylabel('SBL (dB)')
legend('GrazingAngle','HardAngle','Grazing(Cap)','Hard(Cap)')
title('','90 kHz')




%%
%For example later
% for k = 1:length(seasons)
%     %Finding standard deviations/CIs of values
%     SEM = std(nightWinds{1,k}(:),'omitnan')/sqrt(length(nightWinds{1,k}));  
%     ts = tinv([0.025  0.975],length(nightWinds{1,k})-1);  
%     CInightWinds(k,:) = (mean(nightWinds{:,k},'all','omitnan') + ts*SEM); 
% end
% 
% 
% 
% 
% %%
% 
% 
% figure()
% hold on
% % ciplot(CIsunsetNoise(:,1),CIsunsetNoise(:,2),1:5,'k')
% ciplot(CInightNoise(:,1),CInightNoise(:,2),1:5,'b')
% ciplot(CIdayNoise(:,1),CIdayNoise(:,2),1:5,'r')
% xlabel('Seasons, 2020')
% ylabel('Average Noise (mV)')
% title('Average Noise By Time of Day and Season','95% Conf. Interval, 69 kHz')
% legend('Night','Day')



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


theta = 10 %Angle of incidence, theta (degrees)

U = surfaceData.WSPD; % Windspeed (m/s). Messed this up previously, can't use " if U > 6" with large dataset.
f = 69; %Frequency (kHz)
% LOSS   = surface bubble loss (dB)

%Frank's got to slow it down
for k = 1:length(U)
    LOSS1(k,1) = SurfLoss(theta,U(k),20);
end

%Frank's got to slow it down
for k = 1:length(U)
    LOSS2(k,1) = SurfLoss(theta,U(k),69);
end

LOSS3 = SurfLoss(10,15,40)

%Think this is uneccessary, calculated it wrong. I'm flawed.
index = LOSS > 15;
% UWAPL gives a suggestion to cap the upper limit of SBL at 15 dB. Believe this is outdated.
% Chua et al 2018, -40 dB is more recent and is more intuitive. 
cappedLOSS = LOSS; cappedLOSS(index) = 15;

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


















