function Re = getDuctility(P)
% P = B/G, where B is bulk modulus, G is shear modulus.
if P > 1.75
        Re = 'Ductile';
else
        Re = 'Brittle';
end