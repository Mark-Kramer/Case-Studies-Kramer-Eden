function Chapter_4_Question_4()
    % Question 4 - Another Shot at Spectral Analysis of Ch3-EEG-3.mat
    
    %Set Up
    load('Ch3-EEG-3.mat')
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
    
    % The spectra mostly all show an increase in the 20 Hz power (which if we
    % recall from last time are only present at the beginning and end of the
    % recording). However, there may perhaps be a small increase in 5 Hz power,
    % as seen in some of the multitaper methods. The multitaper with a TW 10
    % and zero padding seems to best show this phenomenon, so that would be my
    % preference for the data. Subsequent analysis using bandpass filters could
    % prove the existence of a 5 Hz rhythm.
    
end