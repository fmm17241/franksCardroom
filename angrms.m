
	function angrootms=angrms(angs,theoang)
%
%
%	angrootms=angrms(angs,theoang)
%	
%	ANGRMS requires the following arguments:
%		angs    - array of values to be computed (deg)
%		theoang - the value to which angs are compared (deg)
%
%	OUTPUT VARS
%		angrootms  - the root mean square deviation from the 
%                            theoang (deg)
%
% Calls: math/diff360
%
%
%	Catherine Edwards
%	last modified 30 Nov 1998
%

%columnate input
[M,N] = size(angs);
theoang=repmat(theoang,1,N);

diffs = diff360(theoang,angs);

angrootms=nanstd(diffs);

return;

