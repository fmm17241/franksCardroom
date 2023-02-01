function distsq=sqdist(xvals)
%
% distsq=sqdist(xvals) creates a matrix of squared distances between
% points, from a matrix xvals of coordinates of the points, one in each row
%
%
% Calls: none
ntot=size(xvals,1);
%
% vectorized approach to calculate the matrix of distances
% |a-b|^2=(a.a)+(b.b)-2(a.b)
%
dotab=xvals*xvals';
dotaa=repmat(diag(dotab),1,ntot);
%dotbb=dotaa';
distsq=max(dotaa+dotaa'-2.*dotab,0); %ensure it is non-negative
return
