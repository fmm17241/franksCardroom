cd /home/mfocean/Documents/1-Research/3-Codes/4-Pos/
load pres.mat
load MBAQ_data.mat

ttPres = datestr(mtt12,31);
tempPres = ph;

%%
tt = datestr(MBAQ.mtime,31);

YY=str2num(tt(:,1:4));
MM=str2num(tt(:,6:7));

mtt=MBAQ.mtime(YY==2004 & MM>=5 & MM<=7);
temp=MBAQ.ph(YY==2010 & MM>=5 & MM<=7);

temp10 = MBAQ.ph(YY==2010 & MM>=5 & MM<=7);

mtt10 = MBAQ.mtime(YY==2010 & MM>=5 & MM<=7);

newTT = datestr(mtt10,31);
YY=str2num(newTT(:,1:4));
MM=str2num(newTT(:,6:7));
%%
mtt5 = mtt10(MM==5);
mtt5 = datestr(mtt5);

mtt6 = mtt10(MM==6);
mtt6 = datestr(mtt6);

mtt7 = mtt10(MM==7);
mtt7 = datestr(mtt7);

temp5 = temp10(MM==5);
temp6 = temp10(MM==6);
temp7 = temp10(MM==7);

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

tryNewpH = zeros(1,length(may)+length(jun)+length(jul));
tryNewpH(1,1:length(may)) = may;
tryNewpH(1,length(may)+1:1464) = jun;
tryNewpH(1,1464+1:end) = jul;

%%
subplot('position',[.65 .07 .25 .25])
cc=get(gca,'colororder');
[Pxx,F,Pxxc] = pmtm(temp10,4,2^12,1/320,'ConfidenceLevel',.95);
Ps=sqrt(Pxx.*F);
Psc=sqrt(Pxxc.*F);
patch(log10([F(2:end); flipud(F(2:end)); F(2)].*86400),[Psc(2:end,1); flipud(Psc(2:end,2)); Psc(2,1)],cc(1,:),'edgecolor','none','facealpha',0.5); hold on;

plot(log10(F.*86400),Ps,'linewidth',2,'color',cc(1,:));
set(gca,'fontsize',16);
xlabel('cpd','fontsize',24,'interpreter','latex'); ylabel('pH','fontsize',24,'interpreter','latex');
axis([-.5 0.5 0 0.3]);
set(gca,'xtick',log10([.5 1 2 4 8]),'xticklabel',[1/2 1 2 4 8]);
box on; axis square;

hold on

annotation('textbox', [0.72, 0.21, 0.1, 0.1], 'FontSize',16,'FontWeight','bold','String', "f", 'EdgeColor','none')

%%
subplot('position',[.65 .07 .25 .25])
cc=get(gca,'colororder');
[Pxx,F,Pxxc] = pmtm(ph,3,2^8,1/4000,'ConfidenceLevel',.95);
Ps=sqrt(Pxx.*F);
Psc=sqrt(Pxxc.*F);

patch(log10([F(2:end); flipud(F(2:end)); F(2)].*86400),[Psc(2:end,1); flipud(Psc(2:end,2)); Psc(2,1)],cc(2,:),'edgecolor','none','facealpha',0.5); hold on;

plot(log10(F.*86400),Ps,'linewidth',2,'color',cc(2,:));
set(gca,'fontsize',16);
xlabel('cpd','fontsize',24,'interpreter','latex'); ylabel('pH','fontsize',24,'interpreter','latex');
axis([-.5 0.5 0 0.3]);
set(gca,'xtick',log10([.5 1 2 4 8]),'xticklabel',[1/2 1 2 4 8]);
box on;

%%
windowSize = 10; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

fph10 = filter(b,a,tryNewpH);
fph = filter(b,a,ph);

%%
subplot('position',[.1 .07 .55 .25])
plot(tryNewpH(1850:2000),'linewidth',2,'color',cc(1,:));hold on; plot(ph(703:853),'linewidth',2,'color',cc(2,:))
axis([0 155 7.55 8.05]);
set(gca,'ytick',[7.6 7.8 8.0]);
set(gca,'fontsize',16);
xlabel('time step(hours)','fontsize',22,'interpreter','latex'); ylabel('pH','fontsize',24,'interpreter','latex');
hold on

annotation('textbox', [0.11, 0.21, 0.1, 0.1], 'FontSize',16,'FontWeight','bold','String', "e", 'EdgeColor','none')

%%
%export_fig /home/mfocean/Documents/1-Research/3-Codes/4-Pos/fft_old.png -r300 -transparent