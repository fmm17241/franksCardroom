cd (sprintf('%spassiveSounds',oneDrive))

%Lists the files in the directory chosen above.
broadBandFiles = dir('*BB*');
octaveFiles = dir('*_ol*');
oneThirdOctaveFiles = dir('*tol*');
psdFiles = dir('*psd*');


%

%Open the files and creates the data

%Broadband
for COUNT = 1:length(broadBandFiles)
    fid = fopen(broadBandFiles(COUNT,1).name);
    indata = textscan(fid, '%s%s', 'HeaderLines',1);
    fclose(fid);
    BBdata{COUNT} = [indata{1}, indata{2}];
    clear indata
end


% One Octave
for COUNT = 1:length(octaveFiles)
    fid = fopen(octaveFiles(COUNT,1).name);
    indata = textscan(fid, '%s%s%s%s%s%s%s%s%s%s%s', 'HeaderLines',1);
    fclose(fid);
    OLdata{COUNT} = [indata{1}, indata{2}, indata{3}, indata{4}, indata{5}, indata{6}, indata{7}, indata{8}, indata{9}, indata{10}, indata{11}];
    clear indata
end

% 1/3rd Octave
for COUNT = 1:length(oneThirdOctaveFiles)
    fid = fopen(oneThirdOctaveFiles(COUNT,1).name);
    indata = textscan(fid, '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s','HeaderLines',1);
    fclose(fid);
    TOLdata{COUNT} = [indata{1}, indata{2}, indata{3}, indata{4}, indata{5}, indata{6}, indata{7}, indata{8}, indata{9}, indata{10}, indata{11}, indata{12}...
        , indata{13}, indata{14}, indata{15}, indata{16}, indata{17}, indata{18}, indata{19}, indata{20}, indata{21}, indata{22}, indata{23}, indata{24}, indata{25}...
        , indata{26}, indata{27}, indata{28}, indata{29}, indata{30}, indata{31}];
    clear indata
end


% % PSD - these are huge, need to reevaluate how to process if needed.
% for COUNT = 1:length(psdFiles)
%     fid = fopen(psdFiles(COUNT,1).name);
%     indata = textscan(fid, '%s%s', 'HeaderLines',1);
%     fclose(fid);
%     PSDdata{COUNT} = [indata{1}, indata{2}];
%     clear indata
% end

%%
% Turning the first column datestring into datetime or datenum values

for COUNT = 1:length(BBdata)
    BBdn{COUNT} = DateStr2Num(BBdata{COUNT}(:,1),31);

    BBdt{COUNT} = datetime(BBdn{COUNT},'convertfrom','datenum','TimeZone','UTC')
    broadband{COUNT} = timetable(BBdt{COUNT},str2double(BBdata{COUNT}(:,2)));
end

for COUNT = 1:length(OLdata)
    OLdn{COUNT} = DateStr2Num(OLdata{COUNT}(:,1),31);

    OLdt{COUNT} = datetime(OLdn{COUNT},'convertfrom','datenum','TimeZone','UTC')
    octaveLevel{COUNT} = timetable(OLdt{COUNT},str2double(OLdata{COUNT}(:,2:end)));
end

for COUNT = 1:length(TOLdata)
    TOLdn{COUNT} = DateStr2Num(TOLdata{COUNT}(:,1),31);

    TOLdt{COUNT} = datetime(TOLdn{COUNT},'convertfrom','datenum','TimeZone','UTC')
    thirdOctaveLevel{COUNT} = timetable(TOLdt{COUNT},str2double(TOLdata{COUNT}(:,2:end)));
end


figure()
hold on
for COUNT = 1:length(broadband)
    plot(broadband{COUNT}.Time,broadband{COUNT}.Var1)
end
ylabel('Broadband Sound')
title('Gray''s Reef Sound','Broadband: 20 Hz - 24 kHz')

figure()
plot(octaveLevel{4}.Time,octaveLevel{4}.Var1(:,1),'r')
hold on
plot(octaveLevel{4}.Time,octaveLevel{4}.Var1(:,10),'b')
ylabel('Median Sound Pressure Levels')
title('Gray''s Reef Sound','Red: Low Freq.; Blue: High Freq.')



lowDetrend = detrend(octaveLevel{4}.Var1(:,1))
highDetrend = detrend(octaveLevel{4}.Var1(:,10))

