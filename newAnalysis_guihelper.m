
function x=newAnalysis_guihelper(Conditions,Triggers,RawResponse,spikes,beforeT,window,BinSizeInMS, ppms,saveFile,saveOn)


h = waitbar(0,'Please wait...');
for i=1:numel(Conditions)
    waitbar(i/numel(Conditions),h,['Calculating PSTH for Condition ' num2str(i) '...'])
    %get triggers for this stimulus condition
    triggers=Conditions{i}.Triggers;
    %get raw responses for each trigger
    Conditions{i}.triggeredRawResponse=TriggeredSegments(RawResponse.data,triggers,-ppms*beforeT, ppms*window);
    %calculate mean raw response over all triggers
    Conditions{i}.meanRawResponse=mean(Conditions{i}.triggeredRawResponse','omitnan');
    %calculate std raw response over all triggers
    Conditions{i}.stdRawResponse=std(Conditions{i}.triggeredRawResponse',[],'omitnan');
    % Is this time axis garanteed to have the same number of elements that
    % the signals themselves? It converts the time into indices, increases
    % unitarily and then converts the index array into time.
    Conditions{i}.time=(round(-beforeT*ppms):round(window*ppms))/ppms;
    if length(Conditions{i}.time) ~= length(Conditions{i}.meanRawResponse)
        Conditions{i}.time = -beforeT:(1/ppms):window;
    end
    %finds spike response to each trigger
    bispikes=zeros(size(RawResponse.data));bispikes(spikes)=1;
    Conditions{i}.triggeredSpikes=TriggeredSegments(bispikes,triggers,-ppms*beforeT, ppms*window);
    
    %find spike indices relative to start of trigger
    sp={};counts=[];
    dim=size(Conditions{i}.triggeredSpikes);dim=dim(2);
    if dim ~= numel(triggers)
        disp('Warning: trigger window too large, one or more triggers ignored.')
    end
    for j=1:dim
        %find where binary representation of spike times is 1, correct
        %for time before (e.g. a spike that occurs at trigger will be
        %0)
        sp{j}=find(Conditions{i}.triggeredSpikes(:,j)==1)-(beforeT*ppms);
        counts(j)=numel(sp{j});
    end
    Conditions{i}.relativeSpikeTimes=sp;
    Conditions{i}.counts=counts;
    %calculate PSTH in Hz
    %set bins in sampling points
    Conditions{i}.PSTHbins=[(-beforeT*ppms):(BinSizeInMS*ppms):(window*ppms)];
    Conditions{i}.PSTH=hist(cell2mat(sp'), Conditions{i}.PSTHbins)/dim/BinSizeInMS*1000;
    %convert bins to ms
    Conditions{i}.PSTHbins=Conditions{i}.PSTHbins/ppms;
    %calculate mean and std of delay for each conditions
    Conditions{i}.meanSTDdelay=[mean(cell2mat(sp'))/ppms std(cell2mat(sp'))/ppms];
    try
        Conditions{i}.lsegs=TriggeredSegments(Triggers.light,Conditions{i}.Triggers,round(-ppms*beforeT), ppms*window);
    catch
        % These structure fields were not being created when they were only
        % declared in the catch section of a try expression for both cases.
    %Conditions{i}.lsegs=TriggeredSegments(Triggers.light,Conditions{i}.Triggers,round(-ppms*beforeT), ppms*window);
    end
    try
        Conditions{i}.wsegs=TriggeredSegments(Triggers.whisker,Conditions{i}.Triggers,round(-ppms*beforeT), ppms*window);
    catch
    % Conditions{i}.wsegs=TriggeredSegments(Triggers.whisker,Conditions{i}.Triggers,round(-ppms*beforeT), ppms*window);
    end
end
x=Conditions;

if saveOn
    waitbar(1,h,'Saving data')
    save(saveFile,'Conditions','-append');
    disp(['Saved Conditions to ' saveFile '.mat'])
end

close(h)