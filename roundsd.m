
	function out=roundsd(in,nsd);
%
%	Simple function to round number to certain number of decimal places.
%		
%	out=roundsd(in,nsd);
%
% Calls: none
%
% Catherine R. Edwards
% Last modified: 21 Jan 2002

if(nargin~=2)
  error('Incorrect number of input arguments');
end

nsd10=10^(nsd);
out=round(nsd10*in)/nsd10;

