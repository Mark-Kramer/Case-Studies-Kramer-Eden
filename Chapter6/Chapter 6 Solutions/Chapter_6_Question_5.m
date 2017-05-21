function Chapter_6_Question_5()
    % Question 5 - Bandstop FIR Filter

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

    %Create Bandstop Filter (eliminate 50 to 70 Hz)
    n = 100;
    Wn = [50/nyquist_freq, 70/nyquist_freq]; 
    b = transpose(fir1(n, Wn, 'stop'));
    
    %Fourier Transform Bandstop Filter
    bf = fft(b, N);
    Mb = bf.*conj(bf);
    
    %Visualize Fourier Transform of Bandstop Filter
    figure()
    plot(faxis(isorted), Mb(isorted), 'b', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    title('FFT of Bandstop FIR Filter')
    xlim([-100, 100])
    set(gca, 'FontSize', 14)
    
    %Filter Data
    xnew = filtfilt(b, 1, x);
    
    %Visualize Data Before/After Filter
    figure()
    subplot(2, 1, 1)
    plot(t, x, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Raw Data')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(t, xnew, 'b', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Data after Bandstop Filter')
    set(gca, 'FontSize', 14)
    
end