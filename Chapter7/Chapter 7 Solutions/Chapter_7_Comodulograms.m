function Chapter_7_Comodulograms(LFP, phase, amp, t)
    %INPUT:
    %   LFP = raw local field potential
    %   phase = x-axis range for bandpass filter for phases
    %   amp = y-axis range for bandpass filter for phases
    %   t = time

    %Enforce Row Vectors
    LFP = LFP(:)';
    phase = phase(:)';
    amp = amp(:)';
    t = t(:)';
    
    %Get Important Information
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    T = t(end);
    N = length(t);
    freq_resolution = 1/T;
    nyquist_freq = sample_freq/2;
    faxis = 0:freq_resolution:nyquist_freq;
    phase_interval = phase(2) - phase(1); %assumes similar spacing
    amp_interval = amp(2) - amp(1); %assumes similar spacing
    
    %Create Low Pass and High Pass Data
    Vlo = zeros(length(phase), N);
    for i = 1:length(phase)
        phase_range = [phase(i) - phase_interval/2, phase(i) + phase_interval/2];
        Wn = phase_range/nyquist_freq;
        n = 100;
        b = fir1(n, Wn);
        Vlo(i, :) = filtfilt(b, 1, LFP);
    end
    Vhi = zeros(length(amp), N);
    for i = 1:length(amp)
        amp_range = [amp(i) - amp_interval/2, amp(i) + amp_interval/2];
        Wn = amp_range/nyquist_freq;
        n = 100;
        b = fir1(n, Wn);
        Vhi(i, :) = filtfilt(b, 1, LFP);
    end
    
    %Get Hilbert Transform of Data
    phi = angle(hilbert(Vlo));
    amp_envelope = abs(hilbert(Vhi));
    
    %Get Phase Amplitude Data
    % note: there are more computationally efficient versions; this is didactic
    h_mat = zeros(length(phase), length(amp));
    p_bins = -pi:0.1:pi;
    num_bins = length(p_bins) - 1;
    for i = 1:length(phase) %iterate phase
        for j = 1:length(amp) %iterate amp
            
            %Preallocate CFC Matrix
            a_mean = zeros(num_bins, 1);
            p_mean = zeros(num_bins, 1);
            
            %For Each Phase in Bin
            for k = 1:num_bins
                
                %Get Limits
                pL = p_bins(k); %lower phase limit
                pR = p_bins(k+1); %upper phase limit
                
                %Get Data
                indices = find(phi(i, :) >= pL & phi(i, :) < pR);
                a_mean(k) = mean(amp_envelope(j, indices));
                p_mean(k) = mean([pL pR]);
            end
            
            %Compute and Store Test Statistic
            h_mat(i, j) = max(a_mean) - min(a_mean);
            
        end
        
    end
    
    %Visualize Comodulogram
    figure()
    imagesc(phase, amp, h_mat')
    axis xy
    colorbar()
    xlabel('Low Pass Phase')
    ylabel('High Pass Amplitude')
    title('Test Statistic for CFC')
    set(gca, 'FontSize', 14)

end