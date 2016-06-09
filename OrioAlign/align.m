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
%       Observations probabilities parameters:
%               uniform, logEnergy_s_th, logEnergy_s_mu, logEnergy_r_th, logEnergy_r_mu, enrg_th, enrg_mu
exp_num = 50;
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
[score, firstOnset] = parseMidiScore(scorePathName, scoreFileName, thrsMillisNote, thrsMillisRest);

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


%% Bank of filters for HMM
fb = makeFB(score, nFilters, analysisParams);

figure()
imagesc(fb.bands(:, 1:500)')
set(gca, 'YDir', 'Normal');
title('Spectrogram generated from the MIDI score');
xlabel('Time (s)');
ylabel('Frequencies (Hz)');

%% Create Hidding Markov Model
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

%% Perform HMM Training and Recognition
probs = zeros(1,6);
recognize; % compute alfa, beta e gamma

%% Results
% filters normalized output for each observation
filtersOutput = zeros(nFrameAudio,1);
% resulting sequence of states
statesSequences = hmm.obs(decodedModel_scaledGamma, 2);

for m = 1:nFrameAudio
    if statesSequences(m) > 0
        filtersOutput(m) = harmonicContents(statesSequences(m), m);
    end
end

sumFiltOutput = filtersOutput(filtersOutput > 0);   % output energy from state
maxFiltOutput = max(harmonicContents)';             % for evert bank the max over time of its throughput
meanFiltOutput = mean(harmonicContents)';           % mean over time the mean over time of its throughput

%% Show performance plot
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
%% Decoded Model using scaled gamma
figure()
fldm = imagesc(log(real(scaledGamma)));
pldm = get(fldm, 'parent');
axis xy
hold on; plot(decodedModel_scaledGamma,'ok'); hold off;
title('S-gamma probabilities');
xlabel('Audio frames (s)');
ylabel('HHM states (notes)');


%% Probability histogram: filterbanks performance
% quello che sento vs quello che vedo se modello con banco dei filtri
% idealmente htot dovrebbe essere molto simile a mtot;
figure()
subplot(2,1,1)
title('Output probability from filterbanks in the original song');
hist([0; sumFiltOutput; 1], 100)
xlabel('Probabilities');
ylabel('Empirical Comulative Density Function (eCDF)');
% max output prob banco di filtri
subplot(2,1,2)
title('Output probability from filterbanks in the HMM model');
hist([0; maxFiltOutput; 1], 100)
xlabel('Probabilities');
ylabel('Empirical Comulative Density Function (eCDF)');
% mean
%subplot(3,1,3)
%title('mean (over time) of output probability: energy from a filter');
%hist([0; meanFiltOutput; 1], 100)

%% Score analysis and FFTs
figure()
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
axis([0 size(ySpectrogram,2)*(analysisParams.windowSize-analysisParams.hopeSize)/analysisParams.Fs 21 90])
title('MIDI piano roll of the score')


[~, ppp] = max(-diff(fb.extrs'));
ppp = max(ppp)+150;
decodedModelOverSpectrogram = zeros(size(ySpectrogram));
decodedModel = zeros(size(ySpectrogram));
for m = 1:nFrameAudio
    if hmm.obs(decodedModel_scaledGamma(m), 1) % it is not a rest
        decodedModel(:, m) = fb.bands(hmm.obs(decodedModel_scaledGamma(m),2),:);
        decodedModelOverSpectrogram(:, m) = ySpectrogram(:, m) .* decodedModel(:,m);
    end
end

subplot(3,1,2)
imagesc(log(ySpectrogram(1:ppp,:)))
title('Log-magnitude of the song')
set(gca, 'YDir', 'Normal');
title('Spectrogram of the song');
xlabel('Frames (s)');
ylabel('Frequencies (Hz)');
colormap('bone');

subplot(3,1,3)
imagesc(log(decodedModelOverSpectrogram(1:ppp,:) + ySpectrogram(1:ppp,:) / 10000))
set(gca, 'YDir', 'Normal');
title('Alligned score over spectrogram')
xlabel('Frames (s)');
ylabel('Frequencies (Hz)');


%% Parameters trend

% alpha
figure()
subplot(3,2,1)
hold off;
imagesc(log(real(alfa)))
axis xy
hold on; plot(decodedModel_alpha,'ok'); hold off;
title('Alligment using ALPHA probabilities')
xlabel('Audio frames (s)');
ylabel('HHM states (notes)');

% delta
subplot(3,2,3)
hold off;
imagesc(delta)
axis xy
hold on; plot(decodedModel_delta,'ok'); hold off;
title('Alligment using DELTA probabilities')
xlabel('Audio frames (s)');
ylabel('HHM states (notes)');

% gamma
subplot(3,2,5)
hold off;
imagesc(log(real(gamma)))
axis xy
hold on; plot(decodedModel_gamma,'ok');
title('Alligment using GAMMA probabilities')
xlabel('Audio frames (s)');
ylabel('HHM states (notes)');

% log alpha
subplot(3,2,2)
hold off;
imagesc(log(real(alfa)))
axis xy
hold on;
plot(decodedModel_alpha,'ok')
title('Alligment using LOG ALPHA probabilities')
xlabel('Audio frames (s)');
ylabel('HHM states (notes)');

% scaled delta
subplot(3,2,4)
hold off;
imagesc(delta)
axis xy
hold on;
plot(decodedModel_scaledDelta,'ok')
title('Alligment using SCALED DELTA probabilities')
xlabel('Audio frames (s)');
ylabel('HHM states (notes)');

% scaled gamma
subplot(3,2,6)
hold off;
imagesc(log(real(scaledGamma)))
axis xy
hold on;
plot(decodedModel_scaledGamma,'ok')
title('Alligment using SCALED GAMMA probabilities')
xlabel('Audio frames (s)');
ylabel('HHM states (notes)');



