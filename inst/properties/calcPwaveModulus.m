function Pw = calcPwaveModulus(B,G)

%{
  ==========================  Pugh ratio =============================
    Input parameter:
                   B - bulk modulus
                   G - shear modulus,
    Out parameter: 
                   Pw = B+4*G/3, P-wave modulus.
    refs:
                    
%}
Pw = B+4*G/3;