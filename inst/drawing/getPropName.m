function [mode,name,units,abbr,plane,mma] = getPropName(fname)

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
                name  = 'Young''s Modulus';
                units = 'GPa';
                abbr  = 'E';
                mma   = [];
            case 'beta'
                name  = 'Linear Compressibility';
                units = 'TPa^{-1}';
                abbr  = 'LC';
                mma   = [];
            case 'B'
                name  = 'Bulk Modulus';
                units = 'GPa';
                abbr  = 'B';
                mma   = [];
            case 'G'
                name  = 'Shear Modulus';
                units = 'GPa';
                abbr  = 'G';
                mma   = [];
            case 'P'
                name  = 'Poisson''s Ratio';
                units = [];
                abbr  = '\lambda';
                mma   = [];
            case 'Hv'
                name  = 'Vickers Hardness';
                units = 'GPa';
                abbr  = 'Hv';
                mma   = [];
            case 'Pr'
                name  = 'Pugh Ratio';
                units = [];
                abbr  = 'Pr';
                mma   = [];
            case 'Kic'
                name  = 'Fracture Toughness';
                units = 'MPa·m^{1/2}';
                abbr  = 'K_{IC}';
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
                mma   = 'Positive';
            case 'Eneg'
                name  = 'Young''s Modulus';
                units = 'GPa';
                abbr  = 'E';
                mma   = 'Negative';
            case 'beta'
                name  = 'Linear Compressibility';
                units = 'TPa^{-1}';
                abbr  = 'LC';
                mma   = 'Positive';
            case 'betaneg'
                name  = 'Linear Compressibility';
                units = 'TPa^{-1}';
                abbr  = 'LC_{neg}';
                mma   = 'Negative';
            case 'B'
                name  = 'Bulk Modulus';
                units = 'GPa';
                abbr  = 'B_{neg}';
                mma   = 'Positive';
            case 'Bneg'
                name  = 'Bulk Modulus';
                units = 'GPa';
                abbr  = 'B';
                mma   = 'Negative';
            case 'Gmax'
                name  = 'Shear Modulus';
                units = 'GPa';
                abbr  = 'G_{max}';
                mma   = 'Maximum';
            case 'Gminp'
                name  = 'Shear Modulus';
                units = 'GPa';
                abbr  = 'G_{min +}';
                mma   = 'Minimum positive';
            case 'Gminn'
                name  = 'Shear Modulus';
                units = 'GPa';
                abbr  = 'G_{min -}';
                mma   = 'Minimum negative';
            case 'Gavg'
                name  = 'Shear Modulus';
                units = 'GPa';
                abbr  = 'G_{avg}';
                mma   = 'Average';
            case 'Pmax'
                name  = 'Poisson''s Ratio';
                units = [];
                abbr  = '\lambda_{max}';
                mma   = 'Maximum';
            case 'Pminp'
                name  = 'Poisson''s Ratio';
                units = [];
                abbr  = '\lambda_{min +}';
                mma   = 'Minimum positive';
            case 'Pminn'
                name  = 'Poisson''s Ratio';
                units = [];
                abbr  = '\lambda_{min -}';
                mma   = 'Minimum negative';
            case 'Pavg'
                name  = 'Poisson''s Ratio';
                units = [];
                abbr  = '\lambda_{avg}';
                mma   = 'Average';
            case 'Prmax'
                name  = 'Pugh Ratio';
                units = [];
                abbr  = 'Pr_{max}';
                mma   = 'Maximum';
            case 'Prmin'
                name  = 'Pugh Ratio';
                units = [];
                abbr  = 'Pr_{min}';
                mma   = 'Minimum';
            case 'Hvmax'
                name  = 'Vickers Hardness';
                units = 'GPa';
                abbr  = 'Hv_{max}';
                mma   = 'Maximum';
            case 'Hvmin'
                name  = 'Vickers Hardness';
                units = 'GPa';
                abbr  = 'Hv_{min}';
                mma   = 'Minimum';
            case 'Hvavg'
                name  = 'Vickers Hardness';
                units = 'GPa';
                abbr  = 'Hv_{avg}';
                mma   = 'Average';
            case 'Kicmax'
                name  = 'Fracture Toughness';
                units = 'MPa·m^{1/2}';
                abbr  = 'K_{ICmax}';
                mma   = 'Maximum';
            case 'Kicmin'
                name  = 'Fracture Toughness';
                units = 'MPa·m^{1/2}';
                abbr  = 'K_{ICmin}';
                mma   = 'Minimum';
            case 'Kicavg'
                name  = 'Fracture Toughness';
                units = 'MPa·m^{1/2}';
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