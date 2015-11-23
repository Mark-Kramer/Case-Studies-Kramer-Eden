%% Chapter 3, Step 1.

load('Ch3-EEG-1.mat')		%Load the EEG data,
plot(t,EEG)					%... plot it vs time,
xlabel('Time [s]')			%Label time axis.
ylabel('Voltage [ \muV]')	%Label voltage axis.

x  = EEG;			%Relabel the data variable.
dt = t(2)-t(1);		%Define the sampling interval.
N  = length(x);		%Define the total number of data points.
T  = N*dt;			%Define the total duration of data.

%% Chapter 3, Step 2.

mn = mean(x);		%Compute the mean of the data.
vr = var(x);		%Compute the variance of the data.
sd = std(x);		%Compute the standard deviation of the data.

%% Chapter 3, Step 3.

%Compute the autocov for L +/- 100 indices.
[ac,lags] = xcorr(x-mean(x),100,'biased');
%... and plot the autocov vs lags in units of time.
plot(lags*dt,ac)
%... with axes labelled.
xlabel('Lag [s]')
ylabel('Autocovariance');

[ac_u,lags]=xcorr(x-mean(x),2000,'unbiased');%Unbiased autocov,
plot(lags*dt,ac_u)							%... plot it.
[ac_b,lags]=xcorr(x-mean(x),2000,'biased');	%Biased autocov,
hold on										%... plot it.
plot(lags*dt,ac_b, 'r')
hold off
xlabel('Lag [s]')							%Label the axes.
ylabel('Autocovariance');

%% Chapter 3, Step 4.

xf = fft(x-mean(x));			%Compute Fourier transform of x.
Sxx = 2*dt^2/T * (xf.*conj(xf));	%Compute power spectrum.
Sxx = Sxx(1:length(x)/2+1);		%Ignore negative frequencies.

df = 1/max(T);					%Determine frequency resolution.
fNQ = 1/ dt / 2;				%Determine Nyquist frequency.
faxis = (0:df:fNQ);				%Construct frequency axis.

plot(faxis, Sxx)                %Plot power vs frequency.
xlim([0 100])                   %Select frequency range.
xlabel('Frequency [Hz]')     	%Label the axes.
ylabel('Power [ \muV^2/Hz]')

%% Intuition (Part 3).

%Define the model,
model = [ones(size(x)) sin(2*pi*60*t') cos(2*pi*60*t')];
%... and perform regression.
b = regress(x, model);

%Evaluate the model.
x_60Hz_modeled = b(1)+b(2)*sin(2*pi*60*t)+b(3)*cos(2*pi*60*t);
plot(t,x)               %Plot the EEG data.
hold on                 %... freeze the graphics window,
plot(t,x_60Hz_modeled, 'r')	%... and plot the modeled EEG data,
hold off                %... release the graphics window,
xlim([0.5 1])           %... examine a 0.5 s of data,
xlabel('Time [s]')      %... and label the axes.
ylabel('EEG and modeled EEG')

%Evaluate the model.
x_60Hz_modeled = b(1)+b(2)*sin(2*pi*60*t)+b(3)*cos(2*pi*60*t);
x_cleaned=x-x_60Hz_modeled';	%... remove it from the EEG data,
plot(t,x_cleaned);				%... and plot the result.

Sxx_model_60Hz = b(2)^2+b(3)^2;

%% The discrete Fourier transform in MATLAB

xf = fft(x-mean(x));				%The Fourier transform of x.

Sxx = 2*dt^2/T*(xf.*conj(xf));		%Compute the spectrum.

xf = fft(x-mean(x));			%Compute Fourier transform of x.
Sxx = 2*dt^2/T*(xf.*conj(xf));	%Compute the power spectrum.
Sxx = Sxx(1:N/2+1);				%Ignore negative frequencies.

df = 1/max(T);				%Determine the frequency resolution.
fNQ = 1/ dt / 2;			%Determine the Nyquist frequency.
faxis = (0:df:fNQ);			%Construct frequency axis.
plot(faxis, Sxx)			%Plot power vs frequency.

%% Chapter 3, Step 5.

plot(faxis, 10*log10(Sxx/max(Sxx)))		%Plot power in decibels.
xlim([0 100])							%Select frequency range.
ylim([-60 0])							%Select decibel range.
xlabel('Frequency [Hz]')				%Label axes.
ylabel('Power [dB]')

semilogx(faxis, 10*log10(Sxx/max(Sxx)))	%Log-log scale
xlim([df 100])							%Select frequency range.
ylim([-60 0])							%Select decibel range.
xlabel('Frequency [Hz]')				%Label axes.
ylabel('Power [dB]')

%% Chapter 3, Step 6.

Fs = 1/dt;					%Define the sampling frequency.
interval = round(Fs);		%Specify the interval size.
overlap = round(Fs*0.95);	%Specify the overlap of intervals.
nfft = round(Fs);			%Specify the FFT length.

%Compute the spectrogram,
[S,F,T,P] = spectrogram(x-mean(x),interval,overlap,nfft,Fs);
imagesc(T,F,10*log10(P))	%... and plot it,
colorbar					%... with a colorbar,
axis xy						%... and origin in lower left, 
ylim([0 70])				%... set the frequency range,
xlabel('Time [s]');			%... and label axes.
ylabel('Frequency [Hz]')

%% Chapter 3, Appendix.

dt = 0.001;			%Define the sampling interval.
T = 4;				%Define the total duration of the recording.
t = (dt:dt:T);		%Define a time axis.
N = length(t);		%Define the number of samples.
d = randn(N,1);		%Create artificial data.
d = d - mean(d);    %Set mean to 0.

pow = 2*dt^2/T*(fft(d).*conj(fft(d)));	%Compute the power,
%... then sum power over positive frequencies and multiply by df.
POW = sum(pow(1:N/2+1))*(1/T);	
vr  = var(d);		%Compute variance of data.

%Print the results.
fprintf(['Summed power ' num2str(POW) '\n'])
fprintf(['Variance     ' num2str(vr)  '\n'])
fprintf(['Difference   ' num2str(POW - vr) '\n'])