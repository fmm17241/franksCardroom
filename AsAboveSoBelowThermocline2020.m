% Finding if the glider was above or below the perceived pycnocline when
% it hears a detection. Name in reference to Flemel's philosopher's stone.
% Use this after running the regular processes
% (vemprocess,detectionprocess,sortbypingsfunction,Bindata)


templength = length(matstruct.temp);
depthdiff = [];

for k = 1:templength
    once = diff(matstruct.temp(k,:))
    [Tupac,depthy] = max(once);
    twice(k)   = Tupac;
    if Tupac <= 0.005
       depthdiff(k) = 0;
       continue
    end
    depthdiff(k) = matstruct.z(depthy);
end






%got depth of thermocline, now I need to find if glider was above or below.
%After talking with Dr. Edwards and Woodson, considering keeping depthdiff
%at 0 if the max temp difference is less than 0.005 C. 

many = length(transmitters.id);

for hp = 1:many
    currentdn = transmitters.DN(hp);
    [~,importe]   =  min(abs(matstruct.dn-currentdn));
    roundeddetzdn(hp) = matstruct.dn(importe);
    roundeddetzdt(hp) = matstruct.dt(importe);
    roundeddetzz(hp)  = transmitters.depth(hp);
    roundeddepthdiff(hp) = depthdiff(importe);
end


AASBindex = roundeddetzz> roundeddepthdiff;
count = nnz(AASBindex);

belowz = roundeddetzz(AASBindex);
abuvz  = roundeddetzz(~AASBindex);



figure()
plot(matstruct.dt,depthdiff)
set(gca, 'YDir','reverse')
set(gca,'color','k')
title('Detections Compared to Depth of Thermocline');
ylabel('Depth, m');
xlabel('Mission, hours');
hold on
scatter(roundeddetzdt(AASBindex),belowz,'w*');
scatter(roundeddetzdt(~AASBindex),abuvz,'r*');
hold off



