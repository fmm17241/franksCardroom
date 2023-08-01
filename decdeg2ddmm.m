function ddmm=decdeg2ddmm(decdeg);
%
%	DECDEG2DDMM converts GPS style lat/lon DDMM.MMMM
%		to decimal degrees DD.DDDD, handles +/-
%
% 	ddmm=decdeg2ddmm(decdeglon);
%
%	DDMM2DECDEG is the inverse function
%
% CRE 11/20/2013: clarified sign

decdegsign=sign(decdeg); decdegval=abs(decdeg);

dd=fix(decdegval); mm=(decdegval-dd)*60;

ddmmval=100*dd+mm; ddmm=decdegsign.*ddmmval;
