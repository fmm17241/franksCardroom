function yd = dayofyear( varargin )
%DAYOFYEAR Ordinal number of day in year.
%
%   DAYOFYEAR( YEAR, MONTH, DAY, HOUR, MINUTE, SECOND ) returns the
%   ordinal day number in the given year plus a fractional part
%   depending on the time of day.
%
%   Any missing MONTH or DAY will be replaced by 1.  HOUR, MINUTE or
%   SECOND will be replaced by zeros.
%
%   If no date is specified, the current date and time is used.
%
% Calls: none

%   Author:      Peter J. Acklam
%   Time-stamp:  2000-02-29 01:16:57
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

   days_in_prev_months = [ 0 31 59 90 120 151 181 212 243 273 304 334 ];
   dmonth=days_in_prev_months(month);

   % Day in given month.
   yd = reshape(dmonth,size(year)) ...               % days in prev. months
        + ( isleapyear(year) & ( month > 2 ) ) ...   % leap day
        + day ...                                    % day in month
        + ( 3600*hour + 60*minute + second )/86400;  % part of day
