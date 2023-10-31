%%
%FM isolating seasonal effects, maybe?


for COUNT = 1:length(fullData)
    for season = 1:length(seasons)
        seasonBin{COUNT}{season} = fullData{COUNT}.season ==season;
    end
end
