function Re = getUiInput()

%{
  ========================== Processing input file ========================
    Input parameter:
                    — filename, the input file name that contains the file path.
    Out parameter:
                    — Re, return all the input parameters in the input file.
%}

global VELAS

tC            = get(VELAS.CS,'String');
[tC,~]        = convertString2Num(tC);

val           = get(VELAS.Cpop,'Value');
tcryType      = get(VELAS.Cpop,'String');
cryType       = tcryType{val};
planeSph      = false;
[C,mLegel]    = checkCS(tC,val);

if mLegel
    m         = size(C,1);
    % {'none','Cubic','Hexagonal','Tetragonal','Trigonal','Orthorhombic','Monoclinic','Triclinic','Isotropic'};
    if val ~= 1 || m == 6

        % Compliance matrix Sij
        S    = inv(C);
        valS = get(VELAS.Sij,'Value');
        if valS == 1
            tC = S;
            S  = C;
            C  = tC;
        end

        % For structure under pressure
        prs          = get(VELAS.basepressure,'String');
        if isempty(prs)
            pressure = 0;     % default:0 GPa
        else
            pressure = str2num(prs);
        end

        % mesh number of theta(θ) (default:200), phi(φ) (default:400), chi (χ) (default:400)

        mesh3d       = get(VELAS.basenmesh3d,'String');
        if isempty(mesh3d)
            ntheta       = 200;
            nphi         = 400;
            nchi         = 400;
        else
            nmesh3d      = str2num(mesh3d);
            len          = length(mesh3d);
            switch(len)
                case 1
                    ntheta = nmesh3d;
                    nphi   = nmesh3d;
                    nchi   = nmesh3d;
                case 2
                    ntheta = nmesh3d(1);
                    nphi   = nmesh3d(2);
                    nchi   = nmesh3d(2);
                case 3
                    ntheta = nmesh3d(1);
                    nphi   = nmesh3d(2);
                    nchi   = nmesh3d(3);
                otherwise
                    ntheta = nmesh3d(1);
                    nphi   = nmesh3d(2);
                    nchi   = nmesh3d(3);
            end
        end


        % mesh number of theta in 2D Plane, (default:400)
        mesh2d           = get(VELAS.basenmesh2d,'String');
        if isempty(mesh2d)
            ntheta2d     = 400;
        else
            nmesh2d      = str2num(mesh2d);
            len          = length(mesh2d);
            switch(len)
                case 1
                    ntheta2d = nmesh2d(1);
                otherwise
                    ntheta2d = nmesh2d(1);
            end
        end

        % Precision control, Less than teps will be considered equal to 0
        teps           = get(VELAS.baseteps,'String');
        if isempty(teps)
            teps     = 1e-10;
        else
            teps      = str2num(teps);
            len       = length(teps);
            switch(len)
                case 1
                    teps = teps(1);
                otherwise
                    teps = teps(1);
            end
        end
        tplane      = get(VELAS.baseplane,'String');
        if isempty(tplane)
            planeC   = [1 0 0; 0 1 0; 0 0 1];
        else
