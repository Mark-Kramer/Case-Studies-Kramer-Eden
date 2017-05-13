function Chapter_4_Question_5()
    % Question 5 - Another Shot at Spectral Analysis of Ch3-EEG-4.mat
    
    %Set Up
    load('Ch3-EEG-4.mat')
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
    
    % All of these agree with each other, but misrepresent the data. If you
    % recall from Chapter 3, the spectrogram (spectrum over time) showed a
    % development of a 15 Hz rhythm into a 35 Hz rhythm. All of these analyses
    % completely miss that. If I saw a spectrum that looked like this I would
    % move to a spectrogram approach, to see if that plateau of power could be
    % separated out over time. It seems like the TW 2 with no zero padding
    % gives the best signal, so I would choose that as the base of my
    % spectrogram.
    
end