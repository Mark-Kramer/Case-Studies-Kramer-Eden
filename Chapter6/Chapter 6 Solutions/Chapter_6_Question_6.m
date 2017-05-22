function Chapter_6_Question_6()
    % Question 6 - Naive Rectangular Filter Phase Shift

    %Load the EEG data to define useful parameters.
    load('Ch6-EEG-1.mat') 
    x = EEG(1,:) - mean(EEG(1,:));
    sample_interval = t(2) - t(1);
    N = length(x);
    sample_freq = 1/sample_interval;
    nyquist_freq = sample_freq/2;
    freq_resolution = 1/(N*sample_interval);
    faxis = fftshift((-nyquist_freq:freq_resolution:nyquist_freq-freq_resolution));
    [~, isorted] = sort(faxis, 'descend');
    
    %Find Frequencies Near 60 Hz
    indices = find((abs(abs(single(faxis))-60)) <= 1);
    
    %Create Rectangular Filter
    rectangular_filter = ones(1, N);
    rectangular_filter(indices) = 0;

    %Create Low-Pass Filter
    n = 100;
    Wn = 30/nyquist_freq; 
    b = transpose(fir1(n, Wn, 'low'));
    
    %Get Phase Response Of Filters
    rectf = fft(rectangular_filter);
    bf = fft(b, N);
    
    %Visualize Phase Response of Filter
    figure()
    subplot(2, 1, 1)
    hold on
    plot(faxis(isorted), angle(rectf(isorted)), 'b', 'LineWidth', 2)
    plot(faxis(isorted), angle(bf(isorted)), 'r', 'LineWidth', 2)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Phase')
    xlim([-40 40])
    title('Phase Response of Filters')
    legend({'Rectangular Filter', 'FIR Filter'})
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    hold on
    plot(faxis(isorted), unwrap(angle(rectf(isorted))), 'b', 'LineWidth', 2)
    plot(faxis(isorted), unwrap(angle(bf(isorted))), 'r', 'LineWidth', 2)
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Phase')
    xlim([-40 40])
    title('Phase Response of Filters (unwrapped)')
    legend({'Rectangular Filter', 'FIR Filter'})
    set(gca, 'FontSize', 14)
    
end