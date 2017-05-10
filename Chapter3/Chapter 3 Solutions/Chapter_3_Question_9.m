function Chapter_3_Question_9()
    % Question 9 - Double Time Analysis
    
    %Get Data to Test Hypothesis
    load('Ch3-EEG-2.mat')
    data_single = EEG - mean(EEG);
    data_double = [data_single; data_single];
    t_single = t;
    t_double = [t, t+max(t)];
    
    %Compute Equal Values for Each Dataset
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    nyquist_freq = sample_freq/2;
    
    %Compute Different Values for Each Dataset
    N_single = length(t);
    N_double = length(t_double);
    T_single = max(t);
    T_double = max(t_double);
    freq_res_single = 1/T_single;
    freq_res_double = 1/T_double;
    
    %Compute data_single FFT
    xf_single = fft(data_single); %get fourier transform (complex double output)
    Sxx_single = 2*sample_interval^2/T_single*(xf_single.*conj(xf_single)); %get spectrum
    Sxx_single = Sxx_single(1:N_single/2+1); %ignore negative freqs b/c they are redundant (so you don't add them) 
    Sxx_single(1) = 0; %set 0 frequency to 0 (usually ~ 10^-30 due to rounding errors) 
    faxis_single = (0:freq_res_single:nyquist_freq);
    figure()
    plot(faxis_single, 10*log10(Sxx_single), 'r', 'LineWidth', 2)
    xlim([0 120])
    xlabel('Freq (Hz)')
    ylabel('Power (dB)')
    title('Periodogram of Data')
    set(gca, 'FontSize', 14)
    
    %Compute data_double FFT
    xf_double = fft(data_double); %get fourier transform (complex double output)
    Sxx_double = 2*sample_interval^2/T_double*(xf_double.*conj(xf_double)); %get spectrum
    Sxx_double = Sxx_double(1:N_double/2+1); %ignore negative freqs b/c they are redundant (so you don't add them) 
    Sxx_double(1) = 0; %set 0 frequency to 0 (usually ~ 10^-30 due to rounding errors) 
    faxis_double = (0:freq_res_double:nyquist_freq);
    figure()
    db_Sxx = 10*log10(Sxx_double);
    not_infinity_inds = ~isinf(db_Sxx); %see notes below
    plot(faxis_double(not_infinity_inds), db_Sxx (not_infinity_inds), 'r', 'LineWidth', 2)
    xlim([0 120])
    xlabel('Freq (Hz)')
    ylabel('Power (dB)')
    title('Periodogram of Data (doubled)')
    set(gca, 'FontSize', 14)
    
    %Answer:
    % We clearly see the two periodograms we get are exactly the same, so
    % doubling the data does not give us new frequencies. Further, it doesn't
    % usefully increase our frequency resolution, despite the fact "freq_res_double" is
    % smaller than "freq_res_single", because of the theory behind the fourier
    % transform. When we take a fourier transform of a small segment of data,
    % the theory of the transform implicitly assumes that small segment of data
    % has an infinite number of zeros attached to either end of it. In other words,
    % given 1 second of data, the fourier transform theory assumes that the 1
    % second of data perfectly describes the signal from the beginning of 
    % recorded history until the inevitable heat-death of the universe. It then
    % fits frequencies to this infinite zero-tailed data. By doubling the data, we
    % are not actually giving the fourier transform more information; the same 
    % frequencies are still present in the signal. If you look at the values 
    % of Sxx_double, you'll see every other power is 0. This is because the "new"
    % data, which is really just twice the old data, contains no new
    % frequencies to fit. Everything is still perfectly described by the old
    % best fit frequencies. So even though our frequency resolution has 
    % increased, all the values at those increased frequency resolutions are 
    % zero, effectively making the increased resolution worthless.
    
    % note about "not_infinity_inds": MATLAB has trouble plotting infinity and
    % when I take db_Sxx = 10*log10(Sxx_double) it causes every other value to
    % be infinity (the 10*log10(0) = -Inf). Thus, I create a variable that 
    % stores the indices of only the non-negative-infinity values so I can plot
    % them without MATLAB having problems dealing with their negative-infinity
    % neighbors.

end