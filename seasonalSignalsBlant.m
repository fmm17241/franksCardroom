%Run after loading VUEexport data. This separates hourly detections into
%seasonal bins to look at.


%Seasonal differences? Numbers for season ends on hourly averages.
% 
% winter=1:1895; %Newyear to March 19th
% spring = 1896:4127; %March 20th to June 20th
% summer = 4128:6383; %June 21st to Sept 22nd
% fall   = 6384:8569; %Sept 23rd to December 22nd
% % winter2 = 8521:8784; % Chose not to include. Directly after Dec 22nd,
% % there is a very steep drop off believed to be transmitters going offline

%Changing this to Blanton's 5 wind regimes, should be clear differences

%%Five seasonal wind regimes from Blanton's wind, 1980
% Winter:           Nov-Feb
winter  = [1:1440,7320:8569]
% Spring:           Mar-May
spring   = 1441:3647;
% Summer:           June, July
summer   = 3648:5111;
% Fall:             August
fall     = 5112:5855;
% Mariner's Fall:   Sep-Oct
Mfall    =5856:7319;





%Find statistics for amounts. Ctrl-F and change Detections to Noise or vice
%versa. Gives 95% confidence interval as well.
averages        = [mean(hourlyAVG.Noise(winter)); mean(hourlyAVG.Noise(spring)); mean(hourlyAVG.Noise(summer)); mean(hourlyAVG.Noise(fall));mean(hourlyAVG.Noise(Mfall))]
standardError = [std(hourlyAVG.Noise(winter))/sqrt(length(hourlyAVG.Noise(winter))); std(hourlyAVG.Noise(spring))/sqrt(length(hourlyAVG.Noise(spring))); ...
    std(hourlyAVG.Noise(summer))/sqrt(length(hourlyAVG.Noise(summer)));std(hourlyAVG.Noise(fall))/sqrt(length(hourlyAVG.Noise(fall)));std(hourlyAVG.Noise(Mfall))/sqrt(length(hourlyAVG.Noise(Mfall)))];
tScores          = [tinv([0.025 0.975],length(hourlyAVG.Noise(winter))-1); tinv([0.025 0.975],length(hourlyAVG.Noise(spring))-1);...
    tinv([0.025 0.975],length(hourlyAVG.Noise(summer))-1); tinv([0.025 0.975],length(hourlyAVG.Noise(fall))-1);tinv([0.025 0.975],length(hourlyAVG.Noise(Mfall))-1)];
confidenceInterval = [mean(hourlyAVG.Noise(winter) + tScores(1,:)*standardError(1,:));    mean(hourlyAVG.Noise(spring) + tScores(2,:)*standardError(2,:));...
    mean(hourlyAVG.Noise(summer) + tScores(3,:)*standardError(3,:)); mean(hourlyAVG.Noise(fall) + tScores(4,:)*standardError(4,:));mean(hourlyAVG.Noise(Mfall) + tScores(5,:)*standardError(5,:))];
plusMinus = [tScores(1,:)*standardError(1,:);  tScores(2,:)*standardError(2,:); tScores(3,:)*standardError(3,:); tScores(4,:)*standardError(4,:)];



winterBin = hourlyAVG(winter,:); %Length: 1895
winterArray = [winterBin.Detections winterBin.Noise];

springBin = hourlyAVG(spring,:); %Length: 2232
springArray = [springBin.Detections springBin.Noise];

summerBin = hourlyAVG(summer,:); %Length: 2256
summerArray = [summerBin.Detections summerBin.Noise];

fallBin   = hourlyAVG(fall,:);   %Length: 2186
fallArray = [fallBin.Detections fallBin.Noise];

MfallBin   = hourlyAVG(Mfall,:);   %Length: 2186
MfallArray = [MfallBin.Detections MfallBin.Noise];



%Testing stats of different seasons' effects
% writematrix(winterArray,'winterArray.csv');
% writematrix(springArray,'springArray.csv');
% writematrix(summerArray,'summerArray.csv');
% writematrix(fallArray,'fallArray.csv');


%Plot seasons together, color coded
colorCodedSeasonsBlant

%%
%Plotting all of them together, just messing and seeing trends
x1 = 1:2690; x2 = 1:2207; x3 = 1:1464; x4 = 1:744; x5 = 1:1464;

figure()
plot(x1,winterBin.Detections,'b');
hold on
plot(x2,springBin.Detections,'g');
plot(x3,summerBin.Detections,'r');
plot(x4,fallBin.Detections,'k');
plot(x5,MfallBin.Detections,'c');


