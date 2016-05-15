%%           mAlign               %%
%   SCRIPT for the alignment test %

clear all;
close all;

%% Setup
% add folders and subfolders to working path
addpath(genpath('./'))

%% Flags

%% Experimental parameters
% NB:   Thresholds for merging events:
%               thrs_msec_note, thrs_msec_rest
%       Number of sustain states in the network:
%               nSustStates 
%       Number of filters in the filterbanalysisParamsk:
%               nFilters
%       Analysis Parameters:
%               Fs, nFFT, l_sig, hpsz
%       Observations probabilities:
%               uniform, logEnergy_s_th, logEnergy_s_mu, logEnergy_r_th, logEnergy_r_mu, enrg_th, enrg_mu
exp_num = 15;
setParameters;

%% Load audio and MIDI files
scorePathName = 'score\';
audioPathName = 'audio\';
[scoreFileName] = uigetfile('*.mid', 'Select the MIDI file', scorePathName);
[audioFileName] = uigetfile({'*.wav', '.mp3'}, 'Select the audio file', audioPathName);

%% Load the score from MIDI file
% thresholding for avoid model overfitting
% to smoothare le variazioni (interpretazione si allontana dalla partiture)
% e dipende dalla risoluzione del midi
% ===> re introdurre le soglie!
% evito stati "tappo" <= modello eventi molto rari e il modello si blocca
[score, firstOnset] = parseMidiScore(scorePathName, scoreFileName);

%% Remove long rests
% ATTENZIONE!
% Compound rests with previous events
% compatta le partiture quanalysisParamsdo ci sono lunghe pause;
% sarebbe da toglire per altri generi musicale
% zz = 2;
% while zz <= length(score)
%   if isempty(score{zz,1})
%     score{zz - 1, 2} = score{zz - 1, 2} + score{zz, 2};
%     score = [score(1:zz-1,:); score(zz+1:end,:)];
%   end
%   zz = zz + 1;
% end

%% Create Hidding Markov Model
% bank of filters for HMM
fb = makeFB(score, nFilters, analysisParams);

% NB:   nSustStates:
%           numero stati sustain per simulare la durata di una nota (2 - 4 stati)
%       analysisParams
%           training from parameters (setParameters)
%       model_rest
%           do (or not) model for rest (do not necessary for polyphonic
%           music)
hmm = makeHMM(score, nSustStates, analysisParams, model_rest);

%% Import audio
[ySpectrogram, logEnergy] = doFFT(audioPathName, audioFileName, analysisParams); % normale fft, ma scrivo e riutilizzo fft gia` fatto in precedenza
% spectrogram = matrix of the fft absolute values
% logEnergy: array with the log-energy of each frame

%% Perform HMM Training
probs = zeros(1,6);
recognize; % compute alfa, beta e gamma

%% Results
h1 = zeros(nFrameAudio,1); 
g1 = hmm.obs(decod_sg, 2);

for m = 1:nFrameAudio
  if g1(m) > 0
    h1(m) = outfilt(g1(m),m); % compute filters normalized output for each observation
  end
end

sumFiltOutput = h1(h1>0);       % output energy from a bank given the state
maxFiltOutput = max(outfilt)';  % max over time
meanFiltOutput = mean(outfilt)';% mean over time

%% Show results
% qui lo stampa solo, ma e` l'info che utilizzo per l'allineamento

figure(1)
% grafico piu` promettente
% alfa e` un "ottimo locale" => ok per realtime
% beta informazione futura
% log e fattori di normalizzazione per rappresentazine in macchina
% allienamento con alfa e gamma potrei avere dei salti (probabile in
% live). (tengono aperte tutte le prob => tanti percorsi possibili)
% allineamente che tiene conto dell'ottimo globale (con delta da
% Viterbi) => ok per canzoni delle quali si ha lo score "preciso")

