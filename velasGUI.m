
%% Creat interface
clc;clear;close all;

global VELAS

scr  = get(groot,'ScreenSize');

VELAS.uiW          = round(0.3125*scr(3));   % The width of VELAS UI
VELAS.uiH          = round(0.87963*scr(4));  % The height of VELAS UI
VELAS.backColor    = [1 1 1];                % The backgroud of VELAS UI

VELAS.importflag   = false;
VELAS.runflag      = false;
VELAS.saveflag     = false;
VELAS.inputData    = [];

VELAS.fontname     = 'Times New Roman';
VELAS.fontweight   = 'bold';
VELAS.fontangle    = 'normal';
VELAS.fontunits    = 'points';
VELAS.fontsize     = 13;

VELAS.mpid         = '';
VELAS.xapikey      = '';
VELAS.mponlineflag = false;
VELAS.mpapiverflag = false; % verflag = false, using new api; verflag = true, using Legacy API

%% main UI
VELAS.hfig = figure('position',[scr(3)/2-VELAS.uiW/2,scr(4)/2-VELAS.uiH/2, VELAS.uiW,VELAS.uiH],...
              'name','VELAS ver.1.0.3',...
              'NumberTitle','off',...
              'Color','w',...
              'menubar','none',...
              'toolbar','none',...
              'Resize','off');
VELAS.name = uicontrol(VELAS.hfig,'style','text',...
              'Units','normalized',...
              'position',[0.01 0.96 0.98 0.04],...
              'FontName','Times New Roman',...
              'FontSize',26,...
              'FontWeight','bold',...
              'string','VELAS',...
              'BackgroundColor',VELAS.backColor);

%% Input: elastic tensor (also called stiffness matrix)
VELAS.Cpl    = uipanel(VELAS.hfig,'Title','Elastic constant matrix Cij (GPa) / Sij (GPa^-1):',...
                  'Units','normalized',...
                  'position',[0.004 0.645 0.996 0.31],...
                  'FontName','Times New Roman',...
                  'FontSize',16,...
                  'FontWeight','bold',...
                  'BackgroundColor',VELAS.backColor);
% filename
uicontrol(VELAS.Cpl,'style','text',...
               'Units','normalized',...
               'position',[0.02 0.868 0.24 0.10],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','Full filename: ',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor);

VELAS.Cfname = uicontrol(VELAS.Cpl,'style','edit',...
               'Units','normalized',...
               'position',[0.205 0.87 0.785 0.085],...
               'FontName','Times New Roman',...
               'FontSize',12,...
               'FontWeight','bold',...
               'String','',...
               'HorizontalAlignment','center',...
               'BackgroundColor',VELAS.backColor);

% If the input is Stifness matrix C, please don't check it.
VELAS.Sij =uicontrol(VELAS.Cpl,'style','checkbox',...
               'Units','normalized',...
               'position',[0.02 0.76 0.38 0.10],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String',' Compliance matrix Sij',...
               'HorizontalAlignment','left',...
               'TooltipString','If the inputs is stifness matrix C, please don''t check it!',...
               'BackgroundColor',VELAS.backColor);

% Crystal System
uicontrol(VELAS.Cpl,'style','text',...
               'Units','normalized',...
               'position',[0.52 0.75 0.21 0.10],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','Crystal System: ',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor);
VELAS.Cpop = uicontrol(VELAS.Cpl,'style','popupmenu',...
               'Units','normalized',...
               'position',[0.72 0.74 0.27 0.12],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String',{'none','Cubic','Hexagonal','Tetragonal','Trigonal','Orthorhombic','Monoclinic','Triclinic','Isotropic'},...
               'HorizontalAlignment','center',...
               'BackgroundColor',VELAS.backColor);

% elastic constant matrix
VELAS.CS  = uicontrol(VELAS.Cpl,'style','edit',...
               'Units','normalized',...
               'position',[0 0.25 1 0.48],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'Max',2,...
               'String','',...
               'HorizontalAlignment','right',...
               'BackgroundColor',VELAS.backColor);

% Materials Project API
uicontrol(VELAS.Cpl,'style','text',...
               'Units','normalized',...
               'position',[0.01 0.132 0.60 0.10],...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'String','Materials Project API [Material ID/Formula]: ',...
               'Tooltipstring','Format of Material ID: mp-xxxx or mvc-xxxx; Pretty Formula：SiC; Pretty Formula is only available in offline mode.',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor);
VELAS.mpmid = uicontrol(VELAS.Cpl,'style','edit',...
               'Units','normalized',...
               'position',[0.60 0.13 0.22 0.10],...
               'FontName','Times New Roman',...
               'FontSize',12,...
               'FontWeight','bold',...
               'String','',... mp-7631 ...
               'Tooltipstring','Format of Material ID: mp-xxxx or mvc-xxxx; Pretty Formula：SiC; Pretty Formula is only available in offline mode.',...
               'HorizontalAlignment','center',...
               'BackgroundColor',VELAS.backColor);
VELAS.mponline = uicontrol(VELAS.Cpl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.83 0.13 0.2 0.10],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','Online',...
               'HorizontalAlignment','left',...
               'Tooltipstring','Check it if you want to use online mode.',...
               'BackgroundColor',VELAS.backColor,...
               'Value',0);

uicontrol(VELAS.Cpl,'style','text',...
               'Units','normalized',...
               'position',[0.01 0.01 0.17 0.1],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','X-API-KEY: ',...
               'Tooltipstring','X-API-KEY cannot be empty! No need to provide X-API-KEY in offline mode.',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor);
VELAS.mpapikey = uicontrol(VELAS.Cpl,'style','edit',...
               'Units','normalized',...
               'position',[0.18 0.014 0.50 0.10],...
               'FontName','Times New Roman',...
               'FontSize',10,...
               'FontWeight','bold',...
               'String','',... xhxiBwBUZGqBuMP2A4zHKLHZjQYuTLIr ...
               'HorizontalAlignment','center',...
               'Tooltipstring','X-API-KEY cannot be empty! No need to provide X-API-KEY in offline mode.',...
               'BackgroundColor',VELAS.backColor);
VELAS.mpapiver = uicontrol(VELAS.Cpl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.685 0.014 0.2 0.10],...
               'FontName','Times New Roman',...
               'FontSize',9.5,...
               'FontWeight','bold',...
               'String','Legacy API',...
               'HorizontalAlignment','left',...
               'Tooltipstring','The new api may do not work, please check it to use Legacy API. No need to provide X-API-KEY in offline mode.',...
               'BackgroundColor',VELAS.backColor,...
               'Value',0);
