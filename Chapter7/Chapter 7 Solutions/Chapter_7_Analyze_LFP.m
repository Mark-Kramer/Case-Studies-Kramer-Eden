function Chapter_7_Analyze_LFP(LFP, high_band, low_band, t)
    %INPUT:
    %   LFP = raw local field potential
    %   high_band = high frequency range for bandpass filter
    %   low_band = low frequency range for bandpass filter
    %   t = time

    %Get Important Information
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    T = t(end);
    N = length(t);
    freq_resolution = 1/T;
    nyquist_freq = sample_freq/2;
    faxis = 0:freq_resolution:nyquist_freq;
    
    %Enforce Row Vectors
    LFP = LFP(:)';
    high_band = high_band(:)';
    low_band = low_band(:)';
    t = t(:)';
    
    %Visualize the Time Series Data
    figure()
    plot(t(4000:6000), LFP(4000:6000), 'k', 'LineWidth', 1)
    xlabel('Time (seconds)')
    ylabel('Voltage (mV)')
    title('Two Seconds of Raw LFP')
    set(gca, 'FontSize', 14)
    
    %Spectral Analysis
    x = hann(N).*LFP';
    xf = fft(x  - mean(x));
    Sxx = 2*sample_interval^2/T * (xf.*conj(xf));
    Sxx = Sxx(1:N/2+1);
    
    %Visualize Spectrum
    figure()
    plot(faxis, 10*log10(Sxx), 'r', 'LineWidth', 1)
    xlabel('Frequency (Hz)')
    ylabel('Power (mV^2/Hz)')
    title('F.T. of All Data')
    xlim([0 120])
    ylim([-80 0])
    set(gca, 'FontSize', 14)
    
    %Create Low Pass and High Pass Filters
    Wn = low_band/nyquist_freq;
    n = 100;
    b = fir1(n, Wn);
    Vlo = filtfilt(b, 1, LFP);
    Wn = high_band/nyquist_freq;
    n = 100;
    b = fir1(n, Wn);
    Vhi = filtfilt(b, 1, LFP);

    %Visualize Filters
    figure()
    subplot(3, 1, 1)
    plot(t(4000:6000), LFP(4000:6000), 'k', 'LineWidth', 1)
    xlabel('Time (seconds)')
    ylabel('Voltage (mV)')
    title('Raw Data')
    set(gca, 'FontSize', 14)
    subplot(3, 1, 2)
    plot(t(4000:6000), Vlo(4000:6000), 'b', 'LineWidth', 1)
    xlabel('Time (seconds)')
    ylabel('Voltage (mV)')
    title('Low Pass Data')
    set(gca, 'FontSize', 14)
    subplot(3, 1, 3)
    plot(t(4000:6000), Vhi(4000:6000), 'g', 'LineWidth', 1)
    xlabel('Time (seconds)')
    ylabel('Voltage (mV)')
    title('High Pass Data')
    set(gca, 'FontSize', 14)
    
    %Method 1: Resample Method for CFC
    Chapter_7_Resample_CFC(Vlo, Vhi)
    
    %Method 2: GLM
    n_ctrl_pts = 8;
    [r, r_ci] = GLM_CFC(Vlo, Vhi, n_ctrl_pts);
    
end