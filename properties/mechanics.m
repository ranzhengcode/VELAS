function Re = mechanics(inputData,Re)

%{
   ========= Calculation of crystal mechanical parameters ==========
    Input parameter:
                      inputData, input data including stiffness matrix C, etc
                      filename, the file name that contains the file path.
    Out parameter:
                      Re, output results include various crystal mechanical parameters.
%}

hmsg = msgbox('Start calculation ...', 'VELAS reminder','help');
pause(1);
if ishandle(hmsg)
    close(hmsg);
end

hmsg = msgbox('In calculation ...', 'VELAS reminder','help');

C               = inputData.C;
S               = inputData.S;
plane           = inputData.planeC;
planeS          = inputData.planeS;
cryType         = inputData.cryType;
pressure        = inputData.pressure;
ntheta          = inputData.ntheta;
nphi            = inputData.nphi;
nchi            = inputData.nchi;
ntheta2d        = inputData.ntheta2d;
teps            = inputData.teps;
Pro             = inputData.Pro;

[filepath,fname,~]   = fileparts(inputData.filename);

% creat new folder named by fname
dirStatus            = exist(strcat(filepath,filesep,fname),'dir');
if dirStatus == 0
    status           = mkdir(strcat(filepath,filesep,fname));
    if status
        filepath = strcat(filepath,filesep,fname);
    end
else
    filepath = strcat(filepath,filesep,fname);
end

% Recording and saving the calculation results to .log file
logFilename                   = strcat(filepath,filesep,fname,'.log');
fid                           = fopen(logFilename,'wt');

% Crystal type
if isempty(cryType)
    cryType = getCrystalType(C);
end

tic;

% VELAS logo info
fprintf(fid,'%s\r','');
fprintf(fid,'%s\r','              +---------------------------------------------------------+');
fprintf(fid,'%s\r','              |                                                         |');
fprintf(fid,'%s\r','              |     V       V  EEEEEEE  L            A      SSSSSSS     |');
fprintf(fid,'%s\r','              |      V     V   E        L           A A     S           |');
fprintf(fid,'%s\r','              |       V   V    EEEEEEE  L          AAAAA    SSSSSSS     |');
fprintf(fid,'%s\r','              |        V V     E        L         A     A         S     |');
fprintf(fid,'%s\r','              |         V      EEEEEEE  LLLLLLL  A       A  SSSSSSS     |');
fprintf(fid,'%s\r','              |                                                         |');
fprintf(fid,'%s\r','              |                  VELAS version 1.0.0                    |');
fprintf(fid,'%s\r','              |                   Author: Zheng Ran                     |');
fprintf(fid,'%s\r','              |               Email:ranzheng@outlook.com                |');
fprintf(fid,'%s\r','              |                                                         |');
fprintf(fid,'%s\r','              | If you use VELAS in your resarch, please cite:          |');
fprintf(fid,'%s\r','              |                                                         |');
fprintf(fid,'%s\r','              | "VELAS: An open-source toolbox for visualization and    |');
fprintf(fid,'%s\r','              |           analysis of elastic anisotropy"               |');
fprintf(fid,'%s\r','              +---------------------------------------------------------+');
% VELAS logo info end

fprintf(fid,'%s\r','');
fprintf(fid,'%s\r',strcat('Start at:',32,datestr(now())));

fprintf(fid,'%s\r','');
fprintf(fid,'%s\r','*********************************************************************************************');
fprintf(fid,'%s\r','                           Input parameters');
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,'%s\t%s\t\r','Input File  :',inputData.filename);
fprintf(fid,'%s\t%s\t\r','Output file :',logFilename);
fprintf(fid,'%s\r','');
fprintf(fid,'%s%s\r','Crystal system : ',cryType);
fprintf(fid,'%s\r','');
fprintf(fid,'%s%5.2f\r','Structure under pressure  [Units in GPa]: ',pressure);
fprintf(fid,'%s\r','');
fprintf(fid,'%s\r','Stifness matrix C [Units in GPa]');
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,[repmat('%5.2f\t', 1, size(C,2)), '\n'], C');
fprintf(fid,'%s\r','');
fprintf(fid,'%s\r','                            Meshing parameters');
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,'%s\t\r',strcat('3D Mesh number of [ntheta(θ), nphi(φ), nchi(χ)]: [',num2str(ntheta),',',num2str(nphi),',',num2str(nchi),']'));
fprintf(fid,'%s%d\r','2D Mesh number of theta(θ): ',ntheta2d);
fprintf(fid,'%s\r','');
fprintf(fid,'%s\r','                 Properties calculation parameters');
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,'%s\r','Young(E) Compressibility(β) Shear(G) Poisson(ν) Bulk(B)  PughRat(κ) Hardv(Hv) FractTough(KIC)');
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\r','Mode\Properties:',' E ',' β ',' G ',' ν ',' B ',' κ ','Hv ','KIC');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\r','        3D mode:',setTrueFalse(Pro(1,1)),setTrueFalse(Pro(1,2)),setTrueFalse(Pro(1,3)),setTrueFalse(Pro(1,4)),setTrueFalse(Pro(1,5)),setTrueFalse(Pro(1,6)),setTrueFalse(Pro(1,7)),setTrueFalse(Pro(1,8)));
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\r','        2D mode:',setTrueFalse(Pro(2,1)),setTrueFalse(Pro(2,2)),setTrueFalse(Pro(2,3)),setTrueFalse(Pro(2,4)),setTrueFalse(Pro(2,5)),setTrueFalse(Pro(2,6)),setTrueFalse(Pro(2,7)),setTrueFalse(Pro(2,8)));
fprintf(fid,'%s\r','');

if inputData.planeSph
    if inputData.planeAng
        fprintf(fid,'%s\r','                         Plane for 2D calculation [In angle]');
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,[repmat('%5.2f\t', 1, size(planeS,2)), '\n'], planeS');
    else
        fprintf(fid,'%s\r','                         Plane for 2D calculation [In radian]');
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,[repmat('%5.2f\t', 1, size(planeS,2)), '\n'], planeS');
    end
else
    fprintf(fid,'%s\r','                         Plane for 2D calculation [xyz]');
    fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
    fprintf(fid,[repmat('%5.2f\t', 1, size(plane,2)), '\n'], plane');
end
fprintf(fid,'%s\r','');

fprintf(fid,'%s\r','                             Precision control');
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,'%s%2.1e\t\r','Less than teps will be considered equal to 0: ',teps);
fprintf(fid,'%s\r','');
fprintf(fid,'%s\r','*********************************************************************************************');
fprintf(fid,'%s\r','');

fprintf(fid,'%s\r','#############################################################################################');
fprintf(fid,'%s\r','                          Calculation Results');
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,'%s\r','');
fprintf(fid,'%s\r','Compliance matrix S [(if C in GPa, then S in (TPa)^-1]');
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,[repmat('%5.2f\t', 1, size(S,2)), '\n'], 1000*S');
fprintf(fid,'%s\r','');

% calculating the Eigenvalues of the stiffness matrix C
lamda = eig(C);
fprintf(fid,'%s\r','');
fprintf(fid,'%s\r','Eigenvalues of the stiffness matrix,lamda(λ) [Units in GPa]');
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,[repmat('%5.2f\t', 1, size(lamda,1)), '\n'], lamda');
fprintf(fid,'%s\r','');

%% Tht average scheme of Voigt-Reuss-Hill (VRH)
%{
     B - bulk modulus; G - shear modulus;
     v - Voigt; r - Reuss; h - Hill.
     E - Young's modulus
     nu - Poisson's ratio
%}

av      = (C(1,1)+C(2,2)+C(3,3))/3; bv = (C(1,2)+C(2,3)+C(1,3))/3; cv = (C(4,4)+C(5,5)+C(6,6))/3;
ar      = (S(1,1)+S(2,2)+S(3,3))/3; br = (S(1,2)+S(2,3)+S(1,3))/3; cr = (S(4,4)+S(5,5)+S(6,6))/3;

% Bulk modulus
Bv              = (av+2*bv)/3;
Br              = 1/(3*ar+6*br);
Bh              = (Bv+Br)/2;

% Shear modulus
Gv              = (av-bv+3*cv)/5;
Gr              = 5/(4*ar-4*br+3*cr);
Gh              = (Gv+Gr)/2;

% Young's modulus
Ev              = 1/(1/(3*Gv)+1/(9*Bv));
Er              = 1/(1/(3*Gr)+1/(9*Br));
Eh              = (Ev+Er)/2;

% Poisson's ratio
nuv             = (1-(3*Gv)/(3*Bv+Gv))/2;
nur             = (1-(3*Gr)/(3*Bv+Gr))/2;
nuh             = (nuv+nur)/2;

% Lame's first parameter
lamestv         = nuv*Ev/((1+nuv)*(1-2*nuv));
lamestr         = nur*Er/((1+nur)*(1-2*nur));
lamesth         = nuh*Eh/((1+nuh)*(1-2*nuh));
% Lame's second parameter
lamendv         = Ev/(2*(1+nuv));
lamendr         = Er/(2*(1+nur));
lamendh         = Eh/(2*(1+nuh));

% Pugh ratio
Prv              = Bv/Gv;
Prr              = Br/Gr;
Prh              = Bh/Gh;

% Kleinman parameter
Zeta            = (C(1,1)+8*C(1,2))/(7*C(1,1)+2*C(1,2));
% Average Cauchy pressure based on Wang's model
Cpv             = calcCauchyPressure(Gv,Bv);
Cpr             = calcCauchyPressure(Gr,Br);
Cph             = calcCauchyPressure(Gh,Bh);

% P-wave modulus
Pwv             = calcPwaveModulus(Bv,Gv);
Pwr             = calcPwaveModulus(Br,Gr);
Pwh             = calcPwaveModulus(Bh,Gh);
% Elastic Anisotropy
AU              = Bv/Br + 5*Gv/Gr - 6;                    % Ranganathan and Ostoja-Starzewski universal anisotropy index
AL              = sqrt((log(Bv/Br)^2 + 5*log(Gv/Gr)^2));  % Kube's log-Euclidean anisotropy index

% Vickers hardness based on Mazhnik's, Chen's and Tian's model
HvMazhnikv = calcHardness(Ev,nuv,'M'); HvMazhnikr = calcHardness(Er,nur,'M'); HvMazhnikh = calcHardness(Eh,nuh,'M');
HvChenv    = calcHardness(Gv,Bv,'C');  HvChenr    = calcHardness(Gr,Br,'C');  HvChenh    = calcHardness(Gh,Bh,'C');
HvTianv    = calcHardness(Gv,Bv,'T');  HvTianr    = calcHardness(Gr,Br,'T');  HvTianh    = calcHardness(Gh,Bh,'T');

fprintf(fid,'%s\r','');
fprintf(fid,'%s\r','=============================================================================================');
fprintf(fid,'%s\r','            The average scheme of Voigt-Reuss-Hill (Units in GPa)');
fprintf(fid,'%s\r','=============================================================================================');
fprintf(fid,'%s\t%s\t%s\t\r','                                 Voigt','       Reuss','       Hill');
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,strcat('%s\t',repmat('%s%6.2f\t',1,3), '\n'), 'Bulk modulus              :','    ',Bv,'      ',Br,'      ',Bh);
fprintf(fid,strcat('%s\t',repmat('%s%6.2f\t',1,3), '\n'), 'Shear modulus             :','    ',Gv,'      ',Gr,'      ',Gh);
fprintf(fid,strcat('%s\t',repmat('%s%6.2f\t',1,3), '\n'), 'Young modulus             :','    ',Ev,'      ',Er,'      ',Eh);
fprintf(fid,strcat('%s\t',repmat('%s%6.4f\t',1,3), '\n'), 'Poisson ratio             :','    ',nuv,'      ',nur,'      ',nuh);
fprintf(fid,strcat('%s\t',repmat('%s%6.2f\t',1,3), '\n'), 'P-wave modulus            :','    ',Pwv,'      ',Pwr,'      ',Pwh);
fprintf(fid,strcat('%s\t',repmat('%s%6.2f\t',1,3), '\n'), 'Lame''s first parameter    :','    ',lamestv,'      ',lamestr,'      ',lamesth);
fprintf(fid,strcat('%s\t',repmat('%s%6.2f\t',1,3), '\n'), 'Lame''s second parameter   :','    ',lamendv,'      ',lamendr,'      ',lamendh);
fprintf(fid,strcat('%s\t',repmat('%s%6.2f\t',1,3), '\n'), 'Pugh ratio                :','    ',Prv,'      ',Prr,'      ',Prh);
fprintf(fid,strcat('%s\t',repmat('%s%s\t',1,3), '\n'), 'Ductility                 :','    ',getDuctility(Prv),'      ',getDuctility(Prr),'      ',getDuctility(Prh));
fprintf(fid,strcat('%s\t',repmat('%s%6.2f\t',1,3), '\n'), 'Average Cauchy pressure   :','    ',Cpv,'      ',Cpr,'      ',Cph);
fprintf(fid,strcat('%s\t',repmat('%s\t',1,3), '\n'), 'Bond Tpye                 :',getBondType(Cpv),getBondType(Cpr),getBondType(Cph));
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,strcat('%s\t',repmat('%s%6.4f\t',1,3), '\n'), 'Vickers hardness (Mazhnik):','    ',HvMazhnikv,'      ',HvMazhnikr,'      ',HvMazhnikh);
fprintf(fid,strcat('%s\t',repmat('%s%6.4f\t',1,3), '\n'), 'Vickers hardness (Chen)   :','    ',HvChenv,'      ',HvChenr,'      ',HvChenh);
fprintf(fid,strcat('%s\t',repmat('%s%6.4f\t',1,3), '\n'), 'Vickers hardness (Tian)   :','    ',HvTianv,'      ',HvTianr,'      ',HvTianh);
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
switch(cryType)
    % Cauchy's pressure based on Cij
    case 'Cubic'
        Cp = C(1,2) - C(4,4);
        fprintf(fid,'%s%6.2f\t\r', 'Cauchy pressure based on Cij:   [C12-C44]: ',Cp);
    case {'Hexagonal','Tetragonal','Trigonal'}
        Cp1 = C(1,2) - C(6,6);
        Cp2 = C(1,3) - C(4,4);
        fprintf(fid,'%s\t%s%6.2f\t%s%6.2f\r', 'Cauchy pressure based on Cij: ',' [C12-C66]: ',Cp1,'[C13-C44]: ',Cp2);
    case {'Orthorhombic','Monoclinic','Triclinic'}
        Cp1 = C(1,2) - C(6,6);
        Cp2 = C(1,3) - C(5,5);
        Cp3 = C(2,3) - C(4,4);
        fprintf(fid,'%s\t%s%6.2f\t%s%6.2f\t%s%6.2f\r', 'Cauchy pressure based on Cij: ',' [C12-C66]: ',Cp1,'[C13-C55]: ',Cp2,'[C23-C44]: ',Cp3);
