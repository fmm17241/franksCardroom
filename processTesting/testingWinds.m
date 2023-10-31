%%FM process testing
%First run 
% %arrayCaseStudy
% %createWindSpeedBins

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