figure()
plot(octaveLevel{4}.Time,lowDetrend,'r')
hold on
plot(octaveLevel{4}.Time,highDetrend,'b')
ylabel('Median Sound Levels, Detrended')
title('Gray''s Reef Sound, Detrended','Red: Low Freq. Octave Level; Blue: High Freq.')



%%

% Okay, using this and powerAnalysis
close all
clearvars -except receiverData signal* githubToolbox oneDrive broadband octaveLevel thirdOctaveLevel lowDetrend highDetrend


figure()
plot(octaveLevel{4}.Time,lowDetrend,'r')
hold on
plot(octaveLevel{4}.Time,highDetrend,'b','LineWidth',2)
ylabel('Median Sound Levels, Detrended')
plot(receiverData{4}.DT,receiverData{4}.windSpd,'k','LineWidth',2)
title('Windspeed vs High (blue) and Low (red) Frequencies','Detrended Noise and Windspeed (Black, m/s)')

%%

figure()
tiledlayout(4,2,'TileSpacing','Compact','TileIndexing', 'columnmajor')
ax1 = nexttile([2 1])
yyaxis left
plot(receiverData{4}.DT,receiverData{4}.windSpd,'k')
hold on
ylabel('Windspeed (m/s)')
y3 = yline(6,'--','Moderate Breeze')
y3.LabelHorizontalAlignment = 'left';
y2 = yline(10,'--','Strong Breeze')
y2.LabelHorizontalAlignment = 'right';
ylim([1 15])
yyaxis right
scatter(receiverData{4}.DT,receiverData{4}.HourlyDets,'r','<','filled')

title('Wind''s Effect on a Shallow Coastal Reef''s Soundscape','Wind Magnitude')


ax2 = nexttile([1 1])
plot(octaveLevel{4}.Time,octaveLevel{4}.Var1(:,4),'b','LineWidth',2)
ylabel({'Sound Pressure Level'; 'Hourly Median (dB re 1 µPa)'})
% x1 = xline(receiverData{4}.DT(2224),'-','High Winds')
% x1.LabelVerticalAlignment = 'bottom';
% x2 = xline(receiverData{4}.DT(2366))
title('','Low-Frequency Noise (0.17-0.36 kHz)')

ax3 = nexttile([1 1])
plot(octaveLevel{4}.Time,octaveLevel{4}.Var1(:,10),'r','LineWidth',2)
ylabel({'Sound Pressure Level'; '(dB re 1 µPa)'})
% x1 = xline(receiverData{4}.DT(2224),'-')
% x2 = xline(receiverData{4}.DT(2366))
title('','High-Frequency Noise (11-22 kHz)')

linkaxes([ax1 ax2 ax3],'X')

ax4 = nexttile([2 1])
scatter(receiverData{4}.windSpd(1678:4371,:),octaveLevel{4}.Var1(:,4),'b')
ylabel('Sound Pressure Level')
xlabel('Windspeed (m/s')
title('Low-Frequency Noise vs Increasing Windspeed')
% title('Sound Pressures vs Increasing Windspeed','Low-Frequency')

ax5 = nexttile([2 1])
scatter(receiverData{4}.windSpd(1678:4371,:),octaveLevel{4}.Var1(:,10),'r')
ylabel('Sound Pressure Level')
xlabel('Windspeed (m/s')
title('High-Frequency Noise vs Increasing Windspeed')
% title('','High-Frequency')


%%
%OKAY: Frank binning for big figure

ol4

%


highWindIndex =  [2076:2106,2187:2273,2363:2376];
lowIndex      =  [395:425,506:592,682:695];

figure()
tiledlayout(2,5,'TileSpacing','Compact','TileIndexing', 'columnmajor')

ax1 = nexttile([2 2])
plot(receiverData{4}.DT,receiverData{4}.windSpd,'k')
hold on
ylabel('Windspeed (m/s)')
y3 = yline(6,'--','Moderate Breeze')
y3.LabelHorizontalAlignment = 'left';
y2 = yline(10,'--','Strong Breeze')
y2.LabelHorizontalAlignment = 'right';
ylim([1 15])
yyaxis right
scatter(receiverData{4}.DT,receiverData{4}.HourlyDets,'r','sq','filled')
ylabel('Hourly Detections')
ylim([0 8])
ax1.YAxis(1).Color = 'k';
ax1.YAxis(2).Color = 'k';
title('Wind''s Effect on a Shallow Coastal Reef''s Soundscape','Wind Magnitude (-), Hourly Dets (Red Sq.)')


