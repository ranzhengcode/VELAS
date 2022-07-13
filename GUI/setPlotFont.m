function setPlotFont()

global VELAS

uifont = uisetfont;
if isstruct(uifont)
    VELAS.fontname   = uifont.FontName;
    VELAS.fontweight = uifont.FontWeight;
    VELAS.fontangle  = uifont.FontAngle;
    VELAS.fontsize   = uifont.FontSize;
end