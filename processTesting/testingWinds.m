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
    ylim([5 18])
    ylabel('Instrument Tilt (deg)')
    title(sprintf('Bottom Currents from Wind, %s',seasonName{season}))
end