end
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,strcat('%s%6.4f\t', '\n'), 'Kleinman parameter zeta(ζ)         :',Zeta);
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
fprintf(fid,strcat('%s%6.4f\t', '\n'), 'Universal anisotropy index (ROS''s) :',AU);
fprintf(fid,strcat('%s%6.4f\t', '\n'), 'Universal anisotropy index (Kube''s):',AL);
fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
% fprintf(fid,[repmat('%5.2f\t', 1, size(C,2)), '\n'], lamda');

Re.C      = C;
Re.S      = S;
Re.Pro    = Pro;
Re.planeC = plane;
Re.lamda  = lamda;
Re.Bv =  Bv;
Re.Br =  Br;
Re.Bh =  Bh;
Re.Gv =  Gv;
Re.Gr =  Gr;
Re.Gh =  Gh;
Re.Ev =  Ev;
Re.Er =  Er;
Re.Eh =  Eh;
Re.nuv  =  nuv;
Re.nur  =  nur;
Re.nuh  =  nuh;
Re.HvMv = HvMazhnikv;
Re.HvMr = HvMazhnikr;
Re.HvMh = HvMazhnikh;
Re.HvCv = HvChenv;
Re.HvCr = HvChenr;
Re.HvCh = HvChenh;
Re.HvTv = HvTianv;
Re.HvTr = HvTianr;
Re.HvTh = HvTianh;
Re.lamestv =  lamestv;
Re.lamestr =  lamestr;
Re.lamesth =  lamesth;
Re.lamendv =  lamendv;
Re.lamendr =  lamendr;
Re.lamendh =  lamendh;
Re.AU =  AU;
Re.AL =  AL;


%% base parameters
% Scale to Tera-1
S                  = S*1000;
ttheta              = linspace(0,pi+eps,ntheta);   % theta:θ
tphi                = linspace(0,2*pi+eps,nphi);   % phi:φ

% data format
formatD = [repmat('%5.4f\t', 1, ntheta), '\n'];
formatD(end-3:end-2) = [];

% Generating the grid coordinates of theta & phi
[theta, phi]   = meshgrid(ttheta, tphi);

% Combining   and   for the following vectorization calculation
thph           = [theta(:),phi(:)];

Re.meshedTheta =  theta;
Re.meshedPhi   =  phi;

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
            FractureToughness3D — Pro(1,8),  FractureToughness2D — Pro(2,8);
%}

