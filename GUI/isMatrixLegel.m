function Re = isMatrixLegel()

global VELAS

C   = get(VELAS.CS,'String');

if ~isempty(C)
    hC = size(C,1);
    switch(hC)
        case 1
            if ischar(C)
                loc = strfind(C,'|');
            end
            if ~isempty(loc)
                tC = regexp(C,'\|','split');
                if iscell(tC)
                    wC1 = size(str2num(tC{1}),2);
                    wC2 = size(str2num(tC{2}),2);
                    wC3 = size(str2num(tC{3}),2);
                    wC4 = size(str2num(tC{4}),2);
                    wC5 = size(str2num(tC{5}),2);
                    wC6 = size(str2num(tC{6}),2);
                else
                    wC1 = size(str2num(tC(1,:)),2);
                    wC2 = size(str2num(tC(2,:)),2);
                    wC3 = size(str2num(tC(3,:)),2);
                    wC4 = size(str2num(tC(4,:)),2);
                    wC5 = size(str2num(tC(5,:)),2);
                    wC6 = size(str2num(tC(6,:)),2);
                end

                Cond1 = wC1==6 & wC2==6 & wC3==6 & wC4==6 & wC5==6 & wC6==6;
                Cond2 = wC1==1 & wC2==2 & wC3==3 & wC4==4 & wC5==5 & wC6==6;
                Cond3 = wC1==6 & wC2==5 & wC3==4 & wC4==3 & wC5==2 & wC6==1;
                if Cond1 || Cond2 || Cond3
                    Re = true;
                else
                    Re = false;
                    msgbox({'The elastic constant matrix must be a 6×6 symmetric matrix in full or in triangular form (upper or lower).','Please supplement and try again.'}, 'VELAS reminder','error');
                end
            else
                wC = length(str2num(C));
                switch(wC)
                    case {2,3,5,6,7,9,13,21}
                        Re = true;
                    otherwise
                        Re = false;
                        msgbox({'The elastic constant matrix must be 1 * m (m ≤ 21), m should be one of [2,3,5,6,7,9,13,21].','Please supplement and try again.'}, 'VELAS reminder','error');
                end
            end
        case 6
            wC1 = size(str2num(C(1,:)),2);
            wC2 = size(str2num(C(2,:)),2);
            wC3 = size(str2num(C(3,:)),2);
            wC4 = size(str2num(C(4,:)),2);
            wC5 = size(str2num(C(5,:)),2);
            wC6 = size(str2num(C(6,:)),2);
            Cond1 = wC1==6 & wC2==6 & wC3==6 & wC4==6 & wC5==6 & wC6==6;
            Cond2 = wC1==1 & wC2==2 & wC3==3 & wC4==4 & wC5==5 & wC6==6;
            Cond3 = wC1==6 & wC2==5 & wC3==4 & wC4==3 & wC5==2 & wC6==1;
            if Cond1 || Cond2 || Cond3
                Re = true;
            else
                Re = false;
                msgbox({'The elastic constant matrix must be a 6×6 symmetric matrix in full or in triangular form (upper or lower).','Please supplement and try again.'}, 'VELAS reminder','error');
            end
        otherwise
            Re = false;
            msgbox({'The elastic constant matrix must be 1 * m (m ≤ 21), 6×6 symmetric matrix in full or in triangular form (upper or lower).','Please supplement and try again.'}, 'VELAS reminder','error');
    end
else
    Re = false;
    msgbox({'The elastic constant matrix cannot be empty.','Please supplement and try again.'}, 'VELAS reminder','error');
end