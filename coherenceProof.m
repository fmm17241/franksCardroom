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
% frequencyC = 5;

duration = 10;
Fs = 100;


% I want to add noise to test my coherence.
noiseLevel1 = 0.8;  % Standard deviation of noise for signal 1
noiseLevel2 = 0.3;    % Standard deviation of noise for signal 2


time = 0:1/Fs:duration;

% signalA = ampA * sin(2*pi*frequencyA*time) + ampA*2*(sin(2*pi*frequencyC*time));
signalA = ampA * sin(2*pi*frequencyA*time); 
signalB = ampB * sin(2*pi*frequencyA*time) + ampB * sin(2*pi*frequencyB*time) ;

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
tiledlayout(3,1)
ax1 = nexttile()
plot(testing.f,testing.psda)
title('Test Signals, Power','Signal A')
ax2 = nexttile()
plot(testing.f,testing.psdb)
title('','Signal B')
ax3 = nexttile()
semilogx(testing.f,testing.coh)
title('','Coherence')
