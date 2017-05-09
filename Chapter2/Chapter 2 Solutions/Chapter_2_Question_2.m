function Chapter_2_Question_2()
    % Question 2 - Explore Ch2-EEG-2.mat
    
    load('Ch2-EEG-2.mat')
    Chapter_2_Analyze_EEG(EEG, t)
    %   a) The sample interval is .002 seconds. The sampling rate is 500 Hz.
    %   b) From visual inspection it seems like the EEG is not time-locked to the
    %      stimulus. Further, it looks like there are some oscillations in the
    %      activity. I do not expect to find an ERP different from zero, but
    %      the ERP will likely appear wave-like.
    %   c) There is no time at which the 95% Confidence Interval for ERP does
    %      not include zero. This data does not seem to have stimulus specific
    %      responses, but there are some interesting oscillatory behaviors that
    %      may merit further study.
    
end