function [Cxy,freq] = coher(mod,obs)
%
% Calls: none


[Cxy,f] = cohere(mod,obs,1024,1000)
pi   = acos(-1)
freq = 86400*f(2*pi)

end
return
