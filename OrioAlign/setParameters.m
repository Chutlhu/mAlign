switch exp_num

  case 1001
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 2;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',8192,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.3);    
  
  case 1002
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 2;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',8192,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.6, ...
      'enrg_mu', 0.2);
  
  case 10
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 8;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.6, ...
      'enrg_mu', 0.2);

  case 11
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 6;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.6, ...
      'enrg_mu', 0.2);

  case 12
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.45, ...
      'enrg_mu', 0.15);

  case 13
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 3;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.4, ...
      'enrg_mu', 0.1);

  case 14
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 2;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.35, ...
      'enrg_mu', 0.1);

  case 15
    % Thresholds for merging events
    thrs_msec_note = 100;
    thrs_msec_rest = 200;
    
    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',1024,'hopeSize',512);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.38, ...
      'enrg_mu', 0.1);
    
    % include rests in the HMM model?
    model_rest = 0;

  case 16
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 8;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',1024,'hopeSize',512);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.5, ...
      'enrg_mu', 0.2);

  case 17
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 2;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',1024,'hopeSize',512);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.3, ...
      'enrg_mu', 0.1);

  case 20
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.6, ...
      'enrg_mu', 0.3);

  case 21
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.6, ...
      'enrg_mu', 0.2);

  case 22
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.6, ...
      'enrg_mu', 0.1);

  case 23
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 3;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.5, ...
      'enrg_mu', 0.3);

  case 24
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 3;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.5, ...
      'enrg_mu', 0.2);

  case 25
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 3;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.5, ...
      'enrg_mu', 0.1);

  case 26
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.6, ...
      'enrg_mu', 0.4);

  case 27
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.6, ...
      'enrg_mu', 0.5);

  case 28
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.7, ...
      'enrg_mu', 0.3);

  case 29
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.7, ...
      'enrg_mu', 0.4);

  case 30
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.7, ...
      'enrg_mu', 0.5);

  case 31
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.8, ...
      'enrg_mu', 0.3);

  case 32
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.8, ...
      'enrg_mu', 0.4);

  case 33
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.8, ...
      'enrg_mu', 0.5);

  case 34
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.9, ...
      'enrg_mu', 0.3);

  case 35
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.9, ...
      'enrg_mu', 0.4);

  case 36
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 0.9, ...
      'enrg_mu', 0.5);

  case 37
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.3);

  case 38
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.4);

  case 39
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.5);

  case 40

    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.6);

  case 41

    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.7);

  case 42

    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.8);


  case 43

    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.9);

  case 44

    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 1.0);

  case 1
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.1);


  case 2
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 3;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.1);

  case 3
    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 2;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.1);


  case 421

    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 3;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.8);

  case 422

    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 2;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 4;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.8);

  case 423

    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 3;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.8);

  case 424

    % Thresholds for merging events
    thrs_msec_note = 40;
    thrs_msec_rest = 150;

    % Number of sustain states in the network
    nSustStates = 4;

    % Number of filters in the filterbanalysisParamsk
    nFilters = 2;

    % analysisParamsalysis parameters
    analysisParams = struct('Fs',44100,'nFFT',4096,'windowSize',2048,'hopeSize',1024);

    % Observations probabilities
    pdfs = struct( ...
      'uniform', 0.5, ...
      'logEnergy_s_th', 4.0, ...
      'logEnergy_s_mu', 0.2, ...
      'logEnergy_r_th', 1.0, ...
      'logEnergy_r_mu', 0.2, ...
      'enrg_th', 1.0, ...
      'enrg_mu', 0.8);


end
