function Chapter_5_Question_3()
    % Question 3 - Sine + Gaussian Model Average Cross-Covariance,
    % Cross-Spectrum, and Coherence

    %Describe Data
    T = 1;
    sample_interval = .002;
    sample_freq = 1/sample_interval;
    t = sample_interval:sample_interval:T;
    N = length(t);
    ntrials = 100;
    freq = 10;
    phase = rand(ntrials, 1)*2*pi; %random phase
    t_mat = repmat(t, ntrials, 1); %used later for quick matrix addition
    phase_mat = repmat(phase, 1, N); %used later for quick matrix addition
    
    %Generate 10 Hz Sine Data w/ Random Phase and White Noise
    x = sin(2*pi*freq*t_mat + phase_mat);
    white_noise = randn(ntrials, N);
    white_noise = (white_noise - mean(white_noise, 2)) ./ std(white_noise, [], 2);
    x = x + white_noise; %add white noise
    
    %Generate 10 Hz Sine Data w/ Pi Phase and White Noise
    y = sin(2*pi*freq*t_mat + pi); 
    white_noise = randn(ntrials, N);
    white_noise = (white_noise - mean(white_noise, 2)) ./ std(white_noise, [], 2);
    y = y + white_noise; %add white noise
    
    %Visualize Data
    figure()
    hold on
    plot(t, mean(x, 1), 'b', 'LineWidth', 2)
    plot(t, mean(y, 1), 'r', 'LineWidth', 2)
    hold off
    xlabel('Time (sec)')
    ylabel('Data')
    legend({'Avg. Sine (random phase) + White Noise', 'Avg. Sine (phase = \pi) + White Noise'})
    title('Average Simulated Data')
    set(gca, 'FontSize', 14)
    
    %Compute Trial Cross-Covariance, Trial Spectrum, and Coherence Using Helper
    %Function
    [Sxx, Syy, Sxy, cross_cov, cohr, lags, faxis] = ...
        Chapter_5_Analyze_Electrodes(x, y, sample_freq, T);
    
    %Compute Trial Phase For Each Dataset and the Cross-Spectrum
    phase_freq = 10; %I want to look at 10 Hz frequency phase relations
    [phase_matrix_x, phase_matrix_y, phase_matrix_xy] = ...
        Chapter_5_Compute_Phase(x, y, sample_freq, T, phase_freq);

    %Plot Trial-Averaged Spectrum
    figure()
    hold on
    plot(faxis, 10*log10(mean(Sxx, 1)), 'b', 'LineWidth', 2)
    plot(faxis, 10*log10(mean(Syy, 1)), 'r', 'LineWidth', 2)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Trial Averaged Spectrum')
    legend({'Avg. Sine (random phase) + White Noise', 'Avg. Sine (phase = \pi) + White Noise'})
    set(gca, 'FontSize', 14)
    
    %Plot Coherence
    figure()
    plot(faxis, cohr, 'k', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Coherence')
    title('Coherence')
    ylim([0 1])
    set(gca, 'FontSize', 14)
    
    %Plot Phase of Each Signal As Well As Their Difference
    figure()
    subplot(2, 2, 1)
    rose(phase_matrix_x)
    title('Phase for Avg. Sine (random phase) + White Noise')
    set(gca, 'FontSize', 14)
    subplot(2, 2, 2)
    rose(phase_matrix_y)
    title('Phase for Avg. Sine (phase = \pi) + White Noise')
    set(gca, 'FontSize', 14)
    subplot(2, 2, 3)
    rose(phase_matrix_x - phase_matrix_y)
    title('Phase Difference Between Datasets (Direct Difference Of Phase)')
    set(gca, 'FontSize', 14)
    subplot(2, 2, 4)
    rose(phase_matrix_xy)
    title('Phase Difference Between Datasets (Cross-Spectrum Phase)')
    set(gca, 'FontSize', 14)
    
    % We see from the trial-averaged spectrum that both include frequencies
    % at the expected 10 Hz frequency. However, the coherence shows absolutely
    % no relationship between the two data sets. This makes sense, given that
    % one data set has random phase and the other has a locked phase at pi.
    % This is informative because it means that, while we obviously see no
    % coherence between them, they both have a dominant 10 Hz rhythm. Further,
    % were we to analyze the phase of the rhythms, we would see that the data
    % set with the random phase has, obviously, a random phase and that the
    % data set with a fixed phase has a fixed phase. Thus, it is important to
    % compute all these measures when working with your data. By not looking at
    % each data set's phase, we are ignoring one of the most important aspects 
    % that separate the two data sets. Note that I have plotted the data's
    % individual phases, the difference in their phases (after extraction from
    % the Fourier Transform), and the angle difference as extracted directly
    % from the cross-spectrum fourier transform. This is merely for
    % instructional purposes. 
    
    %IMPORTANT: the phase plot is meant to illustrate phase difference as
    %computed by the cross-spectrum. The best way to analyze phase in one
    %signal is explored in Chapter 7.
    
end