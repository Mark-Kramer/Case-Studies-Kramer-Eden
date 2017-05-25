function Chapter_9_Question_4()
    % Question 4 - Analyze Ch9-spikes-1.mat w/ New Model
    %   note: switching to Ch9-spikes-1.mat, which clearly shows a place cell
    
    %Load Data
    load('Ch9-spikes-1.mat')
    spike_times = spiketimes; clear spiketimes
    spike_train = hist(spike_times, t)';

    %Model 3: lambda(t) = exp( b0 + b1*X(t) + b2*X(t).^2 )
    [b3, dev3, stats3] = glmfit([X X.^2], spike_train, 'poisson', 'log');
    
    %Model Y: lambda(t) = exp( b0 + b1*X(t) + b2*X(t).^2 + b3*y(t))
    Y = randn(size(X));
    [bY, devY, statsY] = glmfit([X X.^2 Y], spike_train, 'poisson', 'log');
    
    %Maximum Likelihood Ratio Test
    p = 1 - chi2cdf(dev3 - devY, 1);
    
    %Confidence Interval and Wald Test
    CI = [bY(4) - 1.96*statsY.se(4) bY(4) + 1.96*statsY.se(4)];
    eCI = exp(CI);
    pY = statsY.p(4);
    
    % The MLRT shows a p-value of .2845 (yours may differ due to randomness),
    % indicating the new model isn't better than the old model. Further, the CI
    % includes 0, and the eCI contains 1 (indicating no change in the firing
    % rate). The p-value for the Y variable is roughly the same as the p-value
    % above. I can confidently exclude this parameter from our model.
    
end