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



% Okay, using this and powerAnalysis

clearvars -except receiverData signal* githubToolbox oneDrive broadband octaveLevel thirdOctaveLevel


figure()
plot(octaveLevel{4}.Time,lowDetrend,'r')
hold on
plot(octaveLevel{4}.Time,highDetrend,'b','LineWidth',2)
ylabel('Median Sound Levels, Detrended')
plot(receiverData{4}.DT,receiverData{4}.windSpd,'k','LineWidth',2)
title('Windspeed vs High (blue) and Low (red) Frequencies','Detrended Noise and Windspeed (Black, m/s)')


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
    % ylim([70 130])
end



