

function [dn,temperature,salt,density,depth,speed]=beautifyData(data)

temperature=data.data(:,4); %degC
cond=data.data(:,2); %S/m
rawpressure=data.data(:,3); %bar
pressure = rawpressure*10;  %converts pressure

%mean latitude for near Gray's Reef, this can change for other places
latmean = 31.3960;
depth = sw_dpth(pressure,latmean);% depth, m

rt=data.data(:,1); %seconds after some time
  
salt=sw_salt(10*cond/sw_c3515,temperature,pressure);
density=sw_dens(salt,temperature,pressure);

% convert rt into datenum style
dn=rt/3600/24+datenum(1970,1,1,0,0,0);

%Mckenzie's eqtn for soundspeed (m/s)
speed = Sndspd(salt,temperature,depth);
end