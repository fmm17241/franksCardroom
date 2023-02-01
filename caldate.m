function cal=caldate(kd)

% returns the calendar date from the gregorian day kd,
% without the "/"'s
if ~exist('kd')
   kd=today;
end

cal=datestr(kd,25);
iding=findstr(cal,'/');
cal(iding)=[];

return

