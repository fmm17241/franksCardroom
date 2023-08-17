function [gridpoints,gridrays,fullRays] = loadrayAuto( rayfil )

% Plot the RAYfil produced by Bellhop or Bellhop3D
% usage: plotray( rayfil )
% where rayfil is the ray file (extension is optional)
% e.g. plotray( 'foofoo' )
%
% for BELLHOP3D files, rays in (x,y,z) are converted to (r,z) coordinates
%
% MBP July 1999
%Bastardized by Frank McQuarrie, 2021

global units jkpsflag

if ( strcmp( rayfil, 'RAYFIL' ) == 0 && ~isempty( strfind(rayfil, '.ray' )) )
   rayfil = [ rayfil '.ray' ]; % append extension
end

% plots a BELLHOP ray file

fid = fopen( rayfil, 'r' );   % open the file
if ( fid == -1 )
   disp( rayfil );
   error( 'No ray file exists; you must run BELLHOP first (with ray ouput selected)' );
end

% read header stuff

TITLE       = fgetl(  fid );
FREQ        = fscanf( fid, '%f', 1 );
Nsxyz       = fscanf( fid, '%f', 3 );
NBeamAngles = fscanf( fid, '%i', 2 );

gridpoints     = (0.5:0.5:2000);
gridrays = NaN(1000,4000);


DEPTHT      = fscanf( fid, '%f', 1 );
DEPTHB      = fscanf( fid, '%f', 1 );

Type        = fgetl( fid );
Type        = fgetl( fid );

Nsx    = Nsxyz( 1 );
Nsy    = Nsxyz( 2 );
Nsz    = Nsxyz( 3 );

Nalpha = NBeamAngles( 1 );
Nbeta  = NBeamAngles( 2 );

% Extract letters between the quotes
nchars = strfind( TITLE, '''' );   % find quotes
TITLE  = [ TITLE( nchars( 1 ) + 1 : nchars( 2 ) - 1 ) blanks( 7 - ( nchars( 2 ) - nchars( 1 ) ) ) ];
TITLE  = deblank( TITLE );  % remove whitespace

nchars = strfind( Type, '''' );   % find quotes
Type   = Type( nchars( 1 ) + 1 : nchars( 2 ) - 1 );
%Type  = deblank( Type );  % remove whitespace

% read rays

% axis limits
rmin = +1e9;
rmax = -1e9;

zmin = +1e9;
zmax = -1e9;
% NansNsz
% this could be changed to a forever loop
for isz = 1 : Nsz
   for ibeam = 1 : Nalpha
      alpha0    = fscanf( fid, '%f', 1 );
      nsteps    = fscanf( fid, '%i', 1 );

      NumTopBnc = fscanf( fid, '%i', 1 );
      NumBotBnc = fscanf( fid, '%i', 1 );

      if isempty( nsteps ); break; end
      switch Type
         case 'rz'
            ray = fscanf( fid, '%f', [2 nsteps] );
            rray{Nsz} = ray;
            
            
            r = ray( 1, : );
            z = ray( 2, : );

            
         case 'xyz'
            ray = fscanf( fid, '%f', [3 nsteps] );
            
            xs = ray( 1, 1 );
            ys = ray( 2, 1 );
            r = sqrt( ( ray( 1, : ) - xs ).^2 + ( ray( 2, : ) - ys ).^2 );
            z = ray( 3, : );
      end
      
      if ( strcmp( units, 'km' ) )
         r = r / 1000;   % convert to km
      end
        [~,ind] = unique(r);
        gridrays(ibeam,:)=interp1(r(ind)',z(ind)',gridpoints,'linear');
      

   end	% next beam
end % next source depth
fclose( fid );

numberR = isfinite(gridrays(:,:));
fullRays   = sum(numberR,1);

end