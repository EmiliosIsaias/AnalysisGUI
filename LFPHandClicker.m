




%%

clear all

[thisfile, pathname, filterindex] = uigetfile('*.mat', 'Pick a data file');
load([pathname thisfile]);

set(0,'defaulttextinterpreter','none')
savename=thisfile(1:end-4);
ppms=spikeFindingData.ppms;
% filter LFP


niqf = 20000/2;
lcf = .1; %low cut-off for the low-freq filter
hcf = 200; %high cut-off for the low-freq filter
[b,a] = butter(2,[lcf hcf]/niqf);
lfp=filtfilt(b,a,EEG.data);
lfp=zscore(lfp);
W=nan(size(lfp));
L=nan(size(lfp));
try,W=Triggers.whisker;W=abs(W);W=W-mean(W(1:10));W=W/max(W);catch;end
try,L=Triggers.light;L=L-mean(L(1:10));L=L/max(L);catch;end
%
HandUp=[];
load([pathname thisfile],'HandUp')
startPoint=0;
HandPickUp_gui(lfp,[],ppms,[pathname thisfile],3000,HandUp,startPoint,W,L)
%%
