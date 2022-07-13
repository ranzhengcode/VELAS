function Re = getMaxMinNeg(Data,flag)

%{
    Input parameter: 
                      data, which is a m*n matrix.
                      flag, 'max', 'min' or 'neg'.
    Out parameter: 
                      Re, return maximum, minimum positive or minimum negative value in column of Data according to flag. 
%}

switch(flag)
    case 'max'  % maximum
%         Re      = arrayfun(@(t) max(Data(Data(:,t)>0,t)), 1:size(Data,2),'UniformOutput',false);
%         loc     = cellfun(@isempty,Re);
%         if any(loc)
%             Re(loc)  = num2cell(0);
%         end
        Re      = max(Data);
    case 'min'  % minimum positive
        Re      = arrayfun(@(t) min(Data(Data(:,t)>0,t)), 1:size(Data,2),'UniformOutput',false);
        loc     = cellfun(@isempty,Re);
        if any(loc)
            Re(loc)  = num2cell(0);
        end
        Re      = cell2mat(Re);
    case 'neg'  % minimum negative
        Re      = arrayfun(@(t) min(Data(Data(:,t)<0,t)), 1:size(Data,2),'UniformOutput',false);
        loc     = cellfun(@isempty,Re);
        if any(loc)
            Re(loc)  = num2cell(0);
        end
        Re      = -cell2mat(Re);
end