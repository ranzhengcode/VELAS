function [shearModulus,negFlag] = calcShear(x,nChi,S,n2d,planeC,flag,flagD)

%{
  ========================== Shear Modulus ================================
    Input parameter: 
                     x, Initial value of optimization function.
                     nChi, mesh number of azimuth ��
                     S, Compliance matrix S
                     n2d, mesh number of [0,2��] in 2D calculation
                     planeC, 2D plane, such as plane (111)
                     flag, 'max', 'min' or 'neg'.
                     flagD, '3D','3d','2D' or '2d', decide whether to compute 3D or 2D.
    Out parameter: 
                     P, return Poisson's Ratio. 
                     negFlag, if there is a negative Poisson's ratio, then true, otherwise false.
%}


switch(flagD)
    case {'3D','3d'}
        k = dir2Vec(x(:,1), x(:,2));
        [k11,k12,k13,k22,k23,k33] = getCoef1(k);
        
        [v1,v2,v3] = dir2Vec3V(x(:,1), x(:,2), nChi);
        [v11,v12,v13,v22,v23,v33] = getCoef2(v1,v2,v3);
        
    case {'2D','2d'}
        
        [k11,k12,k13,k22,k23,k33,theta,phi] = getCoef2D(x,n2d,planeC);
        
        [v1,v2,v3] = dir2Vec3V(theta, phi, nChi);
        [v11,v12,v13,v22,v23,v33] = getCoef2(v1,v2,v3);
end

tmpShear =  k11.*v11.*S(1,1)+2.*k12.*v12.*S(1,2)+2.*k13.*v13.*S(1,3)+(k12.*v13+k13.*v12).*S(1,4)+(k11.*v13+k13.*v11).*S(1,5)+(k11.*v12+k12.*v11).*S(1,6)+...
                                k22.*v22.*S(2,2)+2.*k23.*v23.*S(2,3)+(k22.*v23+k23.*v22).*S(2,4)+(k12.*v23+k23.*v12).*S(2,5)+(k22.*v12+k12.*v22).*S(2,6)+...
                                                    k33.*v33.*S(3,3)+(k33.*v23+k23.*v33).*S(3,4)+(k33.*v13+k13.*v33).*S(3,5)+(k13.*v23+k23.*v13).*S(3,6)+...
          1/4*(k22.*v33+2*k23.*v23+k33.*v22).*S(4,4)+1/2*(k12.*v33+k23.*v13+k13.*v23+k33.*v12).*S(4,5)+1/2*(k12.*v23+k22.*v13+k13.*v22+k23.*v12).*S(4,6)+...
                                                            1/4*(k11.*v33+2*k13.*v13+k33.*v11).*S(5,5)+1/2*(k11.*v23+k12.*v13+k13.*v12+k23.*v11).*S(5,6)+...
                                                                                                              1/4*(k11.*v22+2*k12.*v12+k22.*v11).*S(6,6);
switch(flag)
    case 'normal'
        shearModulus = (1000./(4*tmpShear))';
        if min(min(shearModulus)) < 0
            negFlag = true;
        else
            negFlag = false;
        end
    case 'max'
        tmpG   = (1000./(4*tmpShear))';
        shearModulus       = arrayfun(@(t) max(tmpG(tmpG(:,t)>0,t)), 1:size(tmpG,2),'UniformOutput',false);
        loc     = cellfun(@isempty,shearModulus);
        if any(loc)
            shearModulus(loc)  = num2cell(0);
        end
        shearModulus       = max(cell2mat(shearModulus));
    case 'min'
        tmpG   = (1000./(4*tmpShear))';
        shearModulus       = arrayfun(@(t) min(tmpG(tmpG(:,t)>0,t)), 1:size(tmpG,2),'UniformOutput',false);
        loc     = cellfun(@isempty,shearModulus);
        if any(loc)
            shearModulus(loc)  = num2cell(inf);
        end
        shearModulus       = min(cell2mat(shearModulus));
    case 'neg'
        tmpG   = (1000./(4*tmpShear))';
        shearModulus       = arrayfun(@(t) min(tmpG(tmpG(:,t)<0,t)), 1:size(tmpG,2),'UniformOutput',false);
        loc     = cellfun(@isempty,shearModulus);
        if any(loc)
            shearModulus(loc)  = num2cell(0);
        end
        shearModulus       = max(-cell2mat(shearModulus));
    case 'avg'
        shearModulus       = mean(1000./(4*tmpShear),2);
end

