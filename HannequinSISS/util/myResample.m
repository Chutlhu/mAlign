function [OutputSignal, NewFs]= myResample(InputSignal, Fs, NewFs)

    K = gcd(Fs, NewFs); % greatest common divison
    P = NewFs/K;
    Q = Fs/K;
    
    % Output signal with MATLAB's resample
    OutputSignal = resample(InputSignal,P,Q);
end 
