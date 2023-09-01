%Can run this after vemprocess,detectionprocess,and sortbytransmitters

L = length(correctedDN);
correctedGPS = [correctedLat correctedLon];

% fill in interpolated lat/lon [1 x NT], no NaNs
% show off version: use repmat to make moorings.xx, glider.xx [NM x NT] 

%Now looking to index by distances within a range
detectionsWithinRange = cell(1,1);
outside = cell(1,1);
% This sets the distance (range) at which we're indexing the glider path
% by.
howMany = length(mooredGPS);

rangedist = [4000,3900,3800,3700,3600,3500,3400,3300,3200,3100,3000,2900,2800,2700,2600,2500,2400,2300,2200,2100,2000,1900,1800,1700,1600,1500,1400,1300,1200,1100,1000,900,800,700,600,500,400,300,200,100];  %distance in METERS

for P = 1:length(rangedist)-1
    for k =1:howMany
        index = moglidist(k,:)<rangedist(P) & moglidist(k,:)>rangedist(P+1);
        detectionsWithinRange{k,P}.dn = correctedDN(index);
        detectionsWithinRange{k,P}.distance=moglidist(k,index); detectionsWithinRange{k,P}.gps = correctedGPS(index,:);
        index = sortedbypings.distkm{k}<rangedist(P) & sortedbypings.distkm{k}>rangedist(P+1);
        detectionsWithinRange{k,P}.detections = sortedbypings.distkm{1,k}(index);
        detectionsWithinRange{k,P}.bearing  = sortedbypings.bearing{1,k}(index);
        detectionsWithinRange{k,P}.dt = datetime(detectionsWithinRange{k,P}.dn,'ConvertFrom','datenum');
    end
end
for P = length(rangedist)
    for k =1:howMany
        index = moglidist(k,:)<rangedist(P);
        detectionsWithinRange{k,P}.dn = correctedDN(index);
        detectionsWithinRange{k,P}.distance=moglidist(k,index); detectionsWithinRange{k,P}.gps = correctedGPS(index,:);
        index = sortedbypings.distkm{k}<rangedist(P);
        detectionsWithinRange{k,P}.detections = sortedbypings.distkm{1,k}(index);
        detectionsWithinRange{k,P}.bearing  = sortedbypings.bearing{1,k}(index);
        detectionsWithinRange{k,P}.dt = datetime(detectionsWithinRange{k,P}.dn,'ConvertFrom','datenum');
    end
end

for P = 1:length(rangedist)
    for k=1:howMany
       chump = isempty(detectionsWithinRange{k,P});
        if chump == 1
            continue
        end 
        numberz = length(detectionsWithinRange{k,P}.dt);   %Number of datapoints
        onedata = 4;                        %Seconds represented by each data point
        timeSpent{k,P} = (numberz*onedata)/60;  %Minutes spent in area
        ExpectedPings{k,P} = (timeSpent{k,P})/10;
    end
end


numb = cell(1,1);
for P = 1:length(rangedist)
    for k=1:howMany
%         if k == 15
%             continue
%         end
        numb{k,P} = numel(detectionsWithinRange{k,P}.detections);  
        DetectionEfficiency{k,P} = numb{k,P}/ExpectedPings{k,P};
    end
end




%% TEST
% totalTime=zeros(40,1);
% for P = 1:length(rangedist)
%     for k=1:length(transmittersID)
%        chump = isempty(detectionsWithinRange{k,P});
%         if chump == 1
%             continue
%         end 
%         numberz = length(detectionsWithinRange{k,P}.dt);   %Number of datapoints
%         onedata = 4;                        %Seconds represented by each data point
%         timeSpent(k,P) = (numberz*onedata)/60;  %Minutes spent in area
%     end
% end
% 
% totalTime(P)  = totalTime(P) + sum(timeSpent(k,P));
% 
% ExpectedPings = totalTime/10
% 
% 
% numb = zeros(40,1);
% 
% for P = 1:length(rangedist)
%     for k=1:9
% %         if k == 15
% %             continue
% %         end
%         numb(P) = numb(P) + numel(detectionsWithinRange{k,P}.detections); 
%     end
% end
% 
% 
% DetectionEfficiency = numb/ExpectedPings
% 