%%
%Histograms
% rr= 2;
% cc = 2;
% figure()
% set(gcf,'Position',[300 100 1000 700]);
% 
% s1 = subaxis(rr,cc,1,'MarginTop',0.04,'MarginLeft',0.06,'MarginRight',0.03,'SpacingHoriz',0.05,'SpacingVert',0.04);
% hold on
% histogram(winterBin.Detections,'FaceColor','b','BinWidth',0.5,'BinLimits',[4 16]);
% xticks('');
% ylabel('Hours');
% title('Winter');
% 
% s2 = subaxis(rr,cc,2,'MarginTop',0.04,'MarginLeft',0.06,'MarginRight',0.03,'SpacingHoriz',0.05,'SpacingVert',0.04);
% histogram(springBin.Detections,'FaceColor','g','BinWidth',0.5,'BinLimits',[4 16]);
% xticks('');
% title('Spring');
% 
% s3 = subaxis(rr,cc,3,'MarginTop',0.04,'MarginLeft',0.06,'MarginRight',0.03,'SpacingHoriz',0.05,'SpacingVert',0.04);
% histogram(summerBin.Detections,'FaceColor','r','BinWidth',0.5,'BinLimits',[4 16]);
% ylabel('Hours');
% xlabel('Detections, Hourly');
% title('Summer');
% 
% s4 = subaxis(rr,cc,4,'MarginTop',0.04,'MarginLeft',0.06,'MarginRight',0.03,'SpacingHoriz',0.05,'SpacingVert',0.04);
% histogram(fallBin.Detections,'FaceColor','k','BinWidth',0.5,'BinLimits',[4 16]);
% title('Fall');
% xlabel('Detections, Hourly');
% 
% 
% rr= 1; cc=4;
% figure()
% set(gcf,'Position',[300 100 1000 300]);
% 
% s1 = subaxis(rr,cc,1,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.03,'MarginBot',0.15,'SpacingHoriz',0.02,'SpacingVert',0.04);
% hold on
% histogram(winterBin.Detections,'FaceColor','b','BinWidth',0.5,'BinLimits',[4 16]);
% % xticks('');
% ylabel('Hours');
% title('Winter');
% 
% s2 = subaxis(rr,cc,2,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.03,'MarginBot',0.15,'SpacingHoriz',0.02,'SpacingVert',0.04);
% histogram(springBin.Detections,'FaceColor','g','BinWidth',0.5,'BinLimits',[4 16]);
% % xticks('');
% yticks('');
% title('Spring');
% 
% s3 = subaxis(rr,cc,3,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.03,'MarginBot',0.15,'SpacingHoriz',0.02,'SpacingVert',0.04);
% histogram(summerBin.Detections,'FaceColor','r','BinWidth',0.5,'BinLimits',[4 16]);
% % ylabel('Hours');
% yticks('');
% xTootz = xlabel('Detections, Hourly','fontweight','bold');
% title('Summer');
% 
% s4 = subaxis(rr,cc,4,'MarginTop',0.07,'MarginLeft',0.06,'MarginRight',0.03,'MarginBot',0.15,'SpacingHoriz',0.02,'SpacingVert',0.04);
% histogram(fallBin.Detections,'FaceColor','k','BinWidth',0.5,'BinLimits',[4 16]);
% yticks('');
% title('Fall');
% 
% xTootz.Position(1) = xTootz.Position(1) - 7;

%%
%power spectrum for seasonal data


% springSignal = springBin.Detections; 
% summerSignal = summerBin.Detections; 
% fallSignal   = fallBin.Detections;   
% MfallSignal = MfallBin.Detections;
% winterSignal = winterBin.Detections; 
% 
% 
% win = 24*20; %15 day windows for Welch's power spectrum
% sampleFreq = 1/3600;
% [pxx,f]= pwelch(winterSignal,win,[],[],sampleFreq,'onesided');
% figure()
% loglog(f.*86400,pxx.*f,'b');
% ylabel('Power');
% xlabel('Cycles Per Day');
% title('2020 Spring, Power Spectrum');
% hold on
% [pxx,f]= pwelch(springSignal,win,[],[],sampleFreq,'onesided');
% loglog(f.*86400,pxx.*f,'g');
% [pxx,f]= pwelch(summerSignal,win,[],[],sampleFreq,'onesided');
% loglog(f.*86400,pxx.*f,'r');
% [pxx,f]= pwelch(fallSignal,win,[],[],sampleFreq,'onesided');
% loglog(f.*86400,pxx.*f,'k');
% 
% legend('Winter','Spring','Summer','Fall')

%%
% Gonna filter out frequencies less than 5 days; want to investigate
% spring/neap
% cutoff = (1/432000); %5 day frequency
% fs = 1/3600;
% Wn = cutoff/(0.5*fs);
% 
% 
% [B,A] = butter(3,Wn,'low');
% [D,C] = butter(3,Wn,'high');
% 
% 
% 
% filtLow = filtfilt(B,A,winterSignal);
% filtHigh= filtfilt(D,C,winterSignal);
% 
% figure()
% plot(hourlyAVG.Time(winter),filtLow);
% title('low');
% 
% figure()
% plot(hourlyAVG.Time(winter),filtHigh);
% title('high');




