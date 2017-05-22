function Chapter_6_Question_1()
    % Question 1 - Analyze Ch6-EEG-2.mat

    %Load Data
    load('Ch6-EEG-2.mat')
    x = EEG - mean(EEG);
    T = t(end);
    N = length(t);
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    nyquist_freq = sample_freq/2;
    freq_resolution = 1/T;
    faxis = 0:freq_resolution:nyquist_freq;
    
    %Visualize Data
    figure()
    plot(t, x, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Single Trial EEG Data')
    set(gca, 'FontSize', 14)
    
    %Get Fourier Transform of Data
    xf = fft(x);
    Sxx = 2*sample_interval^2/T * (xf.*conj(xf));
    Sxx = Sxx(1:N/2+1); %ignore negative freqs
    Sxx(1) = 0; %set DC freq to zero power to correct for MATLAB rounding
    
    %Plot Fourier Transform of Data
    figure()
    plot(faxis, 10*log10(Sxx), 'r', 'LineWidth', 2)
    xlim([0 80])
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Fourier Transform Of EEG Data')
    set(gca, 'FontSize', 14)
    
    %Construct a Low Pass Filter for +/- 20 Hz.
    n = 100;
    Wn = 20/nyquist_freq;
    b = transpose(fir1(n, Wn, 'low'));
    
    %Fourier Transform Filter
    bf = fft(b, N);
    Mb = bf.*conj(bf);
    faxis_filter = fftshift((-nyquist_freq:freq_resolution:nyquist_freq-freq_resolution));
    [~, isorted] = sort(faxis_filter, 'descend');
    
    %Visualize FFT of FIR Filter
    figure()
    plot(faxis_filter(isorted), Mb(isorted), 'b', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    title('FFT of FIR Filter')
    xlim([-30, 30])
    set(gca, 'FontSize', 14)
    
    %Apply FIR Filter
    xnew = filtfilt(b, 1, x);
    
    %Get Spectrum of New Data
    xfnew = fft(xnew);
    Sxxnew = 2*sample_interval^2/T * (xfnew.*conj(xfnew));
    Sxxnew = Sxxnew(1:N/2+1); %ignore negative frequencies
    Sxxnew(1) = 0; %set DC freq to zero power to correct for MATLAB rounding
    
    %Visualize New Data
    figure()
    subplot(2, 1, 1)
    plot(t, xnew, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Filtered Data')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(faxis, 10*log10(Sxxnew), 'r', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    xlim([0 80])
    title('Filtered EEG Data FFT')
    set(gca, 'FontSize', 14)
    
    % a) Unfortunately the data appears to be a bit too noisy for me to make
    % out any structure in the data. Thus, I can't observe any clear rhythms. 
    
    % b) The fourier transform shows a lot of flucutating noise/power in the
    % frequencies greater than 20 Hz, but there is no clear peak. While there
    % is a peak at 10 Hz, this rhythm is not visible in the EEG data. Thus, it
    % seems like the EEG contains a plethora of frequencies above 20 or 30 Hz,
    % but none seem to jump out, indicating that they might all just be white
    % noise. That lone 10 Hz peak is what we will focus on, since we are
    % assuming nothing neural would create power in all frequencies above 20 to
    % 30 Hz in such a way as seen here.
    
    % c) We construct a low pass filter to isolate the frequencies +/- 20 Hz.
    % This will eliminate the higher frequency (seemingly) white noise and
    % leave us with our 10 Hz sinusoid. After creating the filter, we visualize
    % it in the frequency domain to ensure it's doing what we expect. Then, we
    % use built-in MATLAB functions to apply the filter and create filtered EEG
    % data. Then we Fourier Transform the filtered data to clearly see the 10
    % Hz sinusoid that makes up our signal. The sinusoid is also clearly
    % visible in the filtered EEG.
    
end