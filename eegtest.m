%% test uds gui 

clear all





datafile='C:\Users\rebecca\Documents\LFP_POm\Data\newExport\110908c1\Data166analysis'
savedir='C:\Users\rebecca\Documents\LFP_POm\Data\newExport\110908c1\'

filename='Data166analysis'
load(datafile)






events=finalizedEPSPs.events;
ppms=spikeFindingData.ppms;
v=preprocessedData.pV;
goods=ones(size(events(:,1)));
dim=size(events);dim=dim(1);
rtime=[];hwidth=[];
mags=v(events(:,2))-v(events(:,1)); intervals=[events(1,1);diff(events(:,1))]/ppms
for ii=1:dim
    if events(ii,1)<events(ii,2)
        v1=v(events(ii,1):events(ii,2));
        v1=v1-v1(1);
        mag=v1(end)-v1(1);
        v10=mag*.1;
        v90=mag*.9;
        v50=mag*.50;
        d=abs(v1-v10);
        index10=find(d==min(d));index10=index10(1);
        d=abs(v1-v90);
        index90=find(d==min(d));index90=index90(1);
        d=abs(v1-v50);
        index50=find(d==min(d));index50=index50(1);
        rtime(ii)=(index90-index10)/ppms;
        hwidth(ii)=index50/ppms;
    end
end


goods(find(rtime<0))=0;goods(find(mags<0))=0;


figure
vstart=v(events(:,1));


%%



checkClusters_gui(mags,rtime,vstart,savedir,filename)




%%

UDS_gui(EEG.data,spikeFindingData.ppms,savedir,filename)


%%
[upT downT]=UDS_helper(EEG.data(1:5000000),RawResponse.data(1:5000000),spikeFindingData.ppms,50,[0.2 10],[15 200])


%%
timeBefore=100*ppms;
timeAfter=700*ppms;


t=[-timeBefore:timeAfter]/ppms/1000;
 uptrig_EEG=TriggeredSegments(EEG.data,upT(2:end-2)*50,-timeBefore, timeAfter);
 downtrig_EEG=TriggeredSegments(EEG.data,downT(2:end-2)*50,-timeBefore, timeAfter);


figure
plot(t,uptrig_EEG,'color',[.7 .7 .7]);hold on
plot(t,mean(uptrig_EEG'),'linewidth',2)


figure
plot(t,downtrig_EEG,'color',[.7 .7 .7]);hold on
plot(t,mean(downtrig_EEG'),'r','linewidth',2)

%%

    downtrig_HF=mean(TriggeredSegments(eeg_hf,downT,-timeBefore, timeAfter)');
    downtrig_LF=mean(TriggeredSegments(eeg_lf,downT,-timeBefore, timeAfter)');
    downtrigV_HF=mean(TriggeredSegments(v_hf,downT,-timeBefore, timeAfter)');
    downtrigV_LF=mean(TriggeredSegments(v_lf,downT,-timeBefore, timeAfter)');