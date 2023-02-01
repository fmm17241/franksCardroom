
	function ang2=angle180(ang1);
% 
%	throws angle (in degrees) into [-180 180]
%
% Calls: none
%
 	degtorad=pi/180; ang=ang1*degtorad;
	ang2=atan2(sin(ang),cos(ang))/degtorad;
	ang2(ang2<180)=ang2(ang2<180)+360;
	ang2(ang2>=180)=ang2(ang2>=180)-360;
	
	return;
