function Chapter_2_Analyze_EEG(EEG, t)
    %INPUT:
    %   EEG: 2D matrix of EEG data; rows are trials and columns are time
    %   t: vector of within trial time
    
    %Part a
    sample_interval = t(2) - t(1);
    
    %Part b
    num_trials = size(EEG, 1);
    figure()
    hold on	
    imagesc(t, 1:num_trials, EEG);     	
    plot([0.25, 0.25], [0 num_trials], 'k', 'LineWidth', 2)
    hold off
    ylim([0 num_trials])
    xlim([0 max(t)])
    colorbar
    xlabel('Time (seconds)')         
    ylabel('Trial Number')  
    title('EEG Across Trials')
    set(gca, 'FontSize', 14)
    
    %Part c
    mn = mean(EEG, 1);
    sdmn = std(EEG, 1)/sqrt(num_trials);
    figure()
    hold on
    plot(t, mn, 'k', 'LineWidth', 2)
    plot(t, mn + 1.96.*sdmn, '--k', 'LineWidth', 2) %upper 95% confidence interval
    plot(t, mn - 1.96.*sdmn, '--k', 'LineWidth', 2) %lower 95% confidence interval
    hold off
    xlabel('Time (seconds)')         
    ylabel('Voltage (\muV)')  
    title('ERP')
    set(gca, 'FontSize', 14)
    
end
