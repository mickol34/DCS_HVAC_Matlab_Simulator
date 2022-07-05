function hl = calc_control(stpt, tl, hr, fl, fr)
    
    % pamięć regulatora:
    persistent Pstpt;
    if isempty(Pstpt)
        Pstpt = zeros(1,4000);
    end
    
    persistent Ptl;
    if isempty(Ptl)
        Ptl = zeros(1,4000);
    end
    
    persistent Phr;
    if isempty(Phr)
        Phr = zeros(1,4000);
    end
    
    persistent Pfl;
    if isempty(Pfl)
        Pfl = zeros(1,4000);
    end
    
    persistent Pfr;
    if isempty(Pfr)
        Pfr = zeros(1,4000);
    end
    
    persistent Phl;
    if isempty(Phl)
        Phl = zeros(1,4000);
    end
    
    persistent er;
    if isempty(er)
        er = zeros(1,4000);
    end
    
    persistent integral;
    if isempty(integral)
        integral = zeros(1,4000);
    end
    
    persistent ODPhr;
    if isempty(ODPhr)
        ODPhr = zeros(1,4000);
    end
    
    persistent ODPfl;
    if isempty(ODPfl)
        ODPfl = zeros(1,4000);
    end
    
    persistent ODPfr;
    if isempty(ODPfr)
        ODPfr = zeros(1,4000);
    end
    
    persistent chwila;
    if isempty(chwila)
        chwila = 1;
    end       
    
    
    % nadpisywanie pamięci:
    Pstpt(chwila) = stpt;
    Ptl(chwila) = tl;
    Phr(chwila) = hr;
    Pfl(chwila) = fl;
    Pfr(chwila) = fr;
    
    
    % funkcje PIDa:
    er(chwila) = stpt-tl;
    if chwila > 1
        integral(chwila) = integral(chwila-1) + er(chwila);
        deriv = er(chwila)-er(chwila-1);
    else
        integral = 0;
        deriv = 0;
    end
    
    
    % parametry PIDa (w wersji ostrej - 12 / 0.1 / 117; w wersji łagodnej - 6 / 0.1 / 0.1):
    K_linear = 12;
    K_integral = 0.1;
    K_derivative = 117;
    
    
    % określenie sterowania dla PIDa:
    hl_PID = K_linear*er(chwila) + K_integral*integral(chwila) + K_derivative*deriv;
    
    
    % odsprzęganie prawej grzałki:
    if chwila > 28
        hl_odsprzeganie_hr = exp(-1/110)*ODPhr(chwila-1)-(15/66)*Phr(chwila-27)+((22*exp(-1/110)-7)/66)*Phr(chwila-28);
    else
        hl_odsprzeganie_hr = 0;
    end
    
    
    % odsprzęganie lewego wentylatora:
    if chwila > 1
        K_fl = -0.0023225*hl_PID;
        hl_odsprzeganie_fl = exp(-1/40)*ODPfl(chwila-1)-(15*K_fl/3.096)*Pfl(chwila)+((8*K_fl*exp(-1/110)+7*K_fl)/3.096)*Pfl(chwila-1);
    else
        hl_odsprzeganie_fl = 0;
    end
    
    
    % odsprzęganie prawego wentylatora:
    if chwila > 1
        K_fr = -0.0006625*hl_PID;
        hl_odsprzeganie_fr = exp(-1/70)*ODPfr(chwila-1)-(15*K_fr/5.418)*Pfr(chwila)+((14*K_fr*exp(-1/70)+K_fr)/5.418)*Pfr(chwila-1);
    else
        hl_odsprzeganie_fr = 0;
    end
    
    
    % sterowanie łącznie:
    hl = hl_PID + hl_odsprzeganie_hr + hl_odsprzeganie_fl + hl_odsprzeganie_fr;
    
    
    % ograniczenie do przedziału sterowania:
    if hl > 100
        hl = 100;
    end
    
    if hl < 0
        hl = 0;
    end
    
    
    % zapis sterowań:
    Phl(chwila) = hl;
    ODPhr(chwila) = hl_odsprzeganie_hr;
    ODPfl(chwila) = hl_odsprzeganie_fl;
    ODPfr(chwila) = hl_odsprzeganie_fr;
    
    
    % licznik czasu:
    chwila = chwila+1;
    
    % wizualizacja pamięci, gdyby trzeba było przeanalizować pamięć programu:
    %{
    if chwila == 4000
        figure;
        plot([1:1:4000], Phl, [1:1:4000], Phr)
        legend("hl", "hr")
        
        figure;
        plot([1:1:4000], Pfl, [1:1:4000], Pfr)
        legend("fl", "fr")
        
        figure;
        plot([1:1:4000], ODPhr, [1:1:4000], ODPfl, [1:1:4000], ODPfr)
        legend("od_hr", "od_fl", "od_fr")
        
    end
    %}
end