if Pro(1,1)
    %% ========== Calculation of Young's Modulus ========================================
    [tmpE,S1111,negFlagE]       = calcYoung(thph,S,ntheta2d,plane,'3D');
    E                           = reshape(tmpE,nphi,ntheta);
    AE                          = calcAnisotropy(E);

    if negFlagE
        % Positive
        tmpEp           = getPosNeg(tmpE,'pos');
        Epos            = reshape(tmpEp,nphi,ntheta);
        % save positive Young's Modulus in .dat file
        EpFilename      = strcat(filepath,filesep,fname,'_3D_E.dat');
        fidEp           = fopen(EpFilename,'wt');
        fprintf(fidEp,formatD, Epos');
        fclose(fidEp);

        tmpEn              = getPosNeg(tmpE,'neg');
        Eneg               = -reshape(tmpEn,nphi,ntheta);
        % save negtitive Young's Modulus in .dat file
        EnFilename         = strcat(filepath,filesep,fname,'_3D_Eneg.dat');
        fidEn              = fopen(EnFilename,'wt');
        fprintf(fidEn,formatD, Eneg');
        fclose(fidEn);

        Re.E                      = Epos;
        Re.Eneg                   = Eneg;
    else
        % save Young's Modulus in .dat file
        EpFilename                = strcat(filepath,filesep,fname,'_3D_E.dat');
        fidEp                     = fopen(EpFilename,'wt');
        fprintf(fidEp,formatD, E');
        fclose(fidEp);

        Re.E                      = E;
        Re.Eneg                   = [];
    end

    % save Young's Modulus in .dat file
    EFilename                   = strcat(filepath,filesep,fname,'_3D_E.dat');
    fidE                        = fopen(EFilename,'wt');
    fprintf(fidE,formatD, E');
    fclose(fidE);

    % calculating the maximum and minimum of Young's Modulus and its directions.
    Emax                   = max(tmpE);
    EmaxTheta              = theta(E == Emax);
    EmaxPhi                = phi(E == Emax);
    Ehklmax                = dir2Vec(EmaxTheta,EmaxPhi);

    Ehklmax                = set2zeros(Ehklmax,teps);
    Ehklmax                = set2ones(Ehklmax,teps);
    % Remove duplicate values
    [~,loc]                = unique(Ehklmax,'rows');
    EmaxTP                 = [EmaxTheta(loc),EmaxPhi(loc)];
    Ehklmax                = Ehklmax(loc,:);
%     [Emax,EmaxTP,Ehklmax]  = maxminSearch(EmaxTP,@(x) -calcYoung(x,S,ntheta2d,plane,'3D'),teps);
%     Ehklmax                = set2zeros(Ehklmax,teps);
%     Ehklmax                = set2ones(Ehklmax,teps);
%     Emax                   = mean(-Emax);

    Emin                   = min(tmpE);
    EminTheta              = theta(E == Emin);
    EminPhi                = phi(E == Emin);
    Ehklmin                = dir2Vec(EminTheta,EminPhi);

    Ehklmin                = set2zeros(Ehklmin,teps);
    Ehklmin                = set2ones(Ehklmin,teps);
    % Remove duplicate values
    [~,loc]                = unique(Ehklmin,'rows');
    EminTP                 = [EminTheta(loc),EminPhi(loc)];
    Ehklmin                = Ehklmin(loc,:);
%     [Emin,EminTP,Ehklmin]  = maxminSearch(EminTP,@(x) calcYoung(x,S,ntheta2d,plane,'3D'),teps);
%     Ehklmin                = set2zeros(Ehklmin,teps);
%     Ehklmin                = set2ones(Ehklmin,teps);
%     Emin                   = mean(Emin);

    Re.Emax    =  Emax;
    Re.EmaxTP  =  EmaxTP;
    Re.Ehklmax =  Ehklmax;
    Re.Emin    =  Emin;
    Re.EminTP  =  EminTP;
    Re.Ehklmin =  Ehklmin;

    fprintf(fid,'%s\r','');
    fprintf(fid,'%s\r','=============================================================================================');
    fprintf(fid,'%s\r','      The maximum and minimum of Young''s Modulus [Units in GPa] and its directions');
    fprintf(fid,'%s\r','=============================================================================================');
    fprintf(fid,'%s\r', ['Anisotropy of Young''s Modulus: ',num2str(AE)]);
    fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
    fprintf(fid,'%s\t%s\t\r','Emax','Emin');
    fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [Emax Emin]);
    fprintf(fid,'%s\r','Direction for Emax');
    fprintf(fid,'%s\t%s\t\r',' θ (Emax)',' φ (Emax)');
    fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], EmaxTP(end,:)');
    fprintf(fid,'%s\t%s\t%s\t\r','x (Emax)','y (Emax)','z (Emax)');
    fprintf(fid,[repmat('%5.2f\t', 1, 3), '\n'], Ehklmax(end,:)');
    fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
    fprintf(fid,'%s\r','Direction for Emin');
    fprintf(fid,'%s\t%s\t\r',' θ (Emin)',' φ (Emin)');
    fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], EminTP(end,:)');
    fprintf(fid,'%s\t%s\t%s\t\r','x (Emin)','y (Emin)','z (Emin)');
    fprintf(fid,[repmat('%5.2f\t', 1, 3), '\n'], Ehklmin(end,:)');
end

if Pro(1,2)
    %% ========== Calculation of Linear Compressibility ==================================
    [tmpbeta,negFlagbeta]  = calcCompress(thph,S,ntheta2d,plane,'3D');
    beta                   = reshape(tmpbeta,nphi,ntheta);
    Abeta                  = calcAnisotropy(beta);
    if negFlagbeta
        % Positive
        tmpbetap           = getPosNeg(tmpbeta,'pos');
        betapos            = reshape(tmpbetap,nphi,ntheta);
        % save positive Linear Compressibility in .dat file
        betapFilename                = strcat(filepath,filesep,fname,'_3D_beta.dat');
        fidbetap                     = fopen(betapFilename,'wt');
        fprintf(fidbetap,formatD, betapos');
        fclose(fidbetap);

        tmpbetan              = getPosNeg(tmpbeta,'neg');
        betaneg               = -reshape(tmpbetan,nphi,ntheta);
        % save negtitive Linear Compressibility in .dat file
        betanFilename                = strcat(filepath,filesep,fname,'_3D_betaneg.dat');
        fidbetan                     = fopen(betanFilename,'wt');
        fprintf(fidbetan,formatD, betaneg');
        fclose(fidbetan);

        Re.beta                      = betapos;
        Re.betaneg                   = betaneg;
    else
        % save Linear Compressibility in .dat file
        betapFilename                = strcat(filepath,filesep,fname,'_3D_beta.dat');
        fidbetap                     = fopen(betapFilename,'wt');
        fprintf(fidbetap,formatD, beta');
        fclose(fidbetap);

        Re.beta                     =  beta;
        Re.betaneg                  = [];
    end

    % calculating the maximum and minimum of Linear compressibility and its directions.
    betamax                   = max(tmpbeta);
    betamaxTheta              = theta(beta == betamax);
    betamaxPhi                = phi(beta == betamax);
    betahklmax                = dir2Vec(betamaxTheta,betamaxPhi);

    betahklmax                = set2zeros(betahklmax,teps);
    betahklmax                = set2ones(betahklmax,teps);

    [~,loc]                   = unique(betahklmax,'rows');
    betamaxTP                 = [betamaxTheta(loc),betamaxPhi(loc)];
    betahklmax                = betahklmax(loc,:);
%     [betamax,betamaxTP,betahklmax]  = maxminSearch(betamaxTP,@(x) -calcCompress(x,S,ntheta2d,plane,'3D'),teps);
%     betahklmax                = set2zeros(betahklmax,teps);
%     betahklmax                = set2ones(betahklmax,teps);
%     betamax                   = mean(-betamax);

    betamin                   = min(tmpbeta);
    betaminTheta              = theta(beta == betamin);
    betaminPhi                = phi(beta == betamin);
    betahklmin                = dir2Vec(betaminTheta,betaminPhi);

    betahklmin                = set2zeros(betahklmin,teps);
    betahklmin                = set2ones(betahklmin,teps);

    [~,loc]                   = unique(betahklmin,'rows');
    betaminTP                 = [betaminTheta(loc),betaminPhi(loc)];
    betahklmin                = betahklmin(loc,:);
%     [betamin,betaminTP,betahklmin]  = maxminSearch(betaminTP,@(x) calcCompress(x,S,ntheta2d,plane,'3D'),teps);
%     betahklmin                = set2zeros(betahklmin,teps);
%     betahklmin                = set2ones(betahklmin,teps);
%     betamin                   = mean(betamin);

    Re.betamax                =  betamax;
    Re.betamaxTP              =  betamaxTP;
    Re.betahklmax             =  betahklmax;
    Re.betamin                =  betamin;
    Re.betaminTP              =  betaminTP;
    Re.betahklmin             =  betahklmin;

    fprintf(fid,'%s\r','');
    fprintf(fid,'%s\r','=============================================================================================');
    fprintf(fid,'%s\r','    The maximum and minimum of Linear Compressibility [Units in TPa^-1] and its directions');
    fprintf(fid,'%s\r','=============================================================================================');
    fprintf(fid,'%s\r', ['Anisotropy of Linear Compressibility: ',num2str(Abeta)]);
    fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
    fprintf(fid,'%s\t%s\t\r','betamax','betamin');
    fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [betamax betamin]);
    fprintf(fid,'%s\r','Direction for betamax');
    fprintf(fid,'%s\t%s\t\r',' θ (betamax)',' φ (betamax)');
    fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], betamaxTP(end,:)');
    fprintf(fid,'%s\t%s\t%s\t\r','x (betamax)','y (betamax)','z (betamax)');
    fprintf(fid,[repmat('%5.2f\t', 1, 3), '\n'], betahklmax(end,:)');
    fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
    fprintf(fid,'%s\r','Direction for betamin');
    fprintf(fid,'%s\t%s\t\r',' θ (betamin)',' φ (betamin)');
    fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], betaminTP(end,:)');
    fprintf(fid,'%s\t%s\t%s\t\r','x (betamin)','y (betamin)','z (betamin)');
    fprintf(fid,[repmat('%5.2f\t', 1, 3), '\n'], betahklmin(end,:)');
end

if Pro(1,3)
    %% ========== Calculation of Shear Modulus ======================================
    [G, negFlagG]  = calcShear(thph,nchi,S,ntheta2d,plane,'normal','3D');
    AG             = calcAnisotropy(G);
    % calculating the maximum ,minimum positive and minimum negative of Poisson's Ratio and its directions.
    % maximum
    tmpGMax        = getMaxMinNeg(G,'max');
    Gmax           = reshape(tmpGMax,nphi,ntheta);

    % save max Shear Modulus in .dat file
    GmaxFilename                   = strcat(filepath,filesep,fname,'_3D_Gmax.dat');
    fidGmax                        = fopen(GmaxFilename,'wt');
    fprintf(fidGmax,formatD, Gmax');
    fclose(fidGmax);

    Gmmax                  = max(tmpGMax);
    GmaxTheta              = theta(Gmax == Gmmax);
    GmaxPhi                = phi(Gmax == Gmmax);
    Ghklmax                = dir2Vec(GmaxTheta,GmaxPhi);

    Ghklmax                = set2zeros(Ghklmax,teps);
    Ghklmax                = set2ones(Ghklmax,teps);

    [~,loc]                = unique(Ghklmax,'rows');
    GmaxTP                 = [GmaxTheta(loc),GmaxPhi(loc)];
    Ghklmax                = Ghklmax(loc,:);
%     [Gmmax,GmaxTP,Ghklmax] = maxminSearch(GmaxTP,@(x) -calcShear(x,nchi,S,ntheta2d,plane,'max','3D'),teps);
%     Ghklmax                = set2zeros(Ghklmax,teps);
%     Ghklmax                = set2ones(Ghklmax,teps);
%     Gmmax                  = mean(-Gmmax);

    % minimum positive
    tmpGMinp                  = getMaxMinNeg(G,'min');
    Gminp                     = reshape(tmpGMinp,nphi,ntheta);
    % save min positive Shear Modulus in .dat file
    GminFilename              = strcat(filepath,filesep,fname,'_3D_Gminp.dat');
    fidGmin                   = fopen(GminFilename,'wt');
    fprintf(fidGmin,formatD, Gminp');
    fclose(fidGmin);

    Gmminp                  = min(tmpGMinp);
    GminpTheta              = theta(Gminp == Gmminp);
    GminpPhi                = phi(Gminp == Gmminp);
    Ghklminp                = dir2Vec(GminpTheta,GminpPhi);

    Ghklminp                = set2zeros(Ghklminp,teps);
    Ghklminp                = set2ones(Ghklminp,teps);

    [~,loc]                 = unique(Ghklminp,'rows');
    GminpTP                 = [GminpTheta(loc),GminpPhi(loc)];
    Ghklminp                = Ghklminp(loc,:);
%     [Gmminp,GminpTP,Ghklminp]  = maxminSearch(GminpTP,@(x) calcShear(x,nchi,S,ntheta2d,plane,'min','3D'),teps);
%     Ghklminp                = set2zeros(Ghklminp,teps);
%     Ghklminp                = set2ones(Ghklminp,teps);
%     Gmminp                   = mean(Gmminp);

    Gmmin                     = Gmminp;
    GminTP                    = GminpTP;
    Ghklmin                   = Ghklminp;

    Re.G        =  G;
    Re.Gmax     =  Gmax;
    Re.Gmmax    =  Gmmax;
    Re.GmaxTP   =  GmaxTP;
    Re.Ghklmax  =  Ghklmax;
    Re.Gminp    =  Gminp;
    Re.Gmminp   =  Gmminp;
    Re.GminpTP  =  GminpTP;
    Re.Ghklminp =  Ghklminp;

    if inputData.avgout
        Gavg                      = reshape(mean(G),nphi,ntheta);
        % save avg Shear Modulus in .dat file
        GavgFilename                   = strcat(filepath,filesep,fname,'_3D_Gavg.dat');
        fidGavg                        = fopen(GavgFilename,'wt');
        %     fprintf(fidGavg,'%s\r','');
        %     fprintf(fidGavg,'%s\r',strcat(fname,'   average Shear Modulus [Units in GPa]'));
        fprintf(fidGavg,formatD, Gavg');
        fclose(fidGavg);
        Re.Gavg     =  Gavg;
    end

    % minimum negative
    if negFlagG
        tmpGMinn                  = getMaxMinNeg(G,'neg');
        Gminn                     = reshape(tmpGMinn,nphi,ntheta);

        % save min positive Shear Modulus in .dat file
        GMinnFilename                   = strcat(filepath,filesep,fname,'_3D_Gminn.dat');
        fidGMinn                        = fopen(GMinnFilename,'wt');
        %         fprintf(fidPMinn,'%s\r','');
        %         fprintf(fidPMinn,'%s\r',strcat(fname,'   minimum negative Poisson''s Ratio'));
        fprintf(fidGMinn,formatD, Gminn');
        fclose(fidGMinn);

        Gmminn                    = max(tmpGMinn);
        GminnTheta                = theta(Gminn == Gmminn);
        GminnPhi                  = phi(Gminn == Gmminn);
        Ghklminn                  = dir2Vec(GminnTheta,GminnPhi);

        Ghklminn                  = set2zeros(Ghklminn,teps);
        Ghklminn                  = set2ones(Ghklminn,teps);

        [~,loc]                   = unique(Ghklminn,'rows');
        GminnTP                   = [GminnTheta(loc),GminnPhi(loc)];
        Ghklminn                  = Ghklminn(loc,:);
%         [Gmminn,GminnTP,Ghklminn] = maxminSearch(GminnTP,@(x) -calcShear(x,nchi,S,ntheta2d,plane,'neg','3D'),teps);
%         Ghklminn                  = set2zeros(Ghklminn,teps);
%         Ghklminn                  = set2ones(Ghklminn,teps);
%         Gmminn                    = mean(Gmminn);

        Gmmin                     = Gmminn;
        GminTP                    = GminnTP;
        Ghklmin                   = Ghklminn;

        Re.Gminn    =  Gminn;
        Re.GminnTP  =  GminnTP;
        Re.Ghklminn =  Ghklminn;
    else
        Re.Gminn    =  [];
        Re.GminnTP  =  [];
        Re.Ghklminn =  [];
    end
    fprintf(fid,'%s\r','');
    fprintf(fid,'%s\r','=============================================================================================');
    fprintf(fid,'%s\r','        The maximum and minimum of Shear Modulus [Units in GPa] and its directions');
    fprintf(fid,'%s\r','=============================================================================================');
    fprintf(fid,'%s\r', ['Anisotropy of Shear Modulus: ',num2str(AG)]);
    fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
    fprintf(fid,'%s\t%s\t\r','Gmax','Gmin');
    fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [Gmmax Gmmin]);
    fprintf(fid,'%s\r','Direction for Gmax');
    fprintf(fid,'%s\t%s\t\r',' θ (Gmax)',' φ (Gmax)');
    fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], GmaxTP(end,:)');
    fprintf(fid,'%s\t%s\t%s\t\r','x (Gmax)','y (Gmax)','z (Gmax)');
    fprintf(fid,[repmat('%5.2f\t', 1, 3), '\n'], Ghklmax(end,:)');
    fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
    fprintf(fid,'%s\r','Direction for Gmin');
    fprintf(fid,'%s\t%s\t\r',' θ (Gmin)',' φ (Gmin)');
    fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], GminTP(end,:)');
    fprintf(fid,'%s\t%s\t%s\t\r','x (Gmin)','y (Gmin)','z (Gmin)');
    fprintf(fid,[repmat('%5.2f\t', 1, 3), '\n'], Ghklmin(end,:)');
end

if Pro(1,4)
    %% ========== Calculation of Poisson's Ratio  ====================================
    if Pro(1,1)
        [P,negFlagP]   = calcPoisson(thph,nchi,S1111,S,ntheta2d,plane,'normal','3D');
    else
        [~,S1111,~]       = calcYoung(thph,S,ntheta2d,plane,'3D');
        [P,negFlagP]   = calcPoisson(thph,nchi,S1111,S,ntheta2d,plane,'normal','3D');
    end
    AP             = calcAnisotropy(P);
    % calculating the maximum ,minimum positive and minimum negative of Poisson's Ratio and its directions.
    % maximum
    tmpPMax                   = getMaxMinNeg(P,'max');
    PMax                      = reshape(tmpPMax,nphi,ntheta);

    % save max Poisson's Ratio in .dat file
    PMaxFilename                   = strcat(filepath,filesep,fname,'_3D_Pmax.dat');
    fidPMax                        = fopen(PMaxFilename,'wt');
    %     fprintf(fidPMax,'%s\r','');
    %     fprintf(fidPMax,'%s\r',strcat(fname,'   maximum Poisson''s Ratio'));
    fprintf(fidPMax,formatD, PMax');
    fclose(fidPMax);

    Pmmax                     = max(tmpPMax);
    PmaxTheta                 = theta(PMax == Pmmax);
    PmaxPhi                   = phi(PMax == Pmmax);
    Phklmax                   = dir2Vec(PmaxTheta,PmaxPhi);

    Phklmax                   = set2zeros(Phklmax,teps);
    Phklmax                   = set2ones(Phklmax,teps);

    [~,loc]                   = unique(Phklmax,'rows');
    PmaxTP                    = [PmaxTheta(loc),PmaxPhi(loc)];
    Phklmax                   = Phklmax(loc,:);
%     [Pmmax,PmaxTP,Phklmax]    = maxminSearch(PmaxTP,@(x) -calcPoisson(x,nchi,S1111(tmpPMax ==Pmmax),S,ntheta2d,plane,'max','3D'),teps);
%     Phklmax                   = set2zeros(Phklmax,teps);
%     Phklmax                   = set2ones(Phklmax,teps);
%     Pmmax                     = mean(-Pmmax);

    % minimum positive
    tmpPMinp                  = getMaxMinNeg(P,'min');
    PMinp                     = reshape(tmpPMinp,nphi,ntheta);

    % save min positive Poisson's Ratio in .dat file
    PMinpFilename                   = strcat(filepath,filesep,fname,'_3D_Pminp.dat');
    fidPMinp                        = fopen(PMinpFilename,'wt');
    %     fprintf(fidPMinp,'%s\r','');
    %     fprintf(fidPMinp,'%s\r',strcat(fname,'   minimum positive Poisson''s Ratio'));
    fprintf(fidPMinp,formatD, PMinp');
    fclose(fidPMinp);

    Pmminp                    = min(tmpPMinp(tmpPMinp>0));
    PminpTheta                = theta(PMinp == Pmminp);
    PminpPhi                  = phi(PMinp == Pmminp);
    Phklminp                  = dir2Vec(PminpTheta,PminpPhi);

    Phklminp                  = set2zeros(Phklminp,teps);
    Phklminp                  = set2ones(Phklminp,teps);

    [~,loc]                   = unique(Phklminp,'rows');
    PminpTP                   = [PminpTheta(loc),PminpPhi(loc)];
    Phklminp                  = Phklminp(loc,:);
%     [Pmminp,PminpTP,Phklminp] = maxminSearch(PminpTP,@(x) calcPoisson(x,nchi,S1111(tmpPMinp == Pmminp),S,ntheta2d,plane,'min','3D'),teps);
%     Phklminp                  = set2zeros(Phklminp,teps);
%     Phklminp                  = set2ones(Phklminp,teps);
%     Pmminp                    = mean(Pmminp);

    Pmmin                     = Pmminp;
    PminTP                    = PminpTP;
    Phklmin                   = Phklminp;

    Re.P                      =  P;
    Re.PMax                   =  PMax;
    Re.Pmmax                  =  Pmmax;
    Re.PmaxTP                 =  PmaxTP;
    Re.Phklmax                =  Phklmax;
    Re.PMinp                  =  PMinp;
    Re.PminpTP                =  PminpTP;
    Re.Phklminp               =  Phklminp;

    if inputData.avgout
        Pavg                  = reshape(mean(P),nphi,ntheta);
        % save avg Shear Modulus in .dat file
        PavgFilename          = strcat(filepath,filesep,fname,'_3D_Pavg.dat');
        fidPavg               = fopen(PavgFilename,'wt');
        %     fprintf(fidPavg,'%s\r','');
        %     fprintf(fidPavg,'%s\r',strcat(fname,'   average Poisson''s Ratio'));
        fprintf(fidPavg,formatD, Pavg');
        fclose(fidPavg);
        Re.Pavg               =  Pavg;
    end

    % minimum negative
    if negFlagP
        tmpPMinn                  = getMaxMinNeg(P,'neg');
        PMinn                     = reshape(tmpPMinn,nphi,ntheta);

        % save min positive Shear Modulus in .dat file
        PMinnFilename                   = strcat(filepath,filesep,fname,'_3D_Pminn.dat');
        fidPMinn                        = fopen(PMinnFilename,'wt');
        %         fprintf(fidPMinn,'%s\r','');
        %         fprintf(fidPMinn,'%s\r',strcat(fname,'   minimum negative Poisson''s Ratio'));
        fprintf(fidPMinn,formatD, PMinn');
        fclose(fidPMinn);

        Pmminn                    = max(tmpPMinn);
        PminnTheta                = theta(PMinn == Pmminn);
        PminnPhi                  = phi(PMinn == Pmminn);
        Phklminn                  = dir2Vec(PminnTheta,PminnPhi);

        Phklminn                  = set2zeros(Phklminn,teps);
        Phklminn                  = set2ones(Phklminn,teps);

        [~,loc]                   = unique(Phklminn,'rows');
        PminnTP                   = [PminnTheta(loc),PminnPhi(loc)];
        Phklminn                  = Phklminn(loc,:);
%         [Pmminn,PminnTP,Phklminn] = maxminSearch(PminnTP,@(x) -calcPoisson(x,nchi,S1111(tmpPMinn ==Pmminn),S,ntheta2d,plane,'neg','3D'),teps);
%         Phklminn                  = set2zeros(Phklminn,teps);
%         Phklminn                  = set2ones(Phklminn,teps);
%         Pmminn                    = mean(Pmminn);

        Pmmin                     = -Pmminn;
        PminTP                    = PminnTP;
        Phklmin                   = Phklminn;

        Re.PMinn    =  PMinn;
        Re.PminnTP  =  PminnTP;
        Re.Phklminn =  Phklminn;
    else
        Re.PMinn    =  [];
        Re.PminnTP  =  [];
        Re.Phklminn =  [];
    end

    fprintf(fid,'%s\r','');
    fprintf(fid,'%s\r','=============================================================================================');
    fprintf(fid,'%s\r','        The maximum and minimum of Poisson''s Ratio and its directions');
    fprintf(fid,'%s\r','=============================================================================================');
    fprintf(fid,'%s\r', ['Anisotropy of Poisson''s Ratio: ',num2str(AP)]);
    fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
    fprintf(fid,'%s\t%s\t\r','PMax','Pmin');
    fprintf(fid,[repmat('%5.4f\t',1,2),'\n'], [Pmmax Pmmin]);
    fprintf(fid,'%s\r','Direction for PMax');
    fprintf(fid,'%s\t%s\t\r',' θ (Pmax)',' φ (Pmax)');
    fprintf(fid,[repmat('%5.4f\t', 1, 2), '\n'], PmaxTP(end,:)');
    fprintf(fid,'%s\t%s\t%s\t\r','x (PMax)','y (PMax)','z (PMax)');
    fprintf(fid,[repmat('%5.4f\t', 1, 3), '\n'],Phklmax(end,:)');
    fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
    fprintf(fid,'%s\r','Direction for Pmin');
    fprintf(fid,'%s\t%s\t\r',' θ (Pmin)',' φ (Pmin)');
    fprintf(fid,[repmat('%5.4f\t', 1, 2), '\n'], PminTP(end,:)');
    fprintf(fid,'%s\t%s\t%s\t\r','x (Pmin)','y (Pmin)','z (Pmin)');
    fprintf(fid,[repmat('%5.4f\t', 1, 3), '\n'], Phklmin(end,:)');
end

if Pro(1,5)
    %% ========== Calculation of Bulk Modulus =======================================
    [tmpB,negFlagB]  = calcBulk(thph,S,ntheta2d,plane,'3D');
    B                = reshape(tmpB,nphi,ntheta);
    AB               = calcAnisotropy(tmpB);
    % save Bulk Modulus in .dat file
    if negFlagB
        % Positive
        tmpBp           = getPosNeg(tmpB,'pos');
        Bpos            = reshape(tmpBp,nphi,ntheta);
        % save positive Bulk Modulus in .dat file
        BpFilename      = strcat(filepath,filesep,fname,'_3D_B.dat');
        fidBp           = fopen(BpFilename,'wt');
        fprintf(fidBp,formatD, Bpos');
        fclose(fidBp);

        tmpBn              = getPosNeg(tmpB,'neg');
        Bneg               = -reshape(tmpBn,nphi,ntheta);
        % save negtitive Bulk Modulus in .dat file
        BnFilename         = strcat(filepath,filesep,fname,'_3D_Bneg.dat');
        fidBn              = fopen(BnFilename,'wt');
        fprintf(fidBn,formatD, Bneg');
        fclose(fidBn);

        Re.B               = Bpos;
        Re.Bneg            = Bneg;
    else
        % save Bulk Modulus in .dat file
        BpFilename         = strcat(filepath,filesep,fname,'_3D_B.dat');
        fidBp              = fopen(BpFilename,'wt');
        fprintf(fidBp,formatD, B');
        fclose(fidBp);

        Re.B               =  B;
        Re.Bneg            = [];
    end

    % calculating the maximum and minimum of Bulk Modulus and its directions.
    Bmax                   = max(tmpB);
    BmaxTheta              = theta(B == Bmax);
    BmaxPhi                = phi(B == Bmax);
    Bhklmax                = dir2Vec(BmaxTheta,BmaxPhi);

    Bhklmax                = set2zeros(Bhklmax,teps);
    Bhklmax                = set2ones(Bhklmax,teps);

    [~,loc]                = unique(Bhklmax,'rows');
    BmaxTP                 = [BmaxTheta(loc),BmaxPhi(loc)];
    Bhklmax                = Bhklmax(loc,:);
%     [Bmax,BmaxTP,Bhklmax]  = maxminSearch(BmaxTP,@(x) -calcBulk(x,S,ntheta2d,plane,'3D'),teps);
%     Bhklmax                = set2zeros(Bhklmax,teps);
%     Bhklmax                = set2ones(Bhklmax,teps);
%     Bmax                   = mean(-Bmax);

    Bmin                   = min(tmpB);
    BminTheta              = theta(B == Bmin);
    BminPhi                = phi(B == Bmin);
    Bhklmin                = dir2Vec(BminTheta,BminPhi);

    Bhklmin                = set2zeros(Bhklmin,teps);
    Bhklmin                = set2ones(Bhklmin,teps);

    [~,loc]                = unique(Bhklmin,'rows');
    BminTP                 = [BminTheta(loc),BminPhi(loc)];
    Bhklmin                = Bhklmin(loc,:);
%     [Bmin,BminTP,Bhklmin]  = maxminSearch(BminTP,@(x) calcBulk(x,S,ntheta2d,plane,'3D'),teps);
%     Bhklmin                = set2zeros(Bhklmin,teps);
%     Bhklmin                = set2ones(Bhklmin,teps);
%     Bmin                   = mean(Bmin);

    Re.Bmax                =  Bmax;
    Re.BmaxTP              =  BmaxTP;
    Re.Bhklmax             =  Bhklmax;
    Re.Bmin                =  Bmin;
    Re.BminTP              =  BminTP;
    Re.Bhklmin             =  Bhklmin;

    fprintf(fid,'%s\r','');
    fprintf(fid,'%s\r','=============================================================================================');
    fprintf(fid,'%s\r','       The maximum and minimum of Bulk Modulus [Units in GPa] and its directions');
    fprintf(fid,'%s\r','=============================================================================================');
    fprintf(fid,'%s\r', ['Anisotropy of Bulk Modulus: ',num2str(AB)]);
    fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
    fprintf(fid,'%s\t%s\t\r','Bmax','Bmin');
    fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [Bmax Bmin]);
    fprintf(fid,'%s\r','Direction for Bmax');
    fprintf(fid,'%s\t%s\t\r',' θ (Bmax)',' φ (Bmax)');
    fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], BmaxTP(end,:)');
    fprintf(fid,'%s\t%s\t%s\t\r','x (Bmax)','y (Bmax)','z (Bmax)');
    fprintf(fid,[repmat('%5.2f\t', 1, 3), '\n'], Bhklmax(end,:)');
    fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
    fprintf(fid,'%s\r','Direction for Bmin');
    fprintf(fid,'%s\t%s\t\r',' θ (Bmin)',' φ (Bmin)');
    fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], BminTP(end,:)');
    fprintf(fid,'%s\t%s\t%s\t\r','x (Bmin)','y (Bmin)','z (Bmin)');
    fprintf(fid,[repmat('%5.2f\t', 1, 3), '\n'], Bhklmin(end,:)');
end

if Pro(1,6)
    %% ========== Calculation of Pugh ratio ========================================

    if Pro(1,3) % For Shear input
        Gin     = G;
    else
        Gin     = calcShear(thph,nchi,S,ntheta2d,plane,'normal','3D');
    end

    if Pro(1,5) % For Bulk input
        Bin     = repmat(tmpB',nchi,1);
    else
        tmpB    = calcBulk(thph,S,ntheta2d,plane,'3D');
        Bin     = repmat(tmpB',nchi,1);
    end

    if ~isempty(Gin) && ~isempty(Bin)
        Pr               = calcPugh(Bin,Gin);
        APr              = calcAnisotropy(Pr);
        % calculating the maximum and minimum of  Pugh ratio and its directions.
        Prmax                  = reshape(max(Pr),nphi,ntheta);

        % save max Vickers hardness in .dat file
        PrmaxFilename          = strcat(filepath,filesep,fname,'_3D_Prmax.dat');
        fidPrmax               = fopen(PrmaxFilename,'wt');
        fprintf(fidPrmax,formatD, Prmax');
        fclose(fidPrmax);

        Prmmax                 = max(Prmax(:));
        PrmaxTheta             = theta(Prmax == Prmmax);
        PrmaxPhi               = phi(Prmax == Prmmax);
        Prhklmax               = dir2Vec(PrmaxTheta,PrmaxPhi);

        Prhklmax               = set2zeros(Prhklmax,teps);
        Prhklmax               = set2ones(Prhklmax,teps);

        [~,loc]                = unique(roundN(Prhklmax,4),'rows');
        PrmaxTP                = [PrmaxTheta(loc),PrmaxPhi(loc)];
        Prhklmax               = dir2Vec(PrmaxTheta(loc),PrmaxPhi(loc));
        Prhklmax               = set2zeros(Prhklmax,teps);
        Prhklmax               = set2ones(Prhklmax,teps);

        Prmin                  = reshape(min(Pr),nphi,ntheta);
        % save min Pugh ratio in .dat file
        PrminFilename                   = strcat(filepath,filesep,fname,'_3D_Prmin.dat');
        fidPrmin                        = fopen(PrminFilename,'wt');
        fprintf(fidPrmin,formatD, Prmin');
        fclose(fidPrmin);

        Prmmin                 = min(Prmin(:));
        PrminTheta             = theta(Prmin == Prmmin);
        PrminPhi               = phi(Prmin == Prmmin);
        Prhklmin               = dir2Vec(PrminTheta,PrminPhi);

        Prhklmin               = set2zeros(Prhklmin,teps);
        Prhklmin               = set2ones(Prhklmin,teps);
        [~,loc]                = unique(roundN(Prhklmin,4),'rows');
        PrminTP                = [PrminTheta(loc),PrminPhi(loc)];
        Prhklmin               = dir2Vec(PrminTheta(loc),PrminPhi(loc));
        Prhklmin               = set2zeros(Prhklmin,teps);
        Prhklmin               = set2ones(Prhklmin,teps);

        Re.Pr                   = Pr;
        Re.Prmax                = Prmax;
        Re.Prmmax               = Prmmax;
        Re.PrmaxTP              = PrmaxTP;
        Re.Prhklmax             = Prhklmax;
        Re.Prmin                = Prmin;
        Re.Prmmin               = Prmmin;
        Re.PrminTP              = PrminTP;
        Re.Prhklmin             = Prhklmin;
        
        if inputData.avgout
            Pravg                = reshape(mean(Pr),nphi,ntheta);
            % save avg Pugh ratio in .dat file
            PravgFilename        = strcat(filepath,filesep,fname,'_3D_Pravg.dat');
            fidPravg             = fopen(PravgFilename,'wt');
            fprintf(fidPravg,formatD, Pravg');
            fclose(fidPravg);
            Re.Pravg             = Pravg;
        end

        fprintf(fid,'%s\r','');
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r','        The maximum and minimum of Pugh ratio and its directions');
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r', ['Anisotropy of Pugh ratio: ',num2str(APr)]);
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\t%s\t\r','PrMax','Prmin');
        fprintf(fid,[repmat('%5.4f\t',1,2),'\n'], [Prmmax Prmmin]);
        fprintf(fid,'%s\r','Direction for PrMax');
        fprintf(fid,'%s\t%s\t\r',' θ (Prmax)',' φ (Prmax)');
        fprintf(fid,[repmat('%5.4f\t', 1, 2), '\n'], PrmaxTP(end,:)');
        fprintf(fid,'%s\t%s\t%s\t\r','x (PrMax)','y (PrMax)','z (PrMax)');
        fprintf(fid,[repmat('%5.4f\t', 1, 3), '\n'],Prhklmax(end,:)');
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\r','Direction for Prmin');
        fprintf(fid,'%s\t%s\t\r',' θ (Prmin)',' φ (Prmin)');
        fprintf(fid,[repmat('%5.4f\t', 1, 2), '\n'], PrminTP(end,:)');
        fprintf(fid,'%s\t%s\t%s\t\r','x (Prmin)','y (Prmin)','z (Prmin)');
        fprintf(fid,[repmat('%5.4f\t', 1, 3), '\n'], Prhklmin(end,:)');
    end
end

if Pro(1,7) && ~isempty(inputData.HvModel)
    %% ========== Calculation of Vickers hardness ========================================
    switch(inputData.HvModel)
        case {'M','Mazhnik'}

            if Pro(1,1) % For Young input
                Uin     = repmat(tmpE',nchi,1);
            else
                [tmpE,~,~] = calcYoung(thph,S,ntheta2d,plane,'3D');
                Uin        = repmat(tmpE',nchi,1);
            end
            
            if Pro(1,4) % For Possion input
                Vin     = P;
            else
                %% ========== Calculation of Poisson's Ratio  ====================================
                if Pro(1,1)
                    [Vin,~]     = calcPoisson(thph,nchi,S1111,S,ntheta2d,plane,'normal','3D');
                else
                    [~,S1111,~] = calcYoung(thph,S,ntheta2d,plane,'3D');
                    [Vin,~]     = calcPoisson(thph,nchi,S1111,S,ntheta2d,plane,'normal','3D');
                end
            end

        case {'C','T','Chen','Tian'}

            if Pro(1,3) % For Shear input
                Uin     = G;
            else
                Uin     = calcShear(thph,nchi,S,ntheta2d,plane,'normal','3D');
            end

            if Pro(1,5) % For Bulk input
                Vin     = repmat(tmpB',nchi,1);
            else
                tmpB    = calcBulk(thph,S,ntheta2d,plane,'3D');
                Vin     = repmat(tmpB',nchi,1);
            end

    end
    if ~isempty(Uin) && ~isempty(Vin)
        Hv                = calcHardness(Uin,Vin,inputData.HvModel);
        AHv               = calcAnisotropy(Hv);
        % calculating the maximum and minimum of Vickers hardness and its directions.
        Hvmax                  = reshape(max(Hv),nphi,ntheta);

        % save max Vickers hardness in .dat file
        HvmaxFilename          = strcat(filepath,filesep,fname,'_3D_Hvmax.dat');
        fidHvmax               = fopen(HvmaxFilename,'wt');
        %         fprintf(fidHvmax,'%s\r','');
        %         fprintf(fidHvmax,'%s\r',strcat(fname,'   maximum Vickers hardness  [Units in GPa]'));
        fprintf(fidHvmax,formatD, Hvmax');
        fclose(fidHvmax);

        Hvmmax                 = max(Hvmax(:));
        HvmaxTheta             = theta(Hvmax == Hvmmax);
        HvmaxPhi               = phi(Hvmax == Hvmmax);
        Hvhklmax               = dir2Vec(HvmaxTheta,HvmaxPhi);

        Hvhklmax               = set2zeros(Hvhklmax,teps);
        Hvhklmax               = set2ones(Hvhklmax,teps);

        [~,loc]                = unique(roundN(Hvhklmax,4),'rows');
        HvmaxTP                = [HvmaxTheta(loc),HvmaxPhi(loc)];
        Hvhklmax               = dir2Vec(HvmaxTheta(loc),HvmaxPhi(loc));
        Hvhklmax               = set2zeros(Hvhklmax,teps);
        Hvhklmax               = set2ones(Hvhklmax,teps);

        Hvmin                  = reshape(min(Hv),nphi,ntheta);
        % save min Vickers hardness in .dat file
        HvminFilename                   = strcat(filepath,filesep,fname,'_3D_Hvmin.dat');
        fidHvmin                        = fopen(HvminFilename,'wt');
        %         fprintf(fidHvmin,'%s\r','');
        %         fprintf(fidHvmin,'%s\r',strcat(fname,'   minimum Vickers hardness [Units in GPa]'));
        fprintf(fidHvmin,formatD, Hvmin');
        fclose(fidHvmin);

        Hvmmin                 = min(Hvmin(:));
        HvminTheta             = theta(Hvmin == Hvmmin);
        HvminPhi               = phi(Hvmin == Hvmmin);
        Hvhklmin               = dir2Vec(HvminTheta,HvminPhi);

        Hvhklmin               = set2zeros(Hvhklmin,teps);
        Hvhklmin               = set2ones(Hvhklmin,teps);
        [~,loc]                = unique(roundN(Hvhklmin,4),'rows');
        HvminTP                = [HvminTheta(loc),HvminPhi(loc)];
        Hvhklmin               = dir2Vec(HvminTheta(loc),HvminPhi(loc));
        Hvhklmin               = set2zeros(Hvhklmin,teps);
        Hvhklmin               = set2ones(Hvhklmin,teps);

        Re.Hv                   = Hv;
        Re.Hvmax                = Hvmax;
        Re.Hvmmax               = Hvmmax;
        Re.HvmaxTP              = HvmaxTP;
        Re.Hvhklmax             = Hvhklmax;
        Re.Hvmin                = Hvmin;
        Re.Hvmmin               = Hvmmin;
        Re.HvminTP              = HvminTP;
        Re.Hvhklmin             = Hvhklmin;

        if inputData.avgout
            Hvavg                = reshape(mean(Hv),nphi,ntheta);
            % save avg Vickers hardness in .dat file
            HvavgFilename                   = strcat(filepath,filesep,fname,'_3D_Hvavg.dat');
            fidHvavg                        = fopen(HvavgFilename,'wt');
            %         fprintf(fidHvavg,'%s\r','');
            %         fprintf(fidHvavg,'%s\r',strcat(fname,'   average Vickers hardness [Units in GPa]'));
            fprintf(fidHvavg,formatD, Hvavg');
            fclose(fidHvavg);
            Re.Hvavg                = Hvavg;
        end

        fprintf(fid,'%s\r','');
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r','        The maximum and minimum of Vickers hardness [Units in GPa] and its directions');
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r', ['Anisotropy of Vickers hardness: ',num2str(AHv)]);
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\t%s\t\r','HvMax','Hvmin');
        fprintf(fid,[repmat('%5.4f\t',1,2),'\n'], [Hvmmax Hvmmin]);
        fprintf(fid,'%s\r','Direction for HvMax');
        fprintf(fid,'%s\t%s\t\r',' θ (Hvmax)',' φ (Hvmax)');
        fprintf(fid,[repmat('%5.4f\t', 1, 2), '\n'], HvmaxTP(end,:)');
        fprintf(fid,'%s\t%s\t%s\t\r','x (HvMax)','y (HvMax)','z (HvMax)');
        fprintf(fid,[repmat('%5.4f\t', 1, 3), '\n'],Hvhklmax(end,:)');
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\r','Direction for Hvmin');
        fprintf(fid,'%s\t%s\t\r',' θ (Hvmin)',' φ (Hvmin)');
        fprintf(fid,[repmat('%5.4f\t', 1, 2), '\n'], HvminTP(end,:)');
        fprintf(fid,'%s\t%s\t%s\t\r','x (Hvmin)','y (Hvmin)','z (Hvmin)');
        fprintf(fid,[repmat('%5.4f\t', 1, 3), '\n'], Hvhklmin(end,:)');
    end
end

if Pro(1,8) && ~isempty(inputData.KIC.model)
    %% ========== Calculation of Fracture Toughness ========================================
    switch(inputData.KIC.model)
        case {'M','Mazhnik'}

            if Pro(1,1) % For Young input
                UKin     = repmat(tmpE',nchi,1);
            else
                [tmpE,~,~] = calcYoung(thph,S,ntheta2d,plane,'3D');
                UKin       = repmat(tmpE',nchi,1);
            end
            
            if Pro(1,4) % For Possion input
                VKin     = P;
            else
                %% ========== Calculation of Poisson's Ratio  ====================================
                if Pro(1,1)
                    [VKin,~]    = calcPoisson(thph,nchi,S1111,S,ntheta2d,plane,'normal','3D');
                else
                    [~,S1111,~] = calcYoung(thph,S,ntheta2d,plane,'3D');
                    [VKin,~]    = calcPoisson(thph,nchi,S1111,S,ntheta2d,plane,'normal','3D');
                end
            end

        case {'N','Niu'}

            if Pro(1,3) % For Shear input
                UKin     = G;
            else
                UKin     = calcShear(thph,nchi,S,ntheta2d,plane,'normal','3D');
            end

            if Pro(1,5) % For Bulk input
                VKin     = repmat(tmpB',nchi,1);
            else
                tmpB    = calcBulk(thph,S,ntheta2d,plane,'3D');
                VKin     = repmat(tmpB',nchi,1);
            end
    end
    if ~isempty(UKin) && ~isempty(VKin)

        Kic              = calcFractureToughness(UKin,VKin,inputData.KIC);
        AKic             = calcAnisotropy(Kic);
        % calculating the maximum and minimum of Fracture Toughness and its directions.
        Kicmax                  = reshape(max(Kic),nphi,ntheta);

        % save max Fracture Toughness in .dat file
        KicmaxFilename          = strcat(filepath,filesep,fname,'_3D_Kicmax.dat');
        fidKicmax               = fopen(KicmaxFilename,'wt');
        fprintf(fidKicmax,formatD, Kicmax');
        fclose(fidKicmax);

        Kicmmax                 = max(Kicmax(:));
        KicmaxTheta             = theta(Kicmax == Kicmmax);
        KicmaxPhi               = phi(Kicmax == Kicmmax);
        Kichklmax               = dir2Vec(KicmaxTheta,KicmaxPhi);

        Kichklmax               = set2zeros(Kichklmax,teps);
        Kichklmax               = set2ones(Kichklmax,teps);

        [~,loc]                = unique(roundN(Kichklmax,4),'rows');
        KicmaxTP                = [KicmaxTheta(loc),KicmaxPhi(loc)];
        Kichklmax               = dir2Vec(KicmaxTheta(loc),KicmaxPhi(loc));
        Kichklmax               = set2zeros(Kichklmax,teps);
        Kichklmax               = set2ones(Kichklmax,teps);

        Kicmin                  = reshape(min(Kic),nphi,ntheta);
        % save min Fracture Toughness in .dat file
        KicminFilename                  = strcat(filepath,filesep,fname,'_3D_Kicmin.dat');
        fidKicmin                        = fopen(KicminFilename,'wt');
        fprintf(fidKicmin,formatD, Kicmin');
        fclose(fidKicmin);

        Kicmmin                 = min(Kicmin(:));
        KicminTheta             = theta(Kicmin == Kicmmin);
        KicminPhi               = phi(Kicmin == Kicmmin);
        Kichklmin               = dir2Vec(KicminTheta,KicminPhi);

        Kichklmin               = set2zeros(Kichklmin,teps);
        Kichklmin               = set2ones(Kichklmin,teps);
        [~,loc]                 = unique(roundN(Kichklmin,4),'rows');
        KicminTP                = [KicminTheta(loc),KicminPhi(loc)];
        Kichklmin               = dir2Vec(KicminTheta(loc),KicminPhi(loc));
        Kichklmin               = set2zeros(Kichklmin,teps);
        Kichklmin               = set2ones(Kichklmin,teps);

        Re.Kic                   = Kic;
        Re.Kic                   = Kicmax;
        Re.Kicmmax               = Kicmmax;
        Re.KicmaxTP              = KicmaxTP;
        Re.Kichklmax             = Kichklmax;
        Re.Kicmin                = Kicmin;
        Re.Kicmmin               = Kicmmin;
        Re.KicminTP              = KicminTP;
        Re.Kichklmin             = Kichklmin;

        if inputData.avgout
            Kicavg                = reshape(mean(Kic),nphi,ntheta);
            % save avg Fracture Toughness in .dat file
            KicavgFilename        = strcat(filepath,filesep,fname,'_3D_Kicavg.dat');
            fidKicavg             = fopen(KicavgFilename,'wt');
            fprintf(fidKicavg,formatD, Kicavg');
            fclose(fidKicavg);
            Re.Kicavg             = Kicavg;
        end

        fprintf(fid,'%s\r','');
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r','        The maximum and minimum of Fracture Toughness [Units in MPa m^(1/2)] and its directions');
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r', ['Anisotropy of Fracture Toughness: ',num2str(AKic)]);
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\t%s\t\r','KicMax','Kicmin');
        fprintf(fid,[repmat('%5.4f\t',1,2),'\n'], [Kicmmax Kicmmin]);
        fprintf(fid,'%s\r','Direction for KicMax');
        fprintf(fid,'%s\t%s\t\r',' θ (Kicmax)',' φ (Kicmax)');
        fprintf(fid,[repmat('%5.4f\t', 1, 2), '\n'], KicmaxTP(end,:)');
        fprintf(fid,'%s\t%s\t%s\t\r','x (KicMax)','y (KicMax)','z (KicMax)');
        fprintf(fid,[repmat('%5.4f\t', 1, 3), '\n'],Kichklmax(end,:)');
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\r','Direction for Hvmin');
        fprintf(fid,'%s\t%s\t\r',' θ (Kicmin)',' φ (Kicmin)');
        fprintf(fid,[repmat('%5.4f\t', 1, 2), '\n'], KicminTP(end,:)');
        fprintf(fid,'%s\t%s\t%s\t\r','x (Hvmin)','y (Kicmin)','z (Kicmin)');
        fprintf(fid,[repmat('%5.4f\t', 1, 3), '\n'], Kichklmin(end,:)');
    end
end

%% 2D plane
lenC = size(plane,1);

for pk = 1:lenC
    theta2d              = linspace(0,2*pi+eps,ntheta2d)';
    Re(pk).theta2d       = theta2d;
    planeC               = plane(pk,:);
    planeName            = strrep(num2str(planeC),' ','');
    if Pro(2,1)
       %% Young's Modulus in PlaneC
        [E2d,S11112d,negFlagE2d]    = calcYoung([],S,ntheta2d,planeC,'2D');
        AE2d                        = calcAnisotropy(E2d);
        % save 2D Young's Modulus in .dat file, first column is angle and second column is young's modulus.
        if negFlagE2d
            E2dpos        = getPosNeg(E2d,'pos');
            E2dneg        = -getPosNeg(E2d,'neg');
            % save 2D Young's Modulus in .dat file, first column is angle, second and third column are Young's Modulus.
            tFilename                   = strcat(filepath,filesep,fname,'_2D_E(',planeName,').dat');
            fidt                        = fopen(tFilename,'wt');
            fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\n', [theta2d E2dpos E2dneg]');
            fclose(fidt);

            Re(pk).E2d               = E2dpos;
            Re(pk).E2dneg            = E2dneg;
        else
            % save 2D Young's Modulus in .dat file, first column is angle and second column is Young's Modulus.
            tFilename                   = strcat(filepath,filesep,fname,'_2D_E(',planeName,').dat');
            fidt                        = fopen(tFilename,'wt');
            fprintf(fidt,'%5.4f\t%5.4f\n', [theta2d E2d]');
            fclose(fidt);

            Re(pk).E2d               = E2d;
            Re(pk).E2dneg            = [];
        end

        % calculating the maximum and minimum of Young's Modulus and its directions.
        E2dmax                   = max(E2d);
        E2dmaxTheta              = theta2d(E2d == E2dmax);
%         [E2dmax,E2dmaxTheta,~]   = maxminSearch(E2dmaxTheta,@(x) -calcYoung(x,S,ntheta2d,planeC,'2D'),teps);
        E2dmaxTheta              = unique(E2dmaxTheta);
        E2dmaxXY                 = dir2Vec2d(E2dmaxTheta);
%         E2dmax                   = mean(-E2dmax);

        E2dmin                   = min(E2d);
        E2dminTheta              = theta2d(E2d == E2dmin);
%         [E2dmin,E2dminTheta,~]   = maxminSearch(E2dminTheta,@(x) calcYoung(x,S,ntheta2d,planeC,'2D'),teps);
        E2dminTheta              = unique(E2dminTheta);
        E2dminXY                 = dir2Vec2d(E2dminTheta);
%         E2dmin                   = mean(E2dmin);

        Re(pk).E2d               = E2d;
        Re(pk).E2dmax            = E2dmax;
        Re(pk).E2dmaxTheta       = E2dmaxTheta;
        Re(pk).E2dmaxXY          = E2dmaxXY;
        Re(pk).E2dmin            = E2dmin;
        Re(pk).E2dminTheta       = E2dminTheta;
        Re(pk).E2dminXY          = E2dminXY;

        fprintf(fid,'%s\r','');
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r',strcat(' The maximum and minimum of Young''s Modulus [Units in GPa] and its directions in plane (',planeName,')'));
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r', ['Anisotropy of Young''s Modulus in plane (',planeName,')',': ',num2str(AE2d)]);
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\t%s\t\r','E2dmax','E2dmin');
        fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [E2dmax E2dmin]);
        fprintf(fid,'%s\r','Direction for E2dmax');
        fprintf(fid,'%s\t\r',' θ (E2dmax)');
        fprintf(fid,'%5.2f\t\n', E2dmaxTheta(end,:));
        fprintf(fid,'%s\t%s\t\r','x (E2dmax)','y (E2dmax)');
        fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], E2dmaxXY(end,:));
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\r','Direction for E2dmin');
        fprintf(fid,'%s\t\r',' θ (E2dmin)');
        fprintf(fid,'%5.2f\t\n', E2dminTheta(end,:));
        fprintf(fid,'%s\t%s\t\r','x (E2dmin)','y (E2dmin)');
        fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], E2dminXY(end,:));
    end

    if Pro(2,2)
        %% Linear compressibility in PlaneC
        [beta2d,negFlagbeta2d] = calcCompress([],S,ntheta2d,planeC,'2D');
        Abeta2d                = calcAnisotropy(beta2d);
        % calculating the maximum and minimum of Linear compressibility and its directions.
        beta2dmax                     = max(beta2d);
        beta2dmaxTheta                = theta2d(beta2d == beta2dmax);
%         [beta2dmax,beta2dmaxTheta,~]  = maxminSearch(beta2dmaxTheta,@(x) -calcCompress(x,S,ntheta2d,planeC,'2D'),teps);
        beta2dmaxTheta                = unique(beta2dmaxTheta);
        beta2dmaxXY                   = dir2Vec2d(beta2dmaxTheta);
%         beta2dmax                     = mean(-beta2dmax);

        beta2dmin                     = min(beta2d);
        beta2dminTheta                = theta2d(beta2d == beta2dmin);
%         [beta2dmin,beta2dminTheta,~]  = maxminSearch(beta2dminTheta,@(x) calcCompress(x,S,ntheta2d,planeC,'2D'),teps);
        beta2dminTheta                = unique(beta2dminTheta);
        beta2dminXY                   = dir2Vec2d(beta2dminTheta);
%         beta2dmin                     = mean(beta2dmin);
        Re(pk).beta2dneg              = [];

        Re(pk).beta2dmax                = beta2dmax;
        Re(pk).beta2dmaxTheta           = beta2dmaxTheta;
        Re(pk).beta2dmaxXY              = beta2dmaxXY;
        Re(pk).beta2dmin                = beta2dmin;
        Re(pk).beta2dminTheta           = beta2dminTheta;
        Re(pk).beta2dminXY              = beta2dminXY;
        Re(pk).beta2davg                = mean(beta2d);

        if negFlagbeta2d
            beta2dpos        = getPosNeg(beta2d,'pos');
            beta2dneg        = -getPosNeg(beta2d,'neg');
            % save 2D Linear compressibility in .dat file, first column is angle, second and third column are Linear compressibility.
            tFilename                   = strcat(filepath,filesep,fname,'_2D_beta(',planeName,').dat');
            fidt                        = fopen(tFilename,'wt');
            fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\n', [theta2d beta2dpos beta2dneg]');
            fclose(fidt);

            Re(pk).beta2d               = beta2dpos;
            Re(pk).beta2dneg            = beta2dneg;
        else
            % save 2D Linear compressibility in .dat file, first column is angle and second column is Linear compressibility.
            tFilename                   = strcat(filepath,filesep,fname,'_2D_beta(',planeName,').dat');
            fidt                        = fopen(tFilename,'wt');
            fprintf(fidt,'%5.4f\t%5.4f\n', [theta2d beta2d]');
            fclose(fidt);

            Re(pk).beta2d               = beta2d;
            Re(pk).beta2dneg            = [];
        end

        fprintf(fid,'%s\r','');
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r',strcat(' The maximum and minimum of Linear Compressibility [Units in GPa] and its directions in plane (',planeName,')'));
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r', ['Anisotropy of Linear Compressibility in plane (',planeName,')',': ',num2str(Abeta2d)]);
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\t%s\t\r','beta2dmax','beta2dmin');
        fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [beta2dmax beta2dmin]);
        fprintf(fid,'%s\r','Direction for beta2dmax');
        fprintf(fid,'%s\t\r',' θ (beta2dmax)');
        fprintf(fid,'%5.2f\t\n', beta2dmaxTheta(end,:));
        fprintf(fid,'%s\t%s\t\r','x (beta2dmax)','y (beta2dmax)');
        fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], beta2dmaxXY(end,:));
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\r','Direction for beta2dmin');
        fprintf(fid,'%s\t\r',' θ (beta2dmin)');
        fprintf(fid,'%5.2f\t\n', beta2dminTheta(end,:));
        fprintf(fid,'%s\t%s\t\r','x (beta2dmin)','y (beta2dmin)');
        fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], beta2dminXY(end,:));
    end

    if Pro(2,3)
        %% Shear Modulus in PlaneC
        [G2d,negFlagG]            = calcShear([],nchi,S,ntheta2d,planeC,'normal','2D');
        AG2d                      = calcAnisotropy(G2d);
        % calculating the maximum and minimum of Shear Modulus and its directions.
        % maximum
        G2dmax                    = getMaxMinNeg(G2d,'max')';

        G2dmmax                   = max(G2d(:));
        G2dmaxTheta               = theta2d(G2dmax == G2dmmax);
%         [G2dmmax,G2dmaxTheta,~]   = maxminSearch(G2dmaxTheta,@(x) -calcShear(x,nchi,S,ntheta2d,planeC,'max','2D'),teps);
        G2dmaxTheta               = unique(G2dmaxTheta);
        G2dmaxXY                  = dir2Vec2d(G2dmaxTheta);
%         G2dmmax                   = mean(-G2dmmax);

        G2dminp                   = getMaxMinNeg(G2d,'min')';
        G2dmminp                  = min(G2dminp(:));
        G2dminpTheta              = theta2d(G2dminp == G2dmminp);
%         [G2dmminp,G2dminpTheta,~] = maxminSearch(G2dminpTheta,@(x) calcShear(x,nchi,S,ntheta2d,planeC,'min','2D'),teps);
        G2dminpTheta               = unique(G2dminpTheta);
        G2dminpXY                 = dir2Vec2d(G2dminpTheta);
%         G2dmminp                  = mean(G2dmminp);

        G2dmin                    = G2dmminp;
        G2dminTheta               = G2dminpTheta;
        G2dminXY                  = G2dminpXY;

        Re(pk).G2d                = G2d;
        Re(pk).G2dmax             = G2dmax;
        Re(pk).G2dmmax            = G2dmmax;
        Re(pk).G2dmaxTheta        = G2dmaxTheta;
        Re(pk).G2dmaxXY           = G2dmaxXY;
        Re(pk).G2dminp            = G2dminp;
        Re(pk).G2dmminp           = G2dmminp;
        Re(pk).G2dminpTheta       = G2dminpTheta;
        Re(pk).G2dminpXY          = G2dminpXY;

        % minimum negative
        if negFlagG
            G2dminn                   = getMaxMinNeg(G2d,'neg')';

            G2dmminn                  = max(G2dminn);
            G2dminnTheta              = theta2d(G2dminn == G2dmminn);
%             [G2dmminn,G2dminnTheta,~] = maxminSearch(G2dminnTheta,@(x) -calcShear(x,nchi,S,ntheta2d,planeC,'neg','2D'),teps);
            G2dminnTheta              = unique(G2dminnTheta);
            G2dminnXY                 = dir2Vec2d(G2dminnTheta);
%             G2dmminn                  = mean(G2dmminn);

            G2dmin                    = G2dmminn;
            G2dminTheta               = G2dminnTheta;
            G2dminXY                  = G2dminnXY;

            % save 2D Shear Modulus in .dat file. The first column is angle,
            % and second column is maximum,minimum positive,minimum negative,average Shear Modulus.
            tFilename                   = strcat(filepath,filesep,fname,'_2D_G(',planeName,').dat');
            fidt                        = fopen(tFilename,'wt');
            if inputData.avgout
                G2davg                  = mean(G2d)';
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\t%5.4f\t%5.4f\n', [theta2d G2dmax G2dminp G2dminn G2davg]');
                Re(pk).G2davg           = G2davg;
            else
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\t%5.4f\n', [theta2d G2dmax G2dminp G2dminn]');
            end

            fclose(fidt);

            Re(pk).G2dminn                =  G2dminn;
            Re(pk).G2dmminn               =  G2dmminn;
            Re(pk).G2dminnTheta           =  G2dminnTheta;
            Re(pk).G2dminnXY              =  G2dminnXY;
        else
            % save 2D Shear Modulus in .dat file. The first column is angle,
            % and second column is maximum, minimum positive, minimum negative, average Shear Modulus.
            tFilename                   = strcat(filepath,filesep,fname,'_2D_G(',planeName,').dat');
            fidt                        = fopen(tFilename,'wt');
            if inputData.avgout
                G2davg                  = mean(G2d)';
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\t%5.4f\n', [theta2d G2dmax G2dminp G2davg]');
                Re(pk).G2davg            = G2davg;
            else
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\n', [theta2d G2dmax G2dminp]');
            end
            fclose(fidt);

            Re(pk).G2dminn                =  [];
            Re(pk).G2dmminn               =  [];
            Re(pk).G2dminnTheta           =  [];
        end

        Re(pk).G2dmin            = G2dmin;
        Re(pk).G2dminTheta       = G2dminTheta;
        Re(pk).G2dminXY          = G2dminXY;

        fprintf(fid,'%s\r','');
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r',strcat(' The maximum and minimum of Shear Modulus [Units in GPa] and its directions in plane (',planeName,')'));
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r', ['Anisotropy of Shear Modulus in plane (',planeName,')',': ',num2str(AG2d)]);
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\t%s\t\r','G2dmax','G2dmin');
        fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [G2dmmax G2dmin]);
        fprintf(fid,'%s\r','Direction for G2dmax');
        fprintf(fid,'%s\t\r',' θ (G2dmax)');
        fprintf(fid,'%5.2f\t\n', G2dmaxTheta(end,:));
        fprintf(fid,'%s\t%s\t\r','x (G2dmax)','y (G2dmax)');
        fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], G2dmaxXY(end,:));
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\r','Direction for G2dmin');
        fprintf(fid,'%s\t\r',' θ (G2dmin)');
        fprintf(fid,'%5.2f\t\n', G2dminTheta(end,:));
        fprintf(fid,'%s\t%s\t\r','x (G2dmin)','y (G2dmin)');
        fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], G2dminXY(end,:));
    end

    if Pro(2,4)
        %% Poisson's Ratio in PlaneC
        if Pro(2,1)
            [P2d,negFlagP]   = calcPoisson([],nchi,S11112d,S,ntheta2d,planeC,'normal','2D');
        else
            [~,S11112d,~]    = calcYoung([],S,ntheta2d,planeC,'2D');
            [P2d,negFlagP]   = calcPoisson([],nchi,S11112d,S,ntheta2d,planeC,'normal','2D');
        end
        AP2d                        = calcAnisotropy(P2d);
        % calculating the maximum ,minimum positive and minimum negative of Poisson's Ratio and its directions.
        % maximum
        P2dmax                    = getMaxMinNeg(P2d,'max')';

        P2dmmax                   = max(P2d(:));
        P2dmaxTheta               = theta2d(P2dmax == P2dmmax);
%         [P2dmmax,P2dmaxTheta,~]   = maxminSearch(P2dmaxTheta,@(x) -calcPoisson(x,nchi,S11112d(P2dmax == P2dmmax),S,ntheta2d,planeC,'max','2D'),teps);
        P2dmaxTheta               = unique(P2dmaxTheta);
        P2dmaxXY                  = dir2Vec2d(P2dmaxTheta);
%         P2dmmax                   = mean(-P2dmmax);

        P2dminp                   = getMaxMinNeg(P2d,'min')';
        P2dmminp                  = min(P2dminp(:));
        P2dminpTheta              = theta2d(P2dminp == P2dmminp);
%         [P2dmminp,P2dminpTheta,~] = maxminSearch(P2dminpTheta,@(x) calcPoisson(x,nchi,S11112d(P2dminp == P2dmminp),S,ntheta2d,planeC,'min','2D'),teps);
        P2dminpTheta               = unique(P2dminpTheta);
        P2dminpXY                 = dir2Vec2d(P2dminpTheta);
%         P2dmminp                  = mean(P2dmminp);

        P2dmin                    = P2dmminp;
        P2dminTheta               = P2dminpTheta;
        P2dminXY                  = P2dminpXY;

        Re(pk).P2d                = P2d;
        Re(pk).P2dmax             = P2dmax;
        Re(pk).P2dmmax            = P2dmmax;
        Re(pk).P2dmaxTheta        = P2dmaxTheta;
        Re(pk).P2dmaxXY           = P2dmaxXY;
        Re(pk).P2dminp            = P2dminp;
        Re(pk).P2dmminp           = P2dmminp;
        Re(pk).P2dminpTheta       = P2dminpTheta;
        Re(pk).P2dminpXY          = P2dminpXY;

        % minimum negative
        if negFlagP
            P2dminn                   = getMaxMinNeg(P2d,'neg')';

            P2dmminn                  = max(P2dminn);
            P2dminnTheta              = theta2d(P2dminn == P2dmminn);
%             [P2dmminn,P2dminnTheta,~] = maxminSearch(P2dminnTheta,@(x) -calcPoisson(x,nchi,S11112d(P2dminn == P2dmminn),S,ntheta2d,planeC,'neg','2D'),teps);
            P2dminnTheta              = unique(P2dminnTheta);
            P2dminnXY                 = dir2Vec2d(P2dminnTheta);
%             P2dmminn                  = mean(P2dmminn);

            P2dmin                    = P2dmminn;
            P2dminTheta               = P2dminnTheta;
            P2dminXY                  = P2dminnXY;

            % save 2D Poisson's Ratio in .dat file. The first column is angle,
            % and second column is maximum,minimum positive,minimum negative,average Poisson's Ratio.
            tFilename                   = strcat(filepath,filesep,fname,'_2D_P(',planeName,').dat');
            fidt                        = fopen(tFilename,'wt');
            if inputData.avgout
                P2davg                  = mean(P2d)';
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\t%5.4f\t%5.4f\n', [theta2d P2dmax P2dminp P2dminn P2davg]');
                Re(pk).P2davg           = P2davg;
            else
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\t%5.4f\n', [theta2d P2dmax P2dminp P2dminn]');
            end
            fclose(fidt);

            Re(pk).P2dminn                =  P2dminn;
            Re(pk).P2dmminn               =  P2dmminn;
            Re(pk).P2dminnTheta           =  P2dminnTheta;
        else
            % save 2D Poisson's Ratio in .dat file. The first column is angle,
            % and second column is maximum, minimum positive, minimum negative, average Poisson's Ratio.
            tFilename                   = strcat(filepath,filesep,fname,'_2D_P(',planeName,').dat');
            fidt                        = fopen(tFilename,'wt');
            if inputData.avgout
                P2davg                  = mean(P2d)';
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\t%5.4f\n', [theta2d P2dmax P2dminp P2davg]');
                Re(pk).P2davg           = P2davg;
            else
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\n', [theta2d P2dmax P2dminp]');
            end
            fclose(fidt);

            Re(pk).P2dminn                =  [];
            Re(pk).P2dmminn               =  [];
            Re(pk).P2dminnTheta           =  [];
        end

        Re(pk).P2dmin                    = P2dmin;
        Re(pk).P2dminTheta               = P2dminTheta;
        Re(pk).P2dminXY                  = P2dminXY;

        fprintf(fid,'%s\r','');
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r',strcat(' The maximum and minimum of Poisson''s Ratio [Units in GPa] and its directions in plane (',planeName,')'));
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r', ['Anisotropy of Poisson''s Ratio in plane (',planeName,')',': ',num2str(AP2d)]);
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\t%s\t\r','P2dmax','P2dmin');
        fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [P2dmmax P2dmin]);
        fprintf(fid,'%s\r','Direction for P2dmax');
        fprintf(fid,'%s\t\r',' θ (P2dmax)');
        fprintf(fid,'%5.2f\t\n', P2dmaxTheta(end,:));
        fprintf(fid,'%s\t%s\t\r','x (P2dmax)','y (P2dmax)');
        fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], P2dmaxXY(end,:));
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\r','Direction for P2dmin');
        fprintf(fid,'%s\t\r',' θ (P2dmin)');
        fprintf(fid,'%5.2f\t\n', P2dminTheta(end,:));
        fprintf(fid,'%s\t%s\t\r','x (P2dmin)','y (P2dmin)');
        fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], P2dminXY(end,:));
    end

    if Pro(2,5)
        %% Bulk Modulus in PlaneC
        [B2d,negFlagB2d]  = calcBulk([],S,ntheta2d,planeC,'2D');
        AB2d              = calcAnisotropy(B2d);
        % save 2D Bulk Modulus in .dat file, first column is angle and second column is Bulk Modulus.
        if negFlagB2d
            B2dpos        = getPosNeg(B2d,'pos');
            B2dneg        = -getPosNeg(B2d,'neg');
            % save 2D Bulk Modulus in .dat file, first column is angle, second and third column are Bulk Modulus.
            tFilename                   = strcat(filepath,filesep,fname,'_2D_B(',planeName,').dat');
            fidt                        = fopen(tFilename,'wt');
            fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\n', [theta2d B2dpos B2dneg]');
            fclose(fidt);

            Re(pk).B2d                 = B2dpos;
            Re(pk).B2dneg              = B2dneg;
        else
            % save 2D Bulk Modulus in .dat file, first column is angle and second column is Bulk Modulus.
            tFilename                  = strcat(filepath,filesep,fname,'_2D_B(',planeName,').dat');
            fidt                       = fopen(tFilename,'wt');
            fprintf(fidt,'%5.4f\t%5.4f\n', [theta2d B2d]');
            fclose(fidt);

            Re(pk).B2d                = B2d;
            Re(pk).B2dneg             = [];
        end

        % calculating the maximum and minimum of Bulk Modulus and its directions.
        B2dmax                   = max(B2d);
        B2dmaxTheta              = theta2d(B2d == B2dmax);
%         [B2dmax,B2dmaxTheta,~]   = maxminSearch(B2dmaxTheta,@(x) -calcBulk(x,S,ntheta2d,planeC,'2D'),teps);
        B2dmaxTheta              = unique(B2dmaxTheta);
        B2dmaxXY                 = dir2Vec2d(B2dmaxTheta);
%         B2dmax                   = mean(-B2dmax);

        B2dmin                   = min(B2d);
        B2dminTheta              = theta2d(B2d == B2dmin);
%         [B2dmin,B2dminTheta,~]   = maxminSearch(B2dminTheta,@(x) calcBulk(x,S,ntheta2d,planeC,'2D'),teps);
        B2dminTheta              = unique(B2dminTheta);
        B2dminXY                 = dir2Vec2d(B2dminTheta);
%         B2dmin                   = mean(B2dmin);

        Re(pk).B2d                   = B2d;
        Re(pk).B2dmax                = B2dmax;
        Re(pk).B2dmaxTheta           = B2dmaxTheta;
        Re(pk).B2dmaxXY              = B2dmaxXY;
        Re(pk).B2dmin                = B2dmin;
        Re(pk).B2dminTheta           = B2dminTheta;
        Re(pk).B2dminXY              = B2dminXY;
        Re(pk).B2davg                = mean(B2d);

        fprintf(fid,'%s\r','');
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r',strcat(' The maximum and minimum of Bulk Modulus [Units in GPa] and its directions in plane (',planeName,')'));
        fprintf(fid,'%s\r','=============================================================================================');
        fprintf(fid,'%s\r', ['Anisotropy of Bulk Modulus in plane (',planeName,')',': ',num2str(AB2d)]);
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\t%s\t\r','B2dmax','B2dmin');
        fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [B2dmax B2dmin]);
        fprintf(fid,'%s\r','Direction for B2dmax');
        fprintf(fid,'%s\t\r',' θ (B2dmax)');
        fprintf(fid,'%5.2f\t\n', B2dmaxTheta(end,:));
        fprintf(fid,'%s\t%s\t\r','x (B2dmax)','y (B2dmax)');
        fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], B2dmaxXY(end,:));
        fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
        fprintf(fid,'%s\r','Direction for B2dmin');
        fprintf(fid,'%s\t\r',' θ (B2dmin)');
        fprintf(fid,'%5.2f\t\n', B2dminTheta(end,:));
        fprintf(fid,'%s\t%s\t\r','x (B2dmin)','y (B2dmin)');
        fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], B2dminXY(end,:));
    end

    if Pro(2,6)
        %% ========== Calculation of Pugh ratio ========================================

        if Pro(2,3) % For Shear input
            Gin2d     = G2d;
        else
            [Gin2d,~] = calcShear([],nchi,S,ntheta2d,planeC,'normal','2D');
        end
        
        if Pro(2,5) % For Bulk input
            Bin2d    = repmat(B2d',nchi,1);
        else
            [B2d,~]  = calcBulk([],S,ntheta2d,planeC,'2D');
            Bin2d    = repmat(B2d',nchi,1);
        end

        if ~isempty(Gin2d) && ~isempty(Bin2d)

            Pr2d      = calcPugh(Bin2d,Gin2d);
            APr2d     = calcAnisotropy(Pr2d);
            % calculating the maximum and minimum of Pugh ratio and its directions.

            Pr2dmax                = max(Pr2d);
            Pr2dmmax               = max(Pr2dmax(:));
            Pr2dmaxTheta           = theta2d(Pr2dmax == Pr2dmmax);
            Pr2dmaxXY              = dir2Vec2d(Pr2dmaxTheta);

            Pr2dmin                = min(Pr2d);
            Pr2dmmin               = min(Pr2dmin(:));
            Pr2dminTheta           = theta2d(Pr2dmin == Pr2dmmin);
            Pr2dminXY              = dir2Vec2d(Pr2dminTheta);

            % save 2D Pugh ratio in .dat file, first column is angle and second column is maximum, minimum, average Pugh ratio.
            tFilename              = strcat(filepath,filesep,fname,'_2D_Pr(',planeName,').dat');
            fidt                   = fopen(tFilename,'wt');
            fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\n', [theta2d Pr2dmax' Pr2dmin']');
            fclose(fidt);

            Re(pk).Pr2d            = Pr2d;
            Re(pk).Pr2dmax         = Pr2dmax;
            Re(pk).Pr2dmmax        = Pr2dmmax;
            Re(pk).Pr2dmaxTheta    = Pr2dmaxTheta;
            Re(pk).Pr2dmaxXY       = Pr2dmaxXY;
            Re(pk).Pr2dmin         = Pr2dmin;
            Re(pk).Pr2dmmin        = Pr2dmmin;
            Re(pk).Pr2dminTheta    = Pr2dminTheta;
            Re(pk).Pr2dminXY       = Pr2dminXY;

            fprintf(fid,'%s\r','');
            fprintf(fid,'%s\r','=============================================================================================');
            fprintf(fid,'%s\r',strcat(' The maximum and minimum of Pugh ratio [Units in GPa] and its directions in plane (',planeName,')'));
            fprintf(fid,'%s\r','=============================================================================================');
            fprintf(fid,'%s\r', ['Anisotropy of Pugh ratio in plane (',planeName,')',': ',num2str(APr2d)]);
            fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
            fprintf(fid,'%s\t%s\t\r','Pr2dmax','Pr2dmin');
            fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [Pr2dmmax Pr2dmmin]);
            fprintf(fid,'%s\r','Direction for Pr2dmax');
            fprintf(fid,'%s\t\r',' θ (Pr2dmax)');
            fprintf(fid,'%5.2f\t\n', Pr2dmaxTheta(end,:));
            fprintf(fid,'%s\t%s\t\r','x (Pr2dmax)','y (Pr2dmax)');
            fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], Pr2dmaxXY(end,:));
            fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
            fprintf(fid,'%s\r','Direction for Pr2dmin');
            fprintf(fid,'%s\t\r',' θ (Pr2dmin)');
            fprintf(fid,'%5.2f\t\n', Pr2dminTheta(end,:));
            fprintf(fid,'%s\t%s\t\r','x (Pr2dmin)','y (Pr2dmin)');
            fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], Pr2dminXY(end,:));
        end
    end

    if Pro(2,7) && ~isempty(inputData.HvModel)
        %% ========== Calculation of Vickers hardness ========================================
        switch(inputData.HvModel)
            case {'M','Mazhnik'}

                if Pro(2,1) % For Young input
                    UHin2d     = repmat(E2d',nchi,1);
                else
                    [E2d,~,~] = calcYoung([],S,ntheta2d,planeC,'2D');
                    UHin2d    = repmat(E2d',nchi,1);
                end

                if Pro(2,4) % For Possion input
                    VHin2d     = P2d;
                else
                    if Pro(2,1)
                        [VHin2d,~]   = calcPoisson([],nchi,S11112d,S,ntheta2d,planeC,'normal','2D');
                    else
                        [~,S11112d,~]    = calcYoung([],S,ntheta2d,planeC,'2D');
                        [VHin2d,~]   = calcPoisson([],nchi,S11112d,S,ntheta2d,planeC,'normal','2D');
                    end
                end

            case {'C','T','Chen','Tian'}

                if Pro(2,3) % For Shear input
                    UHin2d     = G2d;
                else
                    [UHin2d,~] = calcShear([],nchi,S,ntheta2d,planeC,'normal','2D');
                end

                if Pro(2,5) % For Bulk input
                    VHin2d    = repmat(B2d',nchi,1);
                else
                    [B2d,~]  = calcBulk([],S,ntheta2d,planeC,'2D');
                    VHin2d    = repmat(B2d',nchi,1);
                end
        end
        if ~isempty(UHin2d) && ~isempty(VHin2d)

            Hv2d               = calcHardness(UHin2d,VHin2d,inputData.HvModel);
            AHv2d              = calcAnisotropy(Hv2d);
            % calculating the maximum and minimum of Vickers hardness and its directions.

            Hv2dmax                = max(Hv2d);
            Hv2dmmax               = max(Hv2dmax(:));
            Hv2dmaxTheta           = theta2d(Hv2dmax == Hv2dmmax);
            Hv2dmaxXY              = dir2Vec2d(Hv2dmaxTheta);

            Hv2dmin                = min(Hv2d);
            Hv2dmmin               = min(Hv2dmin(:));
            Hv2dminTheta           = theta2d(Hv2dmin == Hv2dmmin);
            Hv2dminXY              = dir2Vec2d(Hv2dminTheta);

            % save 2D Vickers hardness in .dat file, first column is angle and second column is maximum, minimum, average Vickers hardness.
            tFilename              = strcat(filepath,filesep,fname,'_2D_Hv(',planeName,').dat');
            fidt                   = fopen(tFilename,'wt');
            if inputData.avgout
                Hvavg              = mean(Hv2d)';
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\t%5.4f\n', [theta2d Hv2dmax' Hv2dmin' Hvavg]');
                Re(pk).Hvavg       = Hvavg;
            else
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\n', [theta2d Hv2dmax' Hv2dmin']');
            end
            fclose(fidt);

            Re(pk).Hv2d            = Hv2d;
            Re(pk).Hv2dmax         = Hv2dmax';
            Re(pk).Hv2dmmax        = Hv2dmmax;
            Re(pk).Hv2dmaxTheta    = Hv2dmaxTheta;
            Re(pk).Hv2dmaxXY       = Hv2dmaxXY;
            Re(pk).Hv2dmin         = Hv2dmin';
            Re(pk).Hv2dmmin        = Hv2dmmin;
            Re(pk).Hv2dminTheta    = Hv2dminTheta;
            Re(pk).Hv2dminXY       = Hv2dminXY;

            fprintf(fid,'%s\r','');
            fprintf(fid,'%s\r','=============================================================================================');
            fprintf(fid,'%s\r',strcat(' The maximum and minimum of Vickers hardness [Units in GPa] and its directions in plane (',planeName,')'));
            fprintf(fid,'%s\r','=============================================================================================');
            fprintf(fid,'%s\r', ['Anisotropy of Vickers hardness in plane (',planeName,')',': ',num2str(AHv2d)]);
            fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
            fprintf(fid,'%s\t%s\t\r','Hv2dmax','Hv2dmin');
            fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [Hv2dmmax Hv2dmmin]);
            fprintf(fid,'%s\r','Direction for Hv2dmax');
            fprintf(fid,'%s\t\r',' θ (Hv2dmax)');
            fprintf(fid,'%5.2f\t\n', Hv2dmaxTheta(end,:));
            fprintf(fid,'%s\t%s\t\r','x (Hv2dmax)','y (Hv2dmax)');
            fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], Hv2dmaxXY(end,:));
            fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
            fprintf(fid,'%s\r','Direction for Hv2dmin');
            fprintf(fid,'%s\t\r',' θ (Hv2dmin)');
            fprintf(fid,'%5.2f\t\n', Hv2dminTheta(end,:));
            fprintf(fid,'%s\t%s\t\r','x (Hv2dmin)','y (Hv2dmin)');
            fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], Hv2dminXY(end,:));
        end
    end

    if Pro(2,8) && ~isempty(inputData.KIC.model)
        %% ========== Calculation of Fracture Toughness ========================================

        switch(inputData.KIC.model)
            case {'M','Mazhnik'}
                
                if Pro(2,1) % For Young input
                    UKin2d     = repmat(E2d',nchi,1);
                else
                    [E2d,~,~] = calcYoung([],S,ntheta2d,planeC,'2D');
                    UKin2d    = repmat(E2d',nchi,1);
                end

                if Pro(2,4) % For Possion input
                    VKin2d     = P2d;
                else
                    if Pro(2,1)
                        [VKin2d,~]   = calcPoisson([],nchi,S11112d,S,ntheta2d,planeC,'normal','2D');
                    else
                        [~,S11112d,~]    = calcYoung([],S,ntheta2d,planeC,'2D');
                        [VKin2d,~]   = calcPoisson([],nchi,S11112d,S,ntheta2d,planeC,'normal','2D');
                    end
                end

            case {'N','Niu'}

                 if Pro(2,3) % For Shear input
                    UKin2d     = G2d;
                else
                    [UKin2d,~] = calcShear([],nchi,S,ntheta2d,planeC,'normal','2D');
                end

                if Pro(2,5) % For Bulk input
                    VKin2d    = repmat(B2d',nchi,1);
                else
                    [B2d,~]  = calcBulk([],S,ntheta2d,planeC,'2D');
                    VKin2d    = repmat(B2d',nchi,1);
                end
        end
        if ~isempty(UKin2d) && ~isempty(VKin2d)

            Kic2d              = calcFractureToughness(UKin2d,VKin2d,inputData.KIC);
            AKic2d             = calcAnisotropy(Kic2d);
            % calculating the maximum and minimum of Fracture Toughness and its directions.

            Kic2dmax                = max(Kic2d);
            Kic2dmmax               = max(Kic2dmax(:));
            Kic2dmaxTheta           = theta2d(Kic2dmax == Kic2dmmax);
            Kic2dmaxXY              = dir2Vec2d(Kic2dmaxTheta);

            Kic2dmin                = min(Kic2d);
            Kic2dmmin               = min(Kic2dmin(:));
            Kic2dminTheta           = theta2d(Kic2dmin == Kic2dmmin);
            Kic2dminXY              = dir2Vec2d(Kic2dminTheta);

            % save 2D Fracture Toughness in .dat file, first column is angle and second column is maximum, minimum, average Fracture Toughness.
            tFilename                   = strcat(filepath,filesep,fname,'_2D_Kic(',planeName,').dat');
            fidt                        = fopen(tFilename,'wt');
            if inputData.avgout
                Kicavg                  = mean(Kic2d);
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\t%5.4f\n', [theta2d Kic2dmax' Kic2dmin' Kicavg']');
                Re(pk).Kicavg           = Kicavg;
            else
                fprintf(fidt,'%5.4f\t%5.4f\t%5.4f\n', [theta2d Kic2dmax' Kic2dmin']');
            end
            fclose(fidt);

            Re(pk).Kic2d            = Kic2d;
            Re(pk).Kic2dmax         = Kic2dmax;
            Re(pk).Kic2dmmax        = Kic2dmmax;
            Re(pk).Kic2dmaxTheta    = Kic2dmaxTheta;
            Re(pk).Kic2dmaxXY       = Kic2dmaxXY;
            Re(pk).Kic2dmin         = Kic2dmin;
            Re(pk).Kic2dmmin        = Kic2dmmin;
            Re(pk).Kic2dminTheta    = Kic2dminTheta;
            Re(pk).Kic2dminXY       = Kic2dminXY;

            fprintf(fid,'%s\r','');
            fprintf(fid,'%s\r','=============================================================================================');
            fprintf(fid,'%s\r',strcat(' The maximum and minimum of Fracture Toughness [Units in MPa.m^(1/2)] and its directions in plane (',planeName,')'));
            fprintf(fid,'%s\r','=============================================================================================');
            fprintf(fid,'%s\r', ['Anisotropy of Fracture Toughness in plane (',planeName,')',': ',num2str(AKic2d)]);
            fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
            fprintf(fid,'%s\t%s\t\r','Kic2dmax','Kic2dmin');
            fprintf(fid,[repmat('%5.2f\t',1,2),'\n'], [Kic2dmmax Kic2dmmin]);
            fprintf(fid,'%s\r','Direction for Kic2dmax');
            fprintf(fid,'%s\t\r',' θ (Kic2dmax)');
            fprintf(fid,'%5.2f\t\n', Kic2dmaxTheta(end,:));
            fprintf(fid,'%s\t%s\t\r','x (Kic2dmax)','y (Kic2dmax)');
            fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], Kic2dmaxXY(end,:));
            fprintf(fid,'%s\r','---------------------------------------------------------------------------------------------');
            fprintf(fid,'%s\r','Direction for Kic2dmin');
            fprintf(fid,'%s\t\r',' θ (Kic2dmin)');
            fprintf(fid,'%5.2f\t\n', Kic2dminTheta(end,:));
            fprintf(fid,'%s\t%s\t\r','x (Kic2dmin)','y (Kic2dmin)');
            fprintf(fid,[repmat('%5.2f\t', 1, 2), '\n'], Kic2dminXY(end,:));
        end
    end
end

fprintf(fid,'%s\r','');
fprintf(fid,'%s\r','#############################################################################################');
fprintf(fid,'%s\r','');
fprintf(fid,'%s\r',strcat('End at:',32,datestr(now())));
fprintf(fid,'%s\r','');
fclose(fid);
if ishandle(hmsg)
    close(hmsg);
end
toc;

hmsg = msgbox('Calculation completed!', 'VELAS reminder','help');
pause(0.8);
if ishandle(hmsg)
    close(hmsg);
end

