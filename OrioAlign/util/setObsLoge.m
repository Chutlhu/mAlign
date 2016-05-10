function obslog = setObsLoge(path,filename,loge)

% SETOBSLOGE (function)
%
% Function for computing the decays (MU_S,MU_R) and the
% thresholds (TH_L,TH_R) for the observation of silence and sound
% for log-energy (LOGE), and saving the results on directory PATH.
%
% If path already contains a .MAT file with the same parameters
% the function just loads them.
%
% INPUT values
% path: the absolute or relative path where the .wav file
% filename: the name of the .wav file
% loge: the log-energy of the audio to be recognized
%
% OUPUT values
% obslog.mu_r: decay parameter of the exponential function for rest
% obslog.th_r: threshold for rest
% obslog.mu_s: decay parameter of the exponential function for sustain
% obslog.th_s: threshold for sustain
% +
% a file named "filename-l_fft-l_sig-hpsz-obs.mat" in path

name = [path,'/',filename,'-',num2str(l_fft),'-',num2str(l_sig),'-',num2str(hpsz)];

% Check if already computed, with the same parameters
try

  load(name);

% If not, compute the yfft
catch
  
  % Load and normalize the audiofile
  y = wavread([path,'/',filename,'.wav']);
  y = y./max(y);
  l_y = length(y);
  
  hmw = hamming(l_sig);
  
  % Number of frames in the audiofile
  M = floor((l_y - l_sig + hpsz) / hpsz);
  yfft = zeros(l_fft,M);
  
  % Computate the FFT for each frame
  ini = 1;
  fin = l_sig;
  for m = 1:M,
    yfft(:,m) = (abs(fft(hmw .* y(ini:fin), l_fft))) .^ 2;
    ini = ini + hpsz;
    fin = fin + hpsz;
  end
  yfft = yfft(1:l_fft/2,:);
  
  % Compute Log-energy
  loge = log10(sum(yfft) + 0.00001);

  % Save the file
  save(name,'yfft','loge')

end

