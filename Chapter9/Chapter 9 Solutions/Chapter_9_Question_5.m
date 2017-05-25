function Chapter_9_Question_5()
    % Question 5 - Create 2D Place Cell Model
    
    %2D Model: 
    % version 1: lambda(t) = exp( b0 + b1*X(t) + b2*X(t).^2 + b3*X(t) + b4*Y(t).^2)
    % version 2: see PDF for clear equation
    
    %Create My Own 2D Place Cell
    muX = 50; %model center (in x position (cm))
    muY = 75; %model center (in y position (cm))
    sigmaX = 10; %model size (in x position (cm))
    sigmaY = 16; %model size/variance (in y position (cm))
    alpha = 40/1000; %max firing rate (40 spk/sec, or .04 spk/millisec)
    %   Using these defined parameters, I expect the field to be halfway in the
    %   X direction and 3/4 in the Y direction. The X direction should have
    %   less variance than the Y direction.
    
    %Create Magically Teleporting Mouse
    %   Note: Movement in X and Y position is random and not consistent such
    %   that plotting the position (X(t), Y(t)) will be random. This isn't a
    %   problem because we are just trying to see if we can correctly recover
    %   the place field using the GLM, which isn't dependent on speed or 
    %   direction as I have written it.
    posX = randi([0 100], 200000, 1); %get random X location
    posY = randi([0 100], 200000, 1); %get random Y location
    
    %Generate Lambda According to Version 2 of the Model 
    xInfo = ((posX - muX).^2) ./ sigmaX^2;
    yInfo = ((posY - muY).^2) ./ sigmaY^2;
    lambda = alpha*exp(-1*xInfo + -1*yInfo);
    
    %Generate Spikes According to Lambda
    fake_spikes = poissrnd(lambda);
    
    %Visualize Spikes
    spike_inds = find(fake_spikes == 1);
    figure()
    scatter(posX(spike_inds), posY(spike_inds), 'k', 'filled')
    xlabel('X Position (cm)')
    ylabel('Y Position (cm)')
    title('Spike Time Locations')
    xlim([0 100])
    ylim([0 100])
    set(gca, 'FontSize', 14)
    
    %Use Version 1 of Model And Equations From Book/PDF To Recover Estimates
    %for Mu, Sigma, and Alpha
    [b, dev, stats] = glmfit([posX posX.^2 posY posY.^2], fake_spikes, 'poisson', 'log');
    muX_est = -b(2)/(2*b(3));
    muY_est = -b(4)/(2*b(5));
    sigmaX_est = sqrt(-1/(2*b(3)));
    sigmaY_est = sqrt(-1/(2*b(5)));
    alpha_est = exp( b(1) - b(2).^2/(4*b(3)) - b(4).^2/(4*b(5)) );
    %   Everything except the sigma estimates are calculated well.
    
end