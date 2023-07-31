%FM 2023, Testing diurnal differences during different seasons. The annual
%difference in day vs night is not as clear as expected.

%Run binnedAVG

%Index formed by using the fullData area created in binnedAVG
for COUNT= 1:length(fullData)
    daylightIndex{COUNT}(1,:) =  fullData{COUNT}.sunlight==1;
    daylightIndex{COUNT}(2,:) =  fullData{COUNT}.sunlight==2;
    daylightIndex{COUNT}(3,:) =  fullData{COUNT}.sunlight==0;
    %Separating data by day, sunset, and night. "Sunset" is defined as
    %the hour in which the sun sets, attempting to find crepuscular
    %period.
    dayHours{1,COUNT}    = fullData{1,COUNT}(daylightIndex{1,COUNT}(1,:),:)
    sunsetHours{1,COUNT}  = fullData{1,COUNT}(daylightIndex{1,COUNT}(2,:),:)
    nightHours{1,COUNT}  = fullData{1,COUNT}(daylightIndex{1,COUNT}(3,:),:)
    %Isolating just the detections and noise. All other variables can
    %be helpful but this is just a way of finding averages 
    dayDets(COUNT,:)    = dayHours{1,COUNT}.detections;
    nightDets(COUNT,:)  = nightHours{1,COUNT}.detections;
    sunsetDets(COUNT,:)  = sunsetHours{1,COUNT}.detections;
    daySounds(COUNT,:)     =dayHours{1,COUNT}.noise;
    nightSounds(COUNT,:)   = nightHours{1,COUNT}.noise;
    sunsetSounds(COUNT,:)   = sunsetHours{1,COUNT}.noise;
end


for k = 1:length(seasons)
    %1st row: DayHoursxSeasons
    %2nd row: SunsetHoursxSeasons
    %3rd row: NightHoursxSeasons
    dayAverages(1)    = mean(daySounds(:,:),'all')
    dayAverages(2)  = mean(sunsetSounds(:,:),'all')
    dayAverages(3) = mean(nightSounds(:,:),'all')

    dayDetAverages(1)    = mean(dayDets(:,:),'all') %Dets during day
    dayDetAverages(2)  = mean(sunsetDets(:,:),'all') %dets during sunset
    dayDetAverages(3) = mean(nightDets(:,:),'all')   %dets during night

end

dayDetPercents = dayDetAverages/6

%%
%Detection 95%
SEM = std(dayDets(:))/sqrt(length(dayDets));  
ts = tinv([0.025  0.975],length(dayDets)-1);  
CIdayDets = mean(dayDets,'all') + ts*SEM; 

%Sunset Confidence Intervals

    %Finding standard deviations/CIs of values
SEM = std(sunsetDets(:))/sqrt(length(sunsetDets));  
ts = tinv([0.025  0.975],length(sunsetDets)-1);  
CIsunsetDets = mean(sunsetDets,'all') + ts*SEM; 


%Night Confidence Intervals
    %Finding standard deviations/CIs of values
SEM = std(nightDets(:))/sqrt(length(nightDets));  
ts = tinv([0.025  0.975],length(nightDets)-1);  
CInightDets = mean(nightDets,'all') + ts*SEM; 

percentCIday    = CIdayDets/6;
percentCIsunset = CIsunsetDets/6;
percentCInight  = CInightDets/6;

 
%%
%Sound CI 95%
%Day Confidence Intervals

    %Finding standard deviations/CIs of values
SEM = std(daySounds(:))/sqrt(length(daySounds));  
ts = tinv([0.025  0.975],length(daySounds)-1);  
CIdaySound = mean(daySounds,'all') + ts*SEM; 

%Sunset Confidence Intervals

    %Finding standard deviations/CIs of values
SEM = std(sunsetSounds(:))/sqrt(length(sunsetSounds));  
ts = tinv([0.025  0.975],length(sunsetSounds)-1);  
CIsunsetSound = mean(sunsetSounds,'all') + ts*SEM; 


%Night Confidence Intervals
    %Finding standard deviations/CIs of values
SEM = std(nightSounds(:))/sqrt(length(nightSounds));  
ts = tinv([0.025  0.975],length(nightSounds)-1);  
CInightSound = mean(nightSounds,'all') + ts*SEM; 



figure()
hold on
ciplot(CIsunsetSound(:,1),CIsunsetSound(:,2),1:5,'k')
ciplot(CInightSound(:,1),CInightSound(:,2),1:5,'b')
ciplot(CIdaySound(:,1),CIdaySound(:,2),1:5,'r')
xlabel('Seasons, 2020')
ylabel('Average Noise (db/mV)')
title('Average Noise By Time of Day and Season','95% Conf. Interval across Entire Reef')
legend('Sunset','Night','Day')

figure()
scatter(1:5,dayAverages(1,:),'r','filled')
hold on
scatter(1:5,dayAverages(2,:),'o','filled')
scatter(1:5,dayAverages(3,:),'k','filled')
errorbar(1:5,dayAverages(1,:),errDay(1,:),'LineStyle','none')
errorbar(1:5,dayAverages(2,:),errDay(2,:),'LineStyle','none')
errorbar(1:5,dayAverages(3,:),errDay(3,:),'LineStyle','none')
ylim([0480 800])
xlim([0.85 5.2])
xlabel('Seasons 1:5')
ylabel('Average Noise (db/mV)')
title('Average across Entire Reef')
legend('Day','Sunset','Night')
%%
%Frank separated all the bin creation to not clutter one massive script
%with so many different goals.

% createTideBins
% createTideBinsABS
% createTiltBins
% createWindSpeedBins
% createWindDirBins
% 
% % The big'un. Looking to bin by both tide and wind directions.
% AxisAndAllies   


for COUNT=1:length(fullData)
    sumD(COUNT) = sum(fullData{COUNT}.detections);
end
