%function simplegsplanner

%   SIMPLEGSPLANNER version 3.0
%
%  Create smart lines of waypoints based on glider path, measured velocity, and specified bearing
%
%   This creates four '.ma' files with different properties
%       'glidername_ingivendir_datetime.ma' == starts at current location
%           and proceeds in the given direction at a specified spacing (var ds)
%       'glidername_parallel_off_datetime.ma' == starts offset by
%           distoffset along the perpendicular to the direction of the path and
%           proceeds along the track, with additional advanced settings if needed
%       'glidername_perptocurr_datetime.ma' == proceeds perpendicular to
%           the current
%       'glidername_perptopath_datetime.ma' == proceeds perpendicular to
%           the direction of the path
%
%    NOTE On unix machines this can automatically copy files via scp.
%        On windows machines, this can automatically copy files via WinSCP
%        if a profile is created with the name rem_username@rem_machine.
%        If the profile does not already know the password or key, you will
%        be prompted to enter one.
%
%   Written by Catherine Edwards
%   Modified and updated 2020-08-21 by Tony Whipple
%   Expanded advanced settings 2021-10-25 Catherine Edwards


% set some parameters
glider='salacia'; %glider='saltdawg';

%localdir=['G:\Your\Path\Here\'];	% where on your computer you want to write mafiles and plots; copy contourinfo.mat here
localdir=['C:\Users\Skidaway\Desktop\pathplanner\'];		% where on your computer you want to write mafiles and plots; copy contourinfo.mat here

% set some parameters for track spacing, etc. Distances in meters
givendir 	= 340; 		% bearing degrees CW from N, consistent with waypoint reporting from glider
ds		= 3000;		% distance between waypoints at each bearing (set wrt max waypt abort distance, when_wpt_dist automatically set to be ds/2)
dsoffset	= 5000;		% distance between waypoints for parallel offset (should be small)
distoffset	= 15000;	% offset distance from path
nseg		= 15;		% number of segments (waypoints) to generate
perpleft   	= 1;         	%  1 == take the perpendiculars to the left of the track
                        	% -1 == take the perpendiculars to the right of the track

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

degtorad=pi/180;

% information about remote machine (dockserver probably) where current glider data are located
% including lists of glider GPS and water vx/vy, compiled by scripts on dockserver that copy/crawl
% info from SkIO and other SFMCs
rem_username='localuser';
rem_machine='dockserver.skio.uga.edu';
latlondir= '/home/localuser/realtime/latlon/';  % include trailing slash

% Set this for windows machines with winscp installed.  Otherwise it can
% be skipped.
winscp = 'C:\Program Files (x86)\WinSCP\WinSCP.com';
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% only advanced settings beyond this point


% read bathymetry info for pretty plots
load([localdir,'contourinfo.mat'],'bathymetry','coastline');

% % read in lat/lon from scp or winscp
status = -1;    % init
if isunix
	scpstr=['scp -P 2222 ' rem_username '@' rem_machine ':' latlondir glider '*.txt ' localdir '.'];
	status = system(scpstr, '-echo');
end
if ispc
	syscmd = ['"' winscp '" /command "open ""' rem_username '@' rem_machine '""" ' ...
          ' "get ""' latlondir glider '*.txt"" ' localdir '" "exit"'];
	status = system(syscmd, '-echo');
end
if status ~= 0
	disp('Once you have downloaded the files from the dockserver press any key to continue.');
	pause;
end

dstr=datestr(clock,'yyyymmddhhMM');

% load lat/lon files
llmat=load([localdir,glider,'_latlon.txt']);
glat=llmat(:,1)+sign(llmat(:,1)).*llmat(:,2)/60;                                 % convert to decimal degrees
glon=llmat(:,3)+sign(llmat(:,3)).*llmat(:,4)/60;

% find current position, convert to local coordinates in meters relative to current position
currlat=glat(end); currlon=glon(end);
% convert to xy in meters from lat/lon with currlon/currlat as origin
[xx,yy]=ll2xy(glat,glon,currlat,currlon);

% calculate path angle, perpendicular (assume 90 CCW of path); in degrees CCW from E
pathang=atan2(yy(end)-yy(end-1),xx(end)-xx(end-1)); perppathang=pathang+perpleft*pi/2;

% calculate velocity angle, perpendicular
vx=load([localdir,glider,'_water_vx.txt']); vy=load([localdir,glider,'_water_vy.txt']);
velang=atan2(vy(end),vx(end)); perpvelang=velang+perpleft*pi/2;

% convert givendir (deg CW from N) to ang convention (deg CCW from E)
givenang=pi/2-degtorad*givendir;

% gather bearing angles and calculate 

%%%%%%%
angs=[perppathang perpvelang givenang];
angstrs=['perp to path';'perp to curr';'in given dir';'parallel_off'];

% some constants, plus a fixed array of points that will be rotated in directions perp to path/curr, in given dir
degtorad=pi/180;
s=ds:ds:nseg*ds; 

for i=1:3
  angstr=angstrs(i,:); transang=angs(i);
  
  % run out xseg,yseg from starting point at specified angle, ds 
  xseg=s*cos(transang);yseg=s*sin(transang);
  
  % convert back to lat/lon 
  [latseg,lonseg]=xy2ll(xseg,yseg,currlat,currlon);
  alllon(i,:)=lonseg; alllat(i,:)=latseg;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create "safe" parallel offset version parallel to track at distoffset perp from current position; 
% useful when being swept by strong currents so that waypoints sweep along with glider, so fewer updates are needed

% advanced settings: firstang/transang can be set to pathang, perppathang, velang, perpvelang

firstang=perppathang; 			% angle from current position to first point x1=distoffset*cos(firstang)
transang=pathang; 			% angle list of waypoints makes
tweakang_degrees=0;				% tweakang degrees CW

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tweakang=tweakang_degrees*degtorad; 

s=dsoffset*(0:nseg-1);
xseg=distoffset*cos(firstang)+(s-1)*cos(transang+tweakang);
yseg=distoffset*sin(firstang)+(s-1)*sin(transang+tweakang);
[latsafe,lonsafe]=xy2ll(xseg,yseg,currlat,currlon);

angs(4)=transang+tweakang;					%

% plot up

figure;
h1=plot(glon,glat,'k.-'); set(h1,'markersize',10); axis equal; hold on; h2=plot(alllon(1:3,:)',alllat(1:3,:)','x');
hs=plot(lonsafe,latsafe,'r*'); xl=get(gca,'xlim'); yl=get(gca,'ylim');
hold on; 

% plot coastline as dark black line
hb=plot(coastline.x,coastline.y,'k'); set(hb,'linewidth',2); hold on;

% plot [10 20 30 40 50 100 200 500 1000] bathymetry contours as gray lines
for i=1:length(bathymetry)
  hc(i)=line(bathymetry(i).x(:),bathymetry(i).y(:),'color',[.6 .6 .6],'LineWidth',0.5);
end

hleg=legend([h1;h2;hs],'surfacings','perp track','perp currs','givendir','|| offset');
hh=plot(glon(end),glat(end),'r*'); set(gca,'xlim',xl,'ylim',yl);
title([dstr,': vx=',num2str(vx(end)),'; vy=',num2str(vy(end))]);
print('-djpeg90',[localdir,'/',glider,'_tracks_',dstr,'.jpg']);


for i=1:4

  angstr=angstrs(i,:); 
  
  if(i<4)
    lonseg=alllon(i,:); latseg=alllat(i,:);  
  else
    lonseg=lonsafe; latseg=latsafe; 
  end;
  
  nseg=length(lonseg);
  fid=fopen([localdir,glider,'_',blank(angstr),'_',dstr,'.ma'],'w');
  fprintf(fid,'%s\n','behavior_name=goto_list');
  if(i<4)
    fprintf(fid,'%s\n',['# Flies ',angstr]);
    fprintf(fid,'%s\n',['#  at an angle: ',num2str((pi/2-transang)/degtorad),' deg CW of N']);
  else
    fprintf(fid,'%s\n',['# Flies "safe" waypoints parallel to track, offset ',angstr]);
    fprintf(fid,'%s\n',['#  at an angle: ',num2str((pi/2-transang)/degtorad),' deg CW of N']);
  end
  fprintf(fid,'%s\n','<start:b_arg>');
  fprintf(fid,'%s\n','b_arg: num_legs_to_run(nodim) -2 # run once');
  fprintf(fid,'%s\n','b_arg: start_when(enum) 0 # BAW_IMMEDIATELY');
  fprintf(fid,'%s\n','b_arg: list_stop_when(enum) 7 # BAW_WHEN_WPT_DIST');
  if(i<4)
    fprintf(fid,'%s\n',['b_arg: list_when_wpt_dist(m) ',num2str(ds)]);
  else
    fprintf(fid,'%s\n',['b_arg: list_when_wpt_dist(m) ',num2str(dsoffset)]);
  end
  fprintf(fid,'%s\n','b_arg: initial_wpt(enum) -2 # closest');
  fprintf(fid,'%s\n',['b_arg: num_waypoints(nodim) ',num2str(nseg)]);
  fprintf(fid,'%s\n','<end:b_arg>'); fprintf(fid,'%s\n','');
  fprintf(fid,'%s\n','<start:waypoints>');
  fprintf(fid,'%9.3f %9.3f\n',decdeg2ddmm([lonseg; latseg]));
  fprintf(fid,'%s\n','<end:waypoints>');
  fclose(fid);

end



%% ---------------------------------------------------
% The following helper functions are functionally identical to those in 
% Catherines collection of matlab files.

function [x,y]=ll2xy(lat,lon,reflat,reflong)
      
      % [X,Y]=LL2XYGOM(LAT,LON,REFLAT,REFLON)
      %
      % Returns X and Y vectors (as distance from arbitrary
      % origin REFLAT and REFLON) for vectors of latitudes
      % and longitudes, LAT and LON.
      %
      % REFLAT and REFLON default to Boston
      %
      % LAT and LON may be specified as LON+i*LAT
      %
      % Specifying only a single output yields X+i*Y
      
      % CVL, 7-10-97
      % Hacked from mercgom2 from C. Naimie.
      
      r=6.3675E+6;
      
      if nargin<3
	      reflong=-71.03*pi/180;
	      reflat=42.35*pi/180;
      end
      
      if nargin==1
	      lon=real(lat);
	      lat=imag(lat);
      end
      
      xo=r*cos(reflat)*reflong;
      yo=r*cos(reflat)*log((1.0+sin(reflat))/cos(reflat));
      
      rlong=lon*pi/180;
      rlat=lat*pi/180;
      x=r*cos(reflat).*rlong-xo;
      y=r*cos(reflat).*log((1.0+sin(rlat))./cos(rlat))-yo;
      
      if nargout<=1
	      x=x+i*y;
      end
end

function [lat,lon]=xy2ll(x,y,reflat,reflon)

% [LAT,LON]=XY2LLGOM(X,Y,REFLAT,REFLON)
%
% Returns vectors of latitudes and longitudes, LAT and LON, 
% for X and Y vectors (as distance in meters from arbitrary 
% origin REFLAT and REFLON).  Uses a Newton-Raphson Method
% to calculate latitude.  In situations where one or more
% values do not converge, that location is assigned the value
% NaN and a warning is issued.
%
% REFLAT and REFLON default to Boston
%
% X and Y may be specified as X+i*Y
%
% Specifying only a single output yields LON+i*LAT
%
% Calls: none

% CVL, 7-10-97
% Hacked from mercgom2 from C. Naimie.

    if nargin<3
	reflon=-71.03*pi/180;
	reflat=42.35*pi/180;
    end

    if nargin==1
	y=imag(x);
	x=real(x);
    end

    reflon=reflon*pi/180;
    reflat=reflat*pi/180;
    r=6.3675e+6;
    xo=r*cos(reflat)*reflon;
    yo=r*cos(reflat)*log((1.0+sin(reflat))/cos(reflat));

    rlon=(x+xo)/(r*cos(reflat));

    y=y+yo;

    tol=0.0001;
    n=1000;

    po=reflat*ones(size(x));
    for in=1:n
	p1=po-((1.0+sin(po))./cos(po)-exp(y./(r*cos(reflat))))...
	    ./((1.0+sin(po))./(cos(po).^2.0));
	if max(abs(p1-po))<tol
	    break
	end
	po=p1;
    end

    if in==n
	in=find(max(abs(p1-po))<tol);
	p1(in)=NaN*p1(in);
	rlon(in)=NaN*rlon(in);
	disp('Did not converge after 1000 iterations, some values NaN')
    end

    rlat=p1;
    lon=rlon*180/pi;

    lat=rlat*180/pi;

    if nargout<=1
	lat=lon+i*lat;
    end
end

function outstr=blank(instr)
    if size(instr,1) > 1
       error('input string must be a vector');
    end
    outstr=instr(instr ~= ' ');
end

function ddmm=decdeg2ddmm(decdeg)
%
%     DECDEG2DDMM converts GPS style lat/lon DDMM.MMMM
%	      to decimal degrees DD.DDDD, handles +/-
%
%     ddmm=decdeg2ddmm(decdeglon);
%
%     DDMM2DECDEG is the inverse function
%
% CRE 11/20/2013: clarified sign
    decdegsign=sign(decdeg); 
    decdegval=abs(decdeg);
    dd=fix(decdegval);
    mm=(decdegval-dd)*60;
    ddmmval=100*dd+mm;
    ddmm=decdegsign.*ddmmval;
%end



