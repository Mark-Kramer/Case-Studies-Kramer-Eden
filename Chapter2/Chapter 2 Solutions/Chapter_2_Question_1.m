function Chapter_2_Question_1()
    % Question 1 - Alternative Test Statistic
    
    %Load Data
    load('Ch2-EEG-1.mat')
    num_trials = size(EEGa, 1);
    EEG_null = [EEGa; EEGb];
    num_trials_null = size(EEG_null, 1);
    
    %Compute Test Alternative Statistic
    ERP_A = mean(EEGa, 1);
    ERP_B = mean(EEGb, 1);
    test_statistic = sum( (ERP_A - ERP_B).^2 );
    
    %Set Up Bootstrap
    num_bootstrap = 3000;
    alternate_statistic = zeros(num_bootstrap, 1);
    
    disp('Beginning Bootstrap: Please Be Patient!')
    for boot = 1:num_bootstrap
        
        %Get num_trials Random Trials Ranging From 1 to num_trials_null
        rand_trials_A = randsample(num_trials_null, num_trials, 1);
        rand_trials_B = randsample(num_trials_null, num_trials, 1);
        
        %Get ERP From Random Trials
        boot_EEG_A = EEG_null(rand_trials_A, :);
        boot_EEG_B = EEG_null(rand_trials_B, :);
        boot_ERP_A = mean(boot_EEG_A, 1);
        boot_ERP_B = mean(boot_EEG_B, 1);
        
        %Compute/Store Statistic
        stat = sum( (boot_ERP_A - boot_ERP_B).^2 );
        alternate_statistic(boot) = stat;
        
    end
    
    %Plot Bootstrapped Null Hypothesis Statistic and Test Statistic
    figure()
    hold on
    histogram(alternate_statistic)
    y_limits = get(gca, 'YLim'); 
    stem(test_statistic, y_limits(2)/2, 'r', 'LineWidth', 2) %plot the test statistic so it's visible   
    hold off
    title('Bootstrapped Alternative Statistic and the Test Alternative Statistic') 
    legend({'Bootstrap Under Null Hypothesis', 'Test Statistic'})
    xlabel('Value of Alternative Statistic')
    ylabel('Number in Bin (for Histogram, not Test)')
    set(gca, 'FontSize', 14)
    
end