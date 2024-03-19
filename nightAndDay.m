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

        dayPings{k,COUNT}      = mean(dayHours{k,COUNT}.Pings);
        nightPings{k,COUNT}    = mean(nightHours{k,COUNT}.Pings);

        dayStrat{k,COUNT} = mean(dayHours{k,COUNT}.bulkThermalStrat);
        nightStrat{k,COUNT} = mean(nightHours{k,COUNT}.bulkThermalStrat);
    end
end

test = dayDets(1,:);

maxLength = max(cellfun(@numel, test))
paddedMatrix = cellfun(@(x) padcat(x, NaN(maxLength-length(x),1)), test, 'UniformOutput', false);
numericMatrix = cell2mat(paddedMatrix);
columnAverages = nanmean(numericMatrix);



for k = 1:length(seasons)
    maxNumCol = max(cellfun(@(r) size(r,1), dayDets(k,:)))
    aMat{k} = cell2mat(cellfun(@(r){padarray(r,[0,maxNumCol-size(r,2)],NaN,'Post')}, dayDets(k,:)'))
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


for COUNT=1:length(receiverData)
    sumD(COUNT) = sum(receiverData{COUNT}.HourlyDets);
end
