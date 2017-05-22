function Chapter_7_Question_5()
    % Question 5 - Analyze Ch7-LFP-1.mat w/ Different GLM Parameters

    %Load Data and Define Important Information
    load('Ch7-LFP-1.mat')
    sample_interval = t(2) - t(1);
    sample_freq = 1/sample_interval;
    T = t(end);
    nyquist_freq = sample_freq/2;

    %Create Low Pass and High Pass Filters
    Wn = [5 7]/nyquist_freq;
    n = 100;
    b = fir1(n, Wn);
    Vlo = filtfilt(b, 1, LFP);
    Wn = [80 120]/nyquist_freq;
    n = 100;
    b = fir1(n, Wn);
    Vhi = filtfilt(b, 1, LFP);

    %Method 2: GLM
    n_ctrl_pts = [2, 4, 8, 16, 24, 48];
    for i = n_ctrl_pts
        figure()
        GLM_CFC(Vlo, Vhi, i);
        title(['Control Points: ', num2str(i)])
    end
    
    % If we have fewer control points, we don't really capture the actual CFC
    % curve well. However, if we have too many, we don't get any better at
    % computing the CFC curve and instead increase the complexity of the model
    % (the number of free parameters). 

end