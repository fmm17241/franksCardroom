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
%Frank removed the separation of tags by transmitter/tag. Now its all
%detections included in structure.
vems.dn = DN;      
vems.tag = tag;
vems.rec = receiver;
vems.id = id;

end
