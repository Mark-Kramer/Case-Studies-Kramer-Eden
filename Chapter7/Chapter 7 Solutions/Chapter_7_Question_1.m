function Chapter_7_Question_1()
    % Question 1 - Analyze Ch7-LFP-2.mat

    %Load Data
    load('Ch7-LFP-2.mat')
  
    %Analyze LFP
    Chapter_7_Analyze_LFP(LFP, [40 70], [3 7], t)
    
    % a) I observe a clear 5 or so Hz rhythm. However, there aren't any clear
    % higher frequency rhythms.
    
    % b) There are large rhythms at 3-7 Hz. If you squint, you can also kind of
    % see a slight increase in the 40 to 70 Hz range. These might be slightly
    % visible in the LFP, but it is hard to say for sure.
    
    % c) I use a low pass band of [3 7] and a high pass band of [40 70], since
    % these are the only places where it looks like there is some increase in
    % frequency. We do see there is a clear increase in the CFC for the low
    % pass phase (0 phase) and the high pass amplitude using either method.
    
    % d) The data has a clear 5 or so Hz oscillation. There are perhaps some
    % 40-70 Hz oscillations visible in the raw data, but it is slightly more
    % visible in the spectrum. After bandpassing, the oscillations become a bit
    % more visible and you see an increase in the amplitude of the high
    % frequency data at the peaks of the low frequency data. Subsequent CFC
    % analysis using both resampling and GLMs confirms this finding.

end