%function probs = recognize(hmm,fb,pdfs,ySpectrogram,logEnergy)

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
N = length(hmm.prior);
M = length(logEnergy);

% Clip logEnergy
c_logEnergy = logEnergy;
void = logEnergy > pdfs.logEnergy_s_th;
c_logEnergy(void) = pdfs.logEnergy_s_th;
void = logEnergy < pdfs.logEnergy_r_th;
c_logEnergy(void) = pdfs.logEnergy_r_th;

% Compute filters normalized output
ortomio = (fb.bands * ySpectrogram);
outfilt = (fb.bands * ySpectrogram) ./ (fb.extrs * ySpectrogram);
logEnergy_s = exp( (c_logEnergy - pdfs.logEnergy_s_th) / pdfs.logEnergy_s_mu ) / pdfs.logEnergy_s_mu;
logEnergy_r = exp( (pdfs.logEnergy_r_th - c_logEnergy) / pdfs.logEnergy_r_mu ) / pdfs.logEnergy_r_mu * pdfs.uniform;

% Compute probabilities
obsli = zeros(N, M);
for n = 1:N,
  if hmm.obs(n, 1),
    obsli(n, :) = logEnergy_s .* exp( (outfilt(hmm.obs(n, 2), :) - pdfs.enrg_th) / pdfs.enrg_mu ) / pdfs.enrg_mu;
  else
    obsli(n, :) = logEnergy_r;
  end
end
logobsli = log(obsli);

% Initializations
alfa = zeros(N, M);     % forward probabilities -> ottimo locale senza info futura
c = zeros(M, 1);
beta = zeros(N, M);     % backwards probabilities (se e` in tempo reale beta non lo uso, ma si offline)
sbeta = zeros(N, M);    
delta = zeros(N, M);    % prob di transizione (viterbi)
psi = zeros(N, M);
gamma = zeros(N, M);    % alfa times beta = osservazione in quel punto dato -> ottimo locale con info futura
sgamma = zeros(N, M);

% Scaled forward (alfa) probabilities and logarithmic Viterbi (delta, psi) decoding
alfa(:, 1) = hmm.prior .* obsli(:, 1);
c(1) = sum(alfa(:, 1));
alfa(:, 1) = alfa(:, 1) / c(1);
delta(:, 1) = hmm.logPrior + logobsli(:, 1);
for m = 2:M,
  alfa(:, m) = (hmm.trans' * alfa(:, m - 1)) .* obsli(:, m);
  c(m) = sum(alfa(:, m));
  alfa(:, m) = alfa(:, m) / c(m);
  
  for n = 1:N,
    [delta(n, m), psi(n, m)] = max(delta(:, m - 1) + hmm.logTrans(:, n));
    delta(n, m) = delta(n, m) + logobsli(n, m);
  end,
end

% Scaled backward (beta) probabilities, normal and restricted
beta(:, M) = ones(N, 1) / c(M);
sbeta(:, M) = zeros(N, 1);

% ATTENZIONE VARIZIONE SGAMMA
%sbeta(3*n_sust:N, M) = 1 / c(M);
% FINE VARIAZIONE
sbeta(N, M) = 1 / c(M);

for m = M-1:-1:1,
  beta(:, m) = (hmm.trans * (beta(:, m + 1) .* obsli(:, m + 1))) / c(m);
  sbeta(:, m) = (hmm.trans * (sbeta(:, m + 1) .* obsli(:, m + 1))) / c(m);
end

% Forward-backward (gamma) probabilities, normal and restricted
gamma = alfa .* beta;
sgamma = alfa .* sbeta;

% Approaches to the recognition problem       
probs = zeros(1,6);

% Normal condition
% ALPHA -> P( o_1 ... o_T | l )
[void decod_a] = max(real(alfa));
probs(1) = sum(log(c));

% DELTA -> P( o_1 ... o_T | q_1 ... q_T , l )
decod_d = zeros(M,1);
[void, decod_d(M)] = max(real(delta(:, M)));
for m = M-1:-1:1
  decod_d(m) = psi(decod_d(m+1), m+1);
end
for m = 1:M
  probs(2) = probs(2) + logobsli(decod_d(m), m);
end

% GAMMA -> prod_t{ P ( o_t | q_t , l ) }
[void, decod_g] = max(real(gamma));
for m = 1:M
  probs(3) = probs(3) + logobsli(decod_g(m), m);
end

% Restricted
% ALFA_END
probs(4) = sum(log(c(1:end-1))) + log(alfa(N, M));

% DELTA_END
decod_sd = zeros(M,1);
decod_sd(M) = N;
for m = M-1:-1:1
  decod_sd(m) = psi(decod_sd(m+1), m+1);
end
for m = 1:M
  probs(5) = probs(5) + logobsli(decod_sd(m), m);
end

% GAMMA_END
[void, decod_sg] = max(real(sgamma));
for m = 1:M
  probs(6) = probs(6) + logobsli(decod_sg(m), m);
end
