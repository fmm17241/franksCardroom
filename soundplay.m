%%Hey stupid. Running G:\Glider\MinMaxSSP

% Need to better understand boundary layers of top and bottom of water
% column. No data in the first few meters, and guessed the last 8 meters at
% the bottom. Not great.

%% Using real bellhop now not bellhopM. Compiled executables
load angusdbdAprilMay
load angusebdAprilMay

[matstruct] = Bindata(fstruct,sstruct);
matstruct.speed = sndspd(matstruct.salin,matstruct.temp,matstruct.z);




cd 'G:\Glider\MinMaxSSP\FullExamples'

bellhop('strat457');
figure()
plotssp('strat457');
figure()
plotray('strat457');


bellhop('strat109');
figure()
plotssp('strat109');
figure()
plotray('strat109');

figure()
plotssp('example1');
hold on
plotssp('example3');
breakxaxis([1523 1524]);
hold off
set(gca, 'Color', 'none');
title('\color{blue}Sound Speed Profiles, m/s');
export_fig sspbothtest -png -transparent




cd 'G:\BellhopPractice'

bellhop('MunkB_Coh')
figure()
plotshd('MunkB_Coh.shd');

%%

pcolor(matstruct.dn(1:560),matstruct.z,matstruct.rho(1:560,:)')
shading interp; colorbar; set(gca,'ydir','reverse'); datetick('x','keeplimits');
ylim([0 20])
datetick('x','keeplimits');
ylabel('Depth, m');
title('Density(kg/m^3) by Depth');

xline([737907.520833333]); % 109, max strat
xline([737922.020833333]); % 457, min strat
    

xline([737908.520833333]); % 133, May event

%% Make example SSPs

cd G:\Glider\MinMaxSSP\FullExamples\Surfacings


bellhop('surfacing1')
figure()
plotray('surfacing1')


bellhop('surfacing3')
figure()
plotray('surfacing3')



%% 


cd G:\Glider\Data\Environmental






