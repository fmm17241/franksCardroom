%FM

%Attempting to isolate the cause of the detection efficiency changes in
%relation to the tide.



%binnedAVG OR arrayCaseStudy
%createTideBins

%Finding 95CI for noise compared to tides

clear errorDataAnnual

for COUNT = 1:length(fullData)
    for k = 1:height(tideBinsAnnual{COUNT})
        if isempty(tideScenarioAnnual{COUNT}{1,k}) == 1
            errorDataAnnual{COUNT}(1:2,k) = NaN;
            continue
        end
        SEM = std(tideScenarioAnnual{COUNT}{k}.noise)/sqrt(length(tideScenarioAnnual{COUNT}{k}.noise));               % Standard Error
        ts = tinv([0.025  0.975],length(tideScenarioAnnual{COUNT}{k}.noise)-1);      % T-Score
        errorDataAnnual{COUNT}(:,k) = mean(tideScenarioAnnual{COUNT}{k}.noise) + ts*SEM;        
%         errorDataAnnual{COUNT}(k) = std(tideScenarioAnnual{COUNT}{1,k}.detections)
    end
end


x = -.4:.05:.4;
seasonNames = {'Winter','Spring','Summer','Fall','Mariner''s Fall'}

figure()
for COUNT = 1:length(allStrat)
    labelz = num2str(sprintf('%d',COUNT))
    hold on
    h = plot(x,noiseCompareTideAnnual{COUNT})
    scatter(x,noiseCompareTideAnnual{COUNT})

    keepIndex = ~isnan(errorDataAnnual{COUNT});
    X = x(keepIndex(1,:));
    yBot = errorDataAnnual{COUNT}(1,keepIndex(1,:));
    yTop = errorDataAnnual{COUNT}(2,keepIndex(1,:));

    patch([X, fliplr(X)], [yBot fliplr(yTop)], 'b', 'EdgeColor','none', 'FaceAlpha',0.25)
%     patch([X, fliplr(x)], [errorDataAnnual{COUNT}(1,:) fliplr(errorDataAnnual{COUNT}(2,:))], 'b', 'EdgeColor','none', 'FaceAlpha',0.25)
    label(h,sprintf('%s',labelz))
end
hold off
xlabel('Parallel Tidal Magnitude (m/s)')
ylabel('HF Bottom Noise (mV)')
title('Tidal Current''s Effect on HF Noise, 95%CI','6/7 is the only Transceiver on Sandy Bottom')


%%
clear errorDataAnnual

for COUNT = 1:length(fullData)
    for k = 1:height(tideBinsAnnual{COUNT})
        if isempty(tideScenarioAnnual{COUNT}{1,k}) == 1
            errorDataAnnual{COUNT}(1:2,k) = NaN;
            continue
        end
        SEM = std(tideScenarioAnnual{COUNT}{k}.tilt)/sqrt(length(tideScenarioAnnual{COUNT}{k}.tilt));               % Standard Error
        ts = tinv([0.025  0.975],length(tideScenarioAnnual{COUNT}{k}.tilt)-1);      % T-Score
        errorDataAnnual{COUNT}(:,k) = mean(tideScenarioAnnual{COUNT}{k}.tilt) + ts*SEM;        
%         errorDataAnnual{COUNT}(k) = std(tideScenarioAnnual{COUNT}{1,k}.detections)
    end
end
%%


x = -.4:.05:.4;
seasonNames = {'Winter','Spring','Summer','Fall','Mariner''s Fall'}

figure()
for COUNT = 1:length(allStrat)
    labelz = num2str(sprintf('%d',COUNT))
    hold on
    h = plot(x,tiltCompareTideAnnual{COUNT})
    scatter(x,tiltCompareTideAnnual{COUNT})

    keepIndex = ~isnan(errorDataAnnual{COUNT});
    X = x(keepIndex(1,:));
    yBot = errorDataAnnual{COUNT}(1,keepIndex(1,:));
    yTop = errorDataAnnual{COUNT}(2,keepIndex(1,:));
    if ismember(COUNT,[6 7])
        patch([X, fliplr(X)], [yBot fliplr(yTop)], 'r', 'EdgeColor','none', 'FaceAlpha',0.25)
        label(h,sprintf('%s',labelz))
        continue
    end
    patch([X, fliplr(X)], [yBot fliplr(yTop)], 'b', 'EdgeColor','none', 'FaceAlpha',0.25)
%     patch([X, fliplr(x)], [errorDataAnnual{COUNT}(1,:) fliplr(errorDataAnnual{COUNT}(2,:))], 'b', 'EdgeColor','none', 'FaceAlpha',0.25)
    label(h,sprintf('%s',labelz))
end
hold off
xlabel('Parallel Tidal Magnitude (m/s)')
ylabel('Tilt (degs)')
title('Tidal Current''s Effect on Instrument Tilt, 95%CI','6/7 is the only Transceiver on Sandy Bottom')


%%
% stratCompareTideAnnual

clear errorDataAnnual

for COUNT = 1:length(fullData)
    for k = 1:height(tideBinsAnnual{COUNT})
        if isempty(tideScenarioAnnual{COUNT}{1,k}) == 1
            errorDataAnnual{COUNT}(1:2,k) = NaN;
            continue
        end
        SEM = std(tideScenarioAnnual{COUNT}{k}.stratification)/sqrt(length(tideScenarioAnnual{COUNT}{k}.stratification));               % Standard Error
        ts = tinv([0.025  0.975],length(tideScenarioAnnual{COUNT}{k}.stratification)-1);      % T-Score
        errorDataAnnual{COUNT}(:,k) = mean(tideScenarioAnnual{COUNT}{k}.stratification) + ts*SEM;        
%         errorDataAnnual{COUNT}(k) = std(tideScenarioAnnual{COUNT}{1,k}.detections)
    end
end


x = -.4:.05:.4;
seasonNames = {'Winter','Spring','Summer','Fall','Mariner''s Fall'}

figure()
for COUNT = 1:length(allStrat)
    labelz = num2str(sprintf('%d',COUNT))
    hold on
    h = plot(x,stratCompareTideAnnual{COUNT})
    scatter(x,stratCompareTideAnnual{COUNT})

    keepIndex = ~isnan(errorDataAnnual{COUNT});
    X = x(keepIndex(1,:));
    yBot = errorDataAnnual{COUNT}(1,keepIndex(1,:));
    yTop = errorDataAnnual{COUNT}(2,keepIndex(1,:));

%     patch([X, fliplr(X)], [yBot fliplr(yTop)], 'b', 'EdgeColor','none', 'FaceAlpha',0.25)
%     patch([X, fliplr(x)], [errorDataAnnual{COUNT}(1,:) fliplr(errorDataAnnual{COUNT}(2,:))], 'b', 'EdgeColor','none', 'FaceAlpha',0.25)
    label(h,sprintf('%s',labelz))
end
hold off
xlabel('Parallel Tidal Magnitude (m/s)')
ylabel('Thermal Stratification (C)')
title('Tidal Current''s Effect on Thermal Strat, 95%CI','')

