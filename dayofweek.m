function dow = dayofweek(varargin)
%DAYOFWEEK Day of week.
%
%   NUM = DAYOFWEEK(YEAR, MONTH, DAY, HOUR, MINUTE, SECOND) returns the
%   ordinal day number in the given week plus a fractional part depending on
%   the time of day.  This function is ISO 8601 compliant, so Monday is day
%   1, Tuesday is day 2, ..., Sunday is day 7.
%
%   Any missing MONTH or DAY will be replaced by ones.  Any missing HOUR,
%   MINUTE or SECOND will be replaced by zeros.
%
%   If no date is specified, the current date is used.  Gregorian calendar
%   is assumed.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 12:52:07 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(0, 6, nargin));
   dow = 1 + mod(date2mjd(varargin{:}) + 2, 7);
