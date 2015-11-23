%% Chapter 5, Step 1.

load('Ch5-ECoG-1.mat')	%Load the ECoG data.
%... and plot one trial from each electrode.
plot(t,E1(1,:), 'b', 'LineWidth', 2)
hold on
plot(t,E2(1,:), 'r', 'LineWidth', 2)
hold off
xlabel('Time [s]');
ylabel('Voltage [mV]')

ntrials = size(E1,1);		%Define the number of trials,
imagesc(t,(1:ntrials),E1);	%... image all of the data,
xlabel('Time [s]')			%... and label the axes.
ylabel('Trial #')

%% Chapter 5, Step 2.

load('Ch5-ECoG-1.mat')	%Load the ECoG data.
dt = t(2)-t(1);			%Define the sampling interval.
K = size(E1,1);			%Define the # of trials.
nlags = 100;			%Define the max # of +/- lags.
ac = zeros(1,2*nlags+1);%Declare empty vector for autocov.

for k=1:K				%For each trial,
 x = E1(k,:)-mean(E1(k,:));			%...subtract the mean,
 [ac0,lags]=xcorr(x,100,'biased');	%... compute autocovar,
 ac = ac + ac0/K;		%...and add to total, scaled by 1/K.
end
plot(lags*dt,ac)		%Plot autocovar vs lags in time.
xlabel('Lag [s]')		%Label the axes.
ylabel('Autocovariance');

load('Ch5-ECoG-1.mat')				%Load the ECoG data.
dt = t(2)-t(1);						%Define sampling interval.
x = E1(1,:) - mean(E1(1,:));		%Define one time series,
y = E2(1,:) - mean(E2(1,:));		%... and another.
[xc,lags]=xcorr(x,y,100,'biased');	%Compute trial 1 cross cov.
plot(lags*dt,xc)					%Plot cov vs lags in time.
xlabel('Lag [s]')					%... with axes labelled.
ylabel('Cross covariance');

load('Ch5-ECoG-1.mat')		%Load the ECoG data.
K = size(E1,1);				%Define the number of trials.
dt = t(2)-t(1);				%Define the sampling interval.
maxlags = 100;				%Define variable with max lags.

XC = zeros(K,2*maxlags+1);	%Create variable to store cross cov.
for k=1:K					%For each trial ...
    x=E1(k,:)-mean(E1(k,:));%...get data from one electrode,
    y=E2(k,:)-mean(E2(k,:));%...and the other electrode,
    [xc0]=xcorr(x,y,maxlags,'biased');%...compute cross cov,
    XC(k,:) = xc0;			%...and store result.
end
XC = mean(XC,1);            %Average cross cov over trials.

%Plot trial-averaged cross cov vs lags in units of time,
plot((-maxlags:maxlags)*dt,XC)
xlabel('Lag [s]')            %... with axes labelled.
ylabel('Trial-averaged cross covariance');

%% Chapter 5, Step 3.

load('Ch5-ECoG-1.mat')		%Load the ECoG data.
K = size(E1,1);				%Define the number of trials.
N = size(E1,2);				%Define the number of time indices.
dt = t(2)-t(1);				%Define the sampling interval.
T  = t(end);				%Define the duration of data.

Sxx = zeros(K,N);		%Create variable to store each spectrum.
for k=1:K					%For each trial,
    x = E1(k,:);			%... get the data,
    xf  = fft(x-mean(x));	%... compute Fourier transform,
    Sxx(k,:) = 2*dt^2/T *(xf.*conj(xf));%... compute spectrum.
end
Sxx = Sxx(:,1:N/2+1);		%Ignore negative frequencies.
Sxx = mean(Sxx,1);			%Average spectra over trials.

df = 1/max(T);				%Define frequency resolution,
fNQ = 1/dt/2;				%... and Nyquist frequency.
faxis = (0:df:fNQ);			%... to construct frequency axis.

plot(faxis, 10*log10(Sxx))	%Plot power in decibels vs frequency,
xlim([0 100]);				%... in select frequency range,
ylim([-50 0])				%... in select power range,
xlabel('Frequency [Hz]')	%... with axes labelled.
ylabel('Power [ mV^2/Hz]')

