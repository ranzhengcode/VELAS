function [nC,mLegel] = checkCS(C,val)

mLegel = false;
nC     = zeros(6,6);
if ~isempty(C)
    hC = size(C,1);
    switch(hC)
        case 1
            wC = length(C{1,1});
            switch(wC)
                case {2,3,5,6,7,9,13,21}
                    mLegel = true;
                    C = C{1,1};
                    switch(val)
                        case 2
                            % 3 independent elastic constants: C11, C44, C12;
                            nC(1,1) = C(1);
                            nC(1,2) = C(3);
                            nC(4,4) = C(2);
                            nC(2,2)=nC(1,1);
                            nC(3,3)=nC(1,1);
                            nC(5,5)=nC(4,4);
                            nC(6,6)=nC(4,4);
                            nC(1,3)=nC(1,2);
                            nC(2,3)=nC(1,2);
                            % Constructing symmetric matrix
                            nC = nC+triu(nC,1)';
                        case 3
                            % 5 independent elastic constants: C11, C33, C44, C12, C13
                            nC(1,1) = C(1);
                            nC(1,2) = C(4);
                            nC(1,3) = C(5);
                            nC(3,3) = C(2);
                            nC(4,4) = C(3);
                            nC(5,5) = nC(4,4);
                            nC(6,6) = (nC(1,1)-nC(1,2))/2;
                            nC(2,2) = nC(1,1);
                            nC(2,3) = nC(1,3);
                            % Constructing symmetric matrix
                            nC = nC + triu(nC,1)';
                        case 4
                            % tpye1: 6 independent elastic constants: C11, C33, C44, C66, C12, C13
                            % tpye2: 7 independent elastic constants: C11, C33, C44, C66, C12, C13, C16
                            len = length(C);
                            switch(len)
                                case 6
                                    nC(1,1) = C(1);
                                    nC(3,3) = C(2);
                                    nC(4,4) = C(3);
                                    nC(6,6) = C(4);
                                    nC(1,2) = C(5);
                                    nC(1,3) = C(6);
                                    nC(2,2) = nC(1,1);
                                    nC(2,3) = nC(1,3);
                                    nC(5,5) = nC(4,4);
                                case 7
                                    nC(1,1) = C(1);
                                    nC(3,3) = C(2);
                                    nC(4,4) = C(3);
                                    nC(6,6) = C(4);
                                    nC(1,2) = C(5);
                                    nC(1,3) = C(6);
                                    nC(1,6) = C(7);
                                    nC(2,2) = nC(1,1);
                                    nC(2,3) = nC(1,3);
                                    nC(3,2) = nC(1,3);
                                    nC(5,5) = nC(4,4);
                                    nC(2,6) = -nC(1,6);
                            end
                            % Constructing symmetric matrix
                            nC = nC + triu(nC,1)';
                        case 5
                            % type1: 6 independent elastic constants: C11, C33, C44, C12, C13, C14
                            % type2: 7 independent elastic constants: C11, C33, C44, C12, C13, C14, C15
                            len = length(C);
                            switch(len)
                                case 6
                                    nC(1,1) = C(1);
                                    nC(1,2) = C(4);
                                    nC(1,3) = C(5);
                                    nC(1,4) = C(6);
                                    nC(3,3) = C(2);
                                    nC(4,4) = C(3);
                                    nC(2,2) = nC(1,1);
                                    nC(2,3) = nC(1,3);
                                    nC(5,5) = nC(4,4);
                                    nC(6,6) = (nC(1,1)-nC(1,2))/2;
                                    nC(2,4) = -nC(1,4);
                                    nC(5,6) = nC(1,4);
                                case 7
                                    nC(1,1) = C(1);
                                    nC(1,2) = C(4);
                                    nC(1,3) = C(5);
                                    nC(1,4) = C(6);
                                    nC(1,5) = C(7);
                                    nC(2,2) = nC(1,1);
                                    nC(3,3) = C(2);
                                    nC(4,4) = C(3);
                                    nC(5,5) = nC(4,4);
                                    nC(6,6) = (nC(1,1)-nC(1,2))./2;
                                    nC(2,3) = nC(1,3);
                                    nC(2,4) = -nC(1,4);
                                    nC(2,5) = -nC(1,5);
                                    nC(4,6) = nC(2,5);
                                    nC(5,6) = nC(1,4);
                            end
                            % Constructing symmetric matrix
                            nC = nC + triu(nC,1)';
                        case 6
                            % 9 independent elastic constants: C11, C22, C33, C44, C55, C66, C12, C13, C23
                            nC(1,1) = C(1);
                            nC(1,2) = C(7);
                            nC(1,3) = C(8);
                            nC(2,2) = C(2);
                            nC(2,3) = C(9);
                            nC(3,3) = C(3);
                            nC(4,4) = C(4);
                            nC(5,5) = C(5);
                            nC(6,6) = C(6);
                            % Constructing symmetric matrix
                            nC = nC + triu(nC,1)';
                        case 7
                            %{
                            type1: 13 independent elastic constants: C11, C22, C33, C44, C55, C66, C12, C13, C15, C23, C25, C35, C46
                            type2: 13 independent elastic constants: C11, C22, C33, C44, C55, C66, C12, C13, C16, C23, C26, C36, C45
                            %}
                            switch(monoType)
                                case 1
                                    nC(1,1) = C(1);
                                    nC(2,2) = C(2);
                                    nC(3,3) = C(3);
                                    nC(4,4) = C(4);
                                    nC(5,5) = C(5);
                                    nC(6,6) = C(6);
                                    nC(1,2) = C(7);
                                    nC(1,3) = C(8);
                                    nC(1,5) = C(9);
                                    nC(2,3) = C(10);
                                    nC(2,5) = C(11);
                                    nC(3,5) = C(12);
                                    nC(4,6) = C(13);
                                case 2
                                    nC(1,1) = C(1);
                                    nC(2,2) = C(2);
                                    nC(3,3) = C(3);
                                    nC(4,4) = C(4);
                                    nC(5,5) = C(5);
                                    nC(6,6) = C(6);
                                    nC(1,2) = C(7);
                                    nC(1,3) = C(8);
                                    nC(1,6) = C(9);
                                    nC(2,3) = C(10);
                                    nC(2,6) = C(11);
                                    nC(3,6) = C(12);
                                    nC(4,5) = C(13);
                            end
                            % Constructing symmetric matrix
                            nC = nC + triu(nC,1)';
                        case 8
                            %{
                            21 independent elastic constants: C11, C12, C13, C14, C15, C16,
                                                                   C22, C23, C24, C25, C26,
                                                                        C33, C34, C35, C36,
                                                                             C44, C45, C46,
                                                                                  C55, C56,
                                                                                       C66
                            %}
                            nC(1,1) = C(1);
                            nC(1,2) = C(2);
                            nC(1,3) = C(3);
                            nC(1,4) = C(4);
                            nC(1,5) = C(5);
                            nC(1,6) = C(6);
                            nC(2,2) = C(7);
                            nC(2,3) = C(8);
                            nC(2,4) = C(9);
                            nC(2,5) = C(10);
                            nC(2,6) = C(11);
                            nC(3,3) = C(12);
                            nC(3,4) = C(13);
                            nC(3,5) = C(14);
                            nC(3,6) = C(15);
                            nC(4,4) = C(16);
                            nC(4,5) = C(17);
                            nC(4,6) = C(18);
                            nC(5,5) = C(19);
                            nC(5,5) = C(20);
                            nC(6,6) = C(21);
                            % Constructing symmetric matrix
                            nC = nC + triu(nC,1)';
                        case 9
                            % 2 independent elastic constants: C11, C12;
                            nC(1,1) = C(1);
                            nC(1,2) = C(3);

                            nC(2,2) = nC(1,1);
                            nC(3,3) = nC(1,1);
                            nC(4,4) = (nC(1,1)-nC(1,2))/2;
                            nC(5,5) = nC(4,4);
                            nC(6,6) = nC(4,4);
                            nC(1,3) = nC(1,2);
                            nC(2,3) = nC(1,2);
                            % Constructing symmetric matrix
                            nC = nC+triu(nC,1)';
                    end
                otherwise
                    nC = [];
                    msgbox({'The elastic constant matrix must be 1×m (m ≤ 21), m should be one of [2,3,5,6,7,9,13,21].','Please supplement and try again.'}, 'VELAS reminder','error');
            end
        case 6
            wC1 = size(C{1},2);
            wC2 = size(C{2},2);
            wC3 = size(C{3},2);
            wC4 = size(C{4},2);
            wC5 = size(C{5},2);
            wC6 = size(C{6},2);
            Cond1 = wC1==6 & wC2==6 & wC3==6 & wC4==6 & wC5==6 & wC6==6;
            Cond2 = wC1==1 & wC2==2 & wC3==3 & wC4==4 & wC5==5 & wC6==6;
            Cond3 = wC1==6 & wC2==5 & wC3==4 & wC4==3 & wC5==2 & wC6==1;

            if Cond1 || Cond2 || Cond3
                mLegel = true;
                if Cond1
                    nC = cell2mat(C);
                end

                if Cond2
                    for k =1:6
                        nC(k,1:k) =  C{k};
                    end
                    % Constructing symmetric matrix
                    nC = nC + tril(nC,-1)';
                end

                if Cond3
                    for k =1:6
                        nC(k,k:end) =  C{k};
                    end
                    % Constructing symmetric matrix
                    nC = nC + triu(nC,1)';
                end
            else
                nC = [];
                msgbox({'The elastic constant matrix must be a 6×6 symmetric matrix in full or in triangular form (upper or lower).','Please supplement and try again.'}, 'VELAS reminder','error');
            end
        otherwise
            nC = [];
            msgbox({'The elastic constant matrix must be 1 * m (m ≤ 21), 6×6 symmetric matrix in full or in triangular form (upper or lower).','Please supplement and try again.'}, 'VELAS reminder','error');
    end
else
    nC = [];
    msgbox({'The elastic constant matrix cannot be empty.','Please supplement and try again.'}, 'VELAS reminder','error');
end