function saveConfigUI()

global VELAS

C = get(VELAS.CS,'String');
if ~isempty(C)
    % Output filename

    fileN          = get(VELAS.Cfname,'String');
    if ~isempty(fileN)
        [~,tname,~]     = fileparts(fileN);
        defaultName     = strcat(tname,'.txt');
    else
        defaultName     =  strcat('VELAS',strrep(datestr(now,'yyyymmddHH:MM:SS'),':',''),'.txt');
    end

    [filen, pathn] = uiputfile({'*.txt'},'Select file to save',defaultName);
    if isequal(filen,0) || isequal(pathn,0)
        errordlg('No file selected.','VELAS reminder');
    else
        VELAS.saveflag = true;
        filename       = strcat(pathn,filen);
        fid            = fopen(filename,'wt');

        fprintf(fid,'%s\r','');
        fprintf(fid,'%s\r','# VELAS ver. 1.0.0');
        fprintf(fid,'%s\r',['# Create time:',char(32),datestr(now())]);
        fprintf(fid,'%s\r','');

        %% elastic constant matrix
        fprintf(fid,'%s\r','# Elements of stiffness matrix C, non-zero elements or all elements');
        fprintf(fid,'%s\r','Cfull');
        C = str2numb(C);
        fprintf(fid,[repmat('%5.2f ', 1, size(C,2)), '\n'], C');
        fprintf(fid,'%s\r','');

        % Structure under Pressure (GPa)
        fprintf(fid,'%s\r','# External isostatic pressure of crystal (GPa), default:0.00 GPa');
        pressure = str2num(get(VELAS.basepressure,'String'));
        if ~isempty(pressure)
            fprintf(fid,'%s %5.2f\r','pressure', pressure);
        else
            fprintf(fid,'%s\r','pressure 0.00');
        end
        fprintf(fid,'%s\r','');

        % 3D mesh number of [θ, φ, χ]
        fprintf(fid,'%s\r','# 3D mesh number of theta(θ), phi(φ), chi (χ)');
        nmesh3d = get(VELAS.basenmesh3d,'String');
        if ~isempty(nmesh3d)
            tnmesh3d = str2num(nmesh3d);
            len      = length(tnmesh3d);
            switch(len)
                case 1
                    fprintf(fid,'%s %5.2f %5.2f %5.2f\n', 'nmesh3d', repmat(tnmesh3d,1,3));
                case 2
                    fprintf(fid,'%s %5.2f %5.2f %5.2f\n', 'nmesh3d', [tnmesh3d,tnmesh3d(2)]);
                case 3
                    fprintf(fid,'%s %5.2f %5.2f %5.2f\n', 'nmesh3d', tnmesh3d);
            end
        else
            fprintf(fid,'%s\n', 'nmesh3d 200.00 400.00 360.00');
        end
        fprintf(fid,'%s\r','');

        % '2D mesh number of [θ]
        fprintf(fid,'%s\r','# 2D mesh number of theta(θ)');
        nmesh2d = get(VELAS.basenmesh2d,'String');
        if ~isempty(nmesh2d)
            tnmesh2d = str2num(nmesh2d);
            fprintf(fid,'%s %5.2f\n', 'nmesh2d', tnmesh2d);
        else
            fprintf(fid,'%s\n', 'nmesh2d 400');
        end
        fprintf(fid,'%s\r','');

        % Precision control, teps.
        fprintf(fid,'%s\r','# Precision control, Less than teps will be considered equal to 0');
        teps = get(VELAS.baseteps,'String');
        if ~isempty(teps)
            teps = str2num(teps);
            fprintf(fid,'%s %5.1e\n', 'teps', teps);
        else
            fprintf(fid,'%s\n', 'teps 1e-6');
        end
        fprintf(fid,'%s\r','');

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
        fprintf(fid,'%s\r','# properties — Pro(2*8)');
        fprintf(fid,'%s\r','#               Young   Compressibility  Shear   Poisson   Bulk   Pugh ratio     Hardness     Fracture Toughness');
        fprintf(fid,'%s\r','#    3D mode:    1/0         1/0          1/0      1/0      1/0      1/0          1/0              1/0');
        fprintf(fid,'%s\r','#    2D mode:    1/0         1/0          1/0      1/0      1/0      1/0          1/0              1/0');
        fprintf(fid,'%s\r','properties');

        basepop = get(VELAS.basepop,'Value');
        % {'3D','2D','Both'}
        proE      = get(VELAS.proYoung,'Value');   % Young (GPa)
        proLC     = get(VELAS.proLC,'Value');      % Linear Compressibility (TPa^-1)
        proG      = get(VELAS.proShear,'Value');   % Shear (GPa)
        proP      = get(VELAS.proPoisson,'Value'); % Poisson's Ratio
        proB      = get(VELAS.proBulk,'Value');    % Bulk (GPa)
        proPr     = get(VELAS.proPugh,'Value');    % Pugh Ratio

        Hvflag    = get(VELAS.proHv,'Value');      % Vickers Hardness (GPa)
        if Hvflag ~= 1
            proHv   = 1;
        else
            proHv   = 0;
        end

        KICtype   = get(VELAS.proKICtppop,'Value'); % Fracture Toughness (KIC, MPa*m^(1/2))
        KICmode   = get(VELAS.proKICmdpop,'Value');
        if KICtype ~= 1 && KICmode ~= 1
            proKIC   = 1;
        else
            proKIC   = 0;
        end
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

        fprintf(fid,[repmat('%1.0f ', 1, size(Pro,2)), '\n'], logical(Pro)');
        fprintf(fid,'%s\r','');
        
        %% Materials Project API
        fprintf(fid,'%s\r','# Offline mode or Online mode to call Materials Project, the value is "no" (default)/"yes"');
        fprintf(fid,'%s\r','# Note: In offline mode, it''s no need to provide x-api-key, both MPID and Pretty Formula are supported; ');
        fprintf(fid,'%s\r','# In online mode, x-api-key must be provided, and only MPID query is supported');
        valoln = get(VELAS.mponline,'Value');
        switch(valoln)
            case 0
                fprintf(fid,'%s\r','mponline no');
            case 1
                fprintf(fid,'%s\r','mponline yes');
        end
        fprintf(fid,'%s\r','');

        fprintf(fid,'%s\r','# The Material ID for Materials Project, the value is "none"/"mp-xxxx"/"mvc-xxxx", such as "mp-7631","mvc-6281",and "none" (default).');
        mpidstr = get(VELAS.mpmid,'String');
        if ~isempty(mpidstr)
            fprintf(fid,'%s\r',['mpid ',get(VELAS.mpmid,'String')]);
        else
            fprintf(fid,'%s\r','mpid none');
        end
        fprintf(fid,'%s\r','');

        fprintf(fid,'%s\r','# The X-Api-Key for Materials ProjectVelas provides offline mode and online mode to call API, the value is "none" or your personal access api.');
        xapikeystr = get(VELAS.mpapikey,'String');
        if ~isempty(xapikeystr)
            fprintf(fid,'%s\r',['xapikey ',get(VELAS.mpapikey,'String')]);
        else
            fprintf(fid,'%s\r','xapikey none');
        end
        fprintf(fid,'%s\r','');

        fprintf(fid,'%s\r','# Indicating which version of API to use, [New]: next-gen.materialsproject.org. [Legacy]: materialsproject.org');
        fprintf(fid,'%s\r','# "new" refers to new version api (default), "old"/"legacy" refers to legacy version api');
        verval = get(VELAS.mpapiver,'Value');
        switch(verval)
            case 0
                fprintf(fid,'%s\r','mpapiver new');
            case 1
                fprintf(fid,'%s\r','mpapiver old');
        end
        fprintf(fid,'%s\r','');

        % Output model of Vickers Hardness
        % {'none','Mazhnik''s model','Chen''s model','Tian''s model'}
        switch(Hvflag)
            case 2
                fprintf(fid,'%s\r', '# The model of Vickers hardness, Hv M for Mazhnik''s model, Hv C for Chen''s model, Hv T for Tian''s model');
                fprintf(fid,'%s\r', 'Hv M');
                fprintf(fid,'%s\r','');
            case 3
                fprintf(fid,'%s\r', '# The model of Vickers hardness, Hv M for Mazhnik''s model, Hv C for Chen''s model, Hv T for Tian''s model');
                fprintf(fid,'%s\r', 'Hv C');
                fprintf(fid,'%s\r','');
            case 4
                fprintf(fid,'%s\r', '# The model of Vickers hardness, Hv M for Mazhnik''s model, Hv C for Chen''s model, Hv T for Tian''s model');
                fprintf(fid,'%s\r', 'Hv T');
                fprintf(fid,'%s\r','');
        end
        
        % Output model of Fracture Toughness (KIC, MPa*m^(1/2))
        KICtype   = get(VELAS.proKICtppop,'Value');  % Materials type
        KICmode   = get(VELAS.proKICmdpop,'Value');  % Model
        if KICtype ~= 1 && KICmode ~= 1
            fprintf(fid,'%s\r', '# The model and input parameters  of fracture toughness, Kic-Model-materials: Model -> M (Mazhnik''s model)/ N (Niu''s model), materials -> IC(ionic or covalent) / PM (pure metals) / IM (intermetallics)');
            fprintf(fid,'%s\r', '# Input parameters of fracture toughness, the order: V0 gEFr m n XA XB');
            kicStr  = 'KIC ';

            switch(KICmode)
                % {'none','Niu''s model','Mazhnik''s model'}
                case 2
                    kicStr = [kicStr,'N '];
                case 3
                    kicStr = [kicStr,'M '];
            end
            % Materials type
            switch(KICtype)
                % {'none','Ionic/Covalent','Pure metal','Intermetallic'}
                case 2
                    kicStr = [kicStr,'IC'];
                case 3
                    kicStr = [kicStr,'PM'];
                case 4
                    kicStr = [kicStr,'IM'];
            end
            KIC = zeros(1,6);
            % Parameters
            V0 = get(VELAS.proKICV0,'String');
            if ~isempty(V0)
                KIC(1,1) = str2num(V0);
            end

            gEFr = get(VELAS.proKICgEFr,'String');
            if ~isempty(gEFr)
                KIC(1,2) = str2num(gEFr);
            end

            m = get(VELAS.proKICm,'String');
            if ~isempty(m)
                KIC(1,3) = str2num(m);
            end

            n = get(VELAS.proKICn,'String');
            if ~isempty(n)
                KIC(1,4) = str2num(n);
            end

            XA = get(VELAS.proKICXA,'String');
            if ~isempty(XA)
                KIC(1,5) = str2num(XA);
            end

            XB = get(VELAS.proKICXB,'String');
            if ~isempty(XB)
                KIC(1,6) = str2num(XB);
            end
            fprintf(fid,'%s %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f\n', kicStr, KIC);
            fprintf(fid,'%s\r','');
        end

        % Do you want to output the average value? (default: No)
        fprintf(fid,'%s\r', '# Do you want to output the average value？ (avgyes or avgno), default: avgno.');
        avgOut = get(VELAS.proAvg,'Value');
        if avgOut
            fprintf(fid,'%s\r','avg yes');
        else
            fprintf(fid,'%s\r','avg no');
        end
        fprintf(fid,'%s\r','');

        % Colormap
        fprintf(fid,'%s\r', '# Colormap: ''jet'',''turbo'',''rainbow'',''hot'',''parula'',''ocean'',''hsv'',''cool'',''spring'',''summer'',''autumn'',''winter'',''gray'',''bone'',''copper'',''pink'',''viridis'',''cubehelix''');
        cmapstr   = get(VELAS.cmappop,'String');
        cmap      = cmapstr{get(VELAS.cmappop,'Value')};
        fprintf(fid,'%s\r',['camp ',cmap]);
        fprintf(fid,'%s\r','');

        % Plotting 3D Unit Spherical
        fprintf(fid,'%s\r','# 3D Unit Spherical or not? (unitsph yes or unitsph no), default: No');
        dounitsph = get(VELAS.p3dUSph,'Value'); % true or false
        if dounitsph
            fprintf(fid,'%s\r','unitsph yes');
        else
            fprintf(fid,'%s\r','unitsph no');
        end
        fprintf(fid,'%s\r','');

        % map projection
        domap     = get(VELAS.p2dMPro,'Value'); % true or false
        fprintf(fid,'%s\r','# Map Projection or not? (default: Yes) % {''Gall-Peters'' (GP),''Robinson'' (R),''Hammer-Aitoff'' (HA),''Mollweide'' (M)};');

        mpval    = get(VELAS.p2dMMod,'Value'); % flag = {'Gall-Peters','Robinson','Hammer-Aitoff','Mollweide'};
        switch(mpval)
            case 1
                mapstr = 'GP';
            case 2
                mapstr = 'R';
            case 3
                mapstr = 'HA';
            case 4
                mapstr = 'M';
        end
        if domap
            fprintf(fid,'%s\r',['map yes ', mapstr]);
        else
            fprintf(fid,'%s\r',['map no ', mapstr]);
        end
        fprintf(fid,'%s\r','');

        fprintf(fid,'%s\r','# line style');
        lstylVal  = get(VELAS.p2dLStl,'Value');
        switch(lstylVal)
            case 1
                lineStyle = '--';
            case 2
                lineStyle = ':';
            case 3
                lineStyle = '-.';
            case 4
                lineStyle = '-';
        end
        fprintf(fid,'%s\r',['lstyle ',lineStyle]);
        fprintf(fid,'%s\r','');

        % print & dpi
        fprintf(fid,'%s\r','# print or not? (print yes or print no), default: No');
        doprint = get(VELAS.doprint,'Value');  % true or false
        if doprint
            fprintf(fid,'%s\r','print yes');
        else
            fprintf(fid,'%s\r','print no');
        end
        fprintf(fid,'%s\r','');

        fprintf(fid,'%s\r','# dpi');
        if ~isempty(get(VELAS.dpi,'String'))
            dpi = get(VELAS.dpi,'String');    % Resolution, this value is not the real DPI, just control the size of pic.
        else
            dpi = num2str(600);
        end
        fprintf(fid,'%s\r',['dpi ',dpi]);
        fprintf(fid,'%s\r','');

        % Plane for 2D Calculation
        plane = get(VELAS.baseplane,'String');
        if ~isempty(plane)
            fprintf(fid,'%s\r', '# Plane to be calculated');
            planeSph = get(VELAS.baseplaneSph,'Value');
            if planeSph
                planeRad = get(VELAS.baseplaneRad,'Value');
                if planeRad
                    fprintf(fid,'%s\r','planeSPH_rad');
                    plane = str2numb(plane);
                    fprintf(fid,[repmat('%5.4f ', 1, size(plane,2)), '\n'], plane');
                else
                    fprintf(fid,'%s\r','planeSPH_ang');
                    plane = str2numb(plane);
                    fprintf(fid,[repmat('%5.2f ', 1, size(plane,2)), '\n'], plane');
                end
            else
                fprintf(fid,'%s\r','planeXY');
                plane = str2numb(plane);
                fprintf(fid,[repmat('%5.2f ', 1, size(plane,2)), '\n'], plane');
            end
        end
        fclose(fid);
        hmsg = msgbox('Save completed!', 'VELAS reminder','help');
        pause(0.8);
        if ishandle(hmsg)
            close(hmsg);
        end

    end
else
    if ~isempty(get(VELAS.mpmid,'String')) && ~isempty(get(VELAS.mpapikey,'String'))
        % Output filename
        fileN = get(VELAS.Cfname,'String');
        if ~isempty(fileN)
            [~,tname,~]     = fileparts(fileN);
            defaultName     = strcat(tname,'.txt');
        else
            defaultName     =  strcat('VELAS',strrep(datestr(now,'yyyymmddHH:MM:SS'),':',''),'.txt');
        end

        [filen, pathn] = uiputfile({'*.txt'},'Select file to save',defaultName);
        if isequal(filen,0) || isequal(pathn,0)
            errordlg('No file selected.','VELAS reminder');
        else
            VELAS.saveflag = true;
            filename       = strcat(pathn,filen);
            fid            = fopen(filename,'wt');

            fprintf(fid,'%s\r','');
            fprintf(fid,'%s\r','# VELAS ver. 1.0.0');
            fprintf(fid,'%s\r',['# Create time:',char(32),datestr(now())]);
            fprintf(fid,'%s\r','');

            %% Materials Project API
            fprintf(fid,'%s\r','# Offline mode or Online mode to call Materials Project, the value is "no" (default)/"yes"');
            fprintf(fid,'%s\r','# Note: In offline mode, it''s no need to provide x-api-key, both MPID and Pretty Formula are supported; ');
            fprintf(fid,'%s\r','# In online mode, x-api-key must be provided, and only MPID query is supported');
            valoln = get(VELAS.mponline,'Value');
            switch(valoln)
                case 0
                    fprintf(fid,'%s\r','mponline no');
                case 1
                    fprintf(fid,'%s\r','mponline yes');
            end
            fprintf(fid,'%s\r','');

            fprintf(fid,'%s\r','# The Material ID for Materials Project, the value is "none"/"mp-xxxx"/"mvc-xxxx", such as "mp-7631","mvc-6281",and "none" (default).');
            fprintf(fid,'%s\r',['mpid ',get(VELAS.mpmid,'String')]);
            fprintf(fid,'%s\r','');

            fprintf(fid,'%s\r','# The X-Api-Key for Materials ProjectVelas provides offline mode and online mode to call API, the value is "none" or your personal access api.');
            fprintf(fid,'%s\r',['xapikey ',get(VELAS.mpapikey,'String')]);
            fprintf(fid,'%s\r','');

            fprintf(fid,'%s\r','# Indicating which version of API to use, [New]: next-gen.materialsproject.org. [Legacy]: materialsproject.org');
            fprintf(fid,'%s\r','# "new" refers to new version api (default), "old"/"legacy" refers to legacy version api');
            verval = get(VELAS.mpapiver,'Value');
            switch(verval)
                case 0
                    fprintf(fid,'%s\r','mpapiver new');
                case 1
                    fprintf(fid,'%s\r','mpapiver old');
            end
            fprintf(fid,'%s\r','');

            % Structure under Pressure (GPa)
            fprintf(fid,'%s\r','# External isostatic pressure of crystal (GPa), default:0.00 GPa');
            pressure = str2num(get(VELAS.basepressure,'String'));
            if ~isempty(pressure)
                fprintf(fid,'%s %5.2f\r','pressure', pressure);
            else
                fprintf(fid,'%s\r','pressure 0.00');
            end
            fprintf(fid,'%s\r','');

            % 3D mesh number of [θ, φ, χ]
            fprintf(fid,'%s\r','# 3D mesh number of theta(θ), phi(φ), chi (χ)');
            nmesh3d = get(VELAS.basenmesh3d,'String');
            if ~isempty(nmesh3d)
                tnmesh3d = str2num(nmesh3d);
                len      = length(tnmesh3d);
                switch(len)
                    case 1
                        fprintf(fid,'%s %5.2f %5.2f %5.2f\n', 'nmesh3d', repmat(tnmesh3d,1,3));
                    case 2
                        fprintf(fid,'%s %5.2f %5.2f %5.2f\n', 'nmesh3d', [tnmesh3d,tnmesh3d(2)]);
                    case 3
                        fprintf(fid,'%s %5.2f %5.2f %5.2f\n', 'nmesh3d', tnmesh3d);
                end
            else
                fprintf(fid,'%s\n', 'nmesh3d 200.00 400.00 360.00');
            end
            fprintf(fid,'%s\r','');

            % '2D mesh number of [θ]
            fprintf(fid,'%s\r','# 2D mesh number of theta(θ)');
            nmesh2d = get(VELAS.basenmesh2d,'String');
            if ~isempty(nmesh2d)
                tnmesh2d = str2num(nmesh2d);
                fprintf(fid,'%s %5.2f\n', 'nmesh2d', tnmesh2d);
            else
                fprintf(fid,'%s\n', 'nmesh2d 400');
            end
            fprintf(fid,'%s\r','');

            % Precision control, teps.
            fprintf(fid,'%s\r','# Precision control, Less than teps will be considered equal to 0');
            teps = get(VELAS.baseteps,'String');
            if ~isempty(teps)
                teps = str2num(teps);
                fprintf(fid,'%s %5.1e\n', 'teps', teps);
            else
                fprintf(fid,'%s\n', 'teps 1e-6');
            end
            fprintf(fid,'%s\r','');

            %% Properties
            %{
                properties — Pro(2*8)

                        Young   Compressibility  Shear   Poisson  Bulk    Pugh Ratio   Hardness   Fracture Toughness
            3D mode:     1            1           1       1        1         1            1              1
            2D mode:     1            1           1       1        1         1            1              1

            Young3D             — Pro(1,1),  Young2D             — Pro(2,1);
            Compressibility3D   — Pro(1,2),  Compressibility2D   — Pro(2,2);
            Shear3D             — Pro(1,3),  Shear2D             — Pro(2,3);
            Poisson3D           — Pro(1,4),  Poisson2D           — Pro(2,4);
            Bulk3D              — Pro(1,5),  Bulk2D              — Pro(2,5);
            PughRatio3D         — Pro(1,6),  PughRatio2D         — Pro(2,6),
            Hardness3D          — Pro(1,7),  Hardness2D          — Pro(2,7);
            FractureToughness3D — Pro(1,8),  FractureToughness3D — Pro(2,8);
            %}
            fprintf(fid,'%s\r','# properties — Pro(2*8)');
            fprintf(fid,'%s\r','#               Young   Compressibility  Shear   Poisson   Bulk   Pugh ratio     Hardness     Fracture Toughness');
            fprintf(fid,'%s\r','#    3D mode:     1            1           1       1        1         1              1                1');
            fprintf(fid,'%s\r','#    2D mode:     1            1           1       1        1         1              1                1');
            fprintf(fid,'%s\r','properties');

            basepop = get(VELAS.basepop,'Value');
            % {'3D','2D','Both'}
            proE      = get(VELAS.proYoung,'Value');   % Young (GPa)
            proLC     = get(VELAS.proLC,'Value');      % Linear Compressibility (TPa^-1)
            proG      = get(VELAS.proShear,'Value');   % Shear (GPa)
            proP      = get(VELAS.proPoisson,'Value'); % Poisson's Ratio
            proB      = get(VELAS.proBulk,'Value');    % Bulk (GPa)
            proPr     = get(VELAS.proPugh,'Value');    % Pugh Ratio

            Hvflag    = get(VELAS.proHv,'Value');      % Vickers Hardness (GPa)
            if Hvflag ~= 1
                proHv   = 1;
            else
                proHv   = 0;
            end

            KICtype   = get(VELAS.proKICtppop,'Value'); % Fracture Toughness (KIC, MPa*m^(1/2))
            KICmode   = get(VELAS.proKICmdpop,'Value');
            if KICtype ~= 1 && KICmode ~= 1
                proKIC   = 1;
            else
                proKIC   = 0;
            end
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

            fprintf(fid,[repmat('%1.0f ', 1, size(Pro,2)), '\n'], logical(Pro)');
            fprintf(fid,'%s\r','');

            % Output model of Vickers Hardness
            % {'none','Mazhnik''s model','Chen''s model','Tian''s model'}
            switch(Hvflag)
                case 2
                    fprintf(fid,'%s\r', '# The model of Vickers hardness, Hv M for Mazhnik''s model, Hv C for Chen''s model, Hv T for Tian''s model');
                    fprintf(fid,'%s\r', 'Hv M');
                case 3
                    fprintf(fid,'%s\r', '# The model of Vickers hardness, Hv M for Mazhnik''s model, Hv C for Chen''s model, Hv T for Tian''s model');
                    fprintf(fid,'%s\r', 'Hv C');
                case 4
                    fprintf(fid,'%s\r', '# The model of Vickers hardness, Hv M for Mazhnik''s model, Hv C for Chen''s model, Hv T for Tian''s model');
                    fprintf(fid,'%s\r', 'Hv T');
            end
            fprintf(fid,'%s\r','');

            % Output model of Fracture Toughness (KIC, MPa*m^(1/2))
            KICtype   = get(VELAS.proKICtppop,'Value');  % Materials type
            KICmode   = get(VELAS.proKICmdpop,'Value');  % Model
            if KICtype ~= 1 && KICmode ~= 1
                fprintf(fid,'%s\r', '# The model and input parameters  of fracture toughness, Kic-Model-materials: Model -> M (Mazhnik''s model)/ N (Niu''s model), materials -> IC(ionic or covalent) / PM (pure metals) / IM (intermetallics)');
                fprintf(fid,'%s\r', '# Input parameters of fracture toughness, the order: V0 gEFr m n XA XB');
                kicStr  = 'KIC ';

                switch(KICmode)
                    % {'none','Niu''s model','Mazhnik''s model'}
                    case 2
                        kicStr = [kicStr,'N '];
                    case 3
                        kicStr = [kicStr,'M '];
                end
                % Materials type
                switch(KICtype)
                    % {'none','Ionic/Covalent','Pure metal','Intermetallic'}
                    case 2
                        kicStr = [kicStr,'IC'];
                    case 3
                        kicStr = [kicStr,'PM'];
                    case 4
                        kicStr = [kicStr,'IM'];
                end
                KIC = zeros(1,6);
                % Parameters
                V0 = get(VELAS.proKICV0,'String');
                if ~isempty(V0)
                    KIC(1,1) = str2num(V0);
                end

                gEFr = get(VELAS.proKICgEFr,'String');
                if ~isempty(gEFr)
                    KIC(1,2) = str2num(gEFr);
                end

                m = get(VELAS.proKICm,'String');
                if ~isempty(m)
                    KIC(1,3) = str2num(m);
                end

                n = get(VELAS.proKICn,'String');
                if ~isempty(n)
                    KIC(1,4) = str2num(n);
                end

                XA = get(VELAS.proKICXA,'String');
                if ~isempty(XA)
                    KIC(1,5) = str2num(XA);
                end

                XB = get(VELAS.proKICXB,'String');
                if ~isempty(XB)
                    KIC(1,6) = str2num(XB);
                end
                fprintf(fid,'%s %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f\n', kicStr, KIC);
                fprintf(fid,'%s\r','');
            end

            % Do you want to output the average value? (default: No)
            fprintf(fid,'%s\r', '# Do you want to output the average value？ (avgyes or avgno), default: avgno.');
            avgOut = get(VELAS.proAvg,'Value');
            if avgOut
                fprintf(fid,'%s\r','avg yes');
            else
                fprintf(fid,'%s\r','avg no');
            end
            fprintf(fid,'%s\r','');

            % Colormap
            fprintf(fid,'%s\r', '# Colormap: ''jet'',''turbo'',''rainbow'',''hot'',''parula'',''ocean'',''hsv'',''cool'',''spring'',''summer'',''autumn'',''winter'',''gray'',''bone'',''copper'',''pink'',''viridis'',''cubehelix''');
            cmapstr   = get(VELAS.cmappop,'String');
            cmap      = cmapstr{get(VELAS.cmappop,'Value')};
            fprintf(fid,'%s\r',['camp ',cmap]);
            fprintf(fid,'%s\r','');

            % Plotting 3D Unit Spherical
            fprintf(fid,'%s\r','# 3D Unit Spherical or not? (unitsph yes or unitsph no), default: No');
            dounitsph = get(VELAS.p3dUSph,'Value'); % true or false
            if dounitsph
                fprintf(fid,'%s\r','unitsph yes');
            else
                fprintf(fid,'%s\r','unitsph no');
            end
            fprintf(fid,'%s\r','');

            % map projection
            domap     = get(VELAS.p2dMPro,'Value'); % true or false
            fprintf(fid,'%s\r','# Map Projection or not? (default: Yes) % {''Gall-Peters'' (GP),''Robinson'' (R),''Hammer-Aitoff'' (HA),''Mollweide'' (M)};');

            mpval    = get(VELAS.p2dMMod,'Value'); % flag = {'Gall-Peters','Robinson','Hammer-Aitoff','Mollweide'};
            switch(mpval)
                case 1
                    mapstr = 'GP';
                case 2
                    mapstr = 'R';
                case 3
                    mapstr = 'HA';
                case 4
                    mapstr = 'M';
            end
            if domap
                fprintf(fid,'%s\r',['map yes ', mapstr]);
            else
                fprintf(fid,'%s\r',['map no ', mapstr]);
            end
            fprintf(fid,'%s\r','');

            fprintf(fid,'%s\r','# line style');
            lstylVal  = get(VELAS.p2dLStl,'Value');
            switch(lstylVal)
                case 1
                    lineStyle = '--';
                case 2
                    lineStyle = ':';
                case 3
                    lineStyle = '-.';
                case 4
                    lineStyle = '-';
            end
            fprintf(fid,'%s\r',['lstyle ',lineStyle]);
            fprintf(fid,'%s\r','');

            % print & dpi
            fprintf(fid,'%s\r','# print or not? (print yes or print no), default: No');
            doprint = get(VELAS.doprint,'Value');  % true or false
            if doprint
                fprintf(fid,'%s\r','print yes');
            else
                fprintf(fid,'%s\r','print no');
            end
            fprintf(fid,'%s\r','');

            fprintf(fid,'%s\r','# dpi');
            if ~isempty(get(VELAS.dpi,'String'))
                dpi = get(VELAS.dpi,'String');    % Resolution, this value is not the real DPI, just control the size of pic.
            else
                dpi = num2str(600);
            end
            fprintf(fid,'%s\r',['dpi ',dpi]);
            fprintf(fid,'%s\r','');

            % Plane for 2D Calculation
            plane = get(VELAS.baseplane,'String');
            if ~isempty(plane)
                planeSph = get(VELAS.baseplaneSph,'Value');
                if planeSph
                    fprintf(fid,'%s\r', '# Plane to be calculated [spherical coordinates]');
                    planeRad = get(VELAS.baseplaneRad,'Value');
                    if planeRad
                        fprintf(fid,'%s\r','planeSPH rad');
                        plane = str2numb(plane);
                        fprintf(fid,[repmat('%5.4f ', 1, size(plane,2)), '\n'], plane');
                    else
                        fprintf(fid,'%s\r','planeSPH ang');
                        plane = str2numb(plane);
                        fprintf(fid,[repmat('%5.2f ', 1, size(plane,2)), '\n'], plane');
                    end
                else
                    fprintf(fid,'%s\r', '# Plane to be calculated [XYZ coordinates]');
                    fprintf(fid,'%s\r','planeXY');
                    plane = str2numb(plane);
                    fprintf(fid,[repmat('%5.2f ', 1, size(plane,2)), '\n'], plane');
                end
            end
            fclose(fid);
            hmsg = msgbox('Save completed!', 'VELAS reminder','help');
            pause(0.8);
            if ishandle(hmsg)
                close(hmsg);
            end
        end
    else
        msgbox({'The elastic constant matrix and [mpid&x-api-key] cannot both be empty at the same time.','Please supplement and try again.'}, 'VELAS reminder','error');
    end
end
