function Chapter_11_Question_2()
    % Question 2 - Analyze Ch11-spikes-2.mat
    
    %Load Data
    load('Ch11-spikes-LFP-2.mat')
    
    %Analyze Data w/ Helper Function
    Chapter_11_Analyze_Spike_LFP(n, y, t)
    
    %a) There are definitely rhythms in the LFP, but there aren't apparent
    %   rhythms in the spikes. If you squint the white space looks a little 
    %   like there are some rhythms, but it's certainly not conclusive. In 
    %   the lower plot you can clearly see that the spikes prefer to fire at
    %   the peak of the ongoing LFP.
    
    %b) The spike spectrum is odd, but has clear peaks at every multiple of 10.
    %   It's difficult to say what this means in terms of spike spectral
    %   analytics, but it's worth mentioning. There is also a clear spectral
    %   increase in the LFP at 10 Hz, which meshes with our visualization in
    %   part a). 
    
    %c) The spike triggered average clearly shows that the LFP is at a peak of
    %   a 10 Hz rhythm when the spikes tend to fire. The FTA shows that spikes
    %   tend to fire around the 0 phase of the rhythm. These clearly show
    %   associations between the two data sets.
    
    %d) The spike-field coherence shows a large coherence at the 10 Hz band.
    %   This meshes with all of our earlier data analysis.
    
    %e) Again, the GLM clearly shows an increase in firing rate probability as
    %   the oscillation gets to 0 phase. All of our analyses have led to the
    %   same conclusion.

    %f) Looking at the statistics output from the GLM in e), I can say that the
    %   spikes are clearly increasing their firing at the peak of the LFP
    %   cosine wave oscillating at 10 Hz. 
    
end