%UWAGA:
% * Symulator pracuje z czasem pr�bkowania Tp=1sec - jeden krok to 1 sec.
% * Symulator pami�ta stan i zaczyna symulacj� od warunk�w,
%   kt�re si� ustali�y po ostatnim uruchomieniu.

% init_simulator.m ustawia stan pocz�tkowy i powinien by� wykonany
% na pocz�tku symulacji, chyba �e u�ytkownik z jakiego� powodu chce
% kontynuowa� symulacj� dla ostatnich warunk�w.

% Takim powodem mo�e by� np. pr�ba zabrania odpowiedzi skokowej w punkcie
% pracy (hl, hr, fl, fr, tl, tr), gdzie:
%  hl - grza�ka lewa (0,100)
%  hr - grza�ka prawa (0,100)
%  fl - wentylator lewy (0,100)
%  fr - wentylator prawy (0,100)
%  tl - temperatura lewa C
%  tr - temperatura prawa C 
% Przeprowadzenie takiego eksperymentu wymaga wprowadzenie symulatora w
% zadany punkt pracy. W tym celu nale�y ustawi� sygna�y MV i DV i wykona�
% symulacj� na horyzoncie ok. 1800 krok�w, �eby zmienne procesowe PV (tl i
% tr) ustawi�y si� na warto�ciach punktu pracy. Nast�pnie mo�na wykona� 
% eksperyment w celu np identyfikacji transmitancji zak��cenia.


init_simulator
simLength = 4000;

%DV
FLv = zeros(1,simLength);
FRv = zeros(1,simLength);
fl=30;
fr=30;
HRv = zeros(1,simLength);
%grza�ka prawa jest za�aczona od 2000s na 100% - jest to DV
%nie przejmujemy si� temp tr
hr=0;

%MV
HLv = zeros(1,simLength);
hl=0;

%CV
TLv = zeros(1,simLength);
TRv = zeros(1,simLength); % tej temperatury nie kontrolujemy
%warunki pocz�tkowe TLamb i TRamb s� to temperatury pocz�tkowe ok 23C 
tl = TLamb;
tr = TRamb;

%STPT
STPT = zeros(1,simLength);
stpt=30;

%�redni b�ad kwadratowy
err=0;

for k = 1:1:simLength
   if k > 2000
       hr=100;
   end
   % generacja zak��cenia - one mog� ulec zmianie podczas testu odbioru
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

   
   %generacja stpt - one mog� ulec zmianie podczas testu odbioru
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
    title('Sterowanie wentylator�w - zak��cenie DV');
    legend('FLU', 'FRU');
    
    subplot(2,1,2);
    plot(HLv,'r');
    hold on;
    grid on;
    plot(HRv, 'b--');
    xlabel('k');
    ylabel('U(k)');
    title('Sterowanie grza�ek');
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

