function [mu, lambda] = Chapter_8_Inv_Gauss_Log_Likelihood(mu_vals, lambda_vals, isi)
   %INPUT:
   %    mu_vals: range of values you'd like to test for mu
   %    lambda_vals: range of values you'd like to test for lambda
   %    isi: vector of ISIs (in seconds)
   %OUTPUT:
   %    mu: mu corresponding to highest log likelihood value
   %    lambda: lambda corresponding to highest log likelihood value 
   
   %Enforce Row/Column Vectors
   mu_vals = mu_vals(:); %column vector
   lambda_vals = lambda_vals(:)'; 
   isi = isi(:)';
   
   %Get Helpful Values
   N = length(isi);
   constant_term = (3/2) * sum(log(isi));
   
   %Use For Loop To Calculate Log Likelihood
   %    note: a matrix multiplication solution is available, but for loops are
   %    more didactic
   logL = zeros(length(mu_vals), length(lambda_vals));
   for i = 1:length(mu_vals)
       for j = 1:length(lambda_vals)
           lambda = lambda_vals(j);
           mu = mu_vals(i);
           logL(i, j) = (N/2)*log(lambda/(2*pi)) - ...
               constant_term - ...
               sum( (lambda.*(isi-mu).^2)./(2.*isi.*mu.^2) );
       end
   end
           
   %Get Mu and Lambda Values That Maximize the Log Likelihood
   linear_ind = find(logL == max(max(logL)));
   [i, j] = ind2sub(size(logL), linear_ind);
   mu = mu_vals(i);
   lambda = lambda_vals(j);
   
   %Visualize The Log Likelihood
   figure()
   imagesc(mu_vals, lambda_vals, logL')
   axis xy
   colorbar
   xlabel('Mu')
   ylabel('Lambda')
   caxis([max(max(logL)) - 100 max(max(logL))])
   title('Log Likelihood')
   set(gca, 'FontSize', 14)
   
end