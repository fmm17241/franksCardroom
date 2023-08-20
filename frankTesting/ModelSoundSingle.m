
function  [waterdepth,beamFile] = ModelSoundSingle(yoSSP, directory)

cd (directory)

location = sprintf('%s',directory);
% Choose folder to work in
cd (location)
fclose('all'); %Removes previous connections
delete *.env;   % Deletes previous files. Clearing this for automation.
waterdepth = yoSSP(end,2)+3; %Hardcoded water depth: 3m under the last reading, estimating due to inflection.
FileName = sprintf('nbdAnalysis.env'); %Choose file name
fid = fopen(FileName,'a'); %Create new file
fprintf(fid, ' ''Surfacing SSP,''      ! TITLE'); %Title of File
fprintf(fid, '\n 69000.0				! FREQ (Hz)'); %Frequency
fprintf(fid, '\n 1				! NMEDIA');
fprintf(fid, '\n''CVF''				! SSPOPT (Analytic or C-linear interpolation) ');
fprintf(fid, '\n 51  0.0  %d		! DEPTH of bottom (m)',waterdepth);
fprintf(fid, '\n0.0    %d      /  ',yoSSP(1,3)); %Assumes top soundspeed is ALSO surface sspeed. Big assumption.

for k = 1
    if yoSSP(k,2) == 0 
        continue
    end
    if yoSSP(k,3) <1500
        continue
    end
    if yoSSP(k,2) > 0
    fprintf(fid, '\n%d	%d / ',yoSSP(k,2),yoSSP(k,3));
    end

end
for k = 2 %Takes each value in given SSP
    if yoSSP(k,2) < 0.5
        continue
    end
    if yoSSP(k,3) <1500
        continue
    end
    test= yoSSP(k,2)<yoSSP(k-1,2);test2= yoSSP(k,2)==yoSSP(k-1,2);
    if test ==1||test2==1
        continue
    end
    fprintf(fid, '\n%d	%d / ',yoSSP(k,2),yoSSP(k,3));
end
for k = 3 %Takes each value in given SSP
    if yoSSP(k,2) < 0.5
        continue
    end
    if yoSSP(k,3) <1500
        continue
    end
    test= yoSSP(k,2)<yoSSP(k-2,2);test2= yoSSP(k,2)==yoSSP(k-2,2);
    test3= yoSSP(k,2)<yoSSP(k-1,2);test4= yoSSP(k,2)==yoSSP(k-1,2);
    if test ==1 ||test2==1||test3==1||test4--1
        continue
    end
    fprintf(fid, '\n%d	%d / ',yoSSP(k,2),yoSSP(k,3));
end

for k = 4
    if yoSSP(k,3) <1500
        continue
    end
    if yoSSP(k,2) < 0.5
        continue
    end
    test= yoSSP(k,2)<yoSSP(k-1,2);test2=yoSSP(k,2)==yoSSP(k-1,2);test3=yoSSP(k,2)==yoSSP(k-2,2);test4=yoSSP(k,2)<yoSSP(k-2,2);
    test5=yoSSP(k,2)==yoSSP(k-3,2);test6=yoSSP(k,2)<yoSSP(k-3,2);
    if test ==1||test2==1||test3==1||test4==1||test5==1||test6==1
        continue
    end
    fprintf(fid, '\n%d	%d / ',yoSSP(k,2),yoSSP(k,3));
end
for k = 5
    if yoSSP(k,3) <1500
        continue
    end
    if yoSSP(k,2) < 0.5
        continue
    end
    test= yoSSP(k,2)<yoSSP(k-1,2);test2=yoSSP(k,2)==yoSSP(k-1,2);test3=yoSSP(k,2)==yoSSP(k-2,2);test4=yoSSP(k,2)<yoSSP(k-2,2);
    test5=yoSSP(k,2)==yoSSP(k-3,2);test6=yoSSP(k,2)<yoSSP(k-3,2);test7=yoSSP(k,2)<yoSSP(k-4,2);
    if test ==1||test2==1||test3==1||test4==1||test5==1||test6==1||test7==1
        continue
    end
    fprintf(fid, '\n%d	%d / ',yoSSP(k,2),yoSSP(k,3));
end
for k = 6:length(yoSSP)
    if yoSSP(k,3) <1500
        continue
    end
    if yoSSP(k,2) < 0.5
        continue
    end
    test= yoSSP(k,2)<yoSSP(k-1,2);test2=yoSSP(k,2)==yoSSP(k-1,2);test3=yoSSP(k,2)==yoSSP(k-2,2);test4=yoSSP(k,2)<yoSSP(k-2,2);

    test5=yoSSP(k,2)==yoSSP(k-3,2);test6=yoSSP(k,2)<yoSSP(k-3,2);test7=yoSSP(k,2)<yoSSP(k-4,2);test8=yoSSP(k,2)==yoSSP(k-4,2);
    test9=yoSSP(k,2)<yoSSP(k-5,2);test10=yoSSP(k,2)==yoSSP(k-5,2);

    if test ==1||test2==1||test3==1||test4==1||test5==1||test6==1||test7==1||test8==1||test9==1||test10==1
        continue
    end
    fprintf(fid, '\n%d	%d / ',yoSSP(k,2),yoSSP(k,3));
end

fprintf(fid, '\n%d %d  / ',waterdepth,yoSSP(end,3)); %Assumes last soundspeed is ALSO bottom sspeed. Big assumption.
fprintf(fid, '\n''A'' 0.0');
fprintf(fid, '\n%d  %d 0.0 1.0 / ',waterdepth,yoSSP(end,3)); %Repeats last soundspeed
fprintf(fid, '\n1				! NSD, # of source depths  ');
fprintf(fid, '\n%d /			! SD(1:NSD) (m), Souce of depths  ',waterdepth-1); %Depth of Source
fprintf(fid, '\n2				! NRD, # of receiver depths  ');
fprintf(fid, '\n5  15 /			! RD(1:NRD) (m), receiver depths  '); %Receiver Depth
fprintf(fid, '\n1				! NR, # of receiver ranges  ');
fprintf(fid, '\n2 /			! R(1:NR ) (km), receiver ranges  ');
fprintf(fid, '\n''R''	  			! ''R/C/I/S'''); %Type of Output
fprintf(fid, '\n1000		! NBeams '); %How many beams? 
fprintf(fid, '\n-20.0 20.0 /		        ! ALPHA1,2 (degrees) ');
fprintf(fid, '\n0.0 %d  2		! STEP (m), ZBOX (m), RBOX (km), Stepsize, maximum depth, and maximum range',waterdepth);
fclose(fid);


%Finds number of files, takes name without extensions.
filelist = dir('*.env');
filename= filelist.name;

[~,nameonly,~] = fileparts(filename);
beamFile = nameonly;


current = sprintf('%s',beamFile);
figure()
bellhop(current);
plotray(current);
    xlim([0 1500]);
    ylim([0 waterdepth])
nameit = sprintf('Bellhop%s.jpeg',current);
saveas(gcf,nameit)



clf
current = sprintf('%s',beamFile);
plotssp(current,'r');
nameit = sprintf('Bellhop%sSSP.jpeg',current);
saveas(gcf,nameit);
end
%     





