% Function to separate detections by which transmitter was heard
%INPUTS: 
% mooredGPS   = .mat includes lat/lon for each receiver;
% EXAMPLE of mooredGPS:
% mooredGPS(1,:) = 31.399049999999999 -80.902119999999996

%transmitters   = .mat includes transmitterID, going to be different each mission
% EXAMPLE OF 'transmitters': 
% transmitters = {'63068' '63073' '63067' '63079' '63080' '63066' '63076' '63078' '63063'...
%         '63070' '63074' '63075' '63081' '63064' '63062' '63071'};
%       
% GRtransmitters = detection data gained from vemprocess/detectionprocess


function [sortedbypings,transmitters,moglidist,bearing,moorings,gliderx,glidery,reflat,reflon,recdet] = sortbypings(mooredGPS,transmittersID,transmitters,Lat,Lon)
    %Values for Gray's Reef
%     reflat = 31.4002778;
%     reflon  = -80.8663888;
    %Values for USF Dataset
    reflat    = 27.89016555;
    reflon    = -83.8827555;
    [gliderx,glidery]=ll2xy(Lat,Lon,reflat,reflon);
    [moorings.xx,moorings.yy]=ll2xy(mooredGPS(:,1), mooredGPS(:,2), reflat,reflon);     % [1 X NM]
    L = length(transmittersID);
    tic;
    for imooring=1:L
       dx=gliderx-moorings.xx(imooring);
       dy=glidery-moorings.yy(imooring);
       angtemp=atan2d(dy,dx);
       disttemp=abs(dx+sqrt(-1)*dy);

       bearing(imooring,:)=angtemp;       % angle from mooring to glider or glider to mooring?
       moglidist(imooring,:)=disttemp;  %alternately sqrt(dx.*dx+dy.*dy)   
    end    
    toc
    
    new = string(transmitters.id);
    recdet = cell(1,1);
    for k = 1:L
        d = transmittersID(k);
        recdet{k} = find(strcmp(new,d));
        sortedbypings.dn{k}      = transmitters.DN(recdet{k});
        sortedbypings.dt{k}      = transmitters.datetime(recdet{k});
%         sortedbypings.tag{k}     = transmitters.tag(recdet{k});
        sortedbypings.id{k}      = transmitters.id(recdet{k});
        sortedbypings.gps_lat{k} = transmitters.gps_lat(recdet{k});
        sortedbypings.gps_lon{k} = transmitters.gps_lon(recdet{k});
        sortedbypings.gps{k}     = [transmitters.gps_lat(recdet{k}) transmitters.gps_lon(recdet{k})];
%         sortedbypings.vx{k}      = transmitters.vx(recdet{k});
%         sortedbypings.vy{k}      = transmitters.vy(recdet{k});
        sortedbypings.density{k} = transmitters.density(recdet{k});
        sortedbypings.depth{k}   = transmitters.depth(recdet{k});
        sortedbypings.press{k}   = transmitters.press(recdet{k});
        sortedbypings.salt{k}    = transmitters.salt(recdet{k});
        sortedbypings.temp{k}    = transmitters.temp(recdet{k});
        sortedbypings.speed{k}   = transmitters.speedsound(recdet{k});
    end
    
    
    for k = 1:L
        [detectx,detecty] = ll2xy(sortedbypings.gps_lat{k},sortedbypings.gps_lon{k},reflat,reflon);
        dx = detectx-moorings.xx(k);
        dy = detecty-moorings.yy(k);
        angull = atan2d(dy,dx);
        disttemp = abs(dx+sqrt(-1)*dy);
        sortedbypings.bearing{k} = angull;
        sortedbypings.distkm{k} = disttemp;
    end
    
    transmitters.distkm = [];
    for hp = 1:L
        currentmooring = hp;
        currentindex = recdet{hp};
        currentdist  = sortedbypings.distkm{hp};
        transmitters.distkm(currentindex) = currentdist;
    end
transmitters.distkm = transmitters.distkm'
    
    
end