VELAS.mpapibtn = uicontrol(VELAS.Cpl,'style','pushbutton',...
               'Units','normalized',...
               'position',[0.83 0.01 0.16 0.10],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','Query',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor);

%% Basic parameters
VELAS.basepl = uipanel(VELAS.hfig,'Title','Basic parameters',...
                  'Units','normalized',...
                  'position',[0.004 0.48 0.996 0.16],...
                  'FontName','Times New Roman',...
                  'FontSize',16,...
                  'FontWeight','bold',...
                  'BackgroundColor',VELAS.backColor);
% Caculation Mode
uicontrol(VELAS.basepl,'style','text',...
               'Units','normalized',...
               'position',[0.01 0.72 0.24 0.15],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','Calculation Mode: ',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor);
VELAS.basepop = uicontrol(VELAS.basepl,'style','popupmenu',...
               'Units','normalized',...
               'position',[0.25 0.72 0.12 0.17],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String',{'3D','2D','Both'},...
               'HorizontalAlignment','right',...
               'BackgroundColor',VELAS.backColor);

% Structure under Pressure (GPa)
uicontrol(VELAS.basepl,'style','text',...
               'Units','normalized',...
               'position',[0.39 0.72 0.24 0.17],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','Pressure (GPa): ',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor);
VELAS.basepressure = uicontrol(VELAS.basepl,'style','edit',...
               'Units','normalized',...
               'position',[0.61 0.72 0.1 0.17],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','0',...
               'HorizontalAlignment','center',...
               'BackgroundColor',VELAS.backColor);

% 3D mesh number of [θ, φ, χ]
uicontrol(VELAS.basepl,'style','text',...
               'Units','normalized',...
               'position',[0.01 0.47 0.36 0.17],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','3D mesh number of [θ, φ, χ]:',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor);
VELAS.basenmesh3d = uicontrol(VELAS.basepl,'style','edit',...
               'Units','normalized',...
               'position',[0.39 0.47 0.32 0.17],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','200 400 360',...
               'HorizontalAlignment','center',...
               'BackgroundColor',VELAS.backColor);

% '2D mesh number of [θ]
uicontrol(VELAS.basepl,'style','text',...
               'Units','normalized',...
               'position',[0.01 0.24 0.36 0.17],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','2D mesh number of [θ]:',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor);
VELAS.basenmesh2d = uicontrol(VELAS.basepl,'style','edit',...
               'Units','normalized',...
               'position',[0.39 0.24 0.32 0.17],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','400',...
               'HorizontalAlignment','center',...
               'BackgroundColor',VELAS.backColor);

% Precision control, teps.
uicontrol(VELAS.basepl,'style','text',...
               'Units','normalized',...
               'position',[0.01 0.01 0.36 0.17],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','Precision control, teps:',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor);
VELAS.baseteps = uicontrol(VELAS.basepl,'style','edit',...
               'Units','normalized',...
               'position',[0.39 0.01 0.32 0.17],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','1e-10',...
               'HorizontalAlignment','center',...
               'BackgroundColor',VELAS.backColor);

% Plane for 2D Calculation
uicontrol(VELAS.basepl,'style','text',...
               'Units','normalized',...
               'position',[0.74 0.86 0.20 0.17],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'String','Plane for 2D:',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor);
VELAS.baseplaneSph = uicontrol(VELAS.basepl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.76 0.70 0.09 0.17],...
               'FontName','Times New Roman',...
               'FontSize',11,...
               'FontWeight','bold',...
               'String',' Sph',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor,...
               'Value',0);
VELAS.baseplaneRad = uicontrol(VELAS.basepl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.87 0.70 0.09 0.17],...
               'FontName','Times New Roman',...
               'FontSize',11,...
               'FontWeight','bold',...
               'String',' Rad',...
               'HorizontalAlignment','left',...
               'BackgroundColor',VELAS.backColor,...
               'Value',0);

VELAS.baseplane = uicontrol(VELAS.basepl,'style','edit',...
               'Units','normalized',...
               'position',[0.74 0.01 0.25 0.67],...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'Max',2,...
               'String',{'1 0 0';'0 1 0';'0 0 1'},...
               'HorizontalAlignment','center',...
               'BackgroundColor',VELAS.backColor);

%% Properties
VELAS.propl = uipanel(VELAS.hfig,'Title','Properties',...
                  'Units','normalized',...
                  'position',[0.004 0.215 0.996 0.26],...
                  'FontName','Times New Roman',...
                  'FontSize',16,...
                  'FontWeight','bold',...
                  'BackgroundColor',VELAS.backColor);
% Young (GPa)
VELAS.proYoung = uicontrol(VELAS.propl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.02 0.88 0.15 0.09],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',' Young',...
               'Value',1);

% Linear Compressibility (TPa^-1)
VELAS.proLC  = uicontrol(VELAS.propl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.17 0.88 0.35 0.09],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',' Linear Compressibility',...
               'Value',1);
% Shear (GPa)
VELAS.proShear = uicontrol(VELAS.propl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.58 0.88 0.15 0.09],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',' Shear ',...
               'Value',1);

% Poisson's Ratio
VELAS.proPoisson = uicontrol(VELAS.propl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.75 0.88 0.24 0.09],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',' Poisson''s Ratio ',...
               'Value',1);

