function Chapter_5_Question_6()
    % Question 6 - Analyze Ch5-ECoG-2.mat

    %Load Data
    load('Ch5-ECoG-2.mat')
    ntrial = size(x, 1);
    N = length(t);
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    T = t(end);
    x = x - mean(x, 2); %mean-normalize
    y = y - mean(y, 2); %mean-normalize
    
    %Visualize Data
    figure()
    hold on
    plot(t, mean(x, 1), 'b', 'LineWidth', 2)
    plot(t, mean(y, 1), 'r', 'LineWidth', 2)
    hold off
    xlabel('Time (sec)')
    ylabel('Data')
    legend({'Average Electrode 1', 'Average Electrode 2'})
    title('Electrode Responses')
    set(gca, 'FontSize', 14)
    
    %Compute Trial Cross-Covariance, Trial Spectrum, and Coherence Using Helper
    %Function
    [Sxx, Syy, Sxy, cross_cov, cohr, lags, faxis] = ...
        Chapter_5_Analyze_Electrodes(x, y, sample_freq, T);

    %Plot Average Cross-Covariance
    figure()
    plot(lags.*sample_interval, mean(cross_cov, 1), 'k', 'LineWidth', 2)
    xlabel('Lag (seconds)')
    ylabel('Cross-Covariance')
    title('Average Cross-Covariance')
    ylim([-1 1])
    set(gca, 'FontSize', 14)
    
    %Plot Average Spectrum
    figure()
    hold on
    plot(faxis, 10*log10(mean(Sxx, 1)), 'b', 'LineWidth', 2)
    plot(faxis, 10*log10(mean(Syy, 1)), 'r', 'LineWidth', 2)
    hold off
    xlim([0 40])
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Average Spectrum')
    legend({'Electrode 1', 'Electrode 2'})
    set(gca, 'FontSize', 14)

    %Plot Coherence
    figure()
    plot(faxis, cohr, 'k', 'LineWidth', 2)
    xlim([0 40])
    ylim([0 1])
    xlabel('Frequency (Hz)')
    ylabel('Coherence')
    title('Coherence')
    set(gca, 'FontSize', 14)

    % a) The data definitely has structure to it, but what rhythms it invovles
    % is hidden slightly by their apparent overlap. The largest peaks and
    % troughs display a 10 Hz rhythm, but between them are roughly two other
    % peaks and troughs. If we count all peaks (not just the largest ones), we
    % see a 15 Hz rhythm.
    
    % b) Both electrodes show a 10 Hz and 15 Hz spectrum, consistent with our
    % careful (albeit somewhat unsure) analysis of the time series in part a).
    
    % c) The cross-covariance is a bit odd. There seems to be again the 10 Hz
    % and 15 Hz rhythms overlayed, but like a) it's difficult to be sure of
    % this conclusion. 
    
    % d) The coherence clearly shows huge bands at both the 10 Hz and 15 Hz
    % band. Thus, the data are not each independently oscillating at 10 Hz and
    % 15 Hz. Rather, they are oscillating in phase with one another (causing
    % the large coherence). If you look through the individual trials in the
    % data, this is immediately clear.
    
    % e) These two electrodes are very in-sync and are each oscillating at 10 Hz
    % and 15 Hz.

end