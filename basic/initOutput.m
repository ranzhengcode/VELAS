function Re    = initOutput()

% Initialize output results

hmsg = msgbox('Initialize output results!', 'VELAS reminder','help');
pause(0.8);
if ishandle(hmsg)
    close(hmsg);
end

Re.C           = [];
Re.N           = [];
Re.n2d         = 200;
Re.nChi        = 200;
Re.S           = [];
Re.pressure    = 0;
Re.planeC      = [];
Re.teps        = 1e-10;

Re.lamda       = [];

Re.Bv          = [];
Re.Br          = [];
Re.Bh          = [];

Re.Gv          = [];
Re.Gr          = [];
Re.Gh          = [];

Re.Ev          = [];
Re.Er          = [];
Re.Eh          = [];

Re.nuv         = [];
Re.nur         = [];
Re.nuh         = [];

Re.lamestv   = [];
Re.lamestr   = [];
Re.lamesth   = [];
Re.lamendv   = [];
Re.lamendr   = [];
Re.lamendh   = [];

Re.AU   = [];
Re.AL   = [];

%% 3D
Re.meshedTheta = [];
Re.meshedPhi   = [];

Re.E            = [];
Re.Emax         = [];
Re.EmaxTP       = [];
Re.Ehklmax      = [];
Re.Emin         = [];
Re.EminTP       = [];
Re.Ehklmin      = [];
Re.beta         = [];
Re.betamax      = [];
Re.betamaxTP    = [];
Re.betahklmax   = [];
Re.betamin      = [];
Re.betaminTP    = [];
Re.betahklmin   = [];

Re.G         = [];
Re.Gmax      = [];
Re.GMmax     = [];
Re.GmaxTP    = [];
Re.Ghklmax   = [];
Re.Gmin      = [];
Re.Gmmin     = [];
Re.GminTP    = [];
Re.Ghklmin   = [];
Re.Gavg      = [];

Re.P          = [];
Re.PMax       = [];
Re.Pmmax      = [];
Re.Phklmax    = [];
Re.PMinp      = [];
Re.PminpTP    = [];
Re.Phklminp   = [];
Re.PMinn      = [];
Re.PminnTP    = [];
Re.Phklminn   = [];
Re.Pavg       = [];

Re.Hv        = [];
Re.Hvmax     = [];
Re.Hvmmax    = [];
Re.HvmaxTP   = [];
Re.Hvhklmax  = [];
Re.Hvmin     = [];
Re.Hvmmin    = [];
Re.HvminTP   = [];
Re.Hvhklmin  = [];
Re.Hvavg     = [];

%% 2D
Re.theta2d           = [];

Re.E2d                   = [];
Re.E2dmax                = [];
Re.E2dmaxTheta           = [];
Re.E2dmin                = [];
Re.E2dminTheta           = [];

Re.beta2d                   = [];
Re.beta2dmax                = [];
Re.beta2dmaxTheta           = [];
Re.beta2dmin                = [];
Re.beta2dminTheta           = [];
Re.beta2davg                = [];

Re.B2d                   = [];
Re.B2dmax                = [];
Re.B2dmaxTheta           = [];
Re.B2dmin                = [];
Re.B2dminTheta           = [];
Re.B2davg                = [];

Re.G2d                   = [];
Re.G2dmax                = [];
Re.G2dmmax               = [];
Re.G2dmaxTheta           = [];
Re.G2dmin                = [];
Re.G2dmmin               = [];
Re.G2dminTheta           = [];
Re.G2davg                = [];

Re.P2d                    = [];
Re.P2dmax                 = [];
Re.P2dmmax                = [];
Re.P2dmaxTheta            = [];
Re.P2dminp                = [];
Re.P2dmminp               = [];
Re.P2dminpTheta           = [];
Re.P2dminn                = [];
Re.P2dmminn               = [];
Re.P2dminnTheta           = [];
Re.P2dmin                 = [];
Re.P2dminTheta            = [];
Re.P2davg                 = [];
