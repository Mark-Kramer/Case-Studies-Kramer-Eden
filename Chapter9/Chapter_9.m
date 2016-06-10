%% Chapter 9, Step 1.

load('Ch9-spikes-1.mat')	%Load the place field data
plot(t,X)					%... and plot the rat's position.
xlabel('Time [s]');			%... with axes labelled.
ylabel('Position [cm]')

%Histogram spikes into bins centered at times t.
spiketrain = hist(spiketimes,t)';

plot(t,X)                   %Plot the position.
hold on                     %Freeze graphics window.
plot(t,10*spiketrain,'g')   %Plot the spikes.
hold off                    %Release graphics window.
xlabel('Time [sec]')        %Label the axes.
ylabel('Position [cm]')

spikeindex=find(spiketrain);	%Deterime index of each spike.

plot(t,X)					%Plot the position.
hold on						%Freeze graphics window.
plot(t(spikeindex),X(spikeindex),'r.')%Plot spikes @ positions.
hold off					%Release graphics window.
xlabel('Time [sec]')		%Label the axes.
ylabel('Position [cm]')

bins=0:10:100;					%Define spatial bins.
spikehist=hist(X(spikeindex),bins);%Histogram positions @ spikes.
occupancy=hist(X,bins)*0.001;	%Convert occupancy to seconds.
bar(bins,spikehist./occupancy); %Plot results as bars.
xlabel('Position [cm]')			%Label the axes.
ylabel('Occupancy normalized counts (spikes/s)')

%% Chapter 9, Step 2.

%Fit Model 1 to the spike train data.
b=glmfit(X,spiketrain,'poisson','identity');

bar(bins,spikehist./occupancy);		%Plot occupancy norm. hist.
hold on;                        	%Freeze graphics.
plot(bins,(b(1)+b(2)*bins)*1000,'r');%Plot model.
hold off                        	%Release graphics.
xlabel('Position [cm]')			%Label the axes.
ylabel('Occupancy normalized counts (spikes/s)')

%% Chapter 9, Step 3.

%Fit Model 2 to the spike train data.
b2=glmfit(X,spiketrain,'poisson','log');

%Fit Model 2 to the spike train data (omitting last input).
b2=glmfit(X,spiketrain,'poisson');

bar(bins,spikehist./occupancy);		%Plot occupancy norm. hist.
hold on;                        	%Freeze graphics.
plot(bins,exp(b2(1)+b2(2)*bins)*1000,'r');	%Plot Model 2.
hold off                        	%Release graphics.
xlabel('Position [cm]')				%Label the axes.
ylabel('Occupancy normalized counts (spikes/s)')

%Fit Model 3 to the spike train data (omitting last input).
b3=glmfit([X X.^2],spiketrain,'poisson');

bar(bins,spikehist./occupancy);		%Plot occupancy norm. hist.
hold on;                        	%Freeze graphics.
plot(bins,exp(b3(1)+b3(2)*bins+b3(3)*bins.^2)*1000,'r');%Model 3.
hold off                        	%Release graphics.
xlabel('Position [cm]')				%Label the axes.
ylabel('Occupancy normalized counts (spikes/s)')

%Compute maximum likelihood estimates of:
mu=-b3(2)/2/b3(3);                  %...place field center,
sigma=sqrt(-1/(2*b3(3)));           %...place field size,
alpha=exp(b3(1)-b3(2)^2/4/b3(3));   %...max firing rate.

%%  Chapter 9, Step 4.

lambda2=exp(b2(1)+b2(2)*X);		%Use Poisson rate function,
LL2=sum(log(poisspdf(spiketrain,lambda2)));%..and log likelihood,
AIC2 = -2*LL2+2*2;				%...to find AIC for Model 2.

%Compute the AIC for Model 3.
AIC3 = -2*sum(log(poisspdf(spiketrain, ...
                    exp(b3(1)+b3(2)*X+b3(3)*X.^2))))+2*3;

dAIC=AIC2-AIC3;		%Difference in AIC between Models 1 and 2.

%Fit Model 2 and Model 3, and compute difference in AIC.
[b2 dev2 stats2]=glmfit(X,spiketrain,'poisson');
[b3 dev3 stats3]=glmfit([X X.^2],spiketrain,'poisson');
dAIC=(dev2+2*2)-(dev3+2*3);

p=1-chi2cdf(dev2-dev3,1);	%Compare Models 2 and 3, nested GLMs.

%Compute 95% CI for parameters of Model 2.
CI2=[b2-2*stats2.se b2+2*stats2.se];

