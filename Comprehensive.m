% Testing full process files, learning how to make functions rather than
% scripts.
load angusdbdAprilMay
load angusebdAprilMay

% Bindata for different missions
[matstruct,dn,z,temp] = Bindata(fstruct,sstruct);


%Processs raw .vem files, the outputs of our sensors
cd ([oneDrive,'Glider\Data\Vemco\SpringFallDets'])

vems = vemProcess(pwd);

%Load data that has been load_all_glider_data'd

%Gives context to acoustic detections and tells us the physical parameters
%the glider was in at the time.
% [GRtransmitters, correctdn, correctvx,correctvy,correctlat,correctlon,scidn,...
%     temp,density,depth,pressure,salt,speed] =detectionprocess(fstruct,sstruct,vems);

%Detection subset, no doubles
[transmitters, correctedDN,correctedLat,correctedLon,correctedGPS,scidn,...
    temperature,density,depth,pressure,salt,speed] =processDetections(fstruct,sstruct,vems);

%FULL detections heard from moorings, curious about echoes/doubles
% [GRtransmitters, correctdn, correctvx,correctvy,correctlat,correctlon,correctgps,scidn,...
%     temperature,density,depth,pressure,salt,speed] =detectionprocesstest(fstruct,sstruct,vems);


[yoSSP,yotemps,yotimes,yodepths,yosalt,yospeed] = yoDefiner(scidn, depth, temperature, salt, speed)


%Gives us water column data before and after each detection. 
 %First input is number of datapoints near detection
% [ProcessedProfiles,ProcessedDensity] = findprofiles(80,GRtransmitters,scidn,temperature,density,depth,pressure,...
%     salt,speed);
% ProcessedProfiles format: [ProcessedTime ProcessedDensity ProcessedDepth... 
% ProcessedPressure ProcessedSalt ProcessedTemp ProcessedSpeed];

%Load mooring data (which transmitter was where, and separate the pings
load mooredGPS 

%Below loads the name of each transmitter, then depth of receiver(m) and
%water depth(m)
load 2020mooredinfo



transmittersID = {'63068' '63073' '63067' '63079' '63080' '63066' '63076' '63078' '63063'...
        '63070' '63074' '63075' '63081' '63064' '63062' '63071'};
    

    
[sortedbypings,transmitters,moglidist,bearing, moorings,gliderx,glidery,reflat,reflon,recdet] = sortbypings(mooredGPS,transmittersID,transmitters,correctedLat,correctedLon);


rangeProcessing



%Predicts tides for the 2020 mission
% tidalAnalysis2020


[bulktime,bulkrho,bulktemp,transmitters,detrho,dettemp] = binnedbulkstrat(matstruct,transmitters);


plotReef

AsAboveSoBelowThermocline2020

rangePlusThermocline




% 
% fitdist kernel distrubtion
% 
% figure()
% histogram(xtest,'Normalization','pdf','BinWidth',100);
% line(x_pdf,y);
% title('Probability Density Function, Normal');
% xlabel('Distance (m)');
% A = icdf(pdx,0.75)
% 
% figure()
% yyaxis left
% histogram(xtest,'BinWidth',100);
% ylabel('Detections');
% yyaxis right
% h = line(x_pdf,y);
% b = line(x_pdf,ylog);
% ylabel('PDF Values');
% set(h,'Color','k');
% set(b,'Color','r');
% legend('Detections Per 100m','Normal PDF','LogNormal PDF');
% title('Probability Density Function');
% xlabel('Distance (m)');
% A = icdf(pdx,0.75)
% 
% 
% [h,p,stats] = chi2gof(xtest);







% 
% figure()
% plot(fullshift(:,1),fullshift(:,2));
% hold on
% for k = 1:length(floodtime)
%     xline(floodtime(k),'k');
% end
% % for k = 1:length(ebbtime)
% %     xline(ebbtime(k),'r')
% % end
% hold off
% datetick('x','keeplimits');
% xlabel('Days');
% ylabel('Detections Per Hour');
% title('Black is Flood Tide');


% 
% [frequency,freqDN,freqDT] = BVfm(matstruct);
% 
% figure()
% plot(freqDN(1:74),frequency(1:74));
% 
% 
% cutoff = (1/144000);     %40 hours
% % cutoff   = (1/259200); % 3 days
% % cutoff = (1/345600)    % 4 days
% % cutoff = (1/432000)      % 5 days
% 
% %Sampling rate
% fs     = (1/3600);
% Wn = cutoff/(0.5*fs);
% [B,A] = butter(5,Wn,'low');
% tideVx = filtfilt(B,A,frequency);
% 


% 
% GRreceivers2020 = GRtransmitters;
% frequency2020   =  frequency;
% freqDN2020      =  freqDN;
% 
% clearvars -except GRreceivers2020 frequency2020 freqDN2020 

%% MayJune 2019 Test- Need to use process even for those that have multipled "states" of where the 
% transmitters could be.
% 
% cd 'G:\Glider\Data\Vemco\franklin20190621'
% vems = vemprocess(pwd);
% 
% load Deployment_May_2019_franklin_alldbds
% load Deployment_May_2019_franklin_allebds
% 
% [GRtransmitters, correctdn, correctvx,correctvy,correctlat,correctlon,correctgps,scidn,...
%     temp,density,depth,pressure,salt,speed] =detectionprocess(fstruct,sstruct,vems);
% 
% 
% load mooredGPS 
% transmitters = {'00000' '11111' '22222' '33333' '44444' '111245' '66666' '77777' '88888'...
%         '99999' '10000' '12121' '13131' '63069' '63067' '63068'};
% [sortbypings,GRtransmitters,moglidist,bearing,gliderx,glidery,reflat,reflon,recdet] = sortbypingsfunction(mooredGPS,transmitters,GRtransmitters,correctlat,correctlon);
% 
% 
% whereyouatdoe
% 
