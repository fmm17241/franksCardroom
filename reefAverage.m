% cd G:/Moored
cd G:/Moored/
%Separate dets, temps, and noise by which receiver is giving the data
data = readtable('VUE_Export.csv');
%SWITCHED: BELOW LINES TAKES OUT TWO TRANSCEIVERS WHICH WERE NOT HEARD AT
%ALL, NOT EVEN BY THEMSELVES, HURTING AVERAGE FM 4/7/22
forbiddenReceivers = ['VR2Tx-483067';'VR2Tx-483068';'VR2Tx-483079';'VR2Tx-483080'];
data(ismember(data.Receiver,forbiddenReceivers),:)=[];
%
%%
dataDN = datenum(data.DateAndTime_UTC_);
uniqueReceivers = unique(data.Receiver);
for PT = 1:length(uniqueReceivers)
    tempIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Temperature');
    detectionIndex{PT,1} = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Detections on 69 kHz');
    noiseIndex{PT,1}     = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Average noise');
    pingIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Pings on 69 kHz');
    
    
    receiverData{PT}.bottomTemp(:,1) = dataDN(tempIndex{PT}); receiverData{PT}.bottomTemp(:,2) = data.Data(tempIndex{PT});
    receiverData{PT}.hourlyDets(:,1) = dataDN(detectionIndex{PT}); receiverData{PT}.hourlyDets(:,2) = data.Data(detectionIndex{PT});
    receiverData{PT}.avgNoise(:,1)   = dataDN(noiseIndex{PT}); receiverData{PT}.avgNoise(:,2) = data.Data(noiseIndex{PT});
    receiverData{PT}.pings(:,1)      = dataDN(pingIndex{PT});  receiverData{PT}.pings(:,2)    = data.Data(pingIndex{PT});
end
%%
for PT = 1:length(receiverData)
    TotalAvgNoise(PT,1) = mean(receiverData{PT}.avgNoise(:,2));
    time = datetime(receiverData{PT}.avgNoise(:,1),'ConvertFrom','datenum','TimeZone','UTC');
    time.TimeZone = 'local';
    uniqueNoise{PT} = table2timetable(table(time,receiverData{PT}.avgNoise(:,2)));
    uniqueNoise{PT}.Properties.VariableNames = {'Noise'};
    uniqueDets{PT} = table2timetable(table(time,receiverData{PT}.hourlyDets(:,2)));
end

for PT = 1:length(uniqueNoise)
    dailyUniqueNoise{PT} = retime(uniqueNoise{PT},'daily','mean');
    dailyUniqueDets{PT}   = retime(uniqueDets{PT}, 'daily','mean');
end

%%
%Second section: Plot "flag" graphs, showing easy/medium/challenging
%environments

%Create limits for "Noise Flag"
ylimE   = [0 300];        % Optimal mode, good for transmission
ylimM   = [301 650];   %Moderate mode, variable for transmission
ylimH   = [651 950];   %Challenging mode, tough on transmissions

%Plot the daily averaged noise values over the course of 2020
figure()
plot(dailyUniqueNoise{1}.time(20:end),dailyUniqueNoise{1}.Noise(20:end));
hold on
patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimE(1) ylimE(1), ylimE(2) ylimE(2)], [0 1 0],'FaceAlpha',0.4)
patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimM(1) ylimM(1), ylimM(2) ylimM(2)], [1 1 0],'FaceAlpha',0.4)
patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimH(1) ylimH(1), ylimH(2) ylimH(2)], [1 0 0],'FaceAlpha',0.4)
for PT = 2:length(uniqueNoise)
    plot(dailyUniqueNoise{PT}.time(20:end),dailyUniqueNoise{PT}.Noise(20:end));
    caption = sprintf('Ayo, this is %d',PT);
    fprintf('%s\n',caption);
%     pause
end
ylabel('Ambient Noise (mV)');
xlabel('Daily');
title('VEMCO''s Reported Environmental Noise Levels');

%Plot the hourly averaged noise values over the course of 2020
% figure()
% plot(uniqueNoise{11}.time,uniqueNoise{11}.Noise);
% hold on
% patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimE(1) ylimE(1), ylimE(2) ylimE(2)], [0 1 0],'FaceAlpha',0.4)
% patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimM(1) ylimM(1), ylimM(2) ylimM(2)], [1 1 0],'FaceAlpha',0.4)
% patch([min(xlim) max(xlim) max(xlim) min(xlim)], [ylimH(1) ylimH(1), ylimH(2) ylimH(2)], [1 0 0],'FaceAlpha',0.4)
% for PT = 1:length(uniqueNoise)
%     plot(uniqueNoise{PT}.time,uniqueNoise{PT}.Noise);
% end
% ylabel('Ambient Noise (mV)');
% xlabel('Hourly');
% 
% title('VEMCO''s Reported Environmental Noise Levels');

%%
%Third section: separate data by type and isolates the 2020 data. This is
%the year where almost all transceivers were  operating for the entire year
%Separates data by type, doesn't care what receiver gives it
allTempIndex      = strcmp(data.Description,'Temperature');
allDetectionIndex = strcmp(data.Description,'Hourly Detections on 69 kHz');
allNoiseIndex     = strcmp(data.Description,'Average noise');
allPingsIndex     = strcmp(data.Description,'Hourly Pings on 69 kHz');
allTemperatures(:,1)   = dataDN(allTempIndex); allTemperatures(:,2)   = data.Data(allTempIndex);
allDetections(:,1)     = dataDN(allDetectionIndex); allDetections(:,2)   = data.Data(allDetectionIndex);
allNoises(:,1)         =dataDN(allNoiseIndex); allNoises(:,2)   = data.Data(allNoiseIndex);
allPings(:,1)         =dataDN(allPingsIndex); allPings(:,2)   = data.Data(allPingsIndex);
estTemperatures(:,1) = datetime(allTemperatures(:,1),'ConvertFrom','datenum');
index2020 = [9009:99261];
% %Separate only the 2020 data
detections2020   = allDetections(index2020,:);
noises2020       = allNoises(index2020,:);
pings2020        = allPings(index2020,:);
temp2020         = allTemperatures(index2020,:);

%Datetimes for both detections and noise data, and tables
Time= datetime(detections2020(:,1),'ConvertFrom','datenum','TimeZone','UTC'); Time.TimeZone = 'local';
start1 = table(Time,detections2020(:,2),noises2020(:,2),temp2020(:,2)); tableDetections   = table2timetable(start1);


tableDetections.Properties.VariableNames = {'Detections','Noise','Temperature'};

%Retiming: this takes averages from a timetable. Hourly, daily, and monthly
%averages and standard deviations
hourlyAVG= retime(tableDetections,'hourly','mean');
hourlyVAR= retime(tableDetections,'hourly',@std);

dailyAVG = retime(tableDetections,'daily','mean');
dailyVAR = retime(tableDetections,'daily',@std);

monthlyAVG = retime(tableDetections,'monthly','mean');
monthlyVAR = retime(tableDetections,'monthly',@std);