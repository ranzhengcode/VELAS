function importUI()

global VELAS

[filen, pathn] = uigetfile({'*.txt'},'Select an input file');
if isequal(filen,0)
    errordlg('No file selected.','VELAS reminder');
else
    %     [~,tname,~]     = fileparts(filen);
    resetUI();  % reset UI
    filename        = strcat(pathn,filen);
    inputData       = getInput(filename);
    VELAS.inputData = inputData;

    VELAS.importflag = true;

    %% Input: elastic tensor (also called stiffness matrix)

    % filename
    set(VELAS.Cfname,'String',filename);
    % If the input is Stifness matrix C, please don't check this
    switch(lower(inputData.cryType))
        % {'none','Cubic','Hexagonal','Tetragonal','Trigonal','Orthorhombic','Monoclinic','Triclinic','Isotropic'}
        case 'cubic'
            set(VELAS.Cpop,'Value',2);
        case 'hexagonal'
            set(VELAS.Cpop,'Value',3);
        case 'tetragonal'
            set(VELAS.Cpop,'Value',4);
        case 'trigonal'
            set(VELAS.Cpop,'Value',5);
        case 'orthorhombic'
            set(VELAS.Cpop,'Value',6);
        case 'monoclinic'
            set(VELAS.Cpop,'Value',7);
        case 'triclinic'
            set(VELAS.Cpop,'Value',8);
        case 'isotropic'
            set(VELAS.Cpop,'Value',9);
    end

    % Crystal System
    set(VELAS.CS,'String',num2str(roundN(inputData.C,2)));

    % Materials Project API
    set(VELAS.mponline,'Value',VELAS.inputData.mponline);
    switch(lower(VELAS.inputData.mpapiver))
        case 'new'
            set(VELAS.mpapiver,'Value',0);
        case {'old','legacy'}
            set(VELAS.mpapiver,'Value',1);
    end
    if strcmp(lower(VELAS.inputData.mpid),'none')
        set(VELAS.mpmid,'String','');
    else
        set(VELAS.mpmid,'String', VELAS.inputData.mpid);
    end

    if strcmp(lower(VELAS.inputData.xapikey),'none')
        set(VELAS.mpapikey,'String','');
    else
        set(VELAS.mpapikey,'String', VELAS.inputData.xapikey);
    end

    %% Basic parameters

    % Caculation Mode
    flag3d   = any(inputData.Pro(1,:));
    flag2d   = any(inputData.Pro(2,:));
    flagboth = flag3d & flag2d;
    if flagboth
        % {'3D','2D','Both'}
        set(VELAS.basepop,'Value',3);
    else
        if flag3d
            set(VELAS.basepop,'Value',1);
        end
        if flag2d
            set(VELAS.basepop,'Value',2);
        end
    end

    % Structure under Pressure (GPa)
    set(VELAS.basepressure,'String',num2str(inputData.pressure));

    % 3D mesh number of [θ, φ, χ]
    set(VELAS.basenmesh3d,'String',num2str([inputData.ntheta inputData.nphi inputData.nchi]));

    % volume of crystal cell (A^3)
    set(VELAS.basevol,'String',num2str(inputData.volume));

    % '2D mesh number of [θ]
    set(VELAS.basenmesh2d,'String',num2str(inputData.ntheta2d));

    % Density of crystal cell
    set(VELAS.baseden,'String',num2str(inputData.density));

    % Precision control, teps.
    set(VELAS.baseteps,'String',num2str(inputData.teps));

    % total number of atoms in crystal cell
    % Density of crystal cell
    set(VELAS.baseatomn,'String',num2str(inputData.atomnum));

    % Plane for 2D Calculation
    if inputData.planeSph
        set(VELAS.baseplaneSph,'Value',1);
        if inputData.planeAng
            set(VELAS.baseplaneRad,'Value',0);
        else
            set(VELAS.baseplaneRad,'Value',1);
        end

        if ~isempty(inputData.planeS)
            set(VELAS.baseplane,'String',num2str(inputData.planeS));
        else
            set(VELAS.baseplane,'String','');
        end
    else
        set(VELAS.baseplaneSph,'Value',0);
        if ~isempty(inputData.planeC)
            set(VELAS.baseplane,'String',num2str(inputData.planeC));
        else
            set(VELAS.baseplane,'String','');
        end

    end

    %% Properties
    %{
                properties — Pro(2*8)

                        Young   Compressibility  Shear   Poisson  Bulk    Pugh Ratio   Hardness   Fracture Toughness
            3D mode:    1/0         1/0          1/0      1/0      1/0      1/0          1/0              1/0
            2D mode:    1/0         1/0          1/0      1/0      1/0      1/0          1/0              1/0

            Young3D             — Pro(1,1),  Young2D             — Pro(2,1);
            Compressibility3D   — Pro(1,2),  Compressibility2D   — Pro(2,2);
            Shear3D             — Pro(1,3),  Shear2D             — Pro(2,3);
            Poisson3D           — Pro(1,4),  Poisson2D           — Pro(2,4);
            Bulk3D              — Pro(1,5),  Bulk2D              — Pro(2,5);
            PughRatio3D         — Pro(1,6),  PughRatio2D         — Pro(2,6),
            Hardness3D          — Pro(1,7),  Hardness2D          — Pro(2,7);
            FractureToughness3D — Pro(1,8),  FractureToughness3D — Pro(2,8);
    %}

    % Young (GPa)
    if inputData.Pro(1,1) || inputData.Pro(2,1)
        set(VELAS.proYoung,'Value',1);
    else
        set(VELAS.proYoung,'Value',0);
    end

    % Linear Compressibility (TPa^-1)
    if inputData.Pro(1,2) || inputData.Pro(2,2)
        set(VELAS.proLC,'Value',1);
    else
        set(VELAS.proLC,'Value',0);
    end

    % Shear (GPa)
    if inputData.Pro(1,3) || inputData.Pro(2,3)
        set(VELAS.proShear,'Value',1);
    else
        set(VELAS.proShear,'Value',0);
    end

    % Poisson's Ratio
    if inputData.Pro(1,4) || inputData.Pro(2,4)
        set(VELAS.proPoisson,'Value',1);
    else
        set(VELAS.proPoisson,'Value',0);
    end

    % Bulk (GPa)
    if inputData.Pro(1,5) || inputData.Pro(2,5)
        set(VELAS.proBulk,'Value',1);
    else
        set(VELAS.proBulk,'Value',0);
    end

    % Pugh Ratio
    if inputData.Pro(1,6) || inputData.Pro(2,6)
        set(VELAS.proPugh,'Value',1);
    else
        set(VELAS.proPugh,'Value',0);
    end

    % Vickers Hardness (GPa)
    % {'none','Mazhnik''s model','Chen''s model','Tian''s model'}
    if inputData.Pro(1,7) || inputData.Pro(2,7)
        switch(inputData.HvModel)
            case {'M'}
                set(VELAS.proHv,'Value',2);
            case {'C'}
                set(VELAS.proHv,'Value',3);
            case {'T'}
                set(VELAS.proHv,'Value',4);
        end
    else
        set(VELAS.proHv,'Value',1);
    end

    switch(inputData.KIC.material)
        % {'none','Ionic/Covalent','Pure metal','Intermetallic'}
        case 'IC'
            set(VELAS.proKICtppop,'Value',2);
        case 'M'
            set(VELAS.proKICtppop,'Value',3);
        case 'IM'
            set(VELAS.proKICtppop,'Value',4);
        otherwise
            set(VELAS.proKICtppop,'Value',1);
    end

    switch(inputData.KIC.model)
        % {'none','Niu''s model','Mazhnik''s model'}
        case {'N','Niu'}
            set(VELAS.proKICmdpop,'Value',2);
        case {'M','Mazhnik'}
            set(VELAS.proKICmdpop,'Value',3);
        otherwise
            set(VELAS.proKICmdpop,'Value',1);
    end


    % Fracture Toughness (KIC, MPa*m^(1/2))
    if ~isempty(inputData.KIC.V0) && ~isequal(inputData.KIC.V0,0)
        set(VELAS.proKICV0,'String',num2str(inputData.KIC.V0));
    else
        set(VELAS.proKICV0,'String','');
    end

    if ~isempty(inputData.KIC.gEFr) && ~isequal(inputData.KIC.gEFr,0)
        set(VELAS.proKICgEFr,'String',num2str(inputData.KIC.gEFr));
    else
        set(VELAS.proKICgEFr,'String','');
    end

    if ~isempty(inputData.KIC.m) && ~isequal(inputData.KIC.m,0)
        set(VELAS.proKICm,'String',num2str(inputData.KIC.m));
    else
        set(VELAS.proKICm,'String','');
    end

    if ~isempty(inputData.KIC.n) && ~isequal(inputData.KIC.n,0)
        set(VELAS.proKICn,'String',num2str(inputData.KIC.n));
    else
        set(VELAS.proKICn,'String','');
    end

    if ~isempty(inputData.KIC.XA) && ~isequal(inputData.KIC.XA,0)
        set(VELAS.proKICXA,'String',num2str(inputData.KIC.XA));
    else
        set(VELAS.proKICXA,'String','');
    end

    if ~isempty(inputData.KIC.XB) && ~isequal(inputData.KIC.XB,0)
        set(VELAS.proKICXB,'String',num2str(inputData.KIC.XB));
    else
        set(VELAS.proKICXB,'String','');
    end


    % Do you want to output the average value? (default: No)
    if inputData.avgout
        set(VELAS.proAvg,'Value',1);
    else
        set(VELAS.proAvg,'Value',0);
    end

    % color map
    cmapall = get(VELAS.cmappop,'String');
    cloc    = find(strcmp(inputData.cmap,cmapall)==1);
    if ~isempty(cloc)
        set(VELAS.cmappop,'Value',cloc);
    else
        set(VELAS.cmappop,'Value',1);
    end
    setColormapFig;

    % 3D Unit Spherica
    if inputData.dounitsph
        set(VELAS.p3dUSph,'Value',1);
    end

    % Map Projection
    if inputData.domap
        set(VELAS.p2dMPro,'Value',1);
    end

    switch(inputData.mpmode)
        case {'Gall-Peters'}
            set(VELAS.p2dMMod,'Value',1);
        case {'Robinson'}
            set(VELAS.p2dMMod,'Value',2);
        case {'Hammer-Aitoff'}
            set(VELAS.p2dMMod,'Value',3);
        case {'Mollweide'}
            set(VELAS.p2dMMod,'Value',4);
        otherwise
            set(VELAS.p2dMMod,'Value',4); % default: 'Mollweide'
    end

    switch(inputData.lineStyle)
        case '--'
            set(VELAS.p2dLStl,'Value',1);
        case ':'
            set(VELAS.p2dLStl,'Value',2);
        case '-.'
            set(VELAS.p2dLStl,'Value',3);
        case '-'
            set(VELAS.p2dLStl,'Value',4);
        otherwise
            set(VELAS.p2dLStl,'Value',1);
    end

    % print
    if inputData.doprint
        set(VELAS.doprint,'Value',1);
    end
    set(VELAS.dpi,'String',num2str(inputData.dpi));

    hmsg = msgbox('Import completed!', 'VELAS reminder','help');
    pause(0.8);
    if ishandle(hmsg)
        close(hmsg);
    end
end
