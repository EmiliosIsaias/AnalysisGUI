
clear all

[thisfile, pathname, filterindex] = uigetfile('*.mat', 'Pick a data file');
load([pathname thisfile]);

set(0,'defaulttextinterpreter','none')

savename=thisfile(1:end-4);
mkdir(savename);

%% filter LFP


niqf = 20000/2;
lcf = .015; %low cut-off for the low-freq filter
hcf = 200; %high cut-off for the low-freq filter
[b,a] = butter(2,[lcf hcf]/niqf);
lfp=filtfilt(b,a,EEG);
lfp=zscore(lfp);

%%
HandUp=[];
load([pathname thisfile],'HandUp')
startPoint=0;
HandPickUp_gui(lfp,[],ppms,[pathname thisfile],3000,HandUp,startPoint)
%%
