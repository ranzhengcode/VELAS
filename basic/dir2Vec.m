function [K,K1,K2,K3] = dir2Vec(theta, phi)

% Convert direction to vector coordinates

K1 = sin(theta).*cos(phi);
K2 = sin(theta).*sin(phi);
K3 = cos(theta);
K  = [K1,K2,K3];