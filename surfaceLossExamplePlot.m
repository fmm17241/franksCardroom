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
% Frank needs to fix his nonsense. Instead of +/- 3 dB, I should show the range of angles.


%Frank is flawed, he needs to fix his understanding of modeling SBL
U = 0:2:16;

% Frequency Examples
lowFrequency = 50;
highFrequency = 90;
actualFrequency = 69;

% Angles
theta = 10:5:90;

%Frank's got to slow it down
for k = 1:length(U)
    for Angle = 1:length(theta)
        highFreqLoss(k,Angle) = SurfLoss(theta(Angle),U(k),highFrequency);
    end
end
%Frank's got to slow it down
for k = 1:length(U)
    for Angle = 1:length(theta)
        lowFreqLoss(k,Angle) = SurfLoss(theta(Angle),U(k),lowFrequency);
    end
end

for k = 1:length(U)
    for Angle = 1:length(theta)
        actualFreqLoss(k,Angle) = SurfLoss(theta(Angle),U(k),actualFrequency);
    end
end

% UWAPL gives a suggestion to cap the upper limit of SBL at 15 dB. 
indexHigh   = highFreqLoss > 15;
indexLow    = lowFreqLoss > 15;
indexActual = actualFreqLoss > 15;

highFreqLoss(indexHigh) = 15;

lowFreqLoss(indexLow) = 15;

actualFreqLoss(indexActual) = 15;

%%


figure()
plot(U, actualFreqLoss,'LineWidth',2)



fullPlots = figure()
tiledlayout('flow','TileSpacing','Compact')
ax1 = nexttile([1,1])
plot(U,lowFreqLoss,'LineWidth',2)
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
title('','50 kHz, 60deg Angle')

ax3 = nexttile([1,1])
plot(U,highFreqLoss.grazingCap,'r','LineWidth',2)
hold on
ciplot(bufferHighGrazing(:,1),bufferHighGrazing(:,2),0:2:16,'r')
xlim([0 15])
ylim([0 18])
xlabel('SBL')
xlabel('Windspeed (m/s')
ylabel('Surface Bubble Loss (dBs)')
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
title('Range of Surface Bubble Loss','High-Frequency Transceiver Bandwidth')
xlabel('Windspeed (m/s')


