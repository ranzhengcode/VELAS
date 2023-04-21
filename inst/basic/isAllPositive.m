function Re = isAllPositive(D)

%{
    Input parameter: D, which is a m*1 or 1*m matrix.

    Out parameter: Re, if all elements of D are positive, Re = true;
                   else, Re = false;
%}

lenA = length(D);
lenB = length(D(D>0));
Re   = lenA==lenB;