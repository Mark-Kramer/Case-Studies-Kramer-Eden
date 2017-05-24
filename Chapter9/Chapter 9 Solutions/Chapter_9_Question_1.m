function Chapter_9_Question_1()
    % Question 1 - Analyze Ch9-spikes-2.mat
    
    %Load Data
    load('Ch9-spikes-2.mat')
    spike_times = spiketimes; clear spiketimes
    spike_train = hist(spike_times, t)';
    spike_ind = find(spike_train);
    
    %Visualize Spike Train Data
    figure()
    hold on
    plot(t, X, 'k', 'LineWidth', 2)
    plot(t(spike_ind), X(spike_ind), '.r', 'MarkerSize', 15)
    hold off
    xlabel('Time (seconds)')
    ylabel('Position (cm)')
    title('Spike Train Data')
    set(gca, 'FontSize', 14)
    
    %Occupancy Normalized Histogram
    space_bins = 0:10:100;
    spike_hist = hist(X(spike_ind), space_bins); %num of spikes in each space
    occupancy = hist(X, space_bins)*.001; %amount of times in each space
    figure()
    bar(space_bins, spike_hist./occupancy)
    xlabel('Position (cm)')
    ylabel('Occupancy Norm. Hist. (spikes/sec)')
    title('Occupancy Normalized Histogram')
    set(gca, 'FontSize', 14)
    
    %Model 1: lambda(t) = b0 + b1*X(t)
    [b1, dev1, stats1] = glmfit(X, spike_train, 'poisson', 'identity');
    b1_Hz = b1 * 1000;
    model_1_rate = (b1(1) + b1(2)*space_bins)*1000;
    
    %Plot Model 1
    figure()
    hold on
    bar(space_bins, spike_hist./occupancy)
    plot(space_bins, model_1_rate, 'r', 'LineWidth', 2)
    hold off
    xlabel('Position (cm)')
    ylabel('Occupancy Norm. Hist. (spikes/sec)')
    title('Model 1')
    set(gca, 'FontSize', 14)
    
    %Model 2: lambda(t) = exp( b0 + b1*X(t) )
    [b2, dev2, stats2] = glmfit(X, spike_train, 'poisson', 'log');
    model_2_rate = exp(b2(1) + b2(2)*space_bins)*1000;
    
    %Plot Model 2
    figure()
    hold on
    bar(space_bins, spike_hist./occupancy)
    plot(space_bins, model_2_rate, 'r', 'LineWidth', 2)
    hold off
    xlabel('Position (cm)')
    ylabel('Occupancy Norm. Hist. (spikes/sec)')
    title('Model 2')
    set(gca, 'FontSize', 14)
    
    %Compare With Model 1
    p = 1 - chi2cdf(dev1 - dev2, 1);
    
    %Model 3: lambda(t) = exp( b0 + b1*X(t) + b2*X(t).^2 )
    [b3, dev3, stats3] = glmfit([X X.^2], spike_train, 'poisson', 'log');
    model_3_rate = exp(b3(1) + b3(2)*space_bins + b3(3)*space_bins.^2)*1000;
    
    %Plot Model 3
    figure()
    hold on
    bar(space_bins, spike_hist./occupancy)
    plot(space_bins, model_3_rate, 'r', 'LineWidth', 2)
    hold off
    xlabel('Position (cm)')
    ylabel('Occupancy Norm. Hist. (spikes/sec)')
    title('Model 3')
    set(gca, 'FontSize', 14)
    
    %Compare With Model 1 and 2
    p = 1 - chi2cdf(dev1 - dev3, 2);
    p = 1 - chi2cdf(dev2 - dev3, 1);
    
    %Model 4: lambda(t) = exp( b0 + b1*X(t) + b2*X(t).^2 + b3*dir )
    dir = [0; diff(X) > 0];
    [b4, dev4, stats4] = glmfit([X X.^2 dir], spike_train, 'poisson', 'log');
    model_4_rate_forward = exp(b4(1) + b4(2)*space_bins +...
        b4(3)*space_bins.^2 + b4(4)*ones(1, length(space_bins)) )*1000;
    model_4_rate_backward = exp(b4(1) + b4(2)*space_bins +...
        b4(3)*space_bins.^2 + b4(4)*zeros(1, length(space_bins)) )*1000;
    
    %Plot Model 3
    figure()
    hold on
    bar(space_bins, spike_hist./occupancy)
    plot(space_bins, model_4_rate_forward, 'r', 'LineWidth', 2)
    plot(space_bins, model_4_rate_backward, 'k', 'LineWidth', 2)
    hold off
    xlabel('Position (cm)')
    ylabel('Occupancy Norm. Hist. (spikes/sec)')
    legend({'Data', 'Forward Firing Rate', 'Reverse Firing Rate'})
    title('Model 4')
    set(gca, 'FontSize', 14)
    
    %Compare With Model 1, 2, and 3
    p = 1 - chi2cdf(dev1 - dev4, 3);
    p = 1 - chi2cdf(dev2 - dev4, 2);
    p = 1 - chi2cdf(dev3 - dev4, 1);
    
    
    % a) There isn't really information for place cells, per se. However, there
    %    does seem to be firing at the tips of the track.
    % b) The occupancy normalized histogram doesn't really show any
    %    position-dependent firing.
    % c) The baseline firing rate is 1.5 Hz. For every cm the mouse progresses along
    %    the track, the firing rate decreases very slightly, but this isn't
    %    significant (p value is .9241). The fit doesn't really describe the
    %    data too well, based on the occupancy normalized histogram and modeled
    %    firing rate.
    % d) The baseline firing rate is 1.5 Hz. Every cm the mouse progresses
    %    along the track, the firing rate decreases very slightly, but this
    %    isn't significant (.9240). The fit doesn't really describe the data
    %    too well, based on the occupancy normalized histogram and modeled
    %    firing rate. Further, the p-value for the model difference is .9967,
    %    suggesting no difference in the two models.
    % e) The baseline firing rate is 1.5 Hz. Every cm the the mouse progresses
    %    along the track, the firing rate decreases very slightly, but this
    %    isn't significant (.9385). The every square cm causes no change in the
    %    firing rate (p = .9517). The fit doesn't really describe the data too
    %    well. Further, the model difference between this and model 1 is .9982
    %    and between this and model 2 is .9517.
    % f) The baseline firing rate is 1.7 Hz. Every cm (and cm^2) the mouse
    %    progresses has no change in the firing rate (as above). While the
    %    forward direction has a reduction of .84% in the firing rate, this is
    %    not significant. It also isn't different from any of the other models:
    %    model 1 (.6069), model 2 (.3991), and model 3 (.1757).
    % g) There is no clear model that works best. Even by looking at the cell
    %    we can clearly see no place field structure, except perhaps at the
    %    tail end of the track. However, in the occupancy normalized histogram,
    %    there is a slight increase in Hz at 0 and 80 cm. I would explain to
    %    the collaborator that this cell is not a place cell.
    
end