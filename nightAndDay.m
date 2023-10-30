%FM 2023, Testing diurnal differences during different seasons. The annual
%difference in day vs night is not as clear as expected.

%Run binnedAVG

%Index formed by using the fullData area created in binnedAVG
for COUNT= 1:length(fullData)
    for k = 1:length(seasons)
        daylightIndex{COUNT}{k}(1,:) =  fullData{COUNT}.sunlight==1 & fullData{COUNT}.season ==k;
%         daylightIndex{COUNT}{k}(2,:) =  fullData{COUNT}.sunlight==2 & fullData{COUNT}.season ==k;
        daylightIndex{COUNT}{k}(2,:) =  fullData{COUNT}.sunlight==0 & fullData{COUNT}.season ==k;
    
        %Separating data by day, night, and season
        dayHours{k,COUNT}    = fullData{1,COUNT}(daylightIndex{1,COUNT}{1,k}(1,:),:);
%         sunsetHours{k,COUNT}  = fullData{1,COUNT}(daylightIndex{1,COUNT}{1,k}(2,:),:)
        nightHours{k,COUNT}  = fullData{1,COUNT}(daylightIndex{1,COUNT}{1,k}(2,:),:);
        %Isolating just the detections and noise. All other variables can
        %be helpful but this is just a way of finding averages 
        dayDets{k}(COUNT,:)    = dayHours{k,COUNT}.detections;
        nightDets{k}(COUNT,:)  = nightHours{k,COUNT}.detections;
%         sunsetDets{k}(COUNT,:)  = sunsetHours{k,COUNT}.detections;
        daySounds{k}(COUNT,:)     =dayHours{k,COUNT}.noise;
        nightSounds{k}(COUNT,:)   = nightHours{k,COUNT}.noise;
%         sunsetSounds{k}(COUNT,:)   = sunsetHours{k,COUNT}.noise;
        dayWinds{k}(COUNT,:)     =dayHours{k,COUNT}.windSpeed;
        nightWinds{k}(COUNT,:)   = nightHours{k,COUNT}.windSpeed;

        dayPings{k}(COUNT,:)      = mean(dayHours{k,COUNT}.pings);
        nightPings{k}(COUNT,:)    = mean(nightHours{k,COUNT}.pings);

        dayStrat{k}(COUNT,:) = mean(dayHours{k,COUNT}.stratification);
        nightStrat{k}(COUNT,:) = mean(nightHours{k,COUNT}.stratification);

        dayGradient{k}(COUNT,:) = mean(dayHours{k,COUNT}.hGradient);
        nightGradient{k}(COUNT,:) = mean(nightHours{k,COUNT}.hGradient);
    end
end


%%

% seasonNames = {'Winter','Spring','Summer','Fall','Mariner''s Fall'}
% 
% for COUNT = 1:length(dayDets{1})
%     for SEASON = 1:length(seasonNames)
%         figure()
%         plot(daySounds)
%         
% 
% 
%     end
% 
% end


%%


for k = 1:length(seasons)
    %1st row: DayHoursxSeasons
    %2nd row: NightHoursxSeasons
    dayAverages(1,k)    = mean(daySounds{1,k}(:,:),'all','omitnan');
    dayAverages(2,k) = mean(nightSounds{1,k}(:,:),'all','omitnan');

    dayDetAverages(1,k)    = mean(dayDets{1,k}(:,:),'all','omitnan'); %Dets during day
    dayDetAverages(2,k) = mean(nightDets{1,k}(:,:),'all','omitnan');   %dets during night

    dayWindAverage(1,k) = mean(dayWinds{1,k}(:,:),'all','omitnan');
    nightWindAverage(1,k) = mean(nightWinds{1,k}(:,:),'all','omitnan');    

    dayPingsAverage(1,k) = mean(dayPings{1,k}(:,:),'all','omitnan');
    nightPingsAverage(1,k) = mean(nightPings{1,k}(:,:),'all','omitnan');  

    dayStratAverage(1,k) = mean(dayStrat{1,k}(:,:),'all','omitnan');
    nightStratAverage(1,k) = mean(nightStrat{1,k}(:,:),'all','omitnan');    
    
    dayGradientAverage(1,k) = mean(dayGradient{1,k}(:,:),'all','omitnan');
    nightGradientAverage(1,k) = mean(nightGradient{1,k}(:,:),'all','omitnan');

