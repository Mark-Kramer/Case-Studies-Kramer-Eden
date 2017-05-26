function Chapter_10_Question_5()
    % Question 5 - Analyze Ch10-spikes-1.mat w/ Mexican Hat Basis Functions
    
    %Load Data
    load('Ch10-spikes-1.mat')
    K = 50;
    T0 = length(t);
    
    %Construct Dependent Variables
    ord = 70;
    T1 = T0-ord;				
    y = reshape(train(:,ord+1:end)', K*T1,1);
    xdir = reshape((direction*ones(1,T1))',K*T1,1);	
    i_move = ones(K,1)*[zeros(1,T0/2-ord) ones(1,T0/2)];
    i_move = reshape((i_move)',K*T1,1);
    xHist = [];	
    for i = 1:ord				
        xHist=[xHist reshape(train(:,ord+1-i:end-i)',K*T1,1)];
    end

    %Smoothing Splines (Gaussian for ease of implementation)
    for i = 1:ord
        C1(i, :) = normpdf(-5:10:ord, i, 5);
        C2(i, :) = normpdf(-5:10:ord, i, 5) - normpdf(-5:10:ord, i, 10);
    end
    
    %View Gaussian and Mexican Hat Splines
    figure()
    subplot(2, 1, 1)
    hold on
    for col = 1:size(C1, 2)
        plot(C1(:, col))
    end
    hold off
    title('Gaussian Splines')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    hold on
    for col = 1:size(C2, 2)
        plot(C2(:, col))
    end
    hold off
    title('Mexican Hat Splines')
    set(gca, 'FontSize', 14)
    
    %Fit Models
    nparams = size(C1, 2);
    [b5, dev5, stats5] = glmfit([i_move xdir...
        ((1 - i_move)*ones(1, nparams)).*(xHist*C1)...
        ((i_move)*ones(1, nparams)).*(xHist*C1)], y, 'poisson', 'log');
    [b5_hat, dev5_hat, stats5_hat] = glmfit([i_move xdir...
        ((1 - i_move)*ones(1, nparams)).*(xHist*C2)...
        ((i_move)*ones(1, nparams)).*(xHist*C2)], y, 'poisson', 'log');
    
    %Visualize History Modulation
    figure()
    subplot(2, 1, 1)
    plot(1:ord, exp(C1*b5(4:nparams+3)))
    xlabel('Lag (ms)')
    ylabel('Modulation')
    title('Planning: Gaussian Spline')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(1:ord, exp(C1*b5(nparams+4:end)))
    xlabel('Lag (ms)')
    ylabel('Modulation')
    title('Moving: Gaussian Spline')
    set(gca, 'FontSize', 14)
    figure()
    subplot(2, 1, 1)
    plot(1:ord, exp(C2*b5_hat(4:nparams+3)))
    xlabel('Lag (ms)')
    ylabel('Modulation')
    title('Planning: Mexican Hat Spline')
    set(gca, 'FontSize', 14)
    subplot(2, 1, 2)
    plot(1:ord, exp(C2*b5_hat(nparams+4:end)))
    xlabel('Lag (ms)')
    ylabel('Modulation')
    title('Moving: Mexican Hat Spline')
    set(gca, 'FontSize', 14)
    
    %Time Rescaling
    lambda5 = glmval(b5, [i_move xdir...
        ((1 - i_move)*ones(1, nparams)).*(xHist*C1)...
        ((i_move)*ones(1, nparams)).*(xHist*C1)], 'log');
    lambda5_hat = glmval(b5_hat, [i_move xdir...
        ((1 - i_move)*ones(1, nparams)).*(xHist*C2)...
        ((i_move)*ones(1, nparams)).*(xHist*C2)], 'log');
    spike_index = find(y);
    N = length(spike_index);
    Z(1) = sum(lambda5(1:spike_index(1)));
    for i = 2:N
        Z(i) = sum(lambda5(spike_index(i-1) + 1:spike_index(i)));
    end
    [eCDF, zvals] = ecdf(Z);
    mCDF = 1 - exp(-zvals);
    Z(1) = sum(lambda5_hat(1:spike_index(1)));
    for i = 2:N
        Z(i) = sum(lambda5_hat(spike_index(i-1) + 1:spike_index(i)));
    end
    [eCDF_hat, zvals_hat] = ecdf(Z);
    mCDF_hat = 1 - exp(-zvals_hat);
    
    %Model 5: KS Plot
    ci = 1.36/sqrt(N);
    figure()
    subplot(1, 2, 1)
    hold on
    plot(mCDF, eCDF, 'k', 'LineWidth', 2)
    plot([0 1], [0 1] + ci, '--k', 'LineWidth', 1)
    plot([0 1], [0 1] - ci, '--k', 'LineWidth', 1)
    hold off
    xlabel('Model CDF')
    ylabel('Emirical CDF')
    xlim([0 1])
    ylim([0 1])
    title('KS Plot')
    set(gca, 'FontSize', 14)
    subplot(1, 2, 2)
    hold on
    plot(mCDF_hat, eCDF_hat, 'k', 'LineWidth', 2)
    plot([0 1], [0 1] + ci, '--k', 'LineWidth', 1)
    plot([0 1], [0 1] - ci, '--k', 'LineWidth', 1)
    hold off
    xlabel('Model CDF')
    ylabel('Emirical CDF')
    xlim([0 1])
    ylim([0 1])
    title('KS Plot')
    set(gca, 'FontSize', 14)
   
    % It seems like the Mexican Hat Splines actually fit our data worse than
    % the regular Gaussian Splines.
    
end