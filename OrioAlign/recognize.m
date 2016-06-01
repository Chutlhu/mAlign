%function probs = recognize(hmm, fb, pdfs, ySpectrogram, logEnergy)

% recognize (function)
%
% Function for computing the probabilities by which .wav
% file (ySpectrogram, logEnergy) correspond to a .trs file (HMM,FB)
% when PDFS are used for computing probabilities.
%
% INPUT values
% hmm: Hidden Markov Model created by makeHMM
% fb: filterbank created by makeFB
% pdfs: the thresholds and the decading factors of PDFs
% ySpectrogram: matrix of the fft absolute values
% logEnergy: array with the log-energy of each frame
%
% OUTPUT values
% probs(1): using pure forward probabilities
% probs(2): using probability of Viterbi decoding
% probs(3): using forward-backward probabilities
% probs(x+3): same but last state corresponds to last frame

% Number of frames in score and performance
nFrameScore = length(hmm.prior);
nFrameAudio = length(logEnergy);

%% Acoustic features

% Clip logEnergy
clippedLogEnergy = logEnergy;
clippedLogEnergy(logEnergy > pdfs.logEnergy_s_th) = pdfs.logEnergy_s_th;
clippedLogEnergy(logEnergy < pdfs.logEnergy_r_th) = pdfs.logEnergy_r_th;

% Frequencies peack features: harmonic content for event (rows) over time (columns)
% that is the Peak Structured Distance - 1.
harmonicContents = (fb.bands * ySpectrogram) ./ (fb.extrs * ySpectrogram);

%% Observation probabilities
% Probability to observe the Log Energy feature being in a...
% ... sustain/note state as Truncated Unilateral Exponential
obsProb_sustain_logEnergy = exp( (clippedLogEnergy - pdfs.logEnergy_s_th) / pdfs.logEnergy_s_mu ) / pdfs.logEnergy_s_mu;
% ... rest state as Truncated Unilateral Exponential
obsProb_rest_logEnergy = exp( (pdfs.logEnergy_r_th - clippedLogEnergy) / pdfs.logEnergy_r_mu ) / pdfs.logEnergy_r_mu * pdfs.uniform;

obsProb = zeros(nFrameScore, nFrameAudio);
for n = 1:nFrameScore,
  if hmm.obs(n, 1),
    % Probability to observe that amount of energy being in a sustin/note state
    % TO DO: why it is the Truncated Unilateral Exponential?
    obsProb_sustain_filterbanks = exp( (harmonicContents(hmm.obs(n, 2), :) - pdfs.enrg_th) / pdfs.enrg_mu ) / pdfs.enrg_mu;
    % TO DO: try with different distribution as suggested in the paper???
    % maybe it is the unilateral without the constant factor
    
    % joint probability (under indipendence assumption)
    obsProb(n, :) = obsProb_sustain_logEnergy .* obsProb_sustain_filterbanks;
  else
    % No harmonic content for rest state
    obsProb(n, :) = obsProb_rest_logEnergy;
  end
end
logObsProb = log(obsProb); % used to avoid comutational error

%% HMM Training
% Initializations
alfa = zeros(nFrameScore, nFrameAudio);     % forward probabilities. It provides only local optimum with no information about the future
                                            % that is, coming from the past
c = zeros(nFrameAudio, 1);
beta = zeros(nFrameScore, nFrameAudio);     % backwards probabilities (can be used only for offline modelling)
                                            % that is, coming from the future
scaledBeta = zeros(nFrameScore, nFrameAudio);    
delta = zeros(nFrameScore, nFrameAudio);    % transition probabilities for Viterbi decoding
psi = zeros(nFrameScore, nFrameAudio);
gamma = zeros(nFrameScore, nFrameAudio);    % alfa times beta. It provides a global optimum exploiting information jointly 
                                            % from past and future
scaledGamma = zeros(nFrameScore, nFrameAudio);

% Scaled forward (alfa) probabilities and logarithmic Viterbi (delta, psi) decoding
alfa(:, 1) = hmm.prior .* obsProb(:, 1);
c(1) = sum(alfa(:, 1));
alfa(:, 1) = alfa(:, 1) / c(1);
delta(:, 1) = hmm.logPrior + logObsProb(:, 1);
for m = 2:nFrameAudio,
  alfa(:, m) = (hmm.trans' * alfa(:, m - 1)) .* obsProb(:, m);
  c(m) = sum(alfa(:, m));
  alfa(:, m) = alfa(:, m) / c(m);
  
  for n = 1:nFrameScore,
    [delta(n, m), psi(n, m)] = max(delta(:, m - 1) + hmm.logTrans(:, n));
    delta(n, m) = delta(n, m) + logObsProb(n, m);
  end,
end

% Scaled backward (beta) probabilities, normal and restricted
beta(:, nFrameAudio) = ones(nFrameScore, 1) / c(nFrameAudio);
scaledBeta(:, nFrameAudio) = zeros(nFrameScore, 1);

% ATTENZIONE VARIZIONE SGAMMA
%sbeta(3*n_sust:N, M) = 1 / c(M);
% FINE VARIAZIONE
scaledBeta(nFrameScore, nFrameAudio) = 1 / c(nFrameAudio);

for m = nFrameAudio-1:-1:1,
  beta(:, m) = (hmm.trans * (beta(:, m + 1) .* obsProb(:, m + 1))) / c(m);
  scaledBeta(:, m) = (hmm.trans * (scaledBeta(:, m + 1) .* obsProb(:, m + 1))) / c(m);
end

% Forward-backward (gamma) probabilities, normal and restricted
gamma = alfa .* beta;
scaledGamma = alfa .* scaledBeta;

%% Approaches to the recognition problem       
% Viterbi algorithm for decoding

probs = zeros(1,6);

% Normal condition
% ALPHA -> P( o_1 ... o_T | l )
[~, decodedModel_alpha] = max(real(alfa));
probs(1) = sum(log(c));

% DELTA -> P( o_1 ... o_T | q_1 ... q_T , l )
decodedModel_delta = zeros(nFrameAudio,1);
[~, decodedModel_delta(nFrameAudio)] = max(real(delta(:, nFrameAudio)));
for m = nFrameAudio-1:-1:1
  decodedModel_delta(m) = psi(decodedModel_delta(m+1), m+1);
end
for m = 1:nFrameAudio
  probs(2) = probs(2) + logObsProb(decodedModel_delta(m), m);
end

% GAMMA -> prod_t{ P ( o_t | q_t , l ) }
[~, decodedModel_gamma] = max(real(gamma));
for m = 1:nFrameAudio
  probs(3) = probs(3) + logObsProb(decodedModel_gamma(m), m);
end

% Restricted
% ALFA_END
probs(4) = sum(log(c(1:end-1))) + log(alfa(nFrameScore, nFrameAudio));

% DELTA_END
decodedModel_scaledDelta = zeros(nFrameAudio,1);
decodedModel_scaledDelta(nFrameAudio) = nFrameScore;

for m = nFrameAudio-1:-1:1
  decodedModel_scaledDelta(m) = psi(decodedModel_scaledDelta(m+1), m+1);
end
for m = 1:nFrameAudio
  probs(5) = probs(5) + logObsProb(decodedModel_scaledDelta(m), m);
end

% GAMMA_END
[void, decodedModel_scaledGamma] = max(real(scaledGamma));
for m = 1:nFrameAudio
  probs(6) = probs(6) + logObsProb(decodedModel_scaledGamma(m), m);
end