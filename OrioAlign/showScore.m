uno=load('Poli/SCORES/bach1050_01.trs');
due=load('Poli/SCORES/zznoise51.trs');

shw = uno;

figure(1)
hold
for n = 1:size(shw,1)
  plot([shw(n,1),shw(n,1)+shw(n,2)-1],[shw(n,4),shw(n,4)],'k')
end

shw = due;

figure(2)
hold
for n = 1:size(shw,1)
  plot([shw(n,1),shw(n,1)+shw(n,2)-1],[shw(n,4),shw(n,4)],'k')
end
