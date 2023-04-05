%
%Binning by wind during strong and weak stratification periods


weakStratNumber   = 0.1;
strongStratNumber = 3;

weakStratBin = cell(1,length(fullData));
for COUNT= 1:length(fullData)
    for season = 1:length(seasons)
        %Tides cross-shore and weak winds
        weakStratBin{COUNT}{season}(1,:) =  fullData{COUNT}.windSpeed < 1  & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(2,:) =  fullData{COUNT}.windSpeed > 1  & fullData{COUNT}.windSpeed < 2 & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(3,:) =  fullData{COUNT}.windSpeed > 2.5 & fullData{COUNT}.windSpeed < 3 & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(4,:) =  fullData{COUNT}.windSpeed > 3 & fullData{COUNT}.windSpeed < 4 & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(5,:) =  fullData{COUNT}.windSpeed > 4 & fullData{COUNT}.windSpeed < 5  & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(6,:) =  fullData{COUNT}.windSpeed > 5  & fullData{COUNT}.windSpeed < 6  & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(7,:) =  fullData{COUNT}.windSpeed > 6  & fullData{COUNT}.windSpeed < 7  & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(8,:) =  fullData{COUNT}.windSpeed > 7  & fullData{COUNT}.windSpeed < 8  & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(9,:) =  fullData{COUNT}.windSpeed > 8 & fullData{COUNT}.windSpeed < 9 & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(10,:) =  fullData{COUNT}.windSpeed > 9 & fullData{COUNT}.windSpeed < 10 & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(11,:) =  fullData{COUNT}.windSpeed > 10 & fullData{COUNT}.windSpeed < 11  & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(12,:) =  fullData{COUNT}.windSpeed > 11  & fullData{COUNT}.windSpeed < 12  & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(13,:) =  fullData{COUNT}.windSpeed > 12  & fullData{COUNT}.windSpeed < 13  & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(14,:) =  fullData{COUNT}.windSpeed > 13  & fullData{COUNT}.windSpeed < 14  & fullData{COUNT}.stratification < weakStratNumber & fullData{COUNT}.season ==season;
        weakStratBin{COUNT}{season}(15,:) =  fullData{COUNT}.windSpeed > 14  & fullData{COUNT}.stratification  < weakStratNumber & fullData{COUNT}.season ==season;
    end
end


strongStratBin = cell(1,length(fullData));
for COUNT= 1:length(fullData)
    for season = 1:length(seasons)
        %Tides cross-shore and strong winds
        strongStratBin{COUNT}{season}(1,:) =  fullData{COUNT}.windSpeed < 1  & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(2,:) =  fullData{COUNT}.windSpeed > 1  & fullData{COUNT}.windSpeed < 2 & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(3,:) =  fullData{COUNT}.windSpeed > strongStratNumber & fullData{COUNT}.windSpeed < 3 & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(4,:) =  fullData{COUNT}.windSpeed > 3 & fullData{COUNT}.windSpeed < 4 & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(5,:) =  fullData{COUNT}.windSpeed > 4 & fullData{COUNT}.windSpeed < 5  & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(6,:) =  fullData{COUNT}.windSpeed > 5  & fullData{COUNT}.windSpeed < 6  & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(7,:) =  fullData{COUNT}.windSpeed > 6  & fullData{COUNT}.windSpeed < 7  & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(8,:) =  fullData{COUNT}.windSpeed > 7  & fullData{COUNT}.windSpeed < 8  & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(9,:) =  fullData{COUNT}.windSpeed > 8 & fullData{COUNT}.windSpeed < 9 & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(10,:) =  fullData{COUNT}.windSpeed > 9 & fullData{COUNT}.windSpeed < 10 & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(11,:) =  fullData{COUNT}.windSpeed > 10 & fullData{COUNT}.windSpeed < 11  & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(12,:) =  fullData{COUNT}.windSpeed > 11  & fullData{COUNT}.windSpeed < 12  & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(13,:) =  fullData{COUNT}.windSpeed > 12  & fullData{COUNT}.windSpeed < 13  & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(14,:) =  fullData{COUNT}.windSpeed > 13  & fullData{COUNT}.windSpeed < 14  & fullData{COUNT}.stratification > strongStratNumber & fullData{COUNT}.season ==season;
        strongStratBin{COUNT}{season}(15,:) =  fullData{COUNT}.windSpeed > 14  & fullData{COUNT}.stratification  > strongStratNumber & fullData{COUNT}.season ==season;
    end
