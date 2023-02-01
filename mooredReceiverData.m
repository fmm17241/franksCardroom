%Downloading and manipulating data from moored receivers


%Currently working through 2020. Order of moorings is as follows:


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


%unused
% 14IN           63078
% West15         63063
% SURTASS_FS15   63071

cd G:\Moored\GRNMS\VRLs

rawDetFile{1,1} = readtable('VR2Tx_483062_20211112_1.csv');
rawDetFile{2,1} = readtable('VR2Tx_483064_20211025_1.csv');
rawDetFile{3,1} = readtable('VR2Tx_483066_20211018_1.csv');
rawDetFile{4,1} = readtable('VR2Tx_483067_20211112_3.csv');
rawDetFile{5,1} = readtable('VR2Tx_483068_20211223_1.csv');
rawDetFile{6,1} = readtable('VR2Tx_483070_20211223_1.csv');
rawDetFile{7,1} = readtable('VR2Tx_483073_20211112_4.csv');
rawDetFile{8,1} = readtable('VR2Tx_483074_20211025_1.csv');
rawDetFile{9,1} = readtable('VR2Tx_483075_20211025_1.csv');
rawDetFile{10,1} = readtable('VR2Tx_483076_20211018_1.csv');
rawDetFile{11,1} = readtable('VR2Tx_483079_20211130_1.csv');
rawDetFile{12,1} = readtable('VR2Tx_483080_20211223_1.csv');
rawDetFile{13,1} = readtable('VR2Tx_483081_20211005_1.csv');




%%
pattern1 = digitsPattern(4)+ "-" + digitsPattern(3,5);
pattern2 = "-" + digitsPattern(3,5);

mooredReceivers=cell(length(rawDetFile),1);
%%
for counter=1:length(rawDetFile)
    if isempty(rawDetFile{counter})
        continue
    else
    mooredReceivers{counter,1}.DT=table2array(rawDetFile{counter,1}(:,1));mooredReceivers{counter,1}.DT.TimeZone = 'UTC';
    mooredReceivers{counter,1}.DT.TimeZone = 'local';
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
clear first second third fourth counter pattern1 pattern2 test




