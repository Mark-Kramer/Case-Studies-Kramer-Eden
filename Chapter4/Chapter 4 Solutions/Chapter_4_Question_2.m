function Chapter_4_Question_2()
    % Question 2 - Another Shot at Spectral Analysis of Ch3-EEG-1.mat
    
    %Set Up
    load('Ch3-EEG-1.mat')
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
    
    % Just like last time, we see a 60 Hz signal which seems to dominate the
    % EEG. However, all measures of the EEG show a clear increase in lower
    % frequency power. In fact, all except the TW = 10 with no padding
    % condition display two separate peaks. I'd day the preference I have for
    % this data is no padding and a multitaper with TW = 2. This seems to have
    % the clearest signal out of all the solutions.
    
end