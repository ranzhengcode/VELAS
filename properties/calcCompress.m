
function [rC,negFlag] = calcCompress(x,S,n2d,planeC,flagD)

%{
  ====================== Linear Compressibility ===========================
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
% ========== Linear Compressibility (from Nye) ==================================
rC = (S(1,1)+S(1,2)+S(1,3)).*k11+(S(1,6)+S(2,6)+S(3,6)).*k12+(S(1,5)+S(2,5)+S(3,5)).*k13...
    +(S(1,2)+S(2,2)+S(2,3)).*k22+(S(1,4)+S(2,4)+S(3,4)).*k23...
    +(S(1,3)+S(2,3)+S(3,3)).*k33;

if min(rC) < 0
    negFlag = true;
else
    negFlag = false;
end
