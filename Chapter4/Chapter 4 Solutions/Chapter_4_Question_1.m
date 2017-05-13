function Chapter_4_Question_1()
    % Question 1 - Windows and Tapers on Pure Waves
    
    %Generate 1 second of a 10 Hz Sine Wave
    sample_interval = .001; %corresponds to 1000 Hz sampling frequency
    t = sample_interval:sample_interval:1;
    data = sin(2*pi*10.*t);
    
    %Visualize
    figure()
    plot(t, data, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('10 Hz Sine Wave For 1 Second')
    set(gca, 'FontSize', 14)
    
    %Manipulate Data for Further Spectrum Plots
    t_zero_pad = sample_interval:sample_interval:11; 
    zero_pad = zeros(1, 10/sample_interval);
    hann_taper = hann(length(data))';
    rectangle_taper_no_pad = data;
    rectangle_taper_with_pad = [data, zero_pad];
    hanning_taper_no_pad = data.*hann_taper;
    hanning_taper_with_pad = [data.*hann_taper, zero_pad]; %note how you taper before padding  
    
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
    
    %Plot Spectrum
    figure()
    subplot(2, 2, 1)
    plot(freq_axis, 10*log10(Sxx_rectangle_taper_no_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Rectangular Taper; No Padding')
    xlim([0 60])
    set(gca, 'FontSize', 14)
    subplot(2, 2, 2)
    plot(freq_axis_zero_pad, 10*log10(Sxx_rectangle_taper_with_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Rectangular Taper; With Padding')
    set(gca, 'FontSize', 14)
    xlim([0 60])
    subplot(2, 2, 3)
    plot(freq_axis, 10*log10(Sxx_hanning_taper_no_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Hanning Taper; No Padding')
    set(gca, 'FontSize', 14)
    xlim([0 60])
    subplot(2, 2, 4)
    plot(freq_axis_zero_pad, 10*log10(Sxx_hanning_taper_with_pad), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Hanning Taper; With Padding')
    xlim([0 60])
    set(gca, 'FontSize', 14)
    
    % In the case of a pure sinusoid, with a rectangular taper and no padding, 
    % we do see that there is a clear peak frequency at 10 Hz. This corresponds
    % to figure 4.9b in the book. If we use a Hanning taper with no padding,
    % there is still a clear peak frequency, but the spectrum smooths out
    % across various frequencies. When we add zeros after the rectangular taper,
    % the frequency analysis becomes polluted with a series of high frequency
    % waves. This is because they have to fit the sharp transition from sine
    % wave to zero. When we add zeros after the hanning taper, we also see the
    % pollution with high frequency waves. However, the peak is much more
    % clear. Normally this would mean we prefer rectangular tapers and no
    % zero-padding, since that is the best representation of our data. However, 
    % but neural data is rarely, if ever, a pure wave (or collection of pure
    % waves). As we will see in subsequent examples, tapers and zero padding
    % are good when the underlying signal is a bit noisy.
    
    % Side note: Why does our pure sine wave analysis not give the noisy 4.4b
    % picture seen in the book? This is because our sine wave is NOT the data
    % used to generate the book's figure. If you look closely, you can see that
    % the figure's data is created by a series of zeros, then the sine wave,
    % then a series of zeros. I show this below.
    
    %Get "Infinite" Data and Compare to "Finite" Data
    t_note = sample_interval:sample_interval:10;
    inf_sine = sin(2*pi*10.*t_note);
    fin_sine = inf_sine;
    fin_sine(1:4000) = 0; %change first 4 seconds to zero
    fin_sine(6001:end) = 0; %change last 4 seconds to zero
    
    %Visualize
    figure()
    subplot(2, 1, 1)
    plot(t_note, inf_sine, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('"Infinite" 10 Hz Sine Wave')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(t_note, fin_sine, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('"Finite" 10 Hz Sine Wave')
    set(gca, 'FontSize', 14)

    %Fourier Transform Both
    [freq_axis_inf, Sxx_inf] = ...
        Chapter_4_Calculate_Spectrum(inf_sine, t_note);
    [freq_axis_fin, Sxx_fin] = ...
        Chapter_4_Calculate_Spectrum(fin_sine, t_note);
    
    %Visualize Spectral Analsis
    figure()
    subplot(2, 1, 1)
    plot(freq_axis_inf, 10*log10(Sxx_inf), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('"Infinite" 10 Hz Sine Wave')
    xlim([0 60])
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(freq_axis_fin, 10*log10(Sxx_fin), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('"Finite" 10 Hz Sine Wave')
    xlim([0 60])
    set(gca, 'FontSize', 14)
    
    % Side note (cont): So why do we use the rectangular taper (or any taper),
    % not to mention zero padding if it messses with our pure data (the 
    % "Infinite" sinusoid)? Namely it's because our actual FFT (using real EEG,
    % ECoG, or LFP data) is not going to give us a nice signal that decomposes
    % into pure tones. Rather, it's going to give us a lot of noisy estimates.
    % For instance, look at 4.2b; are those peaks near 10 Hz real peaks? Zero
    % padding and tapering are various ways to help resolve noisy estimates of
    % the frequency decomposition of our signal. While they add their own
    % confounds, careful multitaper analysis can help eliminate some of them.
    % Carefully reread the book section "By Doing Nothing, We're Doing
    % Something: The Rectangular Taper" to understand why just putting in only
    % our data (without putting zeros on the tails as I have in the "Finite"
    % data) is slightly dishonest in terms of analyzing the ongoing 
    % oscillations of our brain.
    
end

