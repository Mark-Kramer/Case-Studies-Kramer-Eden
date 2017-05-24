function Chapter_8_Question_3()
    % Question 3 - Analyze Ch8-spikes-2.mat

    %Load Data
    load('Ch8-spikes-2.mat')
    T = 30;
    
    %Analyze Spikes
    Chapter_8_Analyze_Spikes(Spikes, T)
    
    % a) The firing rate is 23.3 Hz.
    % b) The spike train shows some evidence of bursting (periods of activity
    %    and quiescence), but it appears a bit more regular than expected.
    % c) The histogram shows a large number of ISIs in the shorter range,
    %    indicating bursting type activity.
    % d) Spikes tend to cluster into 1-2 spikes per 50 millisecond bin. This
    %    suggests against bursting.
    % e) The Fano Factor is .9, which indicates the spiking is actually a
    %    little bit more regular than expected (and less likely to be actually
    %    bursting).
    % f) There is no compelling evidence for autocorrelation at any lag.
    % g) There is no compelling evidence for autocorrelation at any lag.
    % h) The Poisson process model is a great fit for our data.
    
end