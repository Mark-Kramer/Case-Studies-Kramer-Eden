function Chapter_6_Question_2()
    % Question 2 - Explore Hanning Filters

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
    
    %Find Indices For +/- 60 Hz
    ind = find((abs(abs(single(faxis))-60)) <= 0.1*freq_resolution);
    
    %Describe Three Hann Filters (in Frequency Domain)
    win1 = 7;
    win2 = 15;
    win3 = 30;
    hann_filter1 = ones(1, N);
    hann_filter1(ind(1)-win1:ind(1)+win1) = 1-transpose(hann(2*win1+1));
    hann_filter1(ind(2)-win1:ind(2)+win1) = 1-transpose(hann(2*win1+1));
    hann_filter2 = ones(1, N);
    hann_filter2(ind(1)-win2:ind(1)+win2) = 1-transpose(hann(2*win2+1));
    hann_filter2(ind(2)-win2:ind(2)+win2) = 1-transpose(hann(2*win2+1));
    hann_filter3 = ones(1, N);
    hann_filter3(ind(1)-win3:ind(1)+win3) = 1-transpose(hann(2*win3+1));
    hann_filter3(ind(2)-win3:ind(2)+win3) = 1-transpose(hann(2*win3+1));
    
    %Get Time Domain Hann Filters
    lag_axis = (-N/2+1:N/2)*sample_interval;
    impulse = zeros(1, N);
    impulse(N/2) = 1;
    i_hann_filter1 = ifft(hann_filter1);
    i_hann_filter2 = ifft(hann_filter2);
    i_hann_filter3 = ifft(hann_filter3);
    impulse_response_t1 = zeros(N, 1);
    impulse_response_t2 = zeros(N, 1);
    impulse_response_t3 = zeros(N, 1);
    for i = 1:N
        impulse_response_t1(i) = sum(circshift(i_hann_filter1, [1, i-1]).*impulse);
        impulse_response_t2(i) = sum(circshift(i_hann_filter2, [1, i-1]).*impulse);
        impulse_response_t3(i) = sum(circshift(i_hann_filter3, [1, i-1]).*impulse);
    end
    
    %Visualize Frequency and Time Domain of Filters
    figure()
    subplot(2, 1, 1)
    hold on
    plot(faxis, hann_filter1, 'b', 'LineWidth', 2)
    plot(faxis, hann_filter2, 'g', 'LineWidth', 2)
    plot(faxis, hann_filter3, 'r', 'LineWidth', 2)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    xlim([-80 80])
    ylim([0 1])
    legend({'Win = 7', 'Win = 15', 'Win = 30'})
    title('Fourier Representation of Hanning Filter')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    hold on
    plot(lag_axis, impulse_response_t1, 'b', 'LineWidth', 2)
    plot(lag_axis, impulse_response_t2, 'g', 'LineWidth', 2)
    plot(lag_axis, impulse_response_t3, 'r', 'LineWidth', 2)
    hold off
    xlabel('Time (Seconds)')
    ylabel('Impulse Response')
    xlim([-0.5 0.5])
    ylim([-.03 .03])
    legend({'Win = 7', 'Win = 15', 'Win = 30'})
    title('Time Representation of Hanning Filter')
    set(gca, 'FontSize', 14)
    
    % In the frequency domain, increasing the width of the window causes more
    % frequencies to be affected by the filter. More specifically, the filter
    % more gradually changes from 0 to 1 and vice versa. In the time domain,
    % this causes an increase in the precision with which the filter works.
    % Larger windows are tightly centered around the impulse, whereas small
    % windows extend over more time.
    
end