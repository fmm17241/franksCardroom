function coh = Coherence_whelch_overlap(datainA,datainB,samplinginterval,bins,windoww,DT,cutoff)

%Coherence_whelch_overlap(datainA, datainB, samplinginterval, bins, windoww, DT, cutoff)
%function to find the coherence between two different vectors, "datainA" and "datainB",
%at various frequencies.
%
%The vectors are time series with a sampling interval given by
%"samplinginterval", and the frequencies will be reported in the inverse of
%the units in which this variable is given.
%
%"Bins" is the number of non-overlapped data sub-blocks that fit into the overall record length.
%(The time series is divied up into smaller sub-units (bins), the spectra of each unit (bin) is
%calculated, and then all the speactra from the different units (bins) are averaged together.)
%This rountine overlaps the bins by one half of their length, so that each data data point gets used
%more than once.  This fact is accounted for in the statistics output with the results.
%
%If "windoww" equal 1, the individual data sub-blocks (bins) are windowed with a Hanning window.
%If "DT" equal 1, a linear trend is removed from each sub-block of the data before it is windowed
%and fft-ed.
%
%Any NaNs in the data are replaced as follows:
%If "cutoff" = 0, the vector's mean replaces the NaNs.
%If "cutoff" not equal zero, NaNs are replaced with low-passed white noise with mean and
%variance of the remaining data and half power point of "cutoff." "Cutoff" is
%expressed as a non-dimensional multiple of the sampling interval.  To
%leave white noise unfiltered, set "cutoff" = 2.
%
%This routine is based on Bendat and Piersol, Engineering Applications, Chapter 3
%And Numerical Recipes, Fast Fourier Transform, Chapter 12

N = length(datainA);
if rem(N,2) ~= 0
    datainA(end)=[];
    datainB(end)=[];
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
dumdataB = denan(aa,datainB(1+(n-1)*k/2:(n+1)*k/2),cutoff);   

if DT == 1
dumdataA = detrend(dumdataA);%take out trend
dumdataB = detrend(dumdataB);
else
dumdataA = dumdataA-mean(dumdataA);%take out the mean
dumdataB = dumdataB-mean(dumdataB);   
end

if windoww == 1
dumdataA = dumdataA.*hamming(k).*((8/3)^0.5);%window sub-blocks and account for loss of power 
dumdataB = dumdataB.*hamming(k).*((8/3)^0.5);%with windowing
end

spectraAdum = fft(dumdataA)*samplinginterval;%The dimensional fourier transform of the A sub-blocks
spectraBdum = fft(dumdataB)*samplinginterval;% " " B sub-blocks

    
spectraA(:,n) = spectraAdum.*conj(spectraAdum);%The spectral power of the A sub-blocks
spectraB(:,n) = spectraBdum.*conj(spectraBdum);% " " B sub-blocks

cospectra(:,n) = conj(spectraAdum).*spectraBdum;%The dimesnional co-spectral power
end

spectraA2 =  mean(spectraA.',1); %Average the sub-blocks together at each frequency
spectraB2 =  mean(spectraB.',1);
cospectra2 = mean(cospectra.',1);

%The "frequencies" are [0:(length(data)-1)]/length(data)/(sampling_interval).
dataout(:,1) = [0:k-1]'/k/samplinginterval;

dataout(:,2) = real(spectraA2).';%The power in datainA, averaged over sub-blocks
dataout(:,3) = real(spectraB2).';%The power in datainB, averaged over sub-blocks
dataout(:,4) = cospectra2.';     %The co-spectral power of A and B
dataout(:,5) = (dataout(:,4).*conj(dataout(:,4)))./dataout(:,2)./dataout(:,3);%The coherence of A and B
dataout(:,6) = atan2(-imag(dataout(:,4)),real(dataout(:,4)));%The phase


dataout(k/2+2:end,:) = []; %get rid of negative frequencies to make plotting easier
%1/2/samplinginterval is the Nyquist frequency, or dataout(N/2+1,1)

dataout(:,2:4) = 2*dataout(:,2:4);  %The one-sided spectra
dataout(:,2:4) = dataout(:,2:4)/(k*samplinginterval);%Scale power such that the integral of the power
%will equal the variance of the data. In other words, divide the power by the total time of sub-blocks.


if windoww == 1%Modify the number of independent measurements in confidence limits
               %to account for overlapping (see Harris, Proceedings of the IEEE, 1978)
    c = 0.167;%Hanning window
else
    c = 0.50;%Boxcar
end
s = overlaps;
ss = 1/s*(1 + 2*c^2) - 2/(s^2)*(c^2);
Nd = 1/ss; %This is the effective number of data blocks that get ffted, in the statistical sense.

dataout(:,7) = (2/Nd*dataout(:,5).*((1 - dataout(:,5)).^2)).^0.5; %This is the std of the coherence.
dataout(:,8) = (1/2/Nd*(1 - dataout(:,5))./dataout(:,5)).^0.5; %This is the std of the phase, in radians
dataout(1,5:8) = 0; %set the coherence and phase of mean (zero frequency) to zero 


%The point where the coherence becomes significantly different from zero can be calculated
%using the formula: gamma^2 - 2*sigma = 0.  Here gamma^2 is the coherence and sigma is its std.
%If sigma is known in terms of gamma, the above equation can be solved for a threshold for gamma^2.
r95 = roots([1 (Nd^0.5)/(2^1.5) -1 0]);
r68 = roots([1 (Nd^0.5)/(2^0.5) -1 0]);
ff  = find((r95>=-1) & (r95<=1) & (r95~=0));
threshold95 = r95([ff])^2;
FF =  find((r68>=-1) & (r68<=1) & (r68~=0));
threshold68 = r68([FF])^2;

%The confidence limits can also be calculated using Goodman's formula, see
%RORY Thompson, J. of Atmos. Sci., 1979.

c2_68 = 1 - (1-0.6827)^(1/(Nd-1));
c2_95 = 1 - (1-0.9545)^(1/(Nd-1));
c2_99 = 1 - (1-0.9973)^(1/(Nd-1));

dataout(1,9) = threshold68;%This is the point where the coherence becomes statistically different
                           %from zero to the 68 percent confidence limit, from Bendat formula
dataout(2,9) = c2_68;      %68 limit from Goodman formula
dataout(3,9) = threshold95;%To the 95 percent confidence limit from Bendat formula
dataout(4,9) = c2_95;      %95 limit from the Goodman formula
dataout(5,9) = c2_99;      %99 limit from the Goodman formula
dataout(6,9) = Nd;         %This is the effective number of data blocks that get ffted,
                           %in the statistical sense.
dataout(7,9) = trapz(dataout(:,1),dataout(:,2));%The variance in A
dataout(8,9) = trapz(dataout(:,1),dataout(:,3));%The variance in B

coh.f=dataout(:,1);
coh.psda=dataout(:,2);
coh.psdb=dataout(:,3);
coh.cspd=dataout(:,4);
coh.coh=dataout(:,5);
coh.phase=dataout(:,6);
coh.cohstd=dataout(:,7);
coh.phstd=dataout(:,8);
coh.pr68bendat=dataout(1,9);
coh.pr68gdmn=dataout(2,9);
coh.pr95bendat=dataout(3,9);
coh.pr95gdmn=dataout(4,9);
coh.pr99gdmn=dataout(5,9);
coh.nblocks=dataout(6,9);
coh.varA=dataout(7,9);
coh.varB=dataout(8,9);

end


