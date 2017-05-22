function Chapter_7_Question_2()
    % Question 2 - Analyze Ch7-LFP-3.mat

    %Load Data
    load('Ch7-LFP-3.mat')
  
    %Analyze LFP
    Chapter_7_Analyze_LFP(LFP, [16 20], [5 7], t)
    
    % a) There is a clear rhythm, but it doesn't look neural. The frequency of
    % the rhythm is 6 Hz or so. There is no clear higher frequency.
    
    % b) There are large rhythms at 6, 12, and 18 Hz. Then, the power decreases
    % slowly from there, but some observeable peaks occur at every 6 Hz. This
    % is likely due to the number of frequencies required to create a sharp
    % drop in the LFP (as seen in the raw data). 
    
    % c) I use a low pass band of [5 7] and a high pass band of [16 20]. I do
    % this because I want to highlight how the 18 Hz is only used in the sharp
    % drop down. The CFC shows a clear relationship between the phase of the
    % low pass band and the high pass amplitude. These correspond to times when
    % the sharp peak occurs.
    
    % d) The data has a clear 6 or so Hz oscillation. There are other
    % frequencies at 12 and 18 Hz, but these are used only to capture the sharp
    % deflections in the data. No other clear high frequency activity is seen.

end