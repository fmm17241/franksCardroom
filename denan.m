function dataout = denan(how,data,cutoff,smean,sstd)

%Function Denan(how,data,cutoff,smean,sstd)
%Function to remove any NaNs from vector data as prescribed by "how" switch.
%If "how" == 1, NaNs are removed and vector is shortened.
%If "how" == 2, NaNs are replaced with vector's mean.
%If "how" == 3, NaNs are replaced with low-passed normally-distributed white noise with mean
%and variance of remaining data and half-power period of "cutoff," expressed as a non-dimensional
%multiple of the sampling interval. For unfiltered white noise, set cutoff = 2.
%If "how" == 4, Nans are replaced with low-passed normally-distributed white noise with mean
%and std specified by input variables, where "std" can be zero.
%If data is a matrix, program operates on each column individually.


[rows,cols] = size(data);

if rows <= 1 %If data is a row-vector, transpose it, but also transpose output.
data = data.';
tt = 1;
else 
tt = 0;
end


[rows,cols] = size(data);   
   
for n = 1 : cols
ff = isnan(data(:,n));
ff = find(ff);

if length(ff) == rows
data(:,n) = data(:,n);
else
    
switch how
case 1
data(ff,:) = [];
case 2
dumdata = data(:,n);
dumdata(ff) = [];
mm = mean(dumdata);
data(ff,n) = mm;
case 3
dumdata = data(:,n);
dumdata(ff) = [];
m1 = mean(dumdata);
std1 = std(dumdata);
if length(ff) > 2
xx = randn(length(ff),1);
xxlow = lowpass(xx,min([cutoff length(ff)]));
m2 = mean(xxlow);
std2 = std(xxlow);
yy = std1/std2*xxlow - std1/std2*m2 + m1;
data(ff,n) = yy;
else
data(ff,n) = m1;
end
case 4
dumdata = data(:,n);
dumdata(ff) = [];
if length(ff) > 2
xx = randn(length(ff),1);
xxlow = lowpass(xx,min([cutoff length(ff)]),0);
m2 = mean(xxlow);
std2 = std(xxlow);
yy = sstd/std2*xxlow - sstd/std2*m2 + smean;
data(ff,n) = yy;
else
data(ff,n) = smean;    
end
end
end
end

dataout = data;

if tt == 1
    dataout = dataout.';
end