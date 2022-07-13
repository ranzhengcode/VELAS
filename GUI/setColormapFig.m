function setColormapFig()

global VELAS

val = get(VELAS.cmappop,'Value');

switch(val)
    case 1
        [~,colorm] = interpColormap('jet',256);
    case 2
        [~,colorm] = interpColormap('rainbow',256);
    case 3
        [~,colorm] = interpColormap('hot',256);
    case 4
        [~,colorm] = interpColormap('ocean',256);
    case 5
        [~,colorm] = interpColormap('hsv',256);
    case 6
        [~,colorm] = interpColormap('cool',256);
    case 7
        [~,colorm] = interpColormap('spring',256);
    case 8
        [~,colorm] = interpColormap('summer',256);
    case 9
        [~,colorm] = interpColormap('autumn',256);
    case 10
        [~,colorm] = interpColormap('winter',256);
    case 11
        [~,colorm] = interpColormap('gray',256);
    case 12
        [~,colorm] = interpColormap('bone',256);
    case 13
        [~,colorm] = interpColormap('copper',256);
    case 14
        [~,colorm] = interpColormap('pink',256);
    case 15
        [~,colorm] = interpColormap('viridis',256);
    case 16
        [~,colorm] = interpColormap('cubehelix',256);
end
set(VELAS.aximg,'CData',colorm);
