function decdeg=ddmm2decdeg(ddmm);
%
%	DDMM2DECDEG converts GPS style lat/lon DDMM.MMMM
%		to decimal degrees DD.DDDD, handles +/-
%
% 	decdeglon=ddmm2decdeg(ddmmlon);
%
%	DECDEG2DDMM is the inverse function
%
% CRE 11/20/2013: clarified sign

ddmmsign=sign(ddmm); ddmmval=abs(ddmm);

dd=fix(ddmmval/100); mm=ddmmval-100*dd; decdegval=dd+mm/60;

decdeg=ddmmsign.*decdegval;