eCI2 = exp(CI2);	%Exponentiate Model 2 CIs.

%Compute 95% CI for parameters of Model 3.
CI3 = [b3-2*stats3.se b3+2*stats3.se];

p_beta2 = stats3.p(3);	%Significance level of Model 3 parameter.

N = length(spiketimes);				%Define # of spikes.
lambda3=exp(b3(1)+b3(2)*X+b3(3)*X.^2);	%Evaluate Model 3.
Z(1)=sum(lambda3(1:spikeindex(1)));	%1st rescaled waiting time.
for i=2:N							%... and the rest.
  Z(i)=sum(lambda3(spikeindex(i-1):spikeindex(i)));
end

%Compute empirical CDF from rescaled waiting times.
[eCDF, zvals] = ecdf(Z);

mCDF = 1-exp(-zvals);				%Model CDF at z values.
plot(mCDF,eCDF)						%Create KS-plot.
hold on								%Freeze graphics window.
plot([0 1], [0 1]+1.36/sqrt(N),'k')	%Upper confidence bound.
plot([0 1], [0 1]-1.36/sqrt(N),'k')	%Lower confidence bound.
hold off							%Release graphics window.
xlabel('Model CDF')					%Label the axes.
ylabel('Empirical CDF')

R = cumsum(stats3.resid);	%Cumulative sum of Model 3 residuals.

plot(t,R)

%% Chapter 9, Step 3 (revisited).

dir = [0; diff(X)>0];

%Fit Model 4, and return estimates and useful statistics.
[b4,dev4,stats4]=glmfit([X X.^2 dir],spiketrain,'poisson');

%% Chapter 9, Step 4 (revisited).

dAIC=(dev3+2*3)-(dev4+2*4);%Difference in AIC between Models 3&4.

p=1-chi2cdf(dev3-dev4,1); %Compare Models 3 and 4, nested GLMs.

%For model 4, compute 95% CI for last parameter,
CI_beta3 = [b4(4)-2*stats4.se(4) b4(4)+2*stats4.se(4)];
p_beta3 = stats4.p(4);	%... and significance level.

lambda4=exp(b4(1)+b4(2)*X+b4(3)*X.^2+b4(4)*dir);%Eval. Model 4.
Z(1)=sum(lambda4(1:spikeindex(1)));	%1st rescaled waiting time.
for i=2:N							%... and the rest.
  Z(i)=sum(lambda4(spikeindex(i-1):spikeindex(i)));
end
[eCDF, zvals] = ecdf(Z);			%Define empirical CDF,
mCDF = 1-exp(-zvals);				%...and model CDF,
plot(mCDF,eCDF)						%...to create KS-plot.
hold on								%Freeze graphics window.
plot([0 1], [0 1]+1.36/sqrt(N),'k')	%Upper confidence bound.
plot([0 1], [0 1]-1.36/sqrt(N),'k')	%Lower confidence bound.
hold off							%Release graphics window.
xlabel('Model CDF')					%Label the axes.
ylabel('Empirical CDF')

R = cumsum(stats4.resid);	%Cumulative sum of Model 4 residuals.
plot(t,R)					%Plot it.

%% Chapter 9, Step 5.

%For Model 4, compute maximum likelihood estimates of:
mu=-b4(2)/2/b4(3);                  %...place field center,
sigma=sqrt(-1/(2*b4(3)));           %...place field size,
alpha=exp(b4(1)-b4(2)^2/4/b4(3));   %...max firing rate.

xs=(0:100)';					%Define interval of positions,
Ns=size(xs);					%...and number of positions.
%Evaluate Model 4 in direction 0 (X decreases).
[lambda4_0 up0 low0]=glmval(b4,[xs xs.^2 zeros(Ns)],'log',stats4);
%Evaluate Model 4 in direction 1 (X increases).
[lambda4_1 up1 low1]=glmval(b4,[xs xs.^2 ones(Ns)],'log',stats4);
plot(xs,lambda4_0,'b')			%Plot Model 4, X decreasing,
hold on							%...freeze graphics,
plot(xs,lambda4_0+up0,'b--')	%...add upper CI,
plot(xs,lambda4_0-low0,'b--')	%...and lower CI.
plot(xs,lambda4_1,'r')			%Plot Model 4, X increasing,
plot(xs,lambda4_1+up1,'r--')	%...add upper CI,
plot(xs,lambda4_1-low1,'r--');	%...add lower CI.
hold off						%Release graphics.

%% Chapter 9, Problems.

Y = randn(size(X));