% sgamma => (se so che iniziano e finisco allora stesso tempo (score e
% musica) - informazione in piu` che sto utilizzando
fldm = imagesc(log(real(sgamma)));
pldm = get(fldm,'parent');
axis xy
plot(decod_sg,'ok')
title('S-gamma probabilities');

figure(2)
% Probability histogram: performance del banco dei filtri
% quello che sento vs quello che vedo se modello con banco dei filtri
% idealmente htot dovrebbe essere molto simile a mtot;
subplot(3,1,1)
title('Output probability: energy from a filter at given time');
hist([0; sumFiltOutput; 1], 100)
% max output prob banco di filtri
subplot(3,1,2)
title('max (over time) of output probability: energy from filter bank');
hist([0; maxFiltOutput; 1], 100)
% mean
subplot(3,1,3)
title('mean (over time) of output probability: energy from a filter');
hist([0; meanFiltOutput; 1], 100)

%%%%%%%%%%%%%%%%
% Score analysisParamsd FFTs
figure(3)
subplot(3,1,1)
fpos = firstOnset;
    for n = 1:length(score)
        ipos = fpos;
        fpos = ipos + score{n, 2};

        notes = score{n,1};
        for m = 1:length(notes)
            nt = notes(m);
            line([ipos,fpos],[nt,nt],'LineWidth',3,'LineStyle','-','Color',[0 0 0])
        end
    end
title('MIDI pianoo roll of the score')  

[void, ppp] = max(-diff(fb.extrs'));
ppp = max(ppp)+50;
fy = zeros(size(ySpectrogram));
for m = 1:length(notes)
    if hmm.obs(decod_sg(m), 1),
      fy(:,m) = ySpectrogram(:, m) .* fb.bands(hmm.obs(decod_sg(m),2), :)';
    end
end

subplot(3,1,2)
imagesc(log(ySpectrogram(1:ppp,:)))

title('Log-magnitude of the song')
subplot(3,1,3)
imagesc(log(fy(1:ppp,:) + ySpectrogram(1:ppp,:) / 10000))
title('Log-magnitude of ???')

%%%%%%%%%%%%%%%%%%
% Parameters trend

% ALFA
figure(3)
subplot(3,1,1)
hold off;
imagesc(log(real(alfa)))
axis xy
hold on;
plot(decod_a,'ok')

% DELTA
subplot(3,1,2)
hold off;
imagesc(delta)
axis xy
hold on;
plot(decod_d,'ok')

% GAMMA
subplot(3,1,3)
hold off;
imagesc(log(real(gamma)))
axis xy
hold on;
plot(decod_g,'ok')

figure(4)
subplot(3,1,1)
hold off;
imagesc(log(real(alfa)))
axis xy
hold on;
plot(decod_a,'ok')

subplot(3,1,2)
hold off;
imagesc(delta)
axis xy
hold on;
plot(decod_sd,'ok')

subplot(3,1,3)
hold off;
imagesc(log(real(sgamma)))
axis xy
hold on;
plot(decod_sg,'ok')



% % Trascurare?!
% 
% squerror = zeros(3,1);
% l_xy = zeros(3,1);
% for tst = 1:3
% dcd = zeros(M,1);
% switch tst
%   case 1
%     [void, dcd] = max(real(alfa));
%   case 2
%     [void, dcd(M)] = max(delta(:,M));
%     for m = M-1:-1:1
%       dcd(m) = psi(dcd(m+1), m+1);
%     end
%   case 3
%     [void, dcd] = max(real(gamma));
% end
% 
% last_n = 1;
% timesum = 0;
% xy = zeros(ceil(dcd(M) / nSustStates),2);
% k = 0;
% for m = 2:M
%   if dcd(m) ~= last_n && rem(dcd(m) - 2, nSustStates) == 0
%     last_n = dcd(m);
%     k = k + 1;
%     xy(k,:) = [m,timesum];
%     timesum = timesum + hmm.obs(last_n,3);
%   end
% end
% 
% if xy(k,1) ~= M
%   k = k + 1;
%   xy(k,:) = [M, timesum];
% end
% 
% xy = xy(1:k,:);
% p = polyfit(xy(:,1),xy(:,2),1);
% 
%  figure(6)
%  subplot(3,1,tst)
%  hold off
%  plot(xy(:,1),xy(:,2),'or')
%  hold on
%  plot([xy(1,1),xy(end,1)],p(1)*[xy(1,1),xy(end,1)]+p(2),'k')
% 
% l_xy(tst) = size(xy,1);
% fact = ( p(1)^2 + 1 );
% squerror(tst) = 0;
% for m = 1:l_xy(tst)
%   squerror(tst) = squerror(tst) + ( -p(1)*xy(m,1) + xy(m,2) - p(2) )^2 / fact;
% end
%     squerror(tst) = squerror(tst) / l_xy(tst);
% end
% disp(log(squerror'))
% end
