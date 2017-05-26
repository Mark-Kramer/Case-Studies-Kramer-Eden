function Chapter_10_Question_4()
    % Question 4 - Analyze Ch10-spikes-1.mat like 10.18
    
    %Load Data and Get Useful Information
    load('Ch10-spikes-1.mat')
    i_move = t >= 0;
    spike_train = train(:, i_move);
    N = size(spike_train, 2);
    K = size(spike_train, 1);
    
    %Define Model Order, Generate Data, and Fit Model
    max_ord = 100;
    y = reshape(spike_train(:, max_ord+1:end)', K*(N - max_ord), 1);
    xdir = reshape((direction*ones(1, N - max_ord))', K*(N - max_ord), 1);
    xhist = [];
    disp('Please be patient; this may take a few minutes')
    for i = 1:max_ord
        xhist = [xhist, reshape(spike_train(:, max_ord+1-i:N-i)', K*(N - max_ord), 1)];
        [b, dev, ~] = glmfit([xdir xhist], y, 'poisson', 'log');
        aic(i) = dev+2*length(b);
        if mod(i, 10) == 0
            disp(['Iteration ', num2str(i), ' completed.'])
        end
    end
    
    %Plot AIC
    figure()
    plot(1:100, aic, 'k', 'LineWidth', 2)
    xlabel('History Terms')
    ylabel('AIC')
    title('AIC For Movement Period')
    set(gca, 'FontSize', 14)
    
    % During movement, 8 time lags behind is the lowest AIC. In the planning
    % period from figure 10.18, 62 time lags behind is the lowest AIC. If I
    % were to fit a model for both periods, I would use different time lags for
    % each period.
    
end