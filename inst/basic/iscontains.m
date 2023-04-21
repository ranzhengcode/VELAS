function re = iscontains(A,B)

if isempty(strfind(A,B))
    re = false;
else
    re = true;
end