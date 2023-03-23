
% % The lattice constants
% %%  trigonal crystal system
% latconts = [4.5 3.6 4.2 80 45 72]; % a, b, c, alpha, beta, gamma 
% % The Miller indices of the crystal direction
% hkl     = [1 0 1];

%%  Cubic crystal system
latconts = [4.5 4.5 4.5 90 90 90]; % a, b, c, alpha, beta, gamma 
% The Miller indices of the crystal direction
hkl     = [2 0 1];

[h,k,l] = deal(hkl(1),hkl(2),hkl(3));
% One of the planes perpendicular to the direction [hkl]
Pmiller = dir2Plane(latconts,hkl);

% Display the Miller indices of the plane
disp(['The Miller indices of the plane perpendicular to the [',...
      num2str(h),' ', num2str(k),' ', num2str(l),...
      '] direction are [',...
      num2str(Pmiller(1)), ' ',num2str(Pmiller(2)), ' ',num2str(Pmiller(3)), '].']);
