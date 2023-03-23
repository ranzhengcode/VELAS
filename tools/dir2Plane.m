function Phkl = dir2Plane(latconts,hkl)
%{
  ========================== Calculate a plane perpendicular to the direction [hkl] ================================
    Input parameter: 
                    latconts: [a, b, c, alpha, beta, gamma], the lattice constants.
                    hkl: [h,k,l],  the Miller indices of the crystal direction.
    Out parameter: 
                    Phkl: One of the planes perpendicular to the direction [hkl]
    Note: Phkl is not an integer array in most cases, so if you need to convert it to an integer, please do your own calculations.
%}


[a,b,c,alpha,beta,gamma] = deal(latconts(1),latconts(2),latconts(3),latconts(4),latconts(5),latconts(6));
% Convert the lattice constants to Cartesian coordinates
a1 = a;
a2 = 0;
a3 = 0;

b1 = b*cosd(gamma);
b2 = b*sind(gamma);
b3 = 0;

c1 = c*cosd(beta);
c2 = c*(cosd(alpha)-cosd(beta)*cosd(gamma))/sind(gamma);
c3 = sqrt(c^2-c1^2-c2^2);

% Convert the direction [hkl] to Cartesian coordinates
[h,k,l] = deal(hkl(1),hkl(2),hkl(3));
g1 = h*a1 + k*b1 + l*c1;
g2 = h*a2 + k*b2 + l*c2;
g3 = h*a3 + k*b3 + l*c3;

% Find a vector that is perpendicular to the direction [hkl] using the cross product
u = cross([g1, g2, g3], rand(1,3));

% Find another vector that is perpendicular to both the direction [hkl] and the vector u using the cross product
v = cross([g1, g2, g3], u);

% Normalize the vectors u and v to unit vectors
u = u/norm(u);
v = v/norm(v);

% Calculate the normal vector to the plane
n = cross(u, v);

% Normalize the normal vector to a unit vector
n = n/norm(n);

% Calculate the Miller indices of the plane
Phkl = [n(1)/a, n(2)/b, n(3)/c];
