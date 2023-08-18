function [vems] = vemProcessSingle(vemdir,outputDir,glider)

%FM 2023: Reads in .Vem files from VEMCO instruments and tells us how many
% transmissions were detected in that time period.

%Vemdir is where the input files are, .vems
%outputDir should be where we want these processed files

% Data directory being analyzed
cd (vemdir)

%Sets up cells to build onto
vems = [];
counter = 0
usedatetime=cell(1,1);
tag=cell(1,1);
id=cell(1,1);                
pound=cell(1,1);
receiver=cell(1,1);
number=cell(1,1);
usedatetime=cell(1,1);
tag=cell(1,1);
id=cell(1,1);
pounds=cell(1,1);
statusTime = cell(1,1);


vemfiles = dir('*.vem');                   %List of files
%This only takes the last file. IF we want more, just change for k =
%1:length(vemfiles), or k = end-4:end or something.
for k = length(vemfiles)                %Loop to process each file
    file = vemfiles(k).name;
    fid = fopen(file, 'rt');
    while true
        line =fgetl(fid);
        if ~ischar(line)                %If the lines empty, done, move to next file
            fclose(fid);
            break;
        end
      if(~isempty(strfind(line, 'STS')))     %If line contains STS, move to next line
                Mydata=strsplit(line,',');   %split the data by the commas
                statusTime{end+1}=Mydata{3};
          continue;
      end
      Mydata=strsplit(line,',');   %split the data by the commas
      receiver{end+1}=Mydata{1};   %Put data in previously made bins
      number{end+1} = Mydata{2};
      usedatetime{end+1}=Mydata{3};
      tag{end+1} = Mydata{4};
      id{end+1}= Mydata{5};
      pound{end+1}= Mydata{6};
    end   
    counter = counter +1
end
receiver(1)=[];                    %Erase first value of all, its empty
number(1)=[];
usedatetime(1)=[];
tag(1)=[];
id(1)=[];
pound(1)=[];
statusTime(1)=[];


%FM 8/18 Name of file analyzed without .vem at the end
useFileName = vemfiles(end).name(1:end-4);


% Datenum from original file's status lines, used for duration calc.
statusDN = datenum(statusTime);

%Makes our datetimes between detections, lets us know the duration of the
%file.
timing = (statusDN(end) - statusDN(1))*24; % hours... since "between()" not in R2014a

%%
%Outputs 

%WHEN FILE IS EMPTY, NO DETECTIONS:

%Creates empty output file for periods with no detections
if isempty(usedatetime) == 1
    fclose('all'); %Removes previous connections
    cd (outputDir)
    FileName = sprintf('AT%s%s.txt', glider, useFileName); %Choose file name
    fid = fopen(FileName,'a'); %Create new file
    fprintf(fid, ' ''Acoustic Telemetry, %s''',glider); %Title of File
    fprintf(fid, '\n No detections during this period');
    fprintf(fid, '\n Duration: %f hours',timing);
    fclose('all'); %Removes connection after finishing
    return
end

%%
%WHEN FILE HAS DETECTIONS:

%Index by what was heard: moorings, tags, whatever
DN = datenum(usedatetime);
for K = 1:length(tag)
    allindex(1,K) = (~isempty(strfind(tag{K},'A69-9001')) | ~isempty(strfind(tag{K},'A69-1601')) | ~isempty(strfind(tag{K},'A69-1602')));
    nineohindex(1,K) = ~isempty(strfind(tag{K},'A69-9001'));    %Creating indexes by what pinged
    mooredIndex(1,K) = ~isempty(strfind(tag{K},'A69-1601'));
    oh2index(1,K)    = ~isempty(strfind(tag{K},'A69-1602'));
end
allrec      = receiver(allindex);
allDN    = DN(allindex);
allnumber   = number(allindex);
alltag     = tag(allindex);



%
nineohrec = receiver(nineohindex);       %using indexes to grab context
nineohDN = DN(nineohindex);
nineohid = id(nineohindex);
nineohtime = datestr(nineohDN);
nineohnumber = number(nineohindex);
nineohtag = tag(nineohindex);
nineohpound = pound(nineohindex);
%

%
oh2rec = receiver(oh2index);
oh2DN = DN(oh2index);
oh2time = datestr(oh2DN);
oh2id = id(oh2index);
oh2number = number(oh2index);
oh2tag = tag(oh2index);
oh2pound = pound(oh2index);
%

%One easy matlab structure to work with
vems.dn = (allDN);       %Creates structures to organize data by ping
vems.tag = (alltag);
vems.rec = (allrec);
vems.id = (id);
vems.nineohDN = (nineohDN);
vems.nineohtag = (nineohtag);
vems.nineohrec = (nineohrec);
vems.nineohid = (nineohid);
vems.oh2DN = (oh2DN);
vems.oh2id = (oh2id);
vems.oh2tag = (oh2tag);
vems.oh2rec = (oh2rec);
vems.rec = str2double(vems.rec);   
vems.oh2rec = str2double(vems.oh2rec);
vems.mooredRec = str2double(receiver(mooredIndex));
vems.mooredDN = DN(mooredIndex);
vems.mooredID = id(mooredIndex);
vems.mooredDT = datestr(vems.mooredDN);
vems.mooredNumber = number(mooredIndex);
vems.mooredTag = tag(mooredIndex);
vems.mooredEnd = pound(mooredIndex);



%FM 8/18, this part worked IF datetime worked; unsure of how I want to turn
%the character/datestring dates into numbers.
% [startY, startM, startD] = ymd(beginning);
% [startH, startm, starts] = hms(beginning);
% 
% [overY, overM, overD] = ymd(ending);
% [overH, overm, overs] = hms(ending);



%Defined to be where we want to place the detection readouts.
cd (outputDir)

%Outputs simple text file for software read-in
fclose('all'); %Removes previous connections
FileName = sprintf('AT%s%s.txt',glider,useFileName); %Choose file name
fid = fopen(FileName,'a'); %Create new file
fprintf(fid, ' ''Acoustic Telemetry, %s''',glider); %Title of File

% FM 8/18, changed date output because datetime didnt work, now have dates
% as characters not numbers. Can change in future.
% fprintf(fid, ' \n start: %d %d %d %d %d %d ',startY,startM,startD,startH,startm,starts);
% fprintf(fid, ' \n end: %d %d %d %d %d %d ',overY,overM,overD,overH,overm,overs);
fprintf(fid, ' \n start: %s ',statusTime{1});
fprintf(fid, ' \n end:   %s ',statusTime{end});

fprintf(fid, '\n #detections_total %d', length(vems.dn));
fprintf(fid,  '\n #detections_tags  %d', length(vems.oh2DN));
fprintf(fid, '\n Duration: %0.2f hours',timing);
fclose('all'); %Removes connection after finishing



end
