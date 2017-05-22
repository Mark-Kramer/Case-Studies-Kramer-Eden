function Chapter_6_Question_8()
    % Question 8 - Two Low Pass Filters

    %Construct Impulse
    N = 1000;
    impulse = zeros(1, N);
    impulse(N/2) = 1;
    sample_interval = .001;
    t = sample_interval:sample_interval:1;
    T = t(end);
    sample_freq = 1/sample_interval;
    nyquist_freq = sample_freq/2;
    freq_resolution = 1/T;
    faxis = fftshift((-nyquist_freq:freq_resolution:nyquist_freq-freq_resolution));
    [~, isorted] = sort(faxis, 'descend');
    
    %Create Low-Pass Filter
    n = 100;
    Wn = 30/nyquist_freq; 
    b = transpose(fir1(n, Wn, 'low'));
    
    %Apply Single and Double Filter
    impulse_response_t = filter(b, 1, impulse);
    impulse_response_2t = filter(b, 1, filter(b, 1, impulse));
   
    %Fourier Transform Impulse Response
    bf = fft(impulse_response_t);
    bbf = fft(impulse_response_2t);
    mag = bf.*conj(bf);
    phi = angle(bf);
    mag2 = bbf.*conj(bbf);
    phi2 = angle(bbf);
    
    %Visualize Impulse Response, Magnitude, and Phase
    figure()
    subplot(3, 1, 1)
    hold on
    plot(t, impulse_response_t, 'k', 'LineWidth', 2)
    plot(t, impulse_response_2t, 'b', 'LineWidth', 2)
    hold off
    xlabel('Time (seconds)')
    title('Impulse Response')
    legend({'Single Filter', 'Double Filter'})
    set(gca, 'FontSize', 14)
    subplot(3, 1, 2)
    hold on
    plot(faxis(isorted), mag(isorted), 'k', 'LineWidth', 2)
    plot(faxis(isorted), mag2(isorted), 'b', 'LineWidth', 2)
    hold off
    xlabel('Frequency (Hz)')
    title('Magnitude Response')
    legend({'Single Filter', 'Double Filter'})
    xlim([-40 40])
    set(gca, 'FontSize', 14)
    subplot(3, 1, 3)
    hold on
    plot(faxis(isorted), phi(isorted), 'k', 'LineWidth', 2)
    plot(faxis(isorted), phi2(isorted), 'b', 'LineWidth', 2)
    hold off
    xlabel('Frequency (Hz)')
    title('Phase Response')
    legend({'Single Filter', 'Double Filter'})
    xlim([-40 40])
    set(gca, 'FontSize', 14)
   
    % The impulse response: applying the filter twice causes the time shift to
    % be exacerbated/doubled.
    
    % The magnitude response: applying the filter twice causes the magnitude to
    % be reduced further. This is because if the filter at a given frequency is
    % 0.5, then applying it twice causes it to be 0.5*0.5 or 0.25.
    
    % The phase response: applying the filter twice causes the phase response
    % to be incredibly complex, likely because changes are being applied twice
    % as in the magnitude response.
    
end