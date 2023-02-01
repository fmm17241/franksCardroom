function m=nangeomean(x)
%NANGEOMEAN Geometric mean, disregarding NaNs.
%       M = NANGEOMEAN(X) returns the geometric mean of the input.
%       When X is a vector with n elements, NANGEOMEAN(X) returns of the 
%       the n-th root of the product of the elements.
%       For a matrix input, NANGEOMMEAN(X) returns a row vector containing
%       the geometric mean of each column of X.
%
% Calls: none

%       Catherine R. Edwards
%       last modified: 10 Jun 1999


if isempty(x) % Check for empty input.
    y = NaN;
    return
end

[r,n] = size(x);

% If the input is a row, make sure that M is the number of elements in X.
if r == 1, 
    r = n; 
end

% Replace NaNs with zeros.
nans = isnan(x);
i = find(nans);

if min(size(x))==1,
  count = length(x)-sum(nans);
else
  count = size(x,1)-sum(nans);
end

% Protect against a column of all NaNs
i = find(count==0);
count(i) = ones(size(i));

if any(any(x)) <= 0
    error('The data must all be positive numbers.')
end

m = exp(nansum(log(x)) ./ count);
