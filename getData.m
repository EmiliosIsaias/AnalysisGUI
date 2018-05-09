function x=getData(fname, variables,names,fdir,downsample);


if ~iscell(variables), variables={variables};end
if ~iscell(names), names={names};end

%record current directory
d=cd;
%go to the right directory
cd(fdir);

%Throw error if user has not supplied enough
%(or too many) new variable names...
if numel(variables)~=numel(names)
    display('ERROR: Number of variables is not equal to number of supplied variable names');
    return
end



%load the data
x=load(fname, variables{:});


%rename variables with new user supplied names:
for i=1:numel(variables)
    
    %old field name
    name=variables{i};
    %new field name
    newName=names{i};
    %get field value
    eval(['temp=x.' name ';']);
    %delete the old field name
    x=rmfield(x,name);
    %change 16-bit integer into double, if necessary
    if strcmp(class(temp),'int16'),temp=double(temp);end
    %if it is time series data, downsample
    if strcmp(name(1:4),'chan')
    temp=temp(downsample:downsample:end);
    end
    %assign value new name
    eval(['x.' newName '=temp;']);

    clear temp;
    
end
%go back to the old directory
cd(d);