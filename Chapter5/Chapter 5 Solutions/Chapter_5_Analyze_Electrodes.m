function [Sxx, Syy, Sxy, cross_cov, cohr, lags, faxis] = Chapter_5_Analyze_Electrodes(x, y, sample_freq, T)
    %INPUT:
    %   x: a matrix containing EEG (or modeled) data
    %       rows = trials, columns = within trial time
    %   y: a matrix containing EEG (or modeled) data
    %       rows = trials, columns = within trial time
    %   sample_freq: sample frequency of data
    %   T: length of recording (seconds)
    %OUTPUT:
    %   Sxx: x's spectrum amplitude
    %   Syy: y's spectrum amplitude
    %   Sxy: x and y cross-spectrum (note: complex double)
    %   cross_cov: x and y cross-covariance
    %   cohr: x and y coherence 
    %   lags: vector of lags corresponding to cross_cov
    %   faxis: vector of frequencies corresponding to spectrum/coherence measures
    
    %Calculate Various Information
    ntrials = size(x, 1);
    N = size(x, 2);
    num_lags = N/5;
    nyquist_freq = sample_freq/2;
    freq_resolution = 1/T;
    faxis = 0:freq_resolution:nyquist_freq;
    sample_interval = 1/sample_freq;
    
    %Preallocate Memory For Storage
    cross_cov = zeros(ntrials, 2*num_lags+1);
    Sxx = zeros(ntrials, N);
    Syy = zeros(ntrials, N);
    Sxy = zeros(ntrials, N);
    
    %Calculate Spectrum, Cross-Spectrum, and Cross-Covariance
    for trial = 1:ntrials
        
        %Normalize Data
        x_norm = x(trial, :) - mean(x(trial, :));
        y_norm = y(trial, :) - mean(y(trial, :));
        
        %Compute/Store Cross-Covariance and Fourier Transform Data
        [cross_cov(trial, :), lags] = xcorr(x_norm, y_norm, num_lags, 'biased');
        xf =  fft(x_norm);
        yf =  fft(y_norm);
        
        %Store Spectrum and Cross-Spectrum
        Sxx(trial, :) = 2*sample_interval^2/T * (xf.*conj(xf));
        Syy(trial, :) = 2*sample_interval^2/T * (yf.*conj(yf));
        Sxy(trial, :) = 2*sample_interval^2/T * (xf.*conj(yf));
        
    end
    
    %Ignore Negative Frequencies
    Sxx = Sxx(:, 1:N/2+1);
    Syy = Syy(:, 1:N/2+1);
    Sxy = Sxy(:, 1:N/2+1);
    
    %Set DC to Zero to Correct for MATLAB Rounding
    Sxx(:, 1) = 0;
    Syy(:, 1) = 0; 
    Sxy(:, 1) = 0;
    
    %Calculate Coherence
    cohr = abs(mean(Sxy, 1))./ (sqrt(mean(Sxx, 1)) .* sqrt(mean(Syy, 1)) );
    
end