function Chapter_6_Question_3()
    % Question 3 - Trial 1 Autocovariance Before/After Filters

    %Load Data
    load('Ch6-EEG-1.mat')
    x = EEG(1, :) - mean(EEG(1, :));
    T = t(end);
    N = length(t);
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    nyquist_freq = sample_freq/2;
    freq_resolution = 1/T;
    faxis = fftshift(-nyquist_freq:freq_resolution:nyquist_freq-freq_resolution);
    
    %Find Frequencies Near 60 Hz
    indices = find((abs(abs(single(faxis))-60)) <= 1);
    
    %Create And Apply Rectangular Filter
    rectangular_filter = ones(1, N);
    rectangular_filter(indices) = 0;
    xf = fft(x);
    xfnew = xf.*rectangular_filter;
    x_rect = ifft(xfnew);
    
    %Create And Apply FIR Filter
    n = 100;
    Wn = 30/nyquist_freq;
    b = transpose(fir1(n, Wn, 'low'));
    x_FIR = filtfilt(b, 1, x);
    
    %Visualize Data Before/After Filter(s)
    figure()
    hold on
    plot(t, x, 'k', 'LineWidth', 2)
    plot(t, x_rect, 'b', 'LineWidth', 2)
    plot(t, x_FIR, 'r', 'LineWidth', 2)
    hold off
    xlabel('Time (seconds)')
    ylabel('Data')
    legend({'Raw Data', 'Data + Rect Filter', 'Data + FIR Filter'})
    title('Data Before/After Filter(s)')
    set(gca, 'FontSize', 14)
    
    %Get Biased Autocovariance
    [x_autocov, lags] = xcorr(x, 200, 'biased');
    [x_rect_autocov, ~] = xcorr(x_rect, 200, 'biased');
    [x_FIR_autocov, ~] = xcorr(x_FIR, 200, 'biased');
    
    %Plot Biased Autocovariance
    figure()
    hold on
    plot(lags.*sample_interval, x_autocov, 'k', 'LineWidth', 2)
    plot(lags.*sample_interval, x_rect_autocov, 'b', 'LineWidth', 2)
    plot(lags.*sample_interval, x_FIR_autocov, 'r', 'LineWidth', 2)
    hold off
    xlabel('Time (seconds)')
    ylabel('Autocovariance')
    legend({'Raw Data', 'Data + Rect Filter', 'Data + FIR Filter'})
    title('Autocovariance Before/After Filter(s)')
    set(gca, 'FontSize', 14)
  
    % The raw data show obvious 60 Hz correlation, which is the noise we are
    % trying to get rid of. The rectangular-filtered data has massively reduced
    % this, but if you zoom in on the y-axis you can see minor fluctuations
    % that create a 60 Hz rhythm. However, it does pick up the roughly 20 Hz
    % rhythm that underlies the evoked response, since we see a few undulations
    % that occur once every 0.05 seconds or so (20 Hz). The FIR-filtered data
    % shows the same .05 undulations, but without the added small 60 Hz
    % fluctuations.
    
end