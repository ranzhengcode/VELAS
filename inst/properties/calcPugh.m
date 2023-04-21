function Pr = calcPugh(B,G)

%{
  ==========================  Pugh ratio =============================
    Input parameter:
                   B - bulk modulus
                   G - shear modulus,
                   Pr = B/G, where B is bulk modulus, G is shear modulus.
                   if Pr > 1.75
                            Re = 'Ductile';
                   else
                            Re = 'Brittle';
                   end
    Out parameter: 
                   Pr, return  Pugh's ratio. 
    refs:
                    
%}
Pr = B./G;