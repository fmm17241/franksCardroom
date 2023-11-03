%FM
%What's going on, vegv,pbmkfgbmklfb m sbklgmvkb kgmbkmgf

stationTidalAnalysis

%Loads in and analyzes the windspeeds and directions
stationWindsAnalysis


% fullTime = [datetime(2020,01,29,17,00,00),datetime(2020,12,10,13,00,00)];
% fullTime.TimeZone = 'UTC';
%Creates diurnal data
figure()
SunriseSunsetUTC

%Day timing
sunRun = [sunrise; sunset];



%Load in the detection files
cd ([oneDrive,'Moored\GRNMS\VRLs'])
rawDetFile{1,1} = readtable('VR2Tx_483064_20211025_1.csv'); %SURTASS05IN, A
rawDetFile{2,1} = readtable('VR2Tx_483074_20211025_1.csv'); %STSNEW2, B
rawDetFile{3,1} = readtable('VR2Tx_483075_20211025_1.csv'); %FS6, C
rawDetFile{4,1} = readtable('VR2Tx_483081_20211005_1.csv'); %39IN, D


%%FM 5/24: trying bulk strat using bottom receiver + buoy info
cd ([oneDrive,'Moored'])
% Separate dets, temps, and noise by which receiver is giving the data
data = readtable('VUE_Export.csv');

%These transceivers are used for this research
WonderfulReceivers = ['VR2Tx-483064';'VR2Tx-483074';'VR2Tx-483075';'VR2Tx-483081'];
data(~ismember(data.Receiver,WonderfulReceivers),:)=[];

%%
% Bringing in receiver data

dataDN = datenum(data.DateAndTime_UTC_);
dataDT = datetime(dataDN,'convertFrom','datenum');

%FM 3/6/23 Ordered the transceivers and doubled some up; this is to match
%the transceiver order listed in "matchAngles"/"thetaFinder"
uniqueReceivers = [{'VR2Tx-483064';     % 'VR2Tx-483064' SURTASS_05IN
                    'VR2Tx-483074';     % 'VR2Tx-483074' STSNew2
                    'VR2Tx-483075';     % 'VR2Tx-483075' FS6
                    'VR2Tx-483081'}]    % 'VR2Tx-483081' 39IN

%%
% uniqueReceivers = unique(data.Receiver);
for PT = 1:length(uniqueReceivers)
%     clearvars tempIndex detectionIndex noiseIndex pingIndex tiltIndex
    tempIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Temperature');
    detectionIndex{PT,1} = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Detections on 69 kHz');
    noiseIndex{PT,1}     = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Average noise');
    pingIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Hourly Pings on 69 kHz');
    tiltIndex{PT,1}      = strcmp(data.Receiver,uniqueReceivers(PT)) & strcmp(data.Description,'Tilt angle');
    
    receiverData{PT}.identity        = uniqueReceivers{PT}
    receiverData{PT}.bottomTemp(:,1) = dataDN(tempIndex{PT}); receiverData{PT}.bottomTemp(:,2) = data.Data(tempIndex{PT});
    receiverData{PT}.hourlyDets(:,1) = dataDN(detectionIndex{PT}); receiverData{PT}.hourlyDets(:,2) = data.Data(detectionIndex{PT});
    receiverData{PT}.avgNoise(:,1)   = dataDN(noiseIndex{PT}); receiverData{PT}.avgNoise(:,2) = data.Data(noiseIndex{PT});
    receiverData{PT}.pings(:,1)      = dataDN(pingIndex{PT});  receiverData{PT}.pings(:,2)    = data.Data(pingIndex{PT});
    receiverData{PT}.tilt(:,1)       = dataDN(tiltIndex{PT}); receiverData{PT}.tilt(:,2)          = data.Data(tiltIndex{PT});
    receiverTimes{PT}                = datetime(receiverData{PT}.hourlyDets(:,1),'ConvertFrom','datenum','TimeZone','UTC');
end
clear detectionIndex  PT noiseIndex pingIndex detectionIndex tempIndex tiltIndex WonderfulReceivers data dataDN 

