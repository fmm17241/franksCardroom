%FM 
% Frank's building and testing his knowledge of power and coherence.
%Step 1: create signals
%Step 2: Convert to power spectrum
%Step 3: Measure coherence between the two signals
%Step 4: Match that coherence to what we expected.



%Create two signals with known frequencies.
ampA = 5;
ampB = 10;

frequencyA = 2;
frequencyB = 10;
frequencyC = 40;
% frequencyC = 5;

duration = 10;
Fs = 100;

phase1 = 0;
phase2 = pi/4;
% I want to add noise to test my coherence.
noiseLevel1 = 2.5;  % Standard deviation of noise for signal 1
noiseLevel2 = 2.5;    % Standard deviation of noise for signal 2


time = 0:1/Fs:duration;

% signalA = ampA * sin(2*pi*frequencyA*time) + ampA*2*(sin(2*pi*frequencyC*time));
signalA = ampA * sin(2*pi*frequencyA*time) + ampA*(sin(2*pi*frequencyC*time)); 
signalB = ampB * sin(2*pi*frequencyA*time+phase2) + ampB * sin(2*pi*frequencyB*time+phase2) + ampA*(sin(2*pi*frequencyC*time)) ;

signalA = signalA + noiseLevel1*randn(size(time));
signalB = signalB + noiseLevel1*randn(size(time));

figure()
tiledlayout(2,1)
ax1 = nexttile()
plot(time,signalA);
title('signalA')
title(['Sine Wave: Amplitude = ', num2str(ampA), ', Frequency = ', num2str(frequencyA), ' Hz']);
xlabel('Time (s)');
ylabel('Amplitude');
ax2 = nexttile()
plot(time,signalB);
title(['Sine Wave: Amplitude = ', num2str(ampB), ', Frequency = ', num2str(frequencyB), ' Hz']);
grid on;


% Coherence_whelch_overlap(datainA, datainB, samplinginterval, bins, windoww, DT, cutoff)
testing = Coherence_whelch_overlap(signalA,signalB,Fs,3,0,0,0)

figure()
tiledlayout(4,1)
ax1 = nexttile()
plot(testing.f,testing.psda)
title('Test Signals, 10 Bins, Phase Shift pi/4','Signal A')
ax2 = nexttile()
plot(testing.f,testing.psdb)
title('','Signal B')
ax3 = nexttile()
semilogx(testing.f,testing.coh)
title('','Coherence')
ax4 = nexttile()
semilogx(testing.f,testing.phase)
title('','Phase')

%%
%Okay, looking to take those practice signals and make something closer to what I use, hourly measures.
clearvars amp* frequen* phase* noise* time* testing* ax* duration* Fs*
 

ampA = 5;
ampB = 10;

frequencyA = 1/44712; % 12.42 x 3600, frequency of M2 Tides
frequencyB = 1/86400; % 24 x 3500, diurnal frequency     
% frequencyC = 40;
% frequencyC = 5;

duration = 1000000;
Fs = 1/3600;

phase1 = 0;
phase2 = pi/4;
% I want to add noise to test my coherence.
noiseLevel1 = 2.5;  % Standard deviation of noise for signal 1
noiseLevel2 = 2.5;    % Standard deviation of noise for signal 2


time = 0:1/Fs:duration;


% signalA = ampA * sin(2*pi*frequencyA*time) + ampA*2*(sin(2*pi*frequencyC*time));
signalA = ampA * sin(2*pi*frequencyA*time); 
signalB = ampB * sin(2*pi*frequencyA*time+phase2) + ampB * sin(2*pi*frequencyB*time+phase2) ;

signalA = signalA + noiseLevel1*randn(size(time));
signalB = signalB + noiseLevel1*randn(size(time));



figure()
tiledlayout(2,1)
ax1 = nexttile()
plot(time,signalA);
title('signalA')
title(['Sine Wave: Amplitude = ', num2str(ampA), ', Frequency = ', num2str(frequencyA), ' Hz']);
xlabel('Time (s)');
ylabel('Amplitude');
ax2 = nexttile()
plot(time,signalB);
title(['Sine Wave: Amplitude = ', num2str(ampB), ', Frequency = ', num2str(frequencyB), ' Hz']);
grid on;


% Coherence_whelch_overlap(datainA, datainB, samplinginterval, bins, windoww, DT, cutoff)
testing = Coherence_whelch_overlap(signalA,signalB,Fs,10,0,0,0)

figure()
tiledlayout(4,1)
ax1 = nexttile()
plot(testing.f,testing.psda)
title('Test Signals, 10 Bins, Phase Shift pi/4','Signal A')
ax2 = nexttile()
plot(testing.f,testing.psdb)
title('','Signal B')
ax3 = nexttile()
semilogx(testing.f,testing.coh)
title('','Coherence')
ax4 = nexttile()
semilogx(testing.f,testing.phase)
title('','Phase')





