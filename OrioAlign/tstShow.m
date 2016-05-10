%%%%%%%%%%%
% DISPLAY %
%%%%%%%%%%%

% Prima parte di preanalisi
l_score = size(score,1);
gigi = [0;diff(hmm.obs(1:end-1,2));0];
mystem = find(gigi == 1);
mybar = zeros(l_score, 2);

gigi = find(sum(fb.bands)>0);
mextrs = 50 + gigi(end);

y = wavread([path_a,'/',filename_a,'.wav']);
y = y(:,1);
y = y./max(y);
ly = length(y);

% Interactive "light" graph of the soundfile
ds = 2 * an.hpsz;
lyc = floor(ly / ds);
yc = zeros(2 * lyc, 1);
for n = 1:lyc,
  temp = y(1 + (n - 1) * ds : n * ds);
  yc(2 * n - 1) = max(temp);
  yc(2 * n) = -max(-temp);
end

awin = figure(1);
subplot(4,1,1), hold off,
hay = plot(yc,'k');
haf = get(hay,'parent');
%xlabel 'performance frame * 2'
hold on,

hab = plot([1,1],get(haf,'YLim'),'r');
xlim = get(haf,'XLim');
ap = 1;
nnn = 1;
fl = 1;

disp('Interactive display on...');
while fl,
  tp = waitforbuttonpress;
  
  % the active figure
  if gcf == awin,
    p = max(1, (ap / 2 - 1) * an.hpsz + 1);	% frame start sample
    
    switch tp,
      % mouse
      case 0,
        p = round(get(haf,'CurrentPoint'));
        p = p(1);
        if p > xlim(2),
          ap = ap + 2;
        elseif p < xlim(1),
          ap = ap - 2;
        else
          ap = p;
        end
        
        % keyboard
      case 1,
        ch = get(awin,'CurrentCharacter');
        switch ch,
          case {'q','Q'},        % quit
            fl = 0;
            
            % positioning
          case {'n','f',' '},    % one step forward
            ap = ap + 2;
          case {'N','F'},        % ten steps forward
            ap = ap + 20;
          case {'p','b'},        % one step backward
            ap = ap - 2;
          case {'P','B'},        % ten steps backward
            ap = ap - 20;
            
            % viewing
          case '1',              % previous note
            nnn = nnn - 1;
          case '2',              % next note
            nnn = nnn + 1;
          case '3',
            set(hproba, 'ylim', get(hproba, 'ylim') / 2);
          case '4',
            set(hproba, 'ylim', get(hproba, 'ylim') * 2);
            
            % playing stuff
          case 's',		% play from current position
            sound(y(p : p + 0.5 * an.Fs), an.Fs);
          case 'S',		% longer play from current position
            sound(y(p : p + 1.5 * an.Fs), an.Fs);
          case 'a',		% play from current position
            sound(y(p : p + an.l_sig), an.Fs);
          case 'A',		% play all from current position to end
            sound(y(p : end), an.Fs);
        end
        % end of case keyboard
    end
    if nnn < 1,
      nnn = 1;
    elseif nnn > l_score,
      nnn = l_score;
    end
    if ap < 1,
      ap = 1;
    elseif ap > xlim(2),
      ap = xlim(2);
    end
    
    if fl ~= 0,
      set(hab, 'XData', [ap, ap]);
      p = max(1,ceil((ap * ds / 2 - an.l_sig) / an.hpsz));
      p = min(M, p);
      samppos = (ap / 2 - 1) * an.hpsz + 1;
      
      % FFT and bands
      subplot(4,1,2), hold off
      plot(yfft(1:mextrs, p) ./ max(yfft(1:mextrs, p)),'k'),
      hold on,
      plot(fb.bands(nnn, 1 : mextrs),'r')
      text(mextrs,0.5,num2str(nnn))
      
      % Probabilities and/or values
      hproba = subplot(4,1,3);
      % fixed scale
      % set(hproba, 'nextplot', 'replacechildren', 'ylimmode', 'manual'); 
      cla;
      
      for ziz = 1:l_score,
        poi = find(hmm.obs(:,2) == ziz);
        if ~isempty(score{ziz, 1}),
          mybar(ziz, 1) = obsli(poi(1), p);
          if hmm.obs(poi(end), 1) == 0,
            mybar(ziz, 2) = obsli(poi(end), p);
          else
            mybar(ziz, 2) = 0;
          end
        else
          mybar(ziz, 1) = 0;
          mybar(ziz, 2) = obsli(poi(1), p);
        end
      end
      
      bar(mybar,0.8,'grouped');
      colormap([1 0 0;0 0 1]);
      
      subplot(4,1,4),
      hold off, bar(alfa(:,p),0.4,'k');
      hold on, stem(mystem - 0.5, ones(l_score,1),'r');
      %xlabel 'states'
    end
  end
end

