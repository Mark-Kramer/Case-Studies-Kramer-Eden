function Chapter_8_Question_2()
    % Question 2 - Maximum Likelihood Using Two Methods

    %Load Data
    load('Ch8-spikes-1.mat')
    
    %Get ISIs
    isi_low = diff(SpikesLow);
    isi_high = diff(SpikesHigh);

    %Method 1: Analytic Maximum Likelihood Estimate
    [mu_low_formula, lambda_low_formula] = Chapter_8_Inv_Gauss_Formula(isi_low);
    [mu_high_formula, lambda_high_formula] = Chapter_8_Inv_Gauss_Formula(isi_high);
    
    %Method 2: Iterate Over Values
    mu_vals = 0:0.001:0.1;
    lambda_vals = 0:0.001:0.1;
    [mu_low_iterate, lambda_low_iterate] = ...
        Chapter_8_Inv_Gauss_Log_Likelihood(mu_vals, lambda_vals, isi_low);
    [mu_high_iterate, lambda_high_iterate] = ...
        Chapter_8_Inv_Gauss_Log_Likelihood(mu_vals, lambda_vals, isi_high);
    
end