function [t, t_pad, data, data_pad] = Chapter_4_Model_Sine_Data(desired_T, sample_interval)
    %INPUT:
    %   desired_T: number of seconds you would like to "record" for
    %   sample_interval: number of seconds you would like between data
    %OUTPUT:
    %   t: time vector for modeled data
    %   t_pad: time vector for modeled data + 19 seconds of zero padding
    %   data: modeled data
    %   data_pad: data with 19 seconds of zeros padded onto the tail
    
    %Model Data
    t = sample_interval:sample_interval:desired_T;
    sine_10_5_Hz = sin(2*pi*10.5.*t);
    sine_10_8_Hz = sin(2*pi*10.8.*t);
    data = sine_10_5_Hz + sine_10_8_Hz;
    
    %Pad Data
    t_pad = sample_interval:sample_interval:(desired_T+19);
    data_pad = [data, zeros(1, 19/sample_interval)];
    
end