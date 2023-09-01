
cd ([oneDrive,'Glider\Data\Vemco\angus20190621'])
vems = vemProcess(pwd);

load nov19dbd
load nov19ebd

[matstruct] = Bindata(fstruct,sstruct);
matstruct.speed = sndspd(matstruct.salin,matstruct.temp,matstruct.z);




[GRtransmitters, correctdn,correctlat,correctlon,correctgps,scidn,...
    temp,density,depth,pressure,salt,speed] = processDetections(fstruct,sstruct,vems);


load mooredGPS 


moored = {'FS17','STSNew1','33OUT','34ALTOUT','09T','Roldan',...
          '08ALTIN','14IN','West15','08C','STSNew2','FS6','39IN','SURTASS_05IN',...
          'SURTASS_STN20','SURTASS_FS15'}.';

% 10/17 to 11/20/19, 35 DAYS
dayset{1} = 1:91;
transmitters{1} ={'63079' '63075' '63076' '63066' '63073' '63078' '63074' '63081' '63063'...
    '63064' '63070' '63062' '63080' '63071' '63069' '63077'};
transmitters2(1,:) =string(transmitters{1,1});
%11/20- 11/21/19, 1 Day
dayset{2} = 92:119;
transmitters{2} ={'63068' '63075' '63067' '63079' '63073' '63078' '63074' '63081' '63063'...
    '63064' '63070' '63062' '63080' '63071' '63069' '63077'};
transmitters2(2,:) =string(transmitters{1,2});
%11/21- 11/22/19, 1 Day
dayset{3} = 120:149;
transmitters{3} = {'63068' '63075' '63067' '63079' '63073' '63066' '63076' '63078' '63063'...
    '63064' '63070' '63062' '63080' '63071' '63069' '63077'};
transmitters2(3,:) =string(transmitters{1,3});
%11/22-11/26/19, 5 Days
dayset{4} = 150:351;
transmitters{4} = {'63068' '63075' '63067' '63079' '63080' '63066' '63076' '63078' '63063'...
    '63064' '63074' '63062' '63081' '63071' '63069' '63077'};
transmitters2(4,:) =string(transmitters{1,4});
%11/26-12/6/19, 11 Days
dayset{5} =352:463;
transmitters{5} = {'63068' '63073' '63067' '63079' '63080' '63066' '63076' '63078' '63063'...
    '63070' '63074' '63062' '63081' '63071' '63069' '63077'};
transmitters2(5,:) =string(transmitters{1,5});

reflat = 31.4002778;
reflon  = -80.8663888;
[gliderx,glidery]=ll2xy(correctlat,correctlon,reflat,reflon);
[moorings.xx,moorings.yy]=ll2xy(mooredGPS(:,1), mooredGPS(:,2), reflat,reflon);  

tic;
    for imooring=1:16
       dx=gliderx-moorings.xx(imooring);
       dy=glidery-moorings.yy(imooring);
       angtemp=atan2d(dy,dx);
       disttemp=abs(dx+sqrt(-1)*dy);

       bearing(imooring,:)=angtemp;       % angle from mooring to glider or glider to mooring?
       moglidist(imooring,:)=disttemp;  %alternately sqrt(dx.*dx+dy.*dy)   
    end    
toc



GRtransmitterz =cell(1,1);
startIndex=[1,92,120,150,352];
endIndex=[91,119,149,351,463];
for setCounter = 1:5
    for k = startIndex(setCounter):endIndex(setCounter)
        GRtransmitterz{setCounter}.DN             = GRtransmitters.DN(dayset{setCounter});
        GRtransmitterz{setCounter}.dt             = GRtransmitters.datetime(dayset{setCounter});
        GRtransmitterz{setCounter}.tag            = GRtransmitters.tag(dayset{setCounter});
        GRtransmitterz{setCounter}.id             = GRtransmitters.id(dayset{setCounter});
        GRtransmitterz{setCounter}.gps_lat        = GRtransmitters.gps_lat(dayset{setCounter});
        GRtransmitterz{setCounter}.gps_lon        = GRtransmitters.gps_lon(dayset{setCounter});
        GRtransmitterz{setCounter}.vx             = GRtransmitters.vx(dayset{setCounter});
        GRtransmitterz{setCounter}.vy             = GRtransmitters.vy(dayset{setCounter});
        GRtransmitterz{setCounter}.density        = GRtransmitters.density(dayset{setCounter});
        GRtransmitterz{setCounter}.depth          = GRtransmitters.depth(dayset{setCounter});
        GRtransmitterz{setCounter}.press          = GRtransmitters.press(dayset{setCounter});
        GRtransmitterz{setCounter}.salt           = GRtransmitters.salt(dayset{setCounter});
        GRtransmitterz{setCounter}.temp           = GRtransmitters.temp(dayset{setCounter});
        GRtransmitterz{setCounter}.speedsound     = GRtransmitters.speedsound(dayset{setCounter});
    end
