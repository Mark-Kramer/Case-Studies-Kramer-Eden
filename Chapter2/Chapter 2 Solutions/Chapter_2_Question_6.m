function Chapter_2_Question_6()
    % Question 6 - Explore Ch2-EEG-5.mat
    
    load('Ch2-EEG-5.mat')
    Chapter_2_Analyze_EEG(EEG, t)
    %   a) The sample interval is .002 seconds. The sampling rate is 500 Hz.
    %   b) From visual inspection there is no clear response to the stimulus.
    %   c) There is one square peak at around 250 msec. However, the error bars
    %      on this are quite large and from visual inspection the data doesn't
    %      really show the same. There may be a signal, but it is heavily
    %      obscured by noise.

end