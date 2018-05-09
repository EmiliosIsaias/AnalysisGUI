function [f, f2]= makePSTHfig_helper(Conditions,dim1,dim2,thiscol,...
    fname,xlims,ylims,plotL,plotW,plotFP,FPscale,makeSummaryPlot,i1,i2)
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
    subplot(dim1,dim2,i);hold on
    time=Conditions{i}.PSTHbins;
    psth=Conditions{i}.PSTH;
    m=Conditions{i}.meanRawResponse;
    m=m-m1;
    m=m/M*FPscale;
    m=m-1.2*max(m,[],'omitnan');
    lags=[lags;Conditions{i}.delay];
    if plotFP
        % The time and the signal do not correspond. Changing to a
        % temporary auxiliary time variable
        if length(Conditions{i}.time) == length(m)
            plot(Conditions{i}.time,m,'color',[.8 .8 .8]);hold on;
        else
            auxTime = linspace(xlims(1),xlims(2),length(m));
            plot(auxTime,m,'color',[.8 .8 .8]);
        end
    end
    hold on
    
    indices=find(time>i1 & time<=i2);
    psthpeak(i)=max(psth(indices));
    psthsum(i)=sum(psth(indices));
    index=find(psth==max(psth));peaktime(i)=time(index(1));
    if plotL
        if max(Conditions{i}.lsegs(:,1),[],'omitnan')>100
            ll=Conditions{i}.lsegs(:,2);ll=ll/max(ll)*2000;
            if length(Conditions{i}.time) == length(ll)
                aa=area(Conditions{i}.time,ll);hold on;
            else
                auxTime = linspace(xlims(1),xlims(2),length(ll));
                aa=area(auxTime,ll);hold on;
            end
            hold on;set(aa,'facecolor',[.5 .7 1],'edgecolor','none');
        end
    end
    
    if plotW
        if max(abs(Conditions{i}.wsegs(:,1)),[],'omitnan')>100
            ww=Conditions{i}.wsegs(:,1);
            
            if sum(ww)<0
                ww=ww/min(ww)*2000;
            else
                ww=ww/max(ww)*2000;
            end
            % Here the time and the 'whiskers' trigger signal length is not
            % the same again. Overwritting the auxiliary time variable.
            if length(Conditions{i}.time) == length(ww)
                a=area(Conditions{i}.time,ww);hold on;
            else
                auxTime = linspace(xlims(1),xlims(2),length(ww));
                a=area(auxTime,ww);hold on;
            end
            hold on; set(a,'facecolor',[.6 1 .6],'edgecolor','none');
        end
    end
    
    b=bar(time,psth,1,'showbaseline','off');hold on;
    set(b,'facecolor',thiscol,'edgecolor',thiscol,'linewidth',1);hold on
    
    n=numel(Conditions{i}.Triggers);
    title([Conditions{i}.name ': n=' num2str(n)]);
    xlim(xlims);
    ylim(ylims);
    ylabel Hz;
    xlabel ms;
    labels{i}= Conditions{i}.name;
    if ylims(2)<20, x=5; elseif ylims(2)<50,x=10;else x=20;end
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



