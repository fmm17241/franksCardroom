%clear all
%clc

cd /home/mfocean/Documents/1-Research/3-Codes/4-Pos/
load pres.mat
load MBAQ_data.mat

ttPres = datestr(mtt12,31);
tempPres = DO_mgL;

DO = tempPres;

Units = 'mg/L';
Temp_C = temp12;
Sal_psu = ones(length(temp12(:,1)),1)*34;
Press_db = 15;
[DO_umolkg,DO_umolL,DO_mgL,DO_mlL,DO_perctsat] = convertDOunits(DO,Units,Temp_C,Sal_psu,Press_db);

%%
tt = datestr(MBAQ.mtime,31);

YY=str2num(tt(:,1:4));
MM=str2num(tt(:,6:7));

%mtt=MBAQ.mtime(YY==2004 & MM>=5 & MM<=7);
%temp=MBAQ.temp(YY==2010 & MM>=5 & MM<=7);

%do00 = MBAQ.do_umkg(YY==2000 & MM>=5 & MM<=7);
%do01 = MBAQ.do_umkg(YY==2001 & MM>=5 & MM<=7);
%do02 = MBAQ.do_umkg(YY==2002 & MM>=5 & MM<=7);
%do03 = MBAQ.do_umkg(YY==2003 & MM>=5 & MM<=7);
%temp04 = MBAQ.temp(YY==2004 & MM>=5 & MM<=7);
%do05 = MBAQ.do_umkg(YY==2005 & MM>=5 & MM<=7);
do06 = MBAQ.do(YY==2006 & MM>=5 & MM<=7);
%do08 = MBAQ.do_umkg(YY==2008 & MM>=5 & MM<=7);
%do09 = MBAQ.do_umkg(YY==2009 & MM>=5 & MM<=7);
%do10 = MBAQ.do_umkg(YY==2010 & MM>=5 & MM<=7);

%% 
mtt06 = MBAQ.mtime(YY==2006 & MM>=5 & MM<=7);

newMTT = datestr(mtt06,31);
YY=str2num(newMTT(:,1:4));
MM=str2num(newMTT(:,6:7));
%%

%mm = min([length(do00);length(do01);length(do02);length(do03);...
 %   length(do05);length(do06);length(do08);length(do09);length(do10)])

%do00 = do00(1:mm);
%do01 = do01(1:mm);
%do02 = do02(1:mm);
%do03 = do03(1:mm);
%do05 = do05(1:mm);
%do06 = do06(1:mm);
%do08 = do08(1:mm);
%do09 = do09(1:mm);
%do10 = do10(1:mm);

%newTemp = [do00; do01; do02; do03; do05; do06; do08;...
%           do09; do10];

% mtt00 = MBAQ.mtime(YY==2000 & MM>=5 & MM<=7);
% mtt01 = MBAQ.mtime(YY==2001 & MM>=5 & MM<=7);
% mtt02 = MBAQ.mtime(YY==2002 & MM>=5 & MM<=7);
% mtt03 = MBAQ.mtime(YY==2003 & MM>=5 & MM<=7);
% mtt05 = MBAQ.mtime(YY==2005 & MM>=5 & MM<=7);
% mtt06 = MBAQ.mtime(YY==2006 & MM>=5 & MM<=7);
% mtt08 = MBAQ.mtime(YY==2008 & MM>=5 & MM<=7);
% mtt09 = MBAQ.mtime(YY==2009 & MM>=5 & MM<=7);
% mtt10 = MBAQ.mtime(YY==2010 & MM>=5 & MM<=7);
% 
% mtt00 = mtt00(1:mm);
% mtt01 = mtt01(1:mm);
% mtt02 = mtt02(1:mm);
% mtt03 = mtt03(1:mm);
% mtt05 = mtt05(1:mm);
% mtt06 = mtt06(1:mm);
% mtt08 = mtt08(1:mm);
% mtt09 = mtt09(1:mm);
% mtt10 = mtt10(1:mm);
% 
% newMtt = [mtt00; mtt01; mtt02; mtt03; mtt05; mtt06; mtt08; mtt09; mtt10];
% 
% newTT = datestr(newMtt,31);
% YY=str2num(newTT(:,1:4));
% MM=str2num(newTT(:,6:7));

