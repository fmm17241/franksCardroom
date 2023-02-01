%
% RMS computes the rms value of a vector (or columns of matrix)
% sigdig is an optional argument which sets the number of significant
%  digits for the output
% 
% [output] = sigrms(input,sigdig)
%
% Calls: none
%
% Charles Hannah Jan 1997

function [output] = sigrms(input,sigdig)

output = sqrt(mean(input.*conj(input)));

if nargin==2
   factor=10^sigdig;
   output=round(factor*output)/factor;
end 
%
%
