function monosco = makeMONO(nmat,ppqn)
% 
% Input:
%   nmat = matrice con un solo canale del tipo .trs senza la prima riga
%   ppqn = fattore di conversione per il formato del miditoolbox
% 
% Output:
%   monosco = matrice nmat monofonica
  
% Trasforma la matrice nel tipo miditoolbox
midisco = [nmat(:,1:2) / ppqn, nmat(:,3:6), nmat(:,6:7) / 1000];

midisco = nmat;

% Normalizzazione
vv = find(midisco(:,1) > 0);
midisco = quantize(midisco, 1/48, 1/48);

midisco = [midisco(:,1:2) * ppqn, midisco(:,3:6), midisco(:,6:7) * 1000];

rat = mean(midisco(vv,6) ./ midisco(vv,1));
%rat = 1;

% Parsing
l_notes = size(midisco, 1);

noteons = [ones(l_notes, 1), midisco(:, [4, 1])];
noteofs = [zeros(l_notes, 1), midisco(:, 4), midisco(:, 1) + midisco(:, 2)];

% Structure of notes: [ON/OFF NoteNum Time]
notes = sortrows([noteons; noteofs], [3 1 2]);
l_notes = size(notes, 1);

% Create cell array with data
score = cell(l_notes, 2);

% Initialization
lastOnset = notes(1, 3);
active = notes(1, 2);
score{1, 1} = active;
score{1, 2} = lastOnset;
n = 2;
p = 1;

while n <= l_notes,
  
  if notes(n, 3) ~= lastOnset, % NUOVO EVENTI
    
    if notes(n, 1), % NOTEON => nuovo slice
      active = notes(n, 2);
      score{p, 3} = notes(n, 3) - score{p, 2};
      lastOnset = notes(n, 3);
      p = p + 1;
      score{p, 1} = active;
      score{p, 2} = lastOnset;
      
    else % NOTEOF => nuovo slice solo se e' la nota attiva
      if active == notes(n, 2),
        active = [];
        score{p, 3} = notes(n, 3) - score{p, 2};
        p = p + 1;
        score{p, 1} = active;
        score{p, 2} = lastOnset;
      end
    end
    
  else % ONSET CONTEMPORANEI
    
    if notes(n, 1), % NOTEON
      if isempty(active),
        active = notes(n, 2);
      else
        active = max(active, notes(n, 2));
      end
      score{p, 1} = active;
    end
  end
  n = n + 1;
end      

% Analyse slices
l_score = p - 1;

monosco = zeros(l_score, 7);
p = 1;
for n = 1:l_score,
  if ~isempty(score{n, 1}),
    monosco(p, :) = [[score{n, 2}, score{n, 3}] / 1000, 1, max(score{n, 1}), 100, rat * [score{n, 2}, score{n, 3}]];
    p = p + 1;
  end
end
monosco = monosco(1 : p - 1, :);

