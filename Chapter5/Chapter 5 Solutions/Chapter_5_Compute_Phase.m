function [phase_matrix_x, phase_matrix_y, phase_matrix_xy] = Chapter_5_Compute_Phase(x, y, sample_freq, T, phase_freq)
    %INPUT:
    %   x: a matrix containing EEG (or modeled) data
    %       rows = trials, columns = within trial time
    %   y: a matrix containing EEG (or modeled) data
    %       rows = trials, columns = within trial time
    %   sample_freq: sample frequency of data
    %   T: length of recording (seconds)
    %   phase_freq: a vector (could be of length 1) containing the desired
    %       frequencies to look at phase information for
    %OUTPUT:
    %   phase_matrix_x: matrix of phase information for the desired phase
    %       frequencies using x's data
    %   phase_matrix_y: matrix of phase information for the desired phase
    %       frequencies using y's data
    %   phase_matrix_xy: matrix of phase information for the desired phase
    %       frequencies using x and y's data
    %IMPORTANT: this function is meant to illustrate phase difference as
    %computed by the cross-spectrum. The best way to analyze phase in one
    %signal is explored in Chapter 7.

    %Calculate Various Information
    ntrials = size(x, 1);
    nyquist_freq = sample_freq/2;
    freq_resolution = 1/T;
    faxis = 0:freq_resolution:nyquist_freq;
    sample_interval = 1/sample_freq;
    
    %Get Nearest Requested Frequency
    phase_freq = phase_freq(:)'; %enforce row vector
    [~, indices] = min(abs(faxis' - phase_freq)); %get the indices at which each frequency is represented 
    
    %Preallocate Memory For Storage
    phase_matrix_x = zeros(ntrials, length(phase_freq));
    phase_matrix_y = zeros(ntrials, length(phase_freq));
    phase_matrix_xy = zeros(ntrials, length(phase_freq));
    
    %Calculate Phase
    for trial = 1:ntrials
        
        %Normalize Data
        x_norm = x(trial, :) - mean(x(trial, :));
        y_norm = y(trial, :) - mean(y(trial, :));
        
        %Compute Fourier Transform of Data and Get Phase
        xf =  fft(x_norm);
        yf =  fft(y_norm);
        Sxy = 2*sample_interval^2/T * (xf.*conj(yf));
        xf_phase = angle(xf);
        yf_phase = angle(yf);
        xy_phase = angle(Sxy);
        
        %Store Angles
        phase_matrix_x(trial, :) = xf_phase(indices);
        phase_matrix_y(trial, :) = yf_phase(indices);
        phase_matrix_xy(trial, :) = xy_phase(indices);
        
    end
    
end