

W=Triggers.whisker;



if min(W)<-100
    W=W*-1;
end
W=W/max(W);



figure
plot(W)

D=[0;diff(W)];
%%
plot(D)
onset=find(D>.5)
d=[10000; diff(onset)];
onset=onset(find(d>1000));

%%
trigTime=[];

for i=1:numel(Conditions)
    trigTime=[trigTime;Conditions{i}.Triggers];
end
trigTime=onset
e1=finalizedEPSPs.events(:,1);
Lat=[];
for i=1:numel(e1)
    thisevent=e1(i);
    t=trigTime(find(trigTime<thisevent));
    t=t(end);
    Lat(i)=thisevent-t;
end
mags=finalizedEPSPs.mags;
ppms=20;
figure
subplot(2,1,1)
plot(Lat/ppms, mags,'o')
bins=0:100;

xlim([min(bins) max(bins)])
ylabel mV
xlabel 'Latency [ms]'
subplot(2,1,2)
h=hist(Lat/ppms,bins);
bar(bins,h,1)
ylabel counts
xlabel 'Latency [ms]'
xlim([min(bins) max(bins)])

