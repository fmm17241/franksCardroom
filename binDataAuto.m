function [matstruct] = binDataAuto(sstruct)

% load fstruct/sstruct; fstruct only needed for lat/lon, so can use small version
% compute depth, salnity, density
sstruct.sci_water_cond(sstruct.sci_water_cond<3)=nan;

%mean latitude for near Gray's Reef
latmean = 31.3960;
sstruct.sci_depth=sw_dpth(sstruct.sci_water_pressure*10,latmean);
sstruct.sci_water_salin=sw_salt(10*sstruct.sci_water_cond/sw_c3515,sstruct.sci_water_temp,sstruct.sci_water_pressure*10); 
sstruct.sci_water_rho=sw_dens(sstruct.sci_water_salin,sstruct.sci_water_temp,sstruct.sci_water_pressure); 

% specify delta-t and delta-z, set up time and space vectors to cover data
dt=1/24; dndn=ceil(min(sstruct.dn)):dt:max(sstruct.dn); 
dz=1; maxz=30;  zz=0:dz:maxz; zz(1)=-eps;    			% use -eps so that the bin edge includes 0

% get bin centers
dnmean=(dndn(2:end)+dndn(1:end-1))/2; zmean=(zz(2:end)+zz(1:end-1))/2; 

% find nans on CTD -- the code doesn't nanmean properly
notnans=find(~isnan(sstruct.sci_water_temp));
[temp,yb,ystd,nnall]=bindata2_old(sstruct.sci_water_temp(notnans),sstruct.dn(notnans),sstruct.sci_depth(notnans),dndn,zz);
[salin,yb,ystd,nnall]=bindata2_old(sstruct.sci_water_salin(notnans),sstruct.dn(notnans),sstruct.sci_depth(notnans),dndn,zz);
[rho,yb,ystd,nnall]=bindata2_old(sstruct.sci_water_rho(notnans),sstruct.dn(notnans),sstruct.sci_depth(notnans),dndn,zz);

% create 2d arrays of time, vertical dimension
[dn,z]=meshgrid(dnmean,zmean);

% test plot
figure; h1=pcolor(dn,z,temp'); shading interp; colorbar; set(gca,'ydir','reverse'); datetick('x','keeplimits');

% can get fancy and bin data just in upper 40m, then 40-200m
[salin40m,yb,ystd40,nn40]=bindata2_old(sstruct.sci_water_salin(notnans),sstruct.dn(notnans),sstruct.sci_depth(notnans),dndn,[-eps 40 200]);

% upper 1m and everything else, etc. 
[salin10m,yb,ystd10,nn10]=bindata2_old(sstruct.sci_water_salin(notnans),sstruct.dn(notnans),sstruct.sci_depth(notnans),dndn,[-eps 10 200]);

%% create output structure; note all variables are NTxNZ, NTx1, or 1xNZ
matstruct.dn=dnmean';
matstruct.dt=datetime(matstruct.dn,'ConvertFrom','datenum');
matstruct.z=zmean;
matstruct.dn2d=dn'; matstruct.z2d=z'; 
matstruct.lon=lon'; matstruct.lat=lat';
matstruct.temp=temp;
matstruct.salin=salin;
matstruct.rho=rho;
matstruct.speed = sndspd(matstruct.salin,matstruct.temp,matstruct.z);
end

