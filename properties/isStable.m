function flag = isStable(C,P)

%{  
    Input parameter: C, which is a 6*6 Stifness matrix.
    Out parameter: flag, If stable, flag = true; else, flag = false.

	The necessary and sufficient stability conditions for single crystal:
	Refs:
	[1] T.C.T. TING, Anisotropic Elasticity: Theory and Applications (Oxford University Press,1996, Page 18-21).
    [2] F��lix Mouhat and Francois-Xavier Coudert, PHYSICAL REVIEW B 90, 224104 (2014).
    [3] G V Sin��ko and N A Smirnov 2002 J. Phys.: Condens. Matter 14 6989.
%}
if P > 1e-4
   pC      = triu(C,0);
   pC(1,1) = C(1,1)-P;
   pC(2,2) = C(2,2)-P;
   pC(3,3) = C(3,3)-P;
   pC(4,4) = 4*(C(4,4)-P);
   pC(5,5) = 4*(C(5,5)-P);
   pC(6,6) = 4*(C(6,6)-P);
   pC(1,2) = C(1,2)+P;
   pC(1,3) = C(1,3)+P;
   pC(2,3) = C(2,3)+P;
   pC(1,4:6) = 2*C(1,4:6);
   pC(2,4:6) = 2*C(2,4:6);
   pC(3,4:6) = 2*C(3,4:6);
   pC(4,5:6) = 4*C(4,5:6);
   pC(5,6)   = 4*C(5,6);
   % Constructing symmetric matrix
   C = pC+triu(pC,1)';
end
det1  = det(C(1,1));
det2  = det(C(1:2,1:2));
det3  = det(C(1:3,1:3));
det4  = det(C(1:4,1:4));
det5  = det(C(1:5,1:5));
det6  = det(C);
D     = [det1 det2 det3 det4 det5 det6];
cond1 = isAllPositive(D);
E     = eig(C);
cond2 = isAllPositive(E);

flag  = cond1&&cond2;
