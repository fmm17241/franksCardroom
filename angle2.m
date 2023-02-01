
	function ang2=angle2(ang1);
% 
%	throws angle (in degrees) into [0 360]
%
% Calls: none
%
 	degtorad=pi/180; ang=ang1*degtorad;
	ang2=atan2(sin(ang),cos(ang))/degtorad;
	ang2(ang2<0)=ang2(ang2<0)+360;
	ang2(ang2>=360)=ang2(ang2>=360)-360;
	
	return;
