
%FM splitting up bins by tidal velocity



for k = 1:length(seasonName)
    %Parallel: X-axis of our tides, aligned with transmissions
    crossTideBins{k}(1,:) = singleData{1}.CrossTide < -.4 & singleData{1}.Season ==k;
    crossTideBins{k}(2,:) =  singleData{1}.CrossTide > -.4 &  singleData{1}.CrossTide < -.35 & singleData{1}.Season ==k;
    crossTideBins{k}(3,:) =  singleData{1}.CrossTide > -.35 &  singleData{1}.CrossTide < -.30 & singleData{1}.Season ==k;
    crossTideBins{k}(4,:) =  singleData{1}.CrossTide > -.30 & singleData{1}.CrossTide <-.25 & singleData{1}.Season ==k;
    crossTideBins{k}(5,:) =  singleData{1}.CrossTide > -.25 &  singleData{1}.CrossTide < -.20 & singleData{1}.Season ==k;
    crossTideBins{k}(6,:) =  singleData{1}.CrossTide > -.20 &  singleData{1}.CrossTide < -.15 & singleData{1}.Season ==k;
    crossTideBins{k}(7,:) =  singleData{1}.CrossTide > -.15 &  singleData{1}.CrossTide < -.10 & singleData{1}.Season ==k;
    crossTideBins{k}(8,:) =  singleData{1}.CrossTide > -.1 &  singleData{1}.CrossTide < -.05 & singleData{1}.Season ==k;

    crossTideBins{k}(9,:) =  singleData{1}.CrossTide > -.05 &  singleData{1}.CrossTide < 0.05 & singleData{1}.Season ==k;

    crossTideBins{k}(10,:) =  singleData{1}.CrossTide > .05 &  singleData{1}.CrossTide < .1 & singleData{1}.Season ==k;
    crossTideBins{k}(11,:) =  singleData{1}.CrossTide > .10 &  singleData{1}.CrossTide < .15 & singleData{1}.Season ==k;
    crossTideBins{k}(12,:) =  singleData{1}.CrossTide > .15 & singleData{1}.CrossTide < .2 & singleData{1}.Season ==k;
    crossTideBins{k}(13,:) =  singleData{1}.CrossTide > .20 &  singleData{1}.CrossTide < .25 & singleData{1}.Season ==k;
    crossTideBins{k}(14,:) =  singleData{1}.CrossTide > .25 &  singleData{1}.CrossTide < .3 & singleData{1}.Season ==k;
    crossTideBins{k}(15,:) =  singleData{1}.CrossTide > .30 &  singleData{1}.CrossTide < .35 & singleData{1}.Season ==k;
    crossTideBins{k}(16,:) =  singleData{1}.CrossTide > .35 &  singleData{1}.CrossTide < .4 & singleData{1}.Season ==k;
    crossTideBins{k}(17,:) =  singleData{1}.CrossTide > .40 & singleData{1}.Season ==k;
end
