function Chapter_9_Question_3()
    % Question 3 - Analyze Ch9-spikes-2.mat w/ AIC
    
    %Load Data
    load('Ch9-spikes-2.mat')
    spike_times = spiketimes; clear spiketimes
    spike_train = hist(spike_times, t)';

    %Model 1: lambda(t) = b0 + b1*X(t)
    [b1, dev1, stats1] = glmfit(X, spike_train, 'poisson', 'identity');

    %Model 2: lambda(t) = exp( b0 + b1*X(t) )
    [b2, dev2, stats2] = glmfit(X, spike_train, 'poisson', 'log');
    
    %Model 3: lambda(t) = exp( b0 + b1*X(t) + b2*X(t).^2 )
    [b3, dev3, stats3] = glmfit([X X.^2], spike_train, 'poisson', 'log');
    
    %Compute Difference in AIC
    dAIC_12 = (dev1 + 2*2) - (dev2 + 2*2);
    dAIC_13 = (dev1 + 2*2) - (dev3 + 2*3);
    
    % The difference between AIC1 and AIC2 is essentially zero (and 
    % certainly not significant). AIC3 is also about 2 a.u. larger than 
    % AIC 1, indicating it isn't a better model fit given more parameters 
    % (however, again, this isn't significant). See Chapter_9_Question_1 for
    % more insight into this process.
    
end