%
% 
% numberz=cell(length(mooredReceivers),1);
% for Yes = 1:length(mooredReceivers)
%     if isempty(mooredReceivers{Yes})
%         full(Yes,1) = 0;
%         continue
%     else
%     currentVector = datevec(mooredReceivers{Yes,1}.DT);
%     numberz{Yes,1}.DT          = mooredReceivers{Yes,1}.DT;
%     numberz{Yes,1}.DN          = mooredReceivers{Yes,1}.DN;
%     numberz{Yes,1}.detections  = mooredReceivers{Yes,1}.detections;
%     full(Yes,1)            = numel(numberz{Yes,1}.detections);
%     end
% end
% 
% 
% selfNumbers = [63062,63064,63066,63067,63068,63070,63073,63074,63075,...
%     63076,63079,63080,63081];
% selfNumbers = selfNumbers';
% 
% 
% for PT = 1:length(numberz)
%     if isempty(numberz{PT})
%         selfDets{PT,1} = 0;
%         continue
%     else
%     currentNumber = selfNumbers(PT);
%     selfDets{PT,1}= sum(numberz{PT,1}.detections==currentNumber,'all');
%     end
% end
% 
% selfDets = cell2mat(selfDets);
% 
% OnlyOthers = full - selfDets;
% 
% 
% 
% 
% 
% 
% 
% % Gives time deployed in minutes
% 
% durationz = cell(length(mooredReceivers),1);
% for PT = 1:length(mooredReceivers)
%     if isempty(rawDetFile{PT})
%         continue
%     else
%     T1 = datevec(mooredReceivers{PT,1}.DT(1,1));
%     T2 = datevec(mooredReceivers{PT,1}.DT(end,1));
%     durationz{PT,1} = etime(T2,T1)/60;
%     end
% end
% 
% test = datevec(mooredReceivers{1,1}.DT);
% 
% %%
% % numberz=cell(length(mooredReceivers),1);
% % for Yes = 1:length(mooredReceivers)
% %     if isempty(mooredReceivers{Yes})
% %         full(Yes,1) = 0;
% %         continue
% %     else
% %     currentVector = datevec(mooredReceivers{Yes,1}.DT);
% %     springIndex   = (currentVector(:,2)==4 | currentVector(:,2)==5) & currentVector(:,1)==2020;
% %     numberz{Yes,1}.DT          = mooredReceivers{Yes,1}.DT(springIndex);
% %     numberz{Yes,1}.DN          = mooredReceivers{Yes,1}.DN(springIndex);
% %     numberz{Yes,1}.detections  = mooredReceivers{Yes,1}.detections(springIndex);
% %     full(Yes,1)            = numel(numberz{Yes,1}.detections);
% %     end
% % end
% 
% springDurationz =cell(length(numberz),1);
% for PT = 1:length(numberz)
%     if isempty(numberz{PT})
%         springDurationz{PT,1} = 0;
%         continue
%     else
%     T1 = datevec(numberz{PT,1}.DT(1,1));
%     T2 = datevec(numberz{PT,1}.DT(end,1));
%     springDurationz{PT,1} = etime(T2,T1)/60;
%     end
% end
% 
% springDurationz = cell2mat(springDurationz); %minutes
% springExpected  = springDurationz/10;       %every 10, expected
% 
% 
% 
% 
% 
% %%
% 
% %FM 3/24/22, CHANGE THESE! CHANGING ORDER OF MOORINGS
% % selfNumbers = [63068,63073,63067,63079,63080,63066,63076,63078,63063,...
% %     63070,63074,63075,63081,63064,63062,63071];
% % selfNumbers = selfNumbers';
% 
% % 
% % for PT = 1:length(numberz)
% %     if isempty(numberz{PT})
% %         selfDets{PT,1} = 0;
% %         continue
% %     else
% %     currentNumber = selfNumbers(PT);
% %     selfDets{PT,1}= sum(numberz{PT,1}.detections==currentNumber,'all');
% %     end
% % end
% % 
% % selfDets = cell2mat(selfDets);
% % 
% % springOnlyOthers = selfNumbers - selfDets;
% % 
% % springEfficiency = selfDets./springExpected;
% % 
% % allDTs = [];
% % for k =1:length(mooredReceivers)
% %     if isempty(mooredReceivers{k})
% %         continue
% %     else
% %     allDTs = [allDTs; mooredReceivers{k,1}.DT];
% %     end
% % end
% % 
% % allDTsSorted = sort(allDTs);
% % [Y,M,D,H] = datevec(allDTsSorted);
% % [a,~,ii] = unique([Y,M,D,H],'rows');
% % T_out = table(datetime([a,zeros(size(a,1),2)],'f','MM-dd-uuuu HH:00'),accumarray(ii,1),'v',{'dates','counts'});
% % 
% % 
% % springTotals = table2timetable(T_out(3177:4640,:));
% % 
% % figure()
% % plot(springTotals.dates,springTotals.counts);
% % 
% % smoothTotals = smoothdata(springTotals);
% % 
% % %Finding when there's most detections vs least
% % 
% % low = islocalmin(smoothTotals.counts,'MinProminence',5);
% % high = islocalmax(smoothTotals.counts,'MinProminence',5);
% % 
% % lowdets  = table(smoothTotals.dates(low), smoothTotals.counts(low));
% % highdets = table(smoothTotals.dates(high), smoothTotals.counts(high));
% % 
% % 
% % tidalAnalysis2020
% % 
% % 
% % figure()
% % yyaxis left
% % plot(smoothTotals.dates,smoothTotals.counts);
% % hold on
% % scatter(lowdets.Var1,lowdets.Var2);
% % scatter(highdets.Var1,highdets.Var2);
% % ylim([80 160])
% % ylabel('Hourly Detections');
% % 
% % yyaxis right 
% % dtnew = datetime(dnnew,'ConvertFrom','datenum');
% % plot(dtnew,rotUtide);
% % scatter(dtnew(floodindex),rotUtide(floodindex));
% % scatter(dtnew(ebbindex),rotUtide(ebbindex),'k*');
% % ylabel('Flood & Ebb Tides');
% % 
% % 
% % 
% % 
% % 
% % westDets = find(mooredReceivers{2,1}.detections==63062); %hearing 15
% % selfDets = find(mooredReceivers{2,1}.detections==63073); %hearing self, 2
% % eastDets = find(mooredReceivers{2,1}.detections==63079); %hearing 4
% % southDets = find(mooredReceivers{2,1}.detections==63067); %hearing 3
% % 
% % length(westDets)
% % length(selfDets)
% % length(eastDets)
% % length(southDets)
% % 
% % 
% % % Testing 08ALTIN
% % 
% % selfDets = find(mooredReceivers{7,1}.detections==63076); 
% % NorthDets = find(mooredReceivers{7,1}.detections==63066); 
% % southWestDets = find(mooredReceivers{7,1}.detections==63063);
% % southsouthDets = find(mooredReceivers{7,1}.detections==63078);
% % southDets= find(mooredReceivers{7,1}.detections==63071);
% % 
% % length(selfDets)
% % length(NorthDets)
% % length(southWestDets)
% % length(southDets)
% % length(southsouthDets)
% % 
% % 
% % %Plotting some things
% % index1 = mooredReceivers{2,1}.detections >60000 & mooredReceivers{2,1}.detections ~= 63073;
% % index2 = mooredReceivers{7,1}.detections >60000 & mooredReceivers{7,1}.detections ~= 63076;
% % 
% % 
% % figure()
% % scatter(mooredReceivers{2,1}.DT(index1),mooredReceivers{2,1}.detections(index1),'r');
% % hold on
% % scatter(mooredReceivers{7,1}.DT(index2),mooredReceivers{7,1}.detections(index2),'b');
% % 
% % legend('Northwest Receiver','Southeast Receiver');
% % title('Detections, 2020 Deployment');
% % 
% % totalDets.DT= mooredReceivers{1,1}.DT;
% % totalDets.dets = mooredReceivers{1,1}.detections;
% % for kpop = 2:length(mooredReceivers)
% %     if isempty(mooredReceivers{kpop,1})
% %         continue
% %     end
% %     totalDets.DT = [totalDets.DT; mooredReceivers{kpop,1}.DT];
% %     totalDets.dets = [totalDets.dets; mooredReceivers{kpop,1}.detections];
% % end
% % 
% % figure()
% % histogram(totalDets.DT);
% % 
% % 
% % [J,K] = histcounts(totalDets.DT);
% % K = K(1:end-1);
% % 
% % binDT20 = K(1:108);
% % binDets20 = J(1:108);
% % 
% % %%
