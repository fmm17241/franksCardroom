
cd ([oneDrive,'WeatherData'])

% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\WeatherData'
%
winds2019 = readtable ('continuousWeatherData2019.csv'); %IN UTC!!!!!
% winds2020 = readtable ('continuousWeatherData2020.csv'); %IN UTC!!!!!
winds2020 = readtable ('continuousWeatherData2020.csv'); %IN UTC!!!!!
winds2021 = readtable ('continuousWeatherData2021.csv'); %IN UTC!!!!!
winds = [winds2019;winds2020;winds2021];

%FM 3/21/23
%This changes meteorological directions (wind COMING FROM degrees) to
%oceanographic directions (wind GOING TOWARDS degrees)
%0N clockwise, so 90E.
indexUP = winds.WDIR >= 181;
indexDOWN= winds.WDIR < 181;
winds.WDIR(indexUP) = winds.WDIR(indexUP) -180;
winds.WDIR(indexDOWN) = winds.WDIR(indexDOWN) + 180;





bringIn = readtable ('weatherData2020.csv'); %IN UTC!!!!!
testVector = table2array(bringIn(:,1:5)); testVector(:,6) = zeros(1,length(testVector));
time = datetime(testVector,'TimeZone','UTC')+minutes(10); 
waveHeight = table2timetable(table(time, bringIn.WVHT));
waveHeight.Properties.VariableNames = {'waveHeight'};
waveHeight = retime(waveHeight,'hourly','mean')
waveHeight.waveHeight(waveHeight.waveHeight > 90) = 0;

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

% [rotUwinds,rotVwinds] = rot(windsU,windsV,theta);
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



%Waveheight data
cd([oneDrive,'WeatherData'])
seas2019 = readtable('temp2019.csv'); %IN UTC!!!!!
seas2020 = readtable('temp2020.csv'); %IN UTC!!!!!
seas2021 = readtable('temp2021.csv'); %IN UTC!!!!!
seas = [seas2019;seas2020;seas2021];
timeVectorsst = table2array(seas(:,1:5)); timeVectorsst(:,6) = zeros(1,length(timeVectorsst));
time = datetime(timeVectorsst,'TimeZone','UTC'); time = time + min(1/144);

seas    = table2timetable(table(time,seas.WTMP, seas.WVHT));

%Retimes the data to be binned by the hour.
seas = retime(seas,'hourly','previous');
seas.Properties.VariableNames = {'SST','waveHeight'};
index99 = seas.waveHeight >50;
seas.waveHeight(index99) = 0;
clear fullsst* timeVectorsst





%% Okay, now separate by "seasons"
% 
% WindRose(winds.WDIR(1:11349),winds.WSPD(1:11349),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% title('Wind Rose, Winter');
% %Spring March 20th to June 21st 11350:24715
% WindRose(winds.WDIR(11350:24715),winds.WSPD(11350:24715),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% title('Wind Rose, Spring');
% %Summer June 21st to Sept 22nd 24716:37689
% WindRose(winds.WDIR(24716:37689),winds.WSPD(24716:37689),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% title('Wind Rose, Summer');
% %Fall Sept 22nd to December 21st 37689:end
% WindRose(winds.WDIR(37689:end),winds.WSPD(37689:end),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% title('Wind Rose, Fall');
% 
% 
% WindRose(winds.WDIR(1:11349),winds.WSPD(1:11349),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% title('Wind Rose, Winter');
% 
% 