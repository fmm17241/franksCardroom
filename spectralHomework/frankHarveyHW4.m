cd 'C:\Users\fmm17241\OneDrive - University of Georgia\harveyNotes\hwdata'


load hw4_data.mat


dateArray = [year', month', day', hour', minute', second'];

%30 Day Chunk
DT = datetime(dateArray); DN = datenum(DT); %Full 30 days


%HW tells me to use csd but matlab says use CPSD, and "detrend".
%HW also mentioned cohere


figure()
tiledlayout(2,1,'TileSpacing',"compact")
ax1 = nexttile()
plot(DT,ubr,'b')
title('Cross-Shore')
ax1 = nexttile()
plot(DT,vbr,'--k')
ylim([-0.4 0.4])
title('Along-Shore')

figure()
plot(DT,ubr,'b')
hold on
plot(DT,vbr,'--k')
legend('Cross','Along')

xShoreFreq = fft(ubr)

aShoreFreq = fft(vbr)
N = length(DT);
df = 1/N;
f = df* (0:length(DT)-1);

figure()
tiledlayout(2,1,'TileSpacing','compact')
ax1 = nexttile()
plot(f,abs(xShoreFreq)/length(DT),'k')
hold on
plot(f,abs(aShoreFreq)/length(DT),'--b')
xlabel('Frequency')
ylabel('Spectrum')

ax2 = nexttile()
plot(f,abs(xShoreFreq.*aShoreFreq)/length(DT)^2,'k')
ylabel('Co-Spectrum')




% Cross-shore velocity component
[xShoreCPSD, F] = cpsd(ubr,temp)

figure()
plot(F,angle(xShoreCPSD)/pi)
hold on

set(gca,'XScale','log')
set(gca,'YScale','log')

% Along-shore velocity component
[aShoreCPSD, F] = cpsd(vbr,temp)


figure()
plot(F,angle(aShoreCPSD)/pi,'r')
set(gca,'XScale','log')
set(gca,'YScale','log')




% data, bins, detrend?,window?,smpInterval(secs),cutoff,
PS = Power_spectra(ubr,40,0,1,1,0)

