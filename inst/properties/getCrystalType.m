function Re = getCrystalType(C)

% Judging the type of crystal system according to the stiffness matrix C
         % Cubic        -- 3 independent elastic constants: C11, C44, C12;
         % Hexagonal    -- 5 independent elastic constants: C11, C33, C44, C12, C13
         % Tetragonal   -- 7 independent elastic constants: C11, C33, C44, C66, C12, C13, C16
         % Trigonal     -- 7 independent elastic constants: C11, C33, C44, C12, C13, C14, C15
         % Orthorhombic -- 9 independent elastic constants: C11, C22, C33, C44, C55, C66, C12, C13, C23
         % Monoclinic   -- 13 independent elastic constants: C11, C22, C33, C44, C55, C66, C12, C13, C23, C15, C25, C35, C46
         % Triclinic    -- 21  independent elastic constants: C11, C12, C13, C14, C15, C16,C22, C23, C24, C25, C26, C33, C34, C35, C36, C44, C45, C46, C55, C56, C66
         
         lenC = length(unique(nonzeros(C)));

         switch(lenC)
             case 3
                 Re = 'Cubic';
             case 6
                 if (C(6,6) - 0.5*(C(1,1)-C(1,2)))<1e-2
                     Re = 'Hexagonal';
                 else
                     Re = 'Tetragonal';
                 end
             case 8
                 if (C(6,6) - 0.5*(C(1,1)-C(1,2)))<1e-2
                     Re = 'Trigonal';
                 else
                     Re = 'Tetragonal';
                 end
             case 9
                 Re = 'Orthorhombic';
             case 10
                 Re = 'Trigonal';
             case 13
                 Re = 'Monoclinic';
             case 21
                 Re = 'Triclinic'; 
         end
           