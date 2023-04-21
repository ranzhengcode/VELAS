function Re = getPosNeg(Data,flag)

%{
    Input parameter: 
                    — data, which is a m*n matrix.
                    — flag, 'pos' or 'neg'.
    Out parameter: 
                    — Re, return positive or negative value in Data according to flag. 
%}

switch(flag)
    case 'pos'  % positive
        Re         = zeros(length(Data),1);
        Re(Data>0) = Data(Data>0);
    case 'neg'  % negative
        Re       = zeros(length(Data),1);
        Re(Data<0) = Data(Data<0);
end