% Bulk (GPa)
VELAS.proBulk = uicontrol(VELAS.propl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.02 0.72 0.15 0.08],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',13,...
               'FontWeight','bold',...
               'string',' Bulk',...
               'Value',0);

% Pugh Ratio
VELAS.proPugh = uicontrol(VELAS.propl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.17 0.72 0.2 0.09],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',' Pugh Ratio',...
               'Value',0);

% Vickers Hardness (GPa)
uicontrol(VELAS.propl,'style','text',...
               'Units','normalized',...
               'position',[0.37 0.72 0.33 0.08],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',' Vickers Hardness (GPa):',...
               'HorizontalAlignment','left');
VELAS.proHv  = uicontrol(VELAS.propl,'style','popupmenu',...
               'Units','normalized',...
               'position',[0.70 0.70 0.25 0.10],...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'String',{'none','Mazhnik''s model','Chen''s model','Tian''s model'},...
               'HorizontalAlignment','right',...
               'BackgroundColor',VELAS.backColor);

% Fracture Toughness (KIC, MPa*m^(1/2))
VELAS.pKIC = uipanel(VELAS.propl,'Title','Fracture Toughness (KIC, MPa*m^(1/2))',...
                  'Units','normalized',...
                  'position',[0.005 0.15 0.99 0.53],...
                  'FontName','Times New Roman',...
                  'FontSize',12.5,...
                  'FontWeight','bold',...
                  'BackgroundColor',VELAS.backColor);