end


for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(strongStratBin{COUNT}{season})
            weakStratScenario{COUNT}{season,k}    = fullData{1,COUNT}(weakStratBin{1,COUNT}{season}(k,:),:);
            strongStratScenario{COUNT}{season,k}  = fullData{1,COUNT}(strongStratBin{1,COUNT}{season}(k,:),:);
            %Average of values from those bins
            averagedWeak{COUNT}(season,k) = nanmean(weakStratScenario{COUNT}{season,k}.detections);
            averagedStrong{COUNT}(season,k) = nanmean(strongStratScenario{COUNT}{season,k}.detections);
            if isnan(averagedWeak{COUNT}(season,k))
                averagedWeak{COUNT}(season,k) = 0;
            end
            if isnan(averagedStrong{COUNT}(season,k))
                averagedStrong{COUNT}(season,k) = 0;
            end
        end
    end
end


for COUNT = 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter1 = [averagedStrong{COUNT}(season,:),averagedStrong{COUNT+1}(season,:)]
        comboPlatter2 = [averagedWeak{COUNT}(season,:),averagedWeak{COUNT+1}(season,:)]
        normalizedStrong{COUNT}(season,:)       = averagedStrong{COUNT}(season,:)/(max(comboPlatter1));
        normalizedStrong{COUNT+1}(season,:)     = averagedStrong{COUNT+1}(season,:)/(max(comboPlatter1));
        normalizedWeak{COUNT}(season,:)         = averagedWeak{COUNT}(season,:)/(max(comboPlatter2));
        normalizedWeak{COUNT+1}(season,:)       = averagedWeak{COUNT+1}(season,:)/(max(comboPlatter2));
    end
end

for COUNT = 1:length(normalizedStrong)
    completeNormalStrong(COUNT,:) = nanmean(normalizedStrong{COUNT},1);
    completeNormalWeak(COUNT,:)   = nanmean(normalizedWeak{COUNT},1);
    completeAVGstrong(COUNT, :) =   nanmean(averagedStrong{COUNT},1);
    completeAVGweak(COUNT, :)   =   nanmean(averagedWeak{COUNT},1);
end

%Whole year
yearlyNormalStrong = mean(completeNormalStrong,1);
yearlyNormalWeak = mean(completeNormalWeak,1);

yearlyAVGstrong = mean(completeAVGstrong,1);
yearlyAVGweak = mean(completeAVGweak,1);


x = 0:14;



figure()
scatter(x,yearlyAVGstrong,'r','filled')
hold on
scatter(x,yearlyAVGweak,'b','filled')
legend(sprintf('Strong Strat > %0.1d',strongStratNumber),sprintf('Weak Strat < %0.1d',round(weakStratNumber,2)))
title('Yearly Normalized Detections w/ Strong/Weak Stratification')
xlabel('WindSpeed')
ylabel('Normalized Detection Efficiency')



for COUNT = 1:height(completeAVGstrong)
    figure()
    hold on
    scatter(x,completeAVGstrong(COUNT,:),'r','filled')
    scatter(x,completeAVGweak(COUNT,:),'b','filled')
    ylabel('Avg Det Efficiency')
    xlabel('Tidal Velocity (m/s)')
    ylim([0 6])
    title(sprintf('Transceiver Pairing %d',COUNT))
    legend('Strong Strat','Weak Strat')
end



