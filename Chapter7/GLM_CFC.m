%Function to apply GLM-CFC procedure.
%
%INPUTS.
%  Vlo = low frequency band signal.
%  Vhi = high frequency band signal.
%  nCtlPts = the number of control points to use in the spline fitting of phase.
%
%OPTIONAL INPUT.
%  The 4th input is optional.  Set the 4th input to:
%    'noplot' to prevent plotting of results.
%
%OUTPUTS.
%  r = the GLM-CFC measure.
%  r_CI = the 95% confidence intervals for r.
%  nCtlPts = the number of control points used.
%
%  By default, this function plots the results.

function [r, r_CI] = GLM_CFC(Vlo, Vhi, nCtlPts, varargin)

  %Compute phase and amplitude.
  phi = angle(hilbert(Vlo));
  amp = abs(hilbert(Vhi));
  
  %Define variables for GLM procedure.
  Y = amp'; 
  X = spline_phase0(phi',nCtlPts);
  XC = ones(size(Y));  

  %Perform GLM.
  [b,  ~, stats]  = glmfit(X,  Y, 'gamma', 'link', 'log', 'constant', 'off');
  [bC, ~, statsC] = glmfit(XC, Y, 'gamma', 'link', 'log', 'constant', 'off');

  %Define dense phase points for interpolation.
  phi0 = linspace(-pi,pi,100);
  X0 = spline_phase0(phi0',nCtlPts);

  %Determine spline fit and CI.
  [spline0, dylo, dyhi] = glmval(b,X0,'log',stats,'constant', 'off');
  splineU = spline0+dyhi;
  splineL = spline0-dylo;

  %Determine null fit and CI.
  [null0, dylo, dyhi] = glmval(bC,ones(size(phi0)),'log',statsC,'constant', 'off');
  nullU = null0+dyhi;
  nullL = null0-dylo;

  %Find the max absolute percentage change between the two models.
  [r imx] = max(abs(1-spline0./null0));

  %Determine CI for the measure r.
  M = 10000;
  bMC = b*ones(1,M) + sqrtm(stats.covb)*normrnd(0,1,nCtlPts,M);
  splineMC = glmval(bMC,X0,'log',stats,'constant', 'off');
  nullMC   = mean(splineMC,1);
  mx = zeros(M,1);
  for k=1:M
      mx(k) = max(abs(1-splineMC(:,k)./nullMC(k)));
  end
  r_CI = quantile(mx, [0.025, 0.975]);

  %Plot the results.
  if isempty(varargin) || ~strcmp(varargin{1}, 'noplot')
      plot(phi0, spline0, 'r', 'LineWidth', 2)
      hold on
      plot(phi0, splineU, ':r', 'LineWidth', 2)
      plot(phi0, splineL, ':r', 'LineWidth', 2)
      plot(phi0, null0, 'k', 'LineWidth', 2)
      plot(phi0, nullL, 'k:', 'LineWidth', 2)
      plot(phi0, nullU, 'k:', 'LineWidth', 2)
      plot([phi0(imx) phi0(imx)], [null0(imx), spline0(imx)], 'LineWidth', 2)
      hold off
      ylabel('Amplitude')
      xlabel('Phase')
      axis tight
  end
  
end

% Generate a design matrix X (n by nCtlPts) for a phase signal (n by 1)
function X = spline_phase0(phase,nCtlPts)

% Define Control Point Locations
c_pt_times_all = linspace(0,2*pi,nCtlPts+1);

s = 0.5;  % Define Tension Parameter

% Construct spline regressors
X = zeros(length(phase),nCtlPts);
for i=1:length(phase)  
    nearest_c_pt_index = max(find(c_pt_times_all<=mod(phase(i),2*pi)));
    nearest_c_pt_time = c_pt_times_all(nearest_c_pt_index);
    next_c_pt_time = c_pt_times_all(nearest_c_pt_index+1);
    u = (mod(phase(i),2*pi)-nearest_c_pt_time)/(next_c_pt_time-nearest_c_pt_time);
    p=[u^3 u^2 u 1]*[-s 2-s s-2 s;2*s s-3 3-2*s -s;-s 0 s 0;0 1 0 0];
    X(i,mod(nearest_c_pt_index-2:nearest_c_pt_index+1,nCtlPts)+1) = p;   
end

end
