%FM 2023, Testing diurnal differences during different seasons. The annual
%difference in day vs night is not as clear as expected.
%FM 2024, editing to replace "receiverData"/binnedAVG with receiverData from
%buildReceiverData

%Run buildReceiverData
seasons = 1:5;
%Index formed by using the receiverData area created in binnedAVG
for COUNT= 1:length(receiverData)
    for k = 1:length(seasons)
        daylightIndex{COUNT}{k}(1,:) =  receiverData{COUNT}.daytime==1 & receiverData{COUNT}.Season ==k;
%         daylightIndex{COUNT}{k}(2,:) =  receiverData{COUNT}.daytime==2 & receiverData{COUNT}.Season ==k;
        daylightIndex{COUNT}{k}(2,:) =  receiverData{COUNT}.daytime==0 & receiverData{COUNT}.Season ==k;
    
        %Separating data by day, night, and season
        dayHours{k,COUNT}    = receiverData{1,COUNT}(daylightIndex{1,COUNT}{1,k}(1,:),:);
%         sunsetHours{k,COUNT}  = receiverData{1,COUNT}(daylightIndex{1,COUNT}{1,k}(2,:),:)
        nightHours{k,COUNT}  = receiverData{1,COUNT}(daylightIndex{1,COUNT}{1,k}(2,:),:);
        %Isolating just the detections and noise. All other variables can
        %be helpful but this is just a way of finding averages 
        dayDets{k,COUNT}    = dayHours{k,COUNT}.HourlyDets;
        nightDets{k,COUNT}  = nightHours{k,COUNT}.HourlyDets;
%         sunsetDets{k}(COUNT,:)  = sunsetHours{k,COUNT}.HourlyDets;
        daySounds{k,COUNT}     =dayHours{k,COUNT}.Noise;
        nightSounds{k,COUNT}   = nightHours{k,COUNT}.Noise;
%         sunsetSounds{k}(COUNT,:)   = sunsetHours{k,COUNT}.noise;
        dayWinds{k,COUNT}     =dayHours{k,COUNT}.windSpd;
        nightWinds{k,COUNT}   = nightHours{k,COUNT}.windSpd;

        dayPings{k,COUNT}      = dayHours{k,COUNT}.Pings;
        nightPings{k,COUNT}    = nightHours{k,COUNT}.Pings;

        dayStrat{k,COUNT} = dayHours{k,COUNT}.bulkThermalStrat;
        nightStrat{k,COUNT} = nightHours{k,COUNT}.bulkThermalStrat;
    end
end
% 
% for k = 1:length(seasons)
%     dayDets{k} = padcat(dayDets1{k,1},dayDets1{k,2},dayDets1{k,3},dayDets1{k,4},dayDets1{k,5},dayDets1{k,6},dayDets1{k,7},dayDets1{k,8},dayDets1{k,9},dayDets1{k,10},dayDets1{k,11},dayDets1{k,12},dayDets1{k,13})
%     nightDets{k} = padcat(nightDets1{k,1},nightDets1{k,2},nightDets1{k,3},nightDets1{k,4},nightDets1{k,5},nightDets1{k,6},nightDets1{k,7},nightDets1{k,8},nightDets1{k,9},nightDets1{k,10},nightDets1{k,11},nightDets1{k,12},nightDets1{k,13})
% 
%     daySounds{k} = padcat(daySounds1{k,1},daySounds1{k,2},daySounds1{k,3},daySounds1{k,4},daySounds1{k,5},daySounds1{k,6},daySounds1{k,7},daySounds1{k,8},daySounds1{k,9},daySounds1{k,10},daySounds1{k,11},daySounds1{k,12},daySounds1{k,13})
%     nightSounds{k} = padcat(nightSounds1{k,1},nightSounds1{k,2},nightSounds1{k,3},nightSounds1{k,4},nightSounds1{k,5},nightSounds1{k,6},nightSounds1{k,7},nightSounds1{k,8},nightSounds1{k,9},nightSounds1{k,10},nightSounds1{k,11},nightSounds1{k,12},nightSounds1{k,13})
% 
% 
%     dayWinds{k} = padcat(dayWinds1{k,1},dayWinds1{k,2},dayWinds1{k,3},dayWinds1{k,4},dayWinds1{k,5},dayWinds1{k,6},dayWinds1{k,7},dayWinds1{k,8},dayWinds1{k,9},dayWinds1{k,10},dayWinds1{k,11},dayWinds1{k,12},dayWinds1{k,13})
%     nightWinds{k} = padcat(nightWinds1{k,1},nightWinds1{k,2},nightWinds1{k,3},nightWinds1{k,4},nightWinds1{k,5},nightWinds1{k,6},nightWinds1{k,7},nightWinds1{k,8},nightWinds1{k,9},nightWinds1{k,10},nightWinds1{k,11},nightWinds1{k,12},nightWinds1{k,13})
% 
% 
%     dayPings{k} = padcat(dayPings1{k,1},dayPings1{k,2},dayPings1{k,3},dayPings1{k,4},dayPings1{k,5},dayPings1{k,6},dayPings1{k,7},dayPings1{k,8},dayPings1{k,9},dayPings1{k,10},dayPings1{k,11},dayPings1{k,12},dayPings1{k,13})
%     nightPings{k} = padcat(nightPings1{k,1},nightPings1{k,2},nightPings1{k,3},nightPings1{k,4},nightPings1{k,5},nightPings1{k,6},nightPings1{k,7},nightPings1{k,8},nightPings1{k,9},nightPings1{k,10},nightPings1{k,11},nightPings1{k,12},nightPings1{k,13})
% 
% 
%     dayStrat{k} = padcat(dayStrat1{k,1},dayStrat1{k,2},dayStrat1{k,3},dayStrat1{k,4},dayStrat1{k,5},dayStrat1{k,6},dayStrat1{k,7},dayStrat1{k,8},dayStrat1{k,9},dayStrat1{k,10},dayStrat1{k,11},dayStrat1{k,12},dayStrat1{k,13})
%     nightStrat{k} = padcat(nightStrat1{k,1},nightStrat1{k,2},nightStrat1{k,3},nightStrat1{k,4},nightStrat1{k,5},nightStrat1{k,6},nightStrat1{k,7},nightStrat1{k,8},nightStrat1{k,9},nightStrat1{k,10},nightStrat1{k,11},nightStrat1{k,12},nightStrat1{k,13})
% end

