function [negFlag,arealP] = isNegativePoisson(Dir,varargin)

%{
    Input:
         Dir - Direction need to be checked, size: 1*3 or 3*1.
    Output
         negFlag: if true  (Negative Poisson’s ratio in Dir);
                  if false (Positive Poisson’s ratio in Dir).
         arealP - Areal Poisson’s ratio in plane(Dir).

    Ref: Guo, C. Y . and Wheeler, L., J. Mech. Phys. Solids, 54, 690–707,2006.
    Areal Poisson’s ratio: The average of all values of Poisson’s ratio taken within the plane normal to a chosen direction.
%}

[m,n] = size(Dir);
narginchk(1,2);

if (m == 1 && n == 3) || (m == 3 && n == 1)
    switch(nargin)
        case 1
            [filen, pathn] = uigetfile({'*.txt'},'选择文件');
            if isequal(filen,0)
                errordlg('打开文件失败！','温馨提示');
            else
                filename      = strcat(pathn,filen);
                inputData     = getInput(filename);
            end
        case 2
            matname           = varargin{1};
            load(matname);
    end

    S             = inputData.S;
    ntheta2d      = inputData.ntheta2d;
    nchi          = inputData.nchi;
    [~,S11112d,~] = calcYoung([],S,ntheta2d,Dir,'2D');
    [P2d,~]       = calcPoisson([],nchi,S11112d,S,ntheta2d,Dir,'normal','2D');
    arealP        = mean(P2d(:));
    
    if arealP >= 0
        negFlag = false;
    else
        negFlag = true;
    end
else
    hmsg = msgbox(['Expected input to be of size 1x3 or 3x1, but it is of size ',num2str(m),'x',num2str(n),'.'], 'VELAS reminder','help');
    pause(1.2);
    if ishandle(hmsg)
        close(hmsg);
    end
end



