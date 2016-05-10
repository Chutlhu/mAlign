filename = 'debussy02';

exp_num = 1;
setParameters;

an.hpsz=1024;
an.l_fft=8192;
an.l_sig=4096;

y = wavread(['Poli/AUDIO/',filename,'.wav']);
y = y(:,1);
y = y./(max(abs(y))+0.001);
l_y = length(y);

hmw = hamming(an.l_sig);

% Number of frames in the audiofile
M = floor((l_y - an.l_sig + an.hpsz) / an.hpsz);
yfft = zeros(an.l_fft, M);

% Compute the FFT for each frame
ini = 1;
fin = an.l_sig;
for m = 1:M,
  yfft(:,m) = (abs(fft(hmw .* y(ini:fin), an.l_fft))) .^ 2;
  ini = ini + an.hpsz;
  fin = fin + an.hpsz;
end
yfft = yfft(1:an.l_fft/2,:);

miam = (yfft(1:350,:)).^(1/5);
mx=max(max(miam));
mn=min(min(miam));

miam = uint8(256 * (1 - (miam - mn)/(mx - mn)));
miam3 = uint8(zeros(size(miam,1),size(miam,2),3));
miam3(:,:,1) = miam;
miam3(:,:,2) = miam;
miam3(:,:,3) = miam;

figure(1)
plot(y,'k')
axis tight
g=gca;
xtick=[44100:44100:l_y];
xticklabel=num2str([1:length(xtick)]');
ytick=[-1,-0.5,0,0.5,1];
set(g,'XTick',xtick,'XTickLabel',xticklabel,'YTick',ytick,'YLim',[-1 1])
gx=xlabel('Time (seconds)');
set(gx,'FontSize',13)
gy=ylabel('Amplitude');
set(gy,'FontSize',13)

figure(2)
image(miam3)
axis tight
axis xy
g=gca;
xtick=round([44100/1024:44100/1024:size(miam3,2)]);
xticklabel=num2str([1:length(xtick)]');
ytick=round([1000*4096/44100:1000*4096/44100:350]);
yticklabel=num2str([1:length(ytick)]');
set(g,'XTick',xtick,'XTickLabel',xticklabel,'YTick',ytick,'YTicklabel',yticklabel)
gx=xlabel('Time (seconds)');
set(gx,'FontSize',13)
gy=ylabel('Frequency (kilohertz)');
set(gy,'FontSize',13)

nmat=load('Poli/SCORES/debussy02.trs');
figure(3)
pianoroll(nmat,'sec','hold')
g=gca;
xtick=[763:763:9000];
xticklabel=num2str([1:length(xtick)]');
set(g,'XTick',xtick,'XTickLabel',xticklabel);
gx=xlabel('Time (seconds)');
set(gx,'FontSize',13)
