function [num,eqflag] = convertString2Num(str)

hC     = size(str,1);
digts  = [num2str(iscell(str)),num2str(ischar(str))];
num    = [];
eqflag = false;
switch(digts)
    case '01'
        try
            loc = strfind(str,'|');
        catch
            loc = [];
        end
        if ~isempty(loc)
            tC    = regexp(str,'\|','split');
            lenC = length(tC);
            for k = 1:lenC
                num = [num;{str2num(tC{k})}];
            end
        else
            for k = 1:hC
                num = [num;{str2num(str(k,:))}];
            end
        end
        if ~any(diff(cellfun(@length,num)))
            eqflag = true;
        end
    case '10'
        for k = 1:hC
            num = [num;{str2num(str{k})}];
        end
        if ~any(diff(cellfun(@length,num)))
            eqflag = true;
        end
    otherwise
        msgbox({'The input must be char or cell type.','Please check and try again.'}, 'VELAS reminder','error');
end