% Receiver 2 is just too dramatically different when it comes to detections I'm going to NaN it for
% the purposes of finding a better average
% dayDets{1,1}(:,2) = nan(length(dayDets{1,1}),1); dayDets{1,4}(:,2) = nan(length(dayDets{1,4}),1);
% dayDets{1,2}(:,2) = nan(length(dayDets{1,2}),1); dayDets{1,5}(:,2) = nan(length(dayDets{1,5}),1);
% dayDets{1,3}(:,2) = nan(length(dayDets{1,3}),1);
% 
% nightDets{1,1}(:,2) = nan(length(nightDets{1,1}),1); nightDets{1,4}(:,2) = nan(length(nightDets{1,4}),1);
% nightDets{1,2}(:,2) = nan(length(nightDets{1,2}),1); nightDets{1,5}(:,2) = nan(length(nightDets{1,5}),1);
% nightDets{1,3}(:,2) = nan(length(nightDets{1,3}),1);


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

for COUNT = 1:length(dayDets)
for k = 1:length(seasons)
    %1st row: DayHoursxSeasons
    %2nd row: NightHoursxSeasons
    dayAverages(COUNT,k)    = mean(daySounds{k,COUNT},'all','omitnan');
    nightAverages(COUNT,k) = mean(nightSounds{k,COUNT},'all','omitnan');

    dayDetAverages(COUNT,k)    = mean(dayDets{k,COUNT},'all','omitnan'); %Dets during day
    nightDetAverages(COUNT,k) = mean(nightDets{k,COUNT},'all','omitnan');   %dets during night

    dayWindAverage(COUNT,k) = mean(dayWinds{k,COUNT},'all','omitnan');
    nightWindAverage(COUNT,k) = mean(nightWinds{k,COUNT},'all','omitnan');    

    dayPingsAverage(COUNT,k) = mean(dayPings{k,COUNT},'all','omitnan');
    nightPingsAverage(COUNT,k) = mean(nightPings{k,COUNT},'all','omitnan');  

    dayStratAverage(COUNT,k) = mean(dayStrat{k,COUNT},'all','omitnan');
    nightStratAverage(COUNT,k) = mean(nightStrat{k,COUNT},'all','omitnan');    
end

end


%%

%Day Noise Confidence Intervals
for COUNT = 1:length(dayDets)
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(daySounds{k,COUNT},'omitnan')/sqrt(length(daySounds{k,COUNT}));  
    ts = tinv([0.025  0.975],length(daySounds{k,COUNT})-1);  
    CIdayNoise{COUNT}(k,:) = mean(daySounds{k,COUNT},'all','omitnan') + ts*SEM; 
end
end

%Day Detection Confidence Intervals
for COUNT = 1:length(dayDets)
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(dayDets{k,COUNT},'omitnan')/sqrt(length(dayDets{k,COUNT}));  
    ts = tinv([0.025  0.975],length(dayDets{k,COUNT})-1);  
    CIdayDets{COUNT}(k,:)  = (mean(dayDets{k,COUNT},'all','omitnan') + ts*SEM); 
end
end

%Day Winds Confidence Intervals
for COUNT = 1:length(dayDets)
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(dayWinds{k,COUNT},'omitnan')/sqrt(length(dayWinds{k,COUNT}));  
    ts = tinv([0.025  0.975],length(dayWinds{k,COUNT})-1);  
    CIdayWinds{COUNT}(k,:)  = (mean(dayWinds{k,COUNT},'all','omitnan') + ts*SEM); 
