%FM run freshTest first, then this:


%Frank manually making season bins for the 4 transceivers
%SURT05
winter{1}     = [16:2063, 7944:9188]';
spring{1}     = [ 2064:4271]';
summer{1}  = [4272:5735]';
fall{1}          = [5736:6479]';
mFall{1}      = [6480:7943]';

%STSnew2
winter{2}     = [24:2405, 8286:9253]';
spring{2}     = [2406:4613]';
summer{2}  = [4614:6077]';
fall{2}          = [6078:6821]';
mFall{2}      = [6822:8285]';

%FS6
winter{3}    = [17:2061, 7942:9208]';
spring{3}    = [2062:4269]';
summer{3} = [4270:5733]';
fall{3}         = [5734:6477]';
mFall{3}     = [6478:7941]';

%39IN
winter{4}    = [14:2397, 8278:9373]';
spring{4}    = [2398:4605]';
summer{4} = [4606:6069]';
fall{4}         = [6070:6813]';
mFall{4}     = [6814:8277]';

% 
for COUNT = 1:4
    seasonCounter{COUNT} = zeros(1,length(receiverTimes{COUNT}));
    seasonCounter{COUNT}(winter{COUNT}) = 1; seasonCounter{COUNT}(spring{COUNT}) = 2; seasonCounter{COUNT}(summer{COUNT}) = 3; seasonCounter{COUNT}(fall{COUNT}) = 4; seasonCounter{COUNT}(mFall{COUNT}) = 5;
    receiverData{COUNT}.season = seasonCounter{COUNT}';
end


%%
for COUNT = 1:4
    singleData{COUNT,1} =table(receiverTimes{COUNT},receiverData{COUNT}.season, receiverData{COUNT}.hourlyDets(:,2), receiverData{COUNT}.avgNoise(:,2), receiverData{COUNT}.pings(:,2),receiverData{COUNT}.tilt(:,2),receiverData{COUNT}.bottomTemp(:,2),receiverData{COUNT}.windSpd(:,2),receiverData{COUNT}.windDir(:,2));         
    singleData{COUNT,1}.Properties.VariableNames = {'Time','Season','HourlyDets','Noise','Pings','Tilt','Temp','WindSpd','WindDir'};
end

%Removing timing of testing: first bits are clearly in air.
singleData{1} = singleData{1}(16:end,:)
singleData{2} = singleData{1}(24:end,:)
singleData{3} = singleData{1}(17:end,:)
singleData{4} = singleData{1}(14:end,:)

seasonName = [{'Winter'},{'Spring'},{'Summer'},{'Fall'},{'M. Fall'}];
%%

%Full season windbreakdown
for season = 1:length(seasonName)
    windSpeedBins{season,1} = singleData{1}.WindSpd < 2 & singleData{1}.Season ==season;
    windSpeedBins{season,2} = singleData{1}.WindSpd > 2 & singleData{1}.WindSpd < 4 & singleData{1}.Season ==season;
    windSpeedBins{season,3} = singleData{1}.WindSpd > 4 & singleData{1}.WindSpd < 6 & singleData{1}.Season ==season;
    windSpeedBins{season,4} = singleData{1}.WindSpd > 6 & singleData{1}.WindSpd < 8 & singleData{1}.Season ==season;
    windSpeedBins{season,5} = singleData{1}.WindSpd > 8 & singleData{1}.WindSpd < 10 & singleData{1}.Season ==season;
    windSpeedBins{season,6} = singleData{1}.WindSpd > 10 & singleData{1}.WindSpd < 12 & singleData{1}.Season ==season;
    windSpeedBins{season,7} = singleData{1}.WindSpd > 12  & singleData{1}.Season ==season;
end


%Trying to adjust
for season = 1:height(windSpeedBins)
    for k = 1:length(windSpeedBins)
        windSpeedScenario{season,k}= singleData{1}(windSpeedBins{season,k},:);
        averageWindSpeed{COUNT}{season}(1,k) = mean(windSpeedScenario{season,k}.HourlyDets);
        noiseCompare{COUNT}{season}(k) = mean(windSpeedScenario{season,k}.Noise);
        tiltCompareWind{COUNT}{season}(k) = mean(windSpeedScenario{season,k}.Tilt);
        % stratCompareWind{COUNT}{season}(k) = mean(windSpeedScenario{season,k}.stratification)
    end
    % normalizedWSpeed{season,k}  = averageWindSpeed{COUNT}{season}/(max(averageWindSpeed{COUNT}{season}));
end

sgvfgsdfgsfdg
Frank come back here and make this; this will help compare the one transceiver's measures


        averageWindSpeed{COUNT}{season}(1,k) = mean(windSpeedScenario{COUNT}{season}{1,k}.detections);
        noiseCompare{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.noise);
        wavesCompare{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.waveHeight);
        tiltCompareWind{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.tilt);
        stratCompareWind{COUNT}{season}(k) = mean(windSpeedScenario{COUNT}{season}{1,k}.stratification)
    end
    normalizedWSpeed{COUNT}{season}  = averageWindSpeed{COUNT}{season}/(max(averageWindSpeed{COUNT}{season}));
