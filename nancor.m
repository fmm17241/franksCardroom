
function corr = nancor(x,y)

% CORR calculates correlation.  

% For vectors, corr(x,y) returns the correlation of y with x.  
% For a vector x, matrix A, corr(x,A) returns the correlations 
%  of the columns of A with x.  
% For matrix A, corr(A) returns the correlation of A(:,2:end) with A(:,1).
%
% Divide by zero/NaN result indicates 2 equal timeseries
%
% Calls: math/nancorrcoef
%
% based on code by Cheryl Ann Blain, NRL
% enhanced by Catherine R. Edwards
% Last modified 21 Dec. 1999
% 

if nargin==1
  A=x;
end

if nargin==2
    x=x(:); y=y(:);
    A=[x y];
end

%test=prod(diag(nancov(A)));
%if test==0
%  corr = 0;
%  return
%else
   c=nancorrcoef(A);
   for i=1:size(A,2)-1
     corr(i)=c(1,i+1);
   end
%end
return
