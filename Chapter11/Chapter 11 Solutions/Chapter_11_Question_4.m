function Chapter_11_Question_4()
    % Question 4 - Understand Spike-Field Coherence
    
    %Generate Data: 10 Hz Sinusoid w/ White Noise and 10 Hz Spike
    K =100;
    N = 1000;
    sample_interval = .001;
    t = sample_interval:sample_interval:1;
    y = zeros(K, N);
    n = zeros(K, N);
    for k = 1:K
        y(k, :) = sin(2*pi*(1:N)*sample_interval*10) + 0.1*randn(1, N);
        n(k, :) = binornd(1, 0.01, 1, N);
    end
   
    %Visualize LFP and Spike Data
    Chapter_11_Analyze_Spike_LFP(n, y, t)

    % a) The spike spectra shows a plateau at roughly 10 Hz (which is
    %    expected). The field spectra shows a clear plateau at 10 Hz, which is
    %    indicative of our sine wave and is expected.
    
    % b) The spike-triggered average does show a bit of an oscillatory
    %    component to it. This is likely due to the overwhelming signal being a
    %    10 Hz wave that is created with the same phase shift for each trial.
    %    Thus, it makes sense that our STA would have some structure by chance.
    %    However, the FTA shows no indication of spike synchrony with the phase
    %    of the oscillation.
    
    % c) The coherence has some noisy peaks but nothing that stands out as
    %    being coherent. This is expected, given our data.
    
    % d) The GLM (if you look at the stats and the y-axis closely) shows no
    %    indication that there is a relationship between the spike rate and the
    %    LFP.
    
    % All in all the only potentially surprising thing was our STA showing some
    % evidence of a sinusoid relationship with our spikes. However, this is
    % likely due to chance and an overwhelming LFP signal. Other analysis
    % clearly show our two random data sets have no relationship to each other.
    
end