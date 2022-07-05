%UWAGA:
% * Symulator pracuje z czasem próbkowania Tp=1sec - jeden krok to 1 sec.
% * Symulator pamiêta stan i zaczyna symulacjê od warunków,
%   które siê ustali³y po ostatnim uruchomieniu.

% init_simulator.m ustawia stan pocz¹tkowy i powinien byæ wykonany
% na pocz¹tku symulacji, chyba ¿e u¿ytkownik z jakiegoœ powodu chce
% kontynuowaæ symulacjê dla ostatnich warunków.

% Takim powodem mo¿e byæ np. próba zabrania odpowiedzi skokowej w punkcie
% pracy (hl, hr, fl, fr, tl, tr), gdzie:
%  hl - grza³ka lewa (0,100)
%  hr - grza³ka prawa (0,100)
%  fl - wentylator lewy (0,100)
%  fr - wentylator prawy (0,100)
%  tl - temperatura lewa C
%  tr - temperatura prawa C 
% Przeprowadzenie takiego eksperymentu wymaga wprowadzenie symulatora w
% zadany punkt pracy. W tym celu nale¿y ustawiæ sygna³y MV i DV i wykonaæ
% symulacjê na horyzoncie ok. 1800 kroków, ¿eby zmienne procesowe PV (tl i
% tr) ustawi³y siê na wartoœciach punktu pracy. Nastêpnie mo¿na wykonaæ 
% eksperyment w celu np identyfikacji transmitancji zak³ócenia.


init_simulator
simLength = 4000;

%DV
FLv = zeros(1,simLength);
FRv = zeros(1,simLength);
fl=30;
fr=30;
HRv = zeros(1,simLength);
%grza³ka prawa jest za³aczona od 2000s na 100% - jest to DV
%nie przejmujemy siê temp tr
hr=0;

%MV
HLv = zeros(1,simLength);
hl=0;

%CV
TLv = zeros(1,simLength);
TRv = zeros(1,simLength); % tej temperatury nie kontrolujemy
%warunki pocz¹tkowe TLamb i TRamb s¹ to temperatury pocz¹tkowe ok 23C 
tl = TLamb;
tr = TRamb;

%STPT
STPT = zeros(1,simLength);
stpt=30;

%œredni b³ad kwadratowy
err=0;

for k = 1:1:simLength
   if k > 2000
       hr=100;
   end
   % generacja zak³ócenia - one mog¹ ulec zmianie podczas testu odbioru
   if k > 300
       fl=60;
   end
   if k > 900
       fr=60;
   end
   if k > 1500
       fl=90;
   end
   if k > 2100
       fr=90;
   end
   if k > 2700
       fl=60;
   end
   if k > 3300
       fr=60;
   end
   if k > 3900
       fr=30;
   end

   
   %generacja stpt - one mog¹ ulec zmianie podczas testu odbioru
   if k > 600
       stpt = 35;
   end
   if k > 1200
       stpt = 40;
   end
   if k > 1800
       stpt = 35;
   end
   if k > 2400
       stpt = 40;
   end
   if k > 3000
       stpt = 45;
   end
   if k > 3600
       stpt = 40;
   end
   %Do napisania jest funkcja calc_control
   %STPT:stpt, PV:tl, MV: hl, DV:hr, fl, fr
   hl = calc_control(stpt,tl, hr, fl, fr);
   [tl, tr] = step_simulator(hl, hr, fl, fr);
   TLv(k) = tl;
   TRv(k) = tr;
   FLv(k) = fl;
   FRv(k) = fr;
   HLv(k) = hl;
   HRv(k) = hr;
   STPT(k) = stpt;
   k
   err = err + (stpt-tl)*(stpt-tl)/simLength
end


figure;
    subplot(2,1,1);
    plot(FLv,'r');
    hold on;
    grid on;
    plot(FRv, 'b--');
    xlabel('k');
    ylabel('U(k)');
    title('Sterowanie wentylatorów - zak³ócenie DV');
    legend('FLU', 'FRU');
    
    subplot(2,1,2);
    plot(HLv,'r');
    hold on;
    grid on;
    plot(HRv, 'b--');
    xlabel('k');
    ylabel('U(k)');
    title('Sterowanie grza³ek');
    legend('HL', 'HR');
    
    figure;
    subplot(2,1,1);
    plot(TLv,'r');
    hold on;
    grid on;
    plot(STPT, 'b--');
    xlabel('k');
    ylabel('TL(k)');
    title('Temperatura lewa TL');
    legend('TL', 'STPT');
    
    subplot(2,1,2);
    plot(TRv,'r');
    hold on;
    grid on;
    xlabel('k');
    ylabel('TR(k)');
    title('Temperatura prawa TR');

