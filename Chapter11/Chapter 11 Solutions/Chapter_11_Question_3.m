function Chapter_11_Question_3()
    % Question 3 - Analyze Ch11-spikes-3.mat
    
    %Load Data
    load('Ch11-spikes-LFP-3.mat')
    
    %Analyze Data w/ Helper Function
    Chapter_11_Analyze_Spike_LFP(n, y, t)
    
    %a) There are definitely rhythms in the LFP and the spike data. Once more
    %   the lower plot shows an increase in firing rate as the peak of the LFP
    %   is reached.
    
    %b) The spike spectrum is odd, but has clear peaks at every multiple of 10.
    %   It's difficult to say what this means in terms of spike spectral
    %   analytics, but it's worth mentioning. There is also a clear spectral
    %   increase in the LFP at 10 Hz, which meshes with our visualization in
    %   part a). 
    
    %c) The spike triggered average clearly shows that the LFP is at a peak of
    %   a 10 Hz rhythm when the spikes tend to fire. The FTA shows that spikes
    %   tend to fire when near, but not on, the zero phase. These clearly show
    %   associations between the two data sets.
    
    %d) The spike-field coherence shows a large coherence at the 10 Hz band.
    %   However, there are also smaller coherences in other bands. 
    
    %e) Again, the GLM clearly shows an increase in firing rate probability as
    %   the oscillation gets to 0 phase. However, it did not fully capture that
    %   the rate is higher near 0 as opposed to at 0 phase. Further modeling
    %   could refine the choice of oscillations we fit, perhaps to better
    %   reflect the other peaks in the coherence analysis in part d).
    
    %f) This data set requires a bit of further analysis. There seems to be a
    %   dependency in the LFP at 10 Hz and how it impacts the spike rate.
    %   However, the FTA and coherence show that there may be other important
    %   frequencies to keep in mind.
    
end