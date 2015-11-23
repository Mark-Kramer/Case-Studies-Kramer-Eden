%% Chapter 8, Step 1.

load('Ch8-spikes-1.mat')         %Load the spike train data.

size(SpikesLow)

T = 30;		%The duration of the recording in seconds,
n = size(SpikesLow,2);%...and # spikes in low light condition,
f = n/T;	%... to compute the firing rate.

plot(SpikesLow)

plot(SpikesLow,ones(size(SpikesLow)),'.');%Plot spikes as a row,
xlim([0 5]);							%...display times (0,5)s,
xlabel('Time [s]')						%...label the x-axis.

%Plot low light condition spikes:
plot(SpikesLow, ones(size(SpikesLow)), '.');	
hold on				%... freeze the graphics window.
%Plot high light condition spikes:
plot(SpikesHigh, 2*ones(size(SpikesHigh)), '.g');
hold off			%... release the graphics window,
xlim([0 5]);		%... and display times 0 to 5 s,
ylim([0 3]);		%... set y-axis range,
xlabel('Time [s]')	%... and label the x-axis.

%% Chapter 8, Step 2.

ISIsLow=diff(SpikesLow); %Compute ISIs in low light condition.
ISIsHigh=diff(SpikesHigh);%Compute ISIs in high light condition.

plot(ISIsLow);

bins = (0:0.001:0.5);	%Define the bins for the histogram.
hist(ISIsLow, bins)		%Plot the histogram of the ISI data,
xlim([0 0.15])			%... focus on ISIs from 0 to 150 ms,
xlabel('ISI [s]')		%... label the x-axis,
ylabel('Counts')		%... and the y-axis.

%% Chapter 8, Step 3.

time_bins = (0:0.05:30);	%Define time bins, 50ms increments, 
%... compute a histogram of spike time data,
IncrementsLow50 = hist(SpikesLow,time_bins);
%... and plot the resulting counts versus time,
plot(time_bins,IncrementsLow50,'.')
ylabel('Number of spikes')	%... with x-axis labelled,
xlabel('Time [s]')			%... and y-axis labelled.

FF50Low = var(IncrementsLow50)/mean(IncrementsLow50)

length(IncrementsLow50)

N =length(IncrementsLow50);	%Determine number of time bins.
FF=(0.5:0.001:1.5);			%Define possible FF values for plot,
Y=gampdf(FF,(N-1)/2,2/(N-1));%... compute gamma distribution,
plot(FF,Y);					%... and plot it.

gaminv([.025,.975],(N-1)/2,2/(N-1))

%% Chapter 8, Step 4.

%Compute autocorrelation of increments process for low light.
xcorr(IncrementsLow50-mean(IncrementsLow50),3,'coeff')

%Define time bins, 1 ms increments,
time_bins = (0:0.001:30);
% ... compute histogram to create increments process, 
IncrementsLow1 = hist(SpikesLow,time_bins);
%... and then compute the autocorrelation function.
ACFLow = xcorr(IncrementsLow1-mean(IncrementsLow1),100,'coeff');

plot(-100:100,ACFLow,'.')		%Plot autocorrelation vs lags,
N1 = length(IncrementsLow1);	%... compute the sample size,
%... and plot the upper and lower significance lines,
line([-100 100], [2/sqrt(N1) 2/sqrt(N1)])
line([-100 100],-[2/sqrt(N1) 2/sqrt(N1)])
xlim([-100, 100])				%... set x-limits,
ylim([-0.1, 0.1])				%... and y-limits.

%Define time bins (1 ms increments), compute increments & ACF.
time_bins = (0:0.001:30);
IncrementsHigh1 = hist(SpikesHigh,time_bins);
ACFHigh=xcorr(IncrementsHigh1-mean(IncrementsHigh1),100,'coeff');
%Plot the autocorrelation vs lags with significance lines.
plot(-100:100,ACFHigh,'.')
N2 = length(IncrementsHigh1);
line([-100 100], [2/sqrt(N2) 2/sqrt(N2)])
line([-100 100],-[2/sqrt(N2) 2/sqrt(N2)])
xlim([-100, 100])				%... set x-limits,
ylim([-0.1, 0.1])				%... and y-limits.

ACFDiff=ACFHigh-ACFLow;	%Compute difference of autocorrelations,
% ... and plot it with upper and lower significance lines,
plot(-100:100,ACFDiff,'.')
line([-100 100], [2*sqrt(1/N1+1/N2) 2*sqrt(1/N1+1/N2)])
line([-100 100],-[2*sqrt(1/N1+1/N2) 2*sqrt(1/N1+1/N2)])
xlim([-100, 100])				%... set x-limits,
ylim([-0.1, 0.1])				%... and y-limits.

%% Chapter 8, Step 5.

%Compute and plot the autocorrelation of the low light ISIs,
ISI_ACF_Low = xcorr(ISIsLow-mean(ISIsLow),20,'coeff');
plot(-20:20, ISI_ACF_Low, '.')
%... with upper and lower significance lines,
N3 = length(ISIsLow);
line([-20 20], [2/sqrt(N3) 2/sqrt(N3)])
line([-20 20],-[2/sqrt(N3) 2/sqrt(N3)])
xlim([-20, 20])				%... set x-limits,
ylim([-0.2, 0.2])			%... and y-limits.

%% Chapter 8, Step 6.

