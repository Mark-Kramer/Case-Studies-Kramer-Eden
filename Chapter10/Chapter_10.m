%% Chapter 10, Step 1.

load('Ch10-spikes-1.mat')	%Load the spike data.

imagesc(t,1:50,train)				%Construct a rastergram.
colormap(1-gray);					%...and change the colormap.

Ltrials = find(direction==0);			%Find left trials,
Rtrials = find(direction==1);			%...and right trials.
subplot(2,1,1)
imagesc(t,1:25, train(Ltrials,:))		%Image left trials,
subplot(2,1,2)
imagesc(t,1:25, train(Rtrials,:))		%...and right trials.

PSTH = sum(train)/50/1e-3;				%Compute PSTH, 1 ms bins.

[spiketimes spiketrials]=find(train');	%Find when spikes occur,
PSTH=hist(spiketimes, 1:2000)/50/1e-3;	%... compute histogram.
bar(t,PSTH);							%Display the PSTH.

PSTH10 = hist(spiketimes, 1:10:2000);	%Compute histogram.
bar(t(1:10:2000),PSTH10/50/10*1000);	%...and display PSTH.

i_plan = find(t < 0);					%Indices for planning.
i_move = find(t >= 0);					%Indices for movement.
%Compute the average spike rate,
PlanRate=mean(mean(train(:,i_plan)))/1e-3;%...during planning,
MoveRate=mean(mean(train(:,i_move)))/1e-3;%...during movement.

Ltrials = find(direction==0);			%Find left trials,
Rtrials = find(direction==1);			%... and right trials.
LRate=mean(mean(train(Ltrials,:)))/1e-3;	%... and compute rates.
RRate=mean(mean(train(Rtrials,:)))/1e-3;

PlanL = sum(train(Ltrials,i_plan),2);	%Firing rate L, planning.
PlanR = sum(train(Rtrials,i_plan),2);	%Firing rate R, planning.
MoveL = sum(train(Ltrials,i_move),2);	%Firing rate L, movement.
MoveR = sum(train(Rtrials,i_move),2);	%Firing rate R, movement.
boxplot([PlanL PlanR MoveL MoveR], ...	%Display results.
  'labels',{'Plan Left','Plan Right','Move Left','Move Right'});

ISIs=diff(spiketimes);	%Determine ISIs for all time & trials.
ISIs=ISIs(find(ISIs>0));%Remove spurious values between trials,
hist(ISIs,0:250)		%...and display results.

%In the planning period,				%...find spikes,
[spiketimesPlan spiketrials]=find(train(:,i_plan)');
PlanISIs = diff(spiketimesPlan);		%...compute ISIs,
PlanISIs = PlanISIs(find(PlanISIs>0));	%...drop spurious ones,
subplot(211); hist(PlanISIs,0:250)		%...and plot it,
xlabel('Interspike interval [ms]')		%...with axes labelled.
ylabel('Count')

%In the movement period,				%...find spikes,
[spiketimesMove spiketrials] = find(train(:,i_move)');
MoveISIs = diff(spiketimesMove);		%...compute ISIs,
MoveISIs = MoveISIs(find(MoveISIs>0));	%...drop spurious ones,
subplot(212); hist(MoveISIs,0:250)		%...and plot it,
xlabel('Interspike interval [ms]')		%...with axes labelled.
ylabel('Count')

for k=1:50								%For each trial,
 plan = train(k,i_plan);				%...get planning data,
 move = train(k,i_move);				%...get movement data,
 acf1(k,:)=xcorr(plan-mean(plan),'coeff');%...compute ACFs,
 acf2(k,:)=xcorr(move-mean(move),'coeff');
end										%...and plot results,
subplot(211); stem(1:100,mean(acf1(:,1001:1100)));
ylabel('Autocorrelation')				%... with axes labelled.
subplot(212); stem(1:100,mean(acf2(:,1001:1100)));
ylabel('Autocorrelation');  xlabel('Lag [ms]')

%% Chapter 10, Step 2.

%Set the parameters of the MTM.
TW = 4;						%Choose time-bandwidth product of 4.
ntapers=2*TW-1;				%...which sets the # of tapers.
params.Fs=1000;				%Define sampling frequency,
params.tapers=[TW,ntapers];	%...time-band product,# tapers.
params.fpass=[0 500];		%Define frequency range to examine.
params.trialave=1;			%Perform trial averaging.

%Compute the coherence during planning & movement.
[SPlan,f]=mtspectrumpb(train(:,i_plan)',params);
[SMove,f]=mtspectrumpb(train(:,i_move)',params);

%Plot the spectra ... with axes labelled.
subplot(211); plot(f,SPlan); ylabel('Power [Hz]')
subplot(212); plot(f,SMove); ylabel('Power [Hz]')
xlabel('Frequency [Hz]')

%Set the parameters of the MTM.
movingwin = [.5 .05];		%Define window duration & step size,
params.fpass = [0 50];		%...frequency range to examine,
params.tapers = [2 3];		%...time-band product, # tapers.
[S,T,F]=mtspecgrampb(train',movingwin,params); %Get spectrogram,
T = T+t(1)/1000;			%Set time axis,
imagesc(T,F,S')				%...and display it,
xlabel('Time [s]')			%...with axes labelled.
ylabel('Frequency [Hz]')

%% Chapter 10, Step 3.

K = 50;                                 %# trials.
T0 = length(t);                         %# time points.
Imove=ones(K,1)*[zeros(1,T0/2) ones(1,T0/2)]; %Move indicator.
Imove=reshape((Imove)',K*T0,1);			%Reshape indicator
y = reshape(train',K*T0,1);				%Reshape spikes.
[b1 dev1 stats1] = glmfit(Imove,y,'poisson');%Fit Model 1.

%Compute CI for firing rate modulation during movement period, 
CI_lower = exp(b1(2)-2*stats1.se(2));	%...lower CI,
CI_upper = exp(b1(2)+2*stats1.se(2));	%...upper CI.

pval = stats1.p(2);		%p-value from Wald test.

lambda1=exp(b1(1)+b1(2)*Imove);		%Firing rate of Model 1.

spikeindex=find(y);					%Find spikes,
N=length(spikeindex);				%...and total # spikes.
Z(1)=sum(lambda1(1:spikeindex(1)));	%1st rescaled waiting time,
for i=2:N,							%...and the rest.
     Z(i)=sum(lambda1(spikeindex(i-1)+1:spikeindex(i)));
end

[eCDF, zvals] = ecdf(Z);			%Empirical CDF at z values.
mCDF = 1-exp(-zvals);				%Model CDF at z values.
plot(mCDF,eCDF)						%Create KS-plot.
hold on								%Freeze graphics window.
plot([0 1], [0 1]+1.36/sqrt(N))		%Upper confidence bound.
plot([0 1], [0 1]-1.36/sqrt(N))		%Lower confidence bound.
hold off							%Release graphics window.
xlabel('Model CDF')					%Label the axes.
ylabel('Empirical CDF')

%% Chapter 10, Refining the model: movement direction.

%Create indicator for trial movement direction.
xdir = reshape((direction*ones(1,T0))',K*T0,1);

i0 = find(xdir==0);		%Left movement trial.
i1 = find(xdir==1);		%Right movement trial.
R = cumsum(stats1.resid);%Cumulative sum of Model 1 residuals.
plot(i0,R(i0),'.')      %Plot residuals for L trials,
hold on                 %...freeze graphics,
plot(i1,R(i1),'g.')		%...and plot residuals for R trials,
hold off				%...release graphics,
xlabel('Trial')			%...label axes.
ylabel('Integrate Point Process Residual')

%Fit Model 2, and return estimates and useful statistics.
[b2 dev2 stats2] = glmfit([Imove xdir],y,'poisson');

pval=stats2.p(3);	%Significance of Model 2 direction parameter.

lambda2=exp(b2(1)+b2(2)*Imove+b2(3)*xdir);	%Evaluate Model 2.
Z(1)=sum(lambda2(1:spikeindex(1)));	%1st rescaled waiting time,
for i=2:N							%... and the rest.
  Z(i)=sum(lambda2(spikeindex(i-1)+1:spikeindex(i)));
end
[eCDF, zvals]=ecdf(Z);				%Empirical CDF.
mCDF = 1-exp(-zvals);				%Model CDF.
plot(mCDF,eCDF)						%Create KS-plot.
hold on								%Freeze graphics.
plot([0 1], [0 1]+1.36/sqrt(N))		%Upper confidence bound.
plot([0 1], [0 1]-1.36/sqrt(N))		%Lower confidence bound.
hold off							%Release graphics window.
xlabel('Model CDF')					%Label the axes.
ylabel('Empirical CDF')

%% Chapter 10, Refining the model: history dependence.

ord = 70;					%Set the model order.

T1 = T0-ord;				%Update # time points.
%Redefine observable & predictors to support history dependence.
y=reshape(train(:,ord+1:end)', K*T1,1);				%Data.
xdir=reshape((direction*ones(1,T1))',K*T1,1);		%Direction.
Imove=ones(K,1)*[zeros(1,T0/2-ord) ones(1,T0/2)];	%Period,
Imove=reshape((Imove)',K*T1,1);						%...reshaped.
xHist = [];					%Create the history predictor,
for i = 1:ord				%...for each step in past.
    xHist=[xHist reshape(train(:,ord+1-i:end-i)',K*T1,1)];
end

%Fit Model 3, with history dependence.
[b3 dev3 stats3] = glmfit([Imove xdir xHist],y,'poisson');

%Fit Model 4, with history dependence in each period.
[b4 dev4 stats4] = glmfit([Imove xdir ...	%Period & direction.
  ((1-Imove)*ones(1,ord)).*xHist ...		%History in planning.
  (Imove*ones(1,ord)).*xHist], y,'poisson');%History in movement.

%Examine first three exponentiated parameters of Model 4.
exp(b4(1:3))

subplot(211); plot(1:ord,exp(b4(4:ord+3)));		%Planning,
ylabel('Modulation')							%..axes labelled.
subplot(212); plot(1:ord,exp(b4(ord+4:end)));	%Movement,
ylabel('Modulation'); xlabel('Lag [ms]')		%..axes labelled.

subplot(211)
plot(1:ord,-log(stats4.p(4:3+ord)),'.')	%p-values for Planning,
hold on									%...freeze graphics,
plot([1 ord],[-log(.05) -log(.05)]);	%...draw threshold,
hold off								%...release graphics.
subplot(212)					
plot(1:ord,-log(stats4.p(4+ord:end)),'.')%p-values for Movement
hold on									%...freeze graphics,
plot([1 ord],[-log(.05) -log(.05)]);	%...draw threshold,
hold off								%...release graphics.

pval = 1-chi2cdf(dev3-dev4,ord);		%Compare two nested GLMs.

lambda4 = glmval(b4,[Imove xdir ...	%Evaluate Model 4.
    ((1-Imove)*ones(1,ord)).*xHist ...
    (Imove*ones(1,ord)).*xHist],'log');
spikeindex=find(y);					%Find spikes,
N=length(spikeindex);				%...and total # spikes.
Z(1)=sum(lambda4(1:spikeindex(1)));	%1st rescaled waiting time,
for i=2:N							%... and the rest.
  Z(i)=sum(lambda4(spikeindex(i-1)+1:spikeindex(i)));
end
[eCDF, zvals]=ecdf(Z);				%Empirical CDF.
mCDF = 1-exp(-zvals);				%Model CDF.
plot(mCDF,eCDF)						%Create KS-plot.
hold on								%Freeze graphics.
plot([0 1], [0 1]+1.36/sqrt(N))		%Upper confidence bound.
plot([0 1], [0 1]-1.36/sqrt(N))		%Lower confidence bound.
hold off							%Release graphics window.
xlabel('Model CDF')					%Label the axes.
ylabel('Empirical CDF')

%% Chapter 10, Choice of model order.

maxord = 100;       	%Maximum model order.
%Redefine observable & predictors to support history dependence.
yplan=reshape(train(:,maxord+1:T0/2)',K*(T0/2-maxord),1);
plandir=reshape((direction*ones(1,T0/2-maxord))',...
	K*(T0/2-maxord),1);
planHist=[];			%Create the history predictor,
for i=1:maxord			%...for each step in past,
 planHist=[planHist ...	%...define history,
   reshape(train(:,maxord+1-i:T0/2-i)',K*(T0/2-maxord),1)];
 						%..fit the model,
 [b0 dev0 stats0]=glmfit([plandir planHist],yplan,'poisson');
 						%...and compute the AIC.
 aic(i) = dev0+2*length(b0);
end
plot(1:maxord,aic);     %Plot the AIC,
xlabel('Model Order')   %...with axes labelled,
ylabel('AIC')

%% Chapter 10, Refining the model: smooth history dependence.

for i=1:ord		%Construct the Gaussian kernels.
    C(i,:) = normpdf(-5:10:ord,i,5);
end

%Fit Model 5, with Gaussian kernel basis.
nparams = size(C,2);
[b5 dev5 stats5] = glmfit([Imove xdir ...	%Period & direction.
  ((1-Imove)*ones(1,nparams)).*(xHist*C) ...%History in planning.
  (Imove*ones(1,nparams)).*(xHist*C)], ...	%History in movement.
  y,'poisson');

subplot(211);plot(1:ord,exp(C*b5(4:nparams+3)));%Planning,
ylabel('Modulation')							%..axes labelled.
subplot(212);plot(1:ord,exp(C*b5(nparams+4:end)));%Movement,
ylabel('Modulation'); xlabel('Lag [ms]')		%..axes labelled.

lambda5 = glmval(b5,[Imove xdir ...	%Evaluate Model 5.
  ((1-Imove)*ones(1,nparams)).*(xHist*C) ...
  (Imove*ones(1,nparams)).*(xHist*C)],'log');
spikeindex=find(y);					%Find spikes,
N=length(spikeindex);				%...and total # spikes.
Z(1)=sum(lambda5(1:spikeindex(1)));	%1st rescaled waiting time,
for i=2:N							%... and the rest.
  Z(i)=sum(lambda5(spikeindex(i-1)+1:spikeindex(i)));
end;
[eCDF, zvals]=ecdf(Z);				%Empirical CDF.
mCDF = 1-exp(-zvals);				%Model CDF.
plot(mCDF,eCDF)						%Create KS-plot.
hold on								%Freeze graphics.
plot([0 1], [0 1]+1.36/sqrt(N))		%Upper confidence bound.
plot([0 1], [0 1]-1.36/sqrt(N))		%Lower confidence bound.
hold off							%Release graphics window.
xlabel('Model CDF')					%Label the axes.
ylabel('Empirical CDF')

%% Chapter 10, Step 4.

subplot(211)							%p-values for Planning,
plot(1:nparams,-log(stats5.p(4:3+nparams)),'.')
hold on									%...freeze graphics,
plot([1 nparams],[-log(.05) -log(.05)])	%...draw threshold,
hold off								%...release graphics.
subplot(212)							%p-values for Movement,
plot(1:nparams,-log(stats5.p(4+nparams:end)),'.')
hold on									%...freeze graphics,
plot([1 nparams],[-log(.05) -log(.05)])	%...draw threshold,
hold off								%...release graphics.

%Fit a reduced version of Model 5,
[b6 dev6 stats6] = glmfit([Imove xdir xHist*C],y,'poisson');

p=1-chi2cdf(dev6-dev5,nparams);	%Compare Model 5 and reduction.