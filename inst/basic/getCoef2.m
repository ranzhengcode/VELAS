function [v11,v12,v13,v22,v23,v33] = getCoef2(v1,v2,v3)

% Combination of coefficient of v

v11   = v1.*v1;
v12   = v1.*v2;
v13   = v1.*v3;
v22   = v2.*v2;
v23   = v2.*v3;
v33   = v3.*v3;