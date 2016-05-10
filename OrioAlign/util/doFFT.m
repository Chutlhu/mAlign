function [ySpectrogram, logEnergy] = doFFT(path, filename, analysisParams)

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
% an.nFFT: the length of the window for the fft
% an.l_sig: the length of the signal (an.l_sig <= an.nFFT)
% an.hpsz: the hopsize between subsequent windows
%
% OUPUT values
% yfft: matrix of the fft absolute values
% logEnergy: array with the log-energy of each frame
% +
% a file named "filename-(an.nFFT)-(an.l_sig)-(an.hpsz).mat" in path

name = [path, filename, '-', num2str(analysisParams.nFFT), '-', num2str(analysisParams.l_sig), '-', num2str(analysisParams.hpsz), '.mat'];

% Check if already computed, with the same parameters
try

  load(name);

% If not, compute the yfft
catch
  
  % Load and normalize the audiofile

  y = audioread([path, filename]);
  y = y(:,1);

  % ATTENZIONE: parte per Exp_nr7 e Exp_nr9
  %y = y(1:end-7000);

  y = y./max(abs(y));
  l_y = length(y);
  
  hmw = hamming(analysisParams.l_sig);
  
  % Number of frames in the audiofile
  M = floor((l_y - analysisParams.l_sig + analysisParams.hpsz) / analysisParams.hpsz);
  ySpectrogram = zeros(analysisParams.nFFT, M);
  
  % Computate the FFT for each frame
  ini = 1;
  fin = analysisParams.l_sig;
  for m = 1:M,
    ySpectrogram(:,m) = (abs(fft(hmw .* y(ini:fin), analysisParams.nFFT))) .^ 2;
    ini = ini + analysisParams.hpsz;
    fin = fin + analysisParams.hpsz;
  end
  ySpectrogram = ySpectrogram(1:analysisParams.nFFT/2,:);
  
  % Compute Log-energy
  logEnergy = log10(sum(ySpectrogram) + 0.00001);

  % Save the file
  save(name,'ySpectrogram','logEnergy');

end
