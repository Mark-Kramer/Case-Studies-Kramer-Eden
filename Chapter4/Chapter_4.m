%% Chapter 4, Step 1.

load('Ch4-ECoG-1.mat')       %Load the ECoG data.
plot(t,ECoG)                 %Plot voltage vs time.
xlabel('Time [s]')           %Label time axis.
ylabel('Voltage [mV]')       %Label voltage axis.

%% Chapter 4, Step 2.

%Power spectrum of ECoG.
load('Ch4-ECoG-1.mat')			%Load the ECoG data.
x  = ECoG;						%Relabel the data variable.
dt = t(2)-t(1);					%Define the sampling interval,
T  = t(end);					%... and duration of data.

xf = fft(x-mean(x));			%Compute Fourier transform of x,
Sxx = 2*dt^2/T*(xf.*conj(xf));  %... and the power spectrum.
Sxx = Sxx(1:length(x)/2+1);		%Ignore negative frequencies.

df = 1/T;						%Define frequency resolution.
fNQ = 1/dt/2;				    %Define Nyquist frequency.
faxis = (0:df:fNQ);				%Construct frequency axis.

plot(faxis, Sxx)				%Plot power vs frequency,
xlim([0 100])					%... in select frequency range,
xlabel('Frequency [Hz]')		%... with axes labelled.
ylabel('Power [mV^2/Hz]')

semilogx(faxis, 10*log10(Sxx))	%Plot power vs frequency,
xlim([0 100])					%... in select frequency range,
xlabel('Frequency [Hz]')		%... with axes labelled.
ylabel('Power [dB]')

%Zero-padding example (10 Hz).
Fs = 500;                       %Define sampling frequency.
dt = 1/Fs;                      %Define sampling interval.
t = (dt:dt:1);                  %Define time axis.
T = t(end);                     %Define total time.

d = sin(2.0*pi*t*10);           %Make a 10 Hz sinusoid,
d = [d, zeros(1,10*Fs)];		%... with 10 s of zero padding.

df = 1/(length(d)*dt);			%Define the frequency step size,
fNQ = Fs/2;						%... and Nyquist frequency,
faxis = (0:df:fNQ);             %... to create frequency axis.

pow = 2*dt^2/T*(fft(d).*conj(fft(d)));%Compute power spectrum,
pow = pow(1:length(d)/2+1);     %Ignore negative frequencies.
plot(faxis, 10*log10(pow))      %... and plot it,
xlim([0 20])					%... in selected frequency range,
ylim([-60 10])					%... and selected decibel range.
xlabel('Frequency [Hz]')		%... with axes labelled.
ylabel('Power [dB]')

%Zero-padding example (10 and 10.5 Hz)
Fs = 500;                       %Define sampling frequency.
dt = 1/Fs;                      %Define sampling interval.
t = (dt:dt:1);                  %Define time axis.
T = t(end);                     %Define total time.

d1 = sin(2.0*pi*t*10);          %Make a 10 Hz sinsoid.
d2 = sin(2.0*pi*t*10.5);        %Make a 10.5 Hz sinsoid.
d  = d1+d2;                     %Make the summed signal,
d = [d, zeros(1,10*Fs)];        %... with 10 s of zero padding.

df = 1/(length(d)*dt);			%Define the frequency step size,
fNQ = Fs/2;						%... and Nyquist frequency,
faxis = (0:df:fNQ);             %... to create frequency axis.

pow = 2*dt^2/T*(fft(d).*conj(fft(d)));%Compute power spectrum.
pow = pow(1:length(d)/2+1);     %Ignore negative frequencies,
plot(faxis, 10*log10(pow))      %... and plot it,
xlim([0 20])					%... in selected frequency range,
ylim([-40 10])					%... and selected decibel range.
xlabel('Frequency [Hz]')		%... with axes labelled.
ylabel('Power [dB]')

%% Chapter 4, Step 3.

load('Ch4-ECoG-1.mat')		%Load the ECoG data.
x  = ECoG;					%Relabel the data variable.
N = length(x);				%Define # points in data.
x = hann(N).*x;				%Multiply data by Hanning taper.

%% Chapter 4, Step 4.

load('Ch4-ECoG-1.mat')		%Load the ECoG data.
x  = ECoG;					%Relabel the data variable.
x  = x - mean(x);			%Set mean of x to zero.
dt = t(2)-t(1);				%Define the sampling interval.
Fs = 1/dt;					%Define the sampling frequency.
TW = 3;						%Choose time-bandwidth product of 3.

[Sxx,f]=pmtm(x,TW,length(x),Fs); %Compute MTM power spectrum.

semilogx(f, 10*log10(Sxx))	%Plot power vs. frequency,
xlim([0 100])				%... in selected frequency range,
xlabel('Frequency [Hz]')	%... with axes labelled.
ylabel('Power [dB]')

%% Chapter 4, Step 5.

%Compute MTM power spectrum, and return CIs.
[Sxx,Serr,f]=pmtm(x,TW,length(x),Fs);

semilogx(f,10*log10(Sxx))       %Plot power vs frequency,
hold on							%... freeze the graphics window,
semilogx(f,10*log10(Serr))      %... plot the CI,
hold off						%... release graphics window.
xlim([0 100])					%Select frequency range,
xlabel('Frequency [Hz]')		%... and label the axes.
ylabel('Power [dB]')

%% Chapter 4, Appendix.

x = [3 4 5 6];			%Define a simple signal x,
w = [-1 0.1 -0.2 1];    %... and another simple signal w.
a=fft(conv(w,x));		%Take the FT of the convolution,
b=fft([w 0 0 0]).*fft([x 0 0 0]);%... and the product of the FTs.
