function Chapter_3_Question_7()
    % Question 7 - Explore/Analyze Ch3-EEG-5.mat
    
    %Set Up
    load('Ch3-EEG-5.mat')
    data = EEG - mean(EEG);
    
    %Run Analysis (with helper function)
    Chapter_3_Analyze_EEG(data, t)
    %   a) The sampling interval is: 0.001 seconds.
    %      The total duration of recording is 2 seconds.
    %      The frequency resolution is 0.5 Hz.
    %      The Nyquist frequency is 500 Hz.
    %   b) The data is odd, to say the least. There seems to be a somewhat 2 Hz
    %      square wave that a noisy mixture of other frequencies are riding on
    %      top of.
    %   c) The autocovariance shows a slope heading down as the lags increase.
    %      There are no apparent oscillations in the autocovariance plot.
    %   d) The periodogram shows that every 4 Hz there is a peak in oscillatory
    %      power. This is likely because a square wave can be fit by a series
    %      of related frequencies overlayed on top of one another.The rest 
    %      appears to just be noisy measurements of frequency, indicating no
    %      other clear rhythms present in the signal. I am using the dB scale
    %      to more clearly show small fluctuations. The choice to normalize 
    %      by the max power is merely one convention and, when plotting, 
    %      obscures this problem's time-dependent changes. Thus, I chose not
    %      to divide by the max power.
    %   e) The spectrogram shows a peak frequency roughly every 4 Hz at the
    %      beginning, then a brief pause (corresponding to the large vertical
    %      line in the data), then again a peak frequency roughly every 4 Hz.
    %   f) The initial description of the data has been confirmed by the
    %      spectrogram, but not really they autocovariance or the periodogram.
    %      This particular form of wave (square wave) is particularly difficult
    %      to interpret, due to all the overlying frequencies needed to
    %      generate it. While the spectrogram kind of shows it, the data itself
    %      is definitely more useful in terms of understanding what the signal
    %      is (a square wave with noise at the peaks and troughs).
    
end