%Frank tried FFTs in powerAnalysis, now I want to compare
% at different tides. We'll see, IDK anymore.


%Running this after snapRateAnalyzer and snapRatePlotter, so I have nice
%variables and structures to work with.
% 
% receiverData : cell structure of environmental and detection data.
% 
% hourSnaps : hourly count of snaps at a certain threshold, 1000U if not
% specified.
%
% 






% situationArray = [{weakWinter};{weakSummer};{strongWinter};{strongSummer}]
% arrayDescrip = [{'Winter, Weak tides'};{'Summer, Weak tides'};{'Winter, Strong tides'};{'Summer, Strong tides'}];


%%
% Okay: FFT from strong and weak tides
% for COUNT = 1:length(situationArray)
%     detectionStruct{COUNT} = Power_spectra(situationArray{COUNT}.HourlyDets',1,1,0,3600,0)
%     noiseStruct{COUNT} = Power_spectra(situationArray{COUNT}.Noise',1,1,0,3600,0)
%     tideStruct{COUNT} = Power_spectra(situationArray{COUNT}.crossShore',1,1,0,3600,0)
% end
% 
% 
% figure()
% tiledlayout(length(detectionStruct),1)
% for COUNT = 1:length(detectionStruct)
%     nexttile()
%     plot(detectionStruct{COUNT}.f*86400,detectionStruct{COUNT}.psdw)
%     % xlim([0.7 12])
%     % set(gca,'XScale','log')
%     % set(gca,'YScale','log')
%     title(sprintf('FFT Analysis: Detections, %s',arrayDescrip{COUNT}),'No Window, Detrended')
%     ylim([0 20000000000])
% end







