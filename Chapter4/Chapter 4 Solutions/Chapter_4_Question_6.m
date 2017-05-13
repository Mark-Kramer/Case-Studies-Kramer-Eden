function Chapter_4_Question_6()
    % Question 6 - Another Shot at Spectral Analysis of Ch3-EEG-5.mat
    
    %Set Up
    load('Ch3-EEG-5.mat')
    EEG = EEG - mean(EEG);
    
    %Calculate FFT Frequeny Resolution and the TW's Frequency Resolution
    %   normal_freq_res = 1/T;
    %   TWK_freq_res = 2*K/T;
    T = max(t);
    fft_freq_res = 1/T;
    TW2_freq_res = 2*2/T;
    TW10_freq_res = 2*10/T;
    
    %Run Analysis (with helper function)
    Chapter_4_Analyze_EEG(EEG, t)
    
    % Recall from chapter 3 that this is a square wave. Thus, all our spectra
    % use an plethora of high frequencies to create the sharp line seen in the
    % original waveform. Further, they all kind of hint at some underlying
    % frequency (if you squint you can see a peak near ~2 Hz, the oscillation
    % of the square wave). There really isn't a best choice for this analysis.
    
end