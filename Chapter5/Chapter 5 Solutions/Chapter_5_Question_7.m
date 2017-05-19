function Chapter_5_Question_7()
    % Question 7 - Analyze Ch5-ECoG-3.mat

    %Load Data
    load('Ch5-ECoG-3.mat')
    ntrials = size(x, 1);
    N = length(t);
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    T = t(end);
    x = x - mean(x, 2); %mean-normalize
    y = y - mean(y, 2); %mean-normalize
    
    %Visualize Average Data
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
    
    %Visualize Random Trials of Data
    rand_trials = randi([1 ntrials], 1, 4);
    figure()
    plot_ind = 1;
    for trial = rand_trials
        subplot(4, 1, plot_ind)
        hold on
        plot(t, x(trial, :), 'b', 'LineWidth', 2)
        plot(t, y(trial, :), 'r', 'LineWidth', 2)
        hold off
        xlabel('Time (seconds)')
        ylabel('Data')
        legend({'Electrode 1', 'Electrode 2'})
        title(['Electrode Responses: Trial ', num2str(trial)])
        set(gca, 'FontSize', 14)
        plot_ind = plot_ind + 1;
    end
    
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

    % a) By looking at just the average, we can see a clear 15 Hz rhythm in
    % electrode 1. There is also a 25 Hz rhythm in electrode 2. However, single
    % trials of each perhaps show other oscillations that are difficult to see.
    
    % b) The spectrum shows clear dominant rhythms for electrode 1 being 10 and
    % 15 Hz. The spectrum shows clear dominant rhythms for electrode 2 being 5
    % and 25 Hz. Since we only saw the 15 Hz and 25 Hz oscillations in the 
    % average plot in a) (for electrodes 1 and 2, respectively), we can 
    % hypothesize that those frequencies are similar in phase for each trial.
    % However, the 10 Hz and 5 Hz oscillations were not clear in the average
    % but were slightly more visible when looking at individual trials. Thus,
    % those frequencies must not have a coherent phase across trials.
    % Otherwise, they would have been visible in the time series plot.
    
    % c) The trial-averaged cross-covariance shows no covariance between the
    % datasets. We couldn't really see anything in the time series, so this
    % isn't terribly surprising.

    % d) There is no clear coherence between the two datasets at any frequency.
    
    % e) Electrode 1 has a (likely) phase-invariant 15 Hz rhythm and a (likely)
    % random-phase 10 Hz rhythm. Electrode 2 has a (likely) phase invariant 
    % 25 Hz rhythm and a (likely) random-phase 5 Hz rhythm. None of these
    % frequencies are coherent with one another.
    
end