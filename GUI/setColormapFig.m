function setColormapFig()

global VELAS

val  = get(VELAS.cmappop,'Value');
str  = get(VELAS.cmappop,'String');
flag = str{val};
switch(flag)
    case 'viridis'
        [~,colorm] = interpColormap('viridis',256); % 'viridis'
    case 'cool'
        [~,colorm] = interpColormap('cool',256);    % 'cool'
    case 'summer'
        [~,colorm] = interpColormap('summer',256);  % 'summer'
    case 'copper'
        [~,colorm] = interpColormap('copper',256);  % 'copper'
    case 'hot'
        [~,colorm] = interpColormap('hot',256);     % 'hot'
    case 'ocean'
        [~,colorm] = interpColormap('ocean',256);   % 'ocean'
    case 'gray'
        [~,colorm] = interpColormap('gray',256);    % 'gray'
    case 'bone'
        [~,colorm] = interpColormap('bone',256);    % 'bone'
    case 'pink'
        [~,colorm] = interpColormap('pink',256);    % 'pink'
    case 'spring'
        [~,colorm] = interpColormap('spring',256);  % 'spring'
    case 'autumn'
        [~,colorm] = interpColormap('autumn',256);  % 'autumn'
    case 'winter'
        [~,colorm] = interpColormap('winter',256);  % 'winter'
    case 'cubehelix'
        % Green, D. A., 2011, ‘A colour scheme for the display of astronomical intensity images’, Bulletin of the Astronomical Society of India, 39, 289.
        % Please cite this paper if you use ‘cubehelix’ in any publications.
        [~,colorm] = interpColormap('cubehelix',256); %'cubehelix'
    case 'jet'
        [~,colorm] = interpColormap('jet',256);     % 'jet'
    case 'rainbow'
        [~,colorm] = interpColormap('rainbow',256); % 'rainbow'
    case 'hsv'
        [~,colorm] = interpColormap('hsv',256);     % 'hsv'
    case 'turbo'
        [~,colorm] = interpColormap('turbo',256); % 'turbo'
    case 'colorcube'
        [~,colorm] = interpColormap('colorcube',256); % 'colorcube'
    case 'flag'
        [~,colorm] = interpColormap('flag',256); % 'flag'
    case 'lines'
        [~,colorm] = interpColormap('lines',256); % 'lines'
    case 'prism'
        [~,colorm] = interpColormap('prism',256); % 'prism'
    otherwise % Default Colormap
        [~,colorm] = interpColormap('viridis',256); % 'viridis'
end
set(VELAS.aximg,'CData',colorm);
