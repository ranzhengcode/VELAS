function setColormapFig()

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


val  = get(VELAS.cmappop,'Value');
str  = get(VELAS.cmappop,'String');

flag = str{val};
switch(flag)
    case 'viridis'
        [~,colorm] = interpColormap('viridis',256,VELAS.flipflag); % 'viridis'
    case 'cool'
        [~,colorm] = interpColormap('cool',256,VELAS.flipflag);    % 'cool'
    case 'summer'
        [~,colorm] = interpColormap('summer',256,VELAS.flipflag);  % 'summer'
    case 'copper'
        [~,colorm] = interpColormap('copper',256,VELAS.flipflag);  % 'copper'
    case 'hot'
        [~,colorm] = interpColormap('hot',256,VELAS.flipflag);     % 'hot'
    case 'ocean'
        [~,colorm] = interpColormap('ocean',256,VELAS.flipflag);   % 'ocean'
    case 'gray'
        [~,colorm] = interpColormap('gray',256,VELAS.flipflag);    % 'gray'
    case 'bone'
        [~,colorm] = interpColormap('bone',256,VELAS.flipflag);    % 'bone'
    case 'pink'
        [~,colorm] = interpColormap('pink',256,VELAS.flipflag);    % 'pink'
    case 'spring'
        [~,colorm] = interpColormap('spring',256,VELAS.flipflag);  % 'spring'
    case 'autumn'
        [~,colorm] = interpColormap('autumn',256,VELAS.flipflag);  % 'autumn'
    case 'winter'
        [~,colorm] = interpColormap('winter',256,VELAS.flipflag);  % 'winter'
    case 'cubehelix'
        % Green, D. A., 2011, ‘A colour scheme for the display of astronomical intensity images’, Bulletin of the Astronomical Society of India, 39, 289.
        % Please cite this paper if you use ‘cubehelix’ in any publications.
        [~,colorm] = interpColormap('cubehelix',256,VELAS.flipflag); %'cubehelix'
    case 'turbo'
        [~,colorm] = interpColormap('turbo',256,VELAS.flipflag); % 'turbo'
    case 'thermal'
        [~,colorm] = interpColormap('thermal',256,VELAS.flipflag);
    case 'haline'
        [~,colorm] = interpColormap('haline',256,VELAS.flipflag);
    case 'solar'
        [~,colorm] = interpColormap('solar',256,VELAS.flipflag);
    case 'ice'
        [~,colorm] = interpColormap('ice',256,VELAS.flipflag); 
    case 'deep'
        [~,colorm] = interpColormap('deep',256,VELAS.flipflag); 
    case 'dense'
        [~,colorm] = interpColormap('dense',256,VELAS.flipflag); 
    case 'algae'
        [~,colorm] = interpColormap('algae',256,VELAS.flipflag);
    case 'matter'
        [~,colorm] = interpColormap('matter',256,VELAS.flipflag); 
    case 'turbid'
        [~,colorm] = interpColormap('turbid',256,VELAS.flipflag); 
    case 'speed'
        [~,colorm] = interpColormap('speed',256,VELAS.flipflag); 
    case 'amp'
        [~,colorm] = interpColormap('amp',256,VELAS.flipflag); 
    case 'tempo'
        [~,colorm] = interpColormap('tempo',256,VELAS.flipflag); 
    case 'rain'
        [~,colorm] = interpColormap('rain',256,VELAS.flipflag); 
    case 'phase'
        [~,colorm] = interpColormap('phase',256,VELAS.flipflag);
    case 'balance'
        [~,colorm] = interpColormap('balance',256,VELAS.flipflag);
    case 'delta'
        [~,colorm] = interpColormap('delta',256,VELAS.flipflag); 
    case 'curl'
        [~,colorm] = interpColormap('curl',256,VELAS.flipflag);
    case  'diff'
        [~,colorm] = interpColormap('diff',256,VELAS.flipflag);
    case 'tarn'
        [~,colorm] = interpColormap('tarn',256,VELAS.flipflag);
    case 'inferno'
        [~,colorm] = interpColormap('inferno',256,VELAS.flipflag);
    case 'magma'
        [~,colorm] = interpColormap('magma',256,VELAS.flipflag);
    case 'plasma'
        [~,colorm] = interpColormap('plasma',256,VELAS.flipflag);
    case 'rocket'
        [~,colorm] = interpColormap('rocket',256,VELAS.flipflag);
    case 'mako'
        [~,colorm] = interpColormap('mako',256,VELAS.flipflag);
    case 'flare'
        [~,colorm] = interpColormap('flare',256,VELAS.flipflag);
    case 'crest'
        [~,colorm] = interpColormap('crest',256,VELAS.flipflag);
    case 'vlag'
        [~,colorm] = interpColormap('vlag',256,VELAS.flipflag);
    case 'icefire'
        [~,colorm] = interpColormap('icefire',256,VELAS.flipflag);
    case 'Spectral'
        [~,colorm] = interpColormap('Spectral',256,VELAS.flipflag);
    case 'coolwarm'
        [~,colorm] = interpColormap('coolwarm',256,VELAS.flipflag);
    otherwise % Default Colormap
        [~,colorm] = interpColormap('viridis',256,VELAS.flipflag); % 'viridis'
end
set(VELAS.aximg,'CData',colorm);
