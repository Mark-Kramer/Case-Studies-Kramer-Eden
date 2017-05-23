function Chapter_8_Question_4()
    % Question 3 - Analyze Ch8-spikes-3.mat

    %Load Data
    load('Ch8-spikes-3.mat')
    T = 30;
    
    %Analyze Spikes
    Chapter_8_Analyze_Spikes(Spikes, T)
    
    % a) The firing rate is 7.6 Hz.
    % b) The spike train shows clear evidence of bursting. There is a large
    %    difference between periods of activity and periods of quiescence.
    % c) The histogram shows a large number of ISIs in the shorter range,
    %    followed by no activity, then a large period of activity again. This
    %    suggests bursting.
    % d) Spikes tend to cluster into 1-2 spikes per 50 millisecond bin. It's a
    %    bit difficult to see the bursting in this plot. 
    % e) The Fano Factor is .95, which indicates the spiking is actually a
    %    little bit more regular than expected (and less likely to be actually
    %    bursting).
    % f) There is compelling evidence for autocorrelation at short time ranges
    %    and a bit farther off.
    % g) There is no compelling evidence for autocorrelation at any lag.
    % h) The Poisson process model is not a good model for our data. This helps
    %    explain some of the oddities in our initial bursting-esque
    %    visualizations then finding no clear evidence in the model/fano
    %    factor.
    
end