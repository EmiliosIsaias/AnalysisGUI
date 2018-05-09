

function f= makePSTHfig_helper(Conditions,dim1,dim2,thiscol)
FPfig=figure

for F=1:numel(fnames)
    
    fname=fnames{F};
    saveFile=[fdir '\' fname 'analysis'];
    load(saveFile, 'Conditions');
    for i=1:numel(Conditions)
        subplot(6,numel(Conditions),i+2*(F-1));
        time=Conditions{i}.time;
        r=Conditions{i}.triggeredRawResponse;
        m=Conditions{i}.meanRawResponse;
        s=Conditions{i}.stdRawResponse;
        b=plot(time,r,'color', [.7 .7 .7]);hold on;
        b=plot(time,m,'color', [0 0 0], 'linewidth',2);hold on;
        %b=plot(time,m-s,'color', [0 0 0]);hold on;
        %b=plot(time,m+s,'color', [0 0 0]);hold on;
        
        if F==1
            title(Conditions{i}.name)
        end
        xlim([min(time) max(time)])
        ylim([-4000 1000])
        if F==6, xlabel('Time [ms]');end
        ylabel('FP')
        grid on
        box off
        if i==1,text(20,250,['L=' fname 'mW']);end
    end
end