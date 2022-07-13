function nX = str2numb(X)

cX  = class(X);

switch(cX)
    case 'cell'
        lenC = size(X,1);
        for k = 1:lenC
            nX(k,:) = str2num(X{k});
        end
    case 'char'
        [m,n] = size(X);
        if m == 1
            loc = strfind(X,'|');
        else
            loc = [];
        end
        if isempty(loc)
            nX = str2num(X);
        else
            len = size(loc,2);
            for k = 1:len+1
                if k == 1
                    nX(k,:) = str2num(X(1:loc(k)-1));
                elseif k == len+1
                    nX(k,:) = str2num(X(loc(k-1)+1:end));
                else
                    nX(k,:) = str2num(X(loc(k-1)+1:loc(k)-1));
                end
            end
        end
end