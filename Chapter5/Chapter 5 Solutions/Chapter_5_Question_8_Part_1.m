function Chapter_5_Question_8_Part_1()
    % Question 8 - Multitaper Coherence with White Noise
    % note: requires the Chronux toolbox is downloaded and in your MATLAB
    % directory
    
    %Describe Data
    T = 10;
    sample_interval = .001;
    sample_freq = 1/sample_interval;
    t = sample_interval:sample_interval:T;
    N = length(t);
    
    %Generate Gaussian White Noise
    x = randn(1, N);
    x = (x - mean(x)) ./ std(x);
    y = randn(1, N);
    y = (y - mean(y)) ./ std(y);
    
    %Visualize Data
    figure()
    hold on
    plot(t, x, 'b', 'LineWidth', 0.5)
    plot(t, y, 'r', 'LineWidth', 0.5)
    hold off
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Simulated Data')
    legend({'White Noise 1', 'White Noise 2'})
    set(gca, 'FontSize', 14)
    
    %Compute Coherence With Helper Function (we expect it to be 1 since it's
    %only one trial)
    [~, ~, ~, ~, cohr, ~, faxis] = ...
        Chapter_5_Analyze_Electrodes(x, y, sample_freq, T);
    
    %Plot Coherence (we expect it to be 1 since it's only one trial)
    figure()
    plot(faxis, cohr, 'k', 'LineWidth', 2)
    ylim([0 1.1])
    xlabel('Frequency (Hz)')
    ylabel('Coherence')
    title('Single-Trial Coherence (Regular Method)')
    set(gca, 'FontSize', 14)
    
    %Set Up the MTM Coherence Parameters
    TW = 20;
    ntapers = 2*TW - 1;
    params.Fs = sample_freq;
    params.tapers = [TW, ntapers];
    params.pad = -1;
    
    %Try to Get MTM Coherence
    try
        [C, phi, S12, S1, S2, f] = coherencyc(x, y, params);
    catch
        disp('Please Install Chronux to Display the Multitaper Coherence')
        return
    end
    
    %Plot Coherence (Multitaper Method)
    figure()
    plot(f, C, 'k', 'LineWidth', 2)
    ylim([0 1])
    xlabel('Frequency (Hz)')
    ylabel('Coherence')
    title('Single Trial Coherence (Multitaper Method)')
    set(gca, 'FontSize', 14)
    
    % We see that the regular method of coherence causes problems, since we
    % only have one trial. The multitaper method shows noisy coherence, but
    % clearly no frequency is past the noisy baseline.
    
end