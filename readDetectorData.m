%Frank's analysis. 
function [output] = readDetectorData(fileDirectory)
%Run Raven Pro 1.6's amplitude detector on a 4-hour sanctuary sound file
% 1 ms smoothing, 1000.0 amplitude threshold

%Go to folder containing the detector output files
% cd ([oneDrive,'acousticAnalysis'])
cd (fileDirectory)

%Read in detector tables
%Need to automate the date and time when files start and end
%File has many characters; we need to convert the 10 characters after the
%11th underscore into datetime
audioFiles   = dir('*.txt')
counter      = 0;
startDT        = [];
endDT         = [];
totalSnaps   =  [];

for k = 1:length(audioFiles)                %Loop to process each file
   
    file = audioFiles(k).name;
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



%
testing = readtable('sanctsound_audio_gr01_sanctsound_gr01_04_audio_SanctSound_GR01_04_5421_200129231235.wav.Table01.txt')
