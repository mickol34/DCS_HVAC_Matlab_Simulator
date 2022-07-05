function [tl, tr] = step_simulator(hl, hr, fl, fr)
load('tfDys.mat');
load('lagDys.mat');

k=50;
global HL;
global HR;
global FLU; 
global FRU;

if hl < 0
    hl = 0;
end
if hl > 100
    hl = 100;
end

if hr < 0
    hr = 0;
end
if hr > 100
    hr = 100;
end

if fl < 30
    fl = 30;
end
if fl > 100
    fl = 100;
end

if fr < 30
    fr = 30;
end
if fr > 100
    fr = 100;
end

HL(50)=hl;
HR(50)=hr;
FLU(50)=fl;
FRU(50)=fr;



    % ----- MODELE LOKALNE INTERAKCJI HL-TL ----- %
    global TLhl3030; global TLhl3090; global TLhl9030; global TLhl9090;
    TLhl3030(k) = HLTLfru30flu30b * HL(k-HLTLfru30flu30delay-1) - HLTLfru30flu30a * TLhl3030(k-1);
    TLhl3090(k) = HLTLfru30flu90b * HL(k-HLTLfru30flu90delay-1) - HLTLfru30flu90a * TLhl3090(k-1);
    TLhl9030(k) = HLTLfru90flu30b * HL(k-HLTLfru90flu30delay-1) - HLTLfru90flu30a * TLhl9030(k-1);
    TLhl9090(k) = HLTLfru90flu90b * HL(k-HLTLfru90flu90delay-1) - HLTLfru90flu90a * TLhl9090(k-1);
    
    % ----- MODELE LOKALNE INTERAKCJI HL-TR ----- %
    global TRhl3030; global TRhl3090; global TRhl9030; global TRhl9090;
    TRhl3030(k) = HLTRfru30flu30b * HL(k-HLTRfru30flu30delay-1) - HLTRfru30flu30a * TRhl3030(k-1);
    TRhl3090(k) = HLTRfru30flu90b * HL(k-HLTRfru30flu90delay-1) - HLTRfru30flu90a * TRhl3090(k-1);
    TRhl9030(k) = HLTRfru90flu30b * HL(k-HLTRfru90flu30delay-1) - HLTRfru90flu30a * TRhl9030(k-1);
    TRhl9090(k) = HLTRfru90flu90b * HL(k-HLTRfru90flu90delay-1) - HLTRfru90flu90a * TRhl9090(k-1);
    
    % ----- MODELE LOKALNE INTERAKCJI HR-TL ----- %
    global TLhr3030; global TLhr3090; global TLhr9030; global TLhr9090;
    TLhr3030(k) = HRTLfru30flu30b * HR(k-HRTLfru30flu30delay-1) - HRTLfru30flu30a * TLhr3030(k-1);
    TLhr3090(k) = HRTLfru30flu90b * HR(k-HRTLfru30flu90delay-1) - HRTLfru30flu90a * TLhr3090(k-1);
    TLhr9030(k) = HRTLfru90flu30b * HR(k-HRTLfru90flu30delay-1) - HRTLfru90flu30a * TLhr9030(k-1);
    TLhr9090(k) = HRTLfru90flu90b * HR(k-HRTLfru90flu90delay-1) - HRTLfru90flu90a * TLhr9090(k-1);
    
    % ----- MODELE LOKALNE INTERAKCJI HR-TR ----- %
    global TRhr3030; global TRhr3090; global TRhr9030; global TRhr9090;
    TRhr3030(k) = HRTRfru30flu30b * HR(k-HRTRfru30flu30delay-1) - HRTRfru30flu30a * TRhr3030(k-1);
    TRhr3090(k) = HRTRfru30flu90b * HR(k-HRTRfru30flu90delay-1) - HRTRfru30flu90a * TRhr3090(k-1);
    TRhr9030(k) = HRTRfru90flu30b * HR(k-HRTRfru90flu30delay-1) - HRTRfru90flu30a * TRhr9030(k-1);
    TRhr9090(k) = HRTRfru90flu90b * HR(k-HRTRfru90flu90delay-1) - HRTRfru90flu90a * TRhr9090(k-1);
    
    TL3030 = TLhl3030(k) +  TLhr3030(k);
    TL3090 = TLhl3090(k) +  TLhr3090(k);
    TL9030 = TLhl9030(k) +  TLhr9030(k);
    TL9090 = TLhl9090(k) +  TLhr9090(k);

    TR3030 = TRhl3030(k) +  TRhr3030(k);
    TR3090 = TRhl3090(k) +  TRhr3090(k);
    TR9030 = TRhl9030(k) +  TRhr9030(k);
    TR9090 = TRhl9090(k) +  TRhr9090(k);
    
    % ----- ZMIENNE ROZMYWAJACE ----- %
    global FLUlagtl; global FRUlagtr; global FLUlagtr; global FRUlagtl;

    FLUlagtl(k) = FLUtlb * FLU(k-FLUtldelay-1) - FLUtla * FLUlagtl(k-1);
    FLUlagtr(k) = FLUtrb * FLU(k-FLUtrdelay-1) - FLUtra * FLUlagtr(k-1);
    FRUlagtr(k) = FRUtrb * FRU(k-FRUtrdelay-1) - FRUtra * FRUlagtr(k-1);
    FRUlagtl(k) = FRUtlb * FRU(k-FRUtldelay-1) - FRUtla * FRUlagtl(k-1);
    
    % ----- FUNKCJE PRZYNALEZNOSCI ----- %
    TL_FLU_30X = (1-(FLUlagtl(k)-30)/70) *  TL3030 + (FLUlagtl(k)-30)/70 * TL3090;
    TL_FLU_90X = (1-(FLUlagtl(k)-30)/70) *  TL9030 + (FLUlagtl(k)-30)/70 * TL9090;
    TL_FRU = (1-(FRUlagtl(k)-30)/70) *  TL_FLU_30X + (FRUlagtl(k)-30)/70 * TL_FLU_90X;
    
    TR_FLU_30X = (1-(FLUlagtr(k)-30)/70) *  TR3030 + (FLUlagtr(k)-30)/70 * TR3090;
    TR_FLU_90X = (1-(FLUlagtr(k)-30)/70) *  TR9030 + (FLUlagtr(k)-30)/70 * TR9090;
    TR_FRU = (1-(FRUlagtr(k)-30)/70) *  TR_FLU_30X + (FRUlagtr(k)-30)/70 * TR_FLU_90X;

    global TLamb; global TRamb;
    tl = TL_FRU + TLamb;
    tr = TR_FRU + TRamb;

    
    for i=1:1:49
        HL(i) = HL(i+1);
        HR(i) = HR(i+1);
        FLU(i) = FLU(i+1); 
        FRU(i) = FRU(i+1);
        
        TLhl3030(i) = TLhl3030(i+1); 
        TLhl3090(i) = TLhl3090(i+1); 
        TLhl9030(i) = TLhl9030(i+1); 
        TLhl9090(i) = TLhl9090(i+1);
        TRhl3030(i) = TRhl3030(i+1); 
        TRhl3090(i) = TRhl3090(i+1); 
        TRhl9030(i) = TRhl9030(i+1); 
        TRhl9090(i) = TRhl9090(i+1);
        
        TLhr3030(i) = TLhr3030(i+1); 
        TLhr3090(i) = TLhr3090(i+1); 
        TLhr9030(i) = TLhr9030(i+1); 
        TLhr9090(i) = TLhr9090(i+1);
        TRhr3030(i) = TRhr3030(i+1); 
        TRhr3090(i) = TRhr3090(i+1); 
        TRhr9030(i) = TRhr9030(i+1); 
        TRhr9090(i) = TRhr9090(i+1);
  
        FLUlagtl(i) = FLUlagtl(i+1); 
        FRUlagtr(i) = FRUlagtr(i+1); 
        FLUlagtr(i) = FLUlagtr(i+1); 
        FRUlagtl(i) = FRUlagtl(i+1);    

    end
end