end
end

%Night Noise Confidence Intervals
for COUNT = 1:length(dayDets)
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(nightSounds{k,COUNT},'omitnan')/sqrt(length(nightSounds{k,COUNT}));  
    ts = tinv([0.025  0.975],length(nightSounds{k,COUNT})-1);  
    CInightNoise{COUNT}(k,:) = mean(nightSounds{k,COUNT},'all','omitnan') + ts*SEM; 
end
end

%Day Stratification Confidence Intervals
for COUNT = 1:length(dayDets)
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(dayStrat{k,COUNT},'omitnan')/sqrt(length(dayStrat{k,COUNT}));  
    ts = tinv([0.025  0.975],length(dayStrat{k,COUNT})-1);  
    CIdayStrat{COUNT}(k,:)  = (mean(dayStrat{k,COUNT},'all','omitnan') + ts*SEM); 
end
end


%Night Stratification Confidence Intervals
for COUNT = 1:length(dayDets)
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(nightStrat{k,COUNT},'omitnan')/sqrt(length(nightStrat{k,COUNT}));  
    ts = tinv([0.025  0.975],length(nightStrat{k,COUNT})-1);  
    CInightStrat{COUNT}(k,:)  = mean(nightStrat{k,COUNT},'all','omitnan') + ts*SEM; 
end
end



%Night Detection Confidence Intervals
for COUNT = 1:length(dayDets)
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(nightDets{k,COUNT},'omitnan')/sqrt(length(nightDets{k,COUNT}));  
    ts = tinv([0.025  0.975],length(nightDets{k,COUNT})-1);  
    CInightDets{COUNT}(k,:)  = (mean(nightDets{k,COUNT},'all','omitnan') + ts*SEM); 
end
end

%Night Winds Confidence Intervals
for COUNT = 1:length(dayDets)
for k = 1:length(seasons)
    %Finding standard deviations/CIs of values
    SEM = std(nightWinds{k,COUNT},'omitnan')/sqrt(length(nightWinds{k,COUNT}));  
    ts = tinv([0.025  0.975],length(nightWinds{k,COUNT})-1);  
    CInightWinds{COUNT}(k,:)  = (mean(nightWinds{k,COUNT},'all','omitnan') + ts*SEM); 
end
end




%%

for COUNT = 1:length(receiverData)
figure()
hold on
ciplot(CInightNoise{COUNT}(:,1),CInightNoise{COUNT}(:,2),1:5,'b')
ciplot(CIdayNoise{COUNT}(:,1),CIdayNoise{COUNT}(:,2),1:5,'r')
xlabel('Seasons, 2020')
ylabel('Average Noise (mV)')
title('Average Noise By Time of Day and Season','95% Conf. Interval, 69 kHz')
legend('Night','Day')
ylim([480 800])
end


%%

for COUNT = 1:length(receiverData)
figure()
hold
tiledlayout(1,3,'TileSpacing','compact')
nexttile
hold on
ciplot(CInightNoise{COUNT}(:,1),CInightNoise{COUNT}(:,2),1:5,'b')
ciplot(CIdayNoise{COUNT}(:,1),CIdayNoise{COUNT}(:,2),1:5,'r')
ylabel('Noise (69 kHz)')
title('High-Freq. Noise Averages','95% CI')
legend('Night','Day')
ylim([400 800])
xticks([1,2,3,4,5])
xticklabels({'Winter','Spring','Summer','Fall','M.Fall'})

nexttile()
hold on
ciplot(CInightDets{COUNT}(:,1),CInightDets{COUNT}(:,2),1:5,'b',0.5)
ciplot(CIdayDets{COUNT}(:,1),CIdayDets{COUNT}(:,2),1:5,'r',0.5)
ylabel('Avg. Hourly Detection')
title('Detection Averages', '95% CI')
xticks([1,2,3,4,5])
% ylim([0 10])
xticklabels({'Winter','Spring','Summer','Fall','M.Fall'})

% nexttile()
% hold on
% ciplot(CInightWinds{COUNT}(:,1),CInightWinds{COUNT}(:,2),1:5,'b',0.5)
% ciplot(CIdayWinds{COUNT}(:,1),CIdayWinds{COUNT}(:,2),1:5,'r',0.5)
% ylabel('Windspeed (m/s)')
% title('Wind Differences', '95% CI')
% xticks([1,2,3,4,5])
% ylim([0 10])
% xticklabels({'Winter','Spring','Summer','Fall','M.Fall'})

nexttile()
hold on
ciplot(CInightStrat{COUNT}(:,1),CInightStrat{COUNT}(:,2),1:5,'b',0.5)
ciplot(CIdayStrat{COUNT}(:,1),CIdayStrat{COUNT}(:,2),1:5,'r',0.5)
ylabel('Stratification (C)')
title('Thermal Strat.', '95% CI')
xticks([1,2,3,4,5])
ylim([0 2])
xticklabels({'Winter','Spring','Summer','Fall','M.Fall'})
end

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



