function Re = getInput(filename)

%{
  ========================== Processing input file ========================
    Input parameter:
                      filename, the input file name that contains the file path.
    Out parameter:
                      Re, return all the input parameters in the input file.
%}

C   = zeros(6,6);
     
fid = fopen(filename,'r+');

% For full Stifness matrix C
Cflag    = false;
Sflag    = false;
ck       = 0;
lne1  = 0; lne2  = 0; lne3 = 0; lne4 = 0; lne5 = 0; lne6 = 0;
cryType  = 'none';

% For structure under pressure
pressure     = 0;     % default:0 GPa

% mesh number of theta(θ) (default:200), phi(φ) (default:400), chi (χ) (default:400)
ntheta       = 200;
nphi         = 400;
nchi         = 400;

% mesh number of theta in 2D Plane, (default:400)
ntheta2d     = 400;

% Precision control, Less than teps will be considered equal to 0
teps         = 1e-8;

% Materials Project
Re.mponline = 'no';
Re.mpid     = 'none';
Re.xapikey  = 'none';
Re.mpapiver = 'new';

% For properties
%{
                properties — Pro(2*8)
    
                        Young   Compressibility  Shear   Poisson  Bulk    Pugh Ratio   Hardness   Fracture Toughness
            3D mode:    1/0         1/0          1/0      1/0      1/0      1/0          1/0              1/0
            2D mode:    1/0         1/0          1/0      1/0      1/0      1/0          1/0              1/0
            
            1: to be calculated, 0: not to be calculated.

            Young3D             — Pro(1,1),  Young2D             — Pro(2,1);
            Compressibility3D   — Pro(1,2),  Compressibility2D   — Pro(2,2);
            Shear3D             — Pro(1,3),  Shear2D             — Pro(2,3);
            Poisson3D           — Pro(1,4),  Poisson2D           — Pro(2,4);
            Bulk3D              — Pro(1,5),  Bulk2D              — Pro(2,5);
            PughRatio3D         — Pro(1,6),  PughRatio2D         — Pro(2,6),
            Hardness3D          — Pro(1,7),  Hardness2D          — Pro(2,7);
            FractureToughness3D — Pro(1,8),  FractureToughness3D — Pro(2,8);
%}

Pro          = [1 1 1 1 1 0 0 0;1 1 1 1 1 0 0 0];
Pflag        = false;
pk           = 0;
plne1 = 0; plne2 = 0;

% For Vickers hardness
Re.HvModel = '';

% For fracture toughness

KIC.model    = '';
KIC.material = '';
KIC.V0       = 0.0;
KIC.gEFr     = 0.0;
KIC.m        = 0.0;
KIC.n        = 0.0;
KIC.XA       = 0.0;
KIC.XB       = 0.0;

% Do you want to output the average value  (yes or no), default: No.
avgout       = false;

% 3D Unit Spherical
dounitsph    = false;

% Map Projection
domap        = false;
cmap         = 'jet';
mpmode       = 'Mollweide'; % 'Gall-Peters' (GP),'Robinson' (R),'Hammer-Aitoff' (HA),'Mollweide' (M)
lineStyle    = '--';

% print
doprint      = false;
dpi          = num2str(600);

% For plane
planeC        = [];
planeS        = [];
plk           = 0;
planeXYflag   = false;  % Plane in Cartesian coordinate system
planeSphflag  = false;  % Plane in spherical coordinate system
planeSph      = false;
planeAng      = false;