end


recdet=cell(16,1);
%%

for recordCounter=1:length(GRtransmitters.id)
    if ismember(recordCounter,dayset{1})
        GRtransmitters.currenttransmitter{recordCounter,1}= transmitters{1}';
    elseif ismember(recordCounter,dayset{2})
        GRtransmitters.currenttransmitter{recordCounter,1}= transmitters{2}';
    elseif ismember(recordCounter,dayset{3})
        GRtransmitters.currenttransmitter{recordCounter,1}= transmitters{3}';
    elseif ismember(recordCounter,dayset{4})
        GRtransmitters.currenttransmitter{recordCounter,1}= transmitters{4}';
    elseif ismember(recordCounter,dayset{5})
        GRtransmitters.currenttransmitter{recordCounter,1}= transmitters{5}';
    end
end
FullTransList = cellfun(@str2num,GRtransmitters.id);

%%

ALLid = string(GRtransmitters.id);

Waldo = [];
sortbypings =cell(16,1);
for k =1:length(GRtransmitters.id)
    d = GRtransmitters.currenttransmitter{k}'
    Waldo = find(strcmp(ALLid(k),d))
    sortbypings{Waldo}.dn(k)      = GRtransmitters.DN(k);
    sortbypings{Waldo}.dt(k)     = GRtransmitters.datetime((k));
    sortbypings{Waldo}.tag(k)     = GRtransmitters.tag((k));
    sortbypings{Waldo}.id(k)      = GRtransmitters.id((k));
    sortbypings{Waldo}.gps_lat(k) = GRtransmitters.gps_lat((k));
    sortbypings{Waldo}.gps_lon(k) = GRtransmitters.gps_lon((k));
    sortbypings{Waldo}.gps(k,:)   = [GRtransmitters.gps_lat((k)) GRtransmitters.gps_lon((k))];
    sortbypings{Waldo}.vx(k)      = GRtransmitters.vx((k));
    sortbypings{Waldo}.vy(k)      = GRtransmitters.vy((k));
    sortbypings{Waldo}.density(k) = GRtransmitters.density((k));
    sortbypings{Waldo}.depth(k)   = GRtransmitters.depth((k));
    sortbypings{Waldo}.press(k)   = GRtransmitters.press((k));
    sortbypings{Waldo}.salt(k)    = GRtransmitters.salt((k));
    sortbypings{Waldo}.temp(k)    = GRtransmitters.temp((k));
    sortbypings{Waldo}.speed(k)   = GRtransmitters.speedsound((k));

end
    
%%
for k = 1:16
    Dracula = isempty(sortbypings{k});
    if Dracula == 1
        continue
    end
    sortbypings{k}.dn      = sortbypings{k}.dn(sortbypings{k}.dn~=0);
    sortbypings{k}.dt      = rmmissing(sortbypings{k}.dt);
    sortbypings{k}.tag     = sortbypings{k}.tag(~cellfun(@isempty,sortbypings{k}.tag));
    sortbypings{k}.id      = sortbypings{k}.id(~cellfun(@isempty,sortbypings{k}.id));
    sortbypings{k}.gps_lat = sortbypings{k}.gps_lat(sortbypings{k}.gps_lat~=0);
    sortbypings{k}.gps_lon = sortbypings{k}.gps_lon(sortbypings{k}.gps_lon~=0);
    sortbypings{k}.gps     = [sortbypings{k}.gps_lat sortbypings{k}.gps_lon];
    sortbypings{k}.vx      = sortbypings{k}.vx(sortbypings{k}.vx~=0);
    sortbypings{k}.vy      = sortbypings{k}.vy(sortbypings{k}.vy~=0);
    sortbypings{k}.density = sortbypings{k}.density(sortbypings{k}.density~=0);
    sortbypings{k}.depth   = sortbypings{k}.depth(sortbypings{k}.depth~=0);
    sortbypings{k}.press   = sortbypings{k}.press(sortbypings{k}.press~=0);
    sortbypings{k}.salt    = sortbypings{k}.salt(sortbypings{k}.salt~=0);
    sortbypings{k}.temp    = sortbypings{k}.temp(sortbypings{k}.temp~=0);
    sortbypings{k}.speed   = sortbypings{k}.speed(sortbypings{k}.speed~=0);
