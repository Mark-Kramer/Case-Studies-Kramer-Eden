%% Chapter 2, Step 1.

load('Ch2-EEG-1.mat')       %Load the EEG data.

who                         %List variables in the workspace.

size(EEGa)                  %Determine the dimensions of EEGa.

ntrials = size(EEGa,1);     %Define variable to record # of trials.

EEGa(1,:)                   %Print to screen data from condition A, trial 1.

plot(EEGa(1,:))             %Plot the data from condition A, trial 1.

dt = t(2) - t(1);           %Determine the sampling interval.

plot(t,EEGa(1,:))			%Plot condition A, trial 1 data vs t.
xlabel('Time [s]')          %Label the x-axis as time.
ylabel('Voltage [\mu V]')   %Label the y-axis as voltage.
title('EEG data from condition A, Trial 1')		%Add a title.

hold on                     %Freeze plot & indicate stimulus delivery time ...
plot([0.25, 0.25], [-4,4], 'k', 'LineWidth', 2)
hold off                    %Release the current plot.

plot(t,EEGa(1,:))           %Plot condition A, trial 1 data vs t,
hold on                     %... freeze the plot, and then plot
plot(t,EEGb(1,:), 'r')      %... data from condition B, trial 1,
hold off                    %... and release the plot.
xlabel('Time [s]')          %Label the x-axis as time.
ylabel('Voltage [\mu V]')   %Label the y-axis as voltage.
title('EEG data from conditions A (blue) and B (red), Trial 1')

imagesc(t,(1:ntrials),EEGa);%Image the data from condition A.
xlabel('Time [s]')          %Label the x-axis.
ylabel('Trial #')        	%Label the y-axis.
hold on						%Indicate time of stimulus onset.
plot([0.25, 0.25], [0 1000], 'k', 'LineWidth', 2)
hold off

%% Chapter 2, Step 2.

load('Ch2-EEG-1.mat')		%Load the EEG data.
plot(t, mean(EEGa,1))		%Plot the ERP of condition A.
xlabel('Time [s]')			%Label the x-axis as time,
ylabel('Voltage [\mu V]')	%...and the y-axis as voltage,
title('ERP of condition A')	%...and provide a useful title.

%% Chapter 2, Step 3.

mn = mean(EEGa,1);          %Compute mean across trials (the ERP).

sd = std(EEGa,1);           %Compute std across trials.

sdmn=sd/sqrt(ntrials);      %Compute the std of the mean.

plot(t, mn, 'LineWidth', 3)	%Plot the ERP of condition A.
hold on						%Freeze the plot,
plot(t, mn+2*sdmn);			%... and include the upper CI,
plot(t, mn-2*sdmn);			%... and the lower CI.
hold off					%Release the plot.
xlabel('Time [s]')			%Label the x-axis as time.
ylabel('Voltage [\mu V]')	%Label the y-axis as voltage.
title('ERP of condition A')	%Provide a useful title.

hold on                     %Freeze the plot,
plot(t, zeros(size(mn)),'k')%... add horizontal line at 0,
hold off 					%... and release the plot.

%% Chapter 2, Step 4.

mnA=mean(EEGa,1);				%ERP of condition A,
sdmnA=std(EEGa,1)/sqrt(ntrials);%...and standard dev of mean.
mnB=mean(EEGb,1);				%ERP of condition B,
sdmnB=std(EEGb,1)/sqrt(ntrials);%...and standard dev of mean.
mnD=mnA-mnB;					%The differenced ERP,
sdmnD=sqrt(sdmnA.^2 + sdmnB.^2);%...and its standard dev.

%% Chapter 2, Step 5.

%Draw 1000 integers with replacement from (1,1000);
i=randsample(ntrials,ntrials,1);

EEG0 = EEGa(i,:);               %Create the resampled EEG.

ERP0 = mean(EEG0,1);            %Create the resampled ERP.

i=randsample(ntrials,ntrials,1);%Draw integers,
EEG1 = EEGa(i,:);               %... create resampled EEG,
ERP1 = mean(EEG1,1);            %... create resampled ERP.

i=randsample(ntrials,ntrials,1);%Draw integers,
EEG2 = EEGa(i,:);               %... create resampled EEG,
ERP2 = mean(EEG2,1);            %... create resampled ERP.

i=randsample(ntrials,ntrials,1);%Draw integers,
EEG3 = EEGa(i,:);               %... create resampled EEG,
ERP3 = mean(EEG3,1);            %... create resampled ERP.

ERP0 = zeros(3000,size(EEGa,2));	%Create empty ERP variable.
for k=1:3000						%For each resampling,
    i=randsample(ntrials,ntrials,1);%... choose the trials,
    EEG0 = EEGa(i,:);				%... create resampled EEG,
    ERP0(k,:) = mean(EEG0,1);		%... save resampled ERP.
end

sERP0=sort(ERP0);               %Sort each column of resampled ERP.
ciL  =sERP0(0.025*size(ERP0,1),:);  %Determine lower CI.
ciU  =sERP0(0.975*size(ERP0,1),:);  %Determine upper CI.

mnA = mean(EEGa,1);             %Determine ERP for condition A,
plot(t, mnA, 'LineWidth', 3)    %... and plot it.
hold on                         %Freeze the current plot, 
plot(t,ciL)                     %... and plot lower CI,
plot(t,ciU)                     %... and upper CI.
hold off                        %Release the current plot.

ylabel('Voltage [\mu V]')       %Label the y-axis as voltage.
xlabel('Time [s]')              %Label the x-axis as time.
title('ERP of condition A with bootstrap confidence intervals')

%% Chapter 2, Step 6.

mnA = mean(EEGa,1);             %Determine ERP for condition A.
mnB = mean(EEGb,1);             %Determine ERP for condition B.
mnD = mnA-mnB;                  %Compute the differenced ERP.
stat = max(abs(mnD));           %Compute the statistic.

EEG = [EEGa; EEGb];             %Merge EEG data from all trials.
statD = zeros(3000,1);          %Empty variable to hold results.
for k=1:3000                    %For each resampling,
    i=randsample(ntrials,2*ntrials,1);	%... choose trials,
    EEG0 = EEG(i,:);            %... create resampled EEG,
    mnA = mean(EEG0,1);         %... create resampled ERP.
    
    i=randsample(ntrials,2*ntrials,1);	%The, re-choose trials,
    EEG0 = EEG(i,:);            %... create resampled EEG,
    mnB = mean(EEG0,1);         %... create resampled ERP.
    
    mnD = mnA-mnB;              %Compute differenced ERP,
    statD(k)= max(abs(mnD));    %... and the statistic.
end