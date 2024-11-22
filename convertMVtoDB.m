%%
% Frank converting millivolts to decibels as per Cimino et al 2018

function decibels = convertMVtoDB(V,Vo)

decibels = 20*log10(V/Vo)