end

 
x = 1:5;

figure()
hold on
plot(x,dayGradientAverage)
plot(x,nightGradientAverage)

x = 1:10
figure()
hold on
for season = 1:5
    for COUNT = 1:10
        scatter(x,dayGradient{season})
    end
    legend('Winter','Spring','Summer','Fall','M.Fall')
end
xlabel('Transmission #')
ylabel('Thermal Gradient B/W Transceivers')
title('Horizontal Thermal Gradients')

%%

%Day Noise Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(daySounds{1,k}(:),'omitnan')/sqrt(length(daySounds{1,k}));  
    ts = tinv([0.025  0.975],length(daySounds{1,k})-1);  
    CIdayNoise(k,:) = mean(daySounds{:,k},'all','omitnan') + ts*SEM; 
end

%Day Detection Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(dayDets{1,k}(:),'omitnan')/sqrt(length(dayDets{1,k}));  
    ts = tinv([0.025  0.975],length(dayDets{1,k})-1);  
    CIdayDets(k,:) = (mean(dayDets{:,k},'all','omitnan') + ts*SEM)/6*100; 
end

%Day Winds Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(dayWinds{1,k}(:),'omitnan')/sqrt(length(dayWinds{1,k}));  
    ts = tinv([0.025  0.975],length(dayWinds{1,k})-1);  
    CIdayWinds(k,:) = (mean(dayWinds{:,k},'all','omitnan') + ts*SEM); 
end


%Night Noise Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(nightSounds{1,k}(:),'omitnan')/sqrt(length(nightSounds{1,k}));  
    ts = tinv([0.025  0.975],length(nightSounds{1,k})-1);  
    CInightNoise(k,:) = mean(nightSounds{:,k},'all','omitnan') + ts*SEM; 
end

%Night Detection Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(nightDets{1,k}(:),'omitnan')/sqrt(length(nightDets{1,k}));  
    ts = tinv([0.025  0.975],length(nightDets{1,k})-1);  
    CInightDets(k,:) = (mean(nightDets{:,k},'all','omitnan') + ts*SEM)/6*100; 
end

%Night Winds Confidence Intervals
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(nightWinds{1,k}(:),'omitnan')/sqrt(length(nightWinds{1,k}));  
    ts = tinv([0.025  0.975],length(nightWinds{1,k})-1);  
    CInightWinds(k,:) = (mean(nightWinds{:,k},'all','omitnan') + ts*SEM); 
end




%%


figure()
hold on
% ciplot(CIsunsetNoise(:,1),CIsunsetNoise(:,2),1:5,'k')
ciplot(CInightNoise(:,1),CInightNoise(:,2),1:5,'b')
ciplot(CIdayNoise(:,1),CIdayNoise(:,2),1:5,'r')
xlabel('Seasons, 2020')
ylabel('Average Noise (mV)')
title('Average Noise By Time of Day and Season','95% Conf. Interval, 69 kHz')
legend('Night','Day')



%%


figure()
hold
tiledlayout(1,3,'TileSpacing','compact')
nexttile
hold on
ciplot(CInightNoise(:,1),CInightNoise(:,2),1:5,'b')
ciplot(CIdayNoise(:,1),CIdayNoise(:,2),1:5,'r')
ylabel('Noise (69 kHz)')
title('High-Freq. Noise Averages','95% CI')
legend('Night','Day')
xticks([1,2,3,4,5])
xticklabels({'Winter','Spring','Summer','Fall','M.Fall'})

nexttile()
hold on
ciplot(CInightDets(:,1),CInightDets(:,2),1:5,'b',0.5)
ciplot(CIdayDets(:,1),CIdayDets(:,2),1:5,'r',0.5)
ylabel('Avg. Hourly Detection Efficiency (%)')
title('Detection Averages', '95% CI')
xticks([1,2,3,4,5])
xticklabels({'Winter','Spring','Summer','Fall','M.Fall'})

nexttile()
hold on
ciplot(CInightWinds(:,1),CInightWinds(:,2),1:5,'b',0.5)
ciplot(CIdayWinds(:,1),CIdayWinds(:,2),1:5,'r',0.5)
ylabel('Windspeed (m/s)')
title('Wind Differences', '95% CI')
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
