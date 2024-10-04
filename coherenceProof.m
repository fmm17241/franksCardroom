%FM 
% Frank's building and testing his knowledge of power and coherence.
%Step 1: create signals
%Step 2: Convert to power spectrum
%Step 3: Measure coherence between the two signals
%Step 4: Match that coherence to what we expected.



%Create two signals with known frequencies.
ampA = 1;
ampB = 0.5;

frequencyA = 2;
frequencyB = 10;
frequencyC = 5;

duration = 10;
Fs = 100;

time = 0:1/Fs:duration;

signalA = ampA * sin(2*pi*frequencyA*time) + ampA*2*(sin(2*pi*frequencyC*time));
signalB = ampB * sin(2*pi*frequencyB*time);

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


testing = Coherence_whelch_overlap(signalA,signalB,Fs,2,0,0,0)