function setColormapCustom()

%{
       [1] The color maps viridis, magma, inferno, and plasma were created by Stéfan van der Walt ([@stefanv](https://github.com/stefanv)) 
       and Nathaniel Smith ([@njsmith](https://github.com/njsmith)). 

       [2] Please cite the following paper if you use 'cubehelix' in any publications:
       Green, D. A., 2011,  A colour scheme for the display of astronomical intensity images , Bulletin of the Astronomical Society of India, 39, 289.
    
       [3] A collection of colormaps from https://matplotlib.org/cmocean/
       cmocean: 'thermal'  'haline'  'solar'  'ice'  'deep'  'dense'  'algae'  'matter'  'turbid'  'speed'  'amp'  'tempo'  'rain'  'phase'  'balance'  'delta'  'curl'  'diff'  'tarn'
       Please cite the following paper if you use 'cmocean' colormap sets in any publications:
        Thyng, K. M., Greene, C. A., Hetland, R. D., Zimmerle, H. M., & DiMarco, S. F. (2016). True colors of oceanography. Oceanography, 29(3), 10.

       [4] A collection of colormaps from https://seaborn.pydata.org/
       seaborn: ["rocket", "mako", "flare", "crest", "vlag", "icefire", "Spectral", "coolwarm"]
       Please cite the following paper if you use 'seaborn' colormap sets in any publications:
       Waskom, M. L., (2021). seaborn: statistical data visualization. Journal of Open Source Software, 6(60), 3021, https://doi.org/10.21105/joss.03021

       
        
%}
global VELAS

incmapname  = get(VELAS.custcmapname,'String');

if ~isExistColormap(incmapname)
    incmapname  = 'viridis';
    VELAS.customcmap = 'viridis'; 
else
    VELAS.customcmap = incmapname; 
end

[~,colorm] = interpColormap(incmapname,256,VELAS.flipflag); % 'viridis'
set(VELAS.aximg,'CData',colorm);
