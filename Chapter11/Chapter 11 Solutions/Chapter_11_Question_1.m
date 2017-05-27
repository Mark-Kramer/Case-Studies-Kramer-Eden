function Chapter_11_Question_1()
    % Question 1 - Analyze Ch11-spikes-1.mat
    
    %Load Data 
    load('Ch11-spikes-LFP-1.mat')
    K = size(n, 1);
    N = size(n, 2);
    
    %Analyze Spike Trains w/ Chapter 8 Tools:
    %Visualize Data
    figure()
    imagesc(t, 1:K, n)
    colormap(1 - gray)
    axis xy
    xlabel('Time')
    ylabel('Trial')
    title('Raster of Spike Data')
    
    %Analyze Spike Trains w/ Chapter 8 Tools:
    %Get ISIs
    [spike_time_ind, spike_trial_ind] = find(transpose(n));
    spike_time = t(spike_time_ind);
    spike_ISI = diff(spike_time);
    spike_ISI = spike_ISI(find(spike_ISI > 0));
    time_bins = 0:.001:.5;
    counts = hist(spike_ISI, time_bins);
    %Visualize ISIs
    figure()
    bar(time_bins, counts)
    xlim([0 .08])
    xlabel('ISI (seconds)')
    ylabel('Count')
    title('ISI Histogram of Data')
    set(gca, 'FontSize', 14)
    
    %Analyze Spike Trains w/ Chapter 8 Tools:
    %Increment Process
    time_bins = 0.01:0.01:1;
    counts = hist(spike_time, time_bins)/K; %rate in spks/10 msec (.01 sec)
    counts = counts/10; %rate in spks/1 msec (.001 sec)
    counts = counts*1000; %rate in Hz
    %Visualize Increment Process w/ PSTH (Chapter 10)
    figure()
    bar(time_bins, counts)
    xlabel('Time (seconds')
    ylabel('Rate (Hz)')
    xlim([0 1])
    set(gca, 'FontSize', 14)
    
    %Analyze Spike Trains w/ Chapter 8 Tools:
    %Fano Factor
    increments = reshape(n', 1, []); %change trial matrix to continuous vector
    FF = var(increments) /mean(increments);
    N_FF = length(increments);
    FF_vals = 0.5:0.001:1.5;
    FF_probs = gampdf(FF_vals, (N_FF-1)/2, 2/(N_FF-1));
    %Visualze Fano Factor
    figure()
    hold on
    plot(FF_vals, FF_probs, 'k', 'LineWidth', 2)
    stem(FF, 70)
    hold off
    xlabel('Fano Factor')
    ylabel('Probability Density')
    legend({'Fano Factor PDF', 'Test Statistic FF'})
    set(gca, 'FontSize', 14)
    
    %Analyze Spike Trains w/ Chapter 8 Tools:
    %Autocorrelation
    [autocorr, lags] = xcorr(increments - mean(increments), 500, 'coeff');
    ci = 2/sqrt(length(autocorr));
    %Visualize Autocorrelation
    figure()
    hold on
    scatter(lags, autocorr, 10, 'k')
    line([-500 500], [ci ci])
    line([-500 500], [-ci -ci])
    hold off
    xlabel('Lag (ms)')
    ylabel('Autocorrelation')
    ylim([-0.1 0.1])
    set(gca, 'FontSize', 14)
    
    %Analyze Spike Trains w/ Chapter 8 Tools:
    %Autocorrelation of ISIs
    [autocorr, lags] = xcorr(spike_ISI - mean(spike_ISI), 20, 'coeff');
    ci = 2/sqrt(length(autocorr));
    %Visualize Autocorrelation of ISIs
    figure()
    hold on
    scatter(lags, autocorr, 10, 'k')
    line([-20 20], [ci ci])
    line([-20 20], [-ci -ci])
    hold off
    xlabel('Lag (ms)')
    ylabel('Autocorrelation')
    %ylim([-0.1 0.1])
    set(gca, 'FontSize', 14)
    
    %Analyze LFP w/ Chapter 2 Tools:
    %Visualize Data
    figure()
    imagesc(t, 1:K, y)
    axis xy
    xlabel('Time (seconds)')
    ylabel('Trial')
    title('Colormap Of LFP Data')
    set(gca, 'FontSize', 14)
    
    %Analyze LFP w/ Chapter 2 Tools:
    %Visualize Event-Related Potenial _+ S.E. Bars
    mn = mean(y, 1);
    sd = std(y, [], 1);
    sdmn = sd/sqrt(K);
    figure()
    hold on
    plot(t, mn, 'k', 'LineWidth', 1)
    plot(t, mn+1.96*sdmn, '--k', 'LineWidth', 1)
    plot(t, mn-1.96*sdmn, '--k', 'LineWidth', 1)
    hold off
    xlabel('Time (seconds)')
    ylabel('LFP (mV)')
    title('Average LFP')
    set(gca, 'FontSize', 14)
    
    % The spike trains show some frequency specific modulation (as seen in the
    % autocorrelation plot for the time lags). However, none of the bounds are
    % above the significance level.
    
    % The LFP analysis shows no evoked related potential (everything includes
    % zero in the 95% CI). 
    
    % This shows that analysis like correlation, averaging, and ERP's can
    % obscure or mask true relationships between spiking and LFP activity.
    % Further, they can even obfuscate changes in LFP or spike activity
    % themselves. Thus, it's always important to be critical of your analyses
    % and fully explore the data set before drawing conclusions from it.
    
end