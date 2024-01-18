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
%Winter Strong: Mar 8 - Mar 14
strongsignalWDT = receiverData{1}.DT(920:1087);
strongsignalW = receiverData{1}.crossShore(920:1087);
strongWinter = receiverData{1}(920:1087,:);
%Summer Weak: weak weak tides Aug 8 - Aug 15
%Summer strong: Jun 03 - Jun 08
strongsignalSDT = receiverData{1}.DT(3008:3151);
strongsignalS = receiverData{1}.crossShore(3008:3151);
strongSummer = receiverData{1}(3008:3151,:);
%Summer weak: Jul 12 - Jul 17
weaksignalSDT = receiverData{1}.DT(3224:3367);
weaksignalS = receiverData{1}.crossShore(3224:3367);
weakSummer = receiverData{1}(3224:3367,:);
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



%%
% Okay: FFT from strong and weak tides


