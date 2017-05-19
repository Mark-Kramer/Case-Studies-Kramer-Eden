function Chapter_5_Question_1()
    % Question 1 - Model Frequency and Single Trial Cross-Covariance

    %Generate Data
    T = 2;
    sample_interval = .001;
    freq = 10;
    t = sample_interval:sample_interval:T;
    x = cos(2*pi*freq*t);
    y = sin(2*pi*freq*t);
    
    %Visualize Data
    figure()
    hold on
    plot(t, x, 'b', 'LineWidth', 2)
    plot(t, y, 'r', 'LineWidth', 2)
    hold off
    xlabel('Time (sec)')
    ylabel('Data')
    legend({'Cos(10 Hz)', 'Sin(10 Hz)'})
    title('Single Trial Simulated Data')
    set(gca, 'FontSize', 14)
    
    %Compute Cross-Covariance
    [cross_cov, lags] = xcorr(x - mean(x), y - mean(y), 200, 'biased');
    
    %Plot Cross-Covariance
    figure()
    plot(lags*sample_interval, cross_cov, 'b', 'LineWidth', 2)
    xlabel('Time (sec)')
    ylabel('Cross-Covariance')
    ylim([-0.6 0.6])
    title('Single Trial Cross-Covariance')
    set(gca, 'FontSize', 14)
    
    % We see that the single trial cross-covariance between the two signals
    % shows some correlation, suggesting synchrony between them. However, if we
    % were to randomize the phase at which the sine and cosine model data
    % starts, then repeat the modeling for 100 trials, we would see a lack of
    % correlation between the two signals. See figure 5.6 in the book for an
    % illustration of this. Note how the generated figure here looks like one
    % instance of the lines in 5.6b and how a trial-averaged correlation (where
    % we randomize the phase of the sines and cosines) would generate something
    % close to 5.6a. This question demonstrates that a single trial's
    % cross-covariance can be quite misleading and heavily reliant upon any
    % shared dominant signal between the two (in this case 10 Hz).
    
end