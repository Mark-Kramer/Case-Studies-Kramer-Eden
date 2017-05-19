function Chapter_5_Question_5()
    % Question 5 - Hanning Taper Coherence

    %Load Data
    load('Ch5-ECoG-1.mat')
    ntrial = size(E1, 1);
    N = length(t);
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    T = t(end);
    x = E1 - mean(E1, 2); %mean-normalize
    y = E2 - mean(E2, 2); %mean-normalize
    
    %Window The Data
    wind = hann(N)'; %get hanning window
    wind_mat = repmat(wind, ntrial, 1); %repeat hanning window for each trial
    x_hann = x.*wind_mat; %apply hanning window
    y_hann = y.*wind_mat; %apply hanning window
    
    %Visualize Data
    figure()
    subplot(2, 1, 1)
    hold on
    plot(t, mean(x, 1), 'b', 'LineWidth', 2)
    plot(t, mean(y, 1), 'r', 'LineWidth', 2)
    hold off
    xlabel('Time (sec)')
    ylabel('Data')
    legend({'Average Electrode 1', 'Average Electrode 2'})
    title('Avearge Electrode Responses')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    hold on
    plot(t, mean(x_hann, 1), 'b', 'LineWidth', 2)
    plot(t, mean(y_hann, 1), 'r', 'LineWidth', 2)
    hold off
    xlabel('Time (sec)')
    ylabel('Data')
    legend({'Electrode 1 (w/ Hann Window)', 'Electrode 2 (w/ Hann Window)'})
    title('Average Electrode Responses')
    set(gca, 'FontSize', 14)
    
    %Compute Trial Cross-Covariance, Trial Spectrum, and Coherence Using Helper
    %Function
    [Sxx, Syy, Sxy, cross_cov, cohr, lags, faxis] = ...
        Chapter_5_Analyze_Electrodes(x, y, sample_freq, T);
    [Sxx_hann, Syy_hann, Sxy_hann, cross_cov_hann, cohr_hann, ~, ~] = ...
        Chapter_5_Analyze_Electrodes(x_hann, y_hann, sample_freq, T);
    
    %Plot Average Cross-Covariance
    figure()
    hold on
    plot(lags.*sample_interval, mean(cross_cov, 1), 'g', 'LineWidth', 2)
    plot(lags.*sample_interval, mean(cross_cov_hann, 1), 'm', 'LineWidth', 2)
    hold off
    xlabel('Lag (seconds)')
    ylabel('Cross-Covariance')
    title('Average Cross-Covariance')
    legend({'Data', 'Data (w/ Hann Window)'})
    ylim([-1 1])
    set(gca, 'FontSize', 14)
    
    %Plot Average Spectrum
    figure()
    subplot(2, 1, 1)
    hold on
    plot(faxis, 10*log10(mean(Sxx, 1)), 'b', 'LineWidth', 2)
    plot(faxis, 10*log10(mean(Syy, 1)), 'r', 'LineWidth', 2)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Average Spectrum')
    legend({'Electrode 1', 'Electrode 2'})
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    hold on
    plot(faxis, 10*log10(mean(Sxx_hann, 1)), 'b', 'LineWidth', 2)
    plot(faxis, 10*log10(mean(Syy_hann, 1)), 'r', 'LineWidth', 2)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Average Spectrum')
    legend({'Electrode 1 (w/ Hann Window)', 'Electrode 2 (w/ Hann Window)'})
    set(gca, 'FontSize', 14)

    %Plot Coherence
    figure()
    hold on
    plot(faxis, cohr, 'g', 'LineWidth', 2)
    plot(faxis, cohr_hann, 'm', 'LineWidth', 2)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Coherence')
    title('Coherence')
    legend({'Data', 'Data (w/ Hann Window)'})
    ylim([0 1])
    set(gca, 'FontSize', 14)

    % The Hanning taper helps smooth out some of the broadband noise present in
    % the coherence. However, in doing so, it reduces the peak coherence and
    % seems to distribute it over more frequencies. The average spectrum shows
    % similar changes, wherein the power is less and the spread is more, but
    % the noise is considerably reduced. The cross-covariance is slightly
    % reduced, likely due to the reduction in amplitude that the hanning taper
    % causes.
    
end