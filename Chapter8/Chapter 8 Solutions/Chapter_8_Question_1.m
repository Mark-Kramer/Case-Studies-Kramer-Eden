function Chapter_8_Question_1()
    % Question 1 - Analyze Ch8-spikes-1.mat Autocorrelation
    %   note: there is a typo in the book; the increment process data is
    %   required for a ms lag assessment, not the ISIs.

    %Load Data
    load('Ch8-spikes-1.mat')
    T = 30;
    time_bins = 0:0.001:T;
    
    %Get Spike Count
    spikes_low = hist(SpikesLow, time_bins);
    spikes_high = hist(SpikesHigh, time_bins);
    spikes = [spikes_low spikes_high];
    
    %Set Up Bootstrap
    Nlo = length(spikes_low);
    Nhi = length(spikes_high);
    N = sum(Nlo + Nhi);
    B = 1000;
    samp_diff = zeros(1, 1000);

    %Calculate Test Statistic
    [autocorr_low, lags] = xcorr(spikes_low - mean(spikes_low), 70, 'coeff');
    [autocorr_high, ~] = xcorr(spikes_high - mean(spikes_high), 70, 'coeff');
    inds = lags >= -60 & lags <= -20; %get useable lags
    test_diff = sum(autocorr_high(inds) - autocorr_low(inds));
    
    %Bootstrap
    for b = 1:B
        
        %Get Sample (w/ Replacement)
        samp_low = spikes(randsample(N, Nlo, 1));
        samp_high = spikes(randsample(N, Nhi, 1));
        
        %Calculate Autocorrelation
        [autocorr_low, ~] = xcorr(samp_low - mean(samp_low), 70, 'coeff');
        [autocorr_high, ~] = xcorr(samp_high - mean(samp_high), 70, 'coeff');

        %Calculate/Store Statistics
        samp_diff(b) = sum(autocorr_high(inds) - autocorr_low(inds));
        
    end

    %Visualize Distribution Under Null Hypothesis
    figure()
    hold on
    histogram(samp_diff) %null hypothesis bootstrapped statistics
    stem(test_diff, 100) %test statistic
    hold off
    xlabel('Statistic Value')
    ylabel('Count')
    title('Bootstrapped Null Hypothesis')
    legend({'Null Hypothesis', 'Test Statistic'})
    set(gca, 'FontSize', 14)
    
    %Calculate P-Value
    p = sum(samp_diff > test_diff)/length(samp_diff);
    disp(['The p-value is: ', num2str(p)])
    
    % There are no boostrapped statistics that are larger than the test
    % statistic (for my random bootstrap, there may be a few for yours). Thus,
    % we do believe there is a difference in the High Light increment process
    % from 20-60 milliseconds before the current spike. 
    
end