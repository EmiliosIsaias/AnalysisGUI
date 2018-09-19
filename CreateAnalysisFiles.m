function CreateAnalysisFiles(fdir,fname,ds)


%automatically get channel names
fdir

if strcmp(fdir(end),'\')
    strs=fieldnames(open([fdir fname '.mat']));
else
    strs=fieldnames(open([fdir '\' fname '.mat']));
end

% lastKnownAssignments=open(['D:\Data\AnalysisGui\ChannelStatus.mat'])
chStatFile = fullfile(pwd,'..\..\ChannelStatus.mat');
if exist(chStatFile,'file')
    lastKnownAssignments = open(fullfile(pwd,'..\..\ChannelStatus.mat'));
else
    DATA = {'chan1','head1',''};
    lastKnownAssignments = DATA;
end
headerNames={};
channelNames={};

for i=1:numel(strs)
    if ~isempty(strfind(strs{i},'chan'))
        channelNames=[channelNames;strs{i}];
    end
    if ~isempty(strfind(strs{i},'head'))
        headerNames=[headerNames;strs{i}];
    end
end


% pop up helper gui to assign channel names
[DATA notes LFPstr]=AssignChannels_gui(channelNames,headerNames,lastKnownAssignments);


if ~isempty(LFPstr)
    eval(['LFPnum=' LFPstr ';'])
    LFP=[];
    str=['chan' num2str(LFPnum(1))];
    temp=load([fdir '\' fname '.mat'],str);
    eval(['n=numel(temp.' str ')'])
    LFP=nan(n,numel(LFPnum));
    for i=1:numel(LFPnum)
        str=['chan' num2str(LFPnum(i))];
        temp=load([fdir '\' fname '.mat'],str);
        eval(['x=double(temp.' str ');'])
        LFP(1:numel(x),i)=x;
    end
end

% save(['D:\Data\AnalysisGui\ChannelStatus.mat'],'DATA');
save(fullfile(pwd,'..\..\ChannelStatus.mat'),'DATA');
CHAN=DATA(:,1);HEAD=DATA(:,2);MYNAMES=DATA(:,3);

%find channels with assigned names
indices=[];

for i=1:numel(MYNAMES);
    indices(i)=~isempty(MYNAMES{i});
end
indices=find(indices);


%check for triggers;
trigIndices=[];
for i=1:numel(MYNAMES)
    str=MYNAMES{i};
    
    if strcmp(str,'light')
        trigIndices=[trigIndices i];
    end
    if strcmp(str,'whisker')
        trigIndices=[trigIndices i];
    end
    if strcmp(str,'puff')
        trigIndices=[trigIndices i];
    end
end

indices=setdiff(indices,trigIndices);

vars={};
names={};
Structs={};
count=0;
for i=indices
    count=count+1;
    vars{count}={CHAN{i} HEAD{i}};
    names{count}= {'data' 'header'};
    Structs{count}= MYNAMES{i};
end

if ~isempty(trigIndices)
    v={};
    n={};
    for i=1:numel(trigIndices)
        v{i}=CHAN{trigIndices(i)};
        n{i}=MYNAMES{trigIndices(i)};
    end
    
    vars=[vars {v}];
    names=[names {n}];
    Structs=[Structs {'Triggers'}];
    
end


for i=1:numel(vars)
    eval([Structs{i} '=getData(fname, vars{i},names{i},fdir,ds);']);
end
saveFile=[fname 'analysis'];

save(saveFile,Structs{:});
str=[];
for i=1:numel(Structs)
    if i<numel(Structs)
        str=[str Structs{i} ', '];
    else
        str=[str 'and ' Structs{i}];
    end
end

spikeFindingData={};
spikeFindingData.spikes=[];spikeFindingData.ppms=20;  %% HACK, FIX THIS

% checking for mismatched lengths, should be sped up in the future, lots of
% extra saving that might not be necessary

save(saveFile,'notes','spikeFindingData','-append');

temp=load(saveFile,'RawResponse*','Triggers','filteredResponse','EEG')

maxs=[];
if isfield(temp,'RawResponse')
    maxs=[maxs;numel(temp.RawResponse.data)]
end

if isfield(temp,'RawResponse2')
    maxs=[maxs;numel(temp.RawResponse2.data)]
end

if isfield(temp,'Triggers')
    if isfield(temp.Triggers, 'light')
        maxs=[maxs;numel(temp.Triggers.light)]
    end
    if isfield(temp.Triggers, 'whisker')
        maxs=[maxs;numel(temp.Triggers.whisker)]
    end
end


if isfield(temp,'filteredResponse')
    maxs=[maxs;numel(temp.filteredResponse.data)]
end

if isfield(temp,'filteredResponse2')
    maxs=[maxs;numel(temp.filteredResponse2.data)]
end


if isfield(temp,'EEG')
    maxs=[maxs;numel(temp.EEG.data)]
end

m=min(maxs);


if isfield(temp,'RawResponse')
    temp.RawResponse.data=temp.RawResponse.data(1:m);
    RawResponse=temp.RawResponse;
    save(saveFile,'RawResponse','-append')
end

if isfield(temp,'RawResponse2')
    temp.RawResponse2.data=temp.RawResponse2.data(1:m);
    RawResponse2=temp.RawResponse2;
    save(saveFile,'RawResponse2','-append')
end

if isfield(temp,'Triggers')
    if isfield(temp.Triggers, 'light')
        temp.Triggers.light=temp.Triggers.light(1:m);
    end
    if isfield(temp.Triggers, 'whisker')
        temp.Triggers.whisker=temp.Triggers.whisker(1:m);
    end
    
    Triggers=temp.Triggers;
    save(saveFile,'Triggers','-append')
end


if isfield(temp,'filteredResponse')
    temp.filteredResponse.data=temp.filteredResponse.data(1:m);
    filteredResponse=temp.filteredResponse;
    save(saveFile,'filteredResponse','-append')
end

if isfield(temp,'filteredResponse2')
    temp.filteredResponse2.data=temp.filteredResponse2.data(1:m);
    filteredResponse2=temp.filteredResponse2;
    save(saveFile,'filteredResponse2','-append')
end


if isfield(temp,'EEG')
    temp.EEG.data=temp.EEG.data(1:m);
    filteredResponse=temp.EEG;
    save(saveFile,'EEG','-append')
end







if ~isempty(LFPstr)
    display('saving LFP....');
    save(saveFile,'LFP','-append');
end
display(['Saved ' str ' to ' saveFile '.mat located in ' fdir])
