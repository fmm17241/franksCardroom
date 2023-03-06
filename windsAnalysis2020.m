cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\WeatherData'
%
% winds2019 = readtable ('continuousWeatherData2019.csv'); %IN UTC!!!!!
% winds2020 = readtable ('continuousWeatherData2020.csv'); %IN UTC!!!!!
winds = readtable ('continuousWeatherData2020.csv'); %IN UTC!!!!!
% winds2021 = readtable ('continuousWeatherData2021.csv'); %IN UTC!!!!!

bringIn = readtable ('weatherData2020.csv'); %IN UTC!!!!!
testVector = table2array(bringIn(:,1:5)); testVector(:,6) = zeros(1,length(testVector));
time = datetime(testVector,'TimeZone','UTC')+minutes(10); 
waveHeight = table2timetable(table(time, bringIn.WVHT));
waveHeight.Properties.VariableNames = {'waveHeight'};
waveHeight = retime(waveHeight,'hourly','mean')
% wvTime = retime()

% winds = [winds2019; winds2020; winds2021];

timeVector = table2array(winds(:,1:5)); timeVector(:,6) = zeros(1,length(timeVector));
clearvars time
time = datetime(timeVector,'TimeZone','UTC'); 


winds10Mins = table2timetable(table(time, winds.WDIR, winds.WSPD));



windsAverage = retime(winds10Mins(:,:),'hourly','mean');
% windsAverage = step1(8767:17550,:);  %Takes ONLY 2020, after converting to EST (UTC +5)
windsAverage.Properties.VariableNames = {'WDIR','WSPD'};

WDIR = windsAverage.WDIR;
WSPD = windsAverage.WSPD;


windsDN = datenum(windsAverage.time);
windsDT = datetime(windsDN,'ConvertFrom','datenum','TimeZone','UTC');

[windsU, windsV] = ndbc2cart(WSPD,WDIR);
% scrange(windsDN)
% scrange(windsU)
% scrange(windsV)


% ax = [737907.958333333 737920 -15 15];
% figure()
% tt = stickplot(windsDN(2688:3233),windsU(2688:3233),windsV(2688:3233),ax);
% % datetick('x','keeplimits')
% title('Wind Speed & Magnitude 2020');
% ylabel('Velocity (m/s)');



figure()
plot(windsDN,windsU);


%%
%Rotate the winds based on theta from cross/along shore. For context, check
%tidalAnalysis2020, finds the coefficient using tidal velocities
theta = 0.5825;

[rotUwinds,rotVwinds] = rot(windsU,windsV,theta);
% 
% figure()
% plot(windsDN,rotUwinds);

%%

windsMonthly = retime(winds10Mins,'monthly','mean');
windsMonthly.Properties.VariableNames = {'WDIR','WSPD'};


figure()
scatter(windsMonthly.time,windsMonthly.WSPD);
hold on
plot(windsMonthly.time,windsMonthly.WSPD);


% figure()
% plot(windsAverage.time,WSPD);
% hold on
% % yValue = [0 100];
% % for k = 1:length(sunset)-1
% %     x = [sunset(k) sunrise(k+1)];
% %     area(x,yValue,'FaceColor','k','FaceAlpha',0.2);
% % end
% title('Wind Speeds');
% ylabel('Magnitude, m/s');


windy = sin(WDIR).*WSPD;
windx = cos(WDIR).*WSPD;


% signal = WSPD;
win    = 6*24*30;
sampleFreq = 1/600


directionSignal = detrend(WDIR);
speedSignal = detrend(WSPD);

%Cite WindRose, from Daniel Pereira on matlab filexchange

% WindRose(winds.WDIR(1:20),winds.WSPD(1:20),'AngleNorth',0,'AngleEast',90);
% 
% WindRose(winds.WDIR,winds.WSPD,'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% 
% WindRose(windsAverage.WDIR,windsAverage.WSPD,'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');



%% Okay, now separate by "seasons"

%Astronomical
%Winter start to March 20th 1:11349
WindRose(winds.WDIR(1:11349),winds.WSPD(1:11349),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Winter');
%Spring March 20th to June 21st 11350:24715
WindRose(winds.WDIR(11350:24715),winds.WSPD(11350:24715),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Spring');
%Summer June 21st to Sept 22nd 24716:37689
WindRose(winds.WDIR(24716:37689),winds.WSPD(24716:37689),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Summer');
%Fall Sept 22nd to December 21st 37689:end
WindRose(winds.WDIR(37689:end),winds.WSPD(37689:end),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Fall');



% directionSignal = WDIR;
% speedSignal = WSPD;
% 
% [speedpxx,speedf] = pwelch(speedSignal,win,[],[],sampleFreq,'onesided','ConfidenceLevel',.95);

% 
% figure()
% yyaxis left
% loglog(f.*86400,pxx.*f);
% ylabel('Power, Directional');
% hold on
% yyaxis right
% loglog(speedf.*86400,speedpxx.*f);
% ylabel('Power, Speed');
% xlabel('1 Day Frequency');
% title('2020 Wind Direction & Speed, Freq. Spectrum');
% 
% figure()
% loglog(f.*86400,pxx.*f);
% ylabel('Power, Directional');
% xlabel('1 Day Frequency');
% title('Wind Direction, GRNMS')
% 
% figure()
% loglog(speedf.*86400,speedpxx.*f);
% ylabel('Power, Speed');
% xlabel('1 Day Frequency');
% title('Wind Speed, GRNMS')
% 
% 
% cutoffFr = (1/432000) 
% %sampling rate
% fs = 1/600; %10 min. data
% Wn = cutoffFr/(0.5*fs);
% 
% [B,A] = butter(5,Wn,'low');
% 
% Wfx = filtfilt(B,A,windx);
% Wfy = filtfilt(B,A,windy);
% 
% axis = [0 3000 0 10];
% 
% 
% % figure()
% % hf = feather(Wfx,Wfy);
% % set(gca, 'XLim',[0 numel(Wfx)])                                       % Set X-Axis Limits
% % xt = get(gca,'XTick')                                               % Get X-Tick Values
% % xt(1) = 1;
% % txt = createdDT(xt);                                                        % Define ‘t’ Using ‘xt’
% % set(gca, 'XTick',xt, 'XTickLabel',datestr(txt,'dd/mm/yyyy'), 'XTickLabelRotation',30)
% % 
% % figure()
% % stickplot(createdDN(1:51998),windx,windy,axis);