%%FM process testing
%First run 
% %arrayCaseStudy
% %createWindSpeedBins

%FRANK using just the transceivers. Stations, not paths for this data
fullData = {fullData{1},fullData{2},fullData{3},fullData{6}}
windSpeedScenario= {windSpeedScenario{1},windSpeedScenario{2},windSpeedScenario{3},windSpeedScenario{6}};
tiltCompareWind  = {tiltCompareWind{1},tiltCompareWind{2},tiltCompareWind{3},tiltCompareWind{6}};
normalizedWSpeed = {normalizedWSpeed{1},normalizedWSpeed{2},normalizedWSpeed{3},normalizedWSpeed{6}};
%FS6, SURT05, STSNew2, 39IN

%%
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:length(windSpeedScenario{COUNT}{season})
            usedPings = (windSpeedScenario{COUNT}{season}{k}.TotalDets)*8;
            removeFull{COUNT,season} = windSpeedScenario{COUNT}{season}{k}.pings - usedPings;
            ratio{COUNT,season}{k}      = usedPings./windSpeedScenario{COUNT}{season}{k}.pings;
            averageRatio{COUNT,season}(k) = mean(ratio{COUNT,season}{k})
        end
    end
end

X = 1:2:13;
seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}];
color = ['r','g','k','b','m'];
test = ones(7,1);




for COUNT = 1:length(fullData)
    figure()
    hold on
    for season = 1:length(seasons)
        useThis = (normalizedWSpeed{COUNT}{season}+ 0.000001)*100;
        scatter3(X,tiltCompareWind{COUNT}{season},test,useThis,color(season),'filled')
    end
%     if COUNT ==2
        legend('Winter','Spring','Summer','Fall','M.Fall')
%     end
    ylabel('Tilt (deg)')
    ylim([6 16.5])
    xlabel('Windspeed (m/s)')
    title(sprintf('Tilting Affecting Efficiency %d',COUNT))
end



for k = 1:length(fullData)
    figure
    hold on
    for season = 1:length(seasons)
        plot(X,averageRatio{k,season},color(season),'lineWidth',3)
    end
    title(sprintf('Ratio of Ping Usage, %d',k))
    ylim([0.6 1])
    ylabel('Ping Ratio')
    xlabel('WindSpeed (m/s)')
    if k ==2
        legend('Winter','Spring','Summer','Fall','M.Fall')
    end
end


figure()
hold on
for k = 1:length(fullData)
    plot(X,averageRatio{k,1},color(k))
end
ylim([0.65 1])
title('Winter Ratios')
xlabel('Windspeed (m/s)')
ylabel('Ratio (goodPings/TotalPings)')

figure()
hold on
for k = 1:length(fullData)
    plot(X,averageRatio{k,2})
end
ylim([0.65 1])
title('Spring Ratios')
xlabel('Windspeed (m/s)')
ylabel('Ratio (goodPings/TotalPings)')
figure()
hold on
for k = 1:length(fullData)
    plot(X,averageRatio{k,3})
end
title('Summer Ratios')
xlabel('Windspeed (m/s)')
ylabel('Ratio (goodPings/TotalPings)')
figure()
hold on
for k = 1:length(fullData)
    plot(X,averageRatio{k,4})
end
ylim([0.65 1])
title('Fall Ratios')
xlabel('Windspeed (m/s)')
ylabel('Ratio (goodPings/TotalPings)')
figure()
hold on
for k = 1:length(fullData)
    plot(X,averageRatio{k,5})
end
ylim([0.65 1])
title('M.Fall Ratios')
xlabel('Windspeed (m/s)')
ylabel('Ratio (goodPings/TotalPings)')





%%

test = ones(7,1);

X = 1:2:13;

seasonName = [{'Winter','Spring','Summer','Fall','Mariner''s Fall','Fall'}]
color = ['r','r','g','g','k','k','b','b','m','m'];

for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(fullData)
       useThis = (averageWindSpeed{COUNT}{season} + .000000001)*300;
        scatter3(X,tiltCompareWind{COUNT}{season},test,useThis,color(COUNT),'filled')

    end
    xlabel('Windspeed (m/s)')
    ylim([5 16.5])
    ylabel('Instrument Tilt (deg)')
    title(sprintf('Bottom Currents from Wind, %s',seasonName{season}))
end


for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(fullData)
       useThis = (averageWindSpeed{COUNT}{season} + .000000001)*100;
        scatter3(X,stratCompareWind{COUNT}{season},test,useThis,color(COUNT),'filled')

    end
    xlabel('Windspeed (m/s)')
    ylim([0 2])
    ylabel('Bulk Thermal Strat (C)')
    title(sprintf('Wind Breaking down Stratification, %s',seasonName{season}),'Marker Size = Det. Efficiency')
end

for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(fullData)
       useThis = (averageWindSpeed{COUNT}{season} + .000000001)*100;
        scatter(stratCompareWind{COUNT}{season},averageWindSpeed{COUNT}{season},color(COUNT),'filled')
    end
    ylabel('Detection Efficiency')
    ylim([0 2])
    xlabel('Bulk Stratification (C)')
    title(sprintf('Stratification Affecting Efficiency %s',seasonName{season}),'Marker Size = Det. Efficiency')
end

for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(fullData)
        scatter(X,averageWindSpeed{COUNT}{season}/6*100,color(COUNT),'filled')
    end
    ylabel('Detection Efficiency')
    ylim([0 70])
    xlabel('Windspeed (m/s)')
    title(sprintf('Winds Affecting Efficiency %s',seasonName{season}))
end




