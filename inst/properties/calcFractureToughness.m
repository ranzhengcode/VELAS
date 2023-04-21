function Kic = calcFractureToughness(U,V,KIC)

%{
  ========================== Fracture Toughness =============================
    Input parameter:
                    Mt is a struct variable:
                                             KIC.model:
                                                        if KIC.model = 'M'/'Mazhnik', selecting Mazhnik's model, U = E (Young's modulus), V = P (Poisson's Ratio)
                                                        if KIC.model = 'N'/'Niu', selecting Niu's model, U = G (shear modulus), V = B (bulk modulus)
                                             KIC.V0    - V0 is the volume per atom;
                                             KIC.gEFr  - gEFr is the relative DOS at the Fermi level;
                                             KIC.material  - 'IC' refers to ionic or covalent crystals; 'PM' refers to pure metals; 'IM' refers to intermetallics;
                    For intermetallics AmBn: KIC.m     - m is the number in the chemical formula AmBn;
                                             KIC.n     - n is the number in the chemical formula AmBn;
                                             KIC.XA    - XA refers to the Allen scale electronegativity of elements A;
                                             KIC.XB    - XB refers to the Allen scale electronegativity of elements B;
                                            
    Out parameter: 
                    —— Kic, return Fracture Toughness [MPa*m^(1/2)]
    refs:
        Niu's model: J. Appl. Phys. 125, 065105 (2019)
        Kic[Niu] = (1+α)*V0^(1/6)*G*(B/G)^(1/2).
        For ionic or covalent crystals: α = 0;
        For pure metals:                α = 43*(g(E_F)_R)^(1/4);
        For intermetallics:             α = 43*(g(E_F)_R)^(1/4)*f_EN, where
        f_EN = β/[1+((C1_m*C1_n)/C2_(m+n))*sqrt((X_A-X_B)^2/(X_A*X_B))]^γ.
        
        
        Mazhnik's model: J. Appl. Phys. 126, 125109 (2019)
        Kic[Mazhnik] = fEN*α^(-1/2)*V0^(1/6)*[α(V)*E]^(3/2).
        For ionic or covalent crystals: α = 8840,  fEN = 1, 
        For pure metals:                α = 2,     fEN = 1, 
        For intermetallics:             α = 2,     f_EN = β/[1+((C1_m*C1_n)/C2_(m+n))*sqrt((X_A-X_B)^2/(X_A*X_B))]^γ.
%}

switch(KIC.model)
    case {'N','Niu'}
        switch(KIC.material)
            case 'IC'
                Kic   = ((KIC.V0*1e-30)^(1/6))*(1000*U).*(V./U).^(1/2);
            case 'M'
                alpha = 43*(KIC.gEFr)^(1/4);
                Kic   = (1+alpha)*((KIC.V0*1e-30)^(1/6))*(1000*U).*(V./U).^(1/2);
            case 'IM'
                C1m    = nchoosek(KIC.m,1);
                C1n    = nchoosek(KIC.n,1);
                C2smn  = nchoosek(KIC.m+KIC.n,2);
                fEN    = 0.3/(1+(C1m*C1n/C2smn)*sqrt((KIC.XA-KIC.XB)^2/(KIC.XA*KIC.XB)))^8;
                alpha  = 43*((KIC.gEFr)^(1/4))*fEN;
                Kic    = (1+alpha)*((KIC.V0*1e-30)^(1/6))*(1000*U).*(V./U).^(1/2);
        end
    case {'M','Mazhnik'}
       switch(KIC.material)
            case 'IC'  
                Kic   = real((8840)^(-1/2)*((KIC.V0*1e-30)^(1/6))*1000*(((1-13.7*V+48.6*V.^2)./(1-15.2*V+70.2*V.^2-81.5*V.^3)).*U).^(3/2));
            case 'M'
                Kic   = real((2)^(-1/2)*((KIC.V0*1e-30)^(1/6))*1000*(((1-13.7*V+48.6*V.^2)./(1-15.2*V+70.2*V.^2-81.5*V.^3)).*U).^(3/2));
            case 'IM'
                C1m    = nchoosek(KIC.m,1);
                C1n    = nchoosek(KIC.n,1);
                C2smn  = nchoosek(KIC.m+KIC.n,2);
                fEN    = 0.3/(1+(C1m*C1n/C2smn)*sqrt((KIC.XA-KIC.XB)^2/(KIC.XA*KIC.XB)))^8;
                Kic    = real((2)^(-1/2)*fEN*((KIC.V0*1e-30)^(1/6))*1000*(((1-13.7*V+48.6*V.^2)./(1-15.2*V+70.2*V.^2-81.5*V.^3)).*U).^(3/2));
       end
end
