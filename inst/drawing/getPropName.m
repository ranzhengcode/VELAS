function [mode,name,units,abbr,flname,plane,mma] = getPropName(fname)

    if iscontains(fname,'2D')
        mode    = '2D';
        % patern for plane
        exprp      = '(?<=\().*?(?=\))';
        [matchp,~] = regexp(fname,exprp,'match','split');
        plane   = matchp{end};
        % patern for property
        exprn      = '(?<=_2D_).*?(?=\()';
        [matchn,~] = regexp(fname,exprn,'match','split');
        proname    = matchn{1};
        switch(proname)
            case 'E'
                name   = 'Young''s Modulus';
                units  = 'GPa';
                abbr   = 'E';
                flname = 'Young';
                mma    = [];
            case 'beta'
                name  = 'Linear Compressibility';
                units = 'TPa^{-1}';
                abbr  = 'LC';
                flname = 'LinCompress';
                mma   = [];
            case 'B'
                name  = 'Bulk Modulus';
                units = 'GPa';
                abbr  = 'B';
                flname = 'Bulk';
                mma   = [];
            case 'G'
                name  = 'Shear Modulus';
                units = 'GPa';
                abbr  = 'G';
                flname = 'Shear';
                mma   = [];
            case 'P'
                name  = 'Poisson''s Ratio';
                units = [];
                abbr  = '\lambda';
                flname = 'Poisson';
                mma   = [];
            case 'Hv'
                name  = 'Vickers Hardness';
                units = 'GPa';
                abbr  = 'Hv';
                flname = 'Hardness';
                mma   = [];
            case 'Pr'
                name  = 'Pugh Ratio';
                units = [];
                abbr  = 'Pr';
                flname = 'Pugh';
                mma   = [];
            case 'Kic'
                name  = 'Fracture Toughness';
                units = 'MPa·m^{1/2}';
                abbr  = 'K_{IC}';
                flname = 'FractToughness';
                mma   = [];
        end
        return;
    end

    if iscontains(fname,'3D')
        mode    = '3D';
        plane   = [];
        % patern for property
        exprn      = '(?<=_3D_).*?(?=.dat)';
        [matchn,~] = regexp(fname,exprn,'match','split');
        proname    = matchn{1};
        switch(proname)
            case 'E'
                name  = 'Young''s Modulus';
                units = 'GPa';
                abbr  = 'E';
                flname = 'Young';
                mma   = 'Positive';
            case 'Eneg'
                name  = 'Young''s Modulus';
                units = 'GPa';
                abbr  = 'E';
                flname = 'Young';
                mma   = 'Negative';
            case 'beta'
                name  = 'Linear Compressibility';
                units = 'TPa^{-1}';
                abbr  = 'LC';
                flname = 'LinCompress';
                mma   = 'Positive';
            case 'betaneg'
                name  = 'Linear Compressibility';
                units = 'TPa^{-1}';
                abbr  = 'LC_{neg}';
                flname = 'LinCompress';
                mma   = 'Negative';
            case 'B'
                name  = 'Bulk Modulus';
                units = 'GPa';
                abbr  = 'B_{neg}';
                flname = 'Bulk';
                mma   = 'Positive';
            case 'Bneg'
                name  = 'Bulk Modulus';
                units = 'GPa';
                abbr  = 'B';
                flname = 'Bulk';
                mma   = 'Negative';
            case 'Gmax'
                name  = 'Shear Modulus';
                units = 'GPa';
                abbr  = 'G_{max}';
                flname = 'Shear';
                mma   = 'Maximum';
            case 'Gminp'
                name  = 'Shear Modulus';
                units = 'GPa';
                abbr  = 'G_{min +}';
                flname = 'Shear';
                mma   = 'Minimum positive';
            case 'Gminn'
                name  = 'Shear Modulus';
                units = 'GPa';
                abbr  = 'G_{min -}';
                flname = 'Shear';
                mma   = 'Minimum negative';
            case 'Gavg'
                name  = 'Shear Modulus';
                units = 'GPa';
                abbr  = 'G_{avg}';
                flname = 'Shear';
                mma   = 'Average';
            case 'Pmax'
                name  = 'Poisson''s Ratio';
                units = [];
                abbr  = '\lambda_{max}';
                flname = 'Poisson';
                mma   = 'Maximum';
            case 'Pminp'
                name  = 'Poisson''s Ratio';
                units = [];
                abbr  = '\lambda_{min +}';
                flname = 'Poisson';
                mma   = 'Minimum positive';
            case 'Pminn'
                name  = 'Poisson''s Ratio';
                units = [];
                abbr  = '\lambda_{min -}';
                flname = 'Poisson';
                mma   = 'Minimum negative';
            case 'Pavg'
                name  = 'Poisson''s Ratio';
                units = [];
                abbr  = '\lambda_{avg}';
                flname = 'Poisson';
                mma   = 'Average';
            case 'Prmax'
                name  = 'Pugh Ratio';
                units = [];
                abbr  = 'Pr_{max}';
                flname = 'Pugh';
                mma   = 'Maximum';
            case 'Prmin'
                name  = 'Pugh Ratio';
                units = [];
                abbr  = 'Pr_{min}';
                flname = 'Pugh';
                mma   = 'Minimum';
            case 'Hvmax'
                name  = 'Vickers Hardness';
                units = 'GPa';
                abbr  = 'Hv_{max}';
                flname = 'Hardness';
                mma   = 'Maximum';
            case 'Hvmin'
                name  = 'Vickers Hardness';
                units = 'GPa';
                abbr  = 'Hv_{min}';
                flname = 'Hardness';
                mma   = 'Minimum';
            case 'Hvavg'
                name  = 'Vickers Hardness';
                units = 'GPa';
                abbr  = 'Hv_{avg}';
                flname = 'Hardness';
                mma   = 'Average';
            case 'Kicmax'
                name  = 'Fracture Toughness';
                units = 'MPa·m^{1/2}';
                abbr  = 'K_{ICmax}';
                flname = 'FracToughness';
                mma   = 'Maximum';
            case 'Kicmin'
                name  = 'Fracture Toughness';
                units = 'MPa·m^{1/2}';
                abbr  = 'K_{ICmin}';
                flname = 'FracToughness';
                mma   = 'Minimum';
            case 'Kicavg'
                name  = 'Fracture Toughness';
                units = 'MPa·m^{1/2}';
                flname = 'FracToughness';
                abbr  = 'K_{ICavg}';
                mma   = 'Average'; 
        end
        return;
    end
    plane   = [];
    mode    = [];
    units   = [];
    abbr    = [];
    name    = [];
    mma     = [];
end