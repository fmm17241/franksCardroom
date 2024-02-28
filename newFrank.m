%Frank needs to focus on FS17 and 33OUT and the relationship between


mooredEfficiency
%We're looking at {11}, FS17 hearing STSNew1
% stationWindsAnalysis
buildReceiverData

clearvars -except receiverData hourlyDetections mooredReceivers oneDrive githubToolbox
close all

sunkenReef = receiverData{5};
flatReef   = receiverData{4};

hillToSunken = hourlyDetections{11};
hillToFlat   = hourlyDetections{14};

clearvars -except sunkenReef flatReef hillTo* oneDrive githubToolbox
close all

%Okay. Two scenarios to compare, quantitatively
sunkenLM = fitlm(sunkenReef.windSpd,sunkenReef.Noise)
flatLM   = fitlm(flatReef.windSpd,flatReef.Noise)

sunkenLM = fitlm(sunkenReef.Temp,sunkenReef.Noise)
flatLM   = fitlm(flatReef.Temp,flatReef.Noise)




figure()
plot(sunkenReef.DT,sunkenReef.Temp)