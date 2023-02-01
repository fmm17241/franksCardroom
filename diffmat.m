	
function [dfdx,dfdy]=diffmat(matf,deltax,deltay);

% DIFFMAT.M -- routine used to differentiate a 2D matrix with respect
%	to regularly spaced x,y
%
%	diffmat.m uses central difference method, with forward/backward
%	difference methods on edges, as appropriate, and is [O(h^2)]
%
%	[dfdx,dfdy]=diffmat(u,deltax,deltay);
%
%	DIFFMAT requires the following arguments:
%		matf	  - a 2D field matrix, with x increasing with columns
%			    and y decreasing with rows, specified by
%			    a regularly spaced finite difference grid
%		deltax/   - specify grid spacing of input matrix
%		deltay      matf
%
%	output vars
%		dfdx,dfdy - the derivative of matrix matf wrt x,y
%
% Calls: none
%
%  Last modified:  19 Mar 1999
%  Catherine Edwards
%
%

dims=size(matf);

% central difference portion - build by shifting matrices

shiftxp1 = [matf(:,dims(2)) matf(:,1:dims(2)-1)]; 
shiftxp1(:,1)=0;

shiftxm1 = [matf(:,2:dims(2)) matf(:,1)];
shiftxm1(:,dims(2))=0;

shiftyp1 = [matf(2:dims(1),:); matf(1,:)];
shiftyp1(dims(1),:)=0;

shiftym1 = [matf(dims(1),:); matf(1:dims(1)-1,:)];
shiftym1(1,:)=0;

% central difference x 

dfdx = shiftxm1-shiftxp1;
dfdy = shiftym1-shiftyp1;

% zero out edges where central difference is not valid (for testing purposes)
% dfdx(:,1)=0; dfdx(:,dims(2))=0;
% dfdy(1,:)=0; dfdy(dims(1),:)=0;

% forward difference x on LH edge
dfdx(:,1)=-3*matf(:,1)+4*matf(:,2)-matf(:,3);
% backward difference x on RH edge
dfdx(:,dims(2))=matf(:,dims(2)-2)-4*matf(:,dims(2)-1)+3*matf(:,dims(2));
% forward difference y on bottom edge
dfdy(dims(1),:)=-3*matf(dims(1),:)+4*matf(dims(1)-1,:)-matf(dims(1)-2,:);
% backward difference y on top edge
dfdy(1,:)=matf(3,:)-4*matf(2,:)+3*matf(1,:);

% multiply out at end by 1/(2deltax),1/(2deltay) 

dfdx=0.5*dfdx/deltax;
dfdy=0.5*dfdy/deltay;

return;
