function isdst = is_dst(dn);
%
%	2007 to present: starts 2am 2nd Sunday in March, ends 2am 1st Sunday in November
%	prior to 2007:   starts 2am 1st Sunday in April, ends 2am last Sunday in October
%
% IS_DST takes a vector of datenum and returns locical 1/0 if the values fall within the window of US DST, 
%	accounting for the change in policy in 2007 brought by the Energy Policy Act (2005)
%
%	2007 to present: starts 2am 2nd Sunday in March, ends 2am 1st Sunday in November
%	prior to 2007:   starts 2am 1st Sunday in April, ends 2am last Sunday in October
%
%		isdst = IS_DST(dn);	
%
%	Does not account for 100/400 year leap exceptions, so this algorithm is valid years 1900-2099.
%
% Calls: datevec, julianday
%
% Catherine R. Edwards, SkIO: catherine.edwards@skio.usg.edu
% Last modified: 09 Dec 2013
%
 
allzero=0*dn; monstart=allzero; monend=allzero; daystart=allzero; dayend=allzero;

[yr,mo,d,h,mi,s]=datevec(dn); jd=julianday(yr,mo,d,h,mi,s);

% choose different algorithms for -2006, 2007-
iold=find(yr<2007); inew=find(yr>=2007);

% start month March -2006, April 2007-, end month October -2006, November 2007-
monstart(inew)=3; monend(inew)=11; monstart(iold)=4; monend(iold)=10;

% calculate start day of DST for the year -- 2007 to present
daystart(inew) = 14-mod(1+floor(yr(inew)*5/4),7);
dayend(inew) = 7-mod(1+floor(yr(inew)*5/4),7);

% calculate beginning of DST for the year -- prior to 2007
daystart(iold) = 7 - mod(4+floor(yr(iold)*5/4),7);
dayend(iold) = 31-mod(1+floor(yr(iold)*5/4),7);

% calculate julianday of DST start/end for each datapoint then compare to window to get flag
%	(julianday much much faster than datenum for large arrays)

jdstart=julianday(yr,monstart,daystart,2+allzero,0+allzero,0+allzero);
jdend=julianday(yr,monend,dayend,2+allzero,0+allzero,0+allzero);

isdst=(jd>=jdstart & jd<jdend);
