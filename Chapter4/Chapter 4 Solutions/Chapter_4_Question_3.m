function Chapter_4_Question_3()
    % Question 3 - Another Shot at Spectral Analysis of Ch3-EEG-2.mat
    
    %Set Up
    load('Ch3-EEG-2.mat')
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
    
    % There is a 60Hz dominant signal that is evident in all analyses. However,
    % a few of them don't show the increase in power at 30-40Hz. These are the
    % multitaper approaches with 19 seconds of zero padding and the multitaper
    % 10 TW analyses. With a plethora of zero padding, it seems like the 
    % introduced broadband bias increases the power in the 30-40 Hz range
    % enough to obscure the true 30-40 Hz power. For this analysis it seems
    % like the multitaper approach with 2 TW and no padding is the best choice.
    
end