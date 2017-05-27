function Chapter_11_Question_5()
    % Question 5 - Understand Spike-Field Coherence
    
    %Generate Data: 10 Hz Sinusoid w/ White Noise and 10 Hz Spike
    K =100;
    N = 1000;
    sample_interval = .001;
    f = 0.01;
    b = 1;
    t = sample_interval:sample_interval:1;
    y = zeros(K, N);
    n = zeros(K, N);
    for k = 1:K
        y(k, :) = sin(2*pi*(1:N)*sample_interval*10) + 0.1*randn(1, N);
        p = f*(b+exp(y(k, :)));
        n(k, :) = binornd(1, p, 1, N);
    end
   
    %Visualize LFP and Spike Data
    Chapter_11_Analyze_Spike_LFP(n, y, t)

    % a) The spike spectra shows a plateau at roughly 10 Hz (which is
    %    expected). The field spectra shows a clear plateau at 10 Hz, which is
    %    indicative of our sine wave and is expected.
    
    % b) The spike-triggered average does show a clear oscillatory
    %    component to it. The FTA shows some indication of spike synchrony 
    %    with the phase of the oscillation, but it is incredibly subtle.
    %    However, that is easily explained by our f value being 0.01. Were we
    %    to increase it, the FTA would increase too.
    
    % c) The coherence has a clear peak at 10 Hz. This is expected, given our
    %    data.
    
    % d) The GLM shows clear indication that there is a relationship between 
    %    the spike rate and the LFP.
    
    % All in all the measures, while showing subtle FTA's or GLM measures, 
    % clearly pick up on the idea that our spike is dependent upon the LFP.
    % Feel free to play around with the above parameters to see how the subtle
    % spike timing can be in terms of the yaxis on the FTA and GLM while still
    % having a clear structure in the overlayed spike/LFP plots.
    
end