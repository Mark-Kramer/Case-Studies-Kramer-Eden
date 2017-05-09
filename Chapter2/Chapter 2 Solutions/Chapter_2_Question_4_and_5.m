function Chapter_2_Question_4_and_5()
    % Question 4 and 5 - Explore Ch2-EEG-4.mat
    
    load('Ch2-EEG-4.mat')
    Chapter_2_Analyze_EEG(EEG, t)
    %   a) The sample interval is .002 seconds. The sampling rate is 500 Hz.
    %   b) From visual inspection it seems like the EEG is time-locked to the
    %      stimulus. I expect to see an ERP that reflects this.
    %   c) There are three peaks to the ERP, but none are different from zero.
    %      By looking at the individual trials, it shows a clear inversion of
    %      some responses. Sometimes, the response is positive peak - negative
    %      peak - positive peak. Other times, the response is negative peak -
    %      positive peak - negative peak. While Ch2-EEG-3.mat had the same
    %      problem, it was only for a minority of trials. This task, however,
    %      had more response flipping. Thus, to better analyze the data, we can
    %      look at the difference between peak positivity and peak negativity. 
    %      To make this a stimulus-locked measure, we can analyze the peak 
    %      positivity and peak negativity only within the 300msec to 500 msec
    %      window.
    
    %Analyze Peak To Peak Difference Between 300msec and 500msec
    time_window = [ (t >= .3) & (t <= .5) ]; %get logical boolean for times  
    peak_to_peak = max(EEG(:, time_window), [], 2) - min(EEG(:, time_window), [], 2);
    
    %Plot
    figure()
    histogram(peak_to_peak)
    xlabel('Peak to Peak Amplitude (\muV) Within .3 and .5 seconds')
    ylabel('Number in Bin')
    title('Alternative Analysis of EEG')
    set(gca, 'FontSize', 14)
    
end