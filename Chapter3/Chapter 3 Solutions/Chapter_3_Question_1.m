function Chapter_3_Question_1()
    % Question 1 - Frequency Resolution
    
    %Determine Frequency Resolution:
    %   df == sample_freq/num_data
    %      == sample_freq/(sample_freq * length_of_recording)
    %      == 1/length_of_recording
    %   therefore, length_of_recording = 1/df
    desired_freq_resolution = 0.0001;
    required_recording_length = 1/desired_freq_resolution;
    
    %The necessary time for recording is 10,000 seconds (about 2hr45min). The
    %disadvantages of this are:
    %   1) Most experiments are stimulus-response experiments, so one stimulus
    %      every 2hr45 minutes is a bit too long.
    %   2) Recording that much data would require massive amounts of storage
    %      and subsequent computation.
    %   3) Electrodes drift over time, so the signal present in the first half
    %      hour of recording will be different than the signal present in the
    %      last half hour of recording (for example).
    %   4) If you had 2hr45min of recording, it would be better to do a
    %      spectrogram analysis than a fine-tuned spectrum. In most
    %      experiments, a frequency resolution of 0.0001 Hz isn't useful
    %      anyway.

end