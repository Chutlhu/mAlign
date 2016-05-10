function [score, midireadOutput] = parseRtfMidiScore(scorePathName, scoreFileName,thrs_msec_note,thrs_msec_rest)

% parseMIDI (function)
%
% Function for parsing the .trs file FILENAME, obtained by C function
% midiread, in directory PATH. When THRS_MSEC is set, short slices are
% ignored. It outputs the cell array SCORE.
%
% INPUT values
% filePath: the absolute or relative path where the .trs file is
% midiFileName: the name of the .trs file
% thrs_msec: threshold in msecs for ignoring short slices
%
% OUPUT values
% score: cell array of polyphonic score slices

    if nargin < 3,
      thrs_msec_note = 0;
      thrs_msec_rest = 0;
    end

    file = [scorePathName, scoreFileName];
    midireadPath = 'util\MIDI\midiread.exe';
    
    % parse the midi file in the following format
    % ||--time--|--dur--|--channel--|--key--|--vel--|--lastMsec--|--lastMsecOff-lastMsec--|--3xAccents--||
    % Acc16 = ?
    % Acc17 = ?
    % Acc18 = ?
    [~, midireadOutput] = system([midireadPath, ' ', file]);

    % Load scan the standard output and reorganize the score in a integer matrix
    midiScore = sscanf(midireadOutput, '%d', [10, inf])';

    nNotes = size(midiScore, 1);

    % if midiScore has 7 colums, add zeros columns
    if size(midiScore, 2) == 7
        midiScore = [midiScore zeros(nNotes,3)];
    end

    % ||--note ON--|--key--|--lastMsec--|--3xAccents--||
    noteONs = [ones(nNotes,1), midiScore(:,[4,6]), midiScore(:,[8,9,10])];
    
    % ||--note OFF--|--key--|--lastMsecOff--|--3xAccents--||
    noteOFFs = [zeros(nNotes,1), midiScore(:,4), midiScore(:,6) + midiScore(:,7), midiScore(:,[8,9,10])];

    % ||--ON/OFF--|--key--|--Time--|--3xAccents--||
    notes = sortrows([noteONs; noteOFFs], [3 1 2]); 

    % Create cell array with data
    % ||--key--|--interOnsetTime--|--Accents--||
    score = cell(nNotes,3);

    % Initialization
    lastOnset = notes(1, 3);
    active = notes(1, 2);
    score{1,1} = active;
    score{1,3} = notes(1, 4:6);
    n = 2;
    p = 1;

    % Loop to create slices
    while n <= nNotes,

      % NOTEON vs NOTEOFF
      if notes(n, 1) > 0,
        active = [active, notes(n, 2)];
        score{p,3} = notes(n, 4:6);
      else
        ll = find(active == notes(n, 2));
        if ~isempty(ll),
          active = [active(1 : ll(1) - 1), active(ll(1) + 1 : end)];
        end
      end

      % Update current slice
      if notes(n, 3) ~= lastOnset,
        score{p, 2} = notes(n, 3) - lastOnset;
        lastOnset = notes(n, 3);
        p = p + 1;
      end
      score{p, 1} = unique(active);

      n = n + 1;
    end

    % % Compound identical slices
    l_score = p - 1;
    keep = ones(l_score, 1);
    % m = 1;
    % for n = 2:l_score,
    %   if isequal(score{m, 1}, score{n, 1}),
    %     keep(n) = 0;
    %     score{m, 2} = score{m, 2} + score{n, 2};
    %   else
    %     m = n;
    %   end
    % end
    score = score(keep > 0, :);

    % Detection of short events
    if score{1, 2} < thrs_msec_note,
        score{2, 2} = score{2, 2} + score{1, 2};
        score = score(2:end, :);
    end
    cicla = 1;
    n = 2;
    while cicla,
      % Short rest slices (for some instrument)
      if score{n, 2} < thrs_msec_rest && ...
          sum(ismember(score{n, 1},score{n - 1, 1})) == length(score{n, 1}),
        score{n - 1, 2} = score{n - 1, 2} + score{n, 2};
        score = [score(1:n - 1, :); score(n + 1:end, :)];

      % Short note slices (present in neighbors)
      elseif score{n, 2} < thrs_msec_note && ...
          sum(ismember(score{n, 1},union(score{n - 1, 1},score{n + 1, 1}))) == length(score{n, 1}),
        score{n - 1, 2} = score{n - 1, 2} + score{n, 2} / 2;
        score{n + 1, 2} = score{n + 1, 2} + score{n, 2} / 2;
        score = [score(1:n - 1, :); score(n + 1:end, :)];
      else
        n = n + 1;
      end

      if n == size(score, 1),
        cicla = 0;
      end
    end
    if score{n, 2} < thrs_msec_rest && ...
        sum(ismember(score{n, 1},score{n - 1, 1})) == length(score{n, 1}),
      score{n - 1, 2} = score{n - 1, 2} + score{n, 2};
      score = [score(1:n - 1, :); score(n + 1:end, :)];
    end
end
