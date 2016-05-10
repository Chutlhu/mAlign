dirIn = '/Users/orio/Dropbox/ismir2012_data/filtered_alignments/';
files = dir([dirIn,'*7.csv']);
nf = length(files);

for n = 1:nf
  
  if strcmp(files(n).name,'Accenti_Prelude-7.csv')
    accenti = csvread([dirIn,files(n).name]);
    ref = accenti(:,1);
    obsmatr = zeros(length(ref),nf);
  else
    
    csvmatr = csvread([dirIn,files(n).name]);
    tmp = strfind(files(n).name,'_');
    nome = files(n).name(1:tmp(1)-1);
    outname = [dirIn,files(n).name(1:tmp(1)),'R',files(n).name(tmp(1):end)];
    
    % Calcolo dei dati da mostrare
    thisRef = csvmatr(:,2);
    
    m = 1;
    time = zeros(length(ref),1);
    energy = zeros(length(ref),1);
    for p = 1:length(ref)
      if thisRef(m) == ref(p)
        time(p) = csvmatr(m,1);
        energy(p) = sum(csvmatr(m,3:end));
        m = m+1;
      else
        time(p) = -100;
        energy(p) = -100;
      end
    end
    
    p = 2;
    while p < length(ref)
      if time(p) == -100
        q = p+1;
        while time(q) == -100
          q = q+1;
        end
        for r = p:q-1
          fact = (1+r-p)/(1+q-p);
          time(r) = (1-fact)*time(p-1)+fact*time(q);
          energy(r) = (1-fact)*energy(p-1)+fact*energy(q);
        end
      end
      p = p+1;
    end
    csvwrite(outname,[accenti(:,1),time,energy]);
  end
end
