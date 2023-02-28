
function [u,v]=ndbcadcp2cart(spd,dir);

%	[u,v]=ndbc2cart(spd,dir);
%
% SPD   Current speed (m/s) 
% DIR 	Current direction (degrees toward, oceanographic convention, 
%	in degrees clockwise from true N).
%

degtorad=pi/180;

u=spd.*cos(pi/2-degtorad*dir);
v=spd.*sin(pi/2-degtorad*dir);

