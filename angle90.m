
	function ang2=angle90(ang1);
% 
%	throws angle (in degrees) into [-90 90],
%	Effectively, angle90=atan(tan(ang));
%
% Calls: none
%
 	degtorad=pi/180; 
	ang2=atan(tan(ang1*degtorad))/degtorad;
	
	return;
