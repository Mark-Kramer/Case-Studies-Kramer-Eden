function Chapter_4_Question_7()
    % Question 7 - Simulate Closely Related Signals
    
    %Simulate Data
    sample_interval = .001;
    sample_freq = 1/sample_interval;
    T = 1;
    t = sample_interval:sample_interval:T;
    sine_10_5_Hz = sin(2*pi*10.5.*t);
    sine_10_8_Hz = sin(2*pi*10.8.*t);
    data = sine_10_5_Hz + sine_10_8_Hz;
    
    %Manipulate Data w/ and w/o Zero Padding
    t_pad = sample_interval:sample_interval:(T + 19);
    zero_pad = zeros(1, 19*sample_freq);
    data_no_pad = data;
    data_with_pad = [data, zero_pad];
    
    %Visualize Data
    figure()
    subplot(2, 1, 1)
    plot(t, data_no_pad, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Two Sinusoids')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(t_pad, data_with_pad, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Two Sinusoids + Zero Pad')
    set(gca, 'FontSize', 14)

    %Compute Spectrum w/ and w/o Zero Padding
    [freq_axis, Sxx_no_pad] = ...
        Chapter_4_Calculate_Spectrum(data_no_pad, t);
    
    [freq_axis_zero_pad, Sxx_with_pad] = ...
        Chapter_4_Calculate_Spectrum(data_with_pad, t_pad);

    %Visualize Spectrum
    figure()
    subplot(2, 1, 1)
    plot(freq_axis, 10*log10(Sxx_no_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Two Sinusoids')
    xlim([9 12])
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(freq_axis_zero_pad, 10*log10(Sxx_with_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Two Sinusoids + Zero Pad')
    set(gca, 'FontSize', 14)
    xlim([9 12])
     
    %Compute Needed T To Resolve 0.3 Hz Difference
    %   freq_resolution = 1/T = 0.3 Hz;
    %   needed_T = 1/freq_resolution = 1/0.3 Hz;
    % note: feel free to modify the below T's to whatever you would like,
    % the rest of the code should work
    needed_T = 1/0.3;
    shorter_T = 1/0.5;
    longer_T = 1/0.1;
    
    %Simulate Data
    [needed_t, needed_t_pad, needed_T_data, needed_T_data_pad] = ...
        Chapter_4_Model_Sine_Data(needed_T, sample_interval);
    
    [shorter_t, shorter_t_pad, shorter_T_data, shorter_T_data_pad] = ...
        Chapter_4_Model_Sine_Data(shorter_T, sample_interval);
    
    [longer_t, longer_t_pad, longer_T_data, longer_T_data_pad] = ...
        Chapter_4_Model_Sine_Data(longer_T, sample_interval);
    
    %Compute Spectrum w/ and w/o Zero Padding
    [f_needed_T, Sxx_needed_T] = ...
        Chapter_4_Calculate_Spectrum(needed_T_data, needed_t);
    
    [f_needed_T_pad, Sxx_needed_T_pad] = ...
        Chapter_4_Calculate_Spectrum(needed_T_data_pad, needed_t_pad);

    [f_shorter_T, Sxx_shorter_T] = ...
        Chapter_4_Calculate_Spectrum(shorter_T_data, shorter_t);
    
    [f_shorter_T_pad, Sxx_shorter_T_pad] = ...
        Chapter_4_Calculate_Spectrum(shorter_T_data_pad, shorter_t_pad);
    
    [f_longer_T, Sxx_longer_T] = ...
        Chapter_4_Calculate_Spectrum(longer_T_data, longer_t);
    
    [f_longer_T_pad, Sxx_longer_T_pad] = ...
        Chapter_4_Calculate_Spectrum(longer_T_data_pad, longer_t_pad);
    
    %Visualize Spectrum
    figure()
    subplot(2, 3, 1)
    plot(f_needed_T, 10*log10(Sxx_needed_T), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title(['Two Sinusoids using T = ', num2str(needed_T)])
    xlim([9 12])
    ylim([-40 10])
    set(gca, 'FontSize', 14)
    subplot(2, 3, 4)
    plot(f_needed_T_pad, 10*log10(Sxx_needed_T_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title(['Two Sinusoids + Zero Pad using T = ', num2str(needed_T)])
    xlim([9 12])
    ylim([-40 10])
    set(gca, 'FontSize', 14)

    subplot(2, 3, 2)
    plot(f_shorter_T, 10*log10(Sxx_shorter_T), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title(['Two Sinusoids using T = ', num2str(shorter_T)])
    xlim([9 12])
    ylim([-40 10])
    set(gca, 'FontSize', 14)
    subplot(2, 3, 5)
    plot(f_shorter_T_pad, 10*log10(Sxx_shorter_T_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title(['Two Sinusoids + Zero Pad using T = ', num2str(shorter_T)])
    xlim([9 12])
    ylim([-40 10])
    set(gca, 'FontSize', 14)
    
    subplot(2, 3, 3)
    plot(f_longer_T, 10*log10(Sxx_longer_T), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title(['Two Sinusoids using T = ', num2str(longer_T)])
    xlim([9 12])
    ylim([-40 10])
    set(gca, 'FontSize', 14)
    subplot(2, 3, 6)
    plot(f_longer_T_pad, 10*log10(Sxx_longer_T_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title(['Two Sinusoids + Zero Pad using T = ', num2str(longer_T)])
    xlim([9 12])
    ylim([-40 10])
    set(gca, 'FontSize', 14)
    
    % You can see that zero-padding helps smooth out our spectrum (compare the
    % bottom and top rows). However, no amount of zeros will help the shorter
    % duration of data resolve the two frequencies. We can see the putative
    % lowest needed duration (1/0.3) requires the zero-padding to see the two
    % peaks, but just barely. Using much more data (in terms of duration, not
    % zero-padding) as seen on the right makes the peaks resolve neatly even
    % without zero-padding.
    
end