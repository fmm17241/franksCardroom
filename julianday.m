function jdn = julianday(varargin)
%JULIANDAY Julian day number.
%
%   JULIANDAY( YEAR, MONTH, DAY, HOUR, MINUTE, SECOND ) returns the
%   Julian day number of the given date plus a fractional part depending
%   on the day and time of day.
%
%   Any missing MONTH or DAY will be replaced by ones.  Any missing
%   HOUR, MINUTE or SECOND will be replaced by zeros.
%
%   If no date is specified, the current date and time is used.
%
% Calls: none

%   Author:      Peter J. Acklam
%   Time-stamp:  2000-02-29 01:13:34
%   E-mail:      jacklam@math.uio.no
%   WWW URL:     http://www.math.uio.no/~jacklam

   nargsin = nargin;
   error(nargchk(0, 6, nargsin));
   if nargsin
      argv = { 1 1 1 0 0 0 };
      argv(1:nargsin) = varargin;
   else
      argv = num2cell(clock);
   end
   [ year, month, day, hour, minute, second ] = deal(argv{:});

   % This algorithm is from the Calendar FAQ.

   a = floor((14 - month)/12);
   y = year + 4800 - a;
   m = month + 12*a - 3;

   jdn = day + floor((153*m + 2)/5) ...
         + y*365 + floor(y/4) - floor(y/100) + floor(y/400) - 32045 ...
         +  ( 3600*hour + 60*minute + second )/86400;