%     
end

%%


for k = 1:16
    Dracula = isempty(sortbypings{k});
    if Dracula == 1
        continue
    end
    [detectx,detecty] = ll2xy(sortbypings{k}.gps_lat,sortbypings{k}.gps_lon,reflat,reflon);
    dx = detectx-moorings.xx(k);
    dy = detecty-moorings.yy(k);
    angull = atan2d(dy,dx);
    disttemp = abs(dx+sqrt(-1)*dy);

    sortbypings{k}.bearing = angull;
    sortbypings{k}.distkm = disttemp;

end


for full = 1:length(GRtransmitters.id)
    usenowdude = FullTransList(full);
    currenttrans = cellfun(@str2num,GRtransmitters.currenttransmitter{full});
    [~,~,meech] = intersect(usenowdude,currenttrans);
    [detectx,detecty] = ll2xy(GRtransmitters.gps_lat(full),GRtransmitters.gps_lon(full),reflat,reflon);
    dx = detectx-moorings.xx(meech);
    dy = detecty-moorings.yy(meech);
    angull = atan2d(dy,dx);
    disttemp = abs(dx+sqrt(-1)*dy);
    GRtransmitters.bearing(full,1) = angull;
    GRtransmitters.distkm(full,1)  = disttemp;
end

%%
% [matstruct] = Bindata(fstruct,sstruct);
% [frequency,freqDN,freqDT] = BVfm(matstruct);
% test = frequency<0;
% frequency =frequency(~test);
% test2 = freqDN(~test);
% ind = frequency<4.95e-5;
% frequency = frequency(ind);
% freqDN=test2(ind);



% plot(freqDN,frequency);
% datetick('x','keeplimits');
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
% filtfrequency = filtfilt(B,A,frequency);
% 
% %% Tidal
% cd G:\Glider\Data\ADCP\
% load GR_adcp_30minave_magrot.mat
% adcp
% uz = nanmean(adcp.u);
% vz = nanmean(adcp.v);
% xin = (uz+sqrt(-1)*vz);
% [struct, xout] = t_tide(xin,'interval',adcp.dth,'start time',adcp.dn(1),'latitude',adcp.lat);
% tideU = real(xout);
% tideV = imag(xout);
% 
% 
% constituents = [1:35];
% datetide = [0.5,12,11,2019];
% endtide  = [13.5,28,11,2019];
% 
% 
% [time,ut,vt] = uvpred(struct.tidecon(:,1),struct.tidecon(:,3),struct.tidecon(:,7),struct.tidecon(:,5),constituents,datetide,1,16);
% 
% dnnew=(datenum(2019,11,12,00,30,00):1/24:datenum(2019,11,28,00,30,00));
% dtnew = datetime(dnnew,'ConvertFrom','datenum');
% 
% 
% %plotted, 50-100, Nov14,2019 01:30:00 to Nov16,2019 03:30:00
% yesyes = [737743.062500000 737745.145833333];
% 
% figure()
% ax = [[737743.312500000] [737745.145833333] -0.4 0.4];
% stickplot(dnnew,ut,vt,ax);
% datetick('x','KeepLimits');
% xlabel('Time');
% ylabel('Current Magnitude,m/s');
% title('Tidal Currents');
% 
% figure()
% plot(freqDT(52:100),frequency(52:100));
% datetick('x','KeepLimits');
% xlabel('Time');
% ylabel('Bulk Stratification');
% title('Change in Stratification, Nov 19');




