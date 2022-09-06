function [cOut,colorm] = interpColormap(cmap,N,varargin)

narginchk(2,3);

switch(nargin)
    case 2
        flipflag = false;
    case 3
        tflag = varargin{1};
        if ~islogical(tflag)
            flipflag = false;
        else
            flipflag = tflag;
        end
end

if ischar(cmap)
    cmap = velasColormap(cmap,flipflag);
 end
if N ~= 256
    lenc        = length(cmap);
    [cmx,cmy]   = meshgrid(1:3,1:lenc);
    [cxx,cyy]   = meshgrid(1:3,linspace(1,lenc,N));
    cOut        = interp2(cmx,cmy,cmap,cxx,cyy);
else
    cOut        = cmap;
end

cimg        = zeros(1,N,3);
cimg(1,:,:) = cOut;
colorm      = repmat(cimg,32,1,1);
