cd ([oneDrive,'WeatherData'])

windsOriginal = readtable ('continuousWeatherData2014.csv'); %IN UTC!!!!!

windsTest = readtable ('continuousWeatherData2014.csv'); %IN UTC!!!!!



%FM 3/21/23
%This changes meteorological directions (wind COMING FROM degrees) to
%oceanographic directions (wind GOING TOWARDS degrees)

%0N clockwise, so 90E.
indexUP = windsOriginal.WDIR >= 181;
indexDOWN= windsOriginal.WDIR < 181;
windsOriginal.WDIR(indexUP) = windsOriginal.WDIR(indexUP) -180;
windsOriginal.WDIR(indexDOWN) = windsOriginal.WDIR(indexDOWN) + 180;


bringIn = readtable ('weatherData2014.csv'); %IN UTC!!!!!
testVector = table2array(bringIn(:,1:5)); testVector(:,6) = zeros(1,length(testVector));
time = datetime(testVector,'TimeZone','UTC')+minutes(10); 
waveHeight = table2timetable(table(time, bringIn.WVHT));
waveHeight.Properties.VariableNames = {'waveHeight'};
waveHeight = retime(waveHeight,'hourly','mean')

timeVector = table2array(windsOriginal(:,1:5)); timeVector(:,6) = zeros(1,length(timeVector));
clearvars time
time = datetime(timeVector,'TimeZone','UTC'); 

winds10Mins = table2timetable(table(time, windsOriginal.WDIR, windsOriginal.WSPD));



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

% figure()
% plot(windsDN,windsU);
% dynamicDateTicks();
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



WindRose(windsOriginal.WDIR(1:11349),windsOriginal.WSPD(1:11349),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Winter');
%Spring March 20th to June 21st 11350:24715
WindRose(windsOriginal.WDIR(11350:24715),windsOriginal.WSPD(11350:24715),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Spring');
%Summer June 21st to Sept 22nd 24716:37689
WindRose(windsOriginal.WDIR(24716:37689),windsOriginal.WSPD(24716:37689),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Summer');
%Fall Sept 22nd to December 21st 37689:end
WindRose(windsOriginal.WDIR(37689:end),windsOriginal.WSPD(37689:end),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Fall');

%%
WindRose(windsTest.WDIR(1:11349),windsTest.WSPD(1:11349),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Winter');
%Spring March 20th to June 21st 11350:24715
WindRose(windsTest.WDIR(11350:24715),windsTest.WSPD(11350:24715),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Spring');
%Summer June 21st to Sept 22nd 24716:37689
WindRose(windsTest.WDIR(24716:37689),windsTest.WSPD(24716:37689),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Summer');
%Fall Sept 22nd to December 21st 37689:end
WindRose(windsTest.WDIR(37689:end),windsTest.WSPD(37689:end),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Fall');
