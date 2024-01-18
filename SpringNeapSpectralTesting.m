%Frank tried FFTs in powerAnalysis, now I want to compare
% at different tides. We'll see, IDK anymore.

% Load in data to plot
buildReceiverData

%%
% Find Spring/Neap cycle. I want to find chunks of time where the tides
% were strong and weak.
figure()
plot(receiverData{1}.DT,receiverData{1}.crossShore)
ylabel('X-Shore (m/s)')
title('Finding Strong and Weak Tides')


%Winter weak: weak weak tides Feb 29 - Mar 04
weaksignalWDT = receiverData{1}.DT(728:847);
weaksignalW = receiverData{1}.crossShore(728:847);
weakWinter = receiverData{1}(728:847,:);
%Winter Strong: Mar 8 - Mar 12
strongsignalWDT = receiverData{1}.DT(920:1039);
strongsignalW = receiverData{1}.crossShore(920:1039);
strongWinter = receiverData{1}(920:1039,:);
%Summer Weak: weak weak tides Aug 8 - Aug 15
%Summer strong: Jun 03 - Jun 07
strongsignalSDT = receiverData{1}.DT(3008:3127);
strongsignalS = receiverData{1}.crossShore(3008:3127);
strongSummer = receiverData{1}(3008:3127,:);
%Summer weak: Jul 12 - Jul 16
weaksignalSDT = receiverData{1}.DT(3224:3343);
weaksignalS = receiverData{1}.crossShore(3224:3343);
weakSummer = receiverData{1}(3224:3343,:);
%Summer middle: Jul 20 - Jul 25
%Weak: Sep 8 - Sep 13



figure()
plot(receiverData{1}.DT,receiverData{1}.crossShore,'k')
hold on
plot(weaksignalWDT,weaksignalW,'r')
plot(strongsignalWDT,strongsignalW,'b')
plot(strongsignalSDT,strongsignalS,'b')
plot(weaksignalSDT,weaksignalS,'r')
ylabel('X-Shore (m/s)')
title('Finding Strong and Weak Tides')


situationArray = [{weakWinter};{weakSummer};{strongWinter};{strongSummer}]
arrayDescrip = [{'Winter, Weak tides'};{'Summer, Weak tides'};{'Winter, Strong tides'};{'Summer, Strong tides'}];


%%
% Okay: FFT from strong and weak tides
for COUNT = 1:length(situationArray)
    detectionStruct{COUNT} = Power_spectra(situationArray{COUNT}.HourlyDets',1,1,0,3600,0)
    noiseStruct{COUNT} = Power_spectra(situationArray{COUNT}.Noise',1,1,0,3600,0)
    tideStruct{COUNT} = Power_spectra(situationArray{COUNT}.crossShore',1,1,0,3600,0)
end


figure()
tiledlayout(length(detectionStruct),1)
for COUNT = 1:length(detectionStruct)
    nexttile()
    plot(detectionStruct{COUNT}.f*86400,detectionStruct{COUNT}.psdw)
    % xlim([0.7 12])
    set(gca,'XScale','log')
    set(gca,'YScale','log')
    title(sprintf('FFT Analysis: Detections, %s',arrayDescrip{COUNT}),'No Window, Detrended')
    % ylim([0 18000000000])
    xlim([0 6])
end

figure()
tiledlayout(length(situationArray),1)
for COUNT = 1:length(situationArray)
    nexttile()
    plot(noiseStruct{COUNT}.f*86400,noiseStruct{COUNT}.psdw)
    % xlim([0.7 12])
    set(gca,'XScale','log')
    set(gca,'YScale','log')
    title(sprintf('FFT Analysis: Noise, %s',arrayDescrip{COUNT}),'No Window, Detrended')
    % ylim([0 20000000000000])
    xlim([0 6])
end

figure()
tiledlayout(length(situationArray),1)
for COUNT = 1:length(situationArray)
    nexttile()
    plot(tideStruct{COUNT}.f*86400,tideStruct{COUNT}.psdw)
    % xlim([0.7 12])
    set(gca,'XScale','log')
    set(gca,'YScale','log')
    title(sprintf('FFT Analysis: X-Shore Tides, %s',arrayDescrip{COUNT}),'No Window, Detrended')
    % ylim([0 2000000000])
    xlim([0 6])
end



%%
%FRANK FIND UNITS, SPEND ALL NIGHT FIGURING OUT THE FUCKING UNITS PLEASE






