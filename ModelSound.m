
function  [waterdepth,filename,YoDTz] = ModelSound(YoSSP,typevariable)

%Typevariable should be 'R' for ray tracing or 'E' for eigenray. Plug in
%either.

if any((typevariable ~= 'E') & (typevariable ~= 'R') & (typevariable ~= 'C') &(typevariable ~= 'A') )
       fprintf('ERROR:You entered incorrect choice for typevariable, give ''E'', ''R'',''A'' or ''C''.')
       return
end
cd G:\Glider\Data\Environmental\

location = sprintf('G:\\Glider\\Data\\Environmental\\%s',(typevariable));
% Choose folder to work in
cd (location)
fclose('all'); %Removes previous connections
delete *.env;delete *.prt;delete *.jpeg;delete *.jpg;delete *.ray;delete *.gif;delete *.arr % Deletes previous files
% waterdepth   = 17.5; %meters, just for 2019 yos below average
% for P = 1:30:length(YoSSP) CHANGED THIS ONLY FOR 2014, WANT GOOD SUBSETS
for P = 1:100:length(YoSSP)
%     caption = sprintf('Ayo this is %d',P);
%     fprintf('%\n',caption);
%     drawnow
    if length(YoSSP{P}(:,1)) > 80 | length(YoSSP{P}(:,1)) < 8
        continue
    end
%     YoDTz(P,1) = datetime(YoSSP{1,P}(1,1),'ConvertFrom','datenum');
    waterdepth = YoSSP{1,P}(end,2)+3;
    FileName = sprintf('test%d%s.env',P,typevariable); %Choose file name
    fid = fopen(FileName,'a'); %Create new file
%     fprintf(fid, '\n ''Surfacing SSP, %s%d''      ! TITLE\n',typevariable,P); %Title of File
    fprintf(fid, ' ''Surfacing SSP, %s%d''      ! TITLE',typevariable,P); %Title of File
    fprintf(fid, '\n 69000.0				! FREQ (Hz)'); %Frequency
    fprintf(fid, '\n 1				! NMEDIA');
    fprintf(fid, '\n''CVF''				! SSPOPT (Analytic or C-linear interpolation) ');
    fprintf(fid, '\n 51  0.0  %d		! DEPTH of bottom (m)',waterdepth);
    fprintf(fid, '\n0.0    %d      /  ',YoSSP{1,P}(1,3)); %Assumes top soundspeed is ALSO surface sspeed. Big assumption.
    
    for k = 1
        if YoSSP{1,P}(k,2) == 0 
            continue
        end
        if YoSSP{1,P}(k,3) <1500
            continue
        end
        if YoSSP{1,P}(k,2) > 0
        fprintf(fid, '\n%d	%d / ',YoSSP{1,P}(k,2),YoSSP{1,P}(k,3));
        end
        
    end
    for k = 2 %Takes each value in given SSP
        if YoSSP{1,P}(k,2) < 0.5
            continue
        end
        if YoSSP{1,P}(k,3) <1500
            continue
        end
        test= YoSSP{1,P}(k,2)<YoSSP{1,P}(k-1,2);test2= YoSSP{1,P}(k,2)==YoSSP{1,P}(k-1,2);
        if test ==1||test2==1
            continue
        end
        fprintf(fid, '\n%d	%d / ',YoSSP{1,P}(k,2),YoSSP{1,P}(k,3));
    end
    for k = 3 %Takes each value in given SSP
        if YoSSP{1,P}(k,2) < 0.5
            continue
        end
        if YoSSP{1,P}(k,3) <1500
            continue
        end
        test= YoSSP{1,P}(k,2)<YoSSP{1,P}(k-2,2);test2= YoSSP{1,P}(k,2)==YoSSP{1,P}(k-2,2);
        test3= YoSSP{1,P}(k,2)<YoSSP{1,P}(k-1,2);test4= YoSSP{1,P}(k,2)==YoSSP{1,P}(k-1,2);
        if test ==1 ||test2==1||test3==1||test4--1
            continue
        end
        fprintf(fid, '\n%d	%d / ',YoSSP{1,P}(k,2),YoSSP{1,P}(k,3));
    end
    
    for k = 4
        if YoSSP{1,P}(k,3) <1500
            continue
        end
        if YoSSP{1,P}(k,2) < 0.5
            continue
        end
        test= YoSSP{1,P}(k,2)<YoSSP{1,P}(k-1,2);test2=YoSSP{1,P}(k,2)==YoSSP{1,P}(k-1,2);test3=YoSSP{1,P}(k,2)==YoSSP{1,P}(k-2,2);test4=YoSSP{1,P}(k,2)<YoSSP{1,P}(k-2,2);
        test5=YoSSP{1,P}(k,2)==YoSSP{1,P}(k-3,2);test6=YoSSP{1,P}(k,2)<YoSSP{1,P}(k-3,2);
        if test ==1||test2==1||test3==1||test4==1||test5==1||test6==1
            continue
        end
        fprintf(fid, '\n%d	%d / ',YoSSP{1,P}(k,2),YoSSP{1,P}(k,3));
    end
    for k = 5
        if YoSSP{1,P}(k,3) <1500
            continue
        end
        if YoSSP{1,P}(k,2) < 0.5
            continue
        end
        test= YoSSP{1,P}(k,2)<YoSSP{1,P}(k-1,2);test2=YoSSP{1,P}(k,2)==YoSSP{1,P}(k-1,2);test3=YoSSP{1,P}(k,2)==YoSSP{1,P}(k-2,2);test4=YoSSP{1,P}(k,2)<YoSSP{1,P}(k-2,2);
        test5=YoSSP{1,P}(k,2)==YoSSP{1,P}(k-3,2);test6=YoSSP{1,P}(k,2)<YoSSP{1,P}(k-3,2);test7=YoSSP{1,P}(k,2)<YoSSP{1,P}(k-4,2);
        if test ==1||test2==1||test3==1||test4==1||test5==1||test6==1||test7==1
            continue
        end
        fprintf(fid, '\n%d	%d / ',YoSSP{1,P}(k,2),YoSSP{1,P}(k,3));
    end
    for k = 6:length(YoSSP{1,P})
        if YoSSP{1,P}(k,3) <1500
            continue
        end
        if YoSSP{1,P}(k,2) < 0.5
            continue
        end
        test= YoSSP{1,P}(k,2)<YoSSP{1,P}(k-1,2);test2=YoSSP{1,P}(k,2)==YoSSP{1,P}(k-1,2);test3=YoSSP{1,P}(k,2)==YoSSP{1,P}(k-2,2);test4=YoSSP{1,P}(k,2)<YoSSP{1,P}(k-2,2);
        
        test5=YoSSP{1,P}(k,2)==YoSSP{1,P}(k-3,2);test6=YoSSP{1,P}(k,2)<YoSSP{1,P}(k-3,2);test7=YoSSP{1,P}(k,2)<YoSSP{1,P}(k-4,2);test8=YoSSP{1,P}(k,2)==YoSSP{1,P}(k-4,2);
        test9=YoSSP{1,P}(k,2)<YoSSP{1,P}(k-5,2);test10=YoSSP{1,P}(k,2)==YoSSP{1,P}(k-5,2);
        
        if test ==1||test2==1||test3==1||test4==1||test5==1||test6==1||test7==1||test8==1||test9==1||test10==1
            continue
        end
        fprintf(fid, '\n%d	%d / ',YoSSP{1,P}(k,2),YoSSP{1,P}(k,3));
    end
    
    fprintf(fid, '\n%d %d  / ',waterdepth,YoSSP{1,P}(end,3)); %Assumes last soundspeed is ALSO bottom sspeed. Big assumption.
    fprintf(fid, '\n''A'' 0.0');
    fprintf(fid, '\n%d  %d 0.0 1.0 / ',waterdepth,YoSSP{1,P}(end,3)); %Repeats last soundspeed
    fprintf(fid, '\n1				! NSD  ');
    fprintf(fid, '\n%d /			! SD(1:NSD) (m)  ',waterdepth-1); %Depth of Source
    fprintf(fid, '\n2				! NRD  ');
    fprintf(fid, '\n5  15 /			! RD(1:NRD) (m)  '); %Receiver Depth
    fprintf(fid, '\n1				! NR  ');
    fprintf(fid, '\n2 /			! R(1:NR ) (km)  ');
    fprintf(fid, '\n''%s''	  			! ''R/C/I/S''',typevariable); %Type of Output
    fprintf(fid, '\n1000		! NBeams '); %How many beams? 
    fprintf(fid, '\n-20.0 20.0 /		        ! ALPHA1,2 (degrees) ');
    fprintf(fid, '\n0.0 %d  2		! STEP (m), ZBOX (m), RBOX (km)',waterdepth);
    fclose(fid);