end
%%
%Winds for the first transceiver




seasonName = [{'Winter'},{'Spring'},{'Summer'},{'Fall'},{'M. Fall'}];



%Plots relationship between noise and dets for every season + transceiver
for COUNT = 1
    for season = 1:length(seasonName)
        figure()
        hold on
        scatter(seasonScenario{COUNT,season}.Noise,seasonScenario{COUNT,season}.HourlyDets);
        title(sprintf('Noise vs Dets, %s',seasonName{season}),sprintf('Transceiver %d', COUNT))
        xlabel('Noise (mV)')
        ylabel('Hourly Dets')
        xlim([200 800])
        ylim([5 90])
    end
end

for COUNT = 2:length(winter)
    for season = 1:length(seasonName)
        figure()
        hold on
        scatter(seasonScenario{COUNT,season}.Noise,seasonScenario{COUNT,season}.HourlyDets);
        title(sprintf('Noise vs Dets, %s',seasonName{season}),sprintf('Transceiver %d', COUNT))
        xlabel('Noise (mV)')
        ylabel('Hourly Dets')
        xlim([200 800])
        ylim([5 25])
    end
end

%%
% WIND VS DETS
for COUNT = 1
    for season = 1:length(seasonName)
        figure()
        hold on
        yyaxis left
        scatter(seasonScenario{COUNT,season}.WindSpd,seasonScenario{COUNT,season}.HourlyDets);
        title(sprintf('Windspeed vs Dets, %s',seasonName{season}),sprintf('Transceiver %d', COUNT))
        xlabel('Windspeed (m/s)')
        ylabel('Hourly Dets')
        xlim([2 14])
        ylim([5 90])
        yyaxis right
        scatter(seasonScenario{COUNT,season}.WindSpd,seasonScenario{COUNT,season}.Tilt)
        ylim([2 30])
    end
end

for COUNT = 2:length(winter)
    for season = 1:length(seasonName)
        figure()
        hold on
        scatter(seasonScenario{COUNT,season}.WindSpd,seasonScenario{COUNT,season}.HourlyDets);
        title(sprintf('Windspeed vs Dets, %s',seasonName{season}),sprintf('Transceiver %d', COUNT))
        xlabel('Noise (mV)')
        ylabel('Hourly Dets')
        xlim([2 14])
        ylim([5 25])
        yyaxis right
        scatter(seasonScenario{COUNT,season}.WindSpd,seasonScenario{COUNT,season}.Tilt)
        ylim([2 30])
    end
end
%%






figure()
hold on
scatter(seasonScenario{1,5}.WindSpd, seasonScenario{1,5}.Pings);
title('fall')
xlabel('WindSpd (m/s)')
ylabel('Hourly PINGS')



figure()
hold on
scatter(seasonScenario{1,1}.tilt, seasonScenario{1,1}.pings);
title('Winter')
xlabel('Tilt (deg)')
ylabel('Hourly Dets')

figure()
hold on
scatter(seasonScenario{1,1}.noise, seasonScenario{1,1}.pings);
title('Winter')
xlabel('Noise (mV)')
ylabel('Hourly PINGS')








%     detectionTable{k} = table(useTime{1,k},detections{1,k}); 
%     detectionTable{k}.Properties.VariableNames = {'time','detections'};
%     detectionTable{k} = table2timetable(detectionTable{k});


load mooredGPS


%%
%Frank created receiverData{X}.ratio, now how can I show committee what I'm
%talking about?

figure()
hold on
% yyaxis left
plot(receiverTimes{1},receiverData{1}.ratio(:,2),'LineWidth',2);
ylabel('Ratio')
ylim([0.5 1])
yyaxis right
plot(receiverTimes{1},receiverData{1}.avgNoise(:,2),'LineWidth',2);
ylabel('Noise (mV)')
ylim([400 800])
title('Comparing Efficiency to Noise','Ratio = Used pings (dets*8)/Total Collected Pings')


figure()
hold on
yyaxis left
plot(receiverTimes{2},receiverData{2}.hourlyDets(:,2),'LineWidth',2);
ylabel('Hourly Dets')
ylim([6 15])
yyaxis right
plot(receiverTimes{2},receiverData{2}.avgNoise(:,2),'LineWidth',2);
ylabel('Noise (mV)')
ylim([400 800])
title('Comparing Efficiency to Noise','')

figure()
hold on
yyaxis left
plot(receiverTimes{2},receiverData{2}.pings(:,2),'LineWidth',2);
ylabel('Total Pings')
% ylim([6 15])
yyaxis right
plot(receiverTimes{2},receiverData{2}.avgNoise(:,2),'LineWidth',2);
ylabel('Noise (mV)')
ylim([400 800])
title('Comparing Abiotic Noise to Total Noise','')

