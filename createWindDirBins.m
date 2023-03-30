
% %Tight
% for COUNT = 1:length(fullData)
%     for season = 1:length(seasons)
%         windDirBins{COUNT}{season}(1,:) = fullData{COUNT}.windDir < 10 & fullData{COUNT}.season == season;
%         windDirBins{COUNT}{season}(2,:) = fullData{COUNT}.windDir > 10 & fullData{COUNT}.windDir < 20 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(3,:) = fullData{COUNT}.windDir > 20 & fullData{COUNT}.windDir < 30 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(4,:) = fullData{COUNT}.windDir > 30 & fullData{COUNT}.windDir < 40 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(5,:) = fullData{COUNT}.windDir > 40 & fullData{COUNT}.windDir < 50 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(6,:) = fullData{COUNT}.windDir > 50 & fullData{COUNT}.windDir < 60 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(7,:) = fullData{COUNT}.windDir > 60 & fullData{COUNT}.windDir < 70 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(8,:) = fullData{COUNT}.windDir > 70 & fullData{COUNT}.windDir < 80 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(9,:) = fullData{COUNT}.windDir > 80 & fullData{COUNT}.windDir < 90 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(10,:) = fullData{COUNT}.windDir > 90 & fullData{COUNT}.windDir < 100 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(11,:) = fullData{COUNT}.windDir > 100 & fullData{COUNT}.windDir < 110 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(12,:) = fullData{COUNT}.windDir > 110 & fullData{COUNT}.windDir < 120 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(13,:) = fullData{COUNT}.windDir > 120 & fullData{COUNT}.windDir < 130 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(14,:) = fullData{COUNT}.windDir > 130 & fullData{COUNT}.windDir < 140 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(15,:) = fullData{COUNT}.windDir > 140 & fullData{COUNT}.windDir < 150 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(16,:) = fullData{COUNT}.windDir > 150 & fullData{COUNT}.windDir < 160 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(17,:) = fullData{COUNT}.windDir > 160 & fullData{COUNT}.windDir < 170 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(18,:) = fullData{COUNT}.windDir > 170 & fullData{COUNT}.windDir < 180 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(19,:) = fullData{COUNT}.windDir > 180 & fullData{COUNT}.windDir < 190 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(20,:) = fullData{COUNT}.windDir > 190 & fullData{COUNT}.windDir < 200 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(21,:) = fullData{COUNT}.windDir > 200 & fullData{COUNT}.windDir < 210 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(22,:) = fullData{COUNT}.windDir > 210 & fullData{COUNT}.windDir < 220 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(23,:) = fullData{COUNT}.windDir > 220 & fullData{COUNT}.windDir < 230 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(24,:) = fullData{COUNT}.windDir > 230 & fullData{COUNT}.windDir < 240 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(25,:) = fullData{COUNT}.windDir > 240 & fullData{COUNT}.windDir < 250 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(26,:) = fullData{COUNT}.windDir > 250 & fullData{COUNT}.windDir < 260 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(27,:) = fullData{COUNT}.windDir > 260 & fullData{COUNT}.windDir < 270 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(28,:) = fullData{COUNT}.windDir > 270 & fullData{COUNT}.windDir < 280 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(29,:) = fullData{COUNT}.windDir > 280 & fullData{COUNT}.windDir < 290 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(30,:) = fullData{COUNT}.windDir > 290 & fullData{COUNT}.windDir < 300 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(31,:) = fullData{COUNT}.windDir > 300 & fullData{COUNT}.windDir < 310 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(32,:) = fullData{COUNT}.windDir > 310 & fullData{COUNT}.windDir < 320 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(33,:) = fullData{COUNT}.windDir > 320 & fullData{COUNT}.windDir < 330 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(34,:) = fullData{COUNT}.windDir > 330 & fullData{COUNT}.windDir < 340 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(35,:) = fullData{COUNT}.windDir > 340 & fullData{COUNT}.windDir < 350 & fullData{COUNT}.season ==season;
%         windDirBins{COUNT}{season}(36,:) = fullData{COUNT}.windDir > 350 & fullData{COUNT}.season ==season;
%     end
% end

