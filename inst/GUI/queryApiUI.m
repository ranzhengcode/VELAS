function queryApiUI()

global VELAS

mpid    = get(VELAS.mpmid,'String');
xapikey = get(VELAS.mpapikey,'String');
flag    = [num2str(isempty(mpid)),num2str(isempty(xapikey))];

VELAS.mpid    = mpid;
VELAS.xapikey = xapikey;
if get(VELAS.mponline,'value')
    switch(flag)
        case '11'
            errordlg('Both X-API-KEY and Material ID cannot be empty.','VELAS reminder');
            return;
        case '01'
            errordlg('The X-API-KEY cannot be empty.','VELAS reminder');
            return;
        case '10'
            errordlg('The Material ID cannot be empty.','VELAS reminder');
            return;
    end
else
    if isempty(mpid)
        errordlg('The Material ID cannot be empty.','VELAS reminder');
        return;
    end
end

if get(VELAS.mpapiver,'Value')
    VELAS.mpapiverflag = true;             % using Legacy API
end

if get(VELAS.mponline,'Value')
    VELAS.mponlineflag = true;
end

if VELAS.mponlineflag

    outputs = mpapiElastic(mpid,xapikey,VELAS.mpapiverflag);

    if ~VELAS.mpapiverflag
        set(VELAS.CS,'String',num2str(roundN(outputs.data.elasticity.elastic_tensor,2)));

        switch(lower(outputs.data.symmetry.crystal_system))
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

    else
        set(VELAS.CS,'String',num2str(roundN(outputs.response.elasticity.elastic_tensor,2)));

        switch(lower(outputs.response.spacegroup.crystal_system))
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
    end
else

    outputs = mpapiElasticOffline(mpid);
    if ~isempty(outputs)
        set(VELAS.CS,'String',num2str(roundN(outputs.elasticTensor,2)));

        switch(lower(outputs.crystalSystem))
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
    end
end