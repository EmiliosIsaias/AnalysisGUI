

%%

savedir='C:\Users\rebecca\Documents\BCtoPOm\intracellular\121003\c3'
fname='Data231analysis.mat'

%f=FindEPSPs_gui(RawResponse.data,spikeFindingData.ppms,fname,spikeFindingData.spikes)

%%
DataExampleGui(fname,savedir)

%%


load(fname)

%%
ppms=spikeFindingData.ppms;
window=round(10000*ppms)
n=1
totalshift=0;
light=Triggers.light;light=light/max(light)/2;
v=zscore(preprocessedData.pV);v=v/max(v);
fv=zscore(filteredResponse.data);fv=fv/max(fv);
spikes=spikeFindingData.spikes;

pt=[1:window]+totalshift;
indices=pt;
pt=pt/ppms;



spacer=.3
close all
figure
shift=0;
   hold on
for i=1:4
 
       plot(pt,light(indices)+shift,'b');
       shift=shift+max(light(indices))+spacer;
        
       plot(pt,v(indices)+shift,'k');
        shift=shift+max(v(indices))+spacer;
        
        plot(pt,dv(indices)+shift,'g');
        shift=shift+max(dv(indices))+spacer;
        
        sp=spikes(ismember(spikes,indices))-min(indices)+1;
        plot(sp/ppms, ones(size(sp))*shift,'r.','markersize',10)
        shift=shift+spacer;
        
        indices=indices+pwindow;
         shift=shift+2*spacer;
end
    
xlim([min(pt),max(pt)]);ylim([-spacer shift])
   
%%

