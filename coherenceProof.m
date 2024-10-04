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

duration = 10;
Fs = 100;

time = 0:1/Fs:duration;

signalA = 
signalB =