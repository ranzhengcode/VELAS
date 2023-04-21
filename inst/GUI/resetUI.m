function resetUI()

global VELAS

%% Input: elastic tensor (also called stiffness matrix)
set(VELAS.Cfname,'String','');
set(VELAS.Sij,'Value',0);
set(VELAS.Cpop,'Value',1);
set(VELAS.CS,'String','');

set(VELAS.mpmid,'String','');
set(VELAS.mponline,'Value',0);
set(VELAS.mpapikey,'String','');
set(VELAS.mpapiver,'Value',0);

%% Basic parameters
set(VELAS.basepop,'Value',1);
set(VELAS.basepressure,'String','0');
set(VELAS.basenmesh3d,'String','200 400 360');
set(VELAS.basenmesh2d,'String','400');
set(VELAS.baseteps,'String','1e-10');
set(VELAS.baseplaneSph,'Value',0);
set(VELAS.baseplaneRad,'Value',0);
set(VELAS.baseplane,'String','');

%% Properties
set(VELAS.proYoung,'Value',1);
set(VELAS.proLC,'Value',1);
set(VELAS.proShear,'Value',1);
set(VELAS.proPoisson,'Value',1);
set(VELAS.proBulk,'Value',0);
set(VELAS.proPugh,'Value',0);
set(VELAS.proHv,'Value',1);

set(VELAS.proKICV0,'String','');
set(VELAS.proKICgEFr,'String','');
set(VELAS.proKICm,'String','');
set(VELAS.proKICn,'String','');
set(VELAS.proKICXA,'String','');
set(VELAS.proKICXB,'String','');
set(VELAS.proKICtppop,'Value',1);
set(VELAS.proKICmdpop,'Value',1);

set(VELAS.proAvg,'Value',0);

%% Plot setting
set(VELAS.cmappop,'Value',1);
setColormapFig;
set(VELAS.pltdirct,'Value',1);
set(VELAS.p3dUSph,'Value',0);
set(VELAS.p2dMPro,'Value',1);
set(VELAS.p2dMMod ,'Value',1);
set(VELAS.p2dLStl,'Value',1);
set(VELAS.doprint,'Value',0);
set(VELAS.dpi,'String','600');

