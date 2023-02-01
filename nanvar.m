function [f_var] = nanvar(data);
%
%   [f_var] = nanvar(data);
%
%Function which calculates the var (not NaN) of data containing
%NaN's.  NaN's are excluded completely from calculation.

[m,n] = size(data);

for index = 1:n;
    not_nans = find(isnan(data(:,index)) == 0);
        if length(not_nans) > 0;
            f_var(index) = var(data(not_nans,index));
        else
            f_var(index) = NaN;
        end
end
