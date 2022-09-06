function customFlipChk()

global VELAS

if VELAS.cmcstomflag
            cmapstr   = get(VELAS.custcmapname,'String');
            if isExistColormap(cmapstr)
                cmap = cmapstr;
            else
                cmap = VELAS.customcmap;
            end
        else
            cmapstr  = get(VELAS.cmappop,'String');
            cmap     = cmapstr{get(VELAS.cmappop,'Value')};
end

val = get(VELAS.flipcmap,'value');

if val
    set(VELAS.flipcmap,'value',1);
    VELAS.flipflag = true;
    [~,colorm] = interpColormap(cmap,256,true); % 'viridis'
else
    set(VELAS.flipcmap,'value',0);
    VELAS.flipflag = false;
    [~,colorm] = interpColormap(cmap,256,false); % 'viridis'
end

set(VELAS.aximg,'CData',colorm);