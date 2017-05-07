function Chapter_2_Question_3()
    % Question 3 - Explore Ch2-EEG-3.mat
    
    load('Ch2-EEG-3.mat')
    Chapter_2_Analyze_EEG(EEG, t)
    %   a) The sample interval is .002 seconds. The sampling rate is 500 Hz.
    %   b) From visual inspection it seems like the EEG is time-locked to the
    %      stimulus. I expect to see an ERP that reflects this.
    %   c) There are three peaks to the ERP. First, there is a large positive
    %      voltage at roughly 350 msec. This is followed by a large negative
    %      voltage at 400 msec and a subsequent large positive voltage at
    %      roughly 450 msec. Thus, this data displays a stereotyped response to
    %      the stimulus.
    
end