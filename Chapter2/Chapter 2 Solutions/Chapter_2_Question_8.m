function Chapter_2_Question_8()
    % Question 2.8 - Explore Central Limit Theorem
    
    %a) Draw Any Random Independent Numbers (I use uniform)
    large_sample = 500;
    rand_nums = rand(large_sample, 1);
    figure()
    histogram(rand_nums)
    xlabel('Uniform Random Number Value')
    ylabel('Number in Bin')
    title('Histogram of Uniform Random Numbers Between 0 and 1')
    set(gca, 'FontSize', 16)
    %   For this example, I have chosen to look at the uniform random
    %   distribution between 0 and 1. The histogram shows that, for the most
    %   part, the random numbers are uniform and are definitely contained
    %   within the interval (0, 1).
    
    %b) Compute The Mean
    mn = mean(rand_nums);
    %   I expect the mean of this to be .5, since .5 is in the middle of the
    %   interval (0, 1). Since I am sampling from this interval uniformly, I
    %   expect there to be equal amounts of numbers above and below .5.
    
    %c) Draw a Large Sample 5000 Times
    mn_vals = zeros(5000, 1);
    for i = 1:5000
        rand_nums = rand(large_sample, 1);
        mn_vals(i) = mean(rand_nums);
    end
    figure()
    histogram(mn_vals)
    xlabel('Means of Large Sample of Uniform Random Numbers')
    ylabel('Number in Bin')
    title('Histogram of Means of Large Sample of Uniform Random Numbers Between 0 and 1')
    set(gca, 'FontSize', 16)
    %   This histogram clearly shows that the mean is Normally distributed with
    %   a mean equal to .5. 
    
    %d) Repeat a-c But With Another Random Sample Generator
    %   I will use a Poisson Distribution to draw Random Samples From
    poisson_rate = 1;
    rand_nums = poissrnd(poisson_rate, [large_sample, 1]);
    figure()
    histogram(rand_nums)
    xlabel('Poisson Random Number Value')
    ylabel('Number in Bin')
    title('Histogram of Poisson Distributed Random Numbers')
    set(gca, 'FontSize', 16)
    %   For this example, I have chosen to look at the Poisson distribution
    %   with a rate of 1. The histogram shows that, while the right hand side
    %   (higher numbers) can occur, most numbers stay around 0 or 1. In fact,
    %   if you look at any statistics textbook, 1 is actually the theoretical
    %   mean of a series of Poisson Random Numbers.
    
    %Compute The Mean
    mn = mean(rand_nums);
    %   I expect the mean of this to be 1, since statistical textbooks say that
    %   the mean of a poisson distribution is equal to its' rate parameter.
    %   Further (although your histogram may vary), by histogram shows a peak
    %   at the value 1.
    
    %Draw a Large Sample 5000 Times
    mn_vals = zeros(5000, 1);
    for i = 1:5000
        rand_nums = poissrnd(poisson_rate, [large_sample, 1]);
        mn_vals(i) = mean(rand_nums);
    end
    figure()
    histogram(mn_vals)
    xlabel('Means of Large Sample of Poisson Random Numbers')
    ylabel('Number in Bin')
    title('Histogram of Means of Large Sample of Poisson Random Numbers')
    set(gca, 'FontSize', 16)
    %   This histogram clearly shows that the mean is Normally distributed with
    %   a mean equal to 1, our original Poisson rate parameter. 
     
end