%Timetable of transceiver data
for PT = 1:length(uniqueReceivers)
    startTime = [datetime(receiverData{1,PT}.bottomTemp(1,1),'ConvertFrom','datenum','TimeZone','UTC'); datetime(receiverData{1,PT}.bottomTemp(end,1),'ConvertFrom','datenum','TimeZone','UTC')];
    bottomTime{PT} = datetime(receiverData{PT}.bottomTemp(:,1),'ConvertFrom','datenum','TimeZone','UTC');
    botIndex       = isbetween(bottomTime{PT},startTime(1,1),startTime(2,1));
    bottom{PT} = timetable(bottomTime{PT}(botIndex),receiverData{PT}.bottomTemp(botIndex,2),receiverData{PT}.hourlyDets(botIndex,2),receiverData{PT}.tilt(botIndex,2),receiverData{PT}.avgNoise(botIndex,2),receiverData{PT}.pings(botIndex,2),receiverData{PT}.hourlyDets(botIndex,2));
    bottom{PT}.Properties.VariableNames = {'botTemp','Detections','Tilt','Noise','Pings','TotalDets'};
    bottom{PT}.Tilt(bottom{PT}.Tilt>70) = 0;
end

for PT = 1:length(bottom)
    startTime = [datetime(2020,01,29,17,00,00,'TimeZone','UTC'); datetime(2020,12,10,13,00,00,'TimeZone','UTC')];
    stratIndex1 = isbetween(seas.time,startTime(1,1),startTime(2,1));
    stratIndex2 = isbetween(bottomTime{1,PT},startTime(1,1),startTime(2,1));
%     if PT == 9 | 10
%         continue
%     end
    stratification{PT} = seas.SST(stratIndex1)-bottom{1,PT}.botTemp(stratIndex2);
    nullindex = stratification{1,PT} < .000001;
    stratification{PT}(nullindex) = 0;
end 



for COUNT = 1:length(bottom)
    stratIndex = isbetween(bottom{COUNT}.Time,startTime(1,1),startTime(2,1),'closed');
    bottomStats{COUNT} = bottom{COUNT}(stratIndex,:);
%     fixInd = isnan(buoyStats{COUNT}.botTemp)
%     buoyStratification{COUNT}(fixInd) = 0;
%     fullStratData{COUNT} = buoyStats{COUNT}(stratIndex);
end


%Binary data: night or day
xx = length(sunRun);
sunlight = zeros(1,height(time));
for k = 1:xx
    currentSun = sunRun(:,k);
    currentHours = isbetween(time,currentSun(1,1),currentSun(2,1)); %FM 7/1
    currentDays = find(currentHours);
    sunlight(currentDays) = 1;
end

% winter  = [1:751,6632:7581];
% % Spring:           Mar-May
% spring   = 752:2959;
% % Summer:           June, July
% summer   = 2960:4423;
% % Fall:             August
% fall     = 4424:5167;
% % Mariner's Fall:   Sep-Oct
% Mfall    =5168:6631;

% seasonCounter = zeros(1,length(time));
% seasonCounter(winter) = 1; seasonCounter(spring) = 2; seasonCounter(summer) = 3; seasonCounter(fall) = 4; seasonCounter(Mfall) = 5;



load mooredGPS

% %Creates distance variable between transceivers
% distances(:,1) = repelem(lldistkm(mooredGPS(14,:),mooredGPS(12,:)),length(uniqueReceivers));


%Angles between transceivers
% for K = 1:10
%     arrayPairing(:,K) = repelem(K,length(time))
%     transAngle(:,K)   = repelem(AnglesD(:,K),length(time))
% end

%Okay, basics are set.
close all


%%
%Chunks of time to plot:
startCyclePre = tideDT(97);
%THIS IS WHERE I SET MY CHUNKS! 2 days gives clear patterns and is visually
%appealing, but can be changed for longer dataset analysis.
% 
% % Basic:
cycleDuration  = duration(days(7));



%old
% fixOffset = 0.5*cycleDuration;

% startCycle = startCyclePre - fixOffset
startCycle = startCyclePre

cycleTime = startCycle;
for k = 1:60 %
% for k  = 1:95 % for 4 day chunks
% for k = 1:35 %~30 day chunks
% for k = 1:25     %15 day chunks
% for k = 1:53 %weeks
%    cycleTime(k+1) = cycleTime(k) + fixOffset;  Use this to put in :30
%    offset here, but I've changed that.
   cycleTime(k+1) = cycleTime(k) + cycleDuration;
end

%%


%%Set limits for our figures.
% limitsTide  = [min(rotUtide) max(rotUtide)]; % Chosen to be abs(0.4).
limitsWind     = [min(windsU) max(windsU)];    
limitsDets     = [0 6];
limitsStrat    = [0 5];
limitsHeight   = [min(seas.waveHeight) max(seas.waveHeight)];
axDN(1,1:4) = [0 0 -12 12];
% axDN(1,1:4) = [0 0 -0.5 0.5]; For currents


%Change this to one of the pairings listed above to save
% cd  'C:\Users\fmm17241\OneDrive - University of Georgia\data\Moored\tidalCycles\pairing4'
cd 'C:\Users\fmm17241\Documents\Plots'

receiverLetter = ['A','B','C','D']

