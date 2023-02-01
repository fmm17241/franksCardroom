function xy = nancov(x,varargin)
%COV Covariance matrix.
%   COV(X), if X is a vector, returns the variance.  For matrices,
%   where each row is an observation, and each column a variable,
%   COV(X) is the covariance matrix.  DIAG(COV(X)) is a vector of
%   variances for each column, and SQRT(DIAG(COV(X))) is a vector
%   of standard deviations. COV(X,Y), where X and Y are
%   vectors of equal length, is equivalent to COV([X(:) Y(:)]). 
%   
%   COV(X) or COV(X,Y) normalizes by (N-1) where N is the number of
%   observations.  This makes COV(X) the best unbiased estimate of the
%   covariance matrix if the observations are from a normal distribution.
%
%   COV(X,1) or COV(X,Y,1) normalizes by N and produces the second
%   moment matrix of the observations about their mean.  COV(X,Y,0) is
%   the same as COV(X,Y) and COV(X,0) is the same as COV(X).
%
%   The mean is removed from each column before calculating the
%   result.
%
%   See also CORRCOEF, STD, MEAN.
%
% Calls: none

%   J. Little 5-5-86
%   Revised 6-9-88 LS 3-10-94 BJ
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.12 $  $Date: 1997/11/21 23:23:35 $

if nargin==0, error('Not enough input arguments.'); end
if nargin>3, error('Too many input arguments.'); end
if ndims(x)>2, error('Inputs must be 2-D.'); end

nin = nargin;

% Check for cov(x,flag) or cov(x,y,flag)
if (nin==3) | ((nin==2) & (length(varargin{end})==1));
  flag = varargin{end};
  nin = nin - 1;
else
  flag = 0;
end

if nin == 2,
  x = x(:);
  y = varargin{1}(:);
  if length(x) ~= length(y), 
    error('The lengths of x and y must match.');
  end
  x = [x y];
end

if length(x)==prod(size(x))
  x = x(:);
end

[m,n] = size(x);
nans = isnan(x);


if min(size(x))==1,
  count = length(x)-sum(nans);
else
  count = size(x,1)-sum(nans);
end


if m==1,  % Handle special case
  xy = 0;

else
  % Replace NaNs with ones (multiplication).
  x(nans) = ones(size(x(nans)));
  xc = x - repmat(nansum(x)./count,m,1);  % Remove mean
  if flag
    xy = xc' * xc ./ (repmat(count,n,1));
  else
    xy = xc' * xc ./ (repmat(count-1,n,1));
  end
end
