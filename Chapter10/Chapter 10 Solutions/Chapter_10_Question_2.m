function Chapter_10_Question_2()
    % Question 2 - Analyze Ch10-spikes-1.mat like 10.6
    
    %Load Data and Get Useful Information
    load('Ch10-spikes-1.mat')
    i_plan = t < 0;
    i_move = t >= 0;
    i_left = direction == 0;
    i_right = direction == 1;
    
    %Separate Data
    plan_left = train(i_left, i_plan);
    plan_right = train(i_right, i_plan);
    move_left = train(i_left, i_move);
    move_right = train(i_right, i_move);
    
    %Get Spike Times
    [plan_left_times, ~] = find(plan_left');
    [plan_right_times, ~] = find(plan_right');
    [move_left_times, ~] = find(move_left');
    [move_right_times, ~] = find(move_right');
    
    %Get ISIs (with potentially buggy implementation, but not for these spikes)
    plan_left_ISIs = diff(plan_left_times);
    plan_left_ISIs = plan_left_ISIs(plan_left_ISIs > 0);
    plan_right_ISIs = diff(plan_right_times);
    plan_right_ISIs = plan_right_ISIs(plan_right_ISIs > 0);
    move_left_ISIs = diff(move_left_times);
    move_left_ISIs = move_left_ISIs(move_left_ISIs > 0);
    move_right_ISIs = diff(move_right_times);
    move_right_ISIs = move_right_ISIs(move_right_ISIs > 0);
    
    %Separate Into Bins
    time_bins = 0:2:250;
    plan_left_counts = hist(plan_left_ISIs, time_bins);
    plan_right_counts = hist(plan_right_ISIs, time_bins);
    move_left_counts = hist(move_left_ISIs, time_bins);
    move_right_counts = hist(move_right_ISIs, time_bins);
    
    %Plot ISIs
    figure()
    subplot(2, 2, 1)
    bar(time_bins, plan_left_counts)
    xlabel('ISI (ms)')
    ylabel('Counts')
    title('Plan-Left')
    xlim([0 100])
    set(gca, 'FontSize', 14)
    subplot(2, 2, 2)
    bar(time_bins, plan_right_counts)
    xlabel('ISI (ms)')
    ylabel('Counts')
    title('Plan-Right')
    xlim([0 100])
    set(gca, 'FontSize', 14)
    subplot(2, 2, 3)
    bar(time_bins, move_left_counts)
    xlabel('ISI (ms)')
    ylabel('Counts')
    title('Move-Left')
    xlim([0 100])
    set(gca, 'FontSize', 14)
    subplot(2, 2, 4)
    bar(time_bins, move_right_counts)
    xlabel('ISI (ms)')
    ylabel('Counts')
    title('Move-Right')
    xlim([0 100])
    set(gca, 'FontSize', 14)
    
    % We see that whenever you are moving or planning to move left, there is a
    % general increase in the firing rate (as evidenced by more counts
    % overall). Further, these counts cluster more towards the shorter ISI
    % bins, meaning the spikes are bursting. In general, movement causes more
    % bursting. These are all expected from our analysis in Chapter 10.
    
end