%Very late but Frank has to compare these


for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        nightBin{COUNT,season} = singleData{COUNT}.Daytime == 0 & singleData{COUNT}.Season ==season;
        dayBin{COUNT,season} = singleData{COUNT}.Daytime == 1 & singleData{COUNT}.Season ==season;
        
        nightDets(COUNT,season)  = mean(singleData{COUNT}.HourlyDets(nightBin{COUNT,season}));
        dayDets(COUNT,season)  = mean(singleData{COUNT}.HourlyDets(dayBin{COUNT,season}));

        nightRatio(COUNT,season)  = mean(singleData{COUNT}.Ratio(nightBin{COUNT,season}));
        dayRatio(COUNT,season)  = mean(singleData{COUNT}.Ratio(dayBin{COUNT,season}));

        nightStrat(COUNT,season)  = mean(singleData{COUNT}.BulkStrat(nightBin{COUNT,season}));
        dayStrat(COUNT,season)  = mean(singleData{COUNT}.BulkStrat(dayBin{COUNT,season}));

        nightNoise(COUNT,season)  = mean(singleData{COUNT}.Noise(nightBin{COUNT,season}));
        dayNoise(COUNT,season)  = mean(singleData{COUNT}.Noise(dayBin{COUNT,season}));

        nightPings(COUNT,season)  = mean(singleData{COUNT}.Pings(nightBin{COUNT,season}));
        dayPings(COUNT,season)  = mean(singleData{COUNT}.Pings(dayBin{COUNT,season}));

        nightWindSpd(COUNT,season)  = mean(singleData{COUNT}.WindSpd(nightBin{COUNT,season}),'omitnan');
        dayWindSpd(COUNT,season)  = mean(singleData{COUNT}.WindSpd(dayBin{COUNT,season}),'omitnan');
    end
end





