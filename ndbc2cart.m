
function [u,v]=ndbc2cart(wspd,wdir);

%	[u,v]=ndbc2cart(wspd,wdir);
%
% WSPD  Wind speed (m/s) averaged over an eight-minute period for buoys and a
%	two-minute period for land stations. Reported Hourly. 
% WDIR 	Wind direction (the direction the wind is coming from
%	in degrees clockwise from true N) during the same period used for 
%	WSPD. 

degtorad=pi/180;

u=wspd.*cos(pi/2-degtorad*wdir-pi);
v=wspd.*sin(pi/2-degtorad*wdir-pi);