end
% YoDTz=YoDTz(~isnat(YoDTz));



%Finds number of files, takes name without extensions.
filelist = dir('*.env');
fullfilenames= {filelist.name};
howmany = length(fullfilenames);
filename =cell(1,howmany);
for k =1:howmany
    [~,nameonly,~] = fileparts(fullfilenames{k})
    filename{k} = nameonly;
end
filename = natsortfiles(filename);


if typevariable == 'A'
    prompt1 = 'Which Receiver Depth? Index=';
    prompt2 = 'Which Source Depth? Index=';
    irr = 1;                %Index for Receiver Range. These match lines the values in lines 44-48.
    ird = input(prompt1);       %Index for Receiver Depth
    isd = input(prompt2);         %Index for Source Depth

    for k =1:howmany
        curry = sprintf('%s',filename{k});
        currydelivery = sprintf('%s.arr',filename{k});
        bellhop(curry);
        plotarr(currydelivery,irr,ird,isd);
        nameit = sprintf('Bellhop%s.jpeg',curry);
        saveas(gcf,nameit)
        close all
        continue
    end
    worklocation = pwd;
    [bottomarrivals,toparrivals]=BeamArrivals(worklocation)
return
end
%     
for k =1
    curry = sprintf('%s',filename{k});
    figure()
    bellhop(curry);
    plotray(curry);
%     xlim([0 1500]);
%     ylim([0 waterdepth])
    nameit = sprintf('Bellhop%s.jpeg',curry);
    saveas(gcf,nameit)
end
% gif('SSP RayTracing.gif','frame',gcf,'DelayTime',0.5,'LoopCount',4);
for k =2:howmany
    clf
    curry = sprintf('%s',filename{k});
    bellhop(curry);
    plotray(curry);
%     ylim([0 waterdepth]);
%     xlim([0 1500])
    nameit = sprintf('Bellhop%s.jpeg',curry);
    saveas(gcf,nameit)
%     gif
end
if typevariable == 'R'
    for k =1:howmany
        clf
        curry = sprintf('%s',filename{k});
        plotssp(curry,'r');
        nameit = sprintf('Bellhop%sSSP.jpeg',curry);
        saveas(gcf,nameit);
    end

end