%             tplane   = checkPlane(tplane);
            [tplane,eqflag] = convertString2Num(tplane);
            if ~eqflag
                msgbox({'The size of (hkl) must be m*3 or m*2 (m >=1).','Please check and try again.'}, 'VELAS reminder','error');
            end
            Sphflag  = get(VELAS.baseplaneSph,'Value');
            switch(Sphflag)
                case 0
                    planeC   = cell2mat(tplane);
                    planeSph = false;
                    planeAng = false;
                    planeS   = [];

                case 1
                    len      = size(tplane,1);
                    planeC   = zeros(len,3);
                    planeS   = zeros(len,2);
                    planeSph = true;

                    radflag  = get(VELAS.baseplaneAng,'Value');
                    switch(radflag)
                        case 0
                            planeAng = true;
                            for k = 1:len
                                pL            = tplane{k,1};
                                planetheta    = pL(1);
                                planephi      = pL(2);
                                planex        = sin(planetheta)*cos(planephi);
                                planey        = sin(planetheta)*sin(planephi);
                                planez        = cos(planetheta);
                                planeC(k,:)   = [planex,planey,planez];
                                planeS(k,:)   = pL;
                            end
                        case 1
                            planeAng = false;
                            for k = 1:len
                                pL            = tplane{k,1};
                                planetheta    = pL(1);
                                planephi      = pL(2);
                                planex        = sind(planetheta)*cosd(planephi);
                                planey        = sind(planetheta)*sind(planephi);
                                planez        = cosd(planetheta);
                                planeC(k,:)   = [planex,planey,planez];
                                planeS(k,:)   = pL;
                            end
                    end
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

        Pro       = zeros(2,8);

        proE      = get(VELAS.proYoung,'Value');   % Young (GPa)
        proLC     = get(VELAS.proLC,'Value');      % Linear Compressibility (TPa^-1)
        proG      = get(VELAS.proShear,'Value');   % Shear (GPa)
        proP      = get(VELAS.proPoisson,'Value'); % Poisson's Ratio
        proB      = get(VELAS.proBulk,'Value');    % Bulk (GPa)
        proPr     = get(VELAS.proPugh,'Value');    % Pugh Ratio

        Hvflag    = get(VELAS.proHv,'Value');      % Vickers Hardness (GPa)
        switch(Hvflag)
            case 2
                Re.HvModel = 'M';
            case 3
                Re.HvModel = 'C';
            case 4
                Re.HvModel = 'T';
        end
        if Hvflag ~= 1
            proHv   = 1;
        else
            proHv   = 0;
        end
        

        KICtype   = get(VELAS.proKICtppop,'Value'); % Fracture Toughness (KIC, MPa*m^(1/2))
        KICmode   = get(VELAS.proKICmdpop,'Value');
        KIC       = []; 
        switch(KICtype)
            case 2
                KIC.material = 'IC';
            case 3
                KIC.material = 'PM';
            case 4
                KIC.material = 'IM';
        end

        switch(KICmode)
            case 2
                KIC.model = 'N';
            case 3
                KIC.model = 'M';
        end

        if KICtype ~= 1 && KICmode ~= 1
            proKIC   = 1;
        else
            proKIC   = 0;
        end

        basepop = get(VELAS.basepop,'Value');
        % {'3D','2D','Both'}
        switch(basepop)
            case 1    % 3D
                Pro      = zeros(2,8);
                Pro(1,:) = [proE  proLC  proG  proP  proB  proPr  proHv  proKIC];
            case 2    % 2D
                Pro      = zeros(2,8);
                Pro(2,:) = [proE  proLC  proG  proP  proB  proPr  proHv  proKIC];
            case 3    % both
                Pro(1,:) = [proE  proLC  proG  proP  proB  proPr  proHv  proKIC];
                Pro(2,:) = Pro(1,:);
        end

        % % For fracture toughness Parameters
        V0  = get(VELAS.proKICV0,'String');
        
        if ~isempty(V0)
            KIC.V0 = str2num(V0);
        end

        gEFr = get(VELAS.proKICgEFr,'String');
        if ~isempty(gEFr)
            KIC.gEFr = str2num(gEFr);
        end

        m = get(VELAS.proKICm,'String');
        if ~isempty(m)
            KIC.m = str2num(m);
        end

        n = get(VELAS.proKICn,'String');
        if ~isempty(n)
            KIC.n = str2num(n);
        end

        XA = get(VELAS.proKICXA,'String');
        if ~isempty(XA)
            KIC.XA = str2num(XA);
        end

        XB = get(VELAS.proKICXB,'String');
        if ~isempty(XB)
            KIC.XB = str2num(XB);
        end

        % Do you want to output the average value？ (yes or no), default: No.
        avgOut = get(VELAS.proAvg,'Value');
        if avgOut
            avgout       = true;
        else
            avgout       = false;
        end

        % colormap
        cmapstr      = get(VELAS.cmappop,'String');
        Re.cmap      = cmapstr{get(VELAS.cmappop,'Value')};

        % Plotting 3D Unit Spherical
        Re.dounitsph = get(VELAS.p3dUSph,'Value'); % true or false

        % map projection
        Re.domap     = get(VELAS.p2dMPro,'Value'); % true or false
        mpstr        = get(VELAS.p2dMMod,'String');
        Re.mpmode    = mpstr{get(VELAS.p2dMMod,'Value')}; % {'Gall-Peters','Robinson','Hammer-Aitoff','Mollweide'};


        % print & dpi
        Re.doprint = get(VELAS.doprint,'Value');  % true or false
        if ~isempty(get(VELAS.dpi,'String'))
            Re.dpi = get(VELAS.dpi,'String');    % Resolution, this value is not the real DPI, just control the size of pic.
        else
            Re.dpi = num2str(600);
        end

        lstylVal  = get(VELAS.p2dLStl,'Value');
        switch(lstylVal)
            case 1
                Re.lineStyle = '--';
            case 2
                Re.lineStyle = ':';
            case 3
                Re.lineStyle = '-.';
            case 4
                Re.lineStyle = '-';
        end

        % output of input data
        % Output filename
        filename        = get(VELAS.Cfname,'String');
        if isempty(filename)
            
            filename    = strcat(pwd,filesep,'VELAS',strrep(datestr(now,'yyyymmddHH:MM:SS'),':',''),'.txt');
            set(VELAS.Cfname,'String',filename);
        end
        Re.filename     = filename;
        Re.C            = C;
        Re.S            = S;
        Re.cryType      = cryType;
        Re.pressure     = pressure;
        Re.ntheta       = ntheta;
        Re.nphi         = nphi;
        Re.nchi         = nchi;
        Re.ntheta2d     = ntheta2d;
        Re.teps         = teps;
        Re.Pro          = Pro;
        Re.planeSph     = planeSph;
        Re.planeAng     = planeAng;
        Re.planeC       = planeC;
        Re.planeS       = planeS;
        Re.KIC          = KIC;
        Re.avgout       = avgout;
    else
        msgbox({'A suitable crystal system should be selected first, or a 6 * 6 elastic constant symmetric matrix should be provided.','Please supplement and try again.'}, 'VELAS reminder','error');
    end
end