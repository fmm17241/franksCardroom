	function Int = simpsonxy(Field,nx,ny,deltax,deltay);
%
%	SIMPSONXY integrates over a 2D rectangular regularly spaced grid
%	 and calculates the integral given spacing and number of nodes
%
%	SIMPSONXY requires the following arguments:
%		Field - the 2D field which is integrated
%		nx, ny - the number of segments on x,y, respectively
%		         **nx, ny must be even**
%		deltax, deltay - the spacing between x,y nodes, respectively
%
%	output vars
% 		Int - the value of the integral desired
%
%	Catherine Edwards
%	last modified 12 Jan 1999	
%
% Calls: none
	
% integrate over x then y  

Field(2:2:ny,:)=4*Field(2:2:ny,:);
Field(3:2:ny-1,:)=2*Field(3:2:ny-1,:);
Iy = nansum(Field(:,:));
Iy = deltay*Iy/3.0;

Iy(2:2:nx)=4*Iy(2:2:nx);  Iy(3:2:nx-1)=2*Iy(3:2:nx-1);
Ixy = nansum(Iy);
Int = deltax*Ixy/3.0;

return;
