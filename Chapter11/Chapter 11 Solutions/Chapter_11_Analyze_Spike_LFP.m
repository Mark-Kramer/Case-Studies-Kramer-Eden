function Chapter_11_Analyze_Spike_LFP(n, y, t)
    %INPUT:
    %   n: 0/1 spike data where rows are trials and columns are timestamps
    %   y: LFP data (mV) where rows are trials and columns are timestamps
    %   t: timestamp vector
    
    %Get Useful Measures
    K = size(n, 1);
    N = length(t);
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    nyquist_freq = sample_freq/2;
    
    %Visualize LFP and Spike Data
    figure()
    subplot(2, 2, 1)
    imagesc(t, 1:K, n)
    colormap(1-gray)
    axis xy
    xlabel('Time (seconds)')
    ylabel('Trial')
    title('Spike Data')
    set(gca, 'FontSize', 14)
    subplot(2, 2, 2)
    imagesc(t, 1:K, y)
    colorbar
    axis xy
    xlabel('Time (seconds)')
    ylabel('Trial')
    title('LFP Data')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    hold on
    plot(t, y(1, :), 'k', 'LineWidth', 2)
    plot(t, n(1, :), 'r', 'LineWidth', 1)
    hold off
    xlabel('Time (seconds)')
    ylabel('LFP (mV) and Spike')
    title('LFP and Spike Data Trial 1')
    set(gca, 'FontSize', 14)
    
    %Get Spectrum
    TW = 3;
    ntapers = 2*TW - 1;
    params.Fs = sample_freq;
    params.tapers = [TW ntapers];
    params.pad = -1;
    params.trialave = 1;
    [C, ~, ~, Syy, Snn, f] = coherencycpb(transpose(y), transpose(n), params);
    
    %Visualize Spectrum
    figure()
    subplot(1, 2, 1)
    plot(f, Snn, 'k', 'LineWidth', 2)
    xlim([0 120])
    xlabel('Frequency')
    ylabel('Power (Hz)')
    title('Snn')
    set(gca, 'FontSize', 14)
    subplot(1, 2, 2)
    plot(f, 10*log10(Syy), 'k', 'LineWidth', 2)
    xlim([0 120])
    xlabel('Frequency')
    ylabel('Power (Hz)')
    title('Syy')
    set(gca, 'FontSize', 14)
    
    %Compute Spike-Triggered Average
    win = 100;
    STA = zeros(K, 2*win+1);
    for k = 1:K
        spks = find(n(k, :) == 1);
        for i = 1:length(spks)
            if (spks(i) > win & spks(i) + win < N)
                STA(k, :) = STA(k, :) + y(k, spks(i) - win:spks(i) + win)/length(spks);
            end
        end
    end
    
    %Visualize Spike-Triggered Average
    figure()
    plot(-100:100, mean(STA, 1), 'k', 'LineWidth', 2)
    xlabel('Time (milliseconds)')
    ylabel('Voltage (mV)')
    title('Spike-Triggered Average')
    set(gca, 'FontSize', 14)
    
    %Compute Field Triggered Average
    Wn = [8 12]/nyquist_freq;
    ord = 100;
    b = fir1(ord, Wn);
    FTA = zeros(K, N);
    for k = 1:K
        Vlo = filtfilt(b, 1, y(k, :));
        phi = angle(hilbert(Vlo));
        [~, indices] = sort(phi);
        FTA(k, :) = n(k, indices);
    end
    
    %Visualize Field Triggered Average
    figure()
    plot(linspace(-pi, pi, N), mean(FTA, 1), 'k', 'LineWidth', 2)
    xlabel('Phase')
    ylabel('FTA')
    title('FTA of Spikes Using 9-11 Hz Filter')
    xlim([-pi pi])
    ylim([0 0.3])
    set(gca, 'FontSize', 14)
    
    %Visualize Coherence (gotten way above in Get Spectrum)
    figure()
    plot(f, C, 'k', 'LineWidth', 2)
    xlim([0 120])
    xlabel('Frequency')
    ylabel('Coherence')
    title('Coherence')
    set(gca, 'FontSize', 14)
    
    %Fit GLM (11.5) To The Data
    phi = zeros(K, N);
    for k = 1:K
        Vlo = filtfilt(b, 1, y(k, :));
        phi(k, :) = angle(hilbert(Vlo));
    end
    phi_vec = transpose(reshape(phi', 1, []));
    Y = transpose(reshape(n', 1, []));
    X = [cos(phi_vec) sin(phi_vec)];
    [b1, dev1, stats1] = glmfit(X, Y, 'poisson', 'log');
    
    %Calculate Firing Rate
    phi0 = transpose(-pi:0.01:pi);
    X0 = [cos(phi0) sin(phi0)];
    [y0, dylo, dyhi] = glmval(b1, X0, 'log', stats1);
    
    %Visualize Firing Rate
    figure()
    hold on
    plot(phi0, y0, 'k', 'LineWidth', 2)
    plot(phi0, y0+dyhi, '--k', 'LineWidth', 2)
    plot(phi0, y0-dylo, '--k', 'LineWidth', 2)
    hold off
    xlabel('Phase')
    ylabel('Probability of Spike')
    title('GLM Model')
    set(gca, 'FontSize', 14)
    
end