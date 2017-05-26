function Chapter_10_Question_1()
    % Question 1 - Analyze Ch10-spikes-2.mat
    
    %Load Data and Get Useful Information
    load('Ch10-spikes-2.mat')
    T = 10;
    sample_interval = .001;
    t = sample_interval:sample_interval:T;
    spike_inds1 = find(spike1);
    spike_inds2 = find(spike2);
    spike_times1 = t(spike_inds1);
    spike_times2 = t(spike_inds2);
    
    %Visualize Data
    figure()
    subplot(2, 1, 1)
    hold on
    plot(spike_times1, ones(1, length(spike_times1)), '.k', 'MarkerSize', 10)
    plot(spike_times2, 2*ones(1, length(spike_times2)), '.r', 'MarkerSize', 10)
    hold off
    xlabel('Time (seconds)')
    ylim([0 3])
    ylabel('Spike Train')
    title('Rat Cortex Experiment')
    legend({'Spike 1', 'Spike 2'})
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    hold on
    plot(spike_times1, ones(1, length(spike_times1)), '.k', 'MarkerSize', 10)
    plot(spike_times2, 2*ones(1, length(spike_times2)), '.r', 'MarkerSize', 10)
    hold off
    xlabel('Time (seconds)')
    ylim([0 3])
    xlim([0 1])
    ylabel('Spike Train')
    title('Rat Cortex Experiment')
    legend({'Spike 1', 'Spike 2'})
    set(gca, 'FontSize', 14)
    
    %Compute Autocorrelation (note: not autocovariance)
    [auto_corr1, lags] = xcorr(spike1 - mean(spike1), 200, 'coeff');
    [auto_corr2, ~] = xcorr(spike2 - mean(spike2), 200, 'coeff');
    figure()
    subplot(2, 1, 1)
    plot(lags, auto_corr1, 'k', 'LineWidth', 2)
    xlabel('Lag (milliseconds)')
    ylabel('Autocorrelation')
    title('Spike 1')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(lags, auto_corr2, 'k', 'LineWidth', 2)
    xlabel('Lag (milliseconds)')
    ylabel('Autocorrelation')
    title('Spike 2')
    set(gca, 'FontSize', 14)
    
    %Compute Spectrum
    TW = 4;
    ntapers = 2*TW - 1;
    params.Fs = 1000;
    params.tapers = [TW ntapers];
    params.fpass = [0 500];
    [spike1_S, f] = mtspectrumpb(spike1, params);
    [spike2_S, ~] = mtspectrumpb(spike2, params);

    %Visualize Spectrum
    figure()
    subplot(2, 1, 1)
    plot(f, spike1_S, 'k', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (Hz)')
    title('Spike 1')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(f, spike2_S, 'k', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (Hz)')
    title('Spike 2')
    set(gca, 'FontSize', 14)
    
    %Create Model Parameters
    spike_burn_in = 140; %need at least 140 lags to fit model
    hist_inds = [3:7, 120:140];
    n_hist_params = length(hist_inds);
    y1 = spike1(spike_burn_in+1:end);
    y2 = spike2(spike_burn_in+1:end);
    spike_inds1 = find(y1);
    spike_inds2 = find(y2);
    N1 = length(spike_inds1);
    N2 = length(spike_inds2);
    xHist1 = zeros(length(y1), n_hist_params);
    xHist2 = zeros(length(y1), n_hist_params);
    
    %Populate History Matrix
    i = 1;
    for j = (spike_burn_in + 1):length(spike1)
        xHist1(i, :) = spike1(j - hist_inds);
        xHist2(i, :) = spike2(j - hist_inds);
        i = i + 1;
    end
    
    %Fit Model
    [b1, dev1, stats1] = glmfit(xHist1, y1, 'poisson', 'log');
    [b2, dev2, stats2] = glmfit(xHist2, y2, 'poisson', 'log');
    lambda1 = exp(b1(1) + xHist1*b1(2:end));
    lambda2 = exp(b2(1) + xHist2*b2(2:end));
    
    %Time-Rescale
    Z1(1) = sum(lambda1(1:spike_inds1(1)));
    Z2(1) = sum(lambda2(1:spike_inds2(1)));
    for i = 2:N1
        Z1(i) = sum(lambda1(spike_inds1(i-1) + 1:spike_inds1(i)));
    end
    for i = 2:N2
        Z2(i) = sum(lambda2(spike_inds2(i-1) + 1:spike_inds2(i)));
    end
    [eCDF1, zvals1] = ecdf(Z1);
    [eCDF2, zvals2] = ecdf(Z2);
    mCDF1 = 1 - exp(-zvals1);
    mCDF2 = 1 - exp(-zvals2);
    
    %Model 1: KS
    ci1 = 1.36/sqrt(N1);
    ci2 = 1.36/sqrt(N2);
    figure()
    subplot(1, 2, 1)
    hold on
    plot(mCDF1, eCDF1, 'k', 'LineWidth', 2)
    plot([0 1], [0 1] + ci1, '--k', 'LineWidth', 1)
    plot([0 1], [0 1] - ci1, '--k', 'LineWidth', 1)
    hold off
    xlabel('Model CDF')
    ylabel('Emirical CDF')
    xlim([0 1])
    ylim([0 1])
    title('Spike 1 KS Plot')
    set(gca, 'FontSize', 14)
    subplot(1, 2, 2)
    hold on
    plot(mCDF2, eCDF2, 'k', 'LineWidth', 2)
    plot([0 1], [0 1] + ci2, '--k', 'LineWidth', 1)
    plot([0 1], [0 1] - ci2, '--k', 'LineWidth', 1)
    hold off
    xlabel('Model CDF')
    ylabel('Emirical CDF')
    xlim([0 1])
    ylim([0 1])
    title('Spike 2 KS Plot')
    set(gca, 'FontSize', 14)
    
    % a) There is rhythmic firing in the neurons (about 8 Hz) and spike 1 seems
    %    to precede spike 2.
    % b) The autocorrelation shows that there is a refractory period of a few
    %    milliseconds, followed by a period of increased correlation
    %    (indicating bursting), then nothing until roughly 130 milliseconds
    %    later. This shows neurons are bursting in roughly 8 Hz increments.
    % c) The stimulation frequency is roughly 8 Hz (the other peaks are due to
    %    fitting a sharp line at 8 Hz requires many sinusoids). There are also
    %    increases around 275 - 350 Hz, indicating the bursting is occuring at
    %    roughly those frequencies (corresponding to about 3 millisecond
    %    intervals between bursts).
    % d) The model fits the data decently well, especially given we don't know
    %    the driving stimulus and we only used about 25 time lags to fit 10000 
    %    data points. The model could be improved by including more time lags
    %    or by including an interaction term between the two spikes (we do see
    %    that spike 2 tends to follow spike 1). In terms of the frequency
    %    component, we do see that the only significant lags are those near 5
    %    milliseconds and those near 120 milliseconds or so. These correspond
    %    to the high frequency bursting in the plotted spikes and the time
    %    delay between bursts.
    
end