%FM 11/30/22, wanted sunrise sunset and daylength throughout a year. Using
%UTC, but SunriseSunsetEDT shows our standard timezone

figure()
SunriseSunsetUTC

dayLength = sunset - sunrise;




x = 1:length(dayLength);

figure()
plot(x,dayLength);
xlabel('Day');
ylabel('Hours of Sunlight');
title('Annual Day Length, 2020');
xlim([0 365])


minDayL = min(dayLength);
maxDayL = max(dayLength);

%Okay, we have daylength throughout the year, looking good. Now have to
%compare hourly differences. Use VUEexports or something


%Test against dailyAVG found in VUEexports
VUEexports
% This uses seasonalSignalsBlant, which includes Mariner's Fall

figure()
plot(dailyAVG.Time,dailyAVG.Detections);
title('AVG Daily Dets');
ylabel('Hr. Detections');

figure()
plot(dailyAVG.Time,dailyAVG.Noise);
title('AVG Daily Noise');
ylabel('Hr. Noise (mV, 69 kHz)');

%How to make a variable out of "is it day or night?"
%Sun up is 1, sun down is 0
sunRun = [sunrise; sunset];
xx = length(sunRun);

hourlyAvg{4} = 0;
sunlight = zeros(1,height(hourlyAVG));


for k = 1:xx
    currentSun = sunRun(:,k);
    currentHours = isbetween(hourlyAVG.Time,currentSun(1,1),currentSun(2,1))
    currentDays = find(currentHours);
    sunlight(currentDays) = 1;
end

%This variable now gives a 1 if daytime and a 0 if nighttime!
hourlyAVG = addvars(hourlyAVG,sunlight','NewVariableNames','Day1Night0')

seasons = zeros(1,height(hourlyAVG));
%Using seasonalSignalsBlant, need to give 1-5 to denote season.
seasons(winter) = 1; seasons(spring) = 2; seasons(summer) = 3; seasons(fall) = 4; seasons(Mfall) = 5;

hourlyAVG = addvars(hourlyAVG,seasons','NewVariableNames','Season');

%FM, you can do this. Good productive day.













