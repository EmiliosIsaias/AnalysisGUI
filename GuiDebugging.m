


%% testing for bs
clear all
fname='evoked_LightA_LFP_BC_intraPOm_premuscimolanalysis'
PATHNAME='C:\Users\rebecca\Documents\Groh1p5\IntracellularPOM_for_BS\130212\c2\'
cd(PATHNAME)

load(fname,'spikeFindingData','RawResponse','EEG','Triggers');

%clear Triggers
if exist('EEG')
    niqf = spikeFindingData.ppms*1000/2;
    [b,a] = butter(2,[.01 1000]/niqf);
    eeg=filtfilt(b,a,EEG.data);
    eeg=eeg-max(eeg);eeg=eeg/std(eeg);
end


%%

    if exist('Triggers') && exist('EEG')
        f=FindEPSPs_gui(RawResponse.data,spikeFindingData.ppms,fname,spikeFindingData.spikes,PATHNAME, eeg,Triggers)
        uiwait(f)
    elseif exist('Triggers')
        f=FindEPSPs_gui(RawResponse.data,spikeFindingData.ppms,fname,spikeFindingData.spikes,PATHNAME,0,Triggers)
        uiwait(f)
    elseif exist('EEG')
           f=FindEPSPs_gui(RawResponse.data,spikeFindingData.ppms,fname,spikeFindingData.spikes,PATHNAME,eeg)
           uiwait(f)
    else
    f=FindEPSPs_gui(RawResponse.data,spikeFindingData.ppms,fname,spikeFindingData.spikes,PATHNAME)
    uiwait(f)
end

%%
f=FindEPSPs_gui(RawResponse.data,spikeFindingData.ppms,fname,spikeFindingData.spikes,PATHNAME, eeg)

%%



