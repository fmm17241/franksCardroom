----------------------------------------------------------------
function p = fact2(n)
%FACT2 Factorial function.
%   FACT2(N) = PROD(1:N) = 1*2*...*N.  NaN is returned if N
%   is negative or not an integer.  Inf is returned for N > 170.
%
%   See also PROD, GAMMA.
%
% They both return `factorial(x)' but `prod(1:n)' is not vectorized
% and `gamma(x+1)' does a considerable amount of arithmetic.  I
% have included a factorial function which is vectorized, but uses a
% `prod'-like approach.  It takes advantage of the fact that
% `factorial(x)' overflows for `x > 170'.
% 
% (In MATLAB 6, `gamma' became a mex-function, so there might be no
% speed gain by using the function below.)
% 
%
% Calls: none

% Author:      Peter J. Acklam
% Time-stamp:  2001-02-06 15:39:58
% E-mail:      jacklam@math.uio.no
% URL:         http://www.math.uio.no/~jacklam

   maxval = 170;        % prod(1:maxval+1) = Inf
   table  = cumprod(1 : min(max(n(:)), maxval));

   % initialize output
   nan = NaN;
   p = nan(ones(size(n)));

   % table lookup
   k = n == round(n) & 1 <= n & n <= maxval;
   p(k) = table(n(k));

   % overflow
   k = n == round(n) & n > maxval;
   p(k) = Inf;

   % special case n = 0
   k = n == 0;
   p(k) = 1;
----------------------------------------------------------------
