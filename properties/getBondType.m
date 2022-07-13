function Re = getBondType(Cp)
%  if Cp < 0, covalent bond compounds,else ionic/metallic bonds
if Cp < 0
        Re = '   Covalent   ';
else
        Re = 'Ionic/Metallic';
end