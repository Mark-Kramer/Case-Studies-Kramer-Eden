function Chapter_4_Analyze_EEG(EEG, t)
    %INPUT:
    %   EEG: vector of EEG data
    %   t: vector of within trial timestamps
    
    %Calculate Zero Pad and Tapers
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    zero_pad = zeros(1, 10*sample_freq);
    t_zero_pad = sample_interval:sample_interval:t(end)+10; 
    hann_taper = hann(length(EEG))';
    
    %Manipulate Data In Accordance With Question
    rectangle_taper_no_pad = EEG';
    rectangle_taper_with_pad = [EEG', zero_pad];
    hanning_taper_no_pad = EEG'.*hann_taper;
    hanning_taper_with_pad = [EEG'.*hann_taper, zero_pad];

    %Visualize New Data
    figure()
    subplot(2, 2, 1)
    plot(t, rectangle_taper_no_pad, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Rectangular Taper; No Padding')
    set(gca, 'FontSize', 14)
    subplot(2, 2, 2)
    plot(t_zero_pad, rectangle_taper_with_pad, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Rectangular Taper; With Padding')
    set(gca, 'FontSize', 14)
    subplot(2, 2, 3)
    plot(t, hanning_taper_no_pad, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Hanning Taper; No Padding')
    set(gca, 'FontSize', 14)
    subplot(2, 2, 4)
    plot(t_zero_pad, hanning_taper_with_pad, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Hanning Taper; With Padding')
    set(gca, 'FontSize', 14)
    
    %Compute Fourier Transforms for Data
    [freq_axis, Sxx_rectangle_taper_no_pad] = ...
        Chapter_4_Calculate_Spectrum(rectangle_taper_no_pad, t);

    [freq_axis_zero_pad, Sxx_rectangle_taper_with_pad] = ...
        Chapter_4_Calculate_Spectrum(rectangle_taper_with_pad, t_zero_pad);
    
    [~, Sxx_hanning_taper_no_pad] = ...
        Chapter_4_Calculate_Spectrum(hanning_taper_no_pad, t);

    [~, Sxx_hanning_taper_with_pad] = ...
        Chapter_4_Calculate_Spectrum(hanning_taper_with_pad, t_zero_pad);
        
    [Sxx_TW2_no_pad, ~] = ...
        pmtm(rectangle_taper_no_pad, 2, length(rectangle_taper_no_pad), sample_freq); 

    [Sxx_TW2_with_pad, ~] = ...
        pmtm(rectangle_taper_with_pad, 2, length(rectangle_taper_with_pad), sample_freq); 
    
    [Sxx_TW10_no_pad, ~] = ...
        pmtm(rectangle_taper_no_pad, 10, length(rectangle_taper_no_pad), sample_freq); 

    [Sxx_TW10_with_pad, ~] = ...
        pmtm(rectangle_taper_with_pad, 10, length(rectangle_taper_with_pad), sample_freq); 
     
    
    %Plot Rectangular and Hanning Spectrum Estimates From Above
    figure()
    subplot(2, 2, 1)
    plot(freq_axis, 10*log10(Sxx_rectangle_taper_no_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Rectangular Taper; No Padding')
    xlim([0 120])
    set(gca, 'FontSize', 14)
    subplot(2, 2, 2)
    plot(freq_axis_zero_pad, 10*log10(Sxx_rectangle_taper_with_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Rectangular Taper; With Padding')
    set(gca, 'FontSize', 14)
    xlim([0 120])
    subplot(2, 2, 3)
    plot(freq_axis, 10*log10(Sxx_hanning_taper_no_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Hanning Taper; No Padding')
    set(gca, 'FontSize', 14)
    xlim([0 120])
    subplot(2, 2, 4)
    plot(freq_axis_zero_pad, 10*log10(Sxx_hanning_taper_with_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Hanning Taper; With Padding')
    xlim([0 120])
    set(gca, 'FontSize', 14)
    
    %Plot Multitaper Spectrum Estimates From Above
    figure()
    subplot(2, 2, 1)
    plot(freq_axis, 10*log10(Sxx_TW2_no_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Multitaper Bandwidth 2; No Padding')
    xlim([0 120])
    set(gca, 'FontSize', 14)
    subplot(2, 2, 2)
    plot(freq_axis_zero_pad, 10*log10(Sxx_TW2_with_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Multitaper Bandwidth 2; With Padding')
    set(gca, 'FontSize', 14)
    xlim([0 120])
    subplot(2, 2, 3)
    plot(freq_axis, 10*log10(Sxx_TW10_no_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Multitaper Bandwidth 10; No Padding')
    set(gca, 'FontSize', 14)
    xlim([0 120])
    subplot(2, 2, 4)
    plot(freq_axis_zero_pad, 10*log10(Sxx_TW10_with_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Multitaper Bandwidth 10; With Padding')
    xlim([0 120])
    set(gca, 'FontSize', 14)
    
end