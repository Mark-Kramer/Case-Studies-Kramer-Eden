function [mu, lambda] = Chapter_8_Inv_Gauss_Formula(isi)
   %INPUT:
   %    isi: vector of ISIs (in seconds)
   %OUTPUT:
   %    mu: formula-based estimate for an Inverse Gaussian distribution's mu
   %    lambda: formula-based estimate for an Inverse Gaussian distribution's lambda 
   
   %Calculate Mu
   mu = mean(isi);
   
   %Calculate Lambda
   diffs = 1./isi - 1/mu;
   lambda = 1/mean(diffs);
   
end