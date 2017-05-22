function Chapter_6_Question_4()
    % Question 4 - Changing Order of FIR Filters

    %Load the EEG data to define useful parameters.
    load('Ch6-EEG-1.mat') 
    x = EEG(1,:) - mean(EEG(1,:));
    sample_interval = t(2) - t(1);
    N = length(x);
    sample_freq = 1/sample_interval;
    nyquist_freq = sample_freq/2;
    freq_resolution = 1/(N*sample_interval);
    faxis = fftshift((-nyquist_freq:freq_resolution:nyquist_freq-freq_resolution));

    %Define the filter orders, cutoff frequency, and colors.
    n = [1000, 500, 100, 50];
    Wn = 30/nyquist_freq; 
    clr = {'r', 'g', 'b', 'm'};
    filtered_data = zeros(length(n), N);

    %For each filter, design and visualize the filter.
    for k = 1:length(n)
        
        %Design filter.
        b = fir1(n(k), Wn, 'low');

        %Visualize filter.
        subplot(2,1,1)
        hold on
        plot(b+0.05*k, 'Color', clr{k})
        hold off
        axis tight
        axis off

        bf = fft(b,N);		%NOTE: zero pad to same length as x.
        subplot(2,1,2)
        hold on
        plot(faxis,bf.*conj(bf), 'Color', clr{k})
        hold off
        axis tight
        xlim([-55 55])
        xlabel('Frequency [Hz]')
        
        %Store Filtered Data (note: we cannot use filtfilt)
        x1 = filter(b, 1, x); %filter once
        x1 = x1(N:-1:1); %reverse
        x2 = filter(b, 1, x1); %filter again
        filtered_data(k, :) = x2(N:-1:1); %reverse again

    end
    subplot(2,1,1)
    legend({'n=1000'; 'n=500'; 'n=100'; 'n=50'})
    
    %Plot Filtered Data
    figure()
    subplot(5, 1, 1)
    plot(t, x, 'k', 'LineWidth', 2)
    xlabel('Time (seconds)')
    ylabel('Data')
    title('Raw Data')
    set(gca, 'FontSize', 14)
    for i = 2:5
        subplot(5, 1, i)
        plot(t, filtered_data(i-1, :), clr{i-1}, 'LineWidth', 2)
        xlabel('Time (seconds)')
        ylabel('Data')
        title(['Order: ', num2str(n(i-1))])
        set(gca, 'FontSize', 14)
    end

    % Increasing the order of the FIR filter causes the EEG signal to smooth
    % out. 
    
end