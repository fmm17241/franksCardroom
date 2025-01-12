%McQuarrie 2021
%Breaking down glider adventures into separate "yos", dives and climbs, to
%find separate profiles.


function [yoSSP,yotemps,yotimes,yodepths,yosalt,yospeed] = yoDefiner(dn, depth, temperature, salt, speed)



inflectionsBot = islocalmax(depth,'MinProminence',3,'MinSeparation',3,'FlatSelection','first');
indexbot    = find(inflectionsBot);
% yobotdepth = depth(inflectionsBot);
% yobottime = dn(inflectionsBot);

inflectionsTop = islocalmin(depth,'MinProminence',3,'MinSeparation',3,'FlatSelection','first');
indextop = find(inflectionsTop);
% yotopdepth = depth(inflectionsTop);
% yotoptime = dn(inflectionsTop);

yotemps=cell(1,1);
yotimes=cell(1,1);
yodepths=cell(1,1);
yosalt=cell(1,1);
yospeed=cell(1,1);
yoSSP=cell(1,1);



howmany = length(indextop);
for k = 1:howmany
    test = indexbot(indextop(k)<indexbot);
    useindex = test(1);
    yotemps{k} = temperature(indextop(k):useindex);
    yotimes{k} = dn(indextop(k):useindex);
    yodepths{k} = depth(indextop(k):useindex);
    yosalt{k} = salt(indextop(k):useindex);
    yospeed{k}  = speed(indextop(k):useindex);
    yoSSP{k}    =[yotimes{k},yodepths{k},yospeed{k}];   
end
end
