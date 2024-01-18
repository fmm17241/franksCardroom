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


%Winter weak: weak weak tides Feb 29 - Mar 05
receiverData{1}.DT(728-871);
%Winter Strong: Mar 8 - Mar 14
%Summer Weak: weak weak tides Aug 8 - Aug 15
%Summer strong: Jun 03 - Jun 09
%Summer weak: Jul 13 - Jul 17
%Summer middle: Jul 20 - Jul 25
%Weak: Sep 8 - Sep 13