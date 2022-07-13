function [Re,TP,hkl] = maxminSearch(x0,fun,teps)

%{
   ========================= max or min search ==============================
    Input parameter: 
                      x0, Initial value of optimization function fun.
                      fun, optimization function
                      teps, the difference between a number and 0 or 1, if less than or equal to teps, it is considered to be equal to 0 or 1.
    Out parameter: 
                      Re, return minimum. 
                      TP, angle corresponding to minimum value
                      hkl, direction of minimum value. 
%}

len = size(x0,1);
TP = zeros(size(x0));
Re = zeros(len,1);

for k = 1:len
    options = optimset('TolFun',1e-8,'TolX',1e-8);
    TP(k,:) = fminsearch(fun,x0(k,:),options);
    Re(k,:) = fun(TP(k,:));
end
if size(TP,2) == 2
    hkl   = dir2Vec(TP(:,1), TP(:,2));
    hkl   = set2zeros(hkl,teps);
    TP    = set2zeros(TP,teps);
    hkl   = set2ones(hkl,teps);
else
    hkl   = [];
end


