
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
%         strongWindBin{COUNT}(season,:) = fullData{COUNT}.windSpeed   > 10 & fullData{COUNT}.windSpeed   < 12 &  fullData{COUNT}.season ==season;
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
        averagedWeakStrat{COUNT}(season,1) = nanmean(weakWindScenario{COUNT}{season,:}.stratification);
        averagedMediumStrat{COUNT}(season,1) = nanmean(mediumWindScenario{COUNT}{season,:}.stratification);
        averagedStrongStrat{COUNT}(season,1) = nanmean(strongWindScenario{COUNT}{season,:}.stratification);
        averagedWeakNoise{COUNT}(season,1) = nanmean(weakWindScenario{COUNT}{season,:}.noise);
        averagedMediumNoise{COUNT}(season,1) = nanmean(mediumWindScenario{COUNT}{season,:}.noise);
        averagedStrongNoise{COUNT}(season,1) = nanmean(strongWindScenario{COUNT}{season,:}.noise);
    end
    allWeak(COUNT,:) = averagedWeak{COUNT};
    allMedium(COUNT,:) = averagedMedium{COUNT};
    allStrong(COUNT,:) = averagedStrong{COUNT};
    allWeakStrat(COUNT,:) = averagedWeakStrat{COUNT};
    allMediumStrat(COUNT,:) = averagedMediumStrat{COUNT};
    allStrongStrat(COUNT,:) = averagedStrongStrat{COUNT};
    allWeakNoise(COUNT,:) = averagedWeakNoise{COUNT};
    allMediumNoise(COUNT,:) = averagedMediumNoise{COUNT};
    allStrongNoise(COUNT,:) = averagedStrongNoise{COUNT};
end


%Averages of each season, uses all 10 transmission directions
annualWeak    = mean(allWeak,1);
annualMedium  = mean(allMedium,1);
annualStrong  = mean(allStrong,1);
annualWeakStrat    = mean(allWeakStrat,1)';
annualMediumStrat  = mean(allMediumStrat,1);
annualStrongStrat  = mean(allStrongStrat,1)';

annualWeakNoise    = mean(allWeakNoise,1)';
annualMediumNoise  = mean(allMediumNoise,1);
annualStrongNoise  = mean(allStrongNoise,1)';



%Turns above into a percentage, out of 6 how many heard avg.
annualWeakPercent    = 100*(annualWeak/6);
annualMediumPercent  = 100*(annualMedium/6);
annualStrongPercent  = 100*(annualStrong/6);





percentDiff(:,1) = annualStrongPercent - annualWeakPercent
stratDiff(:,1)   = annualWeakStrat-annualStrongStrat
noiseDiff(:,1)   = annualWeakNoise-annualStrongNoise

stratDiffPercent= (stratDiff(:,1)./annualWeakStrat(:,1))*100
noiseDiffPercent = (noiseDiff(:,1)./annualWeakNoise(:,1))*100



% Finding errorbars for weak wind scenarios
for COUNT = 1:length(weakWindScenario)
    for season = 1:length(seasons)
        errorWeakWind(COUNT,season) = std(weakWindScenario{COUNT}{season,1}.detections)  
        errorMediumWind(COUNT,season) = std(mediumWindScenario{COUNT}{season,1}.detections) 
        errorStrongWind(COUNT,season) = std(strongWindScenario{COUNT}{season,1}.detections)
        errorWeakSound(COUNT,season)   =std(weakWindScenario{COUNT}{season,1}.noise)  
        errorStrongSound(COUNT,season) = std(strongWindScenario{COUNT}{season,1}.noise)  
    end
end

consolidateErrorStrong  = std(errorStrongWind,1);
consolidateErrorMedium  = std(errorMediumWind,1);
consolidateErrorWeak    = std(errorWeakWind,1);

consolidateErrorStrongNoise  = std(errorStrongSound,1);
consolidateErrorWeakNoise    = std(errorWeakSound,1);

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
title('Seasonal Wind Effects','Detection Efficiency')
% legend('Weak, <5m/s','Medium, b/w','Strong, >10m/s')
legend('Weak, <5m/s','Strong, >10m/s')

% Sound
figure()
hold on
scatter(X,annualWeakNoise,'r','filled')
% scatter(X,annualMedium,'g','filled')
scatter(X,annualStrongNoise,'b','filled')
errorbar(X,annualWeakNoise,consolidateErrorWeakNoise,'r',"LineStyle","none")
% errorbar(X,annualMedium,consolidateErrorMedium,'g',"LineStyle","none")
errorbar(X,annualStrongNoise,consolidateErrorStrongNoise,'b',"LineStyle","none")
xlim([0.6 5.2])
% yline(3,'label','50% efficiency')
% ylim([0 3.25])
xlabel('Season')
ylabel('Ambient Noise (mV)')
title('Seasonal Wind Effects','Ambient Sounds')
% legend('Weak, <5m/s','Medium, b/w','Strong, >10m/s')
legend('Weak, <5m/s','Strong, >10m/s')






