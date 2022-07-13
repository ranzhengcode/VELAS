function [cOut,colorm] = interpColormap(cmap,N)
  
 if ischar(cmap)
    cmap = colormap(cmap);
 end

lenc        = length(cmap);
[cmx,cmy]   = meshgrid(1:3,1:lenc);
[cxx,cyy]   = meshgrid(1:3,linspace(1,lenc,N));
cOut        = interp2(cmx,cmy,cmap,cxx,cyy);

cimg        = zeros(1,N,3);
cimg(1,:,:) = cOut;
colorm      = repmat(cimg,32,1,1);