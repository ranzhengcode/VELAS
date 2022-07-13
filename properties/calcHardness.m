function Hv = calcHardness(U,V,model)

%{
  ========================== Vickers hardness =============================
    Input parameter:
                    if flag = 'M', selecting Mazhnik's model, U = E (Young's modulus), V = P (Poisson's Ratio)
                    if flag = 'C', selecting Chen's model, U = G (shear modulus), V = B (bulk modulus)
                    if flag = 'T', selecting Tian's model, U = G (shear modulus), V = B (bulk modulus)
    Out parameter: 
                    —— Hv, return Vickers hardness. 
    refs:
        Mazhnik's model: J. Appl. Phys. 126, 125109 (2019)
        Hv[Mazhnik] = 0.096*((1-8.5*v+19.5*v^2)*E)/(1-7.5*v+12.2*v^2+19.6*v^3).

        Chen's model: Intermetallics 19 (2011) 1275e1281
        Hv[chen]    = 2*(k^2*G)^0.585-3, where k = G/B.

        Tian's model: Int. Journal of Refractory Metals and Hard Materials 33 (2012) 93�C106
        Hv[Tian]    = 0.92*k^1.137*G^0.708, where k = G/B.
%}

switch(model)
    case {'M','Mazhnik'}
        Hv = 0.096*((1-8.5*V+19.5*V.^2)./(1-7.5*V+12.2*V.^2+19.6*V.^3)).*U;
    case {'C','Chen'}
        Hv = 2*(U.^3./V.^2).^0.585-3;
    case {'T','Tian'}
        Hv = 0.92*((U./V).^1.137).*(U.^0.708);
end
