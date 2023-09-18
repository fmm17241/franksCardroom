%FM 2023, Testing diurnal differences during different seasons. The annual
%difference in day vs night is not as clear as expected.

%Run binnedAVG

%Index formed by using the fullData area created in binnedAVG
for COUNT= 1:length(fullData)
    for k = 1:length(seasons)
        daylightIndex{COUNT}{k}(1,:) =  fullData{COUNT}.sunlight==1 & fullData{COUNT}.season ==k;
        daylightIndex{COUNT}{k}(2,:) =  fullData{COUNT}.sunlight==2 & fullData{COUNT}.season ==k;
        daylightIndex{COUNT}{k}(3,:) =  fullData{COUNT}.sunlight==0 & fullData{COUNT}.season ==k;
    
        %Separating data by day, sunset, and night. "Sunset" is defined as
        %the hour in which the sun sets, attempting to find crepuscular
        %period.
        dayHours{k,COUNT}    = fullData{1,COUNT}(daylightIndex{1,COUNT}{1,k}(1,:),:)
        sunsetHours{k,COUNT}  = fullData{1,COUNT}(daylightIndex{1,COUNT}{1,k}(2,:),:)
        nightHours{k,COUNT}  = fullData{1,COUNT}(daylightIndex{1,COUNT}{1,k}(3,:),:)
        %Isolating just the detections and noise. All other variables can
        %be helpful but this is just a way of finding averages 
        dayDets{k}(COUNT,:)    = dayHours{k,COUNT}.detections;
        nightDets{k}(COUNT,:)  = nightHours{k,COUNT}.detections;
        sunsetDets{k}(COUNT,:)  = sunsetHours{k,COUNT}.detections;
        daySounds{k}(COUNT,:)     =dayHours{k,COUNT}.noise;
        nightSounds{k}(COUNT,:)   = nightHours{k,COUNT}.noise;
        sunsetSounds{k}(COUNT,:)   = sunsetHours{k,COUNT}.noise;

    end
end


for k = 1:length(seasons)
    %1st row: DayHoursxSeasons
    %2nd row: SunsetHoursxSeasons
    %3rd row: NightHoursxSeasons
    dayAverages(1,k)    = mean(daySounds{1,k}(:,:),'all')
    dayAverages(2,k)  = mean(sunsetSounds{1,k}(:,:),'all')
    dayAverages(3,k) = mean(nightSounds{1,k}(:,:),'all')

    dayDetAverages(1,k)    = mean(dayDets{1,k}(:,:),'all') %Dets during day
    dayDetAverages(2,k)  = mean(sunsetDets{1,k}(:,:),'all') %dets during sunset
    dayDetAverages(3,k) = mean(nightDets{1,k}(:,:),'all')   %dets during night

end

 
%%

%Day Noise Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(daySounds{1,k}(:))/sqrt(length(daySounds{1,k}));  
    ts = tinv([0.025  0.975],length(daySounds{1,k})-1);  
    CIdayNoise(k,:) = mean(daySounds{:,k},'all') + ts*SEM; 
end

%Day Detection Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(dayDets{1,k}(:))/sqrt(length(dayDets{1,k}));  
    ts = tinv([0.025  0.975],length(dayDets{1,k})-1);  
    CIdayDets(k,:) = (mean(dayDets{:,k},'all') + ts*SEM)/6*100; 
end

%Sunset Noise Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(sunsetSounds{1,k}(:))/sqrt(length(sunsetSounds{1,k}));  
    ts = tinv([0.025  0.975],length(sunsetSounds{1,k})-1);  
    CIsunsetNoise(k,:) = mean(sunsetSounds{:,k},'all') + ts*SEM; 
end

%Sunset Detection Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(sunsetDets{1,k}(:))/sqrt(length(sunsetDets{1,k}));  
    ts = tinv([0.025  0.975],length(sunsetDets{1,k})-1);  
    CIsunsetDets(k,:) = (mean(sunsetDets{:,k},'all') + ts*SEM)/6*100; 
end

%Night Noise Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(nightSounds{1,k}(:))/sqrt(length(nightSounds{1,k}));  
    ts = tinv([0.025  0.975],length(nightSounds{1,k})-1);  
    CInightNoise(k,:) = mean(nightSounds{:,k},'all') + ts*SEM; 
end

%Night Detection Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(nightDets{1,k}(:))/sqrt(length(nightDets{1,k}));  
    ts = tinv([0.025  0.975],length(nightDets{1,k})-1);  
    CInightDets(k,:) = (mean(nightDets{:,k},'all') + ts*SEM)/6*100; 
end






%%


figure()
hold on
ciplot(CIsunsetNoise(:,1),CIsunsetNoise(:,2),1:5,'k')
ciplot(CInightNoise(:,1),CInightNoise(:,2),1:5,'b')
ciplot(CIdayNoise(:,1),CIdayNoise(:,2),1:5,'r')
xlabel('Seasons, 2020')
ylabel('Average Noise (mV)')
title('Average Noise By Time of Day and Season','95% Conf. Interval, 69 kHz')
legend('Sunset','Night','Day')

% figure()
% scatter(1:5,dayAverages(1,:),'r','filled')
% hold on
% scatter(1:5,dayAverages(2,:),'o','filled')
% scatter(1:5,dayAverages(3,:),'k','filled')
% errorbar(1:5,dayAverages(1,:),errDay(1,:),'LineStyle','none')
% errorbar(1:5,dayAverages(2,:),errDay(2,:),'LineStyle','none')
% errorbar(1:5,dayAverages(3,:),errDay(3,:),'LineStyle','none')
% ylim([0480 800])
% xlim([0.85 5.2])
% xlabel('Seasons 1:5')
% ylabel('Average Noise (db/mV)')
% title('Average across Entire Reef')
% legend('Day','Sunset','Night')


figure()
hold
tiledlayout(1,2,'TileSpacing','compact')
nexttile
hold on
ciplot(CIsunsetNoise(:,1),CIsunsetNoise(:,2),1:5,'k')
ciplot(CInightNoise(:,1),CInightNoise(:,2),1:5,'b')
ciplot(CIdayNoise(:,1),CIdayNoise(:,2),1:5,'r')
ylabel('Noise (69 kHz)')
title('High-Freq. Noise Averages','95% CI')
legend('Sunset','Night','Day')
xticks([1,2,3,4,5])
xticklabels({'Winter','Spring','Summer','Fall','M.Fall'})
nexttile()
hold on
% ciplot(CIsunsetDets(:,1),CIsunsetDets(:,2),1:5,'k',0.5)
ciplot(CInightDets(:,1),CInightDets(:,2),1:5,'b',0.5)
ciplot(CIdayDets(:,1),CIdayDets(:,2),1:5,'r',0.5)
ylabel('Avg. Hourly Detection Efficiency (%)')
title('Detection Averages', '95% CI')
xticks([1,2,3,4,5])
xticklabels({'Winter','Spring','Summer','Fall','M.Fall'})




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
