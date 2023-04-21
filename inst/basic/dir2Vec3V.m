function [V1,V2,V3] = dir2Vec3V(thetaTmp, phiTmp, nChi)

% Convert direction to vector coordinates

lena      = size(thetaTmp,1);
theta     = repmat(thetaTmp,1,nChi);
phi       = repmat(phiTmp,1,nChi);
chiTmp    = linspace(0,pi,nChi);
chi       = repmat(chiTmp,lena,1);
V1 = cos(theta).*cos(phi).*cos(chi) - sin(phi).*sin(chi);
V2 = cos(theta).*sin(phi).*cos(chi) + cos(phi).*sin(chi);
V3 = -sin(theta).*cos(chi);