% This sets the distance (range) at which we're indexing the glider path
% by.
%%
rangedist = [2000,1900,1800,1700,1600,1500,1400,1300,1200,1100,1000,900,800,700,600,500,400,300,200,100];  %distance in METERS
for P = 1:length(rangedist)-1
    for k =1:16
        closeindex = moglidist(k,:)<rangedist(P) & moglidist(k,:)>rangedist(P+1);
        within{k,P}.dn = correctdn(closeindex);
        within{k,P}.dt = datetime(within{k,P}.dn,'ConvertFrom','datenum');
        within{k,P}.distance=moglidist(k,closeindex);within{k,P}.gps = correctgps(closeindex,:);
       Dracula = isempty(sortbypings{k});
        if Dracula == 1
            within{k,P}.detections = [];
            continue
        end
        index = sortbypings{k}.distkm<rangedist(P) & sortbypings{k}.distkm>rangedist(P+1);
        within{k,P}.detections = sortbypings{k}.distkm(index);
        within{k,P}.bearing  = sortbypings{k}.bearing(index);
    end
end
for P = length(rangedist)
    for k =1:16
        closeindex = moglidist(k,:)<rangedist(P);
        within{k,P}.dn = correctdn(closeindex);
        within{k,P}.dt = datetime(within{k,P}.dn,'ConvertFrom','datenum');
        within{k,P}.distance=moglidist(k,closeindex);within{k,P}.gps = correctgps(closeindex,:);
        Dracula = isempty(sortbypings{k});
        if Dracula == 1
            within{k,P}.detections = [];
            continue
        end
        index = sortbypings{k}.distkm<rangedist(P);
        within{k,P}.detections = sortbypings{k}.distkm(index);
        within{k,P}.bearing  = sortbypings{k}.bearing(index);
    end
end

%%

% btween = 0.000578185508959; %Threshold: 50 seconds
% spaceinvaders = [];
% timediff = [];
% passport = cell(1,1);
% allindy  = cell(1,1);
% for P = 1:length(rangedist)
%     for k=1:16
%     %         chump = isempty(within{k});
%     %         if chump == 1
%     %             continue
%     %         end
%         L = length(within{k,P}.dn);
%         indy = [];
%         ComeNGo = [];
%         for LK = 1:L-1
%             spaceinvaders = within{k,P}.dn(LK+1)-within{k,P}.dn(LK);
%             timediff  = within{k,P}.dt(LK);
%                 if spaceinvaders > btween;
%     %                ComeNGo = vertcat(ComeNGo,spaceinvaders);
%                   indy = vertcat(indy,LK);
%                   ComeNGo = vertcat(ComeNGo,timediff);
%                 end
%         end
%         allindy{k,P}    = indy;
%         passport{k,P} = ComeNGo;
%     end
% end


%%
for P = 1:length(rangedist)
    for k =1:16
        durationz{k,P} = calendarDuration(0,0,0,0,0,1);
    end
end
    
for P = 1:length(rangedist)
    for k=1:16
       chump = isempty(within{k,P});
        if chump == 1
            continue
        end 
        numberz = length(within{k,P}.dt);   %Number of datapoints
        onedata = 4;                        %Seconds represented by each data point
        durationz{k,P} = (numberz*onedata)/60;  %Minutes spent in area
        ExpectedPings{k,P} = (durationz{k,P})/10;
    end
end


%%
numb = cell(1,1);
for P = 1:length(rangedist)
    for k=1:16
%         if k == 15
%             continue
%         end
        numb{k,P} = numel(within{k,P}.detections);  
        
        
        EfficiencyFinal{k,P} = numb{k,P}/ExpectedPings{k,P};
        
    end
end


%%TEST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for P = 1:length(rangedist)
    for k =1:16
        durationz{k,P} = calendarDuration(0,0,0,0,0,1);
    end
end
    
totalTime=zeros(20,1);
for P = 1:length(rangedist)
    for k=1:16
       chump = isempty(within{k,P});
        if chump == 1
            continue
        end 
        numberz = length(within{k,P}.dt);   %Number of datapoints
        onedata = 4;                        %Seconds represented by each data point
        timeSpent(k,P) = (numberz*onedata)/60;  %Minutes spent in area
    end
end

for P = 1:length(rangedist)
    totalTime(P) = sum(timeSpent(:,P))
end
ExpectedPings = totalTime/10


%%
numb = zeros(20,1);
for P = 1:length(rangedist)
    for k=1:16
%         if k == 15
%             continue
%         end
        numb(P) = numb(P) + numel(within{k,P}.detections);       
    end
end


EfficiencyFinal{k,P} = numb{k,P}/ExpectedPings{k,P};
DetectionEfficiency = numb/ExpectedPings




% 
% AsAboveSoBelow2019warm
% strategumz2019