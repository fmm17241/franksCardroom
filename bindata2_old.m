function [ym,yb,ystd,nn] = bindata2(y,x1,x2,x1rg,x2rg)
    %function [ym,yb] = bindata2(y,x1,x2,x1rg,x2rg)
    %Computes:
    %ym(ii,jj) = mean(y(x1>=x1rg(ii) & x1 < x1rg(ii+1) & x2>=x2rg(jj) & x2 < x2rg(jj+1))
    %for every ii, jj
    %If a bin is empty it returns nan for that bin
    %using a fast algorithm which uses no looping
    %Also returns yb, the approximation of y using binning (useful for r^2
    %calculations). Example:
    %
    %x = randn(500,2);
    %y = sum(x.^2,2) + randn(500,1);
    %xrg = linspace(-3,3,10)';
    %[ym,yb] = bindata2(y,x(:,1),x(:,2),xrg,xrg);
    %subplot(1,2,1);plot3(x(:,1),x(:,2),y,'.');
    %subplot(1,2,2);h = imagesc(xrg,xrg,ym);
    %set(h,'AlphaData',~isnan(ym)); box off;
    %
    %By Patrick Mineault
    %Refs: https://xcorr.net/?p=3326
    %      http://www-pord.ucsd.edu/~matlab/bin.htm

    ioutofxrange1=find(x1<min(x1rg) | x1>=max(x1rg)); y(ioutofxrange1)=nan;
    ioutofxrange2=find(x2<min(x2rg) | x2>=max(x2rg)); y(ioutofxrange2)=nan;

    notnans=find(~isnan(y)); x1=x1(notnans); x2=x2(notnans); y=y(notnans);


    [~,whichedge1] = histc(x1,x1rg(:)');
    [~,whichedge2] = histc(x2,x2rg(:)');
 
 % BUG: https://xcorr.net/2013/12/23/fast-1d-and-2d-data-binning-in-matlab/

    %% Set data outside of range to NaN (just for precaution)
    x1(whichedge1==0) = NaN;   %only data within bin range
    x2(whichedge2==0) = NaN;   %only data within bin range
    y(whichedge1==0 | whichedge2==0) = NaN;   %only data within bin range
 
    bins1 = min(max(whichedge1,1),length(x1rg)-1);
    bins2 = min(max(whichedge2,1),length(x2rg)-1);
%     bins1=whichedge1(whichedge1>0);
%     bins2=whichedge2(whichedge2>0);
 
    bins = (bins2-1)*(length(x1rg)-1)+bins1;
 
    xpos = ones(size(bins,1),1);
    ns = sparse(bins,xpos,1,(length(x1rg)-1)*(length(x2rg)-1),1);
    ysum = sparse(bins,xpos,y,(length(x1rg)-1)*(length(x2rg)-1),1);
    nn=full(ns);
    ym = full(ysum)./nn; 
    ystd=sqrt(full(ysum)./(nn-1) - ym.^2.*nn./(nn-1) );
    yb = ym(bins);
    ym = reshape(ym,length(x1rg)-1,length(x2rg)-1);
end
