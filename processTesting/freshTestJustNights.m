%FM full seasons, not season/season


for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        seasonBin{COUNT,season} = singleData{COUNT}.Season ==season;
        
        seasonDets(COUNT,season)  = mean(singleData{COUNT}.HourlyDets(seasonBin{COUNT,season}));

        seasonRatio(COUNT,season)  = mean(singleData{COUNT}.Ratio(seasonBin{COUNT,season}));

        seasonStrat(COUNT,season)  = mean(singleData{COUNT}.BulkStrat(seasonBin{COUNT,season}));

        seasonNoise(COUNT,season)  = mean(singleData{COUNT}.Noise(seasonBin{COUNT,season}));

        seasonPings(COUNT,season)  = mean(singleData{COUNT}.Pings(seasonBin{COUNT,season}));

        seasonWindSpd(COUNT,season)  = mean(singleData{COUNT}.WindSpd(seasonBin{COUNT,season}),'omitnan');


    end
end

%%
%95% CI
%%
%Detection Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.HourlyDets(seasonBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.HourlyDets(seasonBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        ciDets{COUNT}(season,:) = (mean(singleData{COUNT}.HourlyDets(seasonBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%

%season Ratio Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Ratio(seasonBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Ratio(seasonBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        ciRatio{COUNT}(season,:) = (mean(singleData{COUNT}.Ratio(seasonBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end


%%
%season Noise Confidence Interval
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Noise(seasonBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Noise(seasonBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        ciNoise{COUNT}(season,:) = (mean(singleData{COUNT}.Noise(seasonBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end


%%
%season Ping Confidence Interval
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Pings(seasonBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Pings(seasonBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        ciPings{COUNT}(season,:) = (mean(singleData{COUNT}.Pings(seasonBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end


%%
%Bulk Strat
%season Ping Confidence Interval
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.BulkStrat(seasonBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.BulkStrat(seasonBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        ciStrat{COUNT}(season,:) = (mean(singleData{COUNT}.BulkStrat(seasonBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end


%%
%season Wind Confidence Interval
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.WindSpd(seasonBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.WindSpd(seasonBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        ciWindSpd{COUNT}(season,:) = (mean(singleData{COUNT}.WindSpd(seasonBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%

X = 1:5;

for COUNT = 1:length(singleData)
    figure()
    nexttile([2 1])
    plot(X,seasonDets(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,seasonDets(COUNT,:),150,'r','filled')
    ciplot(ciDets{COUNT}(:,1),ciDets{COUNT}(:,2),X,'r')
    xlabel('Season')
    ylabel('Hourly Detections')
    title('Seasonal Differences in the Acoustic Environment','Hourly Detections')
    
    nexttile([2 1])
    plot(X,seasonPings(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,seasonPings(COUNT,:),150,'r','filled')
    ciplot(ciPings{COUNT}(:,1),ciPings{COUNT}(:,2),X,'r')
    xlabel('Season')
    ylabel('Hourly Pings')
    title('','Hourly Pings')
    
    nexttile([2 1])
    plot(X,seasonRatio(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,seasonRatio(COUNT,:),150,'r','filled')
    ciplot(ciRatio{COUNT}(:,1),ciRatio{COUNT}(:,2),X,'r')
    xlabel('Season')
    ylabel('Ping Ratio')
    ylim([0.65 .8])
    title('95% CI Shaded','Ping Ratio')
    
    nexttile([2 1])
    plot(X,seasonWindSpd(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,seasonWindSpd(COUNT,:),150,'r','filled')
    ciplot(ciWindSpd{COUNT}(:,1),ciWindSpd{COUNT}(:,2),X,'r')
    xlabel('Season')
    ylabel('Windspeed (m/s)')
    title('','Binned Windspeed')
    
    
    nexttile([2 1])
    plot(X,seasonNoise(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,seasonNoise(COUNT,:),150,'r','filled')
    ciplot(ciNoise{COUNT}(:,1),ciNoise{COUNT}(:,2),X,'r')
    yline(650,'--')
    ylim([460 720])
    xlabel('Season')
    ylabel('HF Noise (mV)')
    title('','High-Frequency Noise')
    
    
    
    nexttile([2 1])
    plot(X,seasonStrat(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,seasonStrat(COUNT,:),150,'r','filled')
    ciplot(ciStrat{COUNT}(:,1),ciStrat{COUNT}(:,2),X,'r')
    xlabel('Season')
    ylabel('Bulk Strat (C)')
    title('','Thermal Stratification')
end