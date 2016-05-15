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
% an.windowSize: the length of the signal (an.windowSize <= an.nFFT)
% an.hopeSize: the hopsize between subsequent windows
%
% OUPUT values
% ySpectrogram: matrix of the fft absolute values
% logEnergy: array with the log-energy of each frame
% +
% a file named "filename-(an.nFFT)-(an.windowSize)-(an.hopeSize).mat" in path

name = [path, filename, '-', num2str(analysisParams.nFFT), '-', num2str(analysisParams.windowSize), '-', num2str(analysisParams.hopeSize), '.mat'];

% Check if already computed, with the same parameters
try

  load(name);

% If not, compute the yfft
catch
  
  % Load and normalize the audiofile
  y = audioread([path, filename]);

  % to mono
  if size(y,2) == 2
    y = 0.5*(y(:,1) + y(:,2));
  end
  y = y./max(abs(y));
  nSamples = length(y);
  
  window = hamming(analysisParams.windowSize);
  
  % Number of frames in the audiofile
  nFrames = floor((nSamples - analysisParams.windowSize + analysisParams.hopeSize) / analysisParams.hopeSize);
  ySpectrogram = zeros(analysisParams.nFFT, nFrames);
  
  % Computate the FFT for each frame
  ini = 1;
  fin = analysisParams.windowSize;
  for m = 1:nFrames,
    ySpectrogram(:,m) = (abs(fft(window .* y(ini:fin), analysisParams.nFFT))) .^ 2;
    ini = ini + analysisParams.hopeSize;
    fin = fin + analysisParams.hopeSize;
  end
  
  ySpectrogram = ySpectrogram(1:analysisParams.nFFT/2,:);
  
  % Compute Log-energy
  logEnergy = log10(sum(ySpectrogram) + 0.00001);

  % Save the file
  save(name,'ySpectrogram','logEnergy');

end
