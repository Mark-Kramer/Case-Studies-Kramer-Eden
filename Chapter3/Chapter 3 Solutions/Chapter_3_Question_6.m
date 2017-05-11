function Chapter_3_Question_6()
    % Question 6 - Explore/Analyze Ch3-EEG-4.mat
    
    %Set Up
    load('Ch3-EEG-4.mat')
    data = EEG - mean(EEG);
    
    %Run Analysis (with helper function)
    Chapter_3_Analyze_EEG(data, t)
    %   a) The sampling interval is: 0.0005 seconds.
    %      The total duration of recording is 4 seconds.
    %      The frequency resolution is 0.25 Hz.
    %      The Nyquist frequency is 1000 Hz.
    %   b) The data appears to start with a 15 Hz rhythm that, over time,
    %      transitions into a 35 or so Hz rhythm.
    %   c) The autocovariance shows a roughly 25 Hz rhythm. This actually makes
    %      sense, given that the data evolves over time and the autocorrelation
    %      assumes it doesn't. Thus, if my signal is going from 15 Hz to 35 Hz
    %      or so, then the average will be 25 Hz, the rhythm seen in the
    %      autocorrelation.
    %   d) The periodogram shows that all frequencies between 15 and 35 Hz are
    %      equally represented in the signal. The rest appears to just be
    %      noisy measurements of frequency, indicating no other clear rhythms
    %      present in the signal. I am using the dB scale to more clearly show
    %      small fluctuations. The choice to normalize by the max power is 
    %      merely one convention and, when plotting, obscures this problem's
    %      time-dependent changes. Thus, I chose not to divide by the max
    %      power.
    %   e) The spectrogram shows that the 15 Hz rhythm occurs at the beginning
    %      and, over time, develops into a 35 Hz rhythm. No other frequencies
    %      have obvious changes.
    %   f) The initial description of the data being changed from a 15 Hz
    %      rhythm to a 35 Hz rhythm holds true. However, the autocorrelation
    %      measure didn't quite pick this up, adding merit to the idea
    %      spectral analysis, specifically spectrograms, should be done when
    %      dealing with time-dependent changes in signal.

end