%%

%%
mtt5 = mtt06(MM==5);
mtt5 = datestr(mtt5);

mtt6 = mtt06(MM==6);
mtt6 = datestr(mtt6);

mtt7 = mtt06(MM==7);
mtt7 = datestr(mtt7);

temp5 = do06(MM==5);
temp6 = do06(MM==6);
temp7 = do06(MM==7);

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

tryNewDO = zeros(1,length(may)+length(jun)+length(jul));
tryNewDO(1,1:length(may)) = may;
tryNewDO(1,length(may)+1:1464) = jun;
tryNewDO(1,1464+1:end) = jul;

%%
subplot('position',[.65 .4 .25 .25])
cc=get(gca,'colororder');
%[Pxx,F,Pxxc] = pmtm(do10,4,2^12,1/320,'ConfidenceLevel',.95);
[Pxx,F,Pxxc] = pmtm(do06,3,2^12,1/320,'ConfidenceLevel',.95);
Ps=sqrt(Pxx.*F);
Psc=sqrt(Pxxc.*F);

patch(log10([F(2:end); flipud(F(2:end)); F(2)].*86400),[Psc(2:end,1); flipud(Psc(2:end,2)); Psc(2,1)],cc(1,:),'edgecolor','none','facealpha',0.5); hold on;

 
plot(log10(F.*86400),Ps,'linewidth',2,'color',cc(1,:));
set(gca,'fontsize',16);
xlabel('cpd','fontsize',24,'interpreter','latex'); ylabel('O$_2$ (mgL$^{-1}$)','fontsize',24,'interpreter','latex');
axis([-.5 0.5 0 5]);
set(gca,'xtick',log10([.5 1 2 4 8]),'xticklabel',[1/2 1 2 4 8]);
box on;axis square;

hold on

annotation('textbox', [0.72, 0.54, 0.1, 0.1], 'FontSize',16,'FontWeight','bold','String', "d", 'EdgeColor','none')

%%
subplot('position',[.65 .4 .25 .25])
cc=get(gca,'colororder');
[Pxx,F,Pxxc] = pmtm(DO_mgL,2,2^8,1/3900,'ConfidenceLevel',.95);
Ps=sqrt(Pxx.*F);
Psc=sqrt(Pxxc.*F);

 
%patch(log10([F(2:end); flipud(F(2:end)); F(2)].*86400),log10([Pxxc(2:end,1); flipud(Pxxc(2:end,2))); Pxxc(2,1)]),cc(1,:),'edgecolor','none','facealpha',0.5); hold on;
patch(log10([F(2:end); flipud(F(2:end)); F(2)].*86400),[Psc(2:end,1); flipud(Psc(2:end,2)); Psc(2,1)],cc(2,:),'edgecolor','none','facealpha',0.5); hold on;

plot(log10(F.*86400),Ps,'linewidth',2,'color',cc(2,:));
set(gca,'fontsize',16);
xlabel('cpd','fontsize',24,'interpreter','latex'); ylabel('O$_2$ (mgL$^{-1}$)','fontsize',24,'interpreter','latex');
axis([-.5 0.5 0 5]);
set(gca,'xtick',log10([.5 1 2 4 8]),'xticklabel',[1/2 1 2 4 8]);
box on;axis square;

%%
windowSize = 10; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

fdo06I = filter(b,a,tryNewDO(1000:end));
fdo06 = filter(b,a,DO_umolkg);

%%
subplot('position',[.1 .4 .55 .25])
plot(tryNewDO(1550:1700),'linewidth',2,'color',cc(1,:));hold on; plot(DO_mgL(690:690+150),'linewidth',2,'color',cc(2,:))
axis([0 150 3 9]);
set(gca,'ytick',[3 6 9]);
set(gca,'fontsize',16);
xlabel('time step(hours)','fontsize',22,'interpreter','latex'); ylabel('O$_2$ (mgL$^{-1}$)','fontsize',24,'interpreter','latex');
annotation('textbox', [0.11, 0.54, 0.1, 0.1], 'FontSize',16,'FontWeight','bold','String', "c", 'EdgeColor','none')
