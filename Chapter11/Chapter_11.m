%% Chapter 11, Step 1.

load('Ch11-spikes-LFP-1.mat')	%Load the multiscale data,
plot(t, y(1,:))					%...and plot LFP in 1st trial,
hold on							%...freeze graphics,
plot(t, n(1,:),'k')				%...and plot spikes in 1st trial,
hold off						%...release graphics,
xlabel('Time [s]')				%...and label axis.

win = 100;				%Choose a window size of +/- 100 ms.
K = size(n,1);			%Define the # trials.
N = size(y,2);			%Define # data points per trial.
STA=zeros(K,2*win+1);	%Create a variable to hold the STA,
for k=1:K				%For each trial,
  spks=find(n(k,:)==1); %...find the spikes,
  for i=1:length(spks)	%...and for each spike,
    if (spks(i) > win & spks(i)+win<N)  %...average the LFP.
      STA(k,:)=STA(k,:)+y(k,spks(i)-win:spks(i)+win)/length(spks);
    end
  end
end

dt = t(2)-t(1);		%Define the sampling interval.
fNQ = 1/dt/2;		%Define Nyquist frequency.
Wn = [9,11]/fNQ;	%Set the passband,
ord  = 100;			%...and filter order,
b  = fir1(ord,Wn);	%...build bandpass filter.

FTA=zeros(K,N);		%Create a variable to hold the FTA,
for k=1:K			%For each trial, 
 Vlo = filtfilt(b,1,y(k,:));%... apply the filter,
 phi = angle(hilbert(Vlo));	%... and compute the phase,
 [~,indices] = sort(phi);	%... then sort the phase,
 FTA(k,:) = n(k,indices);	%... and store the sorted spikes.
end
%Plot the average FTA versus phase.
plot(linspace(-pi,pi,N), mean(FTA,1))

%% Chapter 11, Step 2.

dt = t(2)-t(1);				%Define the sampling interval.
Fs = 1/dt;					%Define the sampling frequency.
TW = 3;						%Choose time-bandwidth product of 3.
ntapers = 2*TW-1;			%Choose the # of tapers.
%Set the parameters of the MTM.
params.Fs = Fs;				%... sampling frequency
params.tapers=[TW,ntapers];	%... time-bandwidth product & tapers.
params.pad = -1;			%... no zero padding.
params.trialave = 1;		%... trial average.
%Compute the MTM coherence.
[C,~,~,Syy,Snn,f]=coherencycpb(transpose(y),transpose(n),params);

load('Ch11-spikes-LFP-1.mat')	%Reload the multiscale data,
y = 0.1*y;						%...and scale the LFP.

load('Ch11-spikes-LFP-1.mat')		%Reload the multiscale data.
thinning_factor = 0.5;				%Choose a thinning factor.
for k=1:size(n,1)					%For each trial,
 spikes = find(n(k,:)==1); 			%...find the spikes.
 n_spikes = length(spikes);			%...determine # of spikes.
 spikes=spikes(randperm(n_spikes));	%...permute spikes indices,
 n_remove=floor(thinning_factor*n_spikes);%...# spikes to remove,
 n(k,spikes(1:1+n_remove))=0;		%... remove the spikes.
end

%% Chapter 11, Step 3.

dt = t(2)-t(1);		%Define the sampling interval.
fNQ = 1/dt/2;		%Define Nyquist frequency.
Wn = [44,46]/fNQ;	%Set the passband,
ord  = 100;			%...and filter order,
b  = fir1(ord,Wn);	%...build bandpass filter.

phi=zeros(K,N);					%Create variable to hold phase.
for k=1:K						%For each trial,
  Vlo=filtfilt(b,1,y(k,:));		%...apply the filter,
  phi(k,:)=angle(hilbert(Vlo));	%...and compute the phase,
end

n = n(:);					%Convert spike matrix to vector.
phi = phi(:); 				%Convert phase matrix to vector.
X = [cos(phi) sin(phi)];	%Create a matrix of predictors.
Y = [n];					%Create a vector of responses.
[b1,dev1,stats1]=glmfit(X,Y,'poisson'); %Fit the GLM.

phi0=transpose((-pi:0.01:pi));              %Define new phase interval,
X0 = [cos(phi0) sin(phi0)];                 %...and predictors,
[y0 dylo dyhi]=glmval(b1,X0,'log',stats1);  %...evaluate the model.

pval1=stats1.p(2);          %Significance of parameter beta_1.
pval2=stats1.p(3);          %Significance of parameter beta_2.

X0 = ones(size(phi));                                       %Define reduced predictor.
[b0,dev0,stats0]=glmfit(X0,Y,'poisson','constant','off');   %Fit reduced model.

pval = 1-chi2cdf(dev0-dev1,2);      %Compare two nested GLMs.

p = mean(sum(n,2)/(N));

%% Chapter 11, Problems.

K = 100;		%Define # trials.
N = 1000;		%Define # samples per trial.
dt = 0.001;		%Define sampling interval.

y = zeros(K,N);         %Matrix to hold field data.
n = zeros(K,N);         %Matrix to hold spike data.
for k=1:K               %For each trial ...
    %...define the LFP as a 10 Hz sinusoid + noise.
    y(k,:) = sin(2.0*pi*(1:N)*dt * 10)+0.1*randn(1,N);
    %...draw spikes from a Bernoulli distribution lambda=0.01
    n(k,:) = binornd(1,0.01,1,N);
end

f = 0.01;			% Parameter for scaling of rate.
b = 1;				% Parameter for background spiking.
y = zeros(K,N);		% Matrix to hold field data.
n = zeros(K,N);		% Matrix to hold spike data.
for k=1:K			% For each trial ...
  % ...define the LFP as a 10 Hz sinusoid.
  y(k,:) = sin(2.0*pi*(1:N)*dt * 10)+0.1*randn(1,N);
  % ...draw spikes from a Bernoulli distribution,
  p = f*(b+exp(y(k,:)));%...with probability dependent on LFP.
  n(k,:) = binornd(1,p,1,N);
end