function  [E,rY,negFlag] = calcYoung(x,S,n2d,planeC,flagD)

%{
  ========================== Youngs Modulus ===============================
    Input parameter: 
                    �� x, Initial value of optimization function.
                    �� S, Compliance matrix S
                    �� n2d, mesh number of [0,2��] in 2D calculation
                    �� planeC, 2D plane, such as plane (111)
                    �� flagD, '3D','3d','2D' or '2d', decide whether to compute 3D or 2D.
    Out parameter: 
                    �� P, return Poisson's Ratio. 
                    �� negFlag, if there is a negative Poisson's ratio, then true, otherwise false.
%}

switch(flagD)
    case {'3D','3d'}
        k   = dir2Vec(x(:,1), x(:,2));
        [k11,k12,k13,k22,k23,k33] = getCoef1(k);
    case {'2D','2d'}
        [k11,k12,k13,k22,k23,k33,~,~] = getCoef2D(x,n2d,planeC);
end

rY = k11.*k11*S(1,1)+2*k12.*k12*S(1,2)+2*k13.*k13.*S(1,3)+2*k12.*k13*S(1,4)+2*k11.*k13*S(1,5)+2*k11.*k12*S(1,6)+...
     k22.*k22*S(2,2)+2*k23.*k23*S(2,3)+2*k22.*k23*S(2,4)+2*k12.*k23*S(2,5)+2*k12.*k22*S(2,6)+...
     k33.*k33*S(3,3)+2*k23.*k33*S(3,4)+2*k13.*k33*S(3,5)+2*k13.*k23*S(3,6)+...
     k23.*k23*S(4,4)+2*k13.*k23*S(4,5)+2*k12.*k23*S(4,6)+...
     k13.*k13*S(5,5)+2*k12.*k13*S(5,6)+...
     k12.*k12*S(6,6);
E = 1000./rY;

if min(E) < 0
    negFlag = true;
else
    negFlag = false;
end

end