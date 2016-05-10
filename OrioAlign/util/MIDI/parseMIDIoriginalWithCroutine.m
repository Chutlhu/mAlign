function score = parseMIDI(path,filename,thrs_msec_note,thrs_msec_rest)

% parseMIDI (function)
%
% Function for parsing the .trs file FILENAME, obtained by C function
% midiread, in directory PATH. When THRS_MSEC is set, short slices are
% ignored. It outputs the cell array SCORE.
%
% INPUT values
% path: the absolute or relative path where the .trs file is
% filename: the name of the .trs file
% thrs_msec: threshold in msecs for ignoring short slices
%
% OUPUT values
% score: cell array of polyphonic score slices

if nargin < 3,
  thrs_msec_note = 0;
end

% Load .trs file and reorganize the score
midisco = load([path,'/',filename,'.trs'],'ASCII');
[~, standardOutput] = system('midiread.exe vicazPT2.mid');

midisco = sscanf(standardOutput, '%d', [10, inf])';

l_notes = size(midisco,1);

noteons = [ones(l_notes,1),midisco(:,[4,6,3])];
noteofs = [zeros(l_notes,1),midisco(:,4),midisco(:,6)+midisco(:,7),midisco(:,3)];

% Structure of notes: [ON/OFF NoteNum Time]
notes = sortrows([noteons;noteofs],[3 1 2]);
l_notes = size(notes,1);

% Create cell array with initial data
score = cell(l_notes,3);
% TODO : vedere se e' possibile fare un'unica inizializzazione
for n =1:l_notes,
  score{n,3} = 0;
end

% Initialization
lastOnset = notes(1,3);
active = notes(1,2);
score{1,1} = active;
if notes(1,4) == 0,
  score{1,3} = notes(1,2);
end

% Loop to create slices
p = 1;
for n = 2:l_notes,

  % NOTEON vs NOTEOFF
  if notes(n,1),
    active = [active,notes(n,2)];
  else
    pp = find(active == notes(n,2));
    if ~isempty(pp),
      active = [active(1:pp(1)-1),active(pp(1)+1:end)];
    end
  end

  % Update duration of current slice
  if notes(n,3) ~= lastOnset,
    score{p,2} = notes(n,3) - lastOnset;
    lastOnset = notes(n,3);
    p = p + 1;
  end

  % Continuous update of active notes and note to follow
  score{p,1} = unique(active);
  if notes(n,1) == 1 && notes(n,4) == 0,
    score{p,3} = notes(n,2);
  end

end

l_score = p - 1;
score = score(1:l_score,:);

% % Compound identical slices
% keep = ones(l_score, 1);
% m = 1;
% for n = 2:l_score,
%   if isequal(score{m, 1}, score{n, 1}),
%     keep(n) = 0;
%     score{m, 2} = score{m, 2} + score{n, 2};
%   else
%     m = n;
%   end
% end
% score = score(find(keep > 0), :);

% TODO: ciclare anche sulle prime note
if score{1,2} < thrs_msec_note,
  score{2,2} = score{2,2} + score{1,2};
  score = score(2:end,:);
end
cicla = 1;
n = 2;
while cicla,
  % Treat separately complete silence
  if isempty(score{n,1}),
    % Short rest slices (all instruments)
    if score{n,2} < thrs_msec_rest,
      score{n-1,2} = score{n-1,2} + score{n,2};
      score = [score(1:n-1,:); score(n+1:end,:)];
    else
      n = n + 1;
    end
  else
    % Short rest slices (for some instrument)
    if score{n,2} < thrs_msec_rest && isempty(setdiff(score{n,1},score{n-1,1})),
      score{n-1,2} = score{n-1,2} + score{n,2};
      score = [score(1:n-1,:); score(n+1:end,:)];
      % Short rest slices (for some instrument)
    elseif score{n,2} < thrs_msec_rest && isempty(setdiff(score{n,1},score{n+1,1})),
      score{n+1,2} = score{n+1,2} + score{n,2};
      score = [score(1:n-1,:); score(n+1:end,:)];


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

