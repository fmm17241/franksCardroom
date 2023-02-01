function yd = dayofyearvec(dvec)
%DAYOFYEAR Ordinal number of day in year.
%
%   DAYOFYEARVEC( DVEC ) returns the
%   ordinal day number in the given year plus a fractional part
%   depending on the time of day.
%
%   Any missing MONTH or DAY will be replaced by 1.  HOUR, MINUTE or
%   SECOND will be replaced by zeros.
%
%   If no date is specified, the current date and time is used.
%
% Calls: none

%   Author:      Peter J. Acklam, modified by C. Edwards for DATEVEC format
%   Time-stamp:  2000-02-29 01:16:57
%   E-mail:      jacklam@math.uio.no
%   WWW URL:     http://www.math.uio.no/~jacklam

[r,c]=size(dvec); 
if(c<6);  
  temp=zeros(r,6); temp(:,2:3)=1;
  temp(:,1:c)=dvec; dvec=temp;
end

   year=dvec(:,1);
   month=dvec(:,2);
   day=dvec(:,3);
   hour=dvec(:,4);
   minute=dvec(:,5);
   second=dvec(:,6);

   days_in_prev_months = [ 0 31 59 90 120 151 181 212 243 273 304 334 ];
   dmonth=days_in_prev_months(month);

   % Day in given month.
   yd = reshape(dmonth,size(year)) ...               % days in prev. months
        + ( isleapyear(year) & ( month > 2 ) ) ...   % leap day
        + day ...                                    % day in month
        + ( 3600*hour + 60*minute + second )/86400;  % part of day
