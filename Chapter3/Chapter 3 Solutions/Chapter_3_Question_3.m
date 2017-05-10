function Chapter_3_Question_3()
    % Question 3 - Autocorrelation (Normalized Autocovariance)
    
    %Set Up
    load('Ch3-EEG-1.mat')
    dt = t(2) - t(1);
    data = EEG - mean(EEG);
    var_data = var(data);
    
    %Autocovariance (biased): 
    [auto_cov, lags] = xcorr(data, 100, 'biased'); %biased autocovariance

    %Autocorrelation (biased):
    auto_corr = auto_cov/var_data;

    %Plot
    figure()
    hold on
    plot(lags.*dt, auto_cov, 'k', 'LineWidth', 2)
    plot(lags.*dt, auto_corr, 'b', 'LineWidth', 2)
    hold off
    xlabel('Lag (seconds)')
    ylabel('Autocorrelation or Autocovariance')
    legend({'Autocovariance', 'Autocorrelation'})
    set(gca, 'FontSize', 14)
    
    % The autocovariance is an unnormalized measure of covariance. This can be
    % normalized by taking the biased autocorrelations and dividing by the
    % variance of the data. Overlaying the data (as I have above) shows this
    % clear underlying relationship between both measures.
    
end