function [x,y]=ll2xy(lat,lon,reflat,reflong)

% [X,Y]=LL2XYGOM(LAT,LON,REFLAT,REFLON)
%
% Returns X and Y vectors (as distance from arbitrary 
% origin REFLAT and REFLON) for vectors of latitudes 
% and longitudes, LAT and LON.
% 
% REFLAT and REFLON (in degrees) default to Boston
%
% LAT and LON may be specified as LON+i*LAT
%
% Specifying only a single output yields X+i*Y
%
% Calls: none

% CVL, 7-10-97
% Hacked from mercgom2 from C. Naimie.

r=6.3675E+6;
degtorad=pi/180;

if nargin<3
	reflong=-71.03*pi/180;
	reflat=42.35*pi/180;
end

if nargin==1
	lon=real(lat);
	lat=imag(lat);
end

xo=r*cos(degtorad*reflat)*degtorad*reflong;
yo=r*cos(degtorad*reflat)*log((1.0+sin(degtorad*reflat))/cos(degtorad*reflat));

rlong=lon*pi/180;
rlat=lat*pi/180;
x=r*cos(degtorad*reflat).*rlong-xo;
y=r*cos(degtorad*reflat).*log((1.0+sin(rlat))./cos(rlat))-yo;

if nargout<=1
	x=x+i*y;
end

return;
