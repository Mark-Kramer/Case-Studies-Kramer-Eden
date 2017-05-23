function Chapter_7_Question_3()
    % Question 3 - Analyze White Noise
    

    %Generate White Noise Data
    T = 100;
    sample_freq = 1000;
    sample_interval = 1/sample_freq;
    t = sample_interval:sample_interval:T;
    x = randn(1, length(t)); %generate random numbers uniform between 0 and 1
    x = (x - mean(x) ) ./ std(x); %generate white noise with 0 mean and 1 var

    %Analyze LFP
    Chapter_7_Analyze_LFP(x, [80 120], [5 7], t)
    
    % When generating the noise and then computing the spectrum, there is no
    % clear relationship or power in any of the frequencies. However, the CFC
    % shows a significant change in amplitude as a function of change. This is
    % interesting, since we don't expect it. Thus, caution must be taken to
    % make sure that the CFC analysis is clearly visible in the LFP before
    % assuming the CFC analysis is correct. It appears quite easy to get a
    % coherence, even when there is none.

end