function Plane = checkPlane(str)

hStr = size(str,1);
switch(hStr)
    case 1
        if ischar(str)
            loc = strfind(str,'|');
        end
        if ~isempty(loc)
            tC   = regexp(str,'\|','split');
            lenT = length(tC);
            tP   = [];
            for k = 1:lenT
                tP = [tP;str2num(tC{k})];
            end
            Plane = num2str(tP);
        else
            Plane = str;
        end
    otherwise
        Plane = str;
end