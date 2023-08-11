%McQuarrie 2021 
%Creates CSV files for Beam Density Analysis outputs. NEED to add
%best-guess PDF values to this output to be of most use.

function [percentage]=writeBDAoutput(sumRays,gridpoints)


% 
percents=sumRays/1000;
index=percents>0.5;
percentage=percents;
percentage(index)=0.5;


%Cutting it down to smaller outputs, more relevant bins
ranges = gridpoints(1,200:200:end);

output= [ranges;percentage(1,200:200:end)];
writematrix(output', sprintf('rayOutputCSV.csv'));
dlmwrite(sprintf('rayOutputDLM'),output);

end