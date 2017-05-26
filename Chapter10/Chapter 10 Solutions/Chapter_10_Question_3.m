function Chapter_10_Question_3()
    % Question 3 - Explore Spectral Decomposition of Simulated Spike Train
    
    %Create 100 Hz Spike for 10 seconds
    sample_interval = .001;
    lambda = 100/1000; %spike rate in milliseconds
    T = 10;
    t = sample_interval:sample_interval:T;
    fake_spikes = poissrnd(lambda, 1, length(t));
    spike_times = t(fake_spikes == 1);
    
    %Remove Spikes Within 10 msec of Another Spike
    downsample_spike_times = spike_times(1);
    i = 1;
    k = 1;
    while k < length(spike_times)
        if (spike_times(k) - downsample_spike_times(i)) > .01
           downsample_spike_times(i+1) = spike_times(k);
           i = i + 1;
        end
        k = k + 1;
    end
    fake_downsample_spikes = zeros(1, length(fake_spikes));
    [~, time_inds] = min(abs(t - downsample_spike_times'), [], 2);
    fake_downsample_spikes(time_inds) = 1;
    
    %Visualize Fake Data
    figure()
    subplot(2, 1, 1)
    plot(spike_times, ones(1, length(spike_times)), '.k', 'MarkerSize', 2)
    xlabel('Time (seconds)')
    ylabel('Raster')
    title('Fake Data')
    ylim([0 2])
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(spike_times, ones(1, length(spike_times)), '.k', 'MarkerSize', 10)
    xlabel('Time (seconds)')
    ylabel('Raster')
    title('Fake Data')
    ylim([0 2])
    xlim([0 1])
    set(gca, 'FontSize', 14)
    
    %Visualize Downsampled Fake Data
    figure()
    subplot(2, 1, 1)
    plot(downsample_spike_times, ones(1, length(downsample_spike_times)), '.k', 'MarkerSize', 2)
    xlabel('Time (seconds)')
    ylabel('Raster')
    title('Fake Data (Downsample)')
    ylim([0 2])
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(downsample_spike_times, ones(1, length(downsample_spike_times)), '.k', 'MarkerSize', 10)
    xlabel('Time (seconds)')
    ylabel('Raster')
    title('Fake Data (Downsample)')
    ylim([0 2])
    xlim([0 1])
    set(gca, 'FontSize', 14)
    
    %Get Spectrums
    TW = 4;
    ntapers = 2*TW - 1;
    params.Fs = 1000;
    params.tapers = [TW ntapers];
    params.fpass = [0 500];
    [spike_S, f] = mtspectrumpb(fake_spikes, params);
    [downsample_spike_S, f] = mtspectrumpb(fake_downsample_spikes, params);
  
    %Visualize Spectrum
    figure()
    subplot(2, 1, 1)
    plot(f, spike_S, 'k', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (Hz)')
    title('Spectrum of Homogeneous Poisson Process')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(f, downsample_spike_S, 'k', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (Hz)')
    title('Spectrum of Downsampled Poisson Process')
    set(gca, 'FontSize', 14)
    
    % The theoretical poisson process has a nice flat spectral decomposition,
    % in line with what we learned this chapter. However, when we remove
    % anything within 10 msec, we are explicitly creating a refractory period
    % where spiking cannot occur. This refractory period is seen as a decrease
    % in power in the lower frequency.
    
end