%McQuarrie 2021
%Breaking down glider adventures into separate "yos", dives and climbs, to
%find separate profiles.


function [yoSSP,yotemps,yotimes,yodepths,yosalt,yospeed] = yoDefinerAuto(dn, depth, temperature, salt, speed)

difference=diff(depth);
[~,indexTop] = max(difference);
[~,indexBot] = max(depth);


% inflectionsBot = islocalmax(depth,'MinProminence',3,'MinSeparation',3,'FlatSelection','first');
% indexBot    = find(inflectionsBot);
% yobotdepth = depth(inflectionsBot);
% yobottime = dn(inflectionsBot);

% inflectionsTop = islocalmin(depth,'MinProminence',6,'MinSeparation',6,'FlatSelection','first');
% indexTop = find(inflectionsTop);
% yotopdepth = depth(inflectionsTop);
% yotoptime = dn(inflectionsTop);

yotemps = temperature(indexTop:indexBot);
yotimes = dn(indexTop:indexBot);
yodepths = depth(indexTop:indexBot);
yosalt = salt(indexTop:indexBot);
yospeed  = speed(indexTop:indexBot);
yoSSP    =[yotimes,yodepths,yospeed];   


end