figure()
hold on
scatter(X,annualWeakPercent,'r','filled')
scatter(X,annualStrongPercent,'b','filled')

figure()
yyaxis left
plot(X,percentDiff,'b','LineWidth',4);
hold on
scatter(X,percentDiff,50,'b','filled');
xlim([0.6 5.2])
xticks([1:5])
xlabel('Seasons')
ylabel('Additional % Efficiency')
yyaxis right
plot(X,annualWeakStrat,'k','LineWidth',3)
hold on
scatter(X,annualWeakStrat,'k','filled');
% plot(X,annualMediumStrat,'br')
plot(X,annualStrongStrat,'r','LineWidth',3)
scatter(X,annualStrongStrat,'r','filled')
ylabel('Avg. Thermal Stratification °C')
legend('Percent Diff.','','Strat.,LowWinds (<5 m/s) ','',' Strat., StrWinds (>10 m/s)')
title('Detection Efficiency Gained','When Wind goes from (<5) to (>10)')




figure()
yyaxis left
plot(X,percentDiff,'b','LineWidth',4);
xlabel('Seasons')
ylabel('Additional % Efficiency')
yyaxis right
plot(X,stratDiff,'r','LineWidth',4)
xlim([0.6 5.2])
xticks([1:5])
ylabel('Bulk Thermal Strat °C')
legend('Det Efficiency','Stratification')
title('Effects of Wind Magnitude','Difference between Averages: <5 and >10')

%
figure()
yyaxis left
plot(X,percentDiff,'b','LineWidth',4);
xlabel('Seasons')
ylabel('Additional % Efficiency')
yyaxis right
plot(X,noiseDiff,'r','LineWidth',4)
xlim([0.6 5.2])
xticks([1:5])
ylabel('Ambient Sounds, mV')
legend('Det Efficiency','Ambient Sounds')
title('Effects of Wind Magnitude','Difference between Averages: <5 and >10')



figure()
yyaxis left
scatter(X,percentDiff,200,'k','filled');
xlabel('Seasons')
ylabel('Additional % Efficiency')
yyaxis right
scatter(X,stratDiff,200,'r','filled')
xlim([0.6 5.2])
xticks([1:5])
ylabel('Bulk Thermal Strat °C')
legend('Det Efficiency','Stratification')
title('Effects of Wind Magnitude','Difference between Averages during <5 and >10 m/s winds')


figure()
yyaxis left
scatter(X,percentDiff,200,'k','filled');
xlabel('Seasons')
ylabel('Additional % Efficiency')
yyaxis right
scatter(X,noiseDiff,200,'r','filled')
xlim([0.6 5.2])
xticks([1:5])
ylabel('Ambient Noise, mV')
legend('Det Efficiency','Ambient Noise')
title('Effects of Wind Magnitude','Difference between Averages: <5 and >10 m/s')

%
figure()
yyaxis left
scatter(X,percentDiff,200,'b','filled');
hold on
plot(X,percentDiff,'b')
xlabel('Seasons')
ylabel('Additional % Efficiency')
yyaxis right
scatter(X,noiseDiffPercent,200,'r','filled')
hold on
plot(X,noiseDiffPercent)
scatter(X,stratDiffPercent,200,'k','filled')
plot(X,stratDiffPercent,'k')
ylabel('Percent Difference')
xlim([0.6 5.2])
xticks([1:5])
legend('Det Efficiency','','Noise Diff','','Strat. Diff.')
title('Increasing Wind''s Effect','Percent Change in: <5 and >10 m/s wind conditions')

%%
% Got the stratification now, how to visualize all 3?

errorstrongWind{COUNT}(season,k) = std(strongWindScenario{COUNT}{season,k}.detections)

X = 0:14;
Y = normalizedYearlyWind;
Z = yearlyNoise;



figure()
scatter(X,Y,250,Z,'filled')
a = colorbar
ylabel(a,'Stratification °C','FontSize',16);
ylabel('Normalized Det. Efficiency')
xlabel('Wind Magnitude, m/s')
title('Wind Magnitude''s Effects','Detection Efficiency & Thermal Bulk Strat')


figure()
scatter(X,Y,250,Z,'filled')
a = colorbar
ylabel(a,'Noise, mV','FontSize',16);
ylabel('Normalized Det. Efficiency')
xlabel('Wind Magnitude, m/s')
title('Wind Magnitude''s Effects','Detection Efficiency & Ambient Noise')