%% Chapter 5, Step 4.

load('Ch5-ECoG-1.mat')	%Load the ECoG data.
K = size(E1,1);			%Define the number of trials.
N = size(E1,2);			%Define the number of indices per trial.
dt = t(2)-t(1);			%Define the sampling interval.
T  = t(end); 			%Define the duration of data.

Sxx = zeros(K,N);		%Create variables to save the spectra,
Syy = zeros(K,N);
Sxy = zeros(K,N);
for k=1:K				%... and compute spectra for each trial.
    x=E1(k,:)-mean(E1(k,:));
    y=E2(k,:)-mean(E2(k,:));
    Sxx(k,:) = 2*dt^2/T * (fft(x) .* conj(fft(x)));
    Syy(k,:) = 2*dt^2/T * (fft(y) .* conj(fft(y)));
    Sxy(k,:) = 2*dt^2/T * (fft(x) .* conj(fft(y)));
end

Sxx = Sxx(:,1:N/2+1);	%Ignore negative frequencies.
Syy = Syy(:,1:N/2+1);
Sxy = Sxy(:,1:N/2+1);

Sxx = mean(Sxx,1);		%Average the spectra across trials.
Syy = mean(Syy,1);
Sxy = mean(Sxy,1);		%... and compute the coherence.
cohr = abs(Sxy) ./ (sqrt(Sxx) .* sqrt(Syy));

df = 1/max(T);			%Determine the frequency resolution.
fNQ = 1/dt/2;			%Determine the Nyquist frequency,
faxis = (0:df:fNQ);		%... and construct frequency axis.

plot(faxis, cohr);		%Plot coherence vs frequency,
xlim([0 50])			%... in chosen frequency range,
ylim([0 1])
xlabel('Frequency [Hz]')%... with axes labelled.
ylabel('Coherence')

%% Chapter 5, Step 5.

load('Ch5-ECoG-1.mat')	%Load the ECoG data.
K = size(E1,1);			%Define the number of trials.
N = size(E1,2);			%Define the number of indices per trial.
dt = t(2)-t(1);			%Define the sampling interval.
T  = t(end); 			%Define the duration of data.

df = 1/max(T);			%Determine the frequency resolution.
fNQ = 1/dt/2;			%Determine the Nyquist frequency,
faxis = (0:df:fNQ);		%... and construct frequency axis..

j8 = find(faxis == 8);	%Determine index j for frequency 8 Hz.
j24= find(faxis == 24);	%Determine index j for frequency 24 Hz.

phi8=zeros(K,1);		%Variables to hold phase differences.
phi24=zeros(K,1);

for k=1:K				%For each trial, compute cross spectrum, 
    Sxy = fft(E1(k,:)).*conj(fft(E2(k,:)));
    phi8(k)  = angle(Sxy(j8));	%... and the phases.
    phi24(k) = angle(Sxy(j24));
end

subplot(1,2,1)			%Display the phase differences.
rose(phi8);   title('\Phi at 8 Hz')
subplot(1,2,2)
rose(phi24);  title('\Phi at 24 Hz')

%% Chapter 5, Problem 8.

T = 10;             %Define total duration of data,
dt = 0.001;         %... sampling interval,
N = T/dt;           %... and # pts in data.
x = randn(N,1);     %Generate Gaussian noise data,
y = randn(N,1);     %... and another Gaussian noise data.

TW = 20;				%Choose time-bandwidth product of 20.
ntapers = 2*TW-1;		%...which sets the # of tapers.
params.Fs = 1/dt;		%Define frequency resolution,
params.tapers = [TW,ntapers];%...time-band product,# tapers.
params.pad = -1;		%Specify no zero padding,
						%... and compute the coherence.
[C,phi,S12,S1,S2,f]=coherencyc(x, y, params);

plot(f,C)				%Plot the coherence vs frequency,
ylim([0 1])				%... set the vertical axis,
xlabel('Frequency [Hz]')%... and label the axes.
ylabel('Coherence')