ax2 = nexttile([1 1])
plot(octaveLevel{4}.Time(394:700),octaveLevel{4}.Var1(394:700,4),'b','LineWidth',2)
title('','Low-Frequency Noise (0.17-0.36 kHz)')
ylabel('Sound Pressure Level')

ax3 = nexttile([1 1])
scatter(receiverData{4}.windSpd(2075:2381,:),octaveLevel{4}.Var1(394:700,4),'r')
hold on
scatter(receiverData{4}.windSpd(highWindIndex,:),octaveLevel{4}.Var1(lowIndex,4),'r','filled')
ylabel('Sound Pressure Level')
xlabel('Windspeed (m/s)')
legend('Low Windspeeds','High Windspeeds')


ax4 = nexttile([1 1])
plot(octaveLevel{4}.Time(394:700),octaveLevel{4}.Var1(394:700,10),'b','LineWidth',2)
title('','Mid-Frequency Noise (11-22 kHz)')
ylabel('Sound Pressure Level')

ax5 = nexttile([1 1])
scatter(receiverData{4}.windSpd(2075:2381,:),octaveLevel{4}.Var1(394:700,10),'r')
hold on
scatter(receiverData{4}.windSpd(highWindIndex,:),octaveLevel{4}.Var1(lowIndex,10),'r','filled')
ylabel('Sound Pressure Level')
xlabel('Windspeed (m/s)')
% ylim([75 120])

ax6 = nexttile([1 1])
plot(receiverData{4}.DT(2075:2381,:),receiverData{4}.Noise(2075:2381,:),'b','LineWidth',2)
title('','High-Frequency Noise (50-90 kHz)')
ylabel('Noise (mV)')

ax7 = nexttile([1 1])
scatter(receiverData{4}.windSpd(2075:2381,:),receiverData{4}.Noise(2075:2381,:),'r')
hold on
scatter(receiverData{4}.windSpd(highWindIndex,:),receiverData{4}.Noise(highWindIndex,:),'r','filled')
ylabel('Noise (mV)')
xlabel('Windspeed (m/s)')
% ylim([75 120])



linkaxes([ax1 ax2 ax4 ax6],'x')

%%



figure()
yyaxis left
plot(octaveLevel{4}.Time,octaveLevel{4}.Var1(:,1),'r')
hold on
plot(octaveLevel{4}.Time,octaveLevel{4}.Var1(:,10),'b','LineWidth',2)
ylabel('Median Sound Levels, Detrended')
yyaxis right
plot(receiverData{4}.DT,receiverData{4}.windSpd,'k','LineWidth',2)
title('Windspeed vs High (blue) and Low (red) Frequencies','Windspeed (Black, m/s)')


figure()
scatter(receiverData{4}.windSpd(1678:4371,:),octaveLevel{4}.Var1(:,1))
ylabel('Low Frequency')
xlabel('Windspeed (m/s)')

figure()
tiledlayout(2,5,'TileSpacing','Compact')
for COUNT = 1:width(octaveLevel{4}.Var1)
    nexttile()
    scatter(receiverData{4}.windSpd(1678:4371,:),octaveLevel{4}.Var1(:,COUNT))
    ylabel('Soundpressure Level')
    if ismember(COUNT,[6,7,8,9,10])
        xlabel('Windspeed (m/s)')
    end
    title(sprintf('Octave Level: %d',COUNT))
    ylim([70 120])
end


%%

figure()
tiledlayout(3,1,'TileSpacing','Compact')
ax1 = nexttile()
plot(receiverData{4}.DT,receiverData{4}.windSpd)
ylabel('Windspd (m/s)')
title('Comparing Wind Effects','Windspeed')
ax2 = nexttile()
yyaxis right
plot(receiverData{4}.DT,receiverData{4}.HourlyDets)
ylabel('Detections')
yyaxis left
plot(receiverData{4}.DT,receiverData{4}.Noise)
title('Flat, Dense Reef')
ylabel('High-Freq. Noise (mV)')
ax3 = nexttile()
yyaxis right
plot(receiverData{5}.DT,receiverData{5}.HourlyDets)
ylabel('Detections')
yyaxis left
plot(receiverData{5}.DT,receiverData{5}.Noise)
title('Sunken Reef')
ylabel('High-Freq. Noise (mV)')

linkaxes([ax1 ax2 ax3],'x')



