%% Chapter 7, Step 1.

load('Ch7-LFP-1.mat')		%Load the LFP data,
plot(t,LFP(:))				%... and plot it,
xlabel('Time [s]');			%... with axes labelled.
ylabel('Voltage [mV]')

%% Chapter 7, Step 2.

load('Ch7-LFP-1.mat')			%Load the LFP data,
dt = t(2)-t(1);					%Define the sampling interval.
T = t(end);						%Define the duration of data.
N  = length(LFP);				%Define # points in data.

x = hann(N).*transpose(LFP);	%Multiply data by Hanning window.
xf = fft(x-mean(x));			%Compute Fourier transform of x.
Sxx = 2*dt^2/T *(xf.*conj(xf));	%Compute the power.
Sxx = Sxx(1:N/2+1);				%Ignore negative frequencies.

df = 1/max(T);					%Define frequency resolution.
fNQ = 1/dt/2;					%Define Nyquist frequency.
faxis = (0:df:fNQ);				%Construct frequency axis.
plot(faxis, 10*log10(Sxx))		%Plot power vs frequency.
xlim([0 200]); ylim([-80 0])	%Set frequency & power ranges.
xlabel('Frequency [Hz]')		%Label axes.
ylabel('Power [ mV^2/Hz]')

%% Chapter 7, Step 3.

dt = t(2)-t(1);				%Define the sampling interval.
Fs = 1/dt;					%Define the sampling frequency.
fNQ = Fs/2;					%Define the Nyquist frequency.
							%For low frequency interval,
Wn = [5,7]/fNQ;				%...set the passband,
n  = 100;					%...and filter order,
b  = fir1(n,Wn);			%...build bandpass filter.
Vlo = filtfilt(b,1,LFP);	%...and apply filter.
							%For high frequency interval,
Wn = [80,120]/fNQ;			%...set the passband,
n  = 100;					%...and filter order,
b  = fir1(n,Wn);			%...build bandpass filter.
Vhi = filtfilt(b,1,LFP);	%...and apply filter.

phi=angle(hilbert(Vlo));%Compute phase of low freq signal.
amp=abs(hilbert(Vhi));	%Compute amplitude of high freq signal.

p_bins = (-pi:0.1:pi);				%Define the phase bins.
a_mean = zeros(length(p_bins)-1,1);	%Vector for average amps.
p_mean = zeros(length(p_bins)-1,1);	%Vector for phase bins.
  
for k=1:length(p_bins)-1			%For each phase bin,
    pL = p_bins(k);					%... lower phase limit,
    pR = p_bins(k+1);				%... upper phase limit.
    indices=find(phi>=pL & phi<pR);	%Find phases falling in bin,
    a_mean(k) = mean(amp(indices));	%... compute mean amplitude,
    p_mean(k) = mean([pL, pR]);		%... save center phase.
end

%Difference between max and min modulation.
h = max(a_mean)-min(a_mean);

n_surrogates = 1000;				%Define # surrogates.
hS = zeros(n_surrogates,1);			%Vector to hold h results.
for ns=1:n_surrogates;				%For each surrogate,
    ampS = amp(randperm(length(amp)));	%Resample amplitude,
    p_bins = (-pi:0.1:pi);				%Define the phase bins.
    a_mean = zeros(length(p_bins)-1,1);	%Vector for average amps.
    p_mean = zeros(length(p_bins)-1,1);	%Vector for phase bins.
    for k=1:length(p_bins)-1			%For each phase bin,
      pL = p_bins(k);					%...lower phase limit,
      pR = p_bins(k+1);					%...upper phase limit.
      indices=find(phi>=pL & phi<pR);	%Find phases in bin,
      a_mean(k) = mean(ampS(indices));	%...compute mean amp,
      p_mean(k) = mean([pL, pR]);		%...save center phase.
    end
    hS(ns) = max(a_mean)-min(a_mean);	%Store surrogate h.
end

p = length(find(hS > h))/length(hS);    %Compute p-value.

%%  Chapter 7, Step 3 (continued).

nCtlPts = 8;						%Define # of control points.
[r,r_CI]=GLM_CFC(Vlo,Vhi,nCtlPts);	%...and compute r.