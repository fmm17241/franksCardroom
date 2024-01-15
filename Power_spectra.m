function dataout=Power_spectra(datainA,bins,DT,windoww,samplinginterval,cutoff)

%-------------------------------------------------------------------------
% Instructions:
%
% Function returns power spectra of input
% dataout=Power_spectra(datainA,bins,DT,windoww,samplinginterval,cutoff)
%==========================================================================


%Cut length of data set to make even---------------------------------------

P=0.95;%confidence interval;

N = length(datainA);
if rem(N,2) ~= 0
    datainA(end)=[];
end
N = length(datainA); 

k = floor(N/bins);%This is the length of the sub-blocks to be ffted, in elements
overlaps = 2*bins-1;%This is the number of sub-blocks that get ffted


%Make sure sub-sets to be fft-ed are even in length 
if rem(k,2) ~= 0 
     %disp('number of elements in sub-blocks to be fft-ed must be even in length, break program')
     k = k - 1;  
end


if cutoff == 0
    aa = 2;
else 
    aa = 3;
end

for n = 1 : overlaps

    dumdataA = denan(aa,datainA(1+(n-1)*k/2:(n+1)*k/2),cutoff);%define sub-blocks to be ffted
    
    if DT == 1
    dumdataA = detrend(dumdataA);%take out trend
    else
    dumdataA = dumdataA-mean(dumdataA);%take out the mean
end

if windoww == 1
dumdataA = dumdataA.*hamming(k)'.*((8/3)^0.5);%window sub-blocks and account for loss of power 
end

spectraAdum = fft(dumdataA)*samplinginterval;%The dimensional fourier transform of the A sub-blocks
  
spectraA(:,n) = spectraAdum.*conj(spectraAdum);%The spectral power of the A sub-blocks

end

spectraA2 =  mean(spectraA.',1); %Average the sub-blocks together at each frequency
spectraA3 = var(spectraA.',1);

%--------------------------------------------------------------------------

%The "frequencies" are [0:(length(data)-1)/length(data)/(sampling_interval).

f = (0:k-1)'/(k*samplinginterval);
   
%--------------------------------------------------------------------------

%Compile spectra and frequencies for output and remove negative frequencies

s = real(spectraA2).';%The power in datainA, averaged over sub-blocks
v = real(spectraA3).';

f(k/2+2:end) = [];
s(k/2+2:end)=[];
v(k/2+2:end)=[];%get rid of negative frequencies to make plotting easier
%1/2(samplinginterval) is the Nyquist frequency, or dataout(N/2+1,1)


dataout.f = f;
dataout.s = 2.*s./(k*samplinginterval);
dataout.psdf = 2.*s./f;
dataout.psdw = 2.*s/(2*pi);
dataout.psdT = f.*(2*s/(k*samplinginterval));
dataout.v=v;
dataout.vw = v/(2*pi);
dataout.vT = f.*(2*v/(k*samplinginterval));
%Scale power such that the integral of the power will equal the variance of the data. %
% In other words, divide the power by the total time in subblocks. Multiply by 2 for one-sided spectra.

%Confidence Intervals using chi-squared approach
for i=1:length(f)
Nstar=k.*samplinginterval.*f(i);
alpha2 = (1-P)/2;
conf(i,:) = Nstar./chi2inv([alpha2,1-alpha2],Nstar);
end


dataout.conf=conf;

end
%--------------------------------------------------------------------------

