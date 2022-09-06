function customCMRdbtn()

global VELAS

val = get(VELAS.cmapcustom,'value');

if val
    VELAS.cmcstomflag = true;
    set(VELAS.cmapcustom,'value',1);
    set(VELAS.custcmapname,'Enable','on');
    set(VELAS.setbtn,'Enable','on');
    set(VELAS.cmappop,'Enable','off');
else
    VELAS.cmcstomflag = false;
    set(VELAS.cmapcustom,'value',0);
    set(VELAS.custcmapname,'Enable','off');
    set(VELAS.custcmapname,'String','viridis');
    VELAS.customcmap = 'viridis';
    set(VELAS.setbtn,'Enable','off');
    set(VELAS.cmappop,'Enable','on');
end
