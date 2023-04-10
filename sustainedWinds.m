%FM 4/10
%First binnedAVG, then we work

%Creates a threshold: I need to find when wind is sustained above this
%value
threshold = 9;

A = [0,1,20,5,7,8,13,17,28,11,10,0,2,1,4];

idx = [true,A(1:end-1)>threshold] & A>threshold & [A(2:end)>threshold,true];
idx = [false,idx(1:end-1)] | idx | [idx(2:end),false];
[test] = A(idx)




threshold = 9;

idx = fullData{1}.windSpeed(1:end-1) > threshold & fullData{1}.windSpeed(2:end)>threshold;
idx = [false,idx(1:end-1)] | [idx(2:end),false];

[test] = A(idx)





for COUNT = 1

        idx = [true,fullData{COUNT}.windSpeed(1:end-1) > threshold] & fullData{COUNT}.windSpeed > threshold & [fullData{COUNT}.windSpeed(2:end) > threshold,true];

%         windSpeedBins{COUNT}{season}(2,:) = fullData{COUNT}.windSpeed > 1 & fullData{COUNT}.windSpeed < 2 & fullData{COUNT}.season ==season;
end
