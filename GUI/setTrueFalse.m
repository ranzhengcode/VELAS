function Re = setTrueFalse(x)
%{
   x == 0, return 'False';
   x == 1, return 'True';
%}
switch(x)
    case 0     
        Re = ' F '; % False
    case 1
        Re = ' T '; % True
end