k = 0;
while true
    tline = fgetl(fid);
    if ischar(tline)

        % Check the comments section
        tline  = strtrim(tline);     % remove leading and trailing whitespace
        locpen = find(tline == '#'); % find the location of #
        if ~isempty(locpen)         
            if locpen ~= 1           
                tline = strtrim(tline(1:locpen-1));
            end
        end
        
        % main code
        if ~isempty(strfind(tline,'#')) || isempty(tline)
            continue;
        else
            if ~isempty(strfind(lower(tline),'planexy'))
                planeXYflag = true;
                lne         = k + 1;
            elseif ~isempty(strfind(lower(tline),'planesph '))
                planeSphflag = true;
                planeSph     = true;
                if ~isempty(strfind(lower(tline),'ang')) || ~isempty(strfind(lower(tline),'angle'))
                    planeAng = true;
                end
                lne          = k + 1;
            elseif ~isempty(strfind(lower(tline),'cubi '))
                cubi    = regexp(tline,'\ ','split');
                dataL   = cellfun(@str2num,cubi(2:end));
                cryType = 'Cubic';
                % Cubic: 3 independent elastic constants: C11, C44, C12;
                C(1,1) = dataL(1);
                C(1,2) = dataL(3);
                C(4,4) = dataL(2);
                C(2,2)=C(1,1);
                C(3,3)=C(1,1);
                C(5,5)=C(4,4);
                C(6,6)=C(4,4);
                C(1,3)=C(1,2);
                C(2,3)=C(1,2);
                % Constructing symmetric matrix
                C = C+triu(C,1)';
            elseif ~isempty(strfind(lower(tline),'hexa '))
                cubi    = regexp(tline,'\ ','split');
                cryType = 'Hexagonal'; 
                dataL = cellfun(@str2num,cubi(2:end));
                % Hexagonal: 5 independent elastic constants: C11, C33, C44, C12, C13
                C(1,1) = dataL(1);
                C(1,2) = dataL(4);
                C(1,3) = dataL(5);
                C(3,3) = dataL(2);
                C(4,4) = dataL(3);
                C(5,5) = C(4,4);
                C(6,6) = (C(1,1)-C(1,2))/2;
                C(2,2) = C(1,1);
                C(2,3) = C(1,3);
                % Constructing symmetric matrix
                C = C + triu(C,1)';
            elseif ~isempty(strfind(lower(tline),'tetr '))
                cubi  = regexp(tline,'\ ','split');
                dataL = cellfun(@str2num,cubi(2:end));
                
                cryType = 'Tetragonal'; 
                % Tetragonal: tpye1: 6 independent elastic constants: C11, C33, C44, C66, C12, C13
                % Tetragonal: tpye2: 7 independent elastic constants: C11, C33, C44, C66, C12, C13, C16
                len = length(dataL);
                switch(len)
                    case 6
                        C(1,1) = dataL(1);
                        C(3,3) = dataL(2);
                        C(4,4) = dataL(3);
                        C(6,6) = dataL(4);
                        C(1,2) = dataL(5);
                        C(1,3) = dataL(6);
                        C(2,2) = C(1,1);
                        C(2,3) = C(1,3);
                        C(5,5) = C(4,4);
                    case 7
                        C(1,1) = dataL(1);
                        C(3,3) = dataL(2);
                        C(4,4) = dataL(3);
                        C(6,6) = dataL(4);
                        C(1,2) = dataL(5);
                        C(1,3) = dataL(6);
                        C(1,6) = dataL(7);
                        C(2,2) = C(1,1);
                        C(2,3) = C(1,3);
                        C(3,2) = C(1,3);
                        C(5,5) = C(4,4);
                        C(2,6) = -C(1,6);
                end
                % Constructing symmetric matrix
                C = C + triu(C,1)';

            elseif ~isempty(strfind(lower(tline),'trig '))
                cubi  = regexp(tline,'\ ','split');
                dataL = cellfun(@str2num,cubi(2:end));
                
                cryType = 'Trigonal';
                % Trigonal: type1: 6 independent elastic constants: C11, C33, C44, C12, C13, C14
                % Trigonal: type2: 7 independent elastic constants: C11, C33, C44, C12, C13, C14, C15
                len = length(dataL);
                switch(len)
                    case 6
                        C(1,1) = dataL(1);
                        C(1,2) = dataL(4);
                        C(1,3) = dataL(5);
                        C(1,4) = dataL(6);
                        C(3,3) = dataL(2);
                        C(4,4) = dataL(3);
                        C(2,2) = C(1,1);
                        C(2,3) = C(1,3);
                        C(5,5) = C(4,4);
                        C(6,6) = (C(1,1)-C(1,2))/2;
                        C(2,4) = -C(1,4);
                        C(5,6) = C(1,4);
                    case 7
                        C(1,1) = dataL(1);
                        C(1,2) = dataL(4);
                        C(1,3) = dataL(5);
                        C(1,4) = dataL(6);
                        C(1,5) = dataL(7);
                        C(2,2) = C(1,1);
                        C(3,3) = dataL(2);
                        C(4,4) = dataL(3);
                        C(5,5) = C(4,4);
                        C(6,6) = (C(1,1)-C(1,2))./2;
                        C(2,3) = C(1,3);
                        C(2,4) = -C(1,4);
                        C(2,5) = -C(1,5);
                        C(4,6) = C(2,5);
                        C(5,6) = C(1,4);
                end
                % Constructing symmetric matrix
                C = C + triu(C,1)';

            elseif ~isempty(strfind(lower(tline),'orth '))
                cubi  = regexp(tline,'\ ','split');
                dataL = cellfun(@str2num,cubi(2:end));
                cryType = 'Orthorhombic';
                % Orthorhombic: 9 independent elastic constants: C11, C22, C33, C44, C55, C66, C12, C13, C23
                C(1,1) = dataL(1);
                C(1,2) = dataL(7);
                C(1,3) = dataL(8);
                C(2,2) = dataL(2);
                C(2,3) = dataL(9);
                C(3,3) = dataL(3);
                C(4,4) = dataL(4);
                C(5,5) = dataL(5);
                C(6,6) = dataL(6);
                % Constructing symmetric matrix
                C = C + triu(C,1)';

            elseif ~isempty(strfind(lower(tline),'mono '))
                cubi     = regexp(tline,'\ ','split');
                dataLt   = cellfun(@str2num,cubi(2:end));
                monoType = dataLt(1);   % 1 or 2
                dataL    = dataLt(2:end);
                cryType  = 'Monoclinic';
                %{
                    Monoclinic: type1: 13 independent elastic constants: C11, C22, C33, C44, C55, C66, C12, C13, C15, C23, C25, C35, C46
                    Monoclinic: type2: 13 independent elastic constants: C11, C22, C33, C44, C55, C66, C12, C13, C16, C23, C26, C36, C45
                %}
                switch(monoType)
                    case 1
                        C(1,1) = dataL(1);
                        C(2,2) = dataL(2);
                        C(3,3) = dataL(3);
                        C(4,4) = dataL(4);
                        C(5,5) = dataL(5);
                        C(6,6) = dataL(6);
                        C(1,2) = dataL(7);
                        C(1,3) = dataL(8);
                        C(1,5) = dataL(9);
                        C(2,3) = dataL(10);
                        C(2,5) = dataL(11);
                        C(3,5) = dataL(12);
                        C(4,6) = dataL(13);
                    case 2
                        C(1,1) = dataL(1);
                        C(2,2) = dataL(2);
                        C(3,3) = dataL(3);
                        C(4,4) = dataL(4);
                        C(5,5) = dataL(5);
                        C(6,6) = dataL(6);
                        C(1,2) = dataL(7);
                        C(1,3) = dataL(8);
                        C(1,6) = dataL(9);
                        C(2,3) = dataL(10);
                        C(2,6) = dataL(11);
                        C(3,6) = dataL(12);
                        C(4,5) = dataL(13);
                end
                % Constructing symmetric matrix
                C = C + triu(C,1)';

            elseif ~isempty(strfind(lower(tline),'tric '))
                cubi    = regexp(tline,'\ ','split');
                dataL   = cellfun(@str2num,cubi(2:end));
                cryType  = 'Triclinic';
                %{
                  Triclinic: 21 independent elastic constants: C11, C12, C13, C14, C15, C16,
                                                                    C22, C23, C24, C25, C26,
                                                                         C33, C34, C35, C36,
                                                                              C44, C45, C46,
                                                                                   C55, C56,
                                                                                        C66
                %}
                C(1,1) = dataL(1);
                C(1,2) = dataL(2);
                C(1,3) = dataL(3);
                C(1,4) = dataL(4);
                C(1,5) = dataL(5);
                C(1,6) = dataL(6);
                C(2,2) = dataL(7);
                C(2,3) = dataL(8);
                C(2,4) = dataL(9);
                C(2,5) = dataL(10);
                C(2,6) = dataL(11);
                C(3,3) = dataL(12);
                C(3,4) = dataL(13);
                C(3,5) = dataL(14);
                C(3,6) = dataL(15);
                C(4,4) = dataL(16);
                C(4,5) = dataL(17);
                C(4,6) = dataL(18);
                C(5,5) = dataL(19);
                C(5,5) = dataL(20);
                C(6,6) = dataL(21);
                % Constructing symmetric matrix
                C = C + triu(C,1)';

            elseif (~isempty(strfind(lower(tline),'cfull')) || ~isempty(strfind(lower(tline),'sfull')))
                if ~isempty(strfind(lower(tline),'sfull'))
                    Sflag = true;
                end
                cryType = [];
                Cflag   = true;
                lne1 = k + 1;
                lne2 = k + 2;
                lne3 = k + 3;
                lne4 = k + 4;
                lne5 = k + 5;
                lne6 = k + 6;

            elseif ~isempty(strfind(lower(tline),'isot '))
                cubi    = regexp(tline,'\ ','split');
                dataL   = cellfun(@str2num,cubi(2:end));
                cryType = 'Isotropic';
                % Isotropic: 2 independent elastic constants: C11, C12;
                C(1,1) = dataL(1);
                C(1,2) = dataL(2);

                C(2,2) = C(1,1);
                C(3,3) = C(1,1);
                C(4,4) = (C(1,1)-C(1,2))/2;
                C(5,5) = C(4,4);
                C(6,6) = C(4,4);
                C(1,3) = C(1,2);
                C(2,3) = C(1,2);
                % Constructing symmetric matrix
                C = C+triu(C,1)';

            elseif ~isempty(strfind(lower(tline),'pressure '))
                presre   = regexp(tline,'\ ','split');
                pressure = str2num(presre{2});
            elseif ~isempty(strfind(lower(tline),'nmesh3d '))
                nm3d     = regexp(tline,'\ ','split');
                dataL    = cellfun(@str2num,nm3d(2:end));
                lenD     = length(nm3d);
                switch(lenD)
                    case 1
                        ntheta       = dataL(1);
                    case 2
                        ntheta       = dataL(1);
                        nphi         = dataL(2);
                    case 3
                        ntheta       = dataL(1);
                        nphi         = dataL(2);
                        nchi         = dataL(3);
                end
            elseif ~isempty(strfind(lower(tline),'nmesh2d '))
                nm2d     = regexp(tline,'\ ','split');
                ntheta2d = str2num(nm2d{2});
            elseif ~isempty(strfind(lower(tline),'teps '))
                tepst = regexp(tline,'\ ','split');
                teps  = str2num(tepst{2});
            elseif ~isempty(strfind('properties',strrep(lower(tline),' ',''))) && (length(strrep(lower(tline),' ',''))>=4)
                Pflag = true;
                plne1 = k + 1;
                plne2 = k + 2;
            elseif ~isempty(strfind(lower(tline),'mponline '))
                mponline    = regexp(tline,'\ ','split');
                switch(lower(mponline{2}))
                    case {'no','n'}
                        Re.mponline = false;
                    case {'yes','y'}
                        Re.mponline = true;
                end
            elseif ~isempty(strfind(lower(tline),'mpid '))
                mpid    = regexp(tline,'\ ','split');
                Re.mpid = mpid{2};
            elseif ~isempty(strfind(lower(tline),'xapikey '))
                xapikey = regexp(tline,'\ ','split');
                Re.xapikey = xapikey{2};
            elseif ~isempty(strfind(lower(tline),'mpapiver '))
                mpapiver    = regexp(tline,'\ ','split');
                switch(lower(mpapiver{2}))
                    case {'new'}
                        Re.mpapiver = 'new';
                    case {'old','legacy'}
                        Re.mpapiver = 'old';
                end
            elseif (~isempty(strfind(lower(tline),'hv ')) || ~isempty(strfind(lower(tline),'hardness ')))
                HvM        = regexp(tline,'\ ','split');
                Re.HvModel = HvM{2};
            elseif ~isempty(strfind(lower(tline),'kic '))
                KicM         = regexp(tline,'\ ','split');
                KIC.model    = KicM{2};
                KIC.material = KicM{3};

                dataL = cellfun(@str2num,KicM(4:end));
                
                switch(KIC.model)
                    case {'N','Niu'}
                        switch(KIC.material)
                            case 'IC'
                              if isequal(dataL(1),0)
                                  hmsg = msgbox('V0 cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.V0     = dataL(1);
                              end
                            case 'M'
                              if isequal(dataL(1),0)
                                  hmsg = msgbox('V0 cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.V0     = dataL(1);
                              end
                              if isequal(dataL(2),0)
                                  hmsg = msgbox('gEFr cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.gEFr   = dataL(2);
                              end
                            case 'IM'
                               if isequal(dataL(1),0)
                                  hmsg = msgbox('V0 cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.V0     = dataL(1);
                              end
                              if isequal(dataL(2),0)
                                  hmsg = msgbox('gEFr cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.gEFr   = dataL(2);
                              end
                              if isequal(dataL(3),0)
                                  hmsg = msgbox('m cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.m      = dataL(3);
                              end
                              if isequal(dataL(4),0)
                                  hmsg = msgbox('n cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.n      = dataL(4);
                              end
                              if isequal(dataL(5),0)
                                  hmsg = msgbox('XA cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.XA     = dataL(5);
                              end
                              if isequal(dataL(6),0)
                                  hmsg = msgbox('XB cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.XB     = dataL(6);
                              end
                        end
                    case {'M','Mazhnik'}
                       switch(KIC.material)
                            case 'IC'
                                if isequal(dataL(1),0)
                                    hmsg = msgbox('V0 cannot be 0!', 'VELAS reminder','help');
                                    pause(0.5);
                                    if ishandle(hmsg)
                                        close(hmsg);
                                    end
                                    KIC.model    = '';
                                    KIC.material = '';
                                else
                                    KIC.V0     = dataL(1);
                                end
                            case 'M'
                                if isequal(dataL(1),0)
                                    hmsg = msgbox('V0 cannot be 0!', 'VELAS reminder','help');
                                    pause(0.5);
                                    if ishandle(hmsg)
                                        close(hmsg);
                                    end
                                    KIC.model    = '';
                                    KIC.material = '';
                                else
                                    KIC.V0     = dataL(1);
                                end
                            case 'IM'
                              if isequal(dataL(1),0)
                                  hmsg = msgbox('V0 cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.V0     = dataL(1);
                              end
                              if isequal(dataL(2),0)
                                  hmsg = msgbox('gEFr cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.gEFr   = dataL(2);
                              end
                              if isequal(dataL(3),0)
                                  hmsg = msgbox('m cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.m      = dataL(3);
                              end
                              if isequal(dataL(4),0)
                                  hmsg = msgbox('n cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.n      = dataL(4);
                              end
                              if isequal(dataL(5),0)
                                  hmsg = msgbox('XA cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.XA     = dataL(5);
                              end
                              if isequal(dataL(6),0)
                                  hmsg = msgbox('XB cannot be 0!', 'VELAS reminder','help');
                                  pause(0.5);
                                  if ishandle(hmsg)
                                      close(hmsg);
                                  end
                                  KIC.model    = '';
                                  KIC.material = '';
                              else
                                  KIC.XB     = dataL(6);
                              end
                       end
                end 

            elseif (~isempty(strfind(lower(tline),'avg ')) || ~isempty(strfind(lower(tline),'average ')))
                avg = regexp(tline,'\ ','split');
                switch(lower(avg{2}))
                    case {'yes','y'}
                        avgout = true;
                    case {'no','n'}
                        avgout = false;
                    otherwise
                        avgout = false;
                end
            elseif (~isempty(strfind(lower(tline),'cmap ')) || ~isempty(strfind(lower(tline),'colormap ')))
                cmap = regexp(tline,'\ ','split');
                cmap = cmap{2};
            elseif (~isempty(strfind(lower(tline),'unitsph ')) || ~isempty(strfind(lower(tline),'unitspherical ')))
                unitsph  = regexp(tline,'\ ','split');
                switch(lower(unitsph{2}))
                    case {'yes','y'}
                        dounitsph =  true;
                    case {'no','n'}
                        dounitsph = false;
                    otherwise
                        dounitsph = false;
                end

            elseif (~isempty(strfind(lower(tline),'mapproj ')) || ~isempty(strfind(lower(tline),'mapprojection ')))
                mpro  = regexp(tline,'\ ','split');
                switch(lower(mpro{2}))
                    case {'yes','y'}
                        domap = true;
                    case {'no','n'}
                        domap = false;
                    otherwise
                        domap = false;
                end
                % 'Gall-Peters' (GP),'Robinson' (R),'Hammer-Aitoff' (HA),'Mollweide' (M)
                switch(lower(mpro{3}))
                    case {'gp','gall-peters'}
                        mpmode = 'Gall-Peters';
                    case {'r','robinson'}
                        mpmode = 'Robinson';
                    case {'ha','hammer-aitoff'}
                        mpmode = 'Hammer-Aitoff';
                    case {'m','mollweide'}
                        mpmode = 'Mollweide';
                    otherwise
                        mpmode = 'Mollweide'; % default: 'Mollweide'
                end
            elseif (~isempty(strfind(lower(tline),'lstyle ')) || ~isempty(strfind(lower(tline),'linestyle ')))
                lstyle    = regexp(tline,'\ ','split');
                lineStyle = lstyle{2};

            elseif ~isempty(strfind(lower(tline),'print '))
                printstr  = regexp(tline,'\ ','split');
                switch(lower(printstr{2}))
                    case {'yes','y'}
                        doprint = true;
                    case {'no','n'}
                        doprint = false;
                    otherwise
                        doprint = false;
                end

            elseif (~isempty(strfind(lower(tline),'dpi ')))
                dpi     = regexp(tline,'\ ','split');
                dpi     = dpi{2};
            end

            if Cflag && (k == lne1 ||k == lne2 || k == lne3 || k == lne4 || k == lne5 || k == lne6)
                dataL = str2num(tline);
                ck = ck+1;
                C(ck,:) = dataL;
                if k == lne6
                    Cflag   = false;
                    cryType = getCrystalType(C);
                end
            elseif Pflag && (k == plne1 || k == plne2)
                dataL = str2num(tline);
                pk = pk+1;
                Pro(pk,:) = dataL;
                if k == plne2
                    Pflag = false;
                end
            elseif planeXYflag && k == lne
                lne = k + 1;
                pL = str2num(tline);
                if ~isempty(pL)
                    plk    = plk+1;
                    planex = pL(1);
                    planey = pL(2);
                    planez = pL(3);
                    planeC(plk,:) = [planex,planey,planez];
                else
                    planeXYflag = false;
                end
            elseif planeSphflag && k == lne
                lne = k + 1;
                pL  = str2num(tline);
                if ~isempty(pL)
                    planetheta    = pL(1);
                    planephi      = pL(2);
                    if planeAng
                        planex        = sind(planetheta)*cosd(planephi);
                        planey        = sind(planetheta)*sind(planephi);
                        planez        = cosd(planetheta);
                    else
                        planex        = sin(planetheta)*cos(planephi);
                        planey        = sin(planetheta)*sin(planephi);
                        planez        = cos(planetheta);
                    end
                    plk             = plk+1;
                    planeC(plk,:)   = [planex,planey,planez];
                    planeS(plk,:)   = pL;
                else
                    planeSphflag = false;
                end
            end
            k = k+1;
        end
    else
        break;
    end
end
fclose(fid);

% Compliance matrix Sij
if ~strcmp(cryType,'none')
    S = inv(C);
else
    S = C;
end

if Sflag
    tC = S;
    S  = C;
    C  = tC;
end

% change the number to 0 if it is less than teps.

planeC(abs(planeC)<teps) = 0;
planeS(abs(planeS)<teps) = 0;

% output of input data
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
Re.dounitsph    = dounitsph;
Re.domap        = domap;
Re.cmap         = cmap;
Re.mpmode       = mpmode;
Re.lineStyle    = lineStyle;
Re.doprint      = doprint;
Re.dpi          = dpi;

