function Chapter_6_Question_7()
    % Question 7 - FIR Filter Effect on Sinusoid Waves

    %Create Sinusoid Frequencies
    sample_interval = .001;
    t = sample_interval:sample_interval:1;
    sample_freq = 1/sample_interval;
    sin15 = sin(2*pi*15*t);
    sin20 = sin(2*pi*20*t);
    sin25 = sin(2*pi*25*t);
    nyquist_freq = sample_freq/2;
    
    %Create Low-Pass Filter
    n = 100;
    Wn = 30/nyquist_freq; 
    b = transpose(fir1(n, Wn, 'low'));
    
    %Filter Data
    sin15new = filter(b, 1, sin15);
    sin20new = filter(b, 1, sin20);
    sin25new = filter(b, 1, sin25);
 
    %Visualize Data
    figure()
    subplot(3, 1, 1)
    hold on
    plot(t, sin15, 'k', 'LineWidth', 2)
    plot(t, sin15new, 'b', 'LineWidth', 2)
    hold on
    xlabel('Time (seconds)')
    ylabel('Data')
    title('15 Hz Sinusoid')
    legend({'Raw Data', 'Filtered Data'})
    set(gca, 'FontSize', 14)
    subplot(3, 1, 2)
    hold on
    plot(t, sin20, 'k', 'LineWidth', 2)
    plot(t, sin20new, 'b', 'LineWidth', 2)
    hold on
    xlabel('Time (seconds)')
    ylabel('Data')
    title('20 Hz Sinusoid')
    legend({'Raw Data', 'Filtered Data'})
    set(gca, 'FontSize', 14)
    subplot(3, 1, 3)
    hold on
    plot(t, sin25, 'k', 'LineWidth', 2)
    plot(t, sin25new, 'b', 'LineWidth', 2)
    hold on
    xlabel('Time (seconds)')
    ylabel('Data')
    title('25 Hz Sinusoid')
    legend({'Raw Data', 'Filtered Data'})
    set(gca, 'FontSize', 14)
    
    % The 15 Hz and 25 Hz sinusoids have a phase offset whereas the 20 Hz
    % sinusoid does not. This is what we would expect from figure 6.12.
    
end