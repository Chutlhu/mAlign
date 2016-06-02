function hmm = makeHMM(score, nSustStates, analysisParams, model_rest)

% makeHMM (function)
%
% Function for creating the Hidden Markov Model for polyphonic
% SCORE.
%
% INPUT values
% score: cell array of polyphonic score slices
% nSustStates: number of sustain states
% analysisParams.Fs: sampling rate
% analysisParams.hopeSize: hopsize between adjacent frames
%
% OUPUT values
% hmm.prior: probabilities of being first state
% hmm.trans: transition probabilities
% hmm.obs: pointer to filterbanks, for computing observations
% hmm.logprior: probabilities of beeing first state in log scale
% hmm.logtrans: transition probabilities in log scale

nNotes = size(score, 1);

% Max number of HMM states
nHMMStates = 2 + (nSustStates + 1) * nNotes;

% Expected number of times in slice
% n_self = ceil(cell2mat(score(:, 2)) * analysisParams.Fs / (analysisParams.hopeSize * 1000));
nSelfloops = ceil(cell2mat(score(:, 2)) * analysisParams.Fs / (analysisParams.hopeSize));
selfTransProb = (nSelfloops - nSustStates + 1) ./ nSelfloops;

% Take care of very short slices
selfTransProb(selfTransProb <= 0.1) = 0.1;

% Initialization
prior = zeros(nHMMStates, 1);
trans = zeros(nHMMStates, nHMMStates);
obs = zeros(nHMMStates, 3);

% First state
state = 1;
prior(state) = 1;
trans(state, state) = 0.5;
trans(state, state+1) = 0.5;
% pointer to the filterbanks: [ATTACK/SUSTAIN | STATE_LABEL | TIME SLICE]
obs(state, :) = [0, 0, 0];

% Slices in the score
% fill all the first and the second diagonal
state = 2;
for n = 1:nNotes-1
    
    % Check if slice has notes
    if ~isempty(score{n, 1})
        
        %  Model Sustain on a note
        for m=1:nSustStates,
            trans(state, state) = selfTransProb(n);
            trans(state, state + 1) = 1 - selfTransProb(n);
            obs(state, :) = [1, n, score{n, 2}];
            if ~model_rest && isempty(score{n, 1})
                obs(state, 3) = obs(state, 3) + score{n + 1, 2};
            end
            state = state + 1;
        end
        
        % Check if possible articulation rest state at the end (take flag into account)
        if model_rest && (length(score{n, 1}) == 1 ...
                || (isempty(intersect(score{n, 1}, score{n + 1, 1})) ...
                && ~isempty(score{n + 1, 1})) )
            % Modify last sustain
            trans(state - 1, state) = (1 - selfTransProb(n)) / 2;
            trans(state - 1, state + 1) = (1 - selfTransProb(n)) / 2;
            % Add articulation rest
            trans(state, state) = 0.5;
            trans(state, state + 1) = 0.5;
            obs(state, :) = [0, n];
            state = state + 1;
        end
    else
        
        % REST
        if model_rest
            for m=1:nSustStates,
                trans(state, state) = selfTransProb(n);
                trans(state, state + 1) = 1 - selfTransProb(n);
                obs(state,:)=[0, n, score{n, 2}];
                state = state + 1;
            end
        end
        
    end
    
end

% Last slice, is always a sustain, with no articulation rest
for m = 1:nSustStates
    trans(state, state) = selfTransProb( nNotes );
    trans(state, state + 1) = 1 - selfTransProb( nNotes );
    obs(state, :) = [1, nNotes, score{nNotes,2}];
    state = state + 1;
end

% Resize HMM
nHMMStates = state;
prior = prior(1:nHMMStates);
trans = trans(1:nHMMStates, 1:nHMMStates);
obs = obs(1:nHMMStates, :);

% Last state is always a rest
trans(nHMMStates, nHMMStates) = 1;
obs(nHMMStates, :) = [0, 0, 0];

% Should already be stochastic, yet...
trans = mkStochastic(trans);

% Compute HMM with log transitions
logPrior = zeros(nHMMStates, 1);
logTrans = zeros(nHMMStates, nHMMStates);

for n = 1:nHMMStates
    if prior(n) > 0
        logPrior(n, 1) = log(prior(n));
    else
        logPrior(n, 1) = -Inf;
    end
    
    for m = 1:nHMMStates,
        if trans(n, m) > 0,
            logTrans(n, m) = log(trans(n, m));
        else
            logTrans(n, m) = -Inf;
        end
    end
end

% Create structure to be output
hmm = struct('prior', prior, 'trans', trans, 'obs', obs, 'logPrior', logPrior, 'logTrans', logTrans);
