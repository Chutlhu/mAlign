function [yfft,loge] = doFFT2(path,filename,an,len)

% doFFT (function)
%
% Function for computing the fft of a mono .wav file named FILENAME,
% with given parameters, and saving the results on directory PATH.
%
% If path already contains a .MAT file with the same parameters
% the function just loads them.
%
% INPUT values
% path: the absolute or relative path of the .wav file
% filename: the name of the .wav file
% an.l_fft: the length of the window for the fft
% an.l_sig: the length of the signal (an.l_sig <= an.l_fft)
% an.hpsz: the hopsize between subsequent windows
%
% OUPUT values
% yfft: matrix of the fft absolute values
% loge: array with the log-energy of each frame
% +
% a file named "filename-(an.l_fft)-(an.l_sig)-(an.hpsz).mat" in path

name = [path,'/',filename,'-',num2str(an.l_fft),'-',num2str(an.l_sig),'-',num2str(an.hpsz),'.mat'];

% Check if already computed, with the same parameters
try

  load(name);

% If not, compute the yfft
catch
  
  % Load and normalize the audiofile

  y = wavread([path,'/',filename,'.wav'],len);
  y = y(:,1);
  y = y./max(y);
  l_y = length(y);
  
  hmw = hamming(an.l_sig);
  
  % Number of frames in the audiofile
  M = floor((l_y - an.l_sig + an.hpsz) / an.hpsz);
  yfft = zeros(an.l_fft, M);
  
  % Computate the FFT for each frame
  ini = 1;
  fin = an.l_sig;
  for m = 1:M,
    yfft(:,m) = (abs(fft(hmw .* y(ini:fin), an.l_fft))) .^ 2;
    ini = ini + an.hpsz;
    fin = fin + an.hpsz;
  end
  yfft = yfft(1:an.l_fft/2,:);
  
  % Compute Log-energy
  loge = log10(sum(yfft) + 0.00001);

  % Save the file
  save(name,'yfft','loge');

end