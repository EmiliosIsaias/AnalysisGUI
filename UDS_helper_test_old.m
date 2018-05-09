function [upT downT]=UDS_helper(EEG,V,ppms,dsf,lf_pfs ,hf_pfs)

    
    raw_Fs = 1e3*ppms; %sample frequency

    % PARAMETERS
    Fsd = round(raw_Fs/dsf); %down-sampled sample-frequency
    niqf = raw_Fs/2; %nyquist
    %lf_pfs = [0.2 10]; %filter parameters for low-frequency amplitude signal
   % hf_pfs = [15 200]; %filter parameters for high-frequency power signal
    
    %in order to estimate high-frequency power, first down-sample signal to
    %intermediate Fs, then smooth.  This helps speed things up, but isn't
    %particularly important.
    dsf_stage1 = 10; %intermediate down-sample factor
    Fsd_stage1 = round(raw_Fs/dsf_stage1); %intermediate sample-freq
    lf_pfs_stage1 = [0 200]; %anti-aliasing filter
    smooth_sigma = 0.06; %smoothing sigma (in s)
    % COMPUTE LF and HF SIGNALS
    %low-frequency amplitude signals
    [eeg_lf,t_axis] = hsmm_uds_get_lf_features(EEG,raw_Fs,Fsd,lf_pfs);
    [temp,t_temp] = hsmm_uds_get_lf_features(V,raw_Fs,Fsd,[.01 1000]);
    v_lf = hsmm_uds_get_lf_features(V,raw_Fs,Fsd,lf_pfs);
    
    %intermediate signal
    [eeg_lfs1,ts1] = hsmm_uds_get_lf_features(EEG,raw_Fs,Fsd_stage1,lf_pfs_stage1);
    v_lfs1 = hsmm_uds_get_lf_features(V,raw_Fs,Fsd_stage1,lf_pfs_stage1);
    
    %high-frequency power signals
    [eeg_hf,t_axis] = hsmm_uds_get_hf_features(eeg_lfs1,Fsd_stage1,Fsd,hf_pfs,smooth_sigma);
    v_hf = hsmm_uds_get_hf_features(v_lfs1,Fsd_stage1,Fsd,hf_pfs,smooth_sigma);
    
    % FIT the HMM
    hmm_dsf = 2; %down-sample-factor for HMM signal featurs
    hmm_Fs = Fsd/hmm_dsf; %sample-frequency of HMM signal features (Hz)
    
    if useHF
            sig_features = downsample(eeg_hf,hmm_dsf); %define signal feature to use for HMM fitting
    else
            sig_features = downsample(eeg_lf,hmm_dsf); %define signal feature to use for HMM fitting
    end

    params.meantype = 'variable'; %use 'variable' for time-varying state means. otherwise use 'fixed'
    params.UDS_segs = [1 length(sig_features)];
    params.movingwin = [60 10]; %moving window parameters [windowLength windowSlide](in seconds) for computing time-varying state means
    [hmm] = hsmm_uds_initialize(sig_features,hmm_Fs,params); %initialize model
    
    % FIT AN HMM
    hmm.min_mllik = -8; %set minimum value of the maximal log likelihood for either state before switching to robust estimator.  If you don't want to use this feature, set this to -Inf
    hmm = hsmm_uds_train_hmm(hmm,sig_features); %fit parameters of HMM
    [state_seq,llik_best] = hsmm_uds_viterbi_hmm(hmm,sig_features); %compute best state-sequence
    up_thresh = 300; %minimum up-state duration
    down_thresh = 0; %minimum down-state duration
    [smoothed_seq] = hsmm_uds_smooth_stateseq(state_seq,hmm_Fs,up_thresh,down_thresh); %enforce minimum state durations
    
    %compute broadband signal features for state-sequence alignment
    bb_cf = [0.05 20]; %low and high cutoff frequencies for bandpass filtering (Hz)
    pert_range_bb = [-0.25 0.25]; %range of allowed perturbations of state transitions (in sec)
    bb_smooth_sigma = 0.025;
    [bb_eeg_hf,t_axis] = hsmm_uds_get_hf_features(eeg_lfs1,Fsd_stage1,Fsd,hf_pfs,bb_smooth_sigma);
    bb_v_hf = hsmm_uds_get_hf_features(v_lfs1,Fsd_stage1,Fsd,hf_pfs,bb_smooth_sigma);
    
    %initialize state duration parameters (needed for aligning state sequence
    %to broadband signal)
    min_state_dur = 1; %minimum state duration (in samples)
    max_state_dur = round(hmm_Fs*30); %maximum state duration in samples
    dur_range = (1:max_state_dur)/hmm_Fs; %range of allowed state durations (in samples)
    %set the state duration model for each hidden state to "HMM" ("Geometric")
    for i = 1:hmm.K
        hmm.state(i).dur_type = 'hmm';
    end
    hmm.dur_range = dur_range;
    hmm.max_state_dur = max_state_dur;
    hmm.min_state_dur = min_state_dur;
    [hmm_bb_state_seq] = hsmm_uds_pert_optimize_transitions(bb_eeg_hf,hmm,smoothed_seq,hmm.gamma,hmm.Fs,Fsd,pert_range_bb);
    states=hmm_bb_state_seq{1};
    dStates=[0 ;diff(states)];
    
    upT=find(dStates==1);downT=find(dStates==-1);
    
    
  
    
    
    
   


%%


