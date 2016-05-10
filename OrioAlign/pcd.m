monopoli = 'Poli';
path_m = [monopoli,'/','MIDI'];
path_s = [monopoli,'/','SCORES'];

% SCORES & MIDIS
scoreFiles = dir([path_s,'/*.trs']);
scoreFiles = sort({scoreFiles.name});
l_scoreFiles = length(scoreFiles);

midiFiles = dir([path_m,'/*.mid']);
midiFiles = sort({midiFiles.name});
l_midiFiles = length(midiFiles);

for n = 3:3%1:l_midiFiles
  
  nmat = readmidi([path_m,'/',midiFiles{n}]);
  mmat = load([path_s,'/',scoreFiles{n}]);
  disp(scoreFiles{n})
  
  u = unique(nmat(:,3));
  r = zeros(1,5);
  
  for m = 3:3%1:length(u)
    
    p = u(m);
    mid = nmat(find(nmat(:,3) == p), :);
    trs = mmat(find(mmat(:,3) == p - 1), :);
    
    if size(trs,1) == size(mid,1)
      r(1:2) = sum(abs(1024 * mid(:,1:2) - trs(:,1:2)));
      r(3) = sum(abs(mid(:,4) - trs(:,4)));
      qw = find(mid(:,6) > 0);
      r(4) = mean(abs(mean(trs(qw,6) ./ mid(qw,6)) * mid(:,6) - trs(:,6)));
      r(5) = mean(abs(mean(trs(:,7) ./ mid(:,7)) * mid(:,7) - trs(:,7)));
      
      disp([m, r])
    else
      disp([m size(mid,1) size(trs,1)])
    end
  end
end

