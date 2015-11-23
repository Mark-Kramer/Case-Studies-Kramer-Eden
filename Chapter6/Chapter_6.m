%% Chapter 6, Step 1.

load('Ch6-EEG-1.mat')   %Load the EEG data.
plot(t,EEG(1,:))        %... and plot it for trial 1,
xlabel('Time [s]');     %... with axes labeled.
ylabel('Voltage [mV]')

%% Chapter 6, Step 2.

load('Ch6-EEG-1.mat')			%Load the EEG data.
x = EEG(1,:);					%... and analyze first trial.
x = x - mean(x);				%Subtract the mean from data.
dt = t(2)-t(1);					%Define the sampling interval.
T = t(end);						%Define the duration of trial.
N = length(x);					%Define # points in trial.

xh = hann(N).*transpose(x);		%Multiply data by Hanning window,
xf = fft(xh);					%... compute Fourier transform.
Sxx = 2*dt^2/T*(xf.*conj(xf));	%... compute power spectrum,
Sxx = Sxx(1:length(x)/2+1);		%... ignore negative frequencies.

df = 1/max(T);				%Determine frequency resolution.
fNQ = 1/dt/2;				%Determine Nyquist frequency.
faxis = (0:df:fNQ);			%Construct frequency axis.

semilogx(faxis,10*log10(Sxx)) %Plot decibels vs frequency,
xlim([0 100])				%... in limited frequency range,
xlabel('Frequency [Hz]')	%... with axes labeled.
ylabel('Power [dB]')

%% Chapter 6, Step 3.

K = size(EEG,1);		%Define variable to record # of trials.
mn = mean(EEG,1);		%Compute mean EEG across trials (ERP).
sd = std(EEG,1);		%Compute std of EEG data across trials.
sdmn = sd / sqrt(K);	%Compute the std of the mean.

plot(t, mn)				%Plot the ERP,
hold on 				%... and the confidence intervals,
plot(t, mn+2*sdmn);
plot(t, mn-2*sdmn);
hold off
xlabel('Time [s]')		%... and label the axes.
ylabel('Voltage [ \muV]')

%% Chapter 6, Step 4.

load('Ch6-EEG-1.mat')		%Load the EEG data.
x  = EEG(1,:);				%Relabel the data from trial 1,
x = x - mean(x);			%... subtract mean from the data,
xf = fft(x);				%... and compute the FT.

dt = t(2)-t(1);			%Define the sampling interval.
N  = length(x);			%Define # points in a single trial.
df = 1/(N*dt);			%Determine the frequency resolution.
fNQ = 1/dt/2;			%Determine the Nyquist frequency.
faxis = fftshift(-fNQ:df:fNQ-df);	%Construct frequency axis.

%Find interval near 60 Hz.
indices = find((abs(abs(single(faxis))-60)) <= 1);

rectangular_filter = ones(1,N);	%Define filter in freq domain,
rectangular_filter(indices)=0;	%...set filter @ line noise to 0,
xf_filtered = xf.*rectangular_filter;	%...apply filter to data.

[~, isorted] = sort(faxis, 'ascend');
plot(faxis(isorted), rectangular_filter(isorted))

xnew = ifft(xf_filtered);	%Compute iFT of freq domain data.

impulse = zeros(1,N);		%Define the input signal,
impulse(N/2) = 1;			%... with an impulse at the midpoint.
impulsef=fft(impulse).*rectangular_filter; %Apply naive filter,
impulse_response = ifft(impulsef);	%...iFT back to time domain.
lag_axis = (-N/2+1:N/2)*dt;			%Define lag axis,
plot(lag_axis, impulse_response)	%...display impulse response.

%Transform the filter to the time domain,
i_rectangular_filter = ifft(rectangular_filter);
%... and define the impulse response,
impulse_response_t = zeros(1,N);
for i=1:N						%...at each point in time,
    impulse_response_t(i)=...	%...by computing the convolution.
        sum(circshift(i_rectangular_filter, [1,i-1]).*impulse);
end

load('Ch6-EEG-1.mat')		%Load the EEG data.
x  = EEG(1,:);				%... analyze first trial.
dt = t(2)-t(1);				%Define sampling interval.
N = length(x);				%Define # points in a single trial.
df = 1/(N*dt);				%Determine the frequency resolution.
fNQ = 1/dt/2;				%Determine the Nyquist frequency.
faxis = fftshift(-fNQ:df:fNQ-df);	%Construct frequency axis.

%Find indices at +/- 60 Hz.
ind  = find((abs(abs(single(faxis))-60)) <= 0.1*df);

hann_filter = ones(1,N);	%Define filter in frequency domain,
win = 15;					%... set size of the Hann window,
							%... and apply it:
hann_filter(ind(1)-win:ind(1)+win) = 1-transpose(hann(2*win+1));
hann_filter(ind(2)-win:ind(2)+win) = 1-transpose(hann(2*win+1));

impulse = zeros(1,N);			%Define the input signal,
impulse(N/2) = 1;				%...with impulse at the midpoint.
i_hann_filter=ifft(hann_filter);%Transform filter to time domain,
impulse_response_t = zeros(N,1);%...define impulse response vector,
for i=1:N						%...compute it with convolution.
    impulse_response_t(i) = ...
        sum(circshift(i_hann_filter, [1,i-1]).*impulse);
