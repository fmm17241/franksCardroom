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
xlabel('Tidal Magnitude (m/s)')
ylabel('HF Bottom Noise (mV)')
title('Tidal Current''s Effect on HF Noise, 95%CI','6/7 is the only Transceiver on Sandy Bottom')


%%
tiltCompareTideAnnual{COUNT}(k) = mean(tideScenarioAnnual{COUNT}{1,k}.tilt);



