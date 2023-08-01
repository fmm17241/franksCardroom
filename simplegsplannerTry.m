%   SIMPLEGSPLANNER version 2.0
%
%  Create smart lines of waypoints based on glider path, measured velocity, and specified bearing
%
%   This creates four '.ma' files with different properties
%       'glidername_ingivendir_datetime.ma' == starts at current location
%           and proceeds in the given direction at a specified spacing (var ds)
%       'glidername_parallel_off_datetime.ma' == starts offset by
%           distoffset along the perpendicular to the direction of the path and
%           proceeds along the track
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


% set some parameters
glider='franklin'; %glider='saltdawg';

localdir=['G:\Glider\LegPlanner\'];	% where on your computer you want to write mafiles and plots; copy ec2001.mat here

% set some parameters for track spacing, etc. Distances in meters
givendir= [330]; 		% bearing degrees CW from N, consistent with waypoint reporting from glider
ds=110000;			% distance between waypoints at each bearing (set wrt max waypt abort distance, when_wpt_dist)
dsoffset=7000;			% distance between waypoints for parallel offset (should be small)
distoffset=10000;		% offset distance from path
nseg=18;

% note: default set up expects a Gulf Stream like current and poleward motion. If flow direction and/or path changes, 
% you can change the direction of pathang by changing the sign of pi/2 in the definition of perppathang/velang 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

degtorad=pi/180;

% information about remote machine (dockserver probably) where current glider data are located
% including lists of glider GPS and water vx/vy, compiled by scripts on dockserver that copy/crawl
% info from SkIO and other SFMCs
rem_username='localuser';
rem_machine='dockserver.skio.uga.edu';
latlondir= '/home/localuser/realtime/latlon/';  % include trailing slash

% Set this for windows machines with winscp installed.  Otherwise it can
% be skipped.
% winscp = 'C:\Program Files (x86)\WinSCP\WinSCP.com';
% 
% read bathymetry info for pretty plots
load([localdir,'contourinfo.mat'],'bathymetry','coastline');

% % read in lat/lon from scp or winscp
% status = -1;    % init
% if isunix
% scpstr=['scp -P 2222 ' rem_username '@' rem_machine ':' latlondir '*.txt ' localdir '.'];
% status = system(scpstr, '-echo');
% end
% if ispc
% syscmd = ['"' winscp '" /command "open ""' rem_username '@' rem_machine '""" ' ...
%           ' "get ""' latlondir glider '*.txt"" ' localdir '" "exit"'];
% status = system(syscmd, '-echo');
% end
% if status ~= 0
% disp('Once you have downloaded the files from the dockserver press any key to continue.');
% pause;
% end

% load lat/lon files
llmat=load([localdir,glider,'_latlon.txt']);
% glat=llmat(:,1)+sign(llmat(:,1)).*llmat(:,2)/60;   % convert to decimal degrees
% glon=llmat(:,3)+sign(llmat(:,3)).*llmat(:,4)/60;
% glat = llmat(:,1)+sign(llmat(:,1));
% glon = llmat(:,2)+sign(llmat(:,2));
glat = llmat(:,1);
glon = llmat(:,2);

% find current position, convert to local coordinates in meters relative to current position
currlat=glat(end); currlon=glon(end);
% convert to xy in meters from lat/lon with currlon/currlat as origin
[xx,yy]=ll2xy(glat,glon,currlat,currlon);

% calculate path angle, perpendicular (assume 90 CCW of path); in degrees CCW from E
pathang=atan2(yy(end)-yy(end-1),xx(end)-xx(end-1)); perppathang=pathang+pi/2;

% calculate velocity angle, perpendicular
vx=load([localdir,glider,'_water_vx.txt']); vy=load([localdir,glider,'_water_vy.txt']);
velang=atan2(vy(end),vx(end)); perpvelang=velang+pi/2;

% convert givendir (deg CW from N) to ang convention (deg CCW from E)
givenang=pi/2-degtorad*givendir;

% gather bearing angles and calculate 

%%%%%%%
angs=[perppathang perpvelang givenang];
angstrs=['perp to path';'perp to curr';'in given dir';'parallel_off'];

% some constants, plus a fixed array of points that will be rotated in directions perp to path/curr, in given dir
degtorad=pi/180;
s=ds:ds:nseg*ds; 

for i=1:length(angs)
  angstr=angstrs(i,:); transang=angs(i);
  
  % run out xseg,yseg from starting point at specified angle, ds 
  xseg=s*cos(transang);yseg=s*sin(transang);
  
  % convert back to lat/lon 
  [latseg,lonseg]=xy2ll(xseg,yseg,currlat,currlon);
  alllon(i,:)=lonseg; alllat(i,:)=latseg;

end

% create "safe" parallel offset version parallel to track at distoffset perp from current position; useful when being swept by strong currents so that waypoints sweep along with glider, so fewer updates are needed
s=dsoffset*(0:nseg-1); transang=perppathang; tweakang=-20;
xseg=distoffset*cos(transang)+(s-1)*cos(pathang+tweakang*degtorad); 
yseg=distoffset*sin(transang)+(s-1)*sin(pathang+tweakang*degtorad);
[latsafe,lonsafe]=xy2ll(xseg,yseg,currlat,currlon);

dstr=datestr(clock,'yyyymmddhhMM');

for i=1:4

  angstr=angstrs(i,:); angs(4)=angs(3); transang=angs(i);
  
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
  fprintf(fid,'%s\n','b_arg: list_when_wpt_dist(m) 3000');
  fprintf(fid,'%s\n','b_arg: initial_wpt(enum) -2 # closest');
  fprintf(fid,'%s\n',['b_arg: num_waypoints(nodim) ',num2str(nseg)]);
  fprintf(fid,'%s\n','<end:b_arg>'); fprintf(fid,'%s\n','');
  fprintf(fid,'%s\n','<start:waypoints>');
  fprintf(fid,'%9.3f %9.3f\n',[lonseg; latseg]);
  fprintf(fid,'%s\n','<end:waypoints>');
  fclose(fid);

end



%% plot up
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

