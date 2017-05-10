function Chapter_3_Question_2()
    % Question 2 - Periodogram v. Spectrum
    
    %Set Up
    load('Ch3-EEG-1.mat')
    dt = t(2) - t(1); %sample interval
    Fs = 1/dt; %sample freq
    df = 1/max(t); %frequency resolution
    fNQ = Fs/2; %nyquist frequency
    N = length(EEG);
    T = max(t);
    data = EEG - mean(EEG);

    %FFT Itself (from the book chapter)
    xf = fft(data); %get fourier transform (complex double output)
    Sxx = 2*dt^2/T*(xf.*conj(xf)); %get spectrum
    Sxx = Sxx(1:N/2+1); %ignore negative freqs b/c they are redundant (so you don't add them)  
    faxis_Sxx = (0:df:fNQ); %create frequency axis
    
    %Periodogram Inputs (to prevent defaults within function)
    %   window: a vector of equal length to EEG; explored in Chapter 4
    %   nfft: the number of points you would like to include in the analysis; explored in Chapter 4
    %   Fs: the sampling frequency
    window = rectwin(N); %our above analysis used no window (or, essentially, a rectangular window)  
    nfft = N; %our above analysis used all data points
    [Pxx, faxis_Pxx] = periodogram(data, window, nfft, Fs);

    %Set 0 Term To Zero
    %   it should be zero, but rounding errors in MATLAB cause output of ~ 10^-33 
    Pxx(1) = 0;
    Sxx(1) = 0;
    
    %Plot Both to Show They Are The Same
    figure()
    subplot(2, 1, 1)
    plot(faxis_Sxx, 10*log10(Sxx/max(Sxx)), 'k', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    legend({'FFT Analysis (Chapter)'})
    set(gca, 'FontSize', 14)
    
    subplot(2, 1, 2)
    plot(faxis_Pxx, 10*log10(Pxx/max(Sxx)), 'b', 'LineWidth', 2)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    legend({'FFT Analysis (Periodogram)'})
    set(gca, 'FontSize', 14)
    
end