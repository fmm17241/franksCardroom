cd /home/mfocean/Documents/1-Research/3-Codes/4-Pos/
load pres.mat
load MBAQ_data.mat

ttPres = datestr(mtt12,31);
tempPres = temp12;

%%
tt = datestr(MBAQ.mtime,31);

YY=str2num(tt(:,1:4));
MM=str2num(tt(:,6:7));

%mtt=MBAQ.mtime(YY==2004 & MM>=5 & MM<=7);
%temp=MBAQ.temp(YY==2010 & MM>=5 & MM<=7);

temp06 = MBAQ.temp(YY==2006 & MM>=5 & MM<=7);

%%
temp00 = MBAQ.temp(YY==2000 & MM>=5 & MM<=7);
temp01 = MBAQ.temp(YY==2001 & MM>=5 & MM<=7);
temp02 = MBAQ.temp(YY==2002 & MM>=5 & MM<=7);
temp03 = MBAQ.temp(YY==2003 & MM>=5 & MM<=7);
temp04 = MBAQ.temp(YY==2004 & MM>=5 & MM<=7);
temp05 = MBAQ.temp(YY==2005 & MM>=5 & MM<=7);
temp08 = MBAQ.temp(YY==2008 & MM>=5 & MM<=7);
temp09 = MBAQ.temp(YY==2009 & MM>=5 & MM<=7);
temp10 = MBAQ.temp(YY==2010 & MM>=5 & MM<=7);

mm = min([length(temp00);length(temp01);length(temp02);length(temp03);...
   length(temp05);length(temp06);length(temp08);length(temp09);length(temp10)])

temp00 = temp00(1:mm);
temp01 = temp01(1:mm);
temp02 = temp02(1:mm);
temp03 = temp03(1:mm);
temp05 = temp05(1:mm);
temp06 = temp06(1:mm);
temp08 = temp08(1:mm);
temp09 = temp09(1:mm);
temp10 = temp10(1:mm);

%newTemp = [temp00; temp01; temp02; temp03; temp05; temp06; temp08;...
%           temp09; temp10];

mtt00 = MBAQ.mtime(YY==2000 & MM>=5 & MM<=7);
mtt01 = MBAQ.mtime(YY==2001 & MM>=5 & MM<=7);
mtt02 = MBAQ.mtime(YY==2002 & MM>=5 & MM<=7);
mtt03 = MBAQ.mtime(YY==2003 & MM>=5 & MM<=7);
mtt05 = MBAQ.mtime(YY==2005 & MM>=5 & MM<=7);
mtt06 = MBAQ.mtime(YY==2006 & MM>=5 & MM<=7);
mtt08 = MBAQ.mtime(YY==2008 & MM>=5 & MM<=7);
mtt09 = MBAQ.mtime(YY==2009 & MM>=5 & MM<=7);
mtt10 = MBAQ.mtime(YY==2010 & MM>=5 & MM<=7);

mtt00 = mtt00(1:mm);
mtt01 = mtt01(1:mm);
mtt02 = mtt02(1:mm);
mtt03 = mtt03(1:mm);
mtt05 = mtt05(1:mm);
mtt06 = mtt06(1:mm);
mtt08 = mtt08(1:mm);
mtt09 = mtt09(1:mm);
mtt10 = mtt10(1:mm);

%newMtt = [mtt00; mtt01; mtt02; mtt03; mtt05; mtt06; mtt08; mtt09; mtt10];

%%

newTT = datestr(mtt06,31);
YY=str2num(newTT(:,1:4));
MM=str2num(newTT(:,6:7));
%%
mtt5 = mtt06(MM==5);
mtt5 = datestr(mtt5);

mtt6 = mtt06(MM==6);
mtt6 = datestr(mtt6);

mtt7 = mtt06(MM==7);
mtt7 = datestr(mtt7);

temp5 = temp06(MM==5);
temp6 = temp06(MM==6);
temp7 = temp06(MM==7);

dd5 = str2num(mtt5(:,1:2));
dd6 = str2num(mtt6(:,1:2));
dd7 = str2num(mtt7(:,1:2));

hr5 = str2num(mtt5(:,13:14))+1;
hr6 = str2num(mtt6(:,13:14))+1;
hr7 = str2num(mtt7(:,13:14))+1;

may = zeros(1,31*24);
jun = zeros(1,30*24);
jul = zeros(1,31*24);