end
lag_axis = (-N/2+1:N/2)*dt;			%Define lag axis for plotting,
plot(lag_axis, impulse_response_t)	%...display impulse response.

xf = fft(x);				%Transform data to frequency domain,
xf_filtered=xf.*hann_filter;%...apply Hanning filter,
xnew = ifft(xf_filtered);	%...transform back to time domain.

%% Chapter 6, Step 5.

load('Ch6-EEG-1.mat')	%Load the EEG data,
x  = EEG(1,:);			%...and analyze first trial.
dt = t(2)-t(1);			%Define the sampling interval,
fNQ = 1/dt/2;			%...and the Nyquist frequency.

n=100;					%Define the filter order,
Wn=30/fNQ;				%... specify the cutoff frequency,
b = fir1(n,Wn,'low');	%... and build the low pass filter.

N = length(EEG);				%Define # points in data.
bz = [zeros(1,N-n-1), b];		%Amend filter with leading zeros.
impulse = zeros(1,N);			%Define the test input signal,
impulse(N/2) = 1;				%... with impulse at midpoint.
impulse_response_t = zeros(N,1);%Define impulse response vector,
for i=1:N						%...compute it with convolution.
    impulse_response_t(i) = ...
        sum(circshift(bz, [1,i-1]).*impulse);
end

bf = fft(b,N);		%Transform filter to the frequency domain,
Mb = bf.*conj(bf);	%...and compute the mag response.
df = 1/(N*dt);		%Define the frequency resolution,
T  = t(end);		%...and the total time,
faxis = fftshift((-fNQ:df:fNQ-df));	%...create frequency axis,
[~, isorted]=sort(faxis,'ascend');	%...with axes sorted,
plot(faxis(isorted), Mb(isorted))	%...plot mag response.

xnew = zeros(N,1);		%Define vector to hold filter results,
for i=1:N				%...and for each index i,
    xnew(i) = ...		%...compute the convolution.
        sum(circshift(bz, [1,i]).*x);
end

xnew_MATLAB=filter(b,1,x);	%Apply filter using MATLAB function.

b=transpose(fir1(n,Wn,'low'));	%Design the filter,
xnew_MATLAB = filter(b,1,x);	%...apply it to the signal x.

%% Chapter 6, Step 6.

load('Ch6-EEG-1.mat')	%Load the EEG data.
x  = EEG(1,:);			%...and analyze first trial.
N  = length(x);			%Define # points in trial.
dt = t(2)-t(1);			%Define the sampling interval.
fNQ = 1/dt/2;			%Define the Nyquist frequency, 
df = 1/(N*dt);			%...and the frequency resolution,
faxis = fftshift((-fNQ:df:fNQ-df));	%...create frequency axis,
[~, isorted]=sort(faxis, 'ascend');	%...with axes sorted.

n=100;					%Define the filter order,
Wn=30/fNQ;				%...specify the cutoff frequency,
b = transpose(fir1(n,Wn,'low'));	%...build low pass filter.
bf = fft(b,N);			%Transform filter to frequency domain,
plot(faxis(isorted), angle(bf(isorted)))%...plot phase response.

%Plot the unwrapped phase response.
plot(faxis(isorted), unwrap(angle(bf(isorted))))

x1 = filter(b,1,x);		%Apply the filter to the EEG data,
x1 = x1(N:-1:1);		%... reverse the sequence,
x2 = filter(b,1,x1);	%... reapply the filter,
x2 = x2(N:-1:1);		%... and reverse the sequence.

x3 = filtfilt(b,1,x);		%Perform zero-phase filtering.

%% Chapter 6, Step 7.

load('Ch6-EEG-1.mat')		%Load the EEG data.
dt = t(2)-t(1);				%Define the sampling interval.
fNQ = 1/dt/2;				%Determine the Nyquist frequency.
K = size(EEG,1);			%Define # of trials.

n=100;						%Define the filter order,
Wn=30/fNQ;					%...specify the cutoff frequency,
b = transpose(fir1(n,Wn,'low'));	%...build low pass filter.
EEG_lo = zeros(size(EEG));	%Define matrix to store results,
for k=1:K					%...zero-phase filter each trial.
    EEG_lo(k,:)=filtfilt(b,1,EEG(k,:));
end

%% Chapter 6, Problems.

%Load the EEG data to define useful parameters.
load('Ch6-EEG-1.mat') 
x = EEG(1,:);
dt = t(2)-t(1);
N = length(x);
Fs = 1/dt;
fNQ = Fs/2;
df = 1/(N*dt);
faxis = fftshift((-fNQ:df:fNQ-df));

%Define the filter orders, cutoff frequency, and colors.
n=[1000,500,100,50];
Wn=30/fNQ;
clr = {'r', 'g', 'b', 'm'};

%For each filter, design and visualize the filter.
for k=1:length(n)
    %Design filter.
    b = fir1(n(k),Wn,'low');
    
    %Visualize filter.
    subplot(2,1,1)
    hold on
    plot(b+0.05*k, 'Color', clr{k})
    hold off
    axis tight
    axis off

    bf = fft(b,N);		%NOTE: zero pad to same length as x.
    subplot(2,1,2)
    hold on
    plot(faxis,bf.*conj(bf), 'Color', clr{k})
    hold off
    axis tight
    xlim([-55 55])
    xlabel('Frequency [Hz]')

end
subplot(2,1,1)
legend({'n=1000'; 'n=500'; 'n=100'; 'n=50'})