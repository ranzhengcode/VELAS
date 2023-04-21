function [X, Y, Z] = spherical2Cartesian(theta,phi,R)

%{
        Converts from Spherical (r,θ,φ) to Cartesian (x,y,z) coordinates in 3-dimensions.
        
        Input:
              ntheta - mesh number of theta(θ)
              nphi   - mesh number of phi(φ)
              R      - spherical coordinate distance
        output:
              XZY    - 3D Cartesian coordinates
%}

L1          = sin(theta).*cos(phi);
L2          = sin(theta).*sin(phi);
L3          = cos(theta);

X = R.*L1; 
Y = R.*L2; 
Z = R.*L3;