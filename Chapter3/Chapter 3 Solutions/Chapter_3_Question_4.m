function Chapter_3_Question_4()
    % Question 4 - Explore/Analyze Ch3-EEG-2.mat
    
    %Set Up
    load('Ch3-EEG-2.mat')
    data = EEG - mean(EEG);
    
    %Run Analysis (with helper function)
    Chapter_3_Analyze_EEG(data, t)
    %   a) The sampling interval is: 0.001 seconds.
    %      The total duration of recording is 1 second.
    %      The frequency resolution is 1 Hz.
    %      The Nyquist frequency is 500 Hz.
    %   b) The data appears to be dominated by a clear single rhythmic
    %      component. The rhythm looks to be roughly 60 Hz.
    %   c) The autocovariance shows again a clear 60 Hz rhythm.
    %   d) The periodogram shows a hidden rhythm at roughly 30 Hz and 40 Hz.
    %      This was not visible from the EEG raw data. I am using the dB scale
    %      to more clearly show small fluctuations that might be obscured by
    %      the large 60 Hz oscillation. The choice to normalize by the max 
    %      power is merely one convention and, when plotting, obscures subsequent
    %      problems' time-dependent changes. Thus, I chose not to divide by the
    %      max power.
    %   e) The spectrogram shows that the rhythms do not change with time.
    %   f) The initial description of the data being dominated by a 60 Hz
    %      rhythm remains true. However, it does not show the simultaneous 30
    %      and 40 Hz rhythms that are ongoing. By computing the periodogram, we
    %      saw the presence of the 30 to 40 Hz rhythms. By computing the
    %      spectrogram, we saw that these rhythms remained stable throughout
    %      the entire period.
    
end