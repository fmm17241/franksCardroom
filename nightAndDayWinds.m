%FM 2023, Testing diurnal differences during different seasons. The annual
%difference in day vs night is not as clear as expected.

%Run binnedAVG
seasons = 1:5;

%Index formed by using the receiverData area created in binnedAVG
for COUNT= 1:length(receiverData)
    for season = 1:length(seasons)
        daylightIndex{COUNT}{season}(1,:) =  receiverData{COUNT}.daytime==1 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd < 2;
        nightlightIndex{COUNT}{season}(1,:) =  receiverData{COUNT}.daytime==0 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd < 2;
        
        daylightIndex{COUNT}{season}(2,:) =  receiverData{COUNT}.daytime==1 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd < 4 & receiverData{COUNT}.windSpd > 2;
        nightlightIndex{COUNT}{season}(2,:) =  receiverData{COUNT}.daytime==0 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd < 4 & receiverData{COUNT}.windSpd > 2;
        
        daylightIndex{COUNT}{season}(3,:) =  receiverData{COUNT}.daytime==1 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd < 6 & receiverData{COUNT}.windSpd > 4;
        nightlightIndex{COUNT}{season}(3,:) =  receiverData{COUNT}.daytime==0 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd < 6 & receiverData{COUNT}.windSpd > 4;
        
        daylightIndex{COUNT}{season}(4,:) =  receiverData{COUNT}.daytime==1 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd < 8 & receiverData{COUNT}.windSpd > 6;
        nightlightIndex{COUNT}{season}(4,:) =  receiverData{COUNT}.daytime==0 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd < 8 & receiverData{COUNT}.windSpd > 6;
        
        daylightIndex{COUNT}{season}(5,:) =  receiverData{COUNT}.daytime==1 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd < 10 & receiverData{COUNT}.windSpd > 8;
        nightlightIndex{COUNT}{season}(5,:) =  receiverData{COUNT}.daytime==0 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd < 10 & receiverData{COUNT}.windSpd > 8;
        
        daylightIndex{COUNT}{season}(6,:) =  receiverData{COUNT}.daytime==1 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd > 10;
        nightlightIndex{COUNT}{season}(6,:) =  receiverData{COUNT}.daytime==0 & receiverData{COUNT}.Season ==season & receiverData{COUNT}.windSpd > 10;
    end
end




for COUNT= 1:length(receiverData)
    for season = 1:length(seasons)
        for k = 1:height(daylightIndex{COUNT}{season})
            %Separating data by day, night, and season
            dayHours{season,COUNT}{1,k}    = receiverData{1,COUNT}(daylightIndex{1,COUNT}{1,season}(k,:),:);
            nightHours{season,COUNT}{1,k}  = receiverData{1,COUNT}(nightlightIndex{1,COUNT}{1,season}(k,:),:);

            dayDets{season,COUNT,:}(1,k)    = mean(dayHours{season,COUNT}{1,k}.HourlyDets);
            nightDets{season,COUNT,:}(1,k)   = mean(nightHours{season,COUNT}{1,k}.HourlyDets);

            daySounds{season,COUNT,:}(1,k)      = mean(dayHours{season,COUNT}{1,k}.Noise);
            nightSounds{season,COUNT,:}(1,k)    = mean(nightHours{season,COUNT}{1,k}.Noise);
            
            dayWinds{season,COUNT,:}(1,k)      = mean(dayHours{season,COUNT}{1,k}.windSpd);
            nightWinds{season,COUNT,:}(1,k)    = mean(nightHours{season,COUNT}{1,k}.windSpd);

            dayPings{season,COUNT,:}(1,k)      = mean(dayHours{season,COUNT}{1,k}.Pings);
            nightPings{season,COUNT,:}(1,k)    = mean(nightHours{season,COUNT}{1,k}.Pings);

            dayStrat{season,COUNT,:}(1,k) = mean(dayHours{season,COUNT}{1,k}.bulkThermalStrat);
            nightStrat{season,COUNT,:}(1,k) = mean(nightHours{season,COUNT}{1,k}.bulkThermalStrat);

        end
    end
end

x= 2:2:12;

%adding note to save


%%
% 
figure()
hold on
for COUNT= 1:length(receiverData)
    for season = 1:length(seasons)
        h = plot(x,nightStrat{season,COUNT})
        labelz = num2str(sprintf('%d',COUNT))
        label(h,sprintf('%s',labelz))
    end
end
ylim([0 2.5])
xlabel('wSpeed')
ylabel('Strat')
title('Night Stratification')

% 
figure()
hold on
for COUNT= 1:length(receiverData)
    for season = 1:length(seasons)
        h = plot(x,dayStrat{season,COUNT})
        labelz = num2str(sprintf('%d',COUNT))
        label(h,sprintf('%s',labelz))
    end
end
ylim([0 2.5])
xlabel('windSpd (m/s)')
ylabel('Strat')
title('Day Stratification')

%%
for COUNT= 1:length(receiverData)
    figure()
    hold on
    for season = 1:length(seasons)
        h = plot(x,dayStrat{season,COUNT})
        labelz = num2str(sprintf('%d',season))
         label(h,sprintf('%s',labelz))
    end
    ylim([0 2.5])
    xlabel('windSpd (m/s)')
    ylabel('Strat')
    title(sprintf('Day Stratification, %d',COUNT))
end

for COUNT= 1:length(receiverData)
    figure()
    hold on
    for season = 1:length(seasons)
        h = plot(x,nightStrat{season,COUNT})
        labelz = num2str(sprintf('%d',season))
        label(h,sprintf('%s',labelz))
    end
    ylim([0 2.5])
    xlabel('windSpd (m/s)')
    ylabel('Strat')
    title(sprintf('Night Stratification, %d',COUNT))
end

%%


for k = 1:length(seasons)
    %1st row: DayHoursxSeasons
    %2nd row: NightHoursxSeasons
    dayAverages(1,k)    = mean(daySounds{1,k}(:,:),'all','omitnan')
    dayAverages(2,k) = mean(nightSounds{1,k}(:,:),'all','omitnan')

    dayDetAverages(1,k)    = mean(dayDets{1,k}(:,:),'all','omitnan') %Dets during day
    dayDetAverages(2,k) = mean(nightDets{1,k}(:,:),'all','omitnan')   %dets during night


    dayWindAverage(1,k) = mean(dayWinds{1,k}(:,:),'all','omitnan')
    nightWindAverage(1,k) = mean(nightWinds{1,k}(:,:),'all','omitnan')    
end

 
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
    CIdayDets(k,:) = (mean(dayDets{:,k},'all','omitnan') + ts*SEM); 
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
    CInightDets(k,:) = (mean(nightDets{:,k},'all','omitnan') + ts*SEM); 
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
ylabel('windSpd (m/s)')
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


for COUNT=1:length(receiverData)
    sumD(COUNT) = sum(receiverData{COUNT}.hourlyDets);
end