idx = 0;
while idx ~= length(may)
    for i=1:31
        for j=1:24
            may(1,j+idx) = nanmean(temp5(dd5==i & hr5==j));
        end
        idx = idx + 24
    end
    j+idx    
end

idx = 0;
while idx ~= length(jul)
    for i=1:31
        for j=1:24
            jul(1,j+idx) = nanmean(temp7(dd7==i & hr7==j));
        end
        j + idx
        idx = idx + 24
    end
    
end

 idx = 0;
while idx ~= length(jun)
    for i=1:30
        for j=1:24
            jun(1,j+idx) = nanmean(temp6(dd6==i & hr6==j));
        end
        j + idx
        idx = idx + 24
    end
    
end   

tryNewTemp = zeros(1,length(may)+length(jun)+length(jul));
tryNewTemp(1,1:length(may)) = may;
tryNewTemp(1,length(may)+1:1464) = jun;
tryNewTemp(1,1464+1:end) = jul;

%%
subplot('position',[.65 .73 .25 .25])
cc=get(gca,'colororder');
[Pxx,F,Pxxc] = pmtm(temp06,4,2^12,1/320,'ConfidenceLevel',.95);
%[Pxx,F,Pxxc] = pmtm(tryNew,4,2^8,1/3600,'ConfidenceLevel',.95);
Ps=sqrt(Pxx.*F);
Psc=sqrt(Pxxc.*F);

%patch(log10([F(2:end); flipud(F(2:end)); F(2)].*86400),log10([Pxxc(2:end,1); flipud(Pxxc(2:end,2))); Pxxc(2,1)]),cc(1,:),'edgecolor','none','facealpha',0.5); hold on;
patch(log10([F(2:end); flipud(F(2:end)); F(2)].*86400),[Psc(2:end,1); flipud(Psc(2:end,2)); Psc(2,1)],cc(1,:),'edgecolor','none','facealpha',0.5); hold on;

plot(log10(F.*86400),Ps,'linewidth',2,'color',cc(1,:));
set(gca,'fontsize',16);
xlabel('cpd','fontsize',24,'interpreter','latex'); ylabel('$^{\circ}$C','fontsize',24,'interpreter','latex');
axis([-.5 0.5 0 2.5]);
set(gca,'xtick',log10([.5 1 2 4 8]),'xticklabel',[1/2 1 2 4 8]);
box on;axis square;

hold on

annotation('textbox', [0.72, 0.87, 0.1, 0.1], 'FontSize',16,'FontWeight','bold','String', "b", 'EdgeColor','none')

%%
subplot('position',[.65 .73 .25 .25])
cc=get(gca,'colororder');
[Pxx,F,Pxxc] = pmtm(temp12,2,2^8,1/3900,'ConfidenceLevel',.95);
Ps=sqrt(Pxx.*F);
Psc=sqrt(Pxxc.*F);

patch(log10([F(2:end); flipud(F(2:end)); F(2)].*86400),[Psc(2:end,1); flipud(Psc(2:end,2)); Psc(2,1)],cc(2,:),'edgecolor','none','facealpha',0.5); hold on;

plot(log10(F.*86400),Ps,'linewidth',2,'color',cc(2,:));
set(gca,'fontsize',16);
xlabel('cpd','fontsize',24,'interpreter','latex'); ylabel('$^{\circ}$C','fontsize',24,'interpreter','latex');
axis([-.5 0.5 0 2.5]);
set(gca,'xtick',log10([.5 1 2 4 8]),'xticklabel',[1/2 1 2 4 8]);
box on; axis square;

%%
subplot('position',[.1 .73 .55 .25])
plot(tryNewTemp(1550:1700),'linewidth',2,'color',cc(1,:));hold on; plot(temp12(690:690+150),'linewidth',2,'color',cc(2,:))
axis([0 150 9 13]);
set(gca,'ytick',[9 11 13]);
set(gca,'fontsize',16);
xlabel('time step (hours)','fontsize',22,'interpreter','latex'); ylabel('$^{\circ}$C','fontsize',24,'interpreter','latex');
legend('InSitu','Model','Location','NorthEast')

annotation('textbox', [0.11, 0.87, 0.1, 0.1], 'FontSize',16,'FontWeight','bold','String', "a", 'EdgeColor','none')
