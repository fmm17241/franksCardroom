function [yr,mo,d,h]=gregorian(julian)
%GREGORIAN  Converts Julian day numbers to corresponding
%       Gregorian calendar dates.  Julian days start and
%       end at noon.  
%       Julian day 2440000 began at Noon, May 23, 1968.
%
%     Usage: [y,m,d,h]=gregorian(julian)
%
%        julian... input decimal Julian day number
%
%        yr........ year (e.g., 1979)
%        mo........ month (1-12)
%        d........ corresponding Gregorian day (1-31)
%        h........ decimal hours
%

      julian=julian+5.e-9;    % kludge to prevent roundoff error on seconds

      h=rem(julian,1)*24+12;
      i=(h >= 24);
      julian(i)=julian(i)+1;
      h(i)=h(i)-24;
      j = floor(julian) - 1721119;
      in = 4*j -1;
      y = floor(in/146097);
      j = in - 146097*y;
      in = floor(j/4);
      in = 4*in +3;
      j = floor(in/1461);
      d = floor(((in - 1461*j) +4)/4);
      in = 5*d -3;
      m = floor(in/153);
      d = floor(((in - 153*m) +5)/5);
      y = y*100 +j;
      mo=m-9;
      yr=y+1;
      i=(m<10);
      mo(i)=m(i)+3;
      yr(i)=y(i);
      
   if nargout <2

month=['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
if rem(h(1),1)*60<10.
daystring = [ int2str(yr(1)),' ',month(mo(1),:),' ',int2str(d(1)),...
'  ',int2str(fix(h(1))),':0',int2str(rem(h(1),1)*60)];
else
daystring = [ int2str(yr(1)),' ',month(mo(1),:),' ',int2str(d(1)),...
'  ',int2str(fix(h(1))),':',int2str(rem(h(1),1)*60)];
end
disp(daystring)
yr = daystring;
   end


