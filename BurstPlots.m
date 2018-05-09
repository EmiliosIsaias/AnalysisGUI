function [f f2 H1 H2 AX]=BurstPlots(Conditions,ppms, delayAfterTrigger,windowEnd,i1,i2)


delayAfterTrigger=round(delayAfterTrigger*ppms);
windowEnd=round(windowEnd*ppms);
%if ZeroFlag, startColumn=1, else, startColumn=2;end
startColumn=2;
ISIs={};SpikeCounts={};

delays=[];
for i=1:numel(Conditions)
    delays(i)=Conditions{i}.delay;
end
% To remove the 'find' function from the indexes should enhance the
% performance of the code. Nevertheless, this might be handy if the size of
% the arrays are not identical.
delays(find(delays>0))=0;
delays=-delays;

for i=1:numel(Conditions)
    spikes=Conditions{i}.relativeSpikeTimes;
    isis={};
    for j=1:numel(spikes)
        sp=spikes{j};
        sp=sp(find(sp>(delayAfterTrigger+delays(i)) & sp<=(windowEnd+delays(i))));
        spikecounts(j)=numel(sp);
        if numel(sp)>1, isis{j}=diff(sp);end
    end
    ISIs{i}=isis;
    SpikeCounts{i}=spikecounts;
end

%

meanSpC=[];sp=[];meanSpCwithResponse=[];
labels={};
err=[];
for i=1:numel(SpikeCounts)
    labels{i}=Conditions{i}.name;
    meanSpC(i)=mean(SpikeCounts{i});sp=[sp SpikeCounts{i}];
    meanSpCwithResponse(i)=mean(SpikeCounts{i}(SpikeCounts{i}>0));%sp=[sp SpikeCounts{i}];
    err(i)=std(SpikeCounts{i}(SpikeCounts{i}>0))/(sqrt(numel(SpikeCounts{i}(SpikeCounts{i}>0))-1));%sp=[sp SpikeCounts{i}];
end

f=figure;
subplot(2,2,1)
errorbar(1:numel(Conditions),meanSpCwithResponse,err,'ro','linewidth',2),hold on;
%plot(1:numel(Conditions),meanSpC,'ob','linewidth',2),
%l=legend('trials with response', 'alltrials'),legend boxoff
xlabel Condition
ylabel('mean spike count')
set(gca,'xtick', [1:numel(Conditions)],'xticklabel',labels,'fontsize',6);%set(l,'location','northoutside')
xlim([0 numel(Conditions)+1]);
ylim([0 Inf]);

counts=unique(sp);


subplot(2,2,3:4)
H=zeros(numel(Conditions,numel(counts)));
slabel={};
psthpeaks=[];
for i=1:numel(Conditions)
    sp=SpikeCounts{i};
    
    time=Conditions{i}.PSTHbins;
    psth=Conditions{i}.PSTH;
    indices=find(time>i1 & time<=i2);
    psthpeaks(i)=max(psth(indices));
    
    for j=1:numel(counts)
        slabel{j}=num2str(counts(j));
        H(i,j)=sum(sp==counts(j));
       H(i,j)=H(i,j)/numel(sp(sp>0));
    end
end
xlim([0 numel(Conditions)+1]);
%H=H(:,2:end);

colormap gray
colormap(flipud(colormap))
startColumn
size(H)
bar(1:numel(Conditions),H(:,startColumn:end),'stacked');
l=legend(slabel(startColumn:end));
ylabel('mean spike count');
set(l,'location','southoutside','orientation','horizontal');
ylabel('spike count proportions');
xlabel('spikes per trial:');
set(gca,'xtick', [1:numel(Conditions)],'xticklabel',labels,'fontsize',8);%set(l,'location','northoutside')
xlim([0 numel(Conditions)+1]);
subplot(2,2,2);

% mean isis
m=[];
s=[];r=[];

for i=1:numel(ISIs)
     m(i)=mean(cell2mat(ISIs{i}'))/ppms;
     s(i)=std(cell2mat(ISIs{i}'))/sqrt(numel((cell2mat(ISIs{i}')))-1)/ppms;
     r(i)=sum(SpikeCounts{i}>0)/numel(SpikeCounts{i});
end

errorbar(1:numel(Conditions),m,s,'ro','linewidth',2),hold on;
ylabel('mean ISI [ms]');
set(gca,'xtick', [1:numel(Conditions)],'xticklabel',labels,'fontsize',8);
%set(l,'location','northoutside')
xlims=([0 numel(Conditions)+1]);
f2=figure
 [AX,H1,H2] = plotyy(1:numel(Conditions), r,1:numel(Conditions),psthpeaks),hold on;
 r
 psthpeaks
yr=max(r)*1.3;
y1=[0:round(yr/4*100)/100:yr];
 
yr=max(psthpeaks)*1.3;
y2=[0:round(yr/4):yr];
 

set(AX(2),'xtick',[1:numel(Conditions)],'xticklabel',labels,'ycolor','k','xlim',xlims,'ytick',y2);
set(get(AX(2),'Ylabel'),'String','maximum counts per bin') ;
set(AX(1),'xtick', [],'ycolor','k','xlim',xlims,'ytick',y1);

set(AX(1),'xticklabel',[],'ycolor','r');


set(H1,'markersize',20,'linestyle',':','color','r','marker','.');
set(H2,'markersize',20,'linestyle',':','color','k','marker','.');

ylabel('response probability');
windowEnd
ppms
title(['Response per condition ' num2str(delayAfterTrigger/ppms) '-' num2str(windowEnd/ppms) 'ms']);