function Chapter_2_Question_7()
    % Question 7 - Compare Ch2-EEG-3.mat and Ch2-EEG-4.mat
     
    %Load and Rename Variables
    load('Ch2-EEG-3.mat')
    EEG_3 = EEG;
    load('Ch2-EEG-4.mat')
    EEG_4 = EEG;
    clear EEG
    EEG_null = [EEG_3; EEG_4];
    num_trials_null = size(EEG_null, 1);
    num_trials = size(EEG_4, 1);
     
    %Compute Test Statistic and Alternative Test Statistic
    ERP_3 = mean(EEG_3, 1);
    ERP_4 = mean(EEG_4, 1);
    test_statistic = max(abs(ERP_3 - ERP_4));
    alternative_test_statistic = sum( (ERP_3 - ERP_4).^2 );

    %Set Up Bootstrap
    num_bootstrap = 3000;
    boot_statistic = zeros(num_bootstrap, 1);
    boot_alternate_statistic = zeros(num_bootstrap, 1);
    
    disp('Beginning Bootstrap: Please Be Patient!')
    for boot = 1:num_bootstrap
        
        %Get num_trials Random Trials Ranging From 1 to num_trials_null
        rand_trials_3 = randsample(num_trials_null, num_trials, 1);
        rand_trials_4 = randsample(num_trials_null, num_trials, 1);
        
        %Get ERP From Random Trials
        boot_EEG_3 = EEG_null(rand_trials_3, :);
        boot_EEG_4 = EEG_null(rand_trials_4, :);
        boot_ERP_3 = mean(boot_EEG_3, 1);
        boot_ERP_4 = mean(boot_EEG_4, 1);
        
        %Compute/Store Statistic
        boot_statistic(boot) = max(abs(boot_ERP_3 - boot_ERP_4));
        boot_alternate_statistic(boot) = sum( (boot_ERP_3 - boot_ERP_4).^2 );
        
    end
    
    %Plot Test Statistic
    figure()
    subplot(1, 2, 1) %split figure into two
    hold on
    histogram(boot_statistic)
    y_limits = get(gca, 'YLim'); 
    stem(test_statistic, y_limits(2)/2, 'r', 'LineWidth', 2) %plot the test statistic so it's visible   
    hold off
    title('Bootstrapped Test Statistic and the Test Statistic') 
    legend({'Bootstrap Under Null Hypothesis', 'Test Statistic'})
    xlabel('Value of Test Statistic')
    ylabel('Number in Bin (for Histogram, not Test)')
    set(gca, 'FontSize', 14)

    %Plot Alternative Test Statistic
    subplot(1, 2, 2) %split figure into two
    hold on
    histogram(boot_alternate_statistic)
    y_limits = get(gca, 'YLim'); 
    stem(alternative_test_statistic, y_limits(2)/2, 'b', 'LineWidth', 2) %plot the test statistic so it's visible   
    hold off
    title('Bootstrapped Alternative Statistic and the Alternative Test Statistic') 
    legend({'Bootstrap Under Null Hypothesis', 'Alternative Test Statistic'})
    xlabel('Value of Alternative Test Statistic')
    ylabel('Number in Bin (for Histogram, not Test)')
    set(gca, 'FontSize', 14)
    
end