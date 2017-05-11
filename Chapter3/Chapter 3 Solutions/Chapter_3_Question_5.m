function Chapter_3_Question_5()
    % Question 5 - Explore/Analyze Ch3-EEG-3.mat
    
    %Set Up
    load('Ch3-EEG-3.mat')
    data = EEG - mean(EEG);
    
    %Run Analysis (with helper function)
    Chapter_3_Analyze_EEG(data, t)
    %   a) The sampling interval is: 0.002 seconds.
    %      The total duration of recording is 2 seconds.
    %      The frequency resolution is 0.5 Hz.
    %      The Nyquist frequency is 250 Hz.
    %   b) The data appears to be dominated by a 20 Hz rhythm at the beginning
    %      and end of the recording.The middle doesn't seem to have any
    %      rhythmic component.
    %   c) The autocovariance shows a clear 20 Hz rhythm.
    %   d) The periodogram shows the 20 Hz rhythm. The rest appears to just be
    %      noisy measurements of frequency, indicating no other clear rhythms
    %      present in the signal. I am using the dB scale to more clearly show
    %      small fluctuations. The choice to normalize by the max power is 
    %      merely one convention and, when plotting, obscures this problem's
    %      time-dependent changes. Thus, I chose not to divide by the max
    %      power.
    %   e) The spectrogram shows that the 20 Hz rhythm occurs at the beginning
    %      and end of the recording, but not during the middle portions. No
    %      other clear rhythms are seen.
    %   f) The initial description of the data being dominated by a 20 Hz
    %      rhythm at the beginning and end remains true. Subsequent analysis
    %      confirmed our original findings.
    
end