function gstruct = load_all_glider_data(datadir,nfile);
%
% Bug fix 04/15/2016 -- CRE
%

[files,Dstruct]=wilddir(datadir,'asc');
if(nargin==1); 
  nfile=size(files,1);
end

% populate general structure with a mix of sbd and tbd data 
gstruct.vname=[]; gstruct.fname=[]; gstruct.mname=[]; 

% only choose files with size greater than zero
bytes=vertcat(Dstruct(:).bytes);
inonzero=find(bytes>0);
nzfiles=files(inonzero,:); nnzfile=length(nzfiles); 

% get test file first
testfile=[datadir,nzfiles(1,:)];
data=read_gliderasc(testfile); dstruct=parse_glider_vars(data);
whichvars=fields(dstruct); 
clear data;

% populate general structure with a mix of sbd and tbd data 
gstruct=dstruct;

for i=1:nfile; 
 disp(nzfiles(i,:))
 % protect against empty sbd file
 if(Dstruct(i).bytes>0)
    data=read_gliderasc([datadir,nzfiles(i,:)]);
  
  if(~isempty(data.data))

    % parse glider variables
    dstruct=parse_glider_vars(data);

    gstruct.vname=dstruct.vname;
    % concatenate usual glider variables
    varstrs=[char(whichvars) repmat(' ',length(whichvars),1)];
    timevar=regexp(column(varstrs')','\w*present_time\w*','match'); timevar=timevar(1);
    nansvar=nan*ones(size(eval(['dstruct.',char(timevar)])));

    % assign data, if empty, put in NaNs to prevent mixed *bds with changes in number of vars
    for varind=4:length(whichvars);
      vname=char(whichvars(varind)); vdata=eval(['dstruct.',vname,';']);
      if(~isempty(vdata)); 
        eval(['gstruct.',vname,'=[gstruct.',vname,';vdata];']); 
      else
        eval(['gstruct.',vname,'=[gstruct.',vname,';nansvar];']); 	
      end
    end
  end
 end
end

% do some extra processing -- compute dn, sort

% find time variable -- convert to char and pad with a blank
varstrs=[char(whichvars) repmat(' ',length(whichvars),1)];
timevar=regexp(column(varstrs')','\w*present_time\w*','match');
dn=datenum(1970,1,1)+eval(['gstruct.',char(timevar(1))])/3600/24;

% now sort by datenum
[dnsort,isort]=sort(dn); 

% sort variables according to time index
for varind=4:length(whichvars);
  vname=char(whichvars(varind)); vdata=eval(['gstruct.',vname,';']); 
  [nx,ny]=size(vdata); 
  if(~isempty(vdata)); eval(['gstruct.',vname,'=[vdata(isort)];']); end
end

gstruct.dn=dnsort; 

% look for lon/lat, convert from degrees/decimal minutes to decimal degrees

lonvars=regexp(column(varstrs')','\w*lon\w*','match'); latvars=regexp(column(varstrs')','\w*lat\w*','match');
llvars=[lonvars latvars];

if(length(llvars)>0)
  for varind=1:length(llvars)
     vname=char(llvars(varind));
     vdata=eval(['gstruct.',vname,';']);
     vdata(abs(vdata)>99999)=nan; vdata(vdata==0)=nan; vdata=ddmm2decdeg(vdata);
     eval(['gstruct.',vname,'=vdata;']); 
  end
end 
