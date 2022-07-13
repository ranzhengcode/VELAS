
function [P,negFlag] = calcPoisson(x,nChi,S1111,S,n2d,planeC,flag,flagD)


%{
   ========================= Poisson's Ratio ==============================
    Input parameter: 
                    - x, Initial value of optimization function.
                    - nChi, mesh number of azimuth -
                    - S1111, 
                    - S, Compliance matrix S
                    - n2d, mesh number of [0,2-] in 2D calculation
                    - planeC, 2D plane, such as plane (111)
                    - flag, 'max', 'min' or 'neg'.
                    - flagD, '3D','3d','2D' or '2d', decide whether to compute 3D or 2D.
    Out parameter: 
                    - P, return Poisson's Ratio. 
                    - negFlag, if there is a negative Poisson's ratio, then true, otherwise false.
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

S1122 = k11.*v11.*S(1,1)+(k11.*v22+k22.*v11).*S(1,2)+(k11.*v33+k33.*v11).*S(1,3)+(k11.*v23+k23.*v11).*S(1,4)+(k11.*v13+k13.*v11).*S(1,5)+(k11.*v12+k12.*v11).*S(1,6)+...
                                    k22.*v22.*S(2,2)+(k22.*v33+k33.*v22).*S(2,3)+(k22.*v23+k23.*v22).*S(2,4)+(k22.*v13+k13.*v22).*S(2,5)+(k22.*v12+k12.*v22).*S(2,6)+...
                                                                k33.*v33.*S(3,3)+(k33.*v23+k23.*v33).*S(3,4)+(k33.*v13+k13.*v33).*S(3,5)+(k33.*v12+k12.*v33).*S(3,6)+...
                                                                                            k23.*v23.*S(4,4)+(k23.*v13+k13.*v23).*S(4,5)+(k23.*v12+k12.*v23).*S(4,6)+...
                                                                                                                        k13.*v13.*S(5,5)+(k13.*v12+k12.*v13).*S(5,6)+...
                                                                                                                                                    k12.*v12.*S(6,6);
S1111 = repmat(S1111,1,nChi);

switch(flag)
    case 'normal'
        P       = (-S1122./S1111)';
        if min(min(P)) < 0
            negFlag = true;
        else
            negFlag = false;
        end
    case 'max'
        tmpnu   = (-S1122./S1111)';
        P       = arrayfun(@(t) max(tmpnu(tmpnu(:,t)>0,t)), 1:size(tmpnu,2),'UniformOutput',false);
        loc     = cellfun(@isempty,P);
        if any(loc)
            P(loc)  = num2cell(0);
        end
        P       = max(cell2mat(P));
    case 'min'
        tmpnu   = (-S1122./S1111)';
        P       = arrayfun(@(t) min(tmpnu(tmpnu(:,t)>0,t)), 1:size(tmpnu,2),'UniformOutput',false);
        loc     = cellfun(@isempty,P);
        if any(loc)
            P(loc)  = num2cell(inf);
        end
        P       = min(cell2mat(P));
    case 'neg'
        tmpnu   = (-S1122./S1111)';
        P       = arrayfun(@(t) min(tmpnu(tmpnu(:,t)<0,t)), 1:size(tmpnu,2),'UniformOutput',false);
        loc     = cellfun(@isempty,P);
        if any(loc)
            P(loc)  = num2cell(0);
        end
        P       = max(-cell2mat(P));
    case 'avg'
        P       = mean((-S1122./S1111),2);
end