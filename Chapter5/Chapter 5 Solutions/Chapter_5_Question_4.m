function Chapter_5_Question_4()
    % Question 4 - Gaussian Model Single Trial Cross-Covariance,
    % Cross-Spectrum, and Coherence

    %Describe Data
    T = 1;
    sample_interval = .002;
    sample_freq = 1/sample_interval;
    t = sample_interval:sample_interval:T;
    N = length(t);
 
    %Generate White Noise Data
    x = randn(1, N); %generate random numbers uniform between 0 and 1
    x = (x - mean(x) ) ./ std(x); %generate white noise with 0 mean and 1 var
    y = randn(1, N); %generate random numbers uniform between 0 and 1
    y = (y - mean(y)) ./ std(y); %generate white noise with 0 mean and 1 var

    %Visualize Data
    figure()
    hold on
    plot(t, x, 'b', 'LineWidth', 2)
    plot(t, y, 'r', 'LineWidth', 2)
    hold off
    xlabel('Time (sec)')
    ylabel('Data')
    legend({'Single Trial White Noise 1', 'Single Trial White Noise 2'})
    title('Simulated Data')
    set(gca, 'FontSize', 14)
    
    %Compute Trial Cross-Covariance, Trial Spectrum, and Coherence Using Helper
    %Function
    [Sxx, Syy, Sxy, cross_cov, cohr, lags, faxis] = ...
        Chapter_5_Analyze_Electrodes(x, y, sample_freq, T);
    
    %Plot Single Trial Cross-Covariance
    figure()
    plot(lags.*sample_interval, cross_cov, 'k', 'LineWidth', 2)
    xlabel('Lag (seconds)')
    ylabel('Cross-Covariance')
    title('Single Trial Cross-Covariance')
    ylim([-1 1])
    set(gca, 'FontSize', 14)
    
    %Plot Single Trial Spectrum
    figure()
    hold on
    plot(faxis, 10*log10(mean(Sxx, 1)), 'b', 'LineWidth', 2)
    plot(faxis, 10*log10(mean(Syy, 1)), 'r', 'LineWidth', 2)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Single Trial Spectrum')
    legend({'Single Trial White Noise 1', 'Single Trial White Noise 2'})
    set(gca, 'FontSize', 14)
    
    %Plot Single Trial Coherence
    figure()
    plot(faxis, cohr, 'k', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Coherence')
    title('Single Trial Coherence')
    ylim([0 1.1])
    set(gca, 'FontSize', 14)

    % The data, cross-covariance, and spectrum all indicate a complete lack of
    % underlying synchrony or correlation between the two data sets. This is
    % expected, considering our data is randomly generated white noise.
    % However, the coherence is 1 at all frequencies. Why? This is because,
    % over the course of 1 trial, any given frequency from White Noise 1 will
    % always have the same phase relationship with the same frequency in White
    % Noise 2. Thus, there is perfect coherence over the course of this single
    % trial when we are only comparing one phase difference. This illustrates
    % the importance of remembering that coherence is a measure of synchrony
    % over repeated trials/time. However, using a multitaper method we can
    % actually compute single trial coherence. This is explored in Question 8.
    
end