
%% Import from Spike2, save to Matlab, create analysis file.
fname=0
count=0
while fname==0 & count<1
    fname = uigetfile({'*.smr';'*.mat'},'Choose file to analyze:');
    count=count+1;
end
%
index=strfind(fname,'.')
ext=fname(index:end);
if strcmp('.smr',ext)
    f=importSMR(fname,cd);
elseif strcmp('.mat',ext)
else display('Unknown file!')
    break
end
matfile=fname(1:(index-1));
CreateAnalysisFiles(cd,matfile,1)
saveFile=[matfile 'analysis'];
load(saveFile,'filteredResponse');
filteredResponse.data=filteredResponse.data/max(filteredResponse.data);
%%
findSpikes_gui(filteredResponse,saveFile)



%%

isImported=0;
smr


importSMR(fname)


%% analysis GUI

%% ask for file

%% import data into Matlab

%%

display Goodbye
close(handles.figure1);

[FileName,PathName,FilterIndex] = uigetfile(FilterSpec)
[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,DialogTitle)
[FileName,PathName,FilterIndex] = uigetfile(FilterSpec,DialogTitle,DefaultName)
%[FileName,PathName,FilterIndex] = uigetfile(...,'MultiSelect',selectmode)