% % Loose
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        windDirBins{COUNT}{season}(1,:) = fullData{COUNT}.windDir < 20 & fullData{COUNT}.season == season;
        windDirBins{COUNT}{season}(2,:) = fullData{COUNT}.windDir > 20 & fullData{COUNT}.windDir < 40 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(3,:) = fullData{COUNT}.windDir > 40 & fullData{COUNT}.windDir < 60 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(4,:) = fullData{COUNT}.windDir > 60 & fullData{COUNT}.windDir < 80 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(5,:) = fullData{COUNT}.windDir > 80 & fullData{COUNT}.windDir < 100 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(6,:) = fullData{COUNT}.windDir > 100 & fullData{COUNT}.windDir < 120 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(7,:) = fullData{COUNT}.windDir > 120 & fullData{COUNT}.windDir < 140 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(8,:) = fullData{COUNT}.windDir > 140 & fullData{COUNT}.windDir < 160 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(9,:) = fullData{COUNT}.windDir > 160 & fullData{COUNT}.windDir < 180 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(10,:) = fullData{COUNT}.windDir > 180 & fullData{COUNT}.windDir < 200 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(11,:) = fullData{COUNT}.windDir > 200 & fullData{COUNT}.windDir < 220 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(12,:) = fullData{COUNT}.windDir > 220 & fullData{COUNT}.windDir < 240 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(13,:) = fullData{COUNT}.windDir > 240 & fullData{COUNT}.windDir < 260 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(14,:) = fullData{COUNT}.windDir > 260 & fullData{COUNT}.windDir < 280 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(15,:) = fullData{COUNT}.windDir > 280 & fullData{COUNT}.windDir < 300 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(16,:) = fullData{COUNT}.windDir > 300 & fullData{COUNT}.windDir < 320 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(17,:) = fullData{COUNT}.windDir > 320 & fullData{COUNT}.windDir < 340 & fullData{COUNT}.season ==season;
        windDirBins{COUNT}{season}(18,:) = fullData{COUNT}.windDir > 340 & fullData{COUNT}.season ==season;
    end
end


%%

% average = zeros(1,height(windBins))
for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        for k = 1:height(windDirBins{COUNT}{season})
            windDirScenario{COUNT}{season}{k}= fullData{COUNT}(windDirBins{COUNT}{season}(k,:),:);
            averagewindDir{COUNT}{season}(1,k) = mean(windDirScenario{COUNT}{season}{1,k}.detections);
            tiltCompareWindDir{COUNT}{season}(k) = mean(windDirScenario{COUNT}{season}{1,k}.tilt);
        end
    end
end

for COUNT = 1:2:length(fullData)
    for season = 1:length(seasons)
        comboPlatter = [averagewindDir{COUNT}{season},averagewindDir{COUNT+1}{season}];
        normalizedwindDir{COUNT}{season}  = averagewindDir{COUNT}{season}/(max(comboPlatter));
        normalizedwindDir{COUNT+1}{season}  = averagewindDir{COUNT+1}{season}/(max(comboPlatter));
    end
end




for COUNT = 1:length(normalizedwindDir)
    for season = 1:length(seasons)
        completeWindDir{COUNT}(season,:) = normalizedwindDir{COUNT}{season};
        completeWindDirAVG{COUNT}(season,:) = averagewindDir{COUNT}{season};
        completeTiltVswindDir{COUNT}(season,:)   = tiltCompareWindDir{COUNT}{season};
    end
end


for COUNT = 1:length(completeWindDir)
    completeWindDirAvg(COUNT,:) = nanmean(completeWindDir{COUNT});
    completeWindDirAvg2(COUNT,:) = nanmean(completeWindDirAVG{COUNT});
    completeTiltVsWindDirAvg(COUNT,:) = nanmean(completeTiltVswindDir{COUNT})
end

for COUNT = 1:length(completeWindDirAvg)
    yearlywindDir(1,COUNT) = mean(completeWindDirAvg(:,COUNT));
    yearlywindDirAVG(1,COUNT) = mean(completeWindDirAvg2(:,COUNT));
    yearlyTiltVswindDir(1,COUNT) = mean(completeTiltVsWindDirAvg(:,COUNT));
