function Chapter_7_Question_6()
    % Question 6 - Analyze Ch7-LFP-1.mat w/ Different GLM Parameters

    %Load Data and Define Important Information
    load('Ch7-LFP-1.mat')

    %Calculate Comodulogram
    phase = 3:1:12;
    amp = 50:10:200;
    Chapter_7_Comodulograms(LFP, phase, amp, t)
    
end