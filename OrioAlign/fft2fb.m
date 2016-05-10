len = 44100 * 10;

exp_num = 4;
model_rest = 0;
path_a = ['AudioCDs/WAV'];

thrs = 0.9;

setParameters;

audioFiles = dir([path_a,'/*.wav']);
audioFiles = sort({audioFiles.name});
l_audioFiles = length(audioFiles);

memo = zeros(l_audioFiles,1);

for adf = 100:100 %1:l_audioFiles
  filename_a = audioFiles{adf}(1:end-4);
  disp(filename_a)
  
  [yfft, loge] = doFFT2(path_a, filename_a, an, len);
  
  M = length(loge);
  
  nscore = cell(M,1);
  for m = 1:M
    fy = yfft(:,m);
    
    % Trova le posizioni e i valori dei massimi
    mxp = find([0;sign(diff(fy))] + [sign(diff(fy));0] == 0);
    mxv = fy(mxp);
    
    % Massimi in ordine decrescente
    [omxv omxp] = sort(-mxv);
    omxv = -omxv;
    l_omxv = length(omxv);
    
    if sum(omxv) == 0
      disp(m)
    end
    
    % Numero di filtri da utilizzare per il frame corrente
    n_filt = length(find(cumsum(omxv)/sum(omxv) < thrs));
    if n_filt > 10
      n_filt = 10;
    end
    
    % Valori Hz e MIDI
    md = [];
    for v = 1:n_filt
      hz = an.Fs * (mxp(omxp(v)) - 1) / an.l_fft;
      md = [md, round((12 / log(2)) * log( hz / 440)) + 69];
      %md = [md; mxp(omxp(v)) - 1];
    end
    nscore{m} = md;
  end
  
  figure(adf)
  hold on
  for m = 1:M
    for q = 1:length(nscore{m})
      plot(m,nscore{m}(q),'sk')
    end
  end
end
