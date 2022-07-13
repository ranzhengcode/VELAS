function Re = checkStability(inputData,Re)

%{
   ========= Check the mechanical stability of crystal structure ==========
    Input parameter: 
                      filename, the file name that contains the file path.
                      N, mesh number of azimuth   and ��
                      n2d, mesh number of [0,2π] in 2D calculation
                      nChi, mesh number of azimuth
                      Re, initialized output results
                      teps, the difference between a number and 0 or 1, if less than or equal to teps, it is considered to be equal to 0 or 1.
    Out parameter: 
                      Re, output results include various crystal mechanical parameters Or empty. 
%}

lenC = length(unique(nonzeros(inputData.C)));
if isequal(lenC,0)
    if inputData.mponline
        switch(lower(inputData.mpapiver))
            case 'new'
                verflag = 0;
            case {'old','legacy'}
                verflag = 1;
            otherwise
                verflag = 0;
        end
        outputs = mpapiElastic(inputData.mpid,inputData.xapikey,verflag);
        if ~verflag
            inputData.C = outputs.data.elasticity.elastic_tensor;
            inputData.S = inv(inputData.C);
            inputData.cryType = outputs.data.symmetry.crystal_system;
        else
            inputData.C = outputs.response.elasticity.elastic_tensor;
            inputData.S = inv(inputData.C);
            inputData.cryType = outputs.response.spacegroup.crystal_system;
        end
    else
        outputs = mpapiElasticOffline(inputData.mpid);
        inputData.C = outputs.elasticTensor;
        inputData.S = inv(inputData.C);
        inputData.cryType = outputs.crystalSystem;
    end
end

flag = isStable(inputData.C,inputData.pressure);

if flag
    Re = mechanics(inputData,Re);
else
    errordlg('Structure unstable.','VELAS reminder');
end

