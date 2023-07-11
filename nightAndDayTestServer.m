%FM 2023, Testing diurnal differences during different seasons. The annual
%difference in day vs night is not as clear as expected.

%Run binnedAVG

%Index formed by using 
for COUNT= 1:length(fullData)
    for k = 1:length(seasons)
        daylightIndex{COUNT}{k}(1,:) = fullData{COUNT}.sunlight==1 & fullData{COUNT}.season ==k;
        daylightIndex{COUNT}{k}(2,:) =  fullData{COUNT}.sunlight==0 & fullData{COUNT}.season ==k;
        day{k,COUNT}    = fullData{1,COUNT}(daylightIndex{1,COUNT}{1,k}(1,:),:)
        night{k,COUNT}  = fullData{1,COUNT}(daylightIndex{1,COUNT}{1,k}(2,:),:)
        dayDets{k}(COUNT,:)    = day{k,COUNT}.detections;
        nightDets{k}(COUNT,:)  = night{k,COUNT}.detections;
        daySounds{k}(COUNT,:)     =day{k,COUNT}.noise;
        nightSounds{k}(COUNT,:)   = night{k,COUNT}.noise;

    end
end


noiseDay1    = mean(daySounds,1);
noiseNight1  = mean(nightSounds,1);
noiseDay    = mean(noiseDay1,'all')
noiseNight  = mean(noiseNight1,'all')
avgDay1    = mean(dayDets,1)
avgNight1  = mean(nightDets,1)
avgDay    = mean(avgDay1,'all')
avgNight  = mean(avgNight1,'all')

errDay    = std(avgDay1);

errNight  = std(avgNight1);

x = 1:length(dayDets(1,:));
x1 = 1:length(nightDets(1,:));

figure()
hold on
scatter(day{1}.time,avgDay1,'r','filled')
scatter(night{1}.time,avgNight1,'b','filled')


figure()
scatter(1,avgDay,'r','filled')
hold on
scatter(3,avgNight,'k','filled')
errorbar(1,avgDay,errDay,'LineStyle','none')
errorbar(3,avgNight,errNight,'LineStyle','none')
ylim([0 4])
xlim([0.9 3.1])



%%
%Frank separated all the bin creation to not clutter one massive script
%with so many different goals.

% createTideBins
% createTideBinsABS
% createTiltBins
% createWindSpeedBins
% createWindDirBins
% 
% % The big'un. Looking to bin by both tide and wind directions.
% AxisAndAllies   


for COUNT=1:length(fullData)
    sumD(COUNT) = sum(fullData{COUNT}.detections);
end
