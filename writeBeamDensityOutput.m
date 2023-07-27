%McQuarrie 2021 
%Creates CSV files for Beam Density Analysis outputs. NEED to add
%best-guess PDF values to this output to be of most use.

function [percentage]=writeBeamDensityOutput(sumRays,gridpoints)
howmanyOutputs = length(sumRays);

percentage = cell(1,1);
for k =1:howmanyOutputs
%     percents= sumRays{k}/(sumRays{k}(200));
    percents=sumRays{k}/1000;
    index=percents>0.5;
    percentage{k}=percents;
    percentage{k}(index)=0.5;
end

%Cutting it down to smaller outputs, more relevant bins
ranges = gridpoints(1,200:200:end);
output=cell(1,1);
for k =1:howmanyOutputs
    output{k}= [ranges;percentage{k}(1,200:200:end)];
    writematrix(output{k}', sprintf('rayOutputCSV%d.csv',(k)));
    dlmwrite(sprintf('rayOutputDLM%d',(k)),output{k});
end 
end