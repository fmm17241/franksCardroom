% FM 8/2/23

%Okay. Previously did a conference paper on Beam Density Analysis (BDA):
%simple modeling of sound propagation through a water column collected by a
%glider. By design the inputs were very basic and still gave good agreement
%between measured detection efficiency and the number of beam arrivals that
%each distance saw.

% surfacings.m is running into some issues with how it reads in the data,
% going to move past that for now.


cd ([oneDrive,'Glider\Transform\R\'])






figure()
bellhop('test15R');
plotray('test15R');
% xlim([0 1500]);
figure()
plotshd('test15R.shd')


figure()
plotssp('test15R','r');


figure()
bellhop('test21R');
plotray('test21R');
xlim([0 1500]);



figure()
bellhop('test7R');
plotray('test7R');

figure()
plotssp('test7R','r');


%Alright, bellhop still works, feel good about that. Now I need to figure
%out how best to create/replicate scenarios to look at the processes from
%conference paper.

%Original: April versus November, Stratified versus unstratified

%NOW: Tidal, daily, synoptic, seasonal?

% How to show Tidal: tough, I found that currents were the biggest factor
% in detection efficiency, not changing pycnocline or thermoclines. Maybe
% boundary layers?

% How to show Daily: diurnal differences in noise levels, need to bring in
% transmission loss or something. Have not done anything like that, just
% had propagation until it hit a boundary layer at certain angles of
% incidence.

%How to show synoptic: fun part. Winds changed stratification and
%waveheight, but also noise dropped intensely. Need to figure out how to
%bring in noise

% Seasonal: Easy. We've done this, but need to flesh it out.

cd ('C:\Users\fmm17241\OneDrive - University of Georgia\data\toolbox\AcTUP\')
actup



%FM 8/7/23 19:43 testing

cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\bellhopTesting'

bellhop('guiTest')              %Testing, 6900 Hz frequency
figure()
plotshd('guiTest.shd')

%
bellhop('guiTestHF')            %High frequency, 69 kHz signal
figure()
plotshd('guiTestHF.shd')        %Looking better and better!!!!

bellhop('uniformTest')            
figure()
plotshd('uniformTest.shd') 

























