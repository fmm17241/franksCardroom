clc;clear;
 
% Set problem
g=9.8; % gravity constant
R=6400000; % Earth radius
omega=2*pi/(24*60*60); % Earth rotation angle velocity
eta=peaks(50)/100; % Sea surface height in each point
 
% Set grid
x=linspace(-80.82,-80.91,50);
y=linspace(31.35,31.4,50);
[x y]=meshgrid(x,y);
x=x';y=y';
 
% Set Coriolis force coefficients
f=2*omega*sind(y);
 
% Visualization of sea surface height
pcolor(x,y,eta)
shading flat
 
u=zeros(size(eta));
v=zeros(size(eta));
 
% Calculate geostrophic current using numerical method
for i=2:size(x,2)-1
    for j=2:size(y,1)-1
        dx=(x(i+1,j)-x(i-1,j))*(R*cosd(y(i,j))*pi/180);
        dy=(y(i,j+1)-y(i,j-1))*(R*pi/180);
        u(i,j)=-g/f(i,j)*(eta(i,j+1)-eta(i,j-1))/dy;
        v(i,j)=g/f(i,j)*(eta(i+1,j)-eta(i-1,j))/dx;
    end
end

% Geostrophic current visualization
hold on
quiver(x,y,u,v,2,'k')
title('Calculated geostrophic current using numerical method','fontweight','bold')
xlabel('longitude','fontweight','bold')
ylabel('latitude','fontweight','bold')
set(gcf,'color','w')

print(gcf,'geocurrent2','-dpng')
