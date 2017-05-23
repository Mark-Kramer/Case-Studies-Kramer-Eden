function Chapter_7_Question_4()
    % Question 4 - Analyze Ch7-LFP-1.mat

    %Load Data
    load('Ch7-LFP-1.mat')
  
    %Analyze LFP
    Chapter_7_Analyze_LFP(LFP, [40 60], [5 7], t)
    
    % Again we see a relationship between the low frequency and high frequency
    % components. However, this isn't clear in the raw data. This apparent
    % ability to find CFC between any two frequencies is quite alarming so care
    % must be taken to not blindly apply this method.

end