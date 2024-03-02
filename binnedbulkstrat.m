%% Only useable after moorings or cath or take2, something that has separated acoustic detections by what heard it and when
% Bindata or BindataUse has to be pointed to the correct dbd/ebd files.
%Frank appending 3/2/24

function [bulktime,bulkrho,bulktemp] = binnedbulkstrat(matstruct)


LL = length(matstruct.rho);

for k = 1:LL
    validIndices = ~isnan(matstruct.rho(k,:));
    pooteen  = isempty(find(validIndices));
    if pooteen == 1
        continue
    end
    rho = matstruct.rho(k,validIndices);
    temp = matstruct.temp(k,validIndices);
    bulktime(k) = matstruct.dt(k);
    bulkrho(k)  = abs(rho(end)-rho(1));
    bulktemp(k) = abs(temp(end)-temp(1));
end
bulktime.TimeZone = 'UTC';

% if nargin == 2
% 
%     L = length(transmitters.DN);
%     indy = [];
%     for k =1:L
%         [~,indy(k)] = (min(abs(transmitters.DN(k)-matstruct.dn)));
%     end
% 
%     transmitters.binnedDN = matstruct.dn(indy);
%     detrho = cell(1,1);
%     dettemp = cell(1,1);
%     for k = 1:L
%                 [~,idx] = intersect(matstruct.dn,transmitters.binnedDN(k),'stable');
%                 validIndices = ~isnan(matstruct.rho(idx,:));   
%                 rho         = matstruct.rho(idx,validIndices);
%                 temp        = matstruct.temp(idx,validIndices);
%                 detrho{k}  =  abs(rho(end)-rho(1));
%                 dettemp{k} = abs(temp(end)-temp(1));
%     end
%     transmitters.deltarho = cell2mat(detrho.'); 
%     transmitters.deltaT   = cell2mat(dettemp.');
% end
% 
end



