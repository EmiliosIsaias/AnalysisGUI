%% Import from Spike2, save to Matlab, create analysis file.
fname=0
count=0
while fname==0 & count<1
    [fnames pathname] = uigetfile({'*.mat';'*.smr'},'Choose file(s) to analyze:','multiselect','on');
    count=count+1;
end
%
cd(pathname)

if isstr(fnames)
    N=1;
else N=numel(fnames);
end

for i=1:N
    r={};
    if N==1,fname=fnames;else fname=fnames{i};end
    %MAKE SURE MOVE TO CORRECT DIRECTORY
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
    %
    findSpikes_gui(filteredResponse,saveFile)
%     r=input('hit any key to proceed');
%     while isempty(r),pause;end
end
%%
%%load(saveFile,'spikeFindingData','Triggers');
findTriggers_gui(Triggers,saveFile,ppms)


%% 
saveFile='temp';

makePSTH_gui(Conditions,spikes,RawResponse,Triggers,ppms,saveFile)

%%
Conditions=newAnalysis(Conditions,RawResponse,spikes',beforeT,window,BinSizeInMS, ppms,saveFile);
    
    for j=1:numel(Conditions)
        Conditions{j}.lsegs=TriggeredSegments(Triggers.light,Conditions{j}.triggers,round(-ppms*beforeT), ppms*window);
        Conditions{j}.wsegs=TriggeredSegments(Triggers.whisker,Conditions{j}.triggers,round(-ppms*beforeT), ppms*window);
    end
