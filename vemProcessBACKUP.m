%Function to find and read all the acoustic detection files in a particular
%folder.

function [vems] = vemProcess(vemdir)
cd (vemdir)

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
for k = 1:length(vemfiles)                %Loop to process each file
    file = vemfiles(k).name;
    fid = fopen(file, 'rt');
    
    while true
        line =fgetl(fid);
        if ~ischar(line)                %If the lines empty, done, move to next file
            fclose(fid);
            break;
        end
        
      if(contains(line,'STS'))     %If line contains STS, move to next line, they're empty.
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


DN = datenum(usedatetime);

clc
%%
%Can remove or keep; this was me breaking down what was transmitter, what
%was fish tagged, etc.
% allindex = (contains(tag,'A69-9001') | contains(tag,'A69-1601') | contains(tag,'A69-1602'));
% nineohindex = contains(tag,'A69-9001');    %Creating indexes by what pinged
% mooredIndex = contains(tag,'A69-1601');
% oh2index = contains(tag,'A69-1602');


% allrec = receiver(allindex);
% allDN = DN(allindex);
% alltime = datetime(allDN,'ConvertFrom','datenum');
% allnumber = number(allindex);
% alltag = tag(allindex);
% allpound= pound(allindex);

% nineohrec = receiver(nineohindex);       %using indexes to grab context
% nineohDN = DN(nineohindex);
% nineohid = id(nineohindex);
% nineohtime = datetime(nineohDN,'ConvertFrom','datenum');
% nineohnumber = number(nineohindex);
% nineohtag = tag(nineohindex);
% nineohpound = pound(nineohindex);

% vems.mooredRec = str2double(receiver(mooredIndex));
% vems.mooredDN = DN(mooredIndex);
% vems.mooredID = id(mooredIndex);
% vems.mooredDT = datetime(vems.mooredDN,'ConvertFrom','datenum');
% vems.mooredNumber = number(mooredIndex);
% vems.mooredTag = tag(mooredIndex);
% vems.mooredEnd = pound(mooredIndex);


% oh2rec = receiver(oh2index);
% oh2DN = DN(oh2index);
% oh2time = datetime(oh2DN,'ConvertFrom','datenum');
% oh2id = id(oh2index);
% oh2number = number(oh2index);
% oh2tag = tag(oh2index);
% oh2pound = pound(oh2index);
%%

%This was used because Frank only wanted known moored transmitters. If we
%want all detections included, its just the first 4.
vems.dn = (allDN);       %Creates structures to organize data by ping
vems.tag = (alltag);
vems.rec = (allrec);
vems.id = (id);
% vems.nineohDN = (nineohDN);
% vems.nineohtag = (nineohtag);
% vems.nineohrec = (nineohrec);
% vems.nineohid = (nineohid);
% vems.oh2DN = (oh2DN);
% vems.oh2id = (oh2id);
% vems.oh2tag = (oh2tag);
% vems.oh2rec = (oh2rec);
% vems.rec = str2double(vems.rec);   
% vems.oh2rec = str2double(vems.oh2rec);

%%

end
