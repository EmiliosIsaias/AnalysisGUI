%function [f]=MakeBurstPlots(Conditions,spikeFindingData, delayAfterTrigger,windowSize)


load Data73analysis Conditions spikeFindingData
ppms=spikeFindingData.ppms;
delayAfterTrigger=1*ppms;
windowSize=100*ppms;
Conditions=Conditions([2 10 11 4:9])

ISIs={};SpikeCounts={};
for i=1:numel(Conditions)
    spikes=Conditions{i}.relativeSpikeTimes
    isis={};
    for j=1:numel(spikes)
        sp=spikes{j};
        sp=sp(find(sp>delayAfterTrigger & sp<=(delayAfterTrigger+windowSize)));
        spikecounts(j)=numel(sp);
        if numel(sp)>1, isis{j}=diff(sp);end
    end
    ISIs{i}=isis;
    SpikeCounts{i}=spikecounts
end



%

meanSpC=[];sp=[];meanSpCwithResponse=[];
labels={};
for i=1:numel(SpikeCounts)
    labels{i}=Conditions{i}.name;
    meanSpC(i)=mean(SpikeCounts{i});sp=[sp SpikeCounts{i}];
    meanSpCwithResponse(i)=mean(SpikeCounts{i}(SpikeCounts{i}>0));%sp=[sp SpikeCounts{i}];
end

figure
subplot(2,2,1)
plot(1:numel(Conditions),meanSpCwithResponse,'ro','linewidth',2),hold on
%plot(1:numel(Conditions),meanSpC,'ob','linewidth',2)
%l=legend('trials with response', 'alltrials'),legend boxoff
xlabel Condition
ylabel('mean spike count')
set(gca,'xtick', [1:numel(Conditions)],'xticklabel',labels,'fontsize',6);%set(l,'location','northoutside')
xlim([0 12])
ylim([0 max(meanSpCwithResponse)*1.2])

counts=unique(sp);




subplot(2,2,3:4)
H=zeros(numel(Conditions,numel(counts)));
slabel={};
for i=1:numel(Conditions)
    sp=SpikeCounts{i};
    for j=1:numel(counts)
        slabel{j}=num2str(counts(j));
        H(i,j)=sum(sp==counts(j));
       H(i,j)=H(i,j)/numel(sp(sp>0));
    end
end

%H=H(:,2:end);

colormap gray
colormap(flipud(colormap))
bar(1:numel(Conditions),H(:,2:end),'stacked')
l=legend(slabel(2:end))
xlabel('Proportion trials')
ylabel('mean spike count')
set(l,'location','southoutside','orientation','horizontal')
title('spike count proportions')

set(gca,'xtick', [1:numel(Conditions)],'xticklabel',labels,'fontsize',6);%set(l,'location','northoutside')
xlim([0 12])
subplot(2,2,2)


% mean isis
m=[];
s=[];r=[];



for i=1:numel(ISIs)
     m(i)=mean(cell2mat(ISIs{i}'))/ppms;
     s(i)=std(cell2mat(ISIs{i}'))/ppms;
     r(i)=sum(SpikeCounts{i}>0)/numel(SpikeCounts{i});
end

errorbar(1:numel(Conditions),m,s,'ro','linewidth',2),hold on
ylabel('mean ISI [ms]')
set(gca,'xtick', [1:numel(Conditions)],'xticklabel',labels,'fontsize',6);%set(l,'location','northoutside')
xlim([0 12])
figure



plot(1:numel(Conditions),r,'b:.','linewidth',.5,'markersize', 20),hold on
ylabel('response probability')
set(gca,'xticklabel',labels,'fontsize',6)








function [f f2]= makePSTHfig_helper(Conditions,dim1,dim2,thiscol,fname,xlims,ylims,plotL,plotW,plotFP,FPscale,makeSummaryPlot,i1,i2)
f=figure;
set(f,'name',[fname 'PSTH']);  set(f,'position',[206    60   733   855])
f2=[];%for summary plot

F=[];
for i=1:numel(Conditions)
   F=[F Conditions{i}.meanRawResponse];
end
m1=min(F);M=max(abs(F));
lags=[];labels={};
for i=1:numel(Conditions)
    subplot(dim1,dim2,i)
    time=Conditions{i}.PSTHbins;
    psth=Conditions{i}.PSTH;
    m=Conditions{i}.meanRawResponse;
    m=m-m1;
    m=m/M*FPscale;
    m=m-1.2*max(m);
    lags=[lags;Conditions{i}.delay];
    if plotFP
        plot(Conditions{i}.time,m,'color',[.8 .8 .8]);
    end
    hold on

    indices=find(time>i1 & time<=i2);
    psthpeak(i)=max(psth(indices));
    psthsum(i)=sum(psth(indices));
    index=find(psth==max(psth));peaktime(i)=time(index(1));
    if plotL
        if max(Conditions{i}.lsegs(:,1))>100
            ll=Conditions{i}.lsegs(:,2);ll=ll/max(ll)*2000;
            aa=area(Conditions{i}.time,ll);hold on;set(aa,'facecolor',[.5 .7 1],'edgecolor','none');
        end
    end

    if plotW
        if max(abs(Conditions{i}.wsegs(:,1)))>100
            ww=Conditions{i}.wsegs(:,1);
            
            if sum(ww)<0, 
                ww=ww/min(ww)*2000;
            else
            ww=ww/max(ww)*2000;
            end
            a=area(Conditions{i}.time,ww);hold on; set(a,'facecolor',[.6 1 .6],'edgecolor','none');
        end
    end
    
    b=bar(time,psth,1,'showbaseline','off');
    set(b,'facecolor',thiscol,'edgecolor',thiscol,'linewidth',1);hold on
    
    n=numel(Conditions{i}.Triggers);
    title([Conditions{i}.name ': n=' num2str(n)]);
    xlim(xlims);
    ylim(ylims);
    ylabel Hz;
    xlabel ms;
    labels{i}= Conditions{i}.name;
    if ylims(2)<20, x=5; elseif ylims(2)<50,x=10;else x=20;end;
    set(gca,'ytick',[0:x:ylims(2)])
    
     set(gca,'fontsize',8);
   

end
set(gcf,'position',[ 214   119   697   828])

if makeSummaryPlot
    f2=figure;
    set(f2,'name',[fname 'Summary']);
    plot(1:numel(psthpeak), psthpeak,'.:','linewidth',1,'markersize',20);
    xlim([0 numel(psthpeak)+1])
    ylim([0 max(psthpeak)*1.10])
    set(gca,'xtick',[1:numel(psthpeak)],'xticklabel',labels,'fontsize',8);
    xlabel('Condition');
    ylabel('Peak firing rate [Hz]');
    title([fname 'Summary PSTH maximum']);
    set(gcf,'position',[ 214   676   913   271])
end





    