figure()
ciplot(bufferLowGrazing(:,1),bufferLowGrazing(:,2),0:2:16)
hold on
ciplot(bufferHighGrazing(:,1),bufferHighGrazing(:,2),0:2:16,'r')
plot(U,actualFreqLoss.grazingCap,'k--','lineWidth',4)
xlim([0 15])
ylim([0 18])
yline(15,'--','SBL Boundary','LabelHorizontalAlignment', 'left','LineWidth',2)
title('Range of Surface Bubble Loss','High-Frequency Transceiver Bandwidth')
legend('50 kHz','90 kHz','69 kHz')
xlabel('Windspeed (m/s')
ylabel('SBL (dB)')
%%
% %Frank is flawed, he needs to fix his understanding of modeling SBL
% U = 0:2:16;
% 
% % Frequency Examples
% lowFrequency = 50;
% highFrequency = 90;
% actualFrequency = 69;
% 
% % Angles
% grazingAngle = 10; 
% hardAngle    = 60;
% 
% %Frank's got to slow it down
% for k = 1:length(U)
%     highFreqLoss.grazing(k,1) = SurfLoss(grazingAngle,U(k),highFrequency);
%     highFreqLoss.hard(k,1) = SurfLoss(hardAngle,U(k),highFrequency);
% end
% for k = 1:length(U)
%     lowFreqLoss.grazing(k,1) = SurfLoss(grazingAngle,U(k),lowFrequency);
%     lowFreqLoss.hard(k,1) = SurfLoss(hardAngle,U(k),lowFrequency);
% end
% 
% for k = 1:length(U)
%     actualFreqLoss.grazing(k,1) = SurfLoss(grazingAngle,U(k),actualFrequency);
%     actualFreqLoss.hard(k,1) = SurfLoss(hardAngle,U(k),actualFrequency);
% end
% 
% 
% % UWAPL gives a suggestion to cap the upper limit of SBL at 15 dB. 
% indexHFLgrazing = highFreqLoss.grazing > 15;
% indexLFLgrazing = lowFreqLoss.grazing > 15;
% indexHFLhard = highFreqLoss.hard > 15;
% indexLFLhard = lowFreqLoss.hard > 15;
% indexAFLgrazing = actualFreqLoss.grazing > 15;
% indexAFLhard    = actualFreqLoss.hard > 15;
% 
% highFreqLoss.grazingCap = highFreqLoss.grazing; highFreqLoss.grazingCap(indexHFLgrazing) = 15;
% highFreqLoss.hardCap = highFreqLoss.hard; highFreqLoss.hardCap(indexHFLhard) = 15;
% lowFreqLoss.grazingCap = lowFreqLoss.grazing; lowFreqLoss.grazingCap(indexLFLgrazing) = 15;
% lowFreqLoss.hardCap = lowFreqLoss.hard; lowFreqLoss.hard(indexLFLhard) = 15;
% actualFreqLoss.grazingCap = actualFreqLoss.grazing; actualFreqLoss.grazingCap(indexAFLgrazing) = 15;
% actualFreqLoss.hardCap = actualFreqLoss.hard; actualFreqLoss.hard(indexAFLhard) = 15;
% 
% 
% 
% %%
% %OKay, showed the cap, now I'll move on
% %Adding +/- dB buffer to each signal without worrying about cap.
% 
% bufferLowHard = [lowFreqLoss.hardCap-3 lowFreqLoss.hardCap+3]
% bufferLowGrazing = [lowFreqLoss.grazingCap-3 lowFreqLoss.grazingCap+3]
% 
% bufferHighHard = [highFreqLoss.hardCap-3 highFreqLoss.hardCap+3]
% bufferHighGrazing = [highFreqLoss.grazingCap-3 highFreqLoss.grazingCap+3]
% 
% 
% 
% 
% fullPlots = figure()
% tiledlayout('flow','TileSpacing','Compact')
% ax1 = nexttile([1,1])
% plot(U,lowFreqLoss.grazingCap,'LineWidth',2)
% hold on
% ciplot(bufferLowGrazing(:,1),bufferLowGrazing(:,2),0:2:16)
% xlim([0 15])
% ylim([0 18])
% xlabel('SBL')
% yline(15,'--','SBL Boundary','LabelHorizontalAlignment', 'left')
% title('Calculated Surface Bubble Loss','50 kHz, 10deg Angle')
% 
% ax2 = nexttile([1,1])
% plot(U,lowFreqLoss.hardCap,'LineWidth',2)
% hold on
% ciplot(bufferLowHard(:,1),bufferLowHard(:,2),0:2:16)
% xlim([0 15])
% ylim([0 18])
% legend('','+/- 3 dB')
% title('','50 kHz, 60deg Angle')
% 
% ax3 = nexttile([1,1])
% plot(U,highFreqLoss.grazingCap,'r','LineWidth',2)
% hold on
% ciplot(bufferHighGrazing(:,1),bufferHighGrazing(:,2),0:2:16,'r')
% xlim([0 15])
% ylim([0 18])
% xlabel('SBL')
% xlabel('Windspeed (m/s')
% ylabel('Surface Bubble Loss (dBs)')
% yline(15,'--','SBL Boundary','LabelHorizontalAlignment', 'left')
% title('','90 kHz, 10deg Angle')
% 
% ax4 = nexttile([1,1])
% plot(U,highFreqLoss.hardCap,'r','LineWidth',2)
% hold on
% ciplot(bufferHighHard(:,1),bufferHighHard(:,2),0:2:16,'r')
% xlim([0 15])
% ylim([0 18])
% xlabel('Windspeed (m/s')
% legend('','+/- 3 dB')
% title('','90 kHz, 60deg Angle')
% 
% ax5 = nexttile([1,2])
% ciplot(bufferLowGrazing(:,1),bufferLowGrazing(:,2),0:2:16)
% hold on
% ciplot(bufferHighGrazing(:,1),bufferHighGrazing(:,2),0:2:16,'r')
% xlim([0 15])
% ylim([0 18])
% yline(15,'--','SBL Boundary','LabelHorizontalAlignment', 'left','LineWidth',2)
% title('Range of Surface Bubble Loss','High-Frequency Transceiver Bandwidth')
% xlabel('Windspeed (m/s')
% 
% 
% figure()
% ciplot(bufferLowGrazing(:,1),bufferLowGrazing(:,2),0:2:16)
% hold on
% ciplot(bufferHighGrazing(:,1),bufferHighGrazing(:,2),0:2:16,'r')
% plot(U,actualFreqLoss.grazingCap,'k--','lineWidth',4)
% xlim([0 15])
% ylim([0 18])
% yline(15,'--','SBL Boundary','LabelHorizontalAlignment', 'left','LineWidth',2)
% title('Range of Surface Bubble Loss','High-Frequency Transceiver Bandwidth')
% legend('50 kHz','90 kHz','69 kHz')
% xlabel('Windspeed (m/s')
% ylabel('SBL (dB)')


cd ('C:\Users\fmm17241\OneDrive - University of Georgia\data\acousticAnalysis\plots')
% exportgraphics(fullPlots,'SBLexampleTiles.png')

% figure()
% ciplot(bufferLowGrazing(:,1),bufferLowGrazing(:,2),0:2:16)
% hold on
% ciplot(bufferHighGrazing(:,1),bufferHighGrazing(:,2),0:2:16,'r')
% 
% 
% plot(U,lowFreqLoss.hard,'LineWidth',2)
% plot(U,cappedLFLgrazing,'LineWidth',2)
% plot(U,cappedLFLhard,'LineWidth',2)
% xlim([0 15])
% ylim([0 20])
% ylabel('SBL (dB)')
% legend('GrazingAngle','HardAngle','Grazing(Cap)','Hard(Cap)')
% title('Calculated Surface Bubble Loss','50 kHz')
% 
% ax2 = nexttile()
% plot(U,highFreqLoss.grazing,'LineWidth',2)
% hold on
% plot(U,highFreqLoss.hard,'LineWidth',2)
% plot(U,cappedHFLgrazing,'LineWidth',2)
% plot(U,cappedHFLhard,'LineWidth',2)
% xlim([0 15])
% ylim([ 0 20])
% ylabel('SBL (dB)')
% legend('GrazingAngle','HardAngle','Grazing(Cap)','Hard(Cap)')
% title('','90 kHz')

%%