uicontrol(VELAS.pKIC,'style','text',...
               'Units','normalized',...
               'position',[0.00 0.68 0.09 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','V0:',...
               'HorizontalAlignment','right');
VELAS.proKICV0 = uicontrol(VELAS.pKIC,'style','edit',...
               'Units','normalized',...
               'position',[0.09 0.68 0.12 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','',...
               'HorizontalAlignment','center');
uicontrol(VELAS.pKIC,'style','text',...
               'Units','normalized',...
               'position',[0.28 0.68 0.09 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','gEFr:',...
               'HorizontalAlignment','right');
VELAS.proKICgEFr = uicontrol(VELAS.pKIC,'style','edit',...
               'Units','normalized',...
               'position',[0.37 0.68 0.12 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','',...
               'HorizontalAlignment','center');

uicontrol(VELAS.pKIC,'style','text',...
               'Units','normalized',...
               'position',[0.00 0.35 0.09 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','m:',...
               'HorizontalAlignment','right');
VELAS.proKICm = uicontrol(VELAS.pKIC,'style','edit',...
               'Units','normalized',...
               'position',[0.09 0.35 0.12 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','',...
               'HorizontalAlignment','center');
uicontrol(VELAS.pKIC,'style','text',...
               'Units','normalized',...
               'position',[0.28 0.35 0.09 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','n:',...
               'HorizontalAlignment','right');
VELAS.proKICn = uicontrol(VELAS.pKIC,'style','edit',...
               'Units','normalized',...
               'position',[0.37 0.35 0.12 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','',...
               'HorizontalAlignment','center');

uicontrol(VELAS.pKIC,'style','text',...
               'Units','normalized',...
               'position',[0.00 0.05 0.09 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','XA:',...
               'HorizontalAlignment','right');
VELAS.proKICXA = uicontrol(VELAS.pKIC,'style','edit',...
               'Units','normalized',...
               'position',[0.09 0.05 0.12 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','',...
               'HorizontalAlignment','center');
uicontrol(VELAS.pKIC,'style','text',...
               'Units','normalized',...
               'position',[0.28 0.05 0.09 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','XB:',...
               'HorizontalAlignment','right');
VELAS.proKICXB = uicontrol(VELAS.pKIC,'style','edit',...
               'Units','normalized',...
               'position',[0.37 0.05 0.12 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','',...
               'HorizontalAlignment','center');

uicontrol(VELAS.pKIC,'style','text',...
               'Units','normalized',...
               'position',[0.53 0.55 0.20 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','Material Type:',...
               'HorizontalAlignment','right');
VELAS.proKICtppop = uicontrol(VELAS.pKIC,'style','popupmenu',...
               'Units','normalized',...
               'position',[0.735 0.50  0.26 0.25],...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'String',{'none','Ionic/Covalent','Pure metal','Intermetallic'},...
               'HorizontalAlignment','right',...
               'BackgroundColor',VELAS.backColor);

uicontrol(VELAS.pKIC,'style','text',...
               'Units','normalized',...
               'position',[0.53 0.18 0.20 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','KIC Model:',...
               'HorizontalAlignment','right');
VELAS.proKICmdpop = uicontrol(VELAS.pKIC,'style','popupmenu',...
               'Units','normalized',...
               'position',[0.735 0.12  0.26 0.25],...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'String',{'none','Niu''s model','Mazhnik''s model'},...
               'HorizontalAlignment','right',...
               'BackgroundColor',VELAS.backColor);

% Do you want to output the average value? (DFLT: No)
VELAS.proAvg = uicontrol(VELAS.propl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.01 0.03 0.75 0.09],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',' Do you want to output the average value? (DFLT: No)',...
               'Value',0);

%% Plot setting
VELAS.pltpl = uipanel(VELAS.hfig,'Title','Plot setting',...
                  'Units','normalized',...
                  'position',[0.004 0.05 0.996 0.16],...
                  'FontName','Times New Roman',...
                  'FontSize',16,...
                  'FontWeight','bold',...
                  'BackgroundColor',VELAS.backColor);
% Print setting
% colormap
uicontrol(VELAS.pltpl,'style','text',...
               'Units','normalized',...
               'position',[0.01 0.73 0.15 0.18],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','Colormap:',...
               'HorizontalAlignment','left');
VELAS.cmappop = uicontrol(VELAS.pltpl,'style','popupmenu',...
               'Units','normalized',...
               'position',[0.16 0.72 0.16 0.18],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',{'viridis','cool','summer','copper','hot','ocean','gray','bone','pink','spring','autumn','winter','cubehelix','jet','rainbow','hsv','turbo','colorcube','flag','lines','prism'},...
               'HorizontalAlignment','left',...
               'Value',1);
VELAS.axcmap  = axes(VELAS.pltpl,'position',[0.325 0.66 0.2 0.3]);
axis normal;
[~,colorm]    = interpColormap('viridis',256);
VELAS.aximg   = imshow(colorm);
set(VELAS.cmappop,'Callback','setColormapFig;');

% Font setting
fontbts = uicontrol(VELAS.pltpl,'style','pushbutton',...
               'Units','normalized',...
               'position',[0.54 0.72 0.2 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','Set Fonts',...
               'Callback','setPlotFont;',...
               'HorizontalAlignment','left');

% plot directly
% Font setting
VELAS.pltdirct = uicontrol(VELAS.pltpl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.76 0.72 0.22 0.2],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',' Plot Directly',...
               'HorizontalAlignment','left');

% Plotting 3D Unit Spherical
VELAS.p3dUSph = uicontrol(VELAS.pltpl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.01 0.50 0.60 0.18],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',' 3D Unit Spherical or not? (DFLT: No)',...
               'Value',0);
% Map Projection
VELAS.p2dMPro = uicontrol(VELAS.pltpl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.01 0.30 0.50 0.18],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',' Map Projection or not? (DFLT: Yes)',...
               'Value',1);
% Projection Mode
VELAS.p2dMMod = uicontrol(VELAS.pltpl,'style','popupmenu',...
               'Units','normalized',...
               'position',[0.51 0.30 0.24 0.18],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',{'Gall-Peters','Robinson','Hammer-Aitoff','Mollweide'},...
               'HorizontalAlignment','left',...
               'Value',1);
% map linestyle
VELAS.p2dLStl = uicontrol(VELAS.pltpl,'style','popupmenu',...
               'Units','normalized',...
               'position',[0.76 0.30 0.23 0.18],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',{'------ Dash','......... Dot','-.-.-.- Dash-Dot','──── solid'},...
               'HorizontalAlignment','left',...
               'Value',1);

% Print setting
VELAS.doprint = uicontrol(VELAS.pltpl,'style','radiobutton',...
               'Units','normalized',...
               'position',[0.01 0.06 0.46 0.18],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string',' Print figure or not? (DFLT: No)',...
               'Value',0);
uicontrol(VELAS.pltpl,'style','text',...
               'Units','normalized',...
               'position',[0.47 0.04 0.07 0.18],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','DPI:');
VELAS.dpi = uicontrol(VELAS.pltpl,'style','edit',...
               'Units','normalized',...
               'position',[0.54 0.04 0.15 0.18],...
               'BackgroundColor',VELAS.backColor,...
               'FontName','Times New Roman',...
               'FontSize',12.5,...
               'FontWeight','bold',...
               'string','600',...
               'HorizontalAlignment','center');
%% button groups
% Import file
VELAS.importbtn = uicontrol(VELAS.hfig,'style','pushbutton',...
              'Units','normalized',...
              'position',[0.01 0.005 0.18 0.04],...
              'FontName','Times New Roman',...
              'FontSize',14,...
              'FontWeight','bold',...
              'string','Import file',...
              'BackgroundColor',VELAS.backColor);
% Run
VELAS.runbtn  = uicontrol(VELAS.hfig,'style','pushbutton',...
              'Units','normalized',...
              'position',[0.21 0.005 0.18 0.04],...
              'FontName','Times New Roman',...
              'FontSize',14,...
              'FontWeight','bold',...
              'string','Run',...
              'BackgroundColor',VELAS.backColor,...
              'Enable','on');

% Plot config
VELAS.plotbtn = uicontrol(VELAS.hfig,'style','pushbutton',...
              'Units','normalized',...
              'position',[0.41 0.005 0.18 0.04],...
              'FontName','Times New Roman',...
              'FontSize',14,...
              'FontWeight','bold',...
              'string','Plot',...
              'BackgroundColor',VELAS.backColor);

% Save config
VELAS.savebtn = uicontrol(VELAS.hfig,'style','pushbutton',...
              'Units','normalized',...
              'position',[0.61 0.005 0.18 0.04],...
              'FontName','Times New Roman',...
              'FontSize',14,...
              'FontWeight','bold',...
              'string','Save config',...
              'BackgroundColor',VELAS.backColor);

% Exit
VELAS.exitbtn  = uicontrol(VELAS.hfig,'style','pushbutton',...
              'Units','normalized',...
              'position',[0.81 0.005 0.18 0.04],...
              'FontName','Times New Roman',...
              'FontSize',14,...
              'FontWeight','bold',...
              'string','Exit',...
              'BackgroundColor',VELAS.backColor);

% Callback
set(VELAS.mpapibtn,'Callback','queryApiUI;');
set(VELAS.importbtn,'Callback','importUI;');
set(VELAS.runbtn,'Callback','runUI;');
set(VELAS.plotbtn,'Callback','plotUI;');
set(VELAS.savebtn,'Callback','saveConfigUI;');
set(VELAS.exitbtn,'Callback','exitUI;');
