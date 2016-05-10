function fb = makeFB(score, nFilters, analysisParams)

% makeFB (function)
%
% Function for creating the filterbanalysisParamsk for polyphonic SCORE,
% each bank with nFilters filters. It needs the sampling rate
% analysisParams.FS and the FFT length analysisParams.nFFT.
%
% INPUT values
% score: cell array of polyphonic score slices
% nFilters: number of filters for each banalysisParamsk
% analysisParams.Fs: sampling rate
% analysisParams.nFFT: window length of the FFT
%
% OUPUT values
% fb.banks: matrix of filterbanks
% fb.extrs: support for each filterbanalysisParamsk

% Interval of a semitone
st1 = 2 ^ (1 / 12) - 1;

nNotes = size(score, 1);

% Initialization
bands = zeros(nNotes, analysisParams.nFFT / 2);
extrs = zeros(nNotes, analysisParams.nFFT / 2);
tmpext = [analysisParams.nFFT / 2, 1];
  
for n = 1:nNotes,
  
  for m = 1:length(score{n, 1}),

    % From MIDI notes to Hertz
    freq = 440 * exp((score{n, 1}(m) - 69) * log(2) / 12);

    % Set to one the passbands for each filter
    for p = 1:nFilters,
      wd = floor(0.5 * freq * p * st1 * analysisParams.nFFT / analysisParams.Fs);
      f = 1 + round(freq * p * analysisParams.nFFT / analysisParams.Fs);
      bands(n, f - wd : f + wd) = ones(1, 2 * wd + 1);
    end

    % Compute the support for the whole filterbank
    tmpext = [max(1, min(tmpext(1), floor(( freq / 2) * analysisParams.nFFT / analysisParams.Fs))),...
              min(analysisParams.nFFT / 2, max(tmpext(2), ceil(freq * nFilters * (1 + 2 * st1) * analysisParams.nFFT / analysisParams.Fs)))];
  end

  if ~isempty(score{n, 1}),
    extrs(n, tmpext(1) : tmpext(2)) = 1;
  else
    extrs(n, :) = 1;
  end

  % ATTENZIONE: Variazione per Exp_nr6
  extrs(n, :) = 1;
  % fine variazione per Exp_nr6
  
end

fb = struct('bands', bands, 'extrs', extrs);
