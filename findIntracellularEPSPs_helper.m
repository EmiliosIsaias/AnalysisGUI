
function [locs peaks]=findIntracellularEPSPs_helper(v,thresh,ppms,minMag, maxVoltage, spikes, useDV)



figure
vnorm=v-min(v);vnorm=vnorm/max(vnorm)*100;
%bandpass filter voltage
%find second derivative

if useDV
    dv=[0;diff(v)];
else
    dv=[0;0;diff(diff(v))];
end


%normalize and scale second derivative
dv=dv-mean(dv);dv=dv/max(dv);
dv=dv*100;

%find peaks in second derivative
[PKS,locs]=myfindpeaks(dv,'minpeakheight',thresh,'minpeakdistance',50);




peaks=[];
goods=zeros(size(locs)); %keep everything
n=numel(v);
%find peaks
for jj=1:numel(locs);
    %window to look for peaks
    i1=locs(jj);
  if i1<1,i1=1;
  end
    i2=locs(jj)+6*ppms;
    if i2 > n
        i2=n;
    end
    
    %if event starts are very close together,don't let areas overlap
    if jj<numel(locs)
        if i2>locs(jj+1)
            i2=locs(jj+1)-1;
        end
    end
    
    event=v(locs(jj):(i2)); %pull out voltage to look at
    m1=max(event); %find maximum of event
    index=find(event==m1);peaks(jj)=index(1)+locs(jj)-1; %find index of max
    
    
%     event=v(i1:(locs(jj)+round(1*ppms))); %pull out voltage to look at
%     m=min(event); %find min of event
%     index=find(event==m);locs(jj)=index(1)+locs(jj)-1*ppms; %find index of max

    if m1-v(locs(jj))>1
        goods(jj)=1;
    end
end

locs=locs((find(goods)));peaks=peaks((find(goods)));


shifts=[];
%find true starts
for jj=1:numel(locs);
    indices=[locs(jj)-round(.5*ppms) : locs(jj)+2*ppms];
    
    i1=find(indices>0);indices=indices(i1(1):end);
    i2=find(indices<numel(v));
    indices=round(indices(1:i2(end)));
    
    index=find(v(indices)==min(v(indices)));shifts(jj)=index(1)-1-round(.5*ppms);
end



locs=locs'+shifts';

locs(find(locs<=0))=1;

% deal with overlapping events;

for i=1:numel(locs)-1;
    if ~isnan(locs(i))
        if peaks(i)>locs(i+1)
            peaks(i)=nan;
            locs(i+1)=nan;
        end
    end
end

locs=locs(find(~isnan(locs)));
peaks=peaks(find(~isnan(peaks)));



plot(dv,'color',[.5 .5 .5])
hold on
plot(v)
hold on
plot(spikes,v(spikes),'go')
%exclude epsps that are too small and start too low
mags=v(peaks)-v(locs);
goods=ones(size(mags));
%bads=find(vnorm(locs)<minV & mags<=minMag)
bads=find(mags<=minMag)

goods(bads)=0;
goods=find(goods);
locs=locs(goods);peaks=peaks(goods);


%exclude epsps that are too big (APs, for example)

goods=find(v(peaks)<=maxVoltage);
locs=locs(goods);peaks=peaks(goods)';



%%
% % %get rid of epsps associated with APs
goods=ones(size(locs));
for i=1:numel(spikes)
    spikes(i)
    indices=find(locs<spikes(i));
    d=spikes(i)-locs(indices);
    
    indices2=find(d<20*ppms);
    
    goods(indices(indices2))=0;
end


bads=find(goods==0);
plot(locs(bads), v(locs(bads)),'oy','linewidth',4)

goods=find(goods);
locs=locs(goods);
peaks=peaks(goods);

%plot final good events
plot(locs, v(locs),'oc','linewidth',2)
plot(peaks, v(peaks),'or','linewidth',2)




n=max(dv*1.1);



ylim(round([-n n]))

