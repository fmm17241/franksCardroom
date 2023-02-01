
 function cabserr = cabs(A);
%
% Calls: none
 
 sA=size(A);
 eye=sqrt(-1);
 if(sA(2)~=2); error('Input must be 2xN'); end
 cabserr=abs(A(:,1)+eye*A(:,2));
 
