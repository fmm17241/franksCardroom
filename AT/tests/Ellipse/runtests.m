% Elliptic Bottom test
% mbp 2/09 based on a test case created by Dianna McCammon

global units
units = 'km';
%%
% linear boundary interpolation

make_bdry( 'L' )

% the rays:
bellhop Ellipse
figure; plotray Ellipse
plotati 'Ellipse'   % superimpose an altimetry plot
plotbty 'Ellipse'   % superimpose a bathymetry plot

% TL: Geometric ray theory
copyfile( 'Ellipse.bty', 'EllipseTLGeom.bty' );
copyfile( 'Ellipse.ati', 'EllipseTLGeom.ati' );
bellhop EllipseTLGeom

plotshd( 'EllipseTLGeom.shd', 2, 1, 1 )
caxisrev( [ 60 100 ] )
plotati 'Ellipse'   % superimpose an altimetry plot
plotbty 'Ellipse'   % superimpose a bathymetry plot

% TL: Gaussian beams
copyfile( 'Ellipse.bty', 'EllipseTLGB.bty' );
copyfile( 'Ellipse.ati', 'EllipseTLGB.ati' );
bellhop EllipseTLGB

plotshd( 'EllipseTLGB.shd', 2, 1, 2 )
caxisrev( [ 60 100 ] )
plotati 'Ellipse'   % superimpose an altimetry plot
plotbty 'Ellipse'   % superimpose a bathymetry plot

%%
% curvilinear boundary interpolation

make_bdry( 'C' )

% the rays:
bellhop Ellipse

figure; plotray Ellipse
plotati 'Ellipse'   % superimpose an altimetry plot
plotbty 'Ellipse'   % superimpose a bathymetry plot
%print -depsc EllipseC

% TL: Geometric ray theory
copyfile( 'Ellipse.bty', 'EllipseTLGeom.bty' );
copyfile( 'Ellipse.ati', 'EllipseTLGeom.ati' );
bellhop EllipseTLGeom

plotshd( 'EllipseTLGeom.shd', 2, 1, 1 )
caxisrev( [ 60 100 ] )
plotati 'Ellipse'   % superimpose an altimetry plot
plotbty 'Ellipse'   % superimpose a bathymetry plot

% TL: Gaussian beams
copyfile( 'Ellipse.bty', 'EllipseTLGB.bty' );
copyfile( 'Ellipse.ati', 'EllipseTLGB.ati' );
bellhop EllipseTLGB

plotshd( 'EllipseTLGB.shd', 2, 1, 2 )
caxisrev( [ 60 100 ] )
plotati 'Ellipse'   % superimpose an altimetry plot
plotbty 'Ellipse'   % superimpose a bathymetry plot

