function Chapter_5_Question_2()
    % Question 2 - Gaussian Model Average Cross-Covariance, Cross-Spectrum, and
    % Coherence

    %Generate Data
    T = 1;
    sample_interval = .002;
    sample_freq = 1/sample_interval;
    t = sample_interval:sample_interval:T;
    N = length(t);
    ntrials = 100;
    x = randn(ntrials, N); %generate random numbers uniform between 0 and 1
    x = (x - mean(x, 2) ) ./ std(x, [], 2); %generate white noise with 0 mean and 1 var
    y = randn(ntrials, N); %generate random numbers uniform between 0 and 1
    y = (y - mean(y, 2)) ./ std(y, [], 2); %generate white noise with 0 mean and 1 var

    %Visualize Data
    figure()
    hold on
    plot(t, mean(x, 1), 'b', 'LineWidth', 2)
    plot(t, mean(y, 1), 'r', 'LineWidth', 2)
    hold off
    xlabel('Time (sec)')
    ylabel('Data')
    legend({'Avg. White Noise 1', 'Avg. White Noise 2'})
    title('Average Simulated Data')
    set(gca, 'FontSize', 14)
    
    %Compute Trial Cross-Covariance, Trial Spectrum, and Coherence Using Helper
    %Function
    [Sxx, Syy, Sxy, cross_cov, cohr, lags, faxis] = ...
        Chapter_5_Analyze_Electrodes(x, y, sample_freq, T);
    
    %Plot Trial-Averaged Spectrum
    figure()
    hold on
    plot(faxis, 10*log10(mean(Sxx, 1)), 'b', 'LineWidth', 2)
    plot(faxis, 10*log10(mean(Syy, 1)), 'r', 'LineWidth', 2)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Trial Averaged Spectrum')
    legend({'Avg. White Noise 1', 'Avg. White Noise 2'})
    set(gca, 'FontSize', 14)
    
    %Plot Trial-Averaged Cross-Covariance
    figure()
    plot(lags*sample_interval, mean(cross_cov, 1), 'b', 'LineWidth', 2)
    xlabel('Time (sec)')
    ylabel('Cross-Covariance')
    ylim([-0.1 0.1])
    title('Trial Averaged Cross-Covariance')
    set(gca, 'FontSize', 14)

    %Plot Coherence
    figure()
    plot(faxis, cohr, 'k', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Coherence')
    title('Coherence')
    ylim([0 1])
    set(gca, 'FontSize', 14)
    
    % a) The trial-averaged spectrum shows no clear power in any frequencies,
    % indicating a lack of time-based autocorrelation between points. Since
    % this is the very definition of Gaussian white noise, I'm not surprised by
    % this result.
    
    % b) The trial-averaged cross-covariance is effectively zero across all
    % lags. Again, this is expected because there is no intrinsic correlation
    % between time points in a Gaussian white noise data set.
    
    % c) The coherence, however, is a bit surprising. It seems like there is
    % actually some coherence (albeit low, and not at any particular
    % frequency). Thus, the key thing to remember when analyzing data is that
    % coherence can find spurious values even if your data sets are completely
    % independent. It is important to make sure the coherence is not just an
    % effect of correlating the data. This can be done by shuffling the trials
    % and computing the coherence using shuffled data; this gives a baseline
    % coherence that occurs by chance. Note: this shuffling will not work if
    % there is a constant phase relation between the two data sets regardless
    % of trial (because the shuffling won't actually shuffle anything; there is
    % still constant phase relation regardless of which trial). However, in
    % this case, the coherence will be 1 or near 1, which is much more
    % convincing then the spurious values around .2 or so we saw here.    
    
end