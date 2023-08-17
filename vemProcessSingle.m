function [vems] = vemProcessSingle(vemdir,outputDir,glider)

%FM 2023: Reads in .Vem files from VEMCO instruments and tells us how many
% transmissions were detected in that time period.

%Vemdir is where the input files are, .vems
%outputDir should be where we want these processed files


cd (vemdir)

%Sets up cells to build
counter = 0
vemfiles = dir('*.vem');                   %List of files
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

%This only takes the last file.
for k = length(vemfiles)                %Loop to process each file
    file = vemfiles(k).name;
    fid = fopen(file, 'rt');
    while true
        line =fgetl(fid);
        if ~ischar(line)                %If the lines empty, done, move to next file
            fclose(fid);
            break;
        end
      if(contains(line,'STS'))     %If line contains STS, move to next line
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

%Index by what was heard: moorings, tags, whatever
DN = datenum(usedatetime);
allindex = (contains(tag,'A69-9001') | contains(tag,'A69-1601') | contains(tag,'A69-1602'));
nineohindex = contains(tag,'A69-9001');    %Creating indexes by what pinged
mooredIndex = contains(tag,'A69-1601');
oh2index = contains(tag,'A69-1602');
allrec = receiver(allindex);
allDN = DN(allindex);
alltime = datetime(allDN,'ConvertFrom','datenum');
allnumber = number(allindex);
alltag = tag(allindex);
allpound= pound(allindex);

%
nineohrec = receiver(nineohindex);       %using indexes to grab context
nineohDN = DN(nineohindex);
nineohid = id(nineohindex);
nineohtime = datetime(nineohDN,'ConvertFrom','datenum');
nineohnumber = number(nineohindex);
nineohtag = tag(nineohindex);
nineohpound = pound(nineohindex);
%
vems.mooredRec = str2double(receiver(mooredIndex));
vems.mooredDN = DN(mooredIndex);
vems.mooredID = id(mooredIndex);
vems.mooredDT = datetime(vems.mooredDN,'ConvertFrom','datenum');
vems.mooredNumber = number(mooredIndex);
vems.mooredTag = tag(mooredIndex);
vems.mooredEnd = pound(mooredIndex);
%
oh2rec = receiver(oh2index);
oh2DN = DN(oh2index);
oh2time = datetime(oh2DN,'ConvertFrom','datenum');
oh2id = id(oh2index);
oh2number = number(oh2index);
oh2tag = tag(oh2index);
oh2pound = pound(oh2index);
%

%One easy matlab structure
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


%Find the date of the file, so that if its empty we can still create an
%output file.
fileDate = vemfiles(end).date;
emptyFile= datenum(fileDate);


%Creates empty output file for periods with no detections
if isempty(vems.dn) == 1
    fclose('all'); %Removes previous connections
    cd (outputDir)
    FileName = sprintf('detections%s%f.txt', glider, emptyFile); %Choose file name
    fid = fopen(FileName,'a'); %Create new file
    fprintf(fid, ' ''Acoustic Telemetry Detections, %s''',glider); %Title of File
    fprintf(fid, '\n No detections during this period');
    fclose('all'); %Removes connection after finishing
    return
end


%Makes our datetimes between detections, lets us know the duration of the
%file.
beginning = datetime(vems.dn(1),'ConvertFrom','datenum');
ending = datetime(vems.dn(end),'ConvertFrom','datenum');
timing = between(beginning,ending);

[startY, startM, startD] = ymd(beginning);
[startH, startm, starts] = hms(beginning);

[overY, overM, overD] = ymd(ending);
[overH, overm, overs] = hms(ending);



%Defined to be where we want to place the detection readouts.
cd (outputDir)

%Outputs simple text file for software read-in
fclose('all'); %Removes previous connections
FileName = sprintf('detections%s%f.txt',glider,vems.dn(1,1)); %Choose file name
delete (FileName)
fid = fopen(FileName,'a'); %Create new file
fprintf(fid, ' ''Acoustic Telemetry Detections, %s''',glider); %Title of File
fprintf(fid, ' \n start: %d %d %d %d %d %d ',startY,startM,startD,startH,startm,starts);
fprintf(fid, ' \n end: %d %d %d %d %d %d ',overY,overM,overD,overH,overm,overs);
fprintf(fid, '\n #detections_total %d', length(vems.dn));
fprintf(fid,  '\n #detections_tags  %d', length(vems.oh2DN));
fprintf(fid, '\n Duration: %s',timing);
fclose('all'); %Removes connection after finishing



end
