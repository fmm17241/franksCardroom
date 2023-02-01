function g = gcdall(x)
%GCDALL Greatest common divisor of all elements.
%
%   GCDALL(X) is the greatest common divisor of all elements in X.
%
%   See also GCD, LCM, LCMALL.

%   Author:      Peter J. Acklam
%   Time-stamp:  2001-10-03 14:24:35 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check input arguments
   error(nargchk(1, 1, nargin));

   if ~isnumeric(x) | ~isreal(x)
      error('Argument must be numeric and real.');
   end

   if ~isequal(x, round(x))
      error('Argument must contain integers only.');
   end

   % now find greatest common divisor
   n = prod(size(x));
   g = 0;
   for i = 1:n
      g = gcd(g, x(i));
      if g == 1
         break
      end
   end