end


%20deg bins
if length(averagewindDir{1}{1}) ==18
    X = 1:20:360;
end

%10deg bins
% X = 1:10:360;
if length(averagewindDir{1}{1}) ==36
    X = 1:10:360;
end



figure()
plot(X,yearlywindDir);

figure()
plot(X,yearlywindDirAVG)


for COUNT = 1:length(completeWindDir)
    figure()
    hold on
    for season = 1:length(seasons)
        plot(X,completeWindDirAVG{COUNT}(season,:))
    end
    hold off
end

%This allows us to name each loop by the season plotted.
seasonNames = {'Winter','Spring','Summer','Fall','Mariner''s Fall'}


for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(completeWindDir)
        plot(X,completeWindDirAVG{COUNT}(season,:))
    end
    a = xline(121,'r','LineWidth',30,'label','Offshore','Alpha',0.35)
    b = xline(301,'b','LineWidth',30,'label','Onshore','Alpha',0.35)
    c = xline(30,'k','LineWidth',30,'label','Along.NE','Alpha',0.35)
    d = xline(212,'k','LineWidth',30,'label','Along.SW','Alpha',0.35)
    a.FontSize = 8
    b.FontSize = 8
    c.FontSize = 8
    d.FontSize = 8
    hold off
    xlabel('Wind Dir (CW, 0N')
    ylabel('Det Efficiency')
    title(sprintf('10 Transmissions, %s',seasonNames{season}))
end

% FRANK find separation between the two groupings in Spring? seems like 6ish are above a line, 4ish are below.






%Normalized seasonal plots, all 10
for season = 1:length(seasons)
    figure()
    hold on
    for COUNT = 1:length(completeWindDir)
        plot(X,completeWindDir{COUNT}(season,:))
    end
    a = xline(121,'r','LineWidth',30,'label','Offshore','Alpha',0.35)
    b = xline(301,'b','LineWidth',30,'label','Onshore','Alpha',0.35)
    c = xline(30,'k','LineWidth',30,'label','Along.NE','Alpha',0.35)
    d = xline(212,'k','LineWidth',30,'label','Along.SW','Alpha',0.35)
    a.FontSize = 8
    b.FontSize = 8
    c.FontSize = 8
    d.FontSize = 8
    hold off
    xlabel('Wind Dir (CW, 0N')
    ylabel('Normalized Det Efficiency')
    title(sprintf('10 Transmissions, %s',seasonNames{season}))
end

%Frank needs to add "transmission direction", a vertical line on these
%plots. That way we can look at wind dir compared  to shore and
%transmission.
%use AnglesD? Huh.
%Need to make them 0:360, not -180:180.
indy = AnglesD < 0;
AnglesD(indy) = AnglesD(indy) + 360;

% Frank fix NaNs below. Can also change bin size to 20degs, would help.


%One per graph
for COUNT = 1:length(completeWindDir)
    figure()
    hold on
    for season = 1:length(seasons)
        nexttile()
        plot(X,completeWindDirAVG{COUNT}(season,:))
        a = xline(121,'r','LineWidth',30,'label','Offshore','Alpha',0.35)
        b = xline(301,'b','LineWidth',30,'label','Onshore','Alpha',0.35)
        c = xline(30,'k','LineWidth',30,'label','Along.NE','Alpha',0.35)
        d = xline(212,'k','LineWidth',30,'label','Along.SW','Alpha',0.35)
        a.FontSize = 8
        b.FontSize = 8
        c.FontSize = 8
        d.FontSize = 8
        transDir = xline(AnglesD(COUNT),'k','LineWidth',5,'Alpha',1)
        hold off
        ylim([0 6])
        xlim([0 360])
        xlabel('Wind Dir (CW, 0N')
        ylabel('Det Efficiency')
        if season == 1
            title(sprintf('Pairing %d, %s',COUNT,seasonNames{season}))
            continue
        end
        title(sprintf('%s',seasonNames{season}))
    end
    set(gcf, 'Position', get(0, 'Screensize'));
end

