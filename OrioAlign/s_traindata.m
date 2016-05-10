% SCRIPT for computing training parameters

%%%%%%%%%%%%%%%%%%%%%%%
% Directories & Files %
%%%%%%%%%%%%%%%%%%%%%%%
monopoli = 'Poli'; % 'Mono'

path_a = [monopoli,'/','AUDIO'];
path_s = [monopoli,'/','SCORES'];
path_r = [monopoli,'/','RESULTS'];

audioFiles = dir([path_a,'/*.wav']);
audioFiles = sort({audioFiles.name});
l_audioFiles = length(audioFiles);

scoreFiles = dir([path_s,'/*.trs']);
scoreFiles = sort({scoreFiles.name});
l_scoreFiles = length(scoreFiles);

%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENT VALUES %
%%%%%%%%%%%%%%%%%%%%%
model_rest = 0;

for exp_num = 37:41
  
  htot1 = [];
  setParameters;
  
  for adf = 1:l_audioFiles
    
    % SCORE
    filename_s = scoreFiles{adf}(1:end-4);
    score = parseMIDI(path_s,filename_s,thrs_msec_note,thrs_msec_rest);
    % Modifica al parsing del file MIDI
    if model_rest
      hmm = makeHMM(score,n_sust,an);
    else
      zz= 2;
      while zz <= length(score)
        if length(score{zz,1}) == 0
          score{zz - 1, 2} = score{zz - 1, 2} + score{zz, 2};
          score = [score(1:zz-1,:); score(zz+1:end,:)];
        end
        zz = zz + 1;
      end
      hmm = makeHMM_norest(score,n_sust,an);    
    end
    fb = makeFB(score,n_filt,an);
    
    % AUDIO
    filename_a = audioFiles{adf}(1:end-4);
    [yfft, loge] = doFFT(path_a, filename_a, an);
    probs = zeros(l_scoreFiles,6);
    recognize;
    
    % Analisi dei parametri
    v1 = hmm.obs(decog,2);
    h1 = zeros(length(v1),1);
    for cvc = 1:length(v1)
      if v1(cvc) > 0
        h1(cvc) = outfilt(v1(cvc),cvc);
      end
    end    

    htot1 = [htot1; h1];
  end
  
  eval(['save ',path_r,'/train6_',int2str(exp_num),' htot1'])
end
  
  
  