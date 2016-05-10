% MAIN SCRIPT for showing the recognition ratios

%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENT VALUES %
%%%%%%%%%%%%%%%%%%%%%
%monopoli = 'Mono';
%monopoli = 'Poli';
monopoli = 'Pop';
%exp_num = 39;
model_rest = 0;

%%%%%%%%%%%%%
% LOAD DATA %
%%%%%%%%%%%%%
path_r = [monopoli,'/','RESULTS'];

if model_rest
  eval(['load ',path_r,'/Exp_',int2str(exp_num)])
else
  eval(['load ',path_r,'/Pop_big_',int2str(exp_num)])
end

%%%%%%%%%%%%%%
% EVALUATION %
%%%%%%%%%%%%%%
l_audioFiles = length(audioFiles);
l_scoreFiles = length(scoreFiles);
pos = zeros(l_audioFiles,7);

for a = 1:l_audioFiles
  eval(['probs=probs_',int2str(a),';'])
  eval(['as=as_',int2str(a),';'])

  for n = 1:6
    p = real(probs(:,n));
    [vals, inds] = sort(abs(p-max(p)));
    pos(a,n) = find(as == inds);
  end
  p = real(probs(:,1)) + real(probs(:,3));
  [vals, inds] = sort(abs(p-max(p)));
  pos(a,7) = find(as == inds);

end

%%%%%%%%%%%
% DISPLAY %
%%%%%%%%%%%
%for n = 1:6
%  figure(n)
%  hist(pos(:,n),l_scoreFiles)
%end

% Dati mono da integrare
monpos = ones(28,6);
%monpos(1,:) = [3,4,3,1,1,1];
%monpos(2,2) = 2;
ppos = pos; %[pos;monpos];

av = zeros(4,6);
lim = [2,4,6,11];
for n = 1:4
  for m = 1:6
    av(n,m) = 100*(length(find(ppos(:,m) < lim(n))) / size(ppos,1));
  end
end
%disp(av')
%disp([exp_num, round(av(1,[1:3,7]))])
disp([exp_num, round(av(1,[1:6]))])

