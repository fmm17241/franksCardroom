
	function rootms=rms(vals,theoval)
%
%
%	RMS requires the following arguments:
%		vals    - [MxN] matrix of values to be computed
%		theoval - [Mx1] the values to which vals are compared
%
%	OUTPUT VARS
%		rootms  - the root mean square deviation from the theoval
%
%
% Calls: none
%
%	Catherine Edwards
%	last modified 30 Nov 1998
%

[M,N] = size(vals);
bigtheo=repmat(theoval,1,N);

rootms=nanstd(vals-bigtheo);

return;
