function Chapter_3_Analyze_EEG(EEG, t)
    %INPUT:
    %   EEG: row vector of mean-normalized EEG data
    %   t: column vector of within trial timestamps

    %Calculate Various Measures
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    T = max(t);
    N = length(t);
    freq_resolution = 1/T;
    nyquist_freq = sample_freq/2;
    
    %Plot Data
    figure()
    plot(t, EEG, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Potential (\muV)')
    title('Original Data')
    set(gca, 'FontSize', 14)
    
    %Plot Biased Autocovariance Lags
    [ac, lags] = xcorr(EEG, 100, 'biased');
    figure()
    plot(lags*sample_interval, ac, 'b', 'LineWidth', 2)
    xlabel('Lag (seconds)')
    ylabel('Autocovariance (biased)')
    title('Autocovariance of the Data')
    set(gca, 'FontSize', 14)
    
    %Fourier Transform
    xf = fft(EEG); %get fourier transform (complex double output)
    Sxx = 2*sample_interval^2/T*(xf.*conj(xf)); %get spectrum
    Sxx = Sxx(1:N/2+1); %ignore negative freqs b/c they are redundant (so you don't add them) 
    Sxx(1) = 0; %set 0 frequency to 0 (usually ~ 10^-30 due to rounding errors) 
    faxis = (0:freq_resolution:nyquist_freq);
    figure()
    plot(faxis, 10*log10(Sxx), 'r', 'LineWidth', 2)
    xlim([0 120])
    xlabel('Freq (Hz)')
    ylabel('Power (dB)')
    title('Periodogram of Data')
    set(gca, 'FontSize', 14)
    
    %Compute Spectrogram
    w_size = round(sample_freq/2); %size of window of data you want to analyze
    overlap = round(w_size*.95); %overlap when computing
    nfft = w_size; % number of points to consider for each step
    [S, F, T, P] = spectrogram(EEG, w_size, overlap, nfft, sample_freq);
    %   S: complex double fourier transform at row = freq col = time
    %   F: column vector of freqs
    %   T: row vector of times
    %   P: power ("\muV^2/Hz")
    P(1, :) = 0; %set 0 frequency to 0 (usually ~ 10^-30 due to rounding errors) 
    figure()
    imagesc(T, F, 10*log10(P)) 
    colorbar %add colorbar
    axis xy %origin in lower left; otherwise imagesc flips it weird
    ylim([0 70]) %constrain frequency to [0 70] Hz
    xlabel('Time (seconds)')
    ylabel('Freqs (Hz')
    set(gca, 'FontSize', 16)

end