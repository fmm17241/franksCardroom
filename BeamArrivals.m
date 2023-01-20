
function [bottomarrivals,toparrivals]=Airports(location)
%Location should be in 'G:\blabla\' format
cd (location);
files = dir('*.arr');
howmany = length(files);
bottomarrivals= double(1:howmany);
toparrivals= double(1:howmany);
for k =1:length(files)
    file = files(k).name
    fid = fopen(file,'rt')
    c = textscan(fid, '%d','HeaderLines',5)
    bottomarrivals(k) = c{1,1}(1,1);
    toparrivals(k)    = c{1,1}(2,1);
end
x=1:howmany;
figure()
scatter(x,toparrivals,100,'r');
hold on
scatter(x,bottomarrivals,60,'b');
legend('Top Arrivals, 5m','Bottom Arrivals, 15m');
ylim([0 5])
xlabel('Individual Yo''s');
ylabel('Ray Arrivals');
saveas(gcf,'ArrivalsPlotted.jpeg')
end
