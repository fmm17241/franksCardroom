
cd ([oneDrive,'WeatherData'])

% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\WeatherData'
%
% winds2019 = readtable ('continuousWeatherData2019.csv'); %IN UTC!!!!!
% winds2020 = readtable ('continuousWeatherData2020.csv'); %IN UTC!!!!!
winds = readtable ('continuousWeatherData2020.csv'); %IN UTC!!!!!
% winds2021 = readtable ('continuousWeatherData2021.csv'); %IN UTC!!!!!

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

%Cite WindRose, from Daniel Pereira on matlab filexchange

% WindRose(winds.WDIR(1:20),winds.WSPD(1:20),'AngleNorth',0,'AngleEast',90);
% 
% WindRose(winds.WDIR,winds.WSPD,'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
% 
% WindRose(windsAverage.WDIR,windsAverage.WSPD,'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');



%% Okay, now separate by "seasons"

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


WindRose(winds.WDIR(1:11349),winds.WSPD(1:11349),'AngleNorth',0,'AngleEast',90,'nDirections',10,'FreqLabelAngle','ruler');
title('Wind Rose, Winter');





%%

%Okay, trying to rotate the winds, let's see if parallel and perpendicular
%matter. Don't believe that's the focus, I think its the relation to shore
%because of the physical processes it causes.

%Transceiver pairings:
% 1.  SURTASSSTN20 hearing STSNew1
% 2.  STSNew1 hearing SURTASSSTN20
% 3.  SURTASS05In hearing FS6
% 4.  FS6 hearing SURTASS05In
% 5.  Roldan hearing 08ALTIN
% 6.  08ALTIN hearing Roldan
% 7.  SURTASS05In hearing STSNEW2
% 8.  STSNEW2 hearing SURTASS05In
% 9.  39IN hearing SURTASS05IN
% 10. SURTASS05IN hearing 39IN
% 11. STSNEW2 hearing FS6
% 12. FS6 hearing STSNew2
% 
% load mooredGPS 
% transmitters = {'63068' '63073' '63067' '63079' '63080' '63066' '63076' '63078' '63063'...
%         '63070' '63074' '63075' '63081' '63064' '63062' '63071'};
% %     
% % moored = {'FS17','STSNew1','33OUT','34ALTOUT','09T','Roldan',...
% %           '08ALTIN','14IN','West15','08C','STSNew2','FS6','39IN','SURTASS_05IN',...
% %           'SURTASS_STN20','SURTASS_FS15'}.';
% 
% %SURTASSSTN20 and STSNew1
% AnglesD(1) = atan2d((mooredGPS(15,2)-mooredGPS(2,2)),(mooredGPS(15,1)-mooredGPS(2,1)));
% AnglesD(2) = atan2d((mooredGPS(2,2)-mooredGPS(15,2)),(mooredGPS(2,1)-mooredGPS(15,1)));
% %SURTASS05IN and FS6
% AnglesD(3) = atan2d((mooredGPS(12,2)-mooredGPS(14,2)),(mooredGPS(12,1)-mooredGPS(14,1)));
% AnglesD(4) = atan2d((mooredGPS(14,2)-mooredGPS(12,2)),(mooredGPS(14,1)-mooredGPS(12,1)));
% %Roldan and 08ALTIN
% AnglesD(5) = atan2d((mooredGPS(6,2)-mooredGPS(7,2)),(mooredGPS(6,1)-mooredGPS(7,1)));
% AnglesD(6) = atan2d((mooredGPS(7,2)-mooredGPS(6,2)),(mooredGPS(7,1)-mooredGPS(6,1)));
% %SURTASS05IN and STSNew2
% AnglesD(7) = atan2d((mooredGPS(11,2)-mooredGPS(14,2)),(mooredGPS(11,1)-mooredGPS(14,1)));
% AnglesD(8) = atan2d((mooredGPS(14,2)-mooredGPS(11,2)),(mooredGPS(14,1)-mooredGPS(11,1)));
% %39IN and SURTASS05IN
% AnglesD(9) = atan2d((mooredGPS(14,2)-mooredGPS(13,2)),(mooredGPS(14,1)-mooredGPS(13,1)));
% AnglesD(10) = atan2d((mooredGPS(13,2)-mooredGPS(14,2)),(mooredGPS(13,1)-mooredGPS(14,1)));
% %STSNEW2 and FS6
% AnglesD(11) = atan2d((mooredGPS(12,2)-mooredGPS(11,2)),(mooredGPS(12,1)-mooredGPS(11,1)));
% AnglesD(12) = atan2d((mooredGPS(11,2)-mooredGPS(12,2)),(mooredGPS(11,1)-mooredGPS(12,1)));
% 
% AnglesR = deg2rad(AnglesD);
% 
% 
% rotatorsR = deg2rad(90)+AnglesR;
% % rotatorsR = -AnglesR;
% %%%%%%%
% rotatorsD = rad2deg(rotatorsR);

%FMFMFM: All of the above comes from "ArrayTidalAnalysis", should be run
%together

for COUNT = 1:length(rotatorsR)
    [rotUwinds(COUNT,:) rotVwinds(COUNT,:)] = rot(windsU,windsV,rotatorsR(1,COUNT));
end

%Okay, rotated so that X is parallel to their transmision axis. Cool I
%guess. FM 3/21/23








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