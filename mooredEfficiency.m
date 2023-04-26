%FM 4/27/22

% 1 SURTASSTN20    63062
% 2 SURTASS_05IN   63064
% 3 Roldan         63066
% 4 33OUT          63067 * none heard
% 5 FS17           63068  *none heard
% 6 08C            63070
% 7 STSNew1        63073
% 8 STSNew2        63074
% 9 FS6            63075
% 10 08ALTIN       63076
% 11 34ALTOUT      63079
% 12 09T           63080
% 13 39IN          63081

%Experiment 1, compare two moored transceivers 0.53km away
%For our purposes, Mooring 1 will be SURTASSTN20, deeper transceiver central to an array, and Mooring 2 will be
%STSNew1, more shallow transceiver. Yes, numbers above may be confusing, good observation, but I
%gotta keep them straight. If I lose that numbering, all of this is for naught and I may join the circus.

cd ([oneDrive,'Moored\GRNMS\VRLs'])
% cd 'C:\Users\fmm17241\OneDrive - University of Georgia\data\Moored\GRNMS\VRLs'

% call = readtable('VR2Tx_483080_20211223_1.csv'); %SURTASSSTN20
rawDetFile{1,1} = readtable('VR2Tx_483062_20211112_1.csv'); %SURTASSSTN20
rawDetFile{2,1} = readtable('VR2Tx_483064_20211025_1.csv'); %SURTASS05IN
rawDetFile{3,1} = readtable('VR2Tx_483066_20211018_1.csv'); %Roldan
rawDetFile{4,1} = readtable('VR2Tx_483070_20211223_1.csv'); % 08C
rawDetFile{5,1} = readtable('VR2Tx_483073_20211112_4.csv'); %STSNew1
rawDetFile{6,1} = readtable('VR2Tx_483074_20211025_1.csv'); %STSNEW2
rawDetFile{7,1} = readtable('VR2Tx_483075_20211025_1.csv'); %FS6
rawDetFile{8,1} = readtable('VR2Tx_483076_20211018_1.csv'); %08ALTIN
rawDetFile{9,1} = readtable('VR2Tx_483080_20211223_1.csv'); %09T
rawDetFile{10,1} = readtable('VR2Tx_483081_20211005_1.csv'); %39IN
% rawDetFile{11,1} = readtable('VR2Tx_483079_20211130_1.csv'); %34ALTOUT

%First pairing: SURTASSSTN20 and STSNEW1
%Second pairing: SURTASS05IN and FS6
%Third pairing: Roldan and 08ALTIN
%Fourth pairing: SURTASS05IN and STSNew2
%Fifth pairing: 39IN and SURTASS05IN
%Sixth pairing: STSNEW2 and FS6
%Extra Receivers: 09T

%Recognize pattern in the CSV of unique identification 
pattern1 = digitsPattern(4)+ "-" + digitsPattern(3,5);
pattern2 = "-" + digitsPattern(3,5);

%Comb through raw files, give me datetimes in EST (local), and tell me
%which instrument transmitted.
for counter=1:length(rawDetFile)
    if isempty(rawDetFile{counter})
        continue
    else
    mooredReceivers{counter,1}.DT=table2array(rawDetFile{counter,1}(:,1));mooredReceivers{counter,1}.DT.TimeZone = 'UTC';
    mooredReceivers{counter,1}.DN= datenum(mooredReceivers{counter,1}.DT);
    converty=string(rawDetFile{counter,1}{:,3});
    first = extract(converty,pattern1);
    second = extract(first,pattern2); third = erase(second,"-");
    mooredReceivers{counter,1}.detections = str2double(third);
    [mooredReceivers{counter,1}.which,~,c]      = unique(mooredReceivers{counter,1}.detections);
    arr = accumarray(c,1);
    counters{counter}=[mooredReceivers{counter,1}.which,arr];
    end
end
%Cleanup a bit
clear first second third fourth counter pattern1 pattern2 test arr converty c

%%

%Index of my pair. I don't need all detections, especially not self
%detections, I want to know how many times these bad boys heard each other.

%First pairing
index{1} = mooredReceivers{1,1}.detections == 63073; %SURTASSSTN20 hearing STSNew1, transmits West to East
index{2} = mooredReceivers{5,1}.detections == 63062; %STSNew1 hearing SURTASSSTN20, transmits East to West

%Second pairing
index{3} = mooredReceivers{7,1}.detections == 63064; %FS6 hearing SURTASS05In, transmits ENE
index{4} = mooredReceivers{2,1}.detections == 63075; %SURTASS05In hearing FS6, transmits WSW

%Third pairing
index{5} = mooredReceivers{3,1}.detections == 63076; %Roldan hearing 08ALTIN, transmits South to North
index{6} = mooredReceivers{8,1}.detections == 63066; %08ALTIN hearing Roldan, transmits North to South

%Fourth pairing
index{7} = mooredReceivers{6,1}.detections == 63064; % STSNEW2 hearing SURTASS05IN, transmits NW to SE
index{8} = mooredReceivers{2,1}.detections == 63074; % SURTASS05IN hearing STSNEW2, transmits SE to NW

%Fifth pairing
index{9} = mooredReceivers{2,1}.detections == 63081; % SURTASS05IN hearing 39IN, transmits NW to SE
index{10} = mooredReceivers{10,1}.detections == 63064; % 39IN hearing SURTASS05IN, transmits SE to NW

% %Sixth Pairing
% index{11} = mooredReceivers{1,1}.detections == 63079; %SURTASSSTN20 hearing 34ALTOUT
% index{12} = mooredReceivers{11,1}.detections == 63062; %34ALTOUT hearing SURTASSSTN20

%FM this is my "key" for the index. I didn't want to load data twice so
%this key tells the loop which order to use
% receiverOrder = [1;5;2;7;3;8;2;6;10;2;1;11];
receiverOrder = [1;5;7;2;3;8;6;2;2;10];


% %Making the visualizations more correct: instead of 06:00 representing
% %06:00 to 06:59:59, it will now show as 06:30, the middle of the binned
% %data
% offset = duration(minutes(30));

%Below is a loop to create the timetables for all the different pairings.
%This bins the time by hour, then adds the :30 to make the visualization
%clearer.
%%
for k = 1:length(index)
    recNumber = receiverOrder(k,1);
    time{k} = mooredReceivers{recNumber,1}.DT(index{k});
    detections{k} = ones(length(mooredReceivers{recNumber,1}.detections(index{k})),1);
    detectionTable{k} = table(time{1,k},detections{1,k}); 
    detectionTable{k}.Properties.VariableNames = {'time','detections'};
    detectionTable{k} = table2timetable(detectionTable{k});
    hourlyDetections{k} = retime(detectionTable{k},'hourly','sum');
    %Put this step into chunkPlotter instead; to correctly visualize the
    %bin, we put the hours in :30 but otherwise we keep hours.
%     hourlyDetections{k}.time = hourlyDetections{k}.time + offset;
end

