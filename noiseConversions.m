%Frank
% Following Cimino's previous conversion:

%V = voltage
V =[0.2; 0.3; 0.5; 0.65] ; %V, representing 650 mV, the challenging threshold.

%Vo = average noise floor
% Vo = 0.163; % V, representing 163 mV, the noise floor Cimino saw
Vo = 163 % mV

GAINdecibels = 20*log10(V/Vo)

fileLocation = ([oneDrive,'\acousticAnalysis\matlabVariables']);
cd (fileLocation)
load receiverDataSpring.mat

testing = convertMVtoDB(receiverData{1}.Noise,Vo)