for COUNT = 1:length(receiverData)
    for k = 1:length(cycleTime)-1
    % for k = 145 %Way to make a specific plot that I need
        %Creates axis for each part of the figure
       ax = [cycleTime(k) cycleTime(k+1)];
       axDN(1,1:2) = [datenum(ax(1)) datenum(ax(2))];
    
    %    %Attempting to automatically shade certain hours for diurnal differences
%        findersX(1) = ax(1) + duration(hours(12.5));
%        findersX(2) = ax(1) + duration(hours(23.5));
%        findersX(3) = findersX(1) + duration(hours(24));
%        findersX(4) = findersX(2) + duration(hours(24));
%        findersY    = [0 6 6 0];
%        
%        %add other findersX when doing 4 days instead of 2 to shade
%        findersX(5) = findersX(3) + duration(hours(24));
%        findersX(6) = findersX(4) + duration(hours(24));
%        findersX(7) = findersX(5) + duration(hours(24));
%        findersX(8) = findersX(6) + duration(hours(24));
    % 
    %    %Ugh, doing 7 for posterity
    %    findersX(9) = findersX(7) + duration(hours(24));
    %    findersX(10) = findersX(8) + duration(hours(24));
    %    findersX(11) = findersX(9) + duration(hours(24));
    %    findersX(12) = findersX(10) + duration(hours(24));
    %     
    %    findersX(13) = findersX(11) + duration(hours(24));
    %    findersX(14) = findersX(12) + duration(hours(24));
        
    
        ff = tiledlayout(tileArrangement="vertical")
        set(gcf, 'Position',  [-100, 100, 2000, 1100])
        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.hourlyDets(:,2),'k');
        %     title('Detections, ~500 m, East to West, Transceiver Depth: 13.72 m');
        title(sprintf('Station %s, Hourly Dets',receiverLetter(COUNT)));
        xlim(ax);
        datetick('x','mmm,dd,yyyy','keeplimits');
        ylabel('Hourly Detections');
%         ylim([6 16]);

        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{1,COUNT}.avgNoise(:,2));
        ylabel('Ambient Noise');
        ylim([500 900])
        yline(650)
        xlim(ax);
        datetick('x','keeplimits');
        title('Ambient Noise');
        
        nexttile([1 2])
        plot(windsDT,WSPD);
        ylabel('Windspeed');
%         ylim([500 900])
%         yline(650)
        xlim(ax);
        datetick('x','keeplimits');
        title('Winds');

        %     
%         nexttile([1 2])
%         plot(tideDT,rotUtideShore)
%         title('Rotated Tides, Parallel');
%         ylabel('Parallel Velocity');
%         xlim(ax);
%         ylim([-0.3 0.3]);
%         datetick('x','keeplimits');
%         yline(0);
        
        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.pings(:,2),'r');
        ylabel('Pings');
%         ylim([0 40]);
        xlim(ax);
        title('Single Pings Received, Hourly');
    %     
        nexttile([1 2])
        plot(receiverTimes{COUNT},receiverData{COUNT}.tilt(:,2),'r');
        ylabel('Tilt');
%         ylim([0 40]);
        xlim(ax);
        title('Instrument Tilt');
%         nexttile ([1 2])
%         plot(bottomStats{COUNT}.Time,bottomStats{COUNT}.Tilt)
%         ylim([0 40])
%         xlim(ax);
%         datetick('x','keeplimits');
%         title('Transceiver Tilt, 2');
%     
%         
%         nexttile([1 2])
%         plot(bottomStats{COUNT}.Time,stratification{COUNT},'r');
%         ylabel('Temp \Delta °C)');
%         ylim(limitsStrat);
%         xlim(ax);
%         title('Bulk Stratification at Gray''s Reef, ~20m Depth');
%         nexttile([1 2])
%         plot(fullData{1}.time,fullData{1}.windSpeed)
%         ylabel('Wind Magnitude, m/s');
%         datetick('x','keeplimits');
%         title('Windspeed');
    %     
    %     nexttile([1 2])
    %     plot(seas.time,seas.waveHeight);
    %     title('Wave Height, Gray''s Reef');
    %     ylabel('Wave height (m)');
    %     ylim(limitsHeight);
    %     xlim(ax);
    
    %         nexttile([1 2])
    %     plot(bottom.bottomTime,bottom.Tilt,'r');
    %     ylabel('Tilt Angle, °');
    %     ylim([0 40]);
    %     xlim(ax);
    %     title('Transceiver Tilt from 90°, Straight up');
%         
        exportgraphics(ff,sprintf('saveIt%dand%d7Day.png',COUNT,k))
        close all
    end
end










