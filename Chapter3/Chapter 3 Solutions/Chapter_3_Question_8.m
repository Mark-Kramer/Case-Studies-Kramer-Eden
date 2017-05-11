function Chapter_3_Question_8()
    % Question 8 - Sine Function Analysis
    
    %Generate Data
    dt = 0.001; %note typo in book: should be 0.001 second not 0.001 millisecond 
    t = dt:dt:10;
    data = sin(2 * pi .* (t.^2));
    
    %Run Analysis (with helper function)
    Chapter_3_Analyze_EEG(data, t)
    %   a) The sampling interval is: 0.001 seconds.
    %      The total duration of recording is 10 seconds.
    %      The frequency resolution is 0.1 Hz.
    %      The Nyquist frequency is 500 Hz.
    %   b) The data is much like Ch3-EEG-4.mat data in question 6. It begins at
    %      a low frequency and increases to a 20 Hz or so frequency by the end
    %      of the data.
    %   c) The autocovariance shows a 16 Hz or so rhythm.
    %   d) The periodogram shows an increase in the [0 20] frequency range. 
    %      I am using the dB scale to more clearly show small fluctuations. 
    %      The choice to normalize by the max power is merely one convention 
    %      and, when plotting, obscures this problem's time-dependent changes.
    %      Thus, I chose not to divide by the max power.
    %   e) The spectrogram shows a clear change in the oscillatory power that
    %      starts at 0 Hz and goes until about 20 Hz. This is exactly what we
    %      saw by looking at the data.
    %   f) The initial description of the data has been confirmed by the
    %      spectrogram, but not really they autocovariance or the periodogram.
    %      This is expected because our data was a sine wave whose frequency
    %      varied (increased) with time.
    
end