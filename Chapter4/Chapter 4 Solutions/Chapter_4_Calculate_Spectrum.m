function [freq_axis, Sxx] = Chapter_4_Calculate_Spectrum(data, time)
    %INPUT:
    %   data: vector of data to perform fourier analysis on
    %   time: vector of time_points corresponding to the data
    %OUTPUT: 
    %   freq_axis: vector of frequencies
    %   Sxx: vector of calculated spectrum
    
    %Calculate Important Measures
    sample_interval = time(2) - time(1);
    sample_freq = 1/sample_interval;
    T = max(time);
    N = length(data);
    freq_resolution = 1/T;
    nyquist_freq = sample_freq/2;
    freq_axis = 0:freq_resolution:nyquist_freq;
    data = data - mean(data);
    
    %Use Fourier Analysis to Calculate Spectrum
    xf = fft(data);
    Sxx = (2*sample_interval^2/T) .* (xf.*conj(xf));
    Sxx = Sxx(1:floor(N/2)+1);
    Sxx(1) = 0; %set 0 frequency to 0 power to remove MATLAB's rounding issue  
    
end