%%
%Night Detection Confidence Intervals
%night
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.HourlyDets(nightBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.HourlyDets(nightBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CInightDets{COUNT}(season,:) = (mean(singleData{COUNT}.HourlyDets(nightBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%Day
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.HourlyDets(dayBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.HourlyDets(dayBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CIdayDets{COUNT}(season,:) = (mean(singleData{COUNT}.HourlyDets(dayBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%

%Night Ratio Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Ratio(nightBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Ratio(nightBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CInightRatio{COUNT}(season,:) = (mean(singleData{COUNT}.Ratio(nightBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%Day Ratio Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Ratio(dayBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Ratio(dayBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CIdayRatio{COUNT}(season,:) = (mean(singleData{COUNT}.Ratio(dayBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%
%Day Noise Confidence Interval
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Noise(nightBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Noise(nightBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CInightNoise{COUNT}(season,:) = (mean(singleData{COUNT}.Noise(nightBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%Day Noise Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Noise(dayBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Noise(dayBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CIdayNoise{COUNT}(season,:) = (mean(singleData{COUNT}.Noise(dayBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%
%Night Ping Confidence Interval
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Pings(nightBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Pings(nightBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CInightPings{COUNT}(season,:) = (mean(singleData{COUNT}.Pings(nightBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%Day Ping Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.Pings(dayBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.Pings(dayBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CIdayPings{COUNT}(season,:) = (mean(singleData{COUNT}.Pings(dayBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%
%Bulk Strat
%Night Ping Confidence Interval
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.BulkStrat(nightBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.BulkStrat(nightBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CInightStrat{COUNT}(season,:) = (mean(singleData{COUNT}.BulkStrat(nightBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%Day Ping Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.BulkStrat(dayBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.BulkStrat(dayBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CIdayStrat{COUNT}(season,:) = (mean(singleData{COUNT}.BulkStrat(dayBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%%
%Night Wind Confidence Interval
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.WindSpd(nightBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.WindSpd(nightBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CInightWindSpd{COUNT}(season,:) = (mean(singleData{COUNT}.WindSpd(nightBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end

%Day Wind Confidence Intervals
for COUNT = 1:length(singleData)
    for season = 1:length(seasonName)
        %Finding standard deviations/CIs of values
        SEM = std(singleData{COUNT}.WindSpd(dayBin{COUNT,season}),'omitnan')/sqrt(length(singleData{COUNT}.WindSpd(dayBin{COUNT,season})));  
        ts = tinv([0.025  0.975],height(singleData{COUNT})-1);  
        CIdayWindSpd{COUNT}(season,:) = (mean(singleData{COUNT}.WindSpd(dayBin{COUNT,season}),'all','omitnan') + ts*SEM); 
    end
end
%%


X = 1:5;

for COUNT = 1:length(singleData)
    figure()
    nexttile([2 1])
    plot(X,dayDets(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,dayDets(COUNT,:),150,'r','filled')
    ciplot(CIdayDets{COUNT}(:,1),CIdayDets{COUNT}(:,2),X,'r')
    plot(X,nightDets(COUNT,:),'b','LineWidth',2)
    scatter(X,nightDets(COUNT,:),150,'b','filled')
    ciplot(CInightDets{COUNT}(:,1),CInightDets{COUNT}(:,2),X,'b')
    legend('','','Day','','','Night')
    xlabel('Season')
    ylabel('Hourly Detections')
    title('Diurnal Differences in the Acoustic Environment','Hourly Detections')
    
    nexttile([2 1])
    plot(X,dayPings(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,dayPings(COUNT,:),150,'r','filled')
    ciplot(CIdayPings{COUNT}(:,1),CIdayPings{COUNT}(:,2),X,'r')
    plot(X,nightPings(COUNT,:),'b','LineWidth',2)
    scatter(X,nightPings(COUNT,:),150,'b','filled')
    ciplot(CInightPings{COUNT}(:,1),CInightPings{COUNT}(:,2),X,'b')
    legend('','','Day','','','Night')
    xlabel('Season')
    ylabel('Hourly Pings')
    title('','Hourly Pings')
    
    nexttile([2 1])
    plot(X,dayRatio(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,dayRatio(COUNT,:),150,'r','filled')
    ciplot(CIdayRatio{COUNT}(:,1),CIdayRatio{COUNT}(:,2),X,'r')
    plot(X,nightRatio(COUNT,:),'b','LineWidth',2)
    scatter(X,nightRatio(COUNT,:),150,'b','filled')
    ciplot(CInightRatio{COUNT}(:,1),CInightRatio{COUNT}(:,2),X,'b')
    legend('','','Day','','','Night')
    xlabel('Season')
    ylabel('Ping Ratio')
    title('95% CI Shaded','Ping Ratio')
    
    nexttile([2 1])
    plot(X,dayWindSpd(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,dayWindSpd(COUNT,:),150,'r','filled')
    ciplot(CIdayWindSpd{COUNT}(:,1),CIdayWindSpd{COUNT}(:,2),X,'r')
    plot(X,nightWindSpd(COUNT,:),'b','LineWidth',2)
    scatter(X,nightWindSpd(COUNT,:),150,'b','filled')
    ciplot(CInightWindSpd{COUNT}(:,1),CInightWindSpd{COUNT}(:,2),X,'b')
    legend('','','Day','','','Night')
    xlabel('Season')
    ylabel('Windspeed (m/s)')
    title('','Binned Windspeed')
    
    
    nexttile([2 1])
    plot(X,dayNoise(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,dayNoise(COUNT,:),150,'r','filled')
    ciplot(CIdayNoise{COUNT}(:,1),CIdayNoise{COUNT}(:,2),X,'r')
    plot(X,nightNoise(COUNT,:),'b','LineWidth',2)
    scatter(X,nightNoise(COUNT,:),150,'b','filled')
    ciplot(CInightNoise{COUNT}(:,1),CInightNoise{COUNT}(:,2),X,'b')
    yline(650,'--')
    legend('','','Day','','','Night','')
    xlabel('Season')
    ylabel('HF Noise (mV)')
    title('','High-Frequency Noise')
    
    
    
    nexttile([2 1])
    plot(X,dayStrat(COUNT,:),'r','LineWidth',2)
    hold on
    scatter(X,dayStrat(COUNT,:),150,'r','filled')
    ciplot(CIdayStrat{COUNT}(:,1),CIdayStrat{COUNT}(:,2),X,'r')
    plot(X,nightStrat(COUNT,:),'b','LineWidth',2)
    scatter(X,nightStrat(COUNT,:),150,'b','filled')
    ciplot(CInightStrat{COUNT}(:,1),CInightStrat{COUNT}(:,2),X,'b')
    legend('','','Day','','','Night')
    xlabel('Season')
    ylabel('Bulk Strat (C)')
    title('','Thermal Stratification')
end


figure()
hold on

for COUNT = 1:length(singleData)
    plot(X,dayDets(COUNT,:),'r','LineWidth',2)
    scatter(X,dayDets(COUNT,:),150,'r','filled')
    ciplot(CIdayDets{COUNT}(:,1),CIdayDets{COUNT}(:,2),X,'r')
    plot(X,nightDets(COUNT,:),'b','LineWidth',2)
    scatter(X,nightDets(COUNT,:),150,'b','filled')
    ciplot(CInightDets{COUNT}(:,1),CInightDets{COUNT}(:,2),X,'b')
    xlabel('Season')
    ylabel('Hourly Detections')
    title('Diurnal Differences in the Acoustic Environment','Hourly Detections')
    
end




ax = gcf;
exportgraphics(ax,sprintf('frank%d.png',COUNT))
