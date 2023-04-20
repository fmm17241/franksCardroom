
%FM 4/20


%
weakWindBin = cell(1,length(fullData));
strongWindBin = cell(1,length(fullData));
for COUNT= 1:length(fullData)
    for season = 1:length(seasons)
        %Tides cross-shore and weak winds
        weakWindBin{COUNT}(season,:) =   fullData{COUNT}.windSpeed   < 5  & fullData{COUNT}.season ==season;
        mediumWindBin{COUNT}(season,:) = fullData{COUNT}.windSpeed   > 5 & fullData{COUNT}.windSpeed < 10 & fullData{COUNT}.season ==season;
        strongWindBin{COUNT}(season,:) = fullData{COUNT}.windSpeed   > 10 & fullData{COUNT}.season ==season;
    end
end


%Use the indices above and average
% weakWindScenario= cell(1,length(fullData));
% strongWindScenario= cell(1,length(fullData));
% averagedWeak   = zeros(length(fullData),:);
% averagedStrong =zeros(length(fullData,:));
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
            weakWindScenario{COUNT}{season,:}    = fullData{1,COUNT}(weakWindBin{1,COUNT}(season,:),:);
            mediumWindScenario{COUNT}{season,:}    = fullData{1,COUNT}(mediumWindBin{1,COUNT}(season,:),:);
            strongWindScenario{COUNT}{season,:}  = fullData{1,COUNT}(strongWindBin{1,COUNT}(season,:),:);
            %Average of values from those bins
            averagedWeak{COUNT}(season,1) = nanmean(weakWindScenario{COUNT}{season,:}.detections);
            averagedMedium{COUNT}(season,1) = nanmean(mediumWindScenario{COUNT}{season,:}.detections);
            averagedStrong{COUNT}(season,1) = nanmean(strongWindScenario{COUNT}{season,:}.detections);
%             if isnan(averagedWeak{COUNT}(season,:))
%                 averagedWeak{COUNT}(season,:) = 0;
%             end
%             if isnan(averagedStrong{COUNT}(season,:))
%                 averagedStrong{COUNT}(season,k) = 0;
%             end
    end
    allWeak(COUNT,:) = averagedWeak{COUNT};
    allMedium(COUNT,:) = averagedMedium{COUNT};
    allStrong(COUNT,:) = averagedStrong{COUNT};
end


%Averages of each season, uses all 10 transmission directions
annualWeak    = mean(allWeak,1);
annualMedium  = mean(allMedium,1);
annualStrong  = mean(allStrong,1);

%Turns above into a percentage, out of 6 how many heard avg.
annualWeakPercent    = 100*(annualWeak/6);
annualMediumPercent  = 100*(annualMedium/6);
annualStrongPercent  = 100*(annualStrong/6);

percentDiff(:,1) = annualStrongPercent-annualWeakPercent;



% Finding errorbars for weak wind scenarios
for COUNT = 1:length(weakWindScenario)
    for season = 1:length(seasons)
        errorWeakWind(COUNT,season) = std(weakWindScenario{COUNT}{season,1}.detections)  
        errorMediumWind(COUNT,season) = std(mediumWindScenario{COUNT}{season,1}.detections) 
        errorStrongWind(COUNT,season) = std(strongWindScenario{COUNT}{season,1}.detections)
    end
end

consolidateErrorStrong  = std(errorStrongWind,1);
consolidateErrorMedium  = std(errorMediumWind,1);
consolidateErrorWeak    = std(errorWeakWind,1);



X = 1:5;

figure()
hold on
scatter(X,annualWeak,'r','filled')
scatter(X,annualMedium,'g','filled')
scatter(X,annualStrong,'b','filled')
errorbar(X,annualWeak,consolidateErrorWeak,'r',"LineStyle","none")
errorbar(X,annualMedium,consolidateErrorMedium,'g',"LineStyle","none")
errorbar(X,annualStrong,consolidateErrorStrong,'b',"LineStyle","none")
xlim([0.6 5.2])
yline(3,'label','50% efficiency')
ylim([0 3.5])
xlabel('Season')
ylabel('Avg. Detections')
title('Seasonal Wind Effects')
legend('Weak, <5m/s','Medium, b/w','Strong, >10m/s')

figure()
hold on
scatter(X,annualWeak,'r','filled')
% scatter(X,annualMedium,'g','filled')
scatter(X,annualStrong,'b','filled')
errorbar(X,annualWeak,consolidateErrorWeak,'r',"LineStyle","none")
% errorbar(X,annualMedium,consolidateErrorMedium,'g',"LineStyle","none")
errorbar(X,annualStrong,consolidateErrorStrong,'b',"LineStyle","none")
xlim([0.6 5.2])
yline(3,'label','50% efficiency')
ylim([0 3.25])
xlabel('Season')
ylabel('Avg. Detections')
title('Seasonal Wind Effects')
% legend('Weak, <5m/s','Medium, b/w','Strong, >10m/s')
legend('Weak, <5m/s','Strong, >10m/s')



figure()
hold on
scatter(X,annualWeakPercent,'r','filled')
scatter(X,annualStrongPercent,'b','filled')

figure()
plot(X,percentDiff);
hold on
scatter(X,percentDiff,'filled');
xlim([0.6 5.2])
xlabel('Seasons')
ylabel('Additional % Efficiency')
title('Detection Efficiency Gained','When Wind goes from < 5 to > 10')