bins = (0:0.001:0.5);			%Define 1 ms bins for histogram, 
counts = hist(ISIsLow, bins);	%...compute histogram of ISIs,
prob = counts/length(ISIsLow);	%...convert to probability, 
bar(bins, prob);				%...and plot it, 
xlim([0 0.15])					%...with fixed x-limits,
xlabel('ISI [s]')				%...and with x-axis labeled,
ylabel('Probability')			%...and y-axis labeled.

lambda = 5;						%Choose a value for lambda, 
model = lambda*exp(-lambda*bins)*0.001;	%...and create model,
hold on							%...freeze the graphics window,
plot(bins,model, 'r');			%...plot the model in red,
hold off						%...and release the window.

lambdas = 0:1:50;			%Range of lambda values.
N3 = length(ISIsLow);		%Number of low light ISIs observed.
L = lambdas.^N3.*exp(-lambdas*sum(ISIsLow));%Compute likelihood,
plot(lambdas,L)				%...and plot it.

lambdas = 0:1:50;			%Range of lambda values.
N3 = length(ISIsLow);		%Number of low light ISIs observed.
l = N3*log(lambdas)-lambdas*sum(ISIsLow);%Compute log likelihood,
plot(lambdas,l)				%...and plot it.

%Compute observed difference in lambdas,
MLDiff = 1/mean(ISIsHigh)-1/mean(ISIsLow);
%And then perform the bootstrap analysis.
ISIs  = [ISIsLow ISIsHigh];	%Merge all ISIs.
Nall = length(ISIs);		%Save length of all ISIs.
Nlo = length(ISIsLow);		%Save length of low light condition.
Nhi = length(ISIsHigh);     %Save length of high light condition.
for i = 1:1000				%For each bootstrap sample,	
 sampLo=ISIs(randsample(Nall,Nlo,1)); %...resample low light ISIs,
 sampHi=ISIs(randsample(Nall,Nhi,1)); %...resample low light ISIs,
 SampDiff(i)=1/mean(sampHi)-1/mean(sampLo);%...and difference.
end
hist(SampDiff,30)			%Plot resampled ISIs distribution,
line([MLDiff MLDiff],[0 100]);%... and the empirical ISIs.

%%

bins = (0:0.001:0.5);			%Define 1 ms bins for histogram.
counts = hist(ISIsLow, bins);	%Compute histogram,
prob = counts/length(ISIsLow);	%... convert to probability,
bar(bins, prob);				%... and plot probability.
lambda = 1/mean(ISIsLow); 		%Compute best guess for lambda,
model = lambda*exp(-lambda*bins)*.001; %... build the model,
hold on                                %... and plot it.
plot(bins, model, 'r')
hold off
xlim([0 0.15])					%... xlim from 0 to 150 ms,
xlabel('ISI [s]')				%... label the x-axis,
ylabel('Probability')			%... and label the y-axis.

%%

bins = (0:0.001:0.5);			%Define 1 ms bins for histogram.
lambda = 1/mean(ISIsLow);		%Compute best guess for lambda,
FmodLow = 1-exp(-lambda*bins);	%... and define model CDF.
FempLow = cumsum(prob);			%Define empirical CDF.
plot(bins,FmodLow)				%Plot the model CDF,
hold on
plot(bins,FempLow, 'r')			%... and the empirical CDF,
hold off
xlim([0 0.2])					%... with specified x-limits.

plot(FmodLow,FempLow)	%Plot model vs empirical CDFs.
axis([0 1 0 1])			%Set the axes ranges.

plot(FmodLow,FempLow)		%Plot model vs empirical CDFs.
Nlow = length(ISIsLow);		%Length of low light condition.
%Plot the upper and lower confidence bounds,
line([0 1], [0 1]+1.36/sqrt(Nlow));
line([0 1], [0 1]-1.36/sqrt(Nlow));
axis([0 1 0 1])				%... with fixed axes.

%%  Chapter 8, A more advanced statistical model.

bins = (0:0.001:0.5);				%Define 1 ms bins.
Nlow = length(ISIsLow);				%Length low light condition.
mu=mean(ISIsLow);					%Mean of inverse Gaussian.
lambda=1/mean(1./ISIsLow-1/mu);		%... and shape parameter,
model=sqrt(lambda/2/pi./bins.^3).*...	%... to create model.
  exp(-lambda.*(bins-mu).^2/2/mu^2./bins)*.001;
model(1) = 0;

%Plot the data and the model,
counts = hist(ISIsLow, bins);	%Compute histogram,
prob = counts/length(ISIsLow);	%... convert to probability,
bar(bins, prob);				%... and plot probability.
hold on
plot(bins,model, 'r');			%Plot the model.
hold off
xlim([0 0.2])					%xlim from 0 to 200 ms.
xlabel('ISI [s]')				%Label the x-axis,
ylabel('Probability')			%... and the y-axis.

%Plot the KS plot.
FmodLow = cumsum(model);	%Define the model CDF,
FempLow = cumsum(prob);		%...and define empirical CDF,
plot(FmodLow,FempLow)		%...plot model vs empirical CDF,
line([0 1], [0 1]+1.36/sqrt(Nlow));	%...upper confidence bound,
line([0 1], [0 1]-1.36/sqrt(Nlow));	%...lower confidence bound,
axis([0 1 0 1])				%... set the axes ranges,
xlabel('Model CDF')			%... and label the axes.
ylabel('Empirical CDF')