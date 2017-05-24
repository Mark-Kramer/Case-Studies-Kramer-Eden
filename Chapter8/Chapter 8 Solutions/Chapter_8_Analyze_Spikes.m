function Chapter_8_Analyze_Spikes(spike_times, T)
    %INPUT:
    %   spike_times: vector of spike times
    
    %Get Firing Rate
    firing_rate = length(spike_times)/T;
    
    %Visualize Spike Train
    spike_train = ones(size(spike_times));
    figure()
    subplot(4, 1, 1)
    plot(spike_times, spike_train, '.k', 'MarkerSize', 10)
    xlabel('Time (seconds)')
    ylim([0.5 1.5])
    title('All Data')
    set(gca, 'FontSize', 14)
    subplot(4, 1, 2)
    plot(spike_times, spike_train, '.k', 'MarkerSize', 10)
    xlabel('Time (seconds)')
    ylim([0.5 1.5])
    xlim([0 5])
    title('First Five Seconds')
    set(gca, 'FontSize', 14)
    subplot(4, 1, 3)
    plot(spike_times, spike_train, '.k', 'MarkerSize', 10)
    xlabel('Time (seconds)')
    ylim([0.5 1.5])
    xlim([15 20])
    title('Middle Five Seconds')
    set(gca, 'FontSize', 14)
    subplot(4, 1, 4)
    plot(spike_times, spike_train, '.k', 'MarkerSize', 10)
    xlabel('Time (seconds)')
    ylim([0.5 1.5])
    xlim([25 30])
    title('Last Five Seconds')
    set(gca, 'FontSize', 14)
    
    %Get ISIs
    isi = diff(spike_times);
    time_bins = 0:.001:0.5;
    counts = hist(isi, time_bins);
    
    %Visualize ISIs
    figure()
    bar(time_bins, counts)
    xlim([0 0.15])
    xlabel('ISI (seconds)')
    ylabel('Count')
    title('ISI of Spikes')
    set(gca, 'FontSize', 14)
    
    %Visualize Increment Process
    time_bins = 0:0.05:T;
    increments_50 = hist(spike_times, time_bins);
    figure()
    plot(time_bins, increments_50, '.k', 'MarkerSize', 10)
    xlabel('Time (seconds)')
    ylabel('Number of Spikes')
    ylim([0 6])
    title('Increment Process For Spikes')
    set(gca, 'FontSize', 14)
      
    %Get Fano Factor
    ff = var(increments_50)/mean(increments_50);
    
    %Compute Autocorrelation
    time_bins = 0:0.001:T;
    increments_1 = hist(spike_times, time_bins);
    [autocorr_1, lags] = xcorr(increments_1 - mean(increments_1), 100, 'coeff');
    
    %Visualize Autocorrelation
    N = length(time_bins);
    ci = 2/sqrt(N);
    figure()
    hold on
    plot(lags, autocorr_1, '.k', 'MarkerSize', 10)
    line([-100 100], [ci, ci], 'LineWidth', 2)
    line([-100 100], -[ci, ci], 'LineWidth', 2)
    hold off
    xlabel('Lag (milliseconds)')
    ylabel('Autocorrelation')
    ylim([-0.1 0.1])
    title('Increment Autocorrelation')
    legend({'Lags', 'CI'})
    set(gca, 'FontSize', 14)
    
    %Compute Autocorrelation
    [isi_ACF_1, lags] = xcorr(isi - mean(isi), 20, 'coeff');
    
    %Visualize Autocorrelation
    N = length(isi);
    ci = 2/sqrt(N);
    figure()
    hold on
    plot(lags, isi_ACF_1, '.k', 'MarkerSize', 10)
    line([-20 20], [ci, ci], 'LineWidth', 2)
    line([-20 20], -[ci, ci], 'LineWidth', 2)
    hold off
    xlabel('No. of Spikes in Past/Future')
    ylabel('Autocorrelation')
    ylim([-0.1 0.1])
    title('ISI Autocorrelation')
    set(gca, 'FontSize', 14)
    
    %Fit Poisson Model (i.e. Exponential for ISI)
    bins = 0:0.001:0.5;
    lambda = 1/mean(isi);
    counts = hist(isi, bins);
    prob = counts/length(isi);
    model = lambda*exp(-lambda*bins)*.001; %get probability
    model_CDF = 1 - exp(-lambda*bins);
    emp_CDF = cumsum(prob);
    ci = 1.36/sqrt(length(isi));
    
    %Visualize Model
    figure()
    subplot(1, 2, 1)
    hold on
    bar(bins, prob)
    plot(bins, model, 'r', 'LineWidth', 2)
    hold off
    xlabel('ISI (seconds)')
    ylabel('Probability')
    xlim([0 0.15])
    title('ISI')
    legend({'Emp. PMF', 'Exp PDF'})
    set(gca, 'FontSize', 14)
    subplot(1, 2, 2)
    hold on
    plot(model_CDF, emp_CDF, 'k', 'LineWidth', 2)
    line([0 1], [0 1]+ci)
    line([0 1], [0 1]-ci)
    hold off
    xlabel('Model CDF')
    ylabel('Empirical CDF')
    axis([0 1 0 1])
    title('ISI KS Plot')
    set(gca, 'FontSize', 14)
  
end