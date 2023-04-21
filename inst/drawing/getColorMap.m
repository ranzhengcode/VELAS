function [map,colorm] = getColorMap(flag,N)

% Source：https://github.com/tricialyjun/pridemap

%   ----------
%   Tricia LYJ, 20201117
%   @tricialyjun

switch(flag)
    case {'red','r'}
        r = linspace(0.99 ,0.90, N);
        g = linspace(0.905 ,0.05, N);
        b = linspace(0.905 ,0.05, N);
    case {'blue','b'}
        r = linspace(0.9000, 0.00, N);
        g = linspace(0.9350, 0.35, N);
        b = linspace(0.9900, 0.90, N);
    case {'green','g'}
        r = linspace(0.9000, 0.00, N);
        g = linspace(0.9600, 0.60, N);
        b = linspace(0.9150, 0.15, N);
    case {'orange','o'}
        r = linspace(1, 1.00, N);
        g = linspace(0.95, 0.50, N);
        b = linspace(0.9, 0.00, N);
    case {'violet','v'}
        r = linspace(0.9450, 0.4500, N);
        g = linspace(0.9050, 0.0500, N);
        b = linspace(0.9500, 0.5000, N);
    case {'yellow','y'}
        r = linspace(1.0000, 1.00, N);
        g = linspace(0.9850, 0.85, N);
        b = linspace(0.9150, 0.15, N);
    otherwise
        errordlg('No such colormap scheme.','VELAS reminder');
end

map = ([r', g', b']);
cimg        = zeros(1,N,3);
cimg(1,:,:) = map;
colorm      = repmat(cimg,32,1,1);

end