function Chapter_7_Resample_CFC(Vlo, Vhi)
    %INPUT:
    %   Vlo: low pass filtered data
    %   Vhi: high pass filtered data
    
    %Enforce Row Vector
    Vlo = Vlo(:)';
    Vhi = Vhi(:)';
    
    %Get Hilbert Transform of Data
    phi = angle(hilbert(Vlo));
    amp = abs(hilbert(Vhi));
    
    %Get Phase Amplitude Data
    p_bins = -pi:0.1:pi;
    num_bins = length(p_bins) - 1;
    a_mean = zeros(num_bins, 1);
    p_mean = zeros(num_bins, 1);
    for k = 1:num_bins
        pL = p_bins(k); %lower phase limit
        pR = p_bins(k+1); %upper phase limit
        indices = find(phi >= pL & phi < pR);
        a_mean(k) = mean(amp(indices));
        p_mean(k) = mean([pL pR]);
    end
    
    %Visualize CFC
    figure()
    plot(p_mean, a_mean, 'b', 'LineWidth', 2)
    xlabel('Low-Frequency Phase (Radians)')
    ylabel('High Frequency Amplitude')
    title('CFC')
    xlim([-3 3])
    set(gca, 'FontSize', 14)
    
    %Compute Test Statistic
    h = max(a_mean) - min(a_mean);
    
    %Generate Null Hypothesis Statistic Distribution
    n_surrogates = 1000;
    hS = zeros(n_surrogates, 1);
    for ns = 1:n_surrogates
        ampS = amp(randperm(length(amp))); %sample withOUT replacement
        p_bins = -pi:0.1:pi;
        num_bins = length(p_bins) - 1;
        a_mean = zeros(num_bins, 1);
        p_mean = zeros(num_bins, 1);
        for k = 1:num_bins
            pL = p_bins(k); %lower phase limit
            pR = p_bins(k+1); %upper phase limit
            indices = find(phi >= pL & phi < pR);
            a_mean(k) = mean(ampS(indices));
            p_mean(k) = mean([pL pR]);
        end
        hS(ns) = max(a_mean) - min(a_mean); %store
    end
    
    %Visualize Statistics
    figure()
    hold on
    histogram(hS)
    stem(h, 100)
    hold off
    xlabel('Statistic')
    ylabel('Num in Bin')
    title('Distribution of Statistics for Null Hypoethesis')
    set(gca, 'FontSize', 14)
    
    %Get p-value
    p = length(find(hS